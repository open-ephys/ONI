.. _making_drivers:

Intefacing with Device Drivers
==========================================
A device driver translator (also called ``onidriver``) is a small piece of
software that sits between the public :ref:`liboni` API and the low-level
libraries or kernel drivers handling actual hardware, taking care of all the
implementation details. This allows the API to remain hardware-agnostic and
work with a wide variety of host devices.

Writing an device driver translator requires detailed knowledge of the target
hardware. However, from the API perspective, it is as simple as :ref:`defining
a driver context <making_drivers_context>` and :ref:`implementing all functions
<making_drivers_functions>` defined in :ref:`onidriver.h`.

.. _making_drivers_context:

Driver Context
-----------------------
A driver context is a data structure containing all state information about a
particular instance of the driver. A instance of this istructure will be
created during liboni context creation phase and passed to the main API as an
opaque pointer of type :c:type:`oni_driver_ctx` and stored in a field of
:c:type:`oni_ctx` during its lifetime.

.. tip:: The driver context contents are completely opaque to liboni, so
    its contents are completely up to the developer and the requirements
    of the driver translator itself.

.. warning:: All state information must be contained in this context, instanced
    in :c:func:`oni_driver_create_ctx` and accessed through the :c:type:`oni_driver_ctx`
    parameter present in most function calls. No static variables can be used to
    keep any state information. This is necessary for multiple instances of the driver
    to exist simultaneously, acessing different devices of the same type.

An example of such a context for a simple, file-descriptor accessed device,
could be

.. code-block:: c

    struct simple_driver_ctx_impl {
        int fd_in;  // ONI data input stream
        int fd_out; // ONI data output stream
        int fd_sig; // ONI signal input stream
        int fd_reg; // ONI register IO interface
    };
    typedef simple_driver_ctx_impl* simple_driver_ctx;

.. _making_drivers_functions:

Driver Functions
--------------------------

When liboni operation requires hardware access, it calls a :ref:`set of
functions<onidriver_h_functions>` present on the driver translator, which take
care of the appropriate low-level calls.  See :ref:`onidriver.h` for a complete
description of these functions and its parameters.

.. warning:: All functions present in :ref:`onidriver.h` must be implemented, even if
    they are not actively used.

.. note:: All examples shown in this page, are only orientating and lack
    elements, such as state checks, that are required in a real development.

.. tip:: Most functions have the same return scheme, 0, or :c:macro:`ONI_ESUCCESS`
    on successful operation, or any of the :ref:`onidef_error_codes` on failure.
    Commonly, this error is passed up to the public API and used as return value
    of the :ref:`function <oni_h_functions>` called by the user. The specific
    error value is up to the driver developer.

.. tip:: Since most functions receive a :ref:`making_drivers_context` parameter
    are in the form of a :c:type:`oni_driver_ctx` opaque pointer, a cast to the
    appropriate structure pointer is required. It is handy to define a macro
    taking to take care care of this, instead of manually typing the cast in
    every function. For example:

    .. code-block:: c

        #define CTX_CAST const simple_driver_ctx ctx = (simple_driver_ctx)driver_ctx;

    This macro will be used in all the examples on this page.

Driver translator functions can be organized in the following categories:

.. contents:: :local:

.. _making_drivers_functions_ctx_management:

Context Management
******************************
The three functions responsible for context management are
:c:func:`oni_driver_create_ctx`, :c:func:`oni_driver_init` and
:c:func:`oni_driver_destroy_ctx`.

:c:func:`oni_driver_create_ctx` is responsible for creating the context
instance and allocating all required resources. No hardware access should be
performed in this function, only internal memory allocations as required.

:c:func:`oni_driver_init` is where actual hardware initialization is done. This
function opens the relevant hardware channels and prepare the driver for normal
operation.

:c:func:`oni_destroy_ctx` must close any open hardware connection and release
all allocated resources.

.. code-block:: c
    :caption: Context managment examples

    oni_driver_ctx oni_driver_create_ctx()
    {
        simple_driver_ctx ctx = calloc(1,sizeof(simple_driver_ctx_impl));
        return ctx;
    }

    int oni_driver_init(oni_driver_ctx driver_ctx, int host_idx)
    {
        CTX_CAST;
        ctx->fd_in = open("/dev/instr",O_RDONLY);
        ctx->fs_out = open("/dev/outstr",O_WRONLY);
        ...
        return ONI_ESUCCESS;
    }

    int oni_driver_destroy_ctx(oni_driver_ctx)
    {
        CTX_CAST;
        close(ctx->fd_in);
        close(ctx->fd_out);
        ...
        free(ctx);
        return ONI_ESUCCESS;
    }

.. _making_drivers_functions_stream_io:

Stream I/O
********************
Functions :c:func:`oni_driver_read_stream` and
:c:func:`oni_driver_write_stream` are where access to the `ONI-defined
<https://github.com/open-ephys/ONI>`_ hardware data streams is performed.  Read
operations can be done on the *input* and *signal* streams and write operations
on the *output* streams.

Specific low-level stream access is completely dependent on the hardware
interface used.

