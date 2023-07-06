.. _clroni:

clroni
########################
:Source Code:   `github.com/open-ephys/liboni/api/clroni <https://github.com/open-ephys/liboni/tree/main/api/clroni>`_
:License:       `MIT <https://en.wikipedia.org/wiki/MIT_License>`__

CLR/.NET bindings for :ref:`liboni`. Documentation for the public interface is
provided below:

.. toctree::
    :maxdepth: 1

    context
    hub
    device
    frame
    oniexception


Building the library
---------------------------------------

Windows
=======================================
1. Open the :code:`clroni.sln` solution in Visual Studio 2019 or newer.
2. "Running" the solution will compile the library and test program, and then
   run the test program
3. The Nuget package can be built by right clicking the clroni project and
   clicking "pack".

Mono
=======================================
`Mono <https://github.com/mono/mono>`__ is an open source .NET implementation.
`mcs` is the mono C# compiler.

.. code::

    $ cd clroepcie
    $ make

Test Programs
=======================================
The :code:`clroepcie-test` directory contains minimal working programs that use this
library

1. :code:`Host.exe` : Basic data acquisition loop. Communicate with
   emmulated (e.g. :ref:`test_driver`) or actual (e.g. :ref:`riffa`)
   hardware.

This will be automatically built when the Visual Studio solution is built. It
can also be built using mono via

.. code::

    $ cd clroni-test
    $ make

License
********************************************
`MIT <https://en.wikipedia.org/wiki/MIT_License>`__
