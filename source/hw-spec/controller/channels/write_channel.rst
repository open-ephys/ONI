.. _data-wr-chan:

Write Channel
==============

-  **Data alignment** : 8 bits
-  **Channel type** : Stream
-  **Direction** : Write

The *write* channel provides high bandwidth communication from the host computer
to the controller, and is used to send data to the devices.

Data is sent as a sequence of :ref:`frame` with their ``Common_Timestamp`` field
set to 0. Multiple :ref:`device samples <dev-sample>` can be sent in a single
write frame. In this case, the ``Sample_Size`` field will be equal to the
``Write_Sample_Size`` multiplied by the number of sent samples.

A compliant implementation of this channel requires the following:

- The controller MUST accept all frames sent by the host, at any rate that does
  not exceed the maximal channel bandwidth, which will be
  implementation-defined.

- The controller MUST send all frames received to the destination devices in the
  same order it receives frames from the computer

- Devices that accept data from the write channel MAY buffer it. A device's
  :ref:`dev-datasheet` MUST specify if data is buffered and if there is any
  possibility of dropping frames (e.g: receiving a frame while one is being
  processed)

.. _write-chan-sync:

- Devices that accept data from the write channel MAY inform the host about
  their internal state so a host application can adjust the production rate of
  write frames accordingly. If used, this mechanism MUST use existing channels
  (e.g. Register or Read channels), MUST NOT directly affect the operation of
  the Write channel and MUST be described on the :ref:`dev-datasheet`.

In summary, the Write Channel's sole responsibility is passing frames to devices.
The Write channel is not required to provide any auxiliary signals about its
internal state, specific frame delivery timestamps or any other operational
details.

.. _write-word-alignment:

Write Word Alignment
---------------------

Hardware implementations of controllers might require a :ref:`word
size<write-word-alignment-reg>` greater than 8 bits. In that case, the host will
keep the specified sample sizes and just add padding bytes with the value 0xFF
at the end of a frame to align with the required word size. The controller must
ignore these padding bytes.