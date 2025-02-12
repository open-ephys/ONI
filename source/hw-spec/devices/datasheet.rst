.. _dev-datasheet:

Device Datasheet
----------------
All ONI-compliant devices MUST have a corresponding datasheet that provides
information on register programming and data IO. The datasheet must be served
publicly. It can be a text file, PDF, or website. The required datasheet
sections and information are described below.

Preamble
~~~~~~~~
The following information is required in the preamble:

1. **Informal Device Name**: Name of the device. This field MUST contain only
   alphanumeric characters and punctuation marks (i.e., ``?!*+-_~.()``). Other
   characters, including special characters MUST NOT be used (e.g., ChipXYX,
   Chip XYX, and My~Chip-12ab!, are all valid).
2. **Author(s)**: Device firmware or chip creator(s). Can be a person/people, or
   a company, group, or organization.
3. **Device Version**: The :ref:`device version <dev-desc>` that this datasheet
   corresponds to.
4. **Device ID**: The :ref:`device ID <dev-id>` that this datasheet corresponds
   to.

Description
~~~~~~~~~~~
A textual description of the functionality of the device. This can be simple or
detailed and is meant to be useful for upstream hardware and software developers
for understanding the nature of the device during their work.

Register Map
~~~~~~~~~~~~

Raw Registers
^^^^^^^^^^^^^^^^^^^
If the device uses :ref:`raw registers <reg-type>`, then a link to the
manufacturer's datasheet is all that is required so long as it contains the
register documentation equivalent to that required by :ref:`managed registers
<reg-type>`. However, the register map can also be reproduced for
clarity or if the manufacturer's datasheet is missing required information.

Managed Registers
^^^^^^^^^^^^^^^^^
If the device uses :ref:`managed registers <reg-type>`, a table that describes
the managed register map is required. There are no formatting requirements for
this table, but it MUST contain the following columns:

-  **Address**: Register address within the :ref:`register map <dev-reg-map>`.
-  **Name**: Human readable name for the register. Only capital ASCII letters
   and underscores are allowed, with no spaces or special characters (e.g.
   ``VALID`` and ``ALSO_VALID`` vs. ``NotValid`` and ``ALSO-NOT-VALID``).
-  **Access**: Read-only, Write-only, or Read/Write.
-  **Time of Effect**: When does a register write affect hardware state?
   Immediately or following reset?
-  **POR Value**: Power-on reset default value.
-  **Reset Action**: Upon a reset, what happens to the register? Does it
   maintain its previous state or get reset to some value? If the latter, then
   what value?
-  **Description**: Word description of the register's function.

Additional columns are permitted so long as their information does not conflict
with that in the required columns.

.. _dev-datasheet-read-format:

Read Frame Format
~~~~~~~~~~~~~~~~~
If the device produces :ref:`samples <dev-sample>`, a `bitfield
<https://en.wikipedia.org/wiki/Bit_field>`__ diagram describing the frame
structure is required. Bits can be grouped into words as is convenient. If no
frames are produced, then a statement of such is required.

.. _dev-datasheet-write-format:

Write Frame Format
~~~~~~~~~~~~~~~~~~
If the device accepts :ref:`samples <dev-sample>`, a `bitfield
<https://en.wikipedia.org/wiki/Bit_field>`__ diagram describing the frame
structure is required. Bits can be grouped into words as is convenient. If no
frames are accepted, then a statement of such is required.