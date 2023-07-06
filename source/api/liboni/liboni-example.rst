.. default-domain:: c

.. _liboni_example:

Examples
##########################################
The following examples demonstrate common uses of ``liboni``. They generally
omit checking return codes, which should be done when the library is used in
for real world applications. For instance:

.. code-block:: c

    int rc = oni_function(...);
    if (rc) goto fail;

.. _liboni_example_ctx_creation:

Acquisition Context Creation
*****************************************
Every piece of ONI-complaint host hardware (occupying a single PCIe slot, USB
port, etc) is governed by an acquisition context. Contexts are fully described
by two parameters: a string specifying the hardware driver and an integer
specifying which slot the physical hardware occupies on the host computer.
Context creation and initialization occurs in two function calls.
:func:`oni_create_ctx` allocates API-internal resources to hold context state and
returns a handle to the context. :func:`oni_init_ctx` loads the required driver,
attempts to connect to the hardware (open communication channels), and,
finally, obtain a device table that maps the acquisition hierarchy governed by
the context. So, for instance, to create an initialize an acquisition context
to govern a PCIe acquisition card using the `RIFFA
<https://github.com/KastnerRG/riffa>`_ driver, you would use

.. code-block:: c

    ctx = oni_create_ctx("riffa"); // "riffa" is the driver name
    oni_init_ctx(ctx, 0); // 0 is the host index. You can use -1 to get default slot

If the driver translation library ``onilibrary_<drv_name>.<so/dll>`` cannot be
found by the linker, or the driver finds that the requested index is vacant,
this function will error. Otherwise, it will allocate the required resources to
manage the hardware at the specified host index using the specified driver.

.. note:: Specifying a host index of -1 will open the default slot and is
    useful in cases where there is only on piece of acquisition hardware in the
    host computer (e.g. a single PCIe card).

When multiple pieces of host hardware exist on a single host (e.g. multiple
PCIe cards), a new context must be created and initialization to manage each
one. In some cases (e.g. multiple PCIe cards in a single computer), these
contexts can be synchronized so that each host receiver board shares a common
hardware clock and acquisition trigger (see :ref:`sync_ctx` for an example).
This is not always possible. For instance, multiple USB hosts cannot be
synchronized.

.. attention:: :func:`oni_init_ctx` cannot be called on a previously
    initialized context.  Doing so will return an error.

If the device configuration is changed following context initialization (e.g. a
headstage is plugged in or turned on), a context reset must be issued which to
instruct the initialized context to re-evaluate its device table. This can be
done via

.. code-block:: c

    oni_size_t reset = 1;
    oni_set_opt(ctx, ONI_OPT_RESET, &reset, sizeof(reset));

.. _liboni_example_ctx_destruction:

Closing an Acquisition Context
********************************************
When an acquisition context is no longer needed, it must be disposed to prevent
memory leaks. This is accomplished via

.. code-block:: c

    oni_destroy_ctx(ctx);

which will free all resources used by the API and underlying device driver and
close system-level descriptors providing links to hardware.

.. _liboni_example_device_table:

Examining the Device Table
********************************************
Following context initialization or reset, it is useful to examine the device
table to see the devices that host has access to. To examine the device table,
we query the context for the number of devices in the table, allocate enough
space to hold the table, and then populate it:

.. code-block:: c

    oni_size_t num_devs;
    size_t num_devs_sz = sizeof(num_devs);
    oni_get_opt(ctx, ONI_OPT_NUMDEVICES, &num_devs, &num_devs_sz);

    size_t devices_sz = sizeof(oni_device_t) * num_devs;
    oni_device_t *devices = malloc(devices, devices_sz);
    oni_get_opt(ctx, ONI_OPT_DEVICETABLE, devices, &devices_sz);

This will return an array of ``oni_device_t`` structs where ``oni_device_t`` is
defined as:

.. code-block:: c

    typedef struct {
        oni_size_t idx;           // Complete rsv.rsv.hub.idx device table index
        oni_dev_id_t id;          // Device ID number (see oedevices.h)
        oni_size_t read_size;     // Device data read size per frame in bytes
        oni_size_t write_size;    // Device data write size per frame in bytes

    } oni_device_t;

.. attention:: ``device_t.idx`` is the fully qualified address (hub.index) of a
    device within the acquisition hierarchy. Do not expect these values to increase
    linearly with the position in array returned when querying the device table as
    some bit ranges are used to specifiy the hub address.

.. _liboni_example_read_write_reg:

Reading and Writing Device Registers
********************************************
It is often necessary to inspect and configure devices prior to or during
acquisition. As described in the ONI specification, a device is a leaf element
in the device table with *at least* the following properties:

#. Its own register address space
#. Register access through a standardized register programming interface
#. A datasheet that describes access to these registers

Device registers can be read as follows:

