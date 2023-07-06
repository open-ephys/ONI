.. _device:

Devices
=======
Devices are the endpoint of most ONI transactions. They can represent a
physical element interfacing with the environment (e.g. an external sensor with
a digital communication interface), something programmed within the firmware to
emulate this (e.g. a digital logic module on an FPGA) or a purely internal data
source (e.g. a controller based digital logic module that generates system
status reports). A device exposes the following :ref:`communication channels
<com-channels>`:

- A MANDATORY register interface
- An OPTIONAL read stream
- An OPTIONAL write stream

Communication over streams follows a specific :ref:`sample format
<dev-sample>`, while the register interface must comply with a specific bus
communication cycle. Details on each are provided in following sections. Device
developers MUST provide a :ref:`datasheet <dev-datasheet>` describing the
register map, stream data format, along with general behavior of the device in
order to reach ONI-compliance.

.. _dev-id:

Device ID
---------
Different types of devices MUST have a unqiue identification integer called a
Device ID. Device IDs are 32-bit integers with the following format:

::

    Reserved(8-bit).Company(8-bit).Device(16-bit)

- ``Reserved``: Reserved for future specification revision. Currently ignored.
- ``Company``: Any person, lab, institute, informal group, or company can
  communicate with Open Ephys in order to to obtain a unique 8-bit “Company”
  value, and thus be included in the automatic listings of existing ONI API
  implementations. Open Ephys is 0x0000.
- ``Device``: 16-bit Device ID. This number identifies not only the type of
  data produced or consumed by a device, but also a particular implementation.
  For instance, the same sensor will have a unique Device IDs for each digital
  module implementation that is used to communicate with it. This number can
  optionally be divided in two 8-bit values so long as the resulting 16-bit
  integer is unique within a particular “Company” (there is no need for unary
  are monotonic increments when new devices are introduced).

.. _dev-desc:

Device Descriptor
-----------------
A device MUST expose a descriptor that is read by the :ref:`controller
<controller>` following a reset and that is incorporated into the :ref:`device
table <dev-table>`. The descriptor must contain the following information:

::

    uint32    Device_ID
    uint32    Device_Version
    uint32    Read_Sample_Size
    uint32    Write_Sample_Size

- ``Device_ID``: :ref:`As previously described. <dev-id>`.
- ``Device_Version``: A version number to distinguish between implementations
  of a singular device type. Different versions address minor issues that MUST
  NOT  change the device’s sample data format or alters an existing register
  map. However, register additions that do not affect the existing register map
  are allowed. Any change that warrants a modification of a device’s streaming
  data format, read size, write size, or existing register map MUST be
  implemented as a new :ref:`Device ID <dev-id>`.
- ``Read_Sample_Size``: The length in bytes of a single :ref:`device sample
  <dev-sample>` produced by the device and sent to the :ref:`read stream
  <com-channels>`.
- ``Write_Sample_Size``: The length in bytes that of a single :ref:`device
  sample <dev-sample>` consumed by the device from the :ref:`write stream
  <com-channels>`.

.. _dev-sample:

Device Sample Format
--------------------
Data passed over the read or write streams is transmitted in unit packets,
or “samples”. A sample transmitted over the read stream MUST have the following
format:

::

    uint64    Hub_Timestamp (Read Stream Only)
    var       Payload

- ``Hub_Timestamp``: For samples produced by the device and set to the read
  stream, this is a common counter for all devices in a :ref:`Hub <hub>`,
  indicating the time of sample capture. For samples consumed by the device
  from the write stream, this value is reserved.
- ``Payload``: Device-specific data.

  -  For :ref:`read streams <com-channels>`, this data must be of :ref:`Read Sample
     Size <dev-desc>` - 8.
  -  For :ref:`write streams <com-channels>`, this data must be of :ref:`Write Sample
     Size <dev-desc>`. Thus, the whole sample packet fits into the sample
     size specified in the :ref:`device descriptor <dev-desc>`.

.. _dev-register:

Device Registers
----------------

.. _reg-type:

Register Type
~~~~~~~~~~~~~

Device registers can be separated into two types:

-  **Raw registers**: Those that correspond 1:1 to the physical register space
   of an external electrical component. (e.g.: The register map in the
   manufacturer datasheet of a sensor IC)
-  **Managed registers**: Those designed to interface exclusively with an ONI
   system, usually implemented in firmware and described in a :ref:`ONI Device
   Datasheet <dev-datasheet>`.

Raw registers provide a direct window to the underlying hardware. On the other
hand, managed registers provide flexibility and abstract control over device
state. For instance, managed registers may provide access to abstract properties
that require access to multiple physical registers in hardware, which can all be
completed in a single register read or write cycle. Thus the firmware can
managing low-level raw access to the hardware, while exposing only high-level
abstract registers in order to simplify the interface to user applications.

