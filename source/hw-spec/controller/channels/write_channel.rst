.. _data-wr-chan:

Write Channel
==============

-  **Data alignment** : 8 bits
-  **Channel type** : Stream
-  **Direction** : Write

The *write* channel provides high bandwidth communication from the host computer
to the controller, and is used to send data to the devices.

Data is sent through :ref:`frame` with their respective ``Common_Timestamp`` field
set to 0. Multiple samples can be sent in a single write frame. In this case, the
``Sample_Size`` field will be equal to the ``Write_Sample_Size`` multiplied by the
number of sent samples.

It is the responsibility of the controller to accept frames at any rate the
computer might be sending them. Currently, there is no defined mechanism to
inform the host of any possible dropped frame on the write channel,
although this can be included in an implementation so long as it does not
invalidate any other ONI requirements.

.. _write-word-alignment:

Write Word Alignment
---------------------

Hardware implementations of controllers might require a :ref:`word
size<write-word-alignment-reg>` greater than 8 bits. In this case
the host MUST add after every frame transmission, single- or multi-sample,
as many padding bytes with the value 0xFF as needed to comply with alignment 
requirements. No other modifications to frame transmission must occur.

.. note:: Contrary to the :ref:`Read Channel<read-word-alignment>`,
    word alignment requirements on the Write Channel do not entail 
    any modification of the ``Write_Sample_Size`` field of the :ref:`dev-desc`.
