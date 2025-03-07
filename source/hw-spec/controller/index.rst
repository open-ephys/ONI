.. _controller:

Controller
==========
The :term:`controller's <controller>` purpose is to interface an ONI hardware
system with the host computer. It aggregates and routes device data and provides
transparent access to all devices irrespective of their physical location or
physical means of communication between devices and controller.

.. _acq_clk:

Acquisition Counter
---------------------
The controller MUST have access to a high-resolution, monotonic counter
(typically driven by a high-resolution crystal oscillator, resonator, PLL,
etc.). This counter is used to synchronize data from all devices independently
of their origin hub. The controller MUST capture the counter value when
receiving a :ref:`sample<dev-sample>` and use that value for the ``acqclk_cnt``
field of the corresponding :ref:`frame<frame>`.

.. note:: The controller captures the acquisition counter when it *receives* a
    sample and uses its value for ``acqclk_cnt`` field of the corresponding
    :ref:`frame<frame>`.However, due to hub to controller transmission delays,
    this time may have an offset from the time of sample creation. To account
    for this, hubs contain a :ref:`register <hub_tx_latency>` indicating the
    measured transmission latency. Users can use this value to more precisely
    synchronize samples between hubs.

.. _hard_reset:

Hard Reset
----------------
A controller MUST have a way to issue a hard reset feature that allows to restore
its functionality to the same initial state as after power-on. This signal MUST be
issued through an Out Of Band (OOB) mechanism, triggered by the :term:`Driver Translator`,
and MUST NOT rely on the :ref:`controller_channels`.

The :term:`Driver Translator` SHOULD trigger this hard reset mechanism when communication
between the host and controller is established and when it ends, either normally or
exceptionally.

.. note:: This hard reset signal must nor be confused with the 
    :ref:`soft reset register <soft-reset-reg>`. A hard reset clears all registers and
    states to its power-on status but does not trigger a device map transmission. A 
    soft reset might keep the values of some registers and configurations and always
    triggers a device map transmission to the host.

.. _controller_params:

Hardware-Specific Parameters
-----------------------------
Different ONI-compliant controller implementations might specify
hardware-specific parameters related to standard ONI elements. These need to be
informed through a :ref:`specific address space <address_spec>` reserved for ONI
compliance parameters. :term:`Driver translators <Driver Translator>` can use
this information to hide hardware-specific details to the relevant :term:`API`.

Optional Features
^^^^^^^^^^^^^^^^^^^
The specification includes features that MAY or MAY NOT be implemented in
controller hardware. The :ref:`ONI compliance address space <address_spec>`
includes registers to determine the availability of each optional feature and
its parameters, if applicable.


Communication
-------------

.. toctree::
    :maxdepth: 1

    channels/index
    addresses
    register_interface