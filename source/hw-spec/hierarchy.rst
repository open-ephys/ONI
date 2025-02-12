.. _ONI-hierarchy:

Hardware Topology
=========================
Any ONI-compliant system is comprised of at least three hierarchical hardware
elements:

- :ref:`Controller <controller>`

  - :ref:`Hub <hub>`

    - :ref:`Device <device>`

These hardware elements are managed within a single host computer where they are
governed by a single :term:`Acquisition Context`. An ONI system is arranged in a
`tiered-star network <https://en.wikipedia.org/wiki/Network_topology>`__ similar
to that of USB, which is shown here:

::

       Host Computer [Uses API and Driver Translator to communicate with Controller]
       |...||
       |   || Host Interconnect 0
       |   ||
       |   |+-- Controller 0 [Governed by a Context & generates a Device Table]
       |   |    |
       |   |    | Port Interconnect 0
       |   |    |
       |   |    +-- Hub 0
       |   |    |   |
       |   |    |   +-- Device 0.0.0 (Host.Hub.Device)
       |   |    |   +-- Device 0.0.1
       |   |    |   +-- ..
       |   |    |   +-- Device 0.0.N
       |   |    |
       |   |    +-- Hub 1
       |   |    ·
       |   |    ·
       |   |    ·
       |   |    +-- Hub M
       |   |
       |   | Host Interconnect 1
       |   |
       |   + Controller 1
       ·
       ·
       ·
       |
       | Host Interconnect P
       |
       +--- Controller P

An ONI-compliant hardware system must have at least a single Host, a single
Controller, a single Hub, and a single Device. Hubs can be physically separate
hardware elements that communicate with the controller, or can share the same
hardware. For instance, an FPGA can run the controller logic, contain a hub with
local devices, and connect to external hubs through a digital link. Device
groups operating in different clock domains, even if they lie in the same
physical hardware, must form independent hubs.
