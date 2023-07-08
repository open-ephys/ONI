.. default-domain:: c

.. _oni.h:

oni.h
#######################################

Version Macros
--------------------------------------
See https://semver.org/ for a complete explanation of these macro definitions.

.. macro:: ONI_VERSION_MAJOR

    MAJOR version for incompatible API changes

.. macro:: ONI_VERSION_MINOR

    MINOR version for added functionality that is backwards compatible

.. macro:: ONI_VERSION_PATCH

    PATCH version for backwards compatible bug fixes

.. macro:: ONI_MAKE_VERSION(major, minor, patch)

    Defined as

    .. code-block:: c

        MAJOR * 10000 + MINOR * 100 + PATCH

    Provides compile-time access to the API version.

.. macro:: ONI_VERSION

    Compile-time API version. Defined as

    .. code-block:: c

        ONI_MAKE_VERSION(ONI_VERSION_MAJOR ONI_VERSION_MINOR, ONI_VERSION_PATCH).

.. _oni_h_acquisition_context:

Acquisition Context
---------------------------------------

.. type:: struct oni_ctx_impl *oni_ctx

    An ONI-compliant acquisition context implementation. :type:`oni_ctx` is an
    opaque handle to a structure which manages hardware state.

    .. attention:: Context details are hidden in the implementation file
        (``oni.c``). Direct manipulation of :type:`oni_ctx` data members is never
        nessesary or correct.

    Each :type:`oni_ctx` instance manages the device driver, device table, read
    and write buffers, acquisition run state, etc. Following a hardware reset,
    which is triggered either by a call to :func:`oni_init_ctx` or
    :func:`oni_set_opt` using the :macro:`ONI_OPT_RESET` context option, the
    context run state is set to ``UNINTIALIZED`` and the device table is pushed
    onto the host signal stream by the host hardware as `COBS
    <https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing>`_-encoded
    packets. On the signal stream, the device table is organized as follows,

    .. code-block:: none

        ... | DEVICEMAPACK, uint32_t num_devices | DEVICEINST, oni_device_t dev_0
            | DEVICEINST, oni_device_t dev_1 | ... | DEVICEINST, oni_device_t dev_n
            | ...

    where "|" represents a packet delimiter. During a call to
    :func:`oni_init_ctx`, the device table is decoded from the signal stream.
    It can then be examined using calls to :func:`oni_get_opt` using the
    :macro:`ONI_OPT_DEVICETABLE` option.  After the device table is received,
    the context run state becomes ``IDLE``. A call to :func:`oni_set_opt` with
    the :macro:`ONI_OPT_RUNNING` option can then be used to start acquisition
    uy transitioning the context run state to ``RUNNING``.

.. _oni_h_device:

Device
---------------------------------------
.. struct:: oni_device_t

    .. member:: oni_size_t idx

        Fully qualified **RSV.RSV.HUB.IDX** device table index.

        :RSV: 8-bit unsigned integer (reserved)
        :HUB: 8-bit unsigned integer indicating the hub index
        :IDX: 8-bit unsigned integer indicating the device index

    .. member:: oni_dev_id_t id

        Device ID number (see :ref:`onix.h` for ONIX-specific definitions)

    .. member:: oni_size_t read_size

        Device data read size per frame in bytes

    .. member:: oni_size_t write_size

        Device data write size per frame in bytes

    An ONI-compliant device implementation. An :struct:`oni_device_t` describes
    one of potentially many pieces of hardware managed by an :type:`oni_ctx`.
    Examples of individual devices might include ephys chips, IMUs, optical
    stimulators, camera sensors, etc.

    .. tip:: Look at device index defintions in :ref:`onix.h` to see available
        ONIX-specific device definitions and enum ranges that will not interfere with
        ONIX for custom or closed-source projects.

    A device table is read from hardware and stored in the current context via
    a call to :func:`oni_init_ctx`. This table can be examined via calls to
    :func:`oni_get_opt` using the :macro:`ONI_OPT_DEVICETABLE` option.

.. _oni_h_frame:

