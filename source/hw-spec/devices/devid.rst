.. _dev-id:

Device ID
=========
Device implementations MUST declare a unique identification integer called a
Device ID. Devices sharing an ID are assumed to be the same and share the same
:ref:`dev-datasheet`. Device IDs are 32-bit integers with the following format:

::

    Reserved(8-bit).Company(8-bit).Device(16-bit)

- ``Reserved``: Reserved for future specification revision. Currently ignored.
- ``Company``: Any person, lab, institute, informal group, or company can
  communicate with Open Ephys in order to to obtain a unique 8-bit “Company”
  value, and thus be included in the automatic listings of existing ONI API
  implementations. Open Ephys is 0x00.
- ``Device``: 16-bit Device ID. This number identifies not only the type of
  data produced or consumed by a device, but also a particular implementation.
  For instance, the same sensor will have a unique Device ID for each digital
  module implementation that is used to communicate with it. This number can
  optionally be divided in two 8-bit values so long as the resulting 16-bit
  integer is unique within a particular “Company” (there is no need for unary
  or monotonic increments when new devices are introduced).


.. _null-dev-id:

Null Device ID
----------------
A special case is reserved for a device ID of 0.0.0. This identifies a
null device, which represents a non-present or non-functional device.