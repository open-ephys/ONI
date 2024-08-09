.. _clroni:

clroni
########################
:Language:      C#, .NET
:Source Code:   `github.com/open-ephys/liboni/api/clroni <https://github.com/open-ephys/liboni/tree/main/api/clroni>`_
:License:       `MIT <https://en.wikipedia.org/wiki/MIT_License>`__

.. toctree::
    :maxdepth: 1
    :hidden:

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
   run the test program.
3. The Nuget package can be built by right clicking the clroni project and
   clicking "pack".

Mono
=======================================
`Mono <https://github.com/mono/mono>`__ is an open source .NET implementation.
`mcs` is the mono C# compiler.

.. code::

    $ cd clroni-repl
    $ make

Test Programs
=======================================
The :code:`clroni-repl` directory contains minimal working programs that use this
library

1. :code:`clroni-repl.exe` : Basic data acquisition loop. Communicate with
   emulated (e.g., :ref:`test_driver`) or actual (e.g., :ref:`riffa`)
   hardware.

This will be automatically built when the Visual Studio solution is built. It
can also be built using mono via

.. code::

    $ cd clroni-repl
    $ make

License
********************************************
`MIT <https://en.wikipedia.org/wiki/MIT_License>`__
