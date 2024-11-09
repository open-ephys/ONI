.. _hub:

Hubs
====
Hubs are collections of devices sharing a common clock. They can be independent
hardware aggregates connected to the controller (e.g., a headstage for neural
acquisition) or a logical partition of existing hardware (e.g., a collection of
devices implemented in the same firmware as the controller). Hubs that exist on
hardware that is physically separated from the :ref:`controller <controller>` are
referred to as remote hubs, while hubs existing on the controller are local hubs.
An ONI-compliant system MUST implement at least one local hub, located at
:ref:`Hub_Index 0 <dev-address>` and sharing the clock of controller's main
state machine, and can implement up to 253 additional hubs, local or remote. All
devices reflecting or modifying the :ref:`controller <controller>` state and/or 
reporting errors or similar status messages must be implemented in local hub 0.

Every hub MUST have access to a high-resolution timer that is used by all its devices
to generate a ``Hub_Timestamp`` for a :ref:`data sample <dev-sample>`.

Data from all the devices of a hub is collected and passed to the controller.
The specific interface between a hub and the controller is highly
implementation-dependent and, thus, not in the scope of this document. In
any case, it is the duty of the hub to provide the controller with all the
device descriptors and communication channels in a transparent manner. It is
common for a remote hub to feature a centralized IC (e.g., an FPGA or
microcontroller) integrating the device controllers and communication interface
to fill this duty, but other schemes are possible.

Multiple hubs are differentiated through a unique identifier, or Hardware ID.
This identifier represents a specific implementation of a hub, defined by a
particular collection of devices on a specific hardware platform communicating
with the controller through a specific link. Changes in the device collection,
the communications link or the general hardware architecture require a new
identifier.

.. _special-devs:

Special Devices
---------------
There are two kinds of special devices that are required by this specification: 
An information device on each hub and a heartbeat device in local hub 0.

Information Device
~~~~~~~~~~~~~~~~~~
Every hub in an ONI system MUST feature a special device, located at
:ref:`Device_Address <dev-table>` 0xXXXXXXFE, which supplies information about the
hub. Because this device is required to exist at a fixed address, it is not
listed in the device table and, thus, has no :ref:`device descriptor
<dev-desc>`.  It MUST expose is the register interface, and it MUST NOT include
any streams. The required register map is:

========== ================================
Address    Register
========== ================================
0x00000000 Hardware ID
0x00000001 Hardware revision
0x00000002 Firmware version
0x00000003 (OPTIONAL) Safe firmware version
0x00000004 Hub clock frequency
0x00000005 Hub data latency
========== ================================

Although all register reads are 32-bits in nature, not all registers make use of
the complete width. The detailed description of each Information Devices
registers is as follows:

- **Hardware ID**: A 32-bit value that uniquely identifies the hub. It has a
  similar format to the :ref:`Device ID <dev-id>`:

  ::

         Reserved(8-bit).Company(8-bit).Hub(16-bit)

  -  ``Reserved``: Reserved for future specification revision. Currently
     ignored.
  -  ``Company``: Any person, lab, institute, informal group, or company can
     communicate with Open Ephys in order to to obtain a unique 8-bit “Company”
     value, and thus be included in the automatic listings of existing ONI API
     implementations. Open Ephys is 0x00.
  -  ``Hub``: 16-bit Hub ID. This number usually identifies a physical product
     and would correspond to a stock keeping unit SKU or part number in a
     commercial setting. However, there is no formal restriction on these bits
     other than uniqueness.

- **Hardware revision**: A 16-bit value identifying changes in the hardware
  that do not affect the overall operation of the hub and, therefore, do not
  require a new ID. These are typically related to a PCB revision.

- **Firmware version**: A 16-bit value specifying firmware or gateware version
  of the main component driving the hub (e.g., an FPGA, microcontroller, or
  EEPROM for logic-free hubs).

- **Safe firmware version**: (Optional) For hubs that allow online updates of
  the firmware, 16-bit version of the fallback safe image, if any.

- **Hub clock frequency**: 32-bit value holding the frequency, in Hz, of the
  hub clock that drives the *Hub_Timestamp* passed to the devices.

- **Hub data latency**: 32-bit value representing the average latency, in
  nanoseconds, of the physical link between the hub and the controller. Usually
  0 in local hubs.

All 16-bit valued registers are in the format of:

::

       Major(8-bit).Minor(8-bit).

For example, 0x0103 would imply version 1.3. In the case of the information
device located on hub 0, the versions refer to the physical controller hardware
and its firmware, where that hub is located.

Heartbeat Device
~~~~~~~~~~~~~~~~
Local hub 0 must contain a “heartbeat device”. This is a simple device that
periodically produces :ref:`samples <dev-sample>` containing only the ``Hub
Timestamp`` and an empty payload, at a fixed rate of 100 Hz. Its ``ENABLE``
register must be fixed and always active. This device ensures that API calls
accessing the read stream are guaranteed to be unblocked in the case that no
other devices in the system are producing data.
