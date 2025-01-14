======================
Open Neuro Interface
======================

This documentation's source template was taken from the `Spinal HDL <https://github.com/SpinalHDL/SpinalDoc-RTD>`_ project.

The theme is based on the `PyData Sphinx Theme <https://pydata-sphinx-theme.readthedocs.io/en/latest/>`_.

For more detailed usage instructions, see the `Open Ephys Doc Template <https://github.com/open-ephys/doc-template>`_.

How to build this documentation
===============================

With pipenv (recommended)
-----------

Requirements (Python 3):

* pipenv (will automatically download all the project requirements from pypi)

Create a virtual environment with pipenv (will use the Pipfile for installing the necessary packages).

.. code:: shell

   pipenv install

Then you can build the documentation.

.. code:: shell

   pipenv run make html

If you want to run ``make`` multiple times, prepending ``pipenv run`` on each command can be annoying.
You can spawn a subshell with:

.. code:: shell

   pipenv shell

and then you can use ``make`` the usual way.

.. code:: shell

   make html     # for html
   make latex    # for latex
   make latexpdf # for latex (will require latexpdf installed)
   make          # list all the available output format

All the outputs will be in the docs folder (for html: docs/html).

without pipenv/virtualenv
-------------------------
Requirements (system):

* make

Requirements (Python 3):

* sphinx
* pydata-sphinx-theme=="0.13.3"

After installing the requirements you can run:

.. code:: shell

   make html     # for html
   make latex    # for latex
   make latexpdf # for latex (will require latexpdf installed)
   make          # list all the available output format

How to Create a New Sphinx-Version
==================================

Make sure that the Pipfile and the Pipfile.lock files are up to date with the conf.py extensions. This means
that the conf.py section containing `extensions` only contains the extensions needed to build the docs, and
the Pipfile has the same list of extensions. The Pipfile is manually edited, but once the two files are
synchronized then you can run:

.. code:: shell

   pipenv lock

This will regenerate the Pipfile.lock file. Once this call completes, then run the following line to generate
a text file from the Pipfile.lock that can be used by `sphinx-versioning`:

.. code:: shell

   pipenv requirements > source/req.text

After this, the new version can be created. Run the following line, and it will create a new version of the
docs that can be chosen from the dropdown menu in the sidebar. Change the letters X/Y to be the major/minor
version number for the current version of the docs:

.. code:: shell

   sphinx-version vX.Y --venv --requirements req.txt
