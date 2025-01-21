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

    :Read:  Streams that transmit data from a device to the host computer.
    :Write: Streams that transmit data to a device from the host computer.

  Register Channel
    A synchronous, bidirectional, addressed digital bus to access :term:`registers<Register>`.
    Registers can be Read-only, Write-only or Read/Write. Channels of this type
    MUST indicate a successful or failed completion of a register access operation. 
    (e.g., an access to a non-existent address or a non-allowed operation will signal an error.)

    .. note:: Both the controller and the devices can hold registers. Controller registers are
      arranged in a fixed :ref:`address map<addresses>` and accessed through the 
      :ref:`configuration channel<conf-chan>`. :ref:`Device registers<dev-register>`
      follow the address map defined on each device :ref:`datasheet<dev-datasheet>`
      and are accessed through the :ref:`device register interface<register_interface>`.

