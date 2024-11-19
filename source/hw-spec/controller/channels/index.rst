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

These channels are implemented by the combination of the controller hardware and the :term:`Driver Translator`.

Concurrent access to a single channel by the host (e.g. by multiple threads of execution or applications) is 
NOT permitted. However, individual channels MUST be able to be accessed independently.

.. note:: Concurrent access requirements relate only to the hardware implementation. Functions in 
   a high-level :term:`API` MAY introduce their own access dependencies and concurrency limitations.

The required characteristics of the controller channels are described in the following
sections.

.. toctree:: 
   :hidden:

   data_frames
   read_channel
   write_channel
   signal_channel
   configuration_channel
   

