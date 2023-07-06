.. _onix.h:
.. default-domain:: c

onix.h
#######################################
ONIX hardware-specific definitions that extend the ``liboni`` and are outside
the scope of the ONI specification. This file is not needed to use the API
(:ref:`oni.h`, :ref:`onidriver.h`, etc.).

ONIX Devices
---------------------------------------
Device definitions for ONIX hardware. These definitions are allowances of the
ONI specification and are not required to use the API.

.. attention:: Many of the devices in this enumeration have no ready-made route
    to use in high-level software. This is true for a variety of reasons. For
    instance, they may be prototype hardware or test fixture that we wish to
    maintain for backward compatibility (e.g. :macro:`ONIX_TESTREG0`). Or, they
    may be a low level device (e.g. :macro:`ONIX_AD7617`) that is used in the
    background by other, higher order devices in the list (e.g.
    :macro:`ONIX_FMCANALOG1R3`).

.. enum:: onix_device_id_t

    .. macro:: ONIX_NULL

        (``0``)
        Placeholder device

    .. macro:: ONIX_INFO

        (``1``)
        Virtual device that provides status and error information

    .. macro:: ONIX_RHD2132

        (``2``)
        Intan RHD2132 bioamplifier

    .. macro:: ONIX_RHD2164

        (``3``)
        Intan RHD2162 bioamplifier

    .. macro:: ONIX_ESTIM

        (``4``)
        Electrical stimulation subcircuit

    .. macro:: ONIX_OSTIM

        (``5``)
        Optical stimulation subcircuit

    .. macro:: ONIX_TS4231

        (``6``)
        Triad semiconductor TS421 optical to digital converter

    .. macro:: ONIX_DINPUT32

        (``7``)
        32-bit digital input port

    .. macro:: ONIX_DOUTPUT32

        (``8``)
        32-bit digital output port

    .. macro:: ONIX_BNO055

        (``9``)
        BNO055 9-DOF IMU

    .. macro:: ONIX_TEST0

        (``10``)
        A test device used for debugging

    .. macro:: ONIX_NEUROPIX1R0

        (``11``)
        Neuropixels 1.0

    .. macro:: ONIX_HEARTBEAT

        (``12``)
        Host heartbeat

    .. macro:: ONIX_AD51X2

        (``13``)
        AD51X2 digital potentiometer

    .. macro:: ONIX_FMCVCTRL

        (``14``)
        Open Ephys FMC Host Board rev. 1.3 link voltage control subcircuit

    .. macro:: ONIX_AD7617

        (``15``)
        AD7617 ADC/DAS

    .. macro:: ONIX_AD576X

        (``16``)
        AD576X DAC

    .. macro:: ONIX_TESTREG0

        (``17``)
        A test device used for testing remote register programming

    .. macro:: ONIX_BREAKDIG1R3

        (``18``)
        Open Ephys Breakout Board rev. 1.3 digital and user IO

    .. macro:: ONIX_FMCCLKIN1R3

        (``19``)
        Open Ephys FMC Host Board rev. 1.3 clock input subcircuit

    .. macro:: ONIX_FMCCLKOUT1R3

        (``20``)
        Open Ephys FMC Host Board rev. 1.3 clock output subcircuit

    .. macro:: ONIX_TS4231V2ARR

        (``21``)
        Triad semiconductor TS421 optical to digital converter array targeting V2 base-stations

    .. macro:: ONIX_FMCANALOG1R3

        (``22``)
        Open Ephys FMC Host Board rev. 1.3 analog IO subcircuit

    .. macro:: ONIX_FMCLINKCTRL

        (``23``)
        Open Ephys FMC Host Board coaxial headstage link control circuit

    .. macro:: ONIX_DS90UB9RAW

        (``24``)
        Raw DS90UB9x deserializer

    .. macro:: ONIX_MAXDEVICEID

        (:macro:`MAXDEVID`)
        Final reserved device ID. Always on bottom

Functions
--------------------------------------------

.. function:: const char *onix_device_str (int dev_id)

    Returns a human-readable description from a given :enum:`onix_device_id_t`.

    :param dev_id: The :enum:`onix_device_id_t` to get the description of.
    :return: A C string containing the device description, which could simply
        be "Unknown device" if the device is not a member of
        :enum:`onix_device_id_t`.
