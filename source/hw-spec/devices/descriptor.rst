.. _dev-desc:

Device Descriptor
==================

A device MUST expose a descriptor that is read by the :ref:`controller
<controller>` following a reset and that is incorporated into the :ref:`device
table <dev-table>`. The descriptor must contain the following information:

::

    uint32    Device_ID
    uint32    Device_Version
    uint32    Read_Sample_Size
    uint32    Write_Sample_Size

- ``Device_ID``: :ref:`As previously described <dev-id>`.
- ``Device_Version``: A version number to distinguish between implementations
  of a singular device type. Different versions  MUST
  NOT change the device's sample data format or alter an existing register
  map. However, register additions that do not affect the existing register map
  are allowed. Any change that warrants a modification of a device's streaming
  data format, read size, write size, or existing register map MUST be
  implemented as a new :ref:`Device ID <dev-id>`.
- ``Read_Sample_Size``: The length in bytes of a single :ref:`device sample
  <dev-sample>` produced by the device and sent to the :ref:`read stream
  <com-channels>`.
- ``Write_Sample_Size``: The length in bytes of a single :ref:`device
  sample <dev-sample>` consumed by the device from the :ref:`write stream
  <com-channels>`.