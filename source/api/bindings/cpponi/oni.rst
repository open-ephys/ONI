.. _oni.hpp:
.. default-domain:: cpp

oni.hpp
#######################################
This file includes :ref:`oni.h`.

Version
--------------------------------------
See https://semver.org/ for a complete explanation of these macro definitions.

.. c:macro:: CPPONI_VERSION_MAJOR

    MAJOR version for incompatible API changes

.. c:macro:: CPPONI_VERSION_MINOR

    MINOR version for added functionality that is backwards compatible

.. c:macro:: CPPONI_VERSION_PATCH

    PATCH version for backwards compatible bug fixes

.. c:macro:: CPPONI_MAKE_VERSION(major, minor, patch)

    Defined as

    .. code-block:: c

        MAJOR * 10000 + MINOR * 100 + PATCH

    Provides compile-time access to the API version.

.. c:macro:: CPPONI_VERSION

    Compile-time API version. Defined as

    .. code-block:: c

        CPPONI_MAKE_VERSION(CPPONI_VERSION_MAJOR CPPONI_VERSION_MINOR, CPPONI_VERSION_PATCH).

.. function:: std::tuple<int, int, int> oni::version()

    Get the ``cpponi`` version.

    :return: ``std::tuple<MAJOR, MINOR, PATCH>``

Errors
--------------------------------------
.. namespace:: oni

.. class:: oni::error_t : public std::exception

    `std::exception <https://en.cppreference.com/w/cpp/error/exception>`__
    wrapper for liboni :ref:`onidef_error_codes`. These exceptions are thrown
    from cpponi in lieu of C return codes.

    .. function:: error_t(int errnum)

        Constructor. Not generally needed for cpponi use since
        :class:`oni::error_t` is constructed and thrown from within cpponi and
        only need to be handled by the host application.

        :param errnum: liboni error code integer, generally resulting from a non-zero
            return value of an Underlying liboni function.

    .. function:: const char *what() const noexcept override

        Wrapper for :c:func:`oni_error_str`.

        :return: Human-readable error code description.

Devices
--------------------------------------
.. namespace:: oni

.. type:: oni::device_t = oni_device_t

    Type alias for :c:struct:`oni_device_t`.

.. type:: oni::device_map_t = std::unordered_map<oni_dev_idx_t, oni::device_t>

    :type:`oni::device_t` table type. `std::unordered_map
    <https://en.cppreference.com/w/cpp/container/unordered_map>`__ replaces
    a minimal internal hash table used in liboni and allows fast device lookup based on
    device index.

Frames
--------------------------------------
.. namespace:: oni

.. class:: oni::frame_t

    `RAII <https://en.cppreference.com/w/cpp/language/raii>`__-capable wrapper
    for :c:struct:`oni_frame_t`. User programs generally should not call the
    frame_t constructor directly but deal with frames created by a
    :class:`oni::context_t`

    .. function:: uint64_t time() const

        :return: Underlying :c:struct:`oni_frame_t.time`

    .. function:: oni_dev_idx_t device_index() const

        :return: Underlying :c:struct:`oni_frame_t.dev_idx`

    .. function:: template <typename raw_t>\
                  std::span<const raw_t> data() const   
                  std::vector<const raw_t> data() const

        :return: A type-cast view (or copy if stdlib < C++20) of the underlying
            :c:struct:`oni_frame_t.data`.

        .. note:: `std::span
            <https://en.cppreference.com/w/cpp/container/span>`__ Automatically
            made available when compiled with stdlib >= C++20. Otherwise, this
            function reverts to returning a `std::vector
            <https://en.cppreference.com/w/cpp/container/vector>`__

Context
--------------------------------------
.. namespace:: oni

