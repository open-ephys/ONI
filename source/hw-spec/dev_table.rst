.. _dev-table:

Device Table
============
The collection of :ref:`devices <device>` governed by a :ref:`controller
<controller>` is referred as a device table. The :ref:`controller <controller>`
is responsible for creating this aggregate and sending it to the computer
following a reset. The table consists of an :ref:`addressed <dev-address>` list
of :ref:`device descriptors <dev-desc>`.

.. list-table:: Example Device Table
   :header-rows: 1

   * - Address
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

.. _dev-address:

Device Address
--------------
Each :ref:`device descriptor <dev-desc>` entry in the device table requires a
device address. This is is a unique, 32-bit number with the following format:

::

       Reserved(16-bit).Hub_Index(8-bit).Device_Index(8-bit)

* ``Reserved``: Reserved bits. Must be all zeros.
* ``Hub_Index``: The index of the :ref:`hub <hub>` within the :ref:`controller
  <controller>` that the devie is managed by.
* ``Device_Index``: A unique index of each device within its :ref:`hub <hub>`.
  A valid ``Device_Index`` ranges from 0 to 0xFD. 0xFE is reserved and 0xFF
  indicates an invalid device.
