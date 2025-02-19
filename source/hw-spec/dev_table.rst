.. _dev-table:

Device Table
============
The collection of :ref:`devices <device>` governed by a :ref:`controller
<controller>` is referred to as a device table. The :ref:`controller
<controller>` is responsible for creating the device table and sending it to the
host following a reset. The device table is a read-only associative array
of (:ref:`device address <dev-address>`, :ref:`device descriptor <dev-desc>`)
pairs.

.. flat-table:: Example Device Table
   :header-rows: 1

   * - :ref:`Device Address <dev-address>`
     - :cspan:`4` :ref:`Device Descriptor <dev-desc>`
   * -
     - ID
     - Version
     - Read Sample Size (bytes)
     - Write Sample Size (bytes)
   * - 0.0.0
     - 0.0.12
     - 1.0
     - 8
     - 0
   * - 0.0.1
     - 0.0.27
     - 2.0
     - 26
     - 8
   * - 0.1.0
     - 0.0.12
     - 1.0
     - 8
     - 0

.. note:: The Read Sample Size (``rd_samp_size``) within a :ref:`dev-desc` in the device table might
   be larger than indicated on corresponding device datasheet's :ref:`dev-datasheet-read-format` due to adjustments required to comply to specific
   :ref:`hardware word size requirements<read-word-alignment>`. In this case,
   the host should ignore these extra bytes and decode the data as specified on
   the datasheet.

.. _dev-address:

Device Address
--------------
Each :ref:`device descriptor <dev-desc>`  in the device table is associated with
a unique device address. The device address is a 32-bit number with the
following format:

::

       Reserved(16-bit).Hub_Index(8-bit).Device_Index(8-bit)

* ``Reserved``: Reserved bits. Must be all zeros.
* ``Hub_Index``: The index of the :ref:`hub <hub>` within the :ref:`controller
  <controller>` that the device is managed by.
* ``Device_Index``: A unique index of each device within its :ref:`hub <hub>`.
  A valid ``Device_Index`` ranges from 0 to 0xFD. 0xFE is reserved and 0xFF
  indicates an invalid device.
