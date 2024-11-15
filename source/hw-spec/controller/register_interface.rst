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

- ``Device Address``: The fully qualified address of a device as enumerated in
  the :ref:`device table <dev-table>` and to which communication will be
  directed as described below.

- ``Register Address``: The address of the register within the :ref:`register
  map <dev-reg-map>` of the device located at ``Device Address`` that will be
  written to or read from.

- ``Register Value``: Value to be written to the register ``Register Address`` 
  of device located at ``Device Address``. For compatibility with older versions
  of the specification, reading this register will return the value of the last
  successful read operation. Using this register for reading the value this way
  is not recommended.

- ``Read/Write``: A flag indicating if a read or write should be performed. 0
  indicates read operation. A value > 0 indicates write operation.

- ``Trigger``: Set > 0 to add either a register read or write operation
  depending on the state of ``Read/Write``. If ``Read/Write`` is 0, a read 
  operation is queued. If ``Read/Write`` is 1, an operation to write ``Register Value`` 
  to the register at ``Register Address`` on the device at ``Device Address`` is queued. 
  Reading the ``Triger`` register returns 0 if the queue is empty or 1 if there are
  pending operations.
   
Appropriate values of ``Register Address`` and ``Register Value`` are
determined by:

- Looking at a device's data sheet if the device is an integrated circuit and
  using :ref:`raw registers <reg-type>`.
- Examining the :ref:`ONI Device Datasheet <dev-datasheet>` for :ref:`managed
  registers <reg-type>`.

Register Read Sequence
-------------------------

When a host requests one of more device register *reads*, the following following sequence
must be performed:

1. Check the value of ``Trigger``.

   -  If it is 0, the queue is empty and the procedure can safely proceed.
   -  Else, there are transactions pending on the queue. Since the 
      exact number of pending elements is unknown, adding new transactions
      is not recommended.

2. For each register read transaction to be added to the queue:  

   1. The target device is selected by writing its address, as featured on the
      device map, into ``Device Address`` on the controller.
   2. The desired register address within the device register map is written into
      ``Register Address`` on the controller.
   3. The ``Read/Write`` register on the controller is set to 0x00.
   4. The ``Trigger`` register on the controller is set to 0x01, inserting the 
      operation on the queue.
   5. Repeat as needed until al read transactions have been queued.

3. For each element on the queue, the controller will:

   1. Route a register read operation to the appropriate device.
   2. Push ``CONFIGRACK`` followed by the read value into the signal stream if the
      operation was successful, or ``CONFIGRNACK`` if it failed.

4. The signal stream must be pumped until all ``CONFIGRACK`` or
   ``CONFIGRNACK`` corresponding to all the requested transactions
   are received indicating that the controller has finished execution.

Register Write Sequence
-------------------------

When a host requests one or more device register *writes*, the following following
sequence must be performed:

1. Check the value of ``Trigger``.

   -  If it is 0, the queue is empty and the procedure can safely proceed.
   -  Else, there are transactions pending on the queue. Since the 
      exact number of pending elements is unknown, adding new transactions
      is not recommended.

2. For each register write transaction to be added to the queue:

   1. The target device is selected by writing its address, as featured on the
      device map, into ``Device Address`` on the controller
   2. The desired register address within the device register map is written into
      ``Register Address`` on the controller.
   3. The ``Read/Write`` register on the controller is set to 0x01.
   4. The value to be written into the device register is written into 
      the ``Register Value``  register in the controller.
   5. The ``Trigger`` register on the controller is set to 0x01, inserting the 
      operation on the queue.
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