.. code-block:: c
    :caption: Example stream I/O implementation

    int oni_driver_read_stream(oni_driver_ctx driver_ctx, oni_read_stream_t stream, void *data, size_t size)
    {
        CTX_CAST;
        if (stream == ONI_READ_STREAM_DATA) return read(ctx->fd_in, data, size);
        else if (stream == ONI_READ_STREAM_SIGNAL) return read(ctx->fd_sig, data, size);
        else return ONI_EPATHINVALID
    }

    int oni_driver_write_stream(oni_driver_ctx driver_ctx, oni_write_stream_t stream, const char *data, size_t size)
    {
        CTX_CAST;
        if (stream == ONI_WRITE_STREAM_DATA) return write(ctx->fs_out, data, size);
        else return ONI_EPATHINVALID;
    }

.. note:: Read operations must return the same number of bytes as requested, or it will be treated as an error

.. _making_drivers_functions_register:

Register access
*************************************
Access to the register interface described on the `ONI specification <https://github.com/open-ephys/ONI>`_
is done through the functions :c:func:`oni_driver_read_config` and :c:func:`oni_driver_write_config`

Again, the specifics on how to access such registers are dependent on the hardware interface.

.. tip:: This functions can be used to perform additional actions when the API accesses specific registers.
    An example would be a device that requires some additional low-level actions, besides the usual register
    trigger, when performing a reset or starting/stopping acquisition.

.. code-block:: c
    :caption: Examples of register access

    int oni_driver_read_config(oni_driver_ctx driver_ctx, oni_config_t config, oni_reg_val_t *value)
    {
        CTX_CAST;
        lseek(ctx->fd_reg,reg_to_address(config));
        read(ctx->fd_reg,value,sizeof(oni_reg_val_t));
        return ONI_ESUCCESS;
    }

    int oni_driver_write_config(oni_driver_ctx driver_ctx, oni_config_t config, oni_reg_val_t value)
    {
        //Example of using this function to perform additional low-level actions
        if (config == ONI_CONFIG_RESET && value != 0) ioctl(ctx->fd_reg, CUSTOM_IOCTL_RESET);

        lseek(ctx->fd_reg,reg_to_address(config));
        write(ctx->fd_reg,&value,sizeof(oni_reg_val_t));
    }


.. _making_drivers_functions_callback:

Option Callback
***********************
While some options set by :c:func:`oni_set_opt` translate to hardware register
access (and thus :c:func:`oni_driver_write_config` or
:c:func:`oni_driver_read_config` calls), not all of them do, with some setting
some internal software parameters in :ref:`liboni`. However, there might be
cases where the hardware or the driver translator might need to be aware of
these settings. An example of this could be hardware requiring knowledge of the
block read size (:c:macro:`ONI_OPT_BLOCKREADSIZE`) to optimize internal
buffering parameters.

To solve this, the driver translator function
:c:func:`oni_driver_set_opt_callback` gets called at the end of any successful
:c:func:`oni_set_opt` call, with its same parameters. This allows the driver
translator to act accordingly. The result of this function will be returned as
the result of :c:func:`oni_set_opt`.

If the driver translator does not require any action on any option, this
function can simply return :c:macro:`ONI_ESUCCESS`.

.. tip:: Even for options that perform :ref:`register access
    <making_drivers_functions_register>`, this function is different from
    adding extra actions in register I/O calls because it is called after any
    library operations are also performed. For example, if
    :c:func:`oni_driver_set_opt_callback` were to react to
    :c:macro:`ONI_OPT_RESET`, it would make it so after the new device table
    has been loaded, while an extra action in :c:func:`oni_driver_write_config`
    would act before, during low-level register access.

.. code-block:: c
    :caption: Example post-option callback

    int oni_driver_set_opt_callback(oni_driver_ctx driver_ctx, int oni_option, const void *value, size_t option_len)
    {
        //Example of a device requiring reacting to changed on block read size
        CTX_CAST;
        if (oni_option == ONI_OPT_BLOCKREADSIZE)
        {
            oni_size_t size = *(oni_size_t*)value;
            ioctl(ctx->fd_in, CUSTOM_IOCTL_BLOCKREAD, size);
        }
        return ONI_ESUCCESS;
    }

.. _making_drivers_functions_opts:

Driver Options
*****************************
While it is recommended that all internal settings for the driver translator
and its underlying hardware are derived from standard ONI options, there might
be cases when special options need to be passed to the driver translator.
:c:func:`oni_driver_set_opt` and :c:func:`oni_driver_get_opt` are used for
this. This two functions are transparently called from the public :ref:`liboni`
API functions :c:func:`oni_set_driver_opt` and :c:func:`oni_get_driver_opt`.

In most cases this functions will simply return :c:macro:`ONI_EINVALOPT`.

.. _making_drivers_functions_info:

Driver Information
****************************
A driver translator must be able to report its name and version information.
This is done using the :ref:`oni_driver_info_t` structure, which contains
information following the `Semantic Versioning <https://semver.org/>`_
specification. This structure should be a constant, and a pointer to it should
be returned by :c:func:`oni_get_driver_info`

.. code-block:: c
    :caption: Example implemention

    const oni_driver_info_t oni_driver_info = {
        .name = "simple",
        .major = 1,
        .minor = 0,
        .patch = 0,
        .pre_release = NULL
    };

    const oni_driver_info_t* oni_driver_info()
    {
        return &driverInfo;
    }

