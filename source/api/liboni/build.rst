.. _liboni-build:

Building liboni
##########################################

Build in Linux
********************************************
For build options, look at the top level ``Makefile``. The ``Makefile`` is
self-documenting. You can examine options using:

.. code-block:: console

    $ make help

To build and install ``liboni`` use

.. code-block:: console

    $ make <options>
    $ make install PREFIX=/path/to/install

to place build artifacts in whatever path is specified by ``PREFIX``.
``PREFIX`` defaults to ``/usr/lib/include``. You can uninstall (delete headers
and libraries) via

.. code-block:: console

    $ make uninstall PREFIX=/path/to/uninstall

To make a particular driver, navigate to its location within the ``drivers``
subdirectory and:

.. code-block:: console

    $ make <options>
    $ make install PREFIX=/path/to/install

Then update the dynamic library cache via:

.. code-block:: console

    $ ldconfig

Performance Testing
--------------------------------------------

Install google perftools:

.. code-block:: console

    $ apt-get install google-perftools

Check what library is installed:

.. code-block:: console

    $ ldconfig -p | grep profiler

If ``libprofiler.so`` is not there, but ``libprofiler.so.x`` exists, create a
softlink:

.. code-block:: console

    $ sudo ln -rs /path/to/libprofiler.so.x /path/to/libprofiler.so

Link the profiler into test the programs during compilation using:

.. code-block:: console

    $ cd liboni-test
    $ make profile

Run the ``firmware`` program to serve fake data. Provide a numerical argument
specifying the number of fake frames to produce. It will tell you how long it
takes ``host`` to sink all these frames. This is host processing time + UNIX
pipe read/write.

.. code-block:: console

    $ cd bin
    $ ./firmware 10e6

Run the ``host`` program while dumping profile info:

.. code-block:: console

    $ env CPUPROFILE=/tmp/host.prof ./host

Examine output

.. code-block:: console

    $ pprof ./host /tmp/host.prof

Memory Testing
--------------------------------------------
Run the ``firmware`` and ``host`` programs as described above with valgrind using
full leak check on ``host``:

.. code-block:: console

    $ valgrind --leak-check=full ./host

Build in Windows
********************************************
Open the included `Visual Studio Coummunity
<https://visualstudio.microsoft.com/vs/community/>`_ solution and press play.
For whatever reason, it seems that the selected startup project is not
consistently saved with the solution. So make sure that is set to
``liboni-test`` in the solution properties.
