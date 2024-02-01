.. title:: Home

.. toctree::
   :hidden:
   :maxdepth: 2
   :titlesonly:

   hw-spec/index
   api/index

========================================
Open Neuro Interface
========================================
ONI is a hardware specification and API that facilitiates the creation of
tools for neural data acquisition. This standard allows the creation of neural
recording devices that support **arbitrary mixtures of sensors, probes, and
actuators**. The hope is that ONI will streamline the development of new
hardware for neural data acquisition and guarantee interoperability between
ONI-compliant hardware and software. We also hope that the use of common
protocols will allow easy integration of disparate hardware to develop rich
feedback control loops for neuroscience projects. If you are interested in
developing against this specification (e.g. for a miniscope, headstage,
position tracker, 2P microscope, etc) or improving it, we would love to `hear
from you <https://open-ephys.org/contact>`__ and talk about the best way to
proceed.

Specification Goals
===================
- Potential for low latency round trip times with a computer in the loop
- Potential for high-bandwidth, bidirectional communication (thousands of
  neural data channels; multiple high-resolution cameras)
- Acquisition and control of arbitrary hardware components using a common
  computer interface

  - Support generic mixes of data sources and sinks from multiple,
    asynchronous pieces of hardware
  - Generic, system-wide hardware configuration
  - Generic, system-wide, bidirectional data streaming

- Hardware synchronization of multiple systems on a single host computers or
  across multiple host computers
- Cross platform
- Aimed at the creation of interoperable physical devices, gateware, firmware,
  and APIs

Contents
--------

:ref:`oni-hw`
    Create ONI-compliant hardware.

:ref:`oni-api`
    Create software for controlling ONI-compliant hardware.

Contributing
------------
The main branch contains the stable version of the specification. The unstable
work in progress version can be found in the branch indicating the version.

