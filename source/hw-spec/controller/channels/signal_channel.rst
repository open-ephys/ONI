.. _sig-chan:

Signal Channel
===============

-  **Data alignment** : 8 bits
-  **Channel type** : Stream
-  **Direction** : Read

The *signal* channel provides a way for the controller to inform the host of
configuration results, which may be provided with a significant delay.
Additionally, it is the channel over which the controller sends the device table
to the host following a :ref:`system soft reset <soft-reset-reg>`. Signal data
MUST be framed into packets using Consistent Overhead Byte Stuffing (`COBS
<https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing>`__). Within
this scheme, packets are delimited using 0's and always have the following
format:

::

   ... | PACKET_FLAG, data0, data1, ..., data_k | ...

where ``PACKET_FLAG`` is 32-bit unsigned integer with a single unique bit
setting, ``|`` represents a packet delimiter (in this case, 0), “``,``” are for
visual clarity and are not actually in the data stream, and ``...`` represents
other packets. This stream can be read and ignored until a desired packet is
received. Reading this stream shall block if no data is available, which allows
asynchronous configuration acknowledgment. Valid ``PACKET_FLAG``\ s are:

============ ========== =====================================
Flag         Value      Description
============ ========== =====================================
NULLSIG      0x00000001 Null signal, ignored by host
CONFIGWACK   0x00000002 Configuration write-acknowledgment
CONFIGWNACK  0x00000004 Configuration no-write-acknowledgment
CONFIGRACK   0x00000008 Configuration read-acknowledgment
CONFIGRNACK  0x00000010 Configuration no-read-acknowledgment
DEVICETABACK 0x00000020 Device table start acknowledgment
DEVICEINST   0x00000040 Device descriptor instance
============ ========== =====================================

Following a :ref:`system soft reset <soft-reset-reg>`, the signal channel is
used to provide the :ref:`device table <dev-table>` to the host using the
following packet sequence:

::

   ... | DEVICETABACK, uint32 num_devices
       | DEVICEINST, uint32 dev_addr_0, device_descriptor dev_0
       | DEVICEINST, uint32 dev_addr_1, device_descriptor dev_1 |
       ...
       | DEVICEINST, uint32 dev_addr_n, device_descriptor dev_n | ...

Where ``dev_addr_n`` is the full address of each device as described in the
:ref:`device table <dev-table>` section and ``dev_n`` is a :ref:`device
descriptor <dev-desc>`.

In addition to providing the device table following soft reset, the signal
channel is also used to asynchronously acknowledge register access via the
:ref:`configuration channel <conf-chan>`. Following a device register read or
write, an CONFIGWACK, CONFIGWNACK, CONFIGRACK, or CONFIGRNACK signal is pushed
onto the signal stream by the controller to indicate the validity of the
transaction. Successful transactions will include the following timing 
fields:

- uint64 ``reg_time``: Time when this register access acknowledge was
  received by the controller. Based on the :ref:`acq_clk`.
- uint64 ``reg_hub_time``: Register access time as reported by
  the :ref:`device <dev-reg-time>`.

In the case of a successful read, the CONFIGRACK flag will also be
followed by the result of the read operation after the time fields. 
In all other cases, the flag will be sent with no additional data.

For instance, on a successful register read:

::

    ... | CONFIGRACK, uint64 reg_time, uint64 reg_hub_time, uint32 read_value | ...

While on a succesful register write:

::

    ... | CONFIGWACK, uint64 reg_time, uint64 reg_hub_time | ...

And on a failed register read or write 

::

    ... | CONFIGRNACK | ...
    ... | CONFIGWNACK | ...

