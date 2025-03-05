.. _detachable_devs:

Detachable Devices
====================

A possible configuration for a device is for it to be divided in:

- One driver part, usually an IP module on a FPGA or a routine 
  running in a microcontroller.

- One or more hardware elements, driven by the former.

In these configurations, the driver takes the responsibility of
implementing the ONI specification and performing the required
signal translations to communicate with the hardware.

A possibility in configurations of this type is for the hardware
elements to be physically detachable from the driver part 
(e.g.: a circuit driving an active probe that can be swapped).
In these cases:

- The driver MUST check for the presence of all required hardware elements

- If all are present, the driver will present its :ref:`dev-desc` as normal.
  
- If a required hardware element is not present, the Device Descriptor 
  will be a :ref:`null device descriptor<null-dev-desc>`

- A hardware element MAY be optional, as long as its absence does not 
  modify the behavior described in the :ref:`dev-datasheet`.

- If specific hardware configurations are optional, the device SHOULD 
  inform of its current configuration through its :ref:`dev-reg-map`.