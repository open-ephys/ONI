.. _addresses:

Controller Address Space
=================================

An ONI :term:`Controller` has a 16-bit address register space, accessible
through the :ref:`conf-chan`.

The full address space is divided into three address blocks and a fourth
currently reserved. The address blocks are:

- :ref:`address_global`: 0x0000-0x3FFF
- :ref:`address_spec`: 0x4000-0x7FFF
- :ref:`address_custom`: 0x8000-0xBFFF
- :ref:`address_reserved`: 0xC000-0xFFFF

.. _address_global:

Operation Registers
-------------------

**Address range:** 0x0000-0x3FFF

This address block is dedicated to controlling the operation of the system and
accessing :ref:`dev-register`.

The address map for this block is as follows:

========== ========================= ==================
Address    Name                      Type
========== ========================= ==================
0x0000     SOFT_RESET                Global
0x0001     ACQ_RUNNING               Global
0x0002     SYS_CLK_HZ                Global
0x0003     ACQ_CLK_HZ                Global
0x0004     ACQ_CNT_RESET             Global
0x0005     SYNC_HW_ADDR              Global
0x0006     RI_DEV_ADDR               Register interface
0x0007     RI_REG_ADDR               Register interface
0x0008     RI_REG_VAL                Register interface
0x0009     RI_RW                     Register interface
0x000A     RI_TRIGGER                Register interface
========== ========================= ==================

Global Acquisition Registers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following global acquisition registers govern acquisition over a single
controller.

.. _soft-reset-reg:

- ``SOFT_RESET``: System Soft Reset. Set to 0x00000001 to trigger a hardware
  soft reset, stopping acquisition and clearing the transmission buffers and
  states. After this, a fresh device map is sent to the host. Devices are reset
  but their managed registers might remain unchanged, depending on their
  configuration (See the :ref:`Device registers <dev-register>` section for more
  information). This register is set to 0x00000000 by the controller upon
  entering the reset state.

- ``ACQ_RUNNING``: Acquisition Running. Set to 0x00000001 to run the system
  clock and produce data. Set to 0x00000000 to stop the system clock and
  therefore stop data flow. Results in no other configuration changes.

- ``SYS_CLK_HZ``: System Clock. A read-only register specifying the controller
  main hardware clock frequency in Hz. This is the clock used by the controller
  to perform data transmission.

- ``ACQ_CLK_HZ``: Acquisition Clock. A read-only register specifying the
  :ref:`Acquisition Counter<acq_clk>` frequency in Hz. This clock is used to
  generate an acquisition counter, common to all devices, that timestamps
  samples when packaged into frames by the controller. The ``acqclk_cnt`` in the
  read :ref:`frame <frame>` header is incremented at this frequency.

- ``ACQ_CNT_RESET``: Reset Acquisition Counter. This register is used to reset
  the :ref:`counter<acq_clk>` generating the ``acqclk_cnt`` used in the
  :ref:`device frames <frame>`. A value of 0x00000001 will reset the counter to
  0 without affecting the ``Running`` state. A value of 0x00000002 will reset
  the counter and, at the same time, set ``Running`` to 0x00000001, starting
  data production.

.. _optional-num-sync-dev:

- ``SYNC_HW_ADDR``: Hardware address. This register MAY be used for
  implementations that allow multiple controllers with a link between them to
  synchronize their :ref:`acquisition counters<acq_clk>`. The presence and
  limits of this capability are indicated in the
  :ref:`ONI_ATTR_NUM_SYNC_DEVS<optional-num-sync-dev-reg>` register. In
  configurations that support hardware synchronization, resetting the
  acquisition counter through ``ACQ_CNT_RESET`` on a device with a
  ``SYNC_HW_ADDR`` of 0x00000000 will broadcast a hardware signal to all
  connected non-zero controllers, resetting all counters simultaneously.

  .. note:: Hardware synchronization is guaranteed only among controllers with
    the same hardware implementation and that indicate support for this
    capability. Synchronization between controllers with different
    implementations is not assured, even if they indicate support for this
    capability.

Other addresses in this block are reserved and MUST NOT be used.

Device Register Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^

These registers provide a standardized way to access :ref:`dev-register`. Read
and write procedures to device registers are detailed in
:ref:`register_interface`.

.. _address_spec:

Specification Parameters
-------------------------

**Address range:** 0x4000-0x7FFF

This block contains read-only registers that contain information about hardware
capabilities and ONI specification compliance.

Currently defined addresses are:

======== ===============================
Address  Name
======== ===============================
0x4000   ONI_SPEC_VER
0x4001   ONI_ATTR_READ_STR_ALIGN
0x4002   ONI_ATTR_WRITE_STR_ALIGN
0x4003   ONI_ATTR_MAX_REGISTER_Q_SIZE
0x4004   ONI_ATTR_NUM_SYNC_DEVS
======== ===============================

- ``ONI_SPEC_VER``: ONI specification version. Specifies the version of the ONI
  specification the controller adheres to. Format is:

  ::

    Major(8-bit).Minor(8-bit).Patch(8-bit).Reserved(8-bit)

.. _read-word-alignment-reg:

- ``ONI_ATTR_READ_STR_ALIGN``: Read stream alignment. Specifies, in bits, the
  data word size the hardware implementation of the :ref:`read channel
  <data-rd-chan>` uses for transmission. This value must be divisible by 8.

.. _write-word-alignment-reg:

- ``ONI_ATTR_WRITE_STR_ALIGN``: Write stream alignment. Specifies, in bits, the
  data word size the hardware implementation of the :ref:`write channel
  <data-wr-chan>` uses for transmission. This value must be divisible by 8.

.. _max-devaccess-reg:

- ``ONI_ATTR_MAX_REGISTER_Q_SIZE``: Maximum queued device register operations.
  Maximum number of operations that can be queued through the
  :ref:`register_interface`.

.. _optional-num-sync-dev-reg:

- ``ONI_ATTR_NUM_SYNC_DEVS``: Number of supported synchronized devices. This
  register indicates if the optional capability for :ref:`hardware
  synchronization<optional-num-sync-dev>` is supported. If 0, this controller
  can not synchronize with others. if > 0, it indicates the maximum number of
  controllers that can be synchronized together. If the value is 0xFFFFFFFF,
  then there is no upper bound to this number.

Other addresses in this block are reserved and MUST NOT be used.

.. _address_custom:

Hardware-Specific Registers
----------------------------
**Address range:** 0x8000-0xBFFF

This block is reserved for hardware-specific registers that fall out of the
scope of this specification but might be required for the correct operation of a
specific hardware implementation.

.. note:: These addresses SHOULD be reserved for low-level configuration of the
  hardware. Most hardware-specific operations SHOULD, if possible, be implemented
  either in :ref:`hardware specific registers<hub_addr_hw_specific>` in the
  controller hub-0 :ref:`hub information device<hub_info_dev>` or in dedicated
  devices to access these hardware characteristics (e.g., hub link controllers).
  When registers in this block are used, the :term:`Driver Translator` should,
  to the possible extent, hide these from the :term:`API`.

.. _address_reserved:

Reserved
----------

This address space is currently unused and must be reserved for future updates.