.. code-block:: c

    oni_reg_val_t val = 0;
    oni_read_reg(ctx, dev_idx, addr, &val);

Here, ``dev_idx`` is the fully specified device table index (hub.index) found
in the device table, ``addr`` is the register address as specified within the
ONI device datasheet. Because this is a register read, ``val`` is just a
pointer to a register to be filled during the read. This function will return
an error if the context is in an inappropriate state (e.g. not initialized),
the specified device is not in the device table, or the register is write-only.
Registers can be written as follows:

.. code-block:: c

    oni_reg_val_t val = 42;
    oni_write_reg(ctx, dev_idx, addr, val);

where the function arguments have the same definitions as ``oni_read_reg``.
This function will return an error if the context is in an inappropriate state,
the device does not exist in the device table, or the register is read-only.

.. _liboni_example_set_buffers:

Setting Read and Write Buffer Sizes
********************************************
After context initialization, the internal read and write buffers can be
manually specified. These buffers exist in order to reduce copying.

- During a called ``oni_read_frame``, the read buffer is checked to see if it
  contains data. If so, the return frame is simply a zero-copy "view" into this
  memory.  If not, a block read is performed to fill the buffer, and again, the
  frame is a view into the beginning of this newly allocated block.
- During a call to ``oni_create_frame``, a very similar process occurs in the
  opposite direction, using the write buffer. Write frames are views into a
  pre-allocated memory block.

The size of these buffers dictates a trade off between response bandwidth and
latency, especially during frame reads. In the case of reads, smaller buffers
will be filled faster by the hardware and allow access to data that is closer
in time to its physical creation. However, smaller buffers increase the memory
allocation rate and decrease the maximum bandwidth of the read link.

For this reason, we have chosen to make the read and write buffer size easily
tunable by the user to optimize for different computer capabilities, data
bandwidths, and required response latencies. The buffer sizes default to the
minimum size for a given device table (the maximum frame read and write sizes
across devices int the table aligned to the bus width of hardware communication
link). This provides the lowest latency, but is optimal only for very low
bandwidth acquisition and deterministic and low-latency threads (e.g. those
found on real-time operating system). On a normal computer, these buffers can
be set manually to optimize the bandwidth/latency trade off. For example, to
set the buffer read and write sizes to 1024 and 8192 bytes respectively, use
``oni_set_opt``:

.. code-block:: c

    oni_size_t block_size = 1024;
    size_t block_size_sz = sizeof(block_size);
    oni_set_opt(ctx, ONI_OPT_BLOCKREADSIZE, &block_size, block_size_sz);

    block_size = 8192;
    block_size_sz = sizeof(block_size);
    oni_set_opt(ctx, ONI_OPT_BLOCKWRITESIZE, &block_size, block_size_sz);

If you attempt to set the buffer size to less than the minimal required in a
particular context, these functions will return an error. To examine the buffer
sizes, use ``oni_get_opt`` as follows

.. code-block:: c

    oni_size_t block_size;
    size_t block_size_sz = sizeof(block_size);

    oni_get_opt(ctx, ONI_OPT_BLOCKREADSIZE, &block_size, &block_size_sz);
    printf("Block read size: %u bytes\n", block_size);

    oni_get_opt(ctx, ONI_OPT_BLOCKWRITESIZE, &block_size, &block_size_sz);
    printf("Write pre-allocation size: %u bytes\n", block_size);

.. _start_ctx:

Starting Acquisition
********************************************
Prior to reading and writing to/from the high bandwidth data streams,
acquisition must be started. To do this, write 1 to the ``ONI_OPT_RUNNING``
context option:

.. code-block:: c

    reg = 1;
    oni_set_opt(ctx, ONI_OPT_RUNNING, &reg, sizeof(oni_size_t));

.. attention:: Following the start of data acqusition, hardware memory
    resources are used to queue incoming device data. To prevent buffer overflows,
    the user must issue calls to ``oni_read_frame`` fast enough to keep up with
    data production.

To reset the main system clock counter (frame timer) at any point during or
prior to starting acquisition, write 1 to the ``ONI_OPT_RESETACQCOUNTER``
context option:

.. code-block:: c

    reg = 1;
    oni_set_opt(ctx, ONI_OPT_RESETACQCOUNTER, &reg, sizeof(oni_size_t));

Often, the start of data acquisition should precisely co-occur with a clock
reset. To perform both a clock reset and acquisition start in perfect sync,
write 2 to the ``ONI_OPT_RESETACQCOUNTER`` context option:

.. code-block:: c

    reg = 2; // NOTE: this changed to 2 compared to previous example
    oni_set_opt(ctx, ONI_OPT_RESETACQCOUNTER, &reg, sizeof(oni_size_t));

This will reset the clock and automatically start acquisition (set
``ONI_OPT_RUNNING`` to 1).

.. _liboni_example_read_frame:

