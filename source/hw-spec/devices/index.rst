.. _device:

Devices
=======
Devices are the endpoint of most ONI transactions. They can represent a
physical element interfacing with the environment (e.g., an external sensor with
a digital communication interface), something programmed within the firmware to
emulate this (e.g., a digital logic module on an FPGA) or a purely internal data
source (e.g., a controller based digital logic module that generates system
status reports). A device exposes a set of :ref:`communication channels
<com-channels>`:

- It MUST expose a register interface
- It MAY expose a read stream
- It MAY expose a write stream

Communication over streams MUST follow a specific :ref:`sample format
<dev-sample>`, while the register interface must comply with a specific bus
communication cycle. Details on each are provided in following sections. Device
developers MUST provide a :ref:`datasheet <dev-datasheet>` describing the
register map, stream data format, along with general behavior of the device in
order to reach ONI-compliance.

.. toctree:: 
   :hidden:

   devid
   descriptor
   sample
   registers
   datasheet
   special
