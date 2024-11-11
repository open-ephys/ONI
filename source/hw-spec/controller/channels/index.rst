.. _controller_channels:

Controller Communication Channels
==================================

Communication between the controller and the host computer shall occur over
four abstract communication channels:

#. :ref:`data-rd-chan`: Read-only, high-bandwidth stream of device output :ref:`samples<frame>` from
   controller to host.
#. :ref:`data-wr-chan`: Write-only, high-bandwidth stream of device input :ref:`samples<frame>` from
   host to controller.
#. :ref:`sig-chan`: Read-only stream of short-messages and asynchronous hardware
   events from controller to host.
#. :ref:`conf-chan`: Bidirectional, addressed access to device registers.

API access to all these channels is blocking, i.e.: an API call that accesses
any channel will not return until the requested transaction on that channel is
complete. Concurrent access to a single channel by different threads is NOT
permitted. However, channels are independent and concurrent access to
*different* channels MUST be permitted. A stream transaction is defined as a
blocking read or write of a set number of bytes, while a register transaction
is defined as a single register read or write cycle to an individual address.

The required characteristics of these channels are described in the following
sections. A complete understanding of their use during software development
requires an understanding of the :ref:`oni-api`.

.. toctree:: 
   :hidden:

   data_frames
   read_channel
   write_channel
   signal_channel
   configuration_channel
   

