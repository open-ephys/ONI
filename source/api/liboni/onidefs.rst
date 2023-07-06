.. _onidefs.h:
.. default-domain:: c

onidefs.h
#######################################
Macro and constant definitions common to both :ref:`oni.h` and :ref:`onidriver.h`.

.. _onidef_integer_types:

Integer Types
---------------------------------------

.. warning:: All of these types will be almost certainly be deprecated in
    future API revisions to handle drivers with different channel bit widths

.. type:: uint32_t oni_size_t

    Data sizes are 32-bit uints

.. type:: uint32_t oni_dev_id_t

    Device IDs are 32-bit values

.. type:: uint32_t oni_dev_idx_t

    Device idx are 32-bit, byte.byte.btye.byte addresses

.. type:: uint32_t oni_reg_addr_t

    Registers use a 32-bit address

.. type:: uint32_t oni_reg_val_t

    Registers have 32-bit values

.. type:: uint32_t oni_fifo_dat_t

    FIFOs use 32-bit words

.. type:: uint64_t oni_fifo_time_t

    FIFO bound timers use 64-bit words

.. _onidef_context_options:

Context Options
---------------------------------------
Context options that can be used in calls to :func:`oni_get_opt` and
:func:`oni_set_opt`. The tables under each option provide information about the
corresponding context option type used during calls to these functions.

.. enum:: @ctx_opts_enum

    .. macro:: ONI_OPT_DEVICETABLE

        (``0``)
        Device table.

        =================== ==================================================
        Option value type   :type:`oni_device_t` *
        Option description  Pointer to a pre-allocated array of :type:oni_device_t structs
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_NUMDEVICES

        (``1``)
        Number of devices in the device table.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  The number of devices supported by the firmware
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_RUNNING

        (``2``)
        Set/clear data input gate. Any value greater than 0 will turn data
        acquisition on.  Writing 0 to this option will stop acquisition, but will
        not reset context options or the sample counter. All data not shifted out
        of hardware will be cleared. To obtain the very first samples produced by
        high-bandwidth devices, see :macro:`ONI_OPT_RESETACQCOUNTER` to see how to
        start acqusition sychronously with a clock reset.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Any value greater than 0 will start acquisition
        Default value       0
        Access              Write and Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_RESET

        (``3``)
        Trigger global hardware reset. Any value great than 0 will trigger a
        hardware reset. In this case, acquisition is stopped and resets are issued
        to all devices in the device table. Following a

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Any value greater than 0 will trigger a reset
        Default value       0 (Untriggered)
        Access              Write
        Required run state  IDLE
        =================== ==================================================

    .. macro:: ONI_OPT_SYSCLKHZ

        (``4``)
        Host system clock frequency in Hz. This describes the frequency of the
        clock governing the host hardware.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Host main clock frequency in Hz
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_ACQCLKHZ

        (``5``)
        Host system acqusition clock frequency in Hz, derived from
        :macro:`ONI_OPT_SYSCLKHZ`. This describes the frequency of the clock used
        to drive the acqusition counter which is used timestamp data frames.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Host acqusition clock frequency in Hz
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_RESETACQCOUNTER

        (``6``)
        Trigger a reset of the acqusition clock counter. A value of 1 will trigger
        an acqusition clock counter reset. A value of 2 or greater will trigger
        synchronous acqusition clock counter reset and set :macro:`ONI_OPT_RUNNING`
        to 1.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  1: reset clock counter, 2: reset clock counter and set :macro:`ONI_OPT_RUNNING` to 1
        Default value       0 (Untriggered)
        Access              Write
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_HWADDRESS

        (``7``)
        The address of the host hardware within the acqusition computer.
        Determines the sychronization role of the hardware in multi-host
        systems.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  TODO
        Default value       0
        Access              Read and Write
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_MAXREADFRAMESIZE

        (``8``)
        The maximal size of a frame produced by a call to ``oni_read_frame`` in
        bytes.  This number is the maximum sized frame that can be produced across
        every device within the device table that generates read data.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Maximal read :type:`oni_frame_t` size in bytes
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_MAXWRITEFRAMESIZE

        (``9``)
        The maximal size of a (single-packet) :type:`oni_frame_t` comsumed by a
        call to :func:`oni_write_frame` in bytes.  This number is the maximum
        sized frame that can be consumed across every device within the device
        table that accepts write data.

        =================== ==================================================
        Option value type   :type:`oni_reg_val_t`
        Option description  Maximal (single packet) write :type:`oni_frame_t` size in bytes
        Default value       N/A
        Access              Read
        Required run state  IDLE or RUNNING
        =================== ==================================================

    .. macro:: ONI_OPT_BLOCKREADSIZE

        (``10``)
        Number of bytes read during each driver access to the high-bandwidth read
        channel using :func:`oni_read_frame`. This option allows control over a
        fundamental trade-off between closed-loop response time and overall
        bandwidth. The minimum (default) value will provide the lowest response
        latency. Larger values will reduce syscall frequency and may improve
        processing performance for high-bandwidth data sources. This minimum size
        of this option is determined by :macro:`ONI_OPT_MAXREADFRAMESIZE`.

        =================== ==================================================
        Option value type   ``size_t``
        Option description  Size, in bytes, of high-bandwidth hardware read that may be triggered during a call to :func:`oni_read_frame`
        Default value       Value of :macro:`ONI_OPT_MAXREADFRAMESIZE`
        Access              Read and Write
        Required run state  Read: IDLE or RUNNING; Write: IDLE
        =================== ==================================================

    .. macro:: ONI_OPT_BLOCKWRITESIZE

        (``11``)
        Number of bytes pre-allocated to create frames using
        :func:`oni_create_frame`. A larger size will reduce the amount of dynamic
        memory allocation system calls but increase the cost of each of those
        calls. The minimum size of this option is determined by
        :macro:`ONI_OPT_MAXWRITEFRAMESIZE`.

        =================== ==================================================
        Option value type   ``size_t``
        Option description  Pre-allocation size of buffer used to make frames used by :func:`oni_write_frame`
        Default value       Value of :macro:`ONI_OPT_MAXWRITEFRAMESIZE`
        Access              Read and Write
        Required run state  Read: IDLE or RUNNING; Write: IDLE
        =================== ==================================================