Frame
---------------------------------------
.. struct:: oni_frame_t

    .. member:: const oni_fifo_time_t time

        Frame time (:macro:`ONI_OPT_ACQCLKHZ` host clock counter)

    .. member:: const oni_fifo_dat_t dev_idx

        Device index that produced or accepts the frame

    .. member:: const oni_fifo_dat_t data_sz

        Size of data in bytes

    .. member:: uint8_t *data

        Raw data block. This pointer is a zero-copy "view" into a private,
        referenced-counted buffer managed by the acquisition context.  The
        handle to this buffer is hidden by the API using some C ``union``
        magic.

    An ONI-compliant data frame implementation. :struct:`oni_frame_t`'s are
    produced by calls to :func:`oni_read_frame` and consumed by calls to
    :func:`oni_write_frame`.

    .. seealso::

        :func:`oni_create_frame`
            Create frames for use with :func:`oni_write_frame`.
        :func:`oni_write_frame`
            Write frames to hardware.
        :func:`oni_read_frame`
            Read frames from hardware.
        :func:`oni_destroy_frame`
            Free a frame and underlying resources allocated by
            :func:`oni_create_frame` or :func:`oni_read_frame`.

.. _oni_h_functions:

Functions
--------------------------------------------
The functions in :ref:`oni.h` form the basis of the API and are all that is
needed during the development of user-facing software.

.. alias:: oni_create_ctx
           oni_init_ctx
           oni_destroy_ctx
           oni_get_opt
           oni_set_opt
           oni_get_driver_opt
           oni_set_driver_opt
           oni_read_reg
           oni_write_reg
           oni_read_frame
           oni_create_frame
           oni_write_frame
           oni_destroy_frame
           oni_version
           oni_error_str

.. function:: oni_ctx oni_create_ctx(const char *drv_name)

    Creates an acquisition context, :type:`oni_ctx`, which is an opaque handle
    to a structure that manages device drivers, the device table, data
    streaming, memory management, etc. On success the selected driver is loaded
    and an :type:`oni_ctx` is allocated and created, and its handle is passed
    to the user.  Many API functions take a :type:`oni_ctx` as a first
    agrument.

    :param drv_name: A string specifying the device driver used by
        the context to control hardware. This string corresponds a compiled
        implementation of :ref:`onidriver.h` that has the name
        ``libonidriver_<drv_name>.<so/dll>``. If this library is not on the
        dynamic library search path, the function will error.
    :return: An opaque handle to the newly created context if
        successful. Otherwise it shall return ``NULL`` and set ``errno`` to
        ``EAGAIN``.
    :example: See :ref:`liboni_example_ctx_creation`

    .. seealso::

        :func:`oni_get_opt`
            Inspect :type:`oni_ctx` state
        :func:`oni_set_opt`
            Modify :type:`oni_ctx` state

.. function:: int oni_init_ctx(oni_ctx ctx, int host_idx)

    Initialize an acquisition context. This function initializes the selected
    device driver, opens all communication channels, and acquires a device
    table that maps out the device control and streaming hierarchy.
    Specifically, during a successful call to :func:`oni_init_ctx`, the
    following events occur:

    #. All required data streams are opened.
    #. A hardware reset issued using :macro:`ONI_OPT_RESET`
    #. A device table is obtained from the hardware.
    #. The minimal :macro:`ONI_OPT_BLOCKREADSIZE` and
       :macro:`ONI_OPT_BLOCKWRITESIZE` values are calculated and
       stored.
    #. The context run state is moved from ``UNINITIALIZED`` to ``IDLE``.

    :param ctx: The acquisition context to be initialized
    :param host_idx: The index of the hardware we are going to
        manage using the initialized context and driver. A value of -1 will
        attempt to open the default host index and is useful if there is only a
        single ONIX host managed by driver selected in :func:`oni_create_ctx`
    :return: 0 on success otherwise see :ref:`onidef_error_codes`.
    :example: See :ref:`liboni_example_ctx_creation`

