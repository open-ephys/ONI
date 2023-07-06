.. _test_driver:
.. default-domain:: c

Test Driver
#######################################
**Test Driver** is a very simple hardware emulation driver that is used for
testing the API and software. It has the following limitations:

#. :macro:`ONI_OPT_RUNNING` does nothing.
#. It only supports a device table with containing devices with a fixed read/write size
#. The driver is single threaded and synchronous with API function calls and
   therefore quite limited. This means that the asynchronous nature of real
   hardware is not emulated or tested by this driver.
#. :macro:`ONI_OPT_BLOCKREADSIZE` must be set to an integer multiple of the frame
   size, which is 28 bytes.

Its only dependency is the C standard library.

Building the library
---------------------------------------

Linux
=======================================

.. code::

    make                # Build without debug symbols
    sudo make install   # Install in /usr/local and run ldconfig to update library cache
    make help           # list all make options

Windows
=======================================
Run the project in Visual Studio. It can be included as a dependency in other
projects.
