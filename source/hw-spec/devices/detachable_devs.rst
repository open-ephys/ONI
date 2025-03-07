.. _detachable_devs:

Detachable Devices
====================

It is possible for a device implementation to be divided into two functional
components with unique responsibilities:

- A interfacing component, usually an IP module on a FPGA or a routine
  running in a microcontroller.

- One or more transducer component(s), driven by the former. For instance an
  active probe that is connected to the interfacing component with a detachable
  cable.

In these device configurations, the interfacing component is responsible for
implementing the ONI specification and performing the required signal
translations to communicate with the controller.

For devices that are constructed in this way, it is possible for transducer
component(s) to disconnect from the interfacing component. For instance when an
e.g.: an active probe that can be swapped.

In this case:

- The interfacing component MUST check for the presence of all required
  transducer elements

- If all are present, the interfacing component will present its :ref:`dev-desc`
  as normal.

- If a required transducer element is not present, the Device Descriptor
  will be a :ref:`null device descriptor<null-dev-desc>`

- A transducer element MAY be optional, as long as its absence does not modify
  the behavior described in the :ref:`dev-datasheet`.

- If specific transducer configurations are optional, the device SHOULD inform
  of its current configuration through its :ref:`dev-reg-map`.