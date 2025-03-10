.. _null-device:

Null Device
=============

The :ref:`dev-table` MAY include addresses that do not represent a functional
:ref:`Device<device>`. Possible cases are:

- An address reserved for a device currently not present or active on the 
  system
- A :ref:`Detachable Device<detachable_devs>` lacking a required transducer
  element
- A non-functional device due to an error or issue
- An address intentionally left empty by the :ref:`Hub<hub>` developer 

In summary, a representation of a non-present or non-functional device.

This is done by filling the address' :ref:`Device Descriptor<dev-desc>`
with a Null Device. This descriptor is represented by a :ref:`dev-id`
of 0.0.0.0. All other fields on the descriptor MUST be 0.

A Null Device:

- MUST NOT consume of produce any kind of data. 
- MUST NOT implement any register interface.
- Any attempt to access a Null Device MUST return the same error as accessing
  a non-existing device or register.

.. note:: The last two points imply an exception to the requirement for a 
    :ref:`Register Interface<dev-register>`. This exception
    is justified because a Null Device is not an actual device but a 
    representation of the absence of one.

