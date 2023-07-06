.. _oni-api:

===========================================
ONI API Documentation
===========================================

:Source Code:   https://github.com/open-ephys/liboni.
:Version:       TODO
:Date:          2023.06.29

.. toctree::
    :hidden:
    :maxdepth: 2

    liboni/index
    bindings/index

Core Library
--------------------------
:ref:`liboni`
    A high-performance an ANSI-C library for controlling hardware that conforms
    to the compliant with the :ref:`ONI Hardware Specification <oni-hw>`. It
    contains functions for configuring hardware, streaming data to and from
    hardware, and controlling hardware during operation. This library  has
    minimal external dependencies and is aimed at the creation of higher level
    language bindings and/or integration into existing acquisition software.

    - :ref:`Library Reference <liboni>`
    - :ref:`Build Instructions <liboni-build>`
    - :ref:`Usage Examples <liboni_example>`
    - :ref:`Interfacing with Third Pary Drivers <making_drivers>`
    - :ref:`Existing Drivers <drivers>`

Bindings
--------------
:ref:`C++ Binding Reference <cpponi>`
    C++17 & C++20 bindings for :ref:`liboni`.

:ref:`.NET Binding Refernece <clroni>`
    CLR/.NET bindings for :ref:`liboni`.
