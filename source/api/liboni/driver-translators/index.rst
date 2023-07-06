.. _drivers:

Driver Translators
#######################################

:Code: https://github.com/open-ephys/liboni/tree/main/api/liboni/drivers

There are a many existing `device drivers
<https://en.wikipedia.org/wiki/Device_driver>`_ that support hardware for data
acquisition. Some of these drivers can be used as a backend for ONI-compliant
APIs if they provide some means to support the required ONI communication
channels. Have a look at the :ref:`ONI controller spec <controller>`
for specifications of these channels.

An ONI hardware driver translator implements :ref:`onidriver.h` to convert,
potentially proprietary, device drivers (and corresponding hardware) into a
user space library that can be consumed by ONI-compliant APIs. These are loaded
by the API at runtime and therefore are separate from the API both in terms of
development and licensing requirements.

.. tip:: See the :ref:`making_drivers` page for detailed information on
   creating your own driver translator to allow hardware to work with
   :ref:`liboni` . Feel free to `get in touch
   <https://open-ephys.org/contact>`__ if you want to write a driver translator
   to give your hardware automatic access to our API and software.

Existing driver translator implementations are documented here. Have a look at
the following links for more information on each.

.. toctree::
    :maxdepth: 1

    test
    riffa
    ft600
