.. _controller:

Controller
==========
The :term:`controller`'s purpose is to interface an ONI hardware system with the host
computer. It aggregates and routes device data and provides transparent access
to all devices, independently of their physical location. The host also
contains a common clock that is used to timestamp data from all devices,
independently of their origin hub.

.. _controller_params:

Hardware-specific Parameters
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