.. _cpponi:

cpponi
########################
:Source Code:   `github.com/open-ephys/liboni/api/cpponi <https://github.com/open-ephys/liboni/tree/main/api/cpponi>`_
:License:       `MIT <https://en.wikipedia.org/wiki/MIT_License>`__

C++17 & C++20 bindings for :ref:`liboni`. This is a header only library that
provides abstraction and automatic memory management (`RAII
<https://en.cppreference.com/w/cpp/language/raii>`_) around the base C library.
The C++20 version of the library provides better performance due to that
standard's inclusion of `std::span
<https://en.cppreference.com/w/cpp/container/span>`_ which is useful for
zero-copy, high-level representation of data within :cpp:class:`oni::frame_t`.
The available version of standard library is detected at compile time. If C++20
is not available, :cpp:class:`oni::frame_t` uses `std::vectors
<https://en.cppreference.com/w/cpp/container/vector>`_ for internal storage.

.. toctree::
    :maxdepth: 1

    oni
    onix

License
********************************************
`MIT <https://en.wikipedia.org/wiki/MIT_License>`_
