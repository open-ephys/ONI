.. _glossary:

Glossary of Terms
=================
Here we provide glossary of terms used terms in this specification. A complete
understanding of the term may require knowledge of interaction with other
elements and/or its context within the specification.

.. glossary::

  Acquisition Context

    .. note:: Can be abbreviated as "Context".

    A top-level :term:`API` element that holds acquisition state, a
    :term:`Device Table`, and :term:`Driver Translator` state in order to
    communicate with a single :term:`Controller`. A context is manipulated and
    interacted with using :term:`API` function calls, and ultimately affects
    hardware state over the :term:`Host Interconnect` via a :term:`Driver
    Translator`. Multiple contexts can coexist on a single host system and
    these may each use a different :term:`Driver Translator` and/or physical
    interface.

  API

    ONI application programming interface that can be used to develop software
    to aquire from and control ONI-conforming hardware.

    .. seealso:: :ref:`oni-api`

  Controller
    Hardware with a physical interface to the :term:`Host Computer` over a
    single :term:`Host Interconnect` using a :term:`Driver Translator` and
    ONI-compliant :term:`API` Multiple :term:`controllers <Controller>` can
    coexist in a single :term:`Host Computer` and need not use the same
    :term:`Driver Translator` Controllers communicate via :term:`API` calls
    that manipulate an :term:`Acquisition Context` and a :term:`Device Table` ,
    which affect controller state using via the driver translator. :term:`Hubs
    <Hub>` are connected to the controller where data to/from their devices is
    packed and transmitted to/from the host computer. The controller contains a
    main clock which provides a common timestamp to all incoming data, and that
    can be synchronized with other controllers.

    .. seealso:: :ref:`Controller Specification <controller>`

  Device
    A configurable piece of hardware with its own register address space
    (e.g. an integrated circuit) or a digital “core” that emulates this.
    Devices may or may not produce and/or accept :term:`streaming data <Stream
    Channel>` , but that must at least implement a minimal :term:`register
    programming channel <Register Channel>`. They must be documented, using a
    :term:`Device Datasheet`. Devices are the endpoints for most communication
    operations and often are the hardware interfacing with the physical
    environment.

    .. seealso:: :ref:`Device Specification <device>`

  Device Address
    A unique, 32-bit address for each device entry in a :term:`Device Table`.

    .. seealso:: :ref:`Device Address Specification <dev-address>`

  Device Datasheet
    Documentation for a device which describes how it generates and accepts
    data, if any, along with a guide for programming and reading registers.
    This might take the form of a manufacturer datasheet if all chip
    functionality is exposed via raw register access.

    .. seealso:: :ref:`Device Datasheet Specification <dev-datasheet>`

  Device Table
    A collection of :term:`device addresses <Device Address>` and corresponding
    metadata for all :ref:`devices <device>` governed by a :term:`controller
    <controller>`. The device table contains all meta-information required to
    for proper interaction with each device. E.g.  packet read-size, packet
    write-size, burst read cycles, etc.

    .. seealso:: :ref:`Device Table Specification <dev-table>`

  Driver Translator
    A small `device driver <https://en.wikipedia.org/wiki/Device_driver>`__
    translation library that converts abstract :term:`API` calls to
    hardware-specific system calls that affect the :term`Controller
    <controller>` over the :term:`Host Interconnect`.

    .. seealso:: :ref:`oni-api`

  Host Computer
    The computer supporting acquisition and processing from one or more
    :term:`controllers <Controller>` and running software implmented using the
    :term:`API`.

  Host Interconnect
    A hardware abstraction layer consisting of a physical bus (e.g. PCIe, USB,
    or Ethernet) along with a :term:`Driver Translator` that the
    :term:`Controller` uses to communicate with the :term:`Host Computer`.

  Hub
    A collection of :term:`Devices <Device>` that communicate with a
    :term:`Controller` over a :term:`Port` and sharing a common
    clock. All data acquired by :term:`devices <Device>` in the same Hub are
    timestamped by this clock. Different Hubs may be governed by asynchronous
    clocks. A Hub either forms a portion of the :term:`Device Table` or the
    entire :term:`Device Table` if it contains all the :term:`devices <Device>`
    within the :term:`Acquisition Context`. Hubs can be exist in separate
    hardware from the :term:`Controller` (remote hubs) or withing the
    :term:`Controller` (local hubs).

    .. seealso:: :ref:`Hub Specification <hub>`

  Port
    A `physical bus <https://en.wikipedia.org/wiki/Bus_(computing)>`__ between
    a :term:`Hub` and a :term:`Controller`. This could be an external link to
    a :term:`Hub` that is separated from the :term:`Controller` (e.g. a wire or
    wireless communication channel) or it could be a bus inside of the
    :term:`Controller` in the case of a local hub.