.. _onidef_error_codes:

Error Codes
---------------------------------------
Return codes for functions in the API.

.. enum:: @oni_error_enum

    .. macro:: ONI_ESUCCESS

        (``0``)
        Success

    .. macro:: ONI_EPATHINVALID

        (``-1``)
        Invalid stream path, fail on open

    .. macro:: ONI_EDEVID

        (``-2``)
        Invalid device ID

    .. macro:: ONI_EDEVIDX

        (``-3``)
        Invalid device index

    .. macro:: ONI_EWRITESIZE

        (``-4``)
        Data size is not an integer multiple of the write size for the designated device

    .. macro:: ONI_EREADFAILURE

        (``-5``)
        Failure to read from a stream/register

    .. macro:: ONI_EWRITEFAILURE

        (``-6``)
        Failure to write to a stream/register

    .. macro:: ONI_ENULLCTX

        (``-7``)
        Attempt to use a NULL context

    .. macro:: ONI_ESEEKFAILURE

        (``-8``)
        Failure to seek on stream

    .. macro:: ONI_EINVALSTATE

        (``-9``)
        Invalid operation for the current context run state

    .. macro:: ONI_EINVALOPT

        (``-10``)
        Invalid context option

    .. macro:: ONI_EINVALARG

        (``-11``)
        Invalid function arguments

    .. macro:: ONI_ECOBSPACK

        (``-12``)
        Invalid COBS packet

    .. macro:: ONI_ERETRIG

        (``-13``)
        Attempt to trigger an already triggered operation

    .. macro:: ONI_EBUFFERSIZE

        (``-14``)
        Supplied buffer is too small

    .. macro:: ONI_EBADDEVTABLE

        (``-15``)
        Badly formatted device table supplied by firmware

    .. macro:: ONI_EBADALLOC

        (``-16``)
        Bad dynamic memory allocation

    .. macro:: ONI_ECLOSEFAIL

        (``-17``)
        File descriptor close failure (check errno)

    .. macro:: ONI_EREADONLY

        (``-18``)
        Attempted write to read only object (register, context option, etc)

    .. macro:: ONI_EUNIMPL

        (``-19``)
        Specified, but unimplemented, feature

    .. macro:: ONI_EINVALREADSIZE

        (``-20``)
        Block read size is smaller than the maximal read frame size

    .. macro:: ONI_ENOREADDEV

        (``-21``)
        Frame read attempted when there are no readable devices in the device table

    .. macro:: ONI_EINIT

        (``-22``)
        Hardware initialization failed

    .. macro:: ONI_EWRITEONLY

        (``-23``)
        Attempted to read from a write only object (register, context option, etc)

    .. macro:: ONI_EINVALWRITESIZE

        (``-24``)
        Write buffer pre-allocation size is smaller than the maximal write frame size

    .. macro:: ONI_ENOTWRITEDEV

        (``-25``)
        Frame allocation attempted for a non-writable device

    .. macro:: ONI_EDEVIDXREPEAT

        (``-26``)
        Device table contains repeated device indices


