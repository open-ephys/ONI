.. _special-devs:

Special Devices
================
There are two kinds of special devices that are required by this specification.
These devices are tied to specific :ref:`hubs<hub>`. The required devices are:

- An :ref:`hub_info_dev` on each hub
- A :ref:`hub_heartbeat` in local hub 0.

.. _hub_info_dev:

Information Device
--------------------
Every hub in an ONI system MUST feature a special device, located at
:ref:`Device_Index <dev-address>` 0xFE, which supplies information
about the hub. Because this device is required to exist at a fixed address, it
is not listed in the device table and, thus, has no :ref:`device descriptor
<dev-desc>`.  It MUST expose the register interface, and it MUST NOT include
any streams. The register map is divided in two ranges:

- :ref:`hub_addr_common`: 0x00000000 - 0x00007FFF
- :ref:`hub_addr_hw_specific`: 0x00008000 - 0xFFFFFFFF

.. _hub_addr_common:

Common Registers
^^^^^^^^^^^^^^^^^^^^^^

**Address Range:**  0x00000000 - 0x00007FFF

The registers in this block provide general information about the hub.
All Hub Information Devices MUST provide the following registers:

========== ================================
Address    Register
========== ================================
0x00000000 HUB_HW_ID
0x00000001 HUB_HW_REV
0x00000002 HUB_FW_VER
0x00000003 HUB_SAFE_FW_VER
0x00000004 HUB_CLK_HZ
0x00000005 HUB_TX_LATENCY
0x00000006 HUB_ONI_SPEC_VER
========== ================================

Although all register reads are 32-bits in nature, not all registers make use of
the complete width. The detailed meaning of each register is:

- ``HUB_HW_ID``: :ref:`hub_id`.

- ``HUB_HW_REV``: Hardware revision. A 16-bit value identifying changes in the
  hardware that do not affect the overall operation of the hub and, therefore,
  do not require a new ID. These are typically related to a PCB revision.

- ``HUB_FW_VER``: Firmware version. A 16-bit value specifying firmware or
  gateware version of the main component driving the hub (e.g., an FPGA,
  microcontroller, or EEPROM for logic-free hubs).

- ``HUB_SAFE_FW_VER``: Safe firmware version. Hubs MAY allow online updates of
  their firmware and MAY include a fallback safe image as update protection. If
  such an image is available, this register contains its 16-bit version. If not
  applicable, this register must read 0xFFFFFFFF.

- ``HUB_CLK_HZ``: Hub clock frequency. 32-bit value holding the frequency, in
  Hz, of the hub clock that drives the *Hub_Timestamp* passed to the devices.

.. _hub_tx_latency:

- ``HUB_TX_LATENCY``: Data transmission latency. 32-bit value representing the
  average latency, in nanoseconds, of the physical link between the hub and the
  controller. Usually 0 in local hubs.

- ``HUB_ONI_SPEC_VER``: ONI specification version. Specifies the version of the
  ONI specification the hub adheres to. Format is:

  ::

    Major(8-bit).Minor(8-bit).Patch(8-bit).Reserved(8-bit)

Other addresses in this block are reserved and MUST NOT be used.

All 16-bit versions are in the format:

::

  Major(8-bit).Minor(8-bit).

For example, 0x0103 indicates version 1.3.

In the case of the information device located on hub 0, the versions MUST refer
to the physical controller hardware and its firmware, where that hub is located,
while ``HUB_CLK_HZ`` MUST be equivalent to the ``ACQ_CLK_HZ`` :ref:`controller
register<address_global>`.

.. _hub_addr_hw_specific:

Hardware Specific Registers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Address Range:**  0x00008000 - 0xFFFFFFFF

This address range contains registers that are specific for the hardware
implementation of the hub (e.g., firmware update registers, buffer memory
status, etc...)

A detailed list of the registers of each hub MUST be available on their
:ref:`datasheet<hub-datasheet>`.

.. _hub_heartbeat:

Heartbeat Device
------------------
Local hub 0 MUST contain a “heartbeat device”.  It MUST expose the register
interface and read stream, and it MUST NOT expose a write stream. This is a
simple device that periodically produces :ref:`samples <dev-sample>` containing
only the ``hubclk_cnt`` and an empty payload, at a fixed rate of 100 Hz. Its
``ENABLE`` register must be read-only and always active. This device ensures
that API calls accessing the read stream are guaranteed to be unblocked in the
case that no other devices in the system are producing data.

Other, identical heartbeat devices but with configurable ``ENABLE`` and data
rate MAY exist as part of any hub.
