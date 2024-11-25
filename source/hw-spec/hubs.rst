.. _hub:

Hubs
====

Devices MUST be grouped in logical or physical collections, called Hubs. 
They can be independent hardware aggregates connected to the controller 
(e.g. a headstage for neural acquisition) or a logical partition of existing hardware 
(e.g. a collection of devices implemented in the same firmware as the controller). 

Every hub MUST have access to a counter driven by a high resolution clock. 
All devices within a hub MUST use the values of this counter for the the 
``hubclk_cnt`` field of their :ref:`data samples <dev-sample>`.

Hubs that exist on hardware that is physically separated from the :ref:`controller <controller>` are
referred to as remote hubs, while hubs existing on the controller are local hubs.
An ONI-compliant system MUST implement at least one local hub, located at
:ref:`Hub_Index 0 <dev-address>` and sharing the clock of controller's main
state machine, and can implement up to 253 additional hubs, local or remote. All
devices reflecting or modifying the :ref:`controller <controller>` state and/or 
reporting errors or similar status messages must be implemented in local hub 0.

Data from all the devices of a hub is collected and passed to the controller.
The specific interface between a hub and the controller is highly
implementation-dependent and, thus, not in the scope of this document. In
any case, it is the duty of the hub to provide the controller with all the
device descriptors and communication channels in a transparent manner. It is
common for a remote hub to feature a centralized IC (e.g., an FPGA or
microcontroller) integrating the device controllers and communication interface
to fill this duty, but other schemes are possible.

.. _hub_id:

Hub Hardware ID
----------------

Multiple hubs are differentiated through a unique identifier, or Hardware ID.
This identifier represents a specific implementation of a hub, defined by a
particular collection of devices on a specific hardware platform communicating
with the controller through a specific link. Changes in the device collection,
the communications link or the general hardware architecture require a new
identifier.

Hub Hardware IDs are 32-bit values with the following format:

::

        Reserved(8-bit).Company(8-bit).Hub(16-bit)

- ``Reserved``: Reserved for future specification revision. Currently
  ignored.
- ``Company``: Any person, lab, institute, informal group, or company can
  communicate with Open Ephys in order to to obtain a unique 8-bit “Company”
  value, and thus be included in the automatic listings of existing ONI API
  implementations. Open Ephys is 0x00.
- ``Hub``: 16-bit Hub ID. This number usually identifies a physical product
  and would correspond to a stock keeping unit SKU or part number in a
  commercial setting. However, there is no formal restriction on these bits
  other than uniqueness.

.. _hub-datasheet:

Hub Datasheet
---------------
All ONI-compliant hubs MUST have a corresponding datasheet that provides
information on its devices and connectivity. The datasheet must be served
publicly. It can be a text file, PDF, or website. The required datasheet
sections and information are described below.

Preamble
~~~~~~~~
The following information MUST be included in the preamble:

1. **Informal Hub Name**: Name of the hub. This field MUST contain only alphanumeric
   characters and punctuation marks (i.e. ``?!*+-_~.()``). Other characters, including special
   characters MUST NOT be used (e.g., Headstage64, Neuropixels2.0e, are
   all valid).
2. **Author(s)**: Hub creator(s). Can be a person/people or
   a company, group, or organization.
3. **Hub Hardware ID**: The :ref:`hub ID<hub_id>` that this datasheet corresponds
   to.
4. **Connection Type**: MUST be ``local`` for local hubs or ``remote`` for remote hubs.
5. **Notes**: Other relevant information for the hub not covered by this specification.
   For remote hubs, this field SHOULD include some description of the physical 
   connection to the controller.

Device Map
~~~~~~~~~~~
The datasheet MUST include a map of the devices included on it. It must include 
the following information:

1. **Device Index**: 0-based index of the device within the hub
2. **Device ID**: :ref:`Device ID<dev-id>`.
3. **Informal Device Name**: Device name as stated on its :ref:`datasheet<dev-datasheet>`.

The special :ref:`Hub Information Device<hub_info_dev>` SHOULD NOT appear on this table,
as its existence is mandatory and assumed.

Hardware Specific Registers
-----------------------------
 
If the hub implements :ref:`hardware specific registers<hub_addr_hw_specific>`
on its :ref:`Hub Information Device<hub_info_dev>`, the datasheet MUST include
a complete list and description of these.

Any complex procedure regarding these registers (e.g. firmware update procedures)
SHOULD be documented in this section.

