.. _onidriver.h:
.. default-domain:: c

onidriver.h
#######################################
Definitions and function prototypes for implementing :ref:`drivers`.

.. _onidriver_types:

Constants and Types
-------------------------

.. enum:: oni_read_stream_t

    Represent the available data streams from the device to the host

    .. macro:: ONI_READ_STREAM_DATA

        (``0``)
        High-speed data stream to host

    .. macro:: ONI_READ_STREAM_SIGNAL

        (``1``)
        Low-speed signaling stream

.. enum:: oni_write_stream_t

    Represent the available data streams from the host to the device

    .. macro:: ONI_WRITE_STREAM_DATA

        (``0``)
        High-speed data stream from host

.. type:: void* oni_driver_ctx

    A handle to a driver translator context. Each driver creates its own
    context storing all state variables required for its functionality. This
    common type is used to interchange this context between the common API,
    which does not needed to know its contents, and the driver translator
    implementation.

.. _onidriver_h_functions:

Functions
------------------------
All driver translators must implement these functions. They are called
internally by the public interface decribed in :ref:`oni.h` and perform direct
hardware access as needed.

.. alias::  oni_driver_create_ctx
            oni_driver_destroy_ctx
            oni_driver_init
            oni_driver_read_stream
            oni_driver_write_stream
            oni_driver_read_config
            oni_driver_write_config
            oni_driver_set_opt_callback
            oni_driver_set_opt
            oni_driver_get_opt
            oni_driver_info

.. function:: oni_driver_ctx oni_driver_create_ctx()

    Creates the driver translator context.

    :return: A handle to the newly created internal context, if successful, ``NULL`` otherwise.

.. function:: int oni_driver_destroy_ctx(oni_driver_ctx driver_ctx)

    Destroys the driver translator context and frees its resources.

    :param driver_ctx: Handle to the open context to destroy

    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_init(oni_driver_ctx driver_ctx, int host_idx)

    Initializes a driver translator context opening a specific hardware instance.

    :param driver_ctx: Handle to the context to initialized

    :param host_idx: Index of the hardware device to open. The enumeration depends
        on the specific hardware. ``-1`` always means open the first available device

    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_read_stream(oni_driver_ctx driver_ctx, oni_read_stream_t stream, void *data, size_t size)

    Performs a read operation over the specified input stream.

    :param driver_ctx: Context handling the device driver translator state

    :param stream: The input stream to perform the read operation on

    :param data: Pointer to the data buffer. It must be big enough to fit the requested amount of data

    :param size: Size, in bytes, of the data to read. Must read this amount from the device.

    :return: Bytes retrieved in case of a successful read, see :ref:`onidef_error_codes` otherwise. If the amount 
        of retrieved bytes were different from ``size``, it would be also treated as an error by the API.

.. function:: int oni_driver_write_stream(oni_driver_ctx driver_ctx, oni_write_stream_t stream, const char *data, size_t size)

    Performs a write operation over the specified output stream.

    :param driver_ctx: Context handling the device driver translator state

    :param stream: The output stream to perform the write operation on

    :param data: Pointer to the data buffer. It must contain the amoutn of data requested to write

    :param size: Size, in bytes, of the data to write.

    :return: Bytes sent in case of a successful write, see :ref:`onidef_error_codes` otherwise.

.. function:: int oni_driver_read_config(oni_driver_ctx driver_ctx, oni_config_t config, oni_reg_val_t *value)

    Performs a read operation from one of the hardware configuration registers described on the ONI specification.

    :param driver_ctx: Context handling the device driver translator state

    :param config: Register to read from

    :param value: Variable to store the register value after it is read

    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_write_config(oni_driver_ctx driver_ctx, oni_config_t config, oni_reg_val_t value)

    Performs a write operation to one of the hardware configuration registers described on the ONI specification.

    :param driver_ctx: Context handling the device driver translator state

    :param config: Register to write to

    :param value: Value to be written

    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_set_opt_callback(oni_driver_ctx driver_ctx, int oni_option, const void *value, size_t option_len)

    This function gets called as the last step after a successful :func:`oni_set_opt`. The driver can optionally
    use this for any internal adjustment required. See :ref:`making_drivers` for examples. If this function is
    not used, it is safe to do nothing and return :macro:`ONI_ESUCCESS`.

    :param driver_ctx: Context handling the device driver translator state

    :param oni_option: Option set, as specified in the originating :func:`oni_set_opt` call.

    :param value: Option value, as specified in the originating :func:`oni_set_opt` call.

    :param option_len: Value length, as specified in the originating :func:`oni_set_opt` call.

    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_set_opt(oni_driver_ctx driver_ctx, int driver_option, const void *value, size_t option_len)

    Sets an internal option specific to the driver translator. Called directly by :c:func:`oni_set_driver_opt`.
    If not such options exist in a specific driver
    this can be an empty function returning :macro:`ONI_EINVALOPT`.

    :param driver_ctx: Context handling the device driver translator state

    :param driver_option: Option index to set, specific to the device driver translator

    :param value: buffer containing data to be written to ``driver_option``

    :param option_len: Size of ``value`` buffer (including terminating null
        character, if applicable) in bytes.
    
    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: int oni_driver_get_opt(oni_driver_ctx driver_ctx, int driver_option, void *value, size_t* option_len)

    Reads an internal option specific to the driver translator. Called directly by :c:func:`oni_get_driver_opt`.
    If not such options exist in a specific driver
    this can be an empty function returning :macro:`ONI_EINVALOPT`.

    :param driver_ctx: Context handling the device driver translator state

    :param driver_option: Option index to read, specific to the device driver translator

    :param value: buffer to store value of ``driver_option`` after it is read

    :param option_len: Pointer to the size of ``value`` buffer (including terminating
        null character, if applicable) in bytes.
    
    :return: 0 on success otherwise see :ref:`onidef_error_codes`.

.. function:: const oni_driver_info_t *oni_driver_info()

    Provides static information about the driver translator

    :return: A :ref:`oni_driver_info_t` structure containing information about the driver translator