.. function:: int oni_destroy_ctx(oni_ctx ctx)

    Terminate a context and free bound resources. During context destruction,
    all resources allocated by :func:`oni_create_ctx` and :func:`oni_init_ctx`
    are freed. This function can be called from any context run state. When
    called, an interrupt signal (TODO: Which?) is raised and any blocking
    operations will return immediately. Attached resources (device drivers,
    data buffers, etc.) are closed and their resources freed.

    :param ctx: The acquisition context to close.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`.
    :example: See :ref:`liboni_example_ctx_destruction`

.. function:: int oni_get_opt(oni_ctx ctx, int option, void *value, size_t *size)

    Retrieves the option specified by the ``option`` argument within the
    acquisition context ``ctx`` and stores it in the ``value`` buffer. The
    ``size`` provides a pointer to the size of the ``value`` buffer, in bytes.
    Upon successful completion :func:`oni_get_opt` modifies the value pointed to by
    ``size`` to indicate the actual size of the option value stored in the
    buffer. If the value pointed to by size is too small to store the value,
    the function will error. Additionally, some context options are write-only
    and others can only be read in certain acquisition states. If these
    constraints are disobeyed, the function will error. See
    :ref:`onidef_context_options` for a description of each possible
    ``option``, including access constraints.

    :param ctx: :type:`oni_ctx` context to read an option from
    :param option: Selected option to read. See :ref:`onidef_context_options`
        for valid options.
    :param value: buffer to store value of ``option`` after it is read
    :param size: Pointer to the size of ``value`` buffer (including terminating
        null character, if applicable) in bytes.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`.
    :example: See :ref:`liboni_example_device_table` and
        :ref:`liboni_example_set_buffers`

    .. seealso::
        :ref:`onidef_context_options`
            Valid context options with access and type specifications.

.. function:: int oni_set_opt(oni_ctx ctx, int option, const void *value, size_t size)

    Sets the option specified by the ``option`` argument within the acquisition
    context ``ctx`` to the contents of the  ``value`` buffer. The ``size``
    indicates the size of the ``value`` buffer, in bytes.  Upon successful
    completion, :func:`oni_set_opt` modifies the value pointed to by ``size``
    to indicate the actual size of the option value stored in the functions
    will error. Additionally, some context options are read-only and others can
    only be written in certain acquisition states. If these constraints are
    disobeyed, the function will error. See :ref:`onidef_context_options` for
    description of each possible ``option``, including access constraints.

    :param ctx: :type:`oni_ctx` context to read an option from
    :param option: Selected option to set. See :ref:`onidef_context_options`
        for valid options.
    :param value: buffer containing data to be written to ``option``
    :param size: Size of ``value`` buffer (including terminating null
        character, if applicable) in bytes.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_device_table` and :ref:`liboni_example_set_buffers`

    .. seealso::
        :ref:`onidef_context_options`
            Valid context options with access and type specifications.

.. function:: int oni_get_driver_opt(const oni_ctx ctx, int drv_opt, void* value, size_t *size)

    .. todo:: Document

.. function:: int oni_set_driver_opt(oni_ctx ctx, int drv_opt, const void* value, size_t size)

    .. todo:: Document

.. function:: int oni_read_reg(const oni_ctx ctx, oni_dev_idx_t dev_idx, oni_reg_addr_t addr, oni_reg_val_t *value)

    Read the value of a configuration register from a specific device within the
    current device table. This can be used to verify the success of calls to
    :func:`oni_write_reg` or to obtain state information about devices managed
    by the current acquisition context. Register specifications (addresses,
    read- and write-access, and descriptions are provided on the :ref:`ONI-device
    datasheet <dev-datasheet>`).

    :param ctx: :type:`oni_ctx` context that manages the requested device
    :param dev_idx: fully-qualifies device index within the device table
    :param addr: Address of register to be read
    :param value: Pointer to an unsigned integer that will store the value
        of the register at ``addr`` on ``dev_idx``.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_read_write_reg`

