.. _conf-chan:

Configuration Channel
======================

-  **Data alignment** : 32 bits
-  **Channel type** : Register
-  **Direction** : Read-Write

The *configuration* channel supports addressed access to a set of registers.
The interface must use 32-bit values and 16-bit addressing. Controllers must
implement an :ref:`address map<addresses>` with all the registers required
by the specification.

This channel is also used to access the :ref:`register map <dev-reg-map>`
of the individual devices through an interface comprised of specific 
:ref:`configuration registers<register_interface>`.

