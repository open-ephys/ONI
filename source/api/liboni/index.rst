.. _liboni:

liboni
##########################################

:Source Code:   `github.com/open-ephys/liboni/api/liboni <https://github.com/open-ephys/liboni/tree/main/api/liboni>`_
:License:       `MIT <https://en.wikipedia.org/wiki/MIT_License>`__

.. toctree::
    :maxdepth: 1
    :hidden:

    onidefs
    oni
    onidriver
    onix
    build
    liboni-example
    making-drivers
    driver-translators/index


``liboni`` is a C library that functions with hardware that complies with the
implements the :ref:`oni-hw`. It is written in C to facilitate cross platform
and cross-language use. It is composed of the following files:

#. :ref:`onidefs.h`: common definitions
#. :ref:`oni.h`: core API
#. :ref:`onidriver.h`: device driver translation layer that must be
   implemented for a particular host hardware connection and
   firmware.
#. onidriverloader.h: private functions used for dynamically loading the
   hardware driver. This is used internally by the :ref:`oni.h` and can be
   ignored during both software and driver development.
#. :ref:`onix.h`: ONIX-specific, out of ONI API specification
   scope, definitions and functions. Can be ignored for projects that
   do not interact with ONIX hardware.

The only external dependency aside from the C standard library and dynamic
library loading functions is is a device driver translation layer
(:ref:`onidriver.h`, "driver" for short) that can communicate with hardware
created using the :ref:`ONI controller specification <controller>` . This implementation
contains the following, ready-to-use driver translators:

#. :ref:`test_driver`: Driver emulator for testing.
#. :ref:`riffa`: Open source PCIe stack.
#. :ref:`ft600`: Closed-source FTDI-based USB stack.

These library elements abstract system calls into a common API function calls.
Importantly, the low-level synchronization, resource allocation, and logic
required to use the hardware communication backend is implicit to ``liboni``
API function calls. Orchestration of the communication backend is not directly
managed by the API user.