.. function:: int oni_write_reg(const oni_ctx ctx, oni_dev_idx_t dev_idx, oni_reg_addr_t addr, oni_reg_val_t value)

    Change the value of a configuration register from specific devices within
    the current device table. This can be used to change the functionality of
    devices, e.g. set filter bandwidth, select active channels, or change
    stimulation parameters).  Register specifications (addresses, read- and
    write-access, acceptable values, and descriptions are provided on the
    :ref:`ONI-device datasheet <dev-datasheet>`).

    :param ctx: :type:`oni_ctx` context that manages the requested device
    :param dev_idx: fully-qualified device index within the device table
    :param addr: Address of register to be read
    :param value: Value to write to the register at ``addr`` on ``dev_idx``.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_read_write_reg`

.. function:: int oni_read_frame(const oni_ctx ctx, oni_frame_t **frame)

    Read high-bandwidth data from the data input channel.
    :func:`oni_read_frame` allocates host memory and populates it with a single
    :struct:`oni_frame_t` struct using the data input stream. This call will
    block until either enough data available on the stream to construct an
    underlying block buffer (see :macro:ONI_OPT_BLOCKREADSIZE and
    :ref:`liboni_example_set_buffers`). :struct:`oni_frame_t`'s created during
    calls to :func:`oni_read_frame` are zero-copy views into this buffer.

    .. attention:: It is the user's responsibility to free the resources allocated by
        this call by passing the resulting frame pointer to
        :func:`oni_destroy_frame`

    :param ctx: :type:`oni_ctx` context that manages the high-bandwidth input
        channel that the frame will be read from
    :param frame: NULL pointer to reference using internal memory
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_read_frame`

.. function:: int oni_create_frame(const oni_ctx ctx, oni_frame_t **frame, oni_dev_idx_t dev_idx, void* data, size_t data_sz)

    Create an :oni_frame_t` for consumption by :func:`oni_write_frame`.

    .. attention:: It is the user's responsibility to free the resources allocated by
        this call by passing the resulting frame pointer to
        :func:`oni_destroy_frame`

    :param ctx: :type:`oni_ctx` context that manages the high-bandwidth output
        channel that the frame will be written through
    :param frame: NULL pointer to reference using internal memory
    :param dev_idx: fully-qualified device index within the device table that
        the frame will be written to.
    :param data: Raw data block to be copied into the frame.
    :param data_sz: Size of ``data`` in byes.
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_write_frame`

    .. attention:: ``data_sz`` Must be

        #. An integer multiple of the selected ``dev_idx``'s write size as
           indicated within the device table
        #. Smaller than the internal write block memory size (see
           :macro:`ONI_OPT_BLOCKWRITESIZE` and :ref:`liboni_example_set_buffers`)

.. function:: int oni_write_frame(const oni_ctx ctx, const oni_frame_t *frame)

    Write an :struct:`oni_frame_t` to a particular device within the device
    table using the high-bandwidth output channel.

    :param ctx: :type:`oni_ctx` context that manages the high-bandwidth output
        channel that the frame will be written through
    :param frame: Pointer to frame created duing a call to :func:`oni_create_frame`
    :return: 0 on success otherwise see :ref:`onidef_error_codes`
    :example: See :ref:`liboni_example_write_frame`

    .. tip:: Frames created by using :func:`oni_create_frame` can be written to
        a device multiple times by using them as input arguments to
        :func:`oni_write_frame` multiple times. This allows pre-allocation of
        frame resources from improved latency and determinism in closed-loop
        applications.

.. function:: void oni_destroy_frame(oni_frame_t *frame)

    .. note:: Each call to :func:`oni_create_frame` or :func:`oni_read_frame`
        must matched by a  call to :func:`oni_destroy_frame` to prevent memory
        leaks.

.. function:: void oni_version(int *major, int *minor, int *patch)

    Report the liboni library version. This library uses `Semantic Versioning
    <https://semver.org/>`_. Briefly, the major revision is for incompatible API
    changes. Minor version is for backwards compatible changes. The patch
    number is for backwards-compatible bug fixes. When this function returns,
    input pointers will reference the library's version.

    :param major: major library version for incompatible API changes
    :param minor: minor library version for backwards compatible changes.
    :param patch: patch number for backwards-compatible bug fixes.

.. function:: oni_driver_info_t* oni_get_driver_info(const oni_ctx ctx)

    Reports a :ref:`oni_driver_info_t` structure containing the name of the
    driver translator loaded for a given context as well as its semantic versioning
    version.

    :param ctx: :type:`oni_ctx` context of which the loaded driver translator information
        will be reported
    :return: A pointer to a constant structure containing the driver translator information

.. function:: const char *oni_error_str(int err)

    Convert a return code (see :ref:`onidef_error_codes`) into a human readable
    string.

    :param err: The error code to convert