Register Access and Update
~~~~~~~~~~~~~~~~~~~~~~~~~~

Registers, independently of their :ref:`type <reg-type>`, can be defined as
Read-Write, Read-Only or Write-Only. All registers MUST have a valid value at
power-on. Whenever a device receives a reset request generated by the
controller, registers might either be reset to their power-on value or keep
their current value. This can be defined independently for each register.

All register writes, regardless of reset behavior, MUST be immediate (i.e.: for
a Read-Write register, reading a register after being written must reflect the
new value). However, the *effects* of a register might not occur until the next
reset. An example of this type of behavior is registers that operate on the
:ref:`device descriptor <dev-desc>`. The descriptor must be static during runtime,
but registers affecting it might take action after a reset, providing an updates
descriptor to the controller.

Register access, bit-field definitions, reset behavior, and time of effect MUST
be specified in the hardware datasheet for raw registers or the :ref:`ONI Device
Datasheet <dev-datasheet>` for managed registers.

.. _dev-reg-map:

Register Map
~~~~~~~~~~~~

A device can optionally implement raw registers and MUST implement at least one
managed register, ``ENABLE``, a Read-Write register that takes effect after
reset. When ``ENABLE`` is disabled, the device must not produce any data
through the :ref:`read stream <com-channels>`.

The location of the managed registers depends on the existence of raw
registers.  If the device implements raw registers, those are mapped to
addresses 0x0000 to 0x7FFF, corresponding to the same address map of the
underlying hardware, and managed registers start from 0x80000. If no raw
registers are present, managed registers start from 0x0000 instead.

The ``ENABLE`` register MUST be the first of the managed registers, at 0x0000 if
no raw registers are present, 0x8000 if raw registers are implemented.

.. _dev-datasheet:

Device Datasheet
----------------
All ONI-compliant devices MUST have a corresponding datasheet that provides
information on register programming and data IO. The datasheet must be served
publicly. It can be a text file, PDF, or website. The required datasheet
sections and information are described below.

Preamble
~~~~~~~~
The following information is required in the preamble:

1. **Informal device name**: Name of the device. There are no textual
   requirements for this field. (e.g. ChipXYX, Chip XYX, and My~Chip-12ab!, are
   all valid)
2. **Author(s)**: Device firmware or chip creator(s). Can be a person/people or
   a company, group, or organization.
3. **Device Version**: The `device version <dev-desc>` that this datasheet
   corresponds to.
4. **Device ID**: The `device ID <dev-id>` that this datasheet corresponds
   to.

Description
~~~~~~~~~~~
A textual description of the functionality of the device. This can be simple or
detailed and is meant to be useful for upstream hardware and software develops
for understanding the nature of the device during their work.

Register Map
~~~~~~~~~~~~

Unmanaged Registers
^^^^^^^^^^^^^^^^^^^
If the device uses `unmanaged registers <reg-type>`, then a link to the
manufacturer’s datasheet is all that is required so long as it contains the
register documentation equivalent to that required by `managed registers
<dev-ds-managed-reg>`. However, the register map can also be reproduced for
clarity or if the manufacturer’s datasheet is missing required information.

.. _dev-ds-managed-reg:

Managed Registers
^^^^^^^^^^^^^^^^^
If the device uses :ref:`managed registers <reg-type>`, a table that describes the
managed register map is required. There are no formatting requirements for this
table, but it MUST contain the following columns

-  **Address**: Register address within the :ref:`register map <dev-reg-map>`.
-  **Name**: Human readable name for the register. Only capital ASCII letters
    and underscores are allowed, with no spaces or special characters (e.g.
    ``VALID`` and ``ALSO_VALID`` vs. ``NotValid`` and ``ALSO-NOT-VALID``).
-  **Access**: Read-only, write-only, or read-write.
-  **Time of Effect**: When does a register write affect hardware state.
   Immediate or following reset.
-  **POR Value**: Power-on reset default value.
-  **Reset Action**: Upon a reset, what happens to the register? Does it
   maintain its previous state or get reset to some value? If the latter, then
   what value?
-  **Description**: Word description of the register’s function

Additional columns are permitted so long as their information does not conflict
with that in the required columns.

Read Frame Format
~~~~~~~~~~~~~~~~~
If the device produces frames, a
`bitfield <https://en.wikipedia.org/wiki/Bit_field>`__ diagram describing the
frame structure is required. Bits can be grouped into words as is convenient. If
no frames are produced, then a statement of such is required.

Write Frame Format
~~~~~~~~~~~~~~~~~~
If the device accepts frames, a
`bitfield <https://en.wikipedia.org/wiki/Bit_field>`__ diagram describing the
frame structure is required. Bits can be grouped into words as is convenient. If
no frames are accepted, then a statement of such is required.