.. class:: oni::context_t

    `RAII <https://en.cppreference.com/w/cpp/language/raii>`__-capable wrapper
    for a liboni :ref:`oni_h_acquisition_context` as well as the majority of
    functions within the liboni API.

    .. function:: context_t(const char *driver_name, int host_idx)

        Constructor. Creates and initializes the underlying
        :ref:`oni_h_acquisition_context`.

        :param drv_name: A string specifying the device driver used by
            the context to control hardware. This string corresponds a compiled
            implementation of :ref:`onidriver.h` that has the name
            ``onidriver_<drv_name>.<so/dll>``. If this library is not on the
            dynamic library search path, the function will error.
        :param host_idx: The index of the hardware we are going to
            manage using the initialized context and driver. A value of -1 will
            attempt to open the default host index and is useful if there is only a
            single ONIX host managed by driver selected in :func:`oni_create_ctx`
        :throws: `std::system_error
            <https://en.cppreference.com/w/cpp/error/system_error>`_ if underlying
            context cannot be allocated.

        .. seealso::

            :c:func:`oni_create_ctx`
                Underlying context creation.
            :c:func:`oni_init_ctx`
                Underlying context initialization.

    .. function:: context_t(context_t &&rhs) noexcept

        Move constructor.

        :param rhs: Existing :class:`context_t` instance to move from. 

    .. function:: context_t &operator=(context_t &&rhs) noexcept

        Move assignment operator. 

        :param rhs: Existing :class:`context_t` instance to move from. 

    .. function:: template <typename opt_t>\
                  opt_t get_opt(int option) const
    
        Get a context option. 

        :param option: :c:enum:`@ctx_opts_enum` option selection. See each option
            description for valid opt_t types.
        :return: opt_t option value.

        .. seealso::

            :c:func:`oni_get_opt`
                Underlying C function.

    .. function:: template <typename opt_t>\
                  void set_opt(int option, opt_t const &optval)

        Set a context option. 

        .. seealso::

            :c:func:`oni_set_opt`
                Underlying C function.

    .. function:: template <typename opt_t>\
                  opt_t get_driver_opt(int option) const

        Get a driver option.

        .. seealso::

            :c:func:`oni_get_driver_opt`
                Underlying C function.

    .. function:: template <typename opt_t>\
                  void set_driver_opt(int option, opt_t const &optval)

        Set a driver option.

        .. seealso::

            :c:func:`oni_get_driver_opt`
                Underlying C function.

    .. function:: oni_reg_val_t read_reg(oni_dev_idx_t dev_idx,oni_reg_addr_t addr)

        Read a device register.

        .. seealso::

            :c:func:`oni_read_reg`
                Underlying C function.

    .. function:: void write_reg(oni_dev_idx_t dev_idx, oni_reg_addr_t addr, oni_reg_val_t value)

        Write a device register.

        .. seealso::

            :c:func:`oni_write_reg`
                Underlying C function.

    .. function:: device_map_t device_map() const noexcept

        Convenience function to examine the context's current device table as a
        `std::unordered_map
        <https://en.cppreference.com/w/cpp/container/unordered_map>`__ from
        table index to device instance. The raw device table can still be
        acquired using :func:`get_opt`. 

        :return: :type:`device_map_t` containing ``this``'s device table.

        .. seealso::

            :c:func:`oni_get_opt`

                Underlying C function when used in combination with
                :c:macro:`ONI_OPT_DEVICETABLE`.

    .. function:: frame_t read_frame() const

        Read a :class:`frame_t` data from the acquisition context. 

        :return: :class:`frame_t` from one of the devices in the device table.

        .. attention:: This function must be called frequently enough to
            prevent overflow of the acquisition hardware buffer.

        .. seealso::

            :c:func:`oni_read_frame`

            :c:func:`oni_destroy_frame`

                Underlying C functions.

    .. function:: template <typename data_t>\
                  void write(size_t dev_idx, std::span<const data_t> data) const

        Write data to a device. This function wraps an entire
        :c:func:`oni_create_frame`, :c:func:`oni_write_frame`, and
        :c:func:`oni_destroy_frame` function call cycle.

        :param dev_idx: Fully qualified :c:struct:`oni_device_t.idx` specifying the
            device to write data to. 
        :param data: Data block to write to the device.

        .. note:: ``data.size()`` must be

            #. An integer multiple of the selected ``dev_idx``'s write size as
               indicated within the device table
            #. Smaller than the internal write block memory size (see 
               :c:macro:`ONI_OPT_BLOCKWRITESIZE` and :ref:`liboni_example_set_buffers`)

        .. note:: `std::span
            <https://en.cppreference.com/w/cpp/container/span>`__ is
            automatically made available when compiled with stdlib >= C++20.
            Otherwise, this function reverts to returning a `std::vector
            <https://en.cppreference.com/w/cpp/container/vector>`__

        .. seealso::
            :c:func:`oni_create_frame`

            :c:func:`oni_write_frame`

            :c:func:`oni_destroy_frame`

                Underlying C functions.
