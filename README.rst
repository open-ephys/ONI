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

Then you can build the documentation. Note that ``make html`` will call
``sphinx-multiversion`` and will automatically build all tags and branches as
defined in the conf.py file. For more details, see the section on
``sphinx-multiversion`` below.

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

All the outputs will be in the docs folder (for html: docs/html). Note that
there will be a folder for every tag or branch that is being built by
``sphinx-multiversion``, as well as a redirect page at the root to automatically
redirect to the main branch build.

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

Sphinx Multiversion Extension
===============================

The ``sphinx-multiversion`` extension is used to automate the build for all tags
and the main branch of these docs. This allows a dropdown menu to be placed in
the left sidebar where the user can choose which version of the docs they want
to browse. This dropdown menu is governed by the
'source/_templates/versioning.html' file, and can be modified via HTML/CSS to
any theme or visualization.

Note that this extension is not building the uncommitted files in the current
working directory; it is building the files that have been committed to the
branch locally. This means that **you must commit all files locally before
building if you want to preview the pages**. Additionally, if your local
branches (i.e., main) are not up to date, your local preview may not reflect
the most recent changes to the repo.

It is also important to note that if you
are working in a feature branch, it is not automatically pulled into the build
due to the branch whitelist found in the conf.py file. To test changes
that have been committed locally, add the current branch to the
``smv_branch_whitelist`` regular expression. For example, if the current working
branch is ``issue-XX``, then the new regular expression can be modified to be
"r'^(main|issue-XX)$'". Be sure to revert the changes to the conf.py file before
merging to main, otherwise the feature branch will be built in the online
version.

For more information on the extension, and the different configuration options,
check out their `documentation site
<https://sphinx-contrib.github.io/multiversion/main/index.html>`__.
