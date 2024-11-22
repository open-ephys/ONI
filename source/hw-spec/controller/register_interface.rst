.. _register_interface:

Device Register Programming Interface
======================================

The device programming interface allows transparent access to each device's
:ref:`register map <dev-reg-map>`. It defines a general purpose bus that hides
the specifics of any particular implementation. 

Using this interface, the host adds device register access requests to an internal 
queue. The controller will execute the requests in order. The :term:`Driver Translator`
and :term:`API` must ensure that the number of pending requests in the does not
exceed the :ref:`maximum queue size<max-devaccess-reg>`.

The register programming interface is composed of the following
:ref:`conf-chan` registers, which are used to insert requests into the queue:

- ``RI_DEV_ADDR``: Device Address. The fully qualified address of a device as 
  enumerated in the :ref:`device table <dev-table>` and to which communication 
  will be directed as described below.

- ``RI_REG_ADDR``: Register Address. The address of the register within 
  the :ref:`register map <dev-reg-map>` of the device located at ``RI_DEV_ADDR`` 
  that will be written to or read from.

- ``RI_REG_VAL``: Register Value. Value to be written to the register 
  ``RI_REG_ADDR`` of device located at ``RI_DEV_ADDR``. For compatibility with 
  older versions of the specification, reading this register will return the value 
  of the last successful read operation. Using this register for reading the value 
  this way is not recommended.

- ``RI_RW``: Read/Write. A flag indicating if a read or write should be performed. 0
  indicates a read operation. A value of 0x00000001 indicates a write operation.

- ``RI_TRIGGER``: Trigger. Set to 0x00000001 to add either a register read or write
  operation depending on the state of ``RI_RW``. If ``RI_RW`` is
  0x00000000, a read operation is queued. If ``RI_RW`` is 1, an operation
  to write ``RI_REG_VAL`` to the register at ``Ri_REG_ADDR`` on the
  device at ``RI_DEV_ADDR`` is queued. Reading the ``RI_TRIGGER`` register
  returns 0x00000000 if the queue is empty or 1 if there are pending operations.
   
Appropriate values of ``RI_REG_ADDR`` and ``RI_REG_VAL`` are
determined by:

- Looking at a device's data sheet if the device is an integrated circuit and
  using :ref:`raw registers <reg-type>`.
- Examining the :ref:`ONI Device Datasheet <dev-datasheet>` for :ref:`managed
  registers <reg-type>`.

Register Read Sequence
-------------------------

When a host requests one of more device register *reads*, the following following sequence
must be performed:

1. Check the value of ``RI_TRIGGER``.

   -  If it is 0x00000000, the queue is empty and the procedure can safely proceed.
   -  Else, there are transactions pending on the queue. Since the 
      exact number of pending elements is unknown, adding new transactions
      is not recommended.

2. For each register read transaction to be added to the queue:

   1. The target device is selected by writing its address, as featured on the
      device map, into ``RI_DEV_ADDR`` on the controller.
   2. The desired register address within the device register map is written
      into ``RI_REG_ADDR`` on the controller.
   3. The ``RI_RW`` register on the controller is set to 0x00000000.
   4. The ``RI_TRIGGER`` register on the controller is set to 0x00000001, inserting
      the operation on the queue.
   5. The host repeats steps 1-4 as needed until all read transactions have been
      queued.

3. For each element on the queue, the controller will:

   1. Route a register read operation to the appropriate device.
   2. Push ``CONFIGRACK`` followed by the read value into the signal stream if the
      operation was successful, or ``CONFIGRNACK`` if it failed.

4. The signal stream must be pumped until all ``CONFIGRACK`` or
   ``CONFIGRNACK`` corresponding to all the requested transactions
   are received indicating that the controller has finished execution.

Register Write Sequence
-------------------------

When a host requests one or more device register *writes*, the following
sequence must be performed:

1. Check the value of ``RI_TRIGGER``.

   -  If it is 0x00000000, the queue is empty and the procedure can safely proceed.
   -  Else, there are transactions pending on the queue. Since the 
      exact number of pending elements is unknown, adding new transactions
      is not recommended.

2. For each register write transaction to be added to the queue:

   1. The target device is selected by writing its address, as featured on the
      device map, into ``RI_DEV_ADDR`` on the controller
   2. The desired register address within the device register map is written
      into ``RI_REG_ADDR`` on the controller.
   3. The ``RI_RW`` register on the controller is set to 0x00000001.
   4. The value to be written into the device register is written into 
      the ``RI_REG_VAL``  register in the controller.
   5. The ``RI_TRIGGER`` register on the controller is set to 0x00000001, inserting
      the operation on the queue.
   6. Repeat as needed until al read transactions have been queued.

3. For each element on the queue, the controller will:

   1. Route a register write operation to the appropriate device.
   2. Push ``CONFIGWACK`` into the signal stream if the operation was successful, 
      or ``CONFIGRNACK`` if it failed.

4. The signal stream must be pumped until all ``CONFIGWACK`` or
   ``CONFIGWNACK`` corresponding to all the requested transactions
   are received indicating that the controller has finished execution.

Following successful or unsuccessful device register read or write, the
appropriate ACK or NACK packets *must* be passed to the :ref:`signal channel
<sig-chan>` by the controller. If they are not, the register read and write
calls will block indefinitely.