.. _controller:

Controller
==========
The :term:`controller's <controller>` purpose is to interface an ONI hardware system with the host
computer. It aggregates and routes device data and provides transparent access
to all devices, independently of their physical location. 

.. _acq_clk:

Acquisition Counter
---------------------

The controller MUST have access to a high resolution clock. The tick count from this
clock is used to synchronize data from all devices independently of their origin hub.
The controller MUST capture the counter value when receiving a :ref:`sample<dev-sample>`
and use that value for the ``acqclk_cnt`` field of the corresponding :ref:`frame<frame>`.

.. note:: The controller adds the acquisition counter when it receives the samples
    and proceeds to create the associated frame. However, due to hub to controller
    transmission delays, this time may have an offset from sample creation time.
    To account for this, hubs contain a :ref:`register <hub_tx_latency>` indicating the measured
    transmission latency. Users can use this value to more precisely synchronize
    samples between hubs.

.. _controller_params:

Hardware-Specific Parameters
-----------------------------

Different ONI-compliant controller implementations might specify hardware-specific parameters related to standard ONI elements.
These need to be informed through a :ref:`specific address space <address_spec>` reserved for ONI compliance parameters. 
:term:`Driver translators <Driver Translator>` can use this information to hide hardware-specific details to the 
relevant :term:`API`.

Optional Features
^^^^^^^^^^^^^^^^^^^

The specification includes features that MAY or MAY NOT be implemented in controller hardware. 
The :ref:`ONI compliance address space <address_spec>` includes registers to determine the availability 
of each optional feature and its parameters, if applicable.


Communication
-------------

.. toctree::
    :maxdepth: 1
 
    channels/index
    addresses
    register_interface