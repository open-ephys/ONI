.. _dev-desc:

Device Descriptor
==================

A device MUST expose a descriptor that is read by the :ref:`controller
<controller>` following a reset and that is incorporated into the :ref:`device
table <dev-table>`. The descriptor must contain the following information:

::

    uint32    device_id
    uint32    device_ver
    uint32    rd_samp_size
    uint32    wr_samp_size

- ``device_id``: :ref:`dev-id`.
- ``device_ver``: Device version. A version number to distinguish between
  implementations of a singular device type. Different versions  MUST NOT change
  the device's sample data format or alter an existing register map. However,
  register additions that do not affect the existing register map are allowed.
  Any change that warrants a modification of a device's streaming data format,
  read size, write size, or existing register map MUST be implemented as a new
  :ref:`Device ID <dev-id>`.
- ``rd_samp_size``: Read sample size. The length in bytes of a single
  :ref:`device sample <dev-sample>` produced by the device and sent to the
  :ref:`read stream <com-channels>`. This value must be *at least* as a large as
  the number of bytes in the Device Sample indicated by the
  :ref:`dev-datasheet-read-format`.
- ``wr_samp_size``: Write sample size. The length in bytes of a single
  :ref:`device sample <dev-sample>` consumed by the device from the :ref:`write
  stream <com-channels>`.This value must be *at least* as a large as the number
  of bytes in the Device Sample indicated by the
  :ref:`dev-datasheet-write-format`.

