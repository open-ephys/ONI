.. _dev-sample:

Device Sample Format
=====================

Data passed over the read or write streams are transmitted in unit packets,
or “samples”. A sample transmitted over the read stream MUST have the following
format:

::

    uint64    Hub_Timestamp (Read Stream Only)
    var       Payload

- ``Hub_Timestamp``: For samples produced by the device and sent to the read
  stream, this is a common counter for all devices in a :ref:`Hub <hub>`,
  indicating the time of sample capture. For samples consumed by the device
  from the write stream, this value is reserved.
- ``Payload``: Device-specific data.

  -  For :ref:`read streams <com-channels>`, this data must be of :ref:`Read Sample
     Size <dev-desc>` - 8.
  -  For :ref:`write streams <com-channels>`, this data must be of :ref:`Write Sample
     Size <dev-desc>`. Thus, the whole sample packet fits into the sample
     size specified in the :ref:`device descriptor <dev-desc>`.