Hardware Registers
---------------------------------------
These constants are used by :ref:`drivers` to implement the ONI-specified
register programming interface. These correspond to the hardware registers
described in the specification and are used by the driver translators
as the underlying hardware endpoint for functions such as :func:`oni_get_opt`,
:func:`oni_set_opt`, :func:`oni_read_reg` and :func:`oni_write_reg`

.. enum:: oni_config_t

    .. macro:: ONI_CONFIG_DEV_IDX

        ( ``0``)
        Device register access: Target device index

    .. macro:: ONI_CONFIG_REG_ADDR

        ( ``1``)
        Device register access: Target adress

    .. macro:: ONI_CONFIG_REG_VALUE

        ( ``2``)
        Device register access: Register value

    .. macro:: ONI_CONFIG_RW

        ( ``3``)
        Device register access: Select read ``0`` or write ``1`` operation

    .. macro:: ONI_CONFIG_TRIG

        ( ``4``)
        Device register access: Operation start trigger (Write-only)

    .. macro:: ONI_CONFIG_RUNNING

        ( ``5``)
        Select acquisition running state. Accessed through :macro:`ONI_OPT_RUNNING`
    .. macro:: ONI_CONFIG_RESET

        ( ``6``)
        Reset operation and refresh device map trigger. Accessed through :macro:`ONI_OPT_RESET` (Write-only)

    .. macro:: ONI_CONFIG_SYSCLKHZ

        ( ``7``)
        ONI Host system clock speed, reported to :macro:`ONI_OPT_SYSCLKHZ` (Read-only)

    .. macro:: ONI_CONFIG_ACQCLKHZ

        ( ``8``)
        ONI Host acquisition clock speed, reported to :macro:`ONI_OPT_ACQCLKHZ` (Read-only)

    .. macro:: ONI_CONFIG_RESETACQCOUNTER

        ( ``9``)
        Trigger a reset of the acquisition counter. Accessed through :macro:`ONI_OPT_RESETACQCOUNTER` (Write-only)

    .. macro:: ONI_CONFIG_HWADDRESS

        ( ``10``)
        The address of the host hardware within the acqusition computer. Accessed through :macro:`ONI_OPT_HWADDRESS`

.. _oni_driver_info_t:

Driver Information
--------------------------------
.. struct:: oni_driver_info_t

    This structure contains information about the loaded :ref:`driver translator <drivers>`.

    .. member:: const char* name

        Name of the driver translator

    .. member:: const int major

        Major version component, according to `Semantic versioning <https://semver.org/>`_.

    .. member:: const int minor

        Minor version component, according to `Semantic versioning <https://semver.org/>`_.

    .. member:: const int patch

        Patch version component, according to `Semantic versioning <https://semver.org/>`_.

    .. member:: const char* pre_release

        Pre-release optional string. Can be ``NULL``.
