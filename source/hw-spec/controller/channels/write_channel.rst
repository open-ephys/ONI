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

Hardware implementations of controllers might require a :ref:`word size<write-word-alignment-reg>`
greater than 8 bits. In that case, the host will keep the specified sample sizes and just add
padding bytes with the value 0xFF at the end of a frame to align with the required word size.
The controller must ignore this padding bytes.