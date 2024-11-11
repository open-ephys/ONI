.. _addresses:

Controller Address Space
=================================

An ONI :term:`Controller` has a 16-bit address register space, accessible through the :ref:`conf-chan`.

The full address space is divided into three address blocks and a fourth currently reserved. The address blocks are:

.. _address_global:

Operation registers
-------------------

**Address range:** 0x0000-0x3FFF


This address block is dedicated to controlling the operation of the system and accessing :ref:`dev-register`.

The address map for this block is as follows:

========== ========================= ==================
Address    Name                      Type
========== ========================= ==================
0x0000     Reset                     Global
0x0001     Running                   Global
0x0002     System Clock              Global
0x0003     Acquisition Clock         Global
0x0004     Reset Acquisition Counter Global
0x0005     Hardware Address          Global
0x0006     Device Address            Register interface
0x0007     Register Address          Register interface
0x0008     Register Value            Register interface
0x0009     Read/Write                Register interface
0x000A     Trigger                   Register interface
========== ========================= ==================

Global Acquisition Registers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following global acquisition registers provide information about, and
control over, the entire acquisition system:

- ``Running``: Set to > 0 to run the system clock and produce data. Set to 0 to
  stop the system clock and therefore stop data flow. Results in no other
  configuration changes.

- ``Reset``: Set to > 0 to trigger a hardware reset and send a fresh device
  map to the host. Devices are reset but their managed registers might remain
  unchanged, depending on their configuration (See the :ref:`Device registers
  <dev-register>` section for more information). Set to 0 by the controller
  upon entering the reset state.

- ``System Clock``: A read-only register specifying the master hardware clock
  frequency in Hz. This is the clock used by the controller to perform data
  transmission.

- ``Acquisition Clock``: A read-only register specifying the system common
  clock frequency in Hz. This clock is used to generate an acquisition counter
  that timestamps data from all the devices. The ``Common_Timestamp`` in the
  read :ref:`frame <frame>` header is incremented at this frequency.

- ``Reset Acquisition Counter``: This register is used to reset the counter
  generating the ``Common_Timestamp`` used in the :ref:`device frames <frame>`.
  A value of 1 will reset the counter to 0 without affecting the ``Running``
  state. A value of 2 will reset the counter and, at the same time, set
  ``Running`` to 1, starting data production.

  .. _optional-num-sync-dev:

- ``Hardware Address``: :ref:`(OPTIONAL) <optional-num-sync-dev-reg>` This is used for systems that allow multiple
  controllers with a link between them to synchronize their
  ``Common_Timestamps``. When resetting the acquisition counter through the
  ``Reset acquisition counter`` on a device with a ``Hardware Address`` of 0,
  this command will be sent through an external link to all non-zero devices,
  synchronizing the counters. When supported, synchronization is only required
  for controllers sharing a hardware implementation.

Device Register Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^
  
These registers provide a standardized way to access :ref:`dev-register`. Read and write
procedures to device registers are detailed in :ref:`register_interface`.

.. _address_spec:

Specification parameters
-------------------------

**Address range:** 0x4000-0x7FFF

This block contains read-only registers that contain information about hardware 
capabilities and ONI specification compliance.

Currently defined addresses are:

======== ===========================
Address  Name
======== ===========================
0x4000   ONI specification version
0x4001   Read stream alignment
0x4002   Write stream alignment
0x4003   Maximum queued device register operations
0x4004   Number of supported synchronized devices
======== ===========================

- **ONI specification version**: Specifies the version of the ONI specification the controller adheres to.
  Format is, bits 31-24: Major, 23-16: Minor, 15-8: patch, 7-0: reserved

.. _read-word-alignment-reg:
  
- **Read stream alignment**: Specifies, in bits, the data word size the hardware implementation of 
  the :ref:`read channel <data-rd-chan>` uses for transmission.

.. _write-word-alignment-reg:

- **Write stream alignment**: Specifies, in bits, the data word size the hardware implementation of 
  the :ref:`write channel <data-wr-chan>` uses for transmission.

.. _max-devaccess-reg:

- **Maximum queued device register operations**: Maximum number of operations that can be queued through the
  :ref:`register_interface`

.. _optional-num-sync-dev-reg:

- **Number of supported synchronized devices**: This register indicates if the optional capability
  for :ref:`hardware synchronization<optional-num-sync-dev>` is supported. If 0, this controller can
  not synchronize with others. if >0, it indicates the maximum number of controllers that can be synchronized
  together. If the value is 0xFFFFFFFF, then there is no upper bound to this number.


.. _address_custom:

Hardware-specific registers
----------------------------
**Address range:** 0x8000-0xBFFF

This block is reserved for hardware-specific registers that fall out of the scope of this specification
but might be required for the correct operation of a specific hardware implementation.

The :term:`Driver Translator` should, to the possible extent, hide these from the :term:`API`.
