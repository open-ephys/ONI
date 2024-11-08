.. _data-rd-chan:

Read Channel
=============

-  **Data alignment** : 8 bits
-  **Channel type** : Stream
-  **Direction** : Read

The *read* channel provides high bandwidth communication from the controller to
the host computer. Data from the read stream of all devices that support it is
aggregated and multiplexed by the controller and sent to the host through this
channel in the form of :ref:`frame`.

Data should be pushed to this channel as quickly as possible. It is the
responsibility of the host computer to read data from the stream quickly enough
to keep up with data production by the controller. Therefore, it is highly
recommended that an ONI system implements some kind of internal buffering to
ameliorate the effects of uneven reading times caused by computer operating
systems or other software limitations.

.. _read-word-alignment:

Read word alignment
---------------------

Hardware implementations of controllers might require a :ref:`word size<read-word-alignment-reg>`
greater than 8 bits. In that case, the controller is required to increase the ``Read_Sample_Size`` 
values of all devices on the :ref:`dev-table` so they fit into the required
word alignment. Extra bytes after the size defined on the :term:`Device Datasheet`
will be padded with 0xFF.