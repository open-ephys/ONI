.. _com-channels:

Channel Types
=============
This standard defines two types of communication channels that are used across
the system:

.. glossary::

  Stream Channel
    A unidirectional, asynchronous channel of continuous, N-bit word data along
    with a signal indicating if it is ready to send/receive data. Two
    directions are defined:

    :Read:  Streams that transmit data from a device to the host computer
    :Write: Streams that transmit data to a device from the host computer

  Register Channel
    A synchronous, bidirectional, N-bit, addressed digital bus. Each address is
    a 32-bit value. Registers can be Read-only, Write-only or Read-Write. This
    channel also has signals to indicate a successful or failed completion of a
    register access operation. (e.g. An access to an non-existent address or a
    non-allowed operation will return an error.)