Reading Data Frames
********************************************
:struct:`oni_frame_t`'s are minimal packets containing metadata and raw binary
data blocks from a single device within the device table. A
:struct:`oni_size_t` is defined as

.. code-block:: c

    struct oni_frame {
        const uint64_t dev_idx;  // Device index that produced or accepts the frame
        const uint32_t data_sz;  // Size in bytes of data buffer
        const uint64_t time;     // Frame time (ACQCLKHZ)
        uint8_t *data;           // Raw data block
    };

where ``dev_idx`` is the fully qualified device index within the device table
(hub.index), ``data_sz`` is the size in bytes of the raw data block, ``time``
is the system clock count that indicates the frame creation time, and, ``data``
is a pointer to the raw data block. A single frames can be read from an
acquisition context after it is started (see :ref:`start_ctx`) using repeated
calls to ``oni_read_frame`` as follows:

.. code-block:: c

    // Read a frame
    oni_frame_t *frame = NULL;
    oni_read_frame(ctx, &frame);

    // Perform desired operations with frame

    // Dispose of frame
    oni_destroy_frame(frame);

In the preceding example, ``frame`` is initialized to ``NULL`` because a call
to ``oni_read_frame`` will assign its contents to an existing, pre-allocated
memory block (see :ref:`liboni_example_set_buffers`). ``oni_read_frame`` will
return an error if the acquisition context is in an inappropriate state (e.g.
not started). If the hardware is not producing frames, it will wait
indefinitely.

.. attention:: After acquisition is started, ``oni_read_frame`` must be called
    frequently enough such that hardware buffers do not overflow.

After they have been used, frames must be disposed using ``oni_destroy_frame``.

.. attention:: Every call to ``oni_read_frame`` must be matched by a call to
    ``oni_destroy_frame``. Not doing so will result in a memory leak.

.. _liboni_example_write_frame:

Writing Data Frames
********************************************
Writing frames to an appropriate device in the device table follows similar
steps to reading frames.

.. code-block:: c

    // Required elements to create frame
    oni_frame_t *frame = NULL;
    size_t dev_idx = 256;
    size_t data_sz = 8; // or 16, 24, 32, etc
    char data[] = {0, 1, 2, 3, 4, 5, 6, 7};

    // Create a frame
    oni_create_frame(ctx, &frame, dev_idx, data, data_sz);

    // Write the frame
    oni_write_frame(ctx, frame);

    // Dispose the frame
    oni_destroy_frame(frame);

First, a frame is created using a call to ``oni_create_frame`` (analogous to
``oni_read_frame``, except that frame data is provided by the user instead of
the hardware). In the preceding example, it is assumed that the user has
queried the device table to ensure that the device with qualified index 256 is
writable and has a write size of 8 bytes. If the device at ``dev_idx`` does not
accept writes or ``data``/``data_sz`` are not a multiple of the device write
size, then ``oni_create_frame`` will return an error.

.. note:: When calling ``oni_create_frame``, ``data``/``data_sz`` can be a
    multiple of the write size for a particular device. This way, a frame can be
    loaded with multiple data packets that are written to the device as quickly as
    the hardware and device driver permit.

.. warning:: Attempting to write multi-packet frames that are larger than
    :macro:`ONI_OPT_BLOCKWRITESIZE` will result in a error.

After a frame has been created, it can then be written to to hardware using
``oni_write_frame``. Just like frames produced by ``oni_read_frame``, frames
generated by ``oni_create_frame`` must be disposed of using
``oni_destroy_frame`` when the are no longer needed.

.. tip:: Frames created using ``oni_create_frame`` can be reused by re-writing
    their data field following a frame write

The following example shows a single frame being used for two writes with a
change in the data field in between writes:

.. code-block:: c

    // Required elements to create frame
    oni_frame_t *frame = NULL;
    size_t dev_idx = 256;
    size_t data_sz = 8; // or 16, 24, 32, etc
    char data[8] = {0, 1, 2, 3, 4, 5, 6, 7};

    // Create a frame
    oni_create_frame(ctx, &frame, dev_idx, data, data_sz);

    // Write the frame
    oni_write_frame(ctx, frame);

    // Reuse the same frame
    char new_data[8] = {8, 9, 10, 11, 12, 13, 14, 15};
    memcpy(frame->data, new_data, data_sz);

    // Write the frame with new_data
    oni_write_frame(ctx, frame);

    // Dispose the frame
    oni_destroy_frame(frame);

.. _sync_ctx:

Synchronizing Contexts
********************************************
.. todo:: Document.

..
    ## Test Programs (Linux Only)
    The [libonix-test](libonix-test) directory contains minimal working programs that use this library.

    1. `firmware` : Emulate hardware. Stream fake data over UNIX pipes (Linux only)
    1. `host` : Basic data acquisition loop. Communicate with `firmware` or actual
       hardware (Linux and Windows).
