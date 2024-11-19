.. _hub:

Hubs
====
Hubs are collections of devices sharing a common clock. They can be independent
hardware aggregates connected to the controller (e.g. a headstage for neural
acquisition) or a logical partition of existing hardware (e.g. a collection of
devices implemented in the same firmware as the controller). Hubs that exist on
hardware that is physically separated from the :ref:`controller <controller>` are
referred to as remote hubs, while hubs existing on the controller are local hubs.
An ONI-compliant system MUST implement at least one local hub, located at
:ref:`Hub_Index 0 <dev-address>` and sharing the clock of controller's main
state machine, and can implement up to 253 additional hubs, local or remote. All
devices reflecting or modifying the :ref:`controller <controller>` state and/or 
reporting errors or similar status messages must be implemented in local hub 0.

Every hub MUST have access to a high-resolution timer that is used by all its
devices to generate a ``hubclk_cnt`` for a :ref:`data sample <dev-sample>`.

Data from all the devices of a hub is collected and passed to the controller.
The specific interface between a hub and the controller is highly
implementation-dependent and, thus, not in the scope of this document. In
any case, it is the duty of the hub to provide the controller with all the
device descriptors and communication channels in a transparent manner. It is
common for a remote hub to feature a centralized IC (e.g., an FPGA or
microcontroller) integrating the device controllers and communication interface
to fill this duty, but other schemes are possible.

Multiple hubs are differentiated through a unique identifier, or Hardware ID.
This identifier represents a specific implementation of a hub, defined by a
particular collection of devices on a specific hardware platform communicating
with the controller through a specific link. Changes in the device collection,
the communications link or the general hardware architecture require a new
identifier.
