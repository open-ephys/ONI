======================
Open Neuro Interface
======================

This documentation's source template was taken from the `Spinal HDL <https://github.com/SpinalHDL/SpinalDoc-RTD>`_ project.

The theme is based on the `PyData Sphinx Theme <https://pydata-sphinx-theme.readthedocs.io/en/latest/>`_.

For more detailed usage instructions, see the `Open Ephys Doc Template <https://github.com/open-ephys/doc-template>`_.

How to build this documentation
===============================

Building local changes with multi-versioning
--------------------------------------------

Due to how sphinx-multiversion is configured (see below), in order to view the local changes that
are made, it is necessary to create a file at the top-most level of the repo named "whitelist.txt".
This file will be ignored via .gitignore, so it will only exist locally, but it should contain a
list of local branches that should be included in the build process.

The contents of the file should only include the names of the branches that should be included. For
example, if work is being done on branch issue-85, the whitelist.txt file should contain **only**
the following line:

.. code:: shell

    issue-85

If work is being done on multiple branches, and all of them need to be built simultaneously to
preview how the changes are being rendered, then split the list of branches into individual lines
like the following example:

.. code:: shell
  
  issue-85
  issue-86

Then, follow the instructions below on how to set up the environment correctly, commit your changes
to the current branch, and call `pipenv run make html`. This will automatically include all branch
names found in the whitelist file in the multiversion build. If there are branches that need to be
removed, since they are no longer being worked on, call `pipenv run make clean` to remove all files,
and then run `make html` again to create a fresh build.

Building local changes without committing
----------------------------------------

Since it can be a burden, and not a very useful workflow, to have to commit local changes to the
branch before building them, this section provides a method to build local changes from the edited
files before they are committed to the branch. One caveat, is that this method will break the
multiversion dropdown and the associated functionality, so only the local changes will be rendered
in the HTML pages.

Before building locally, it is recommended to run `pipenv run make clean` to remove the folder
hierarchy that might be created from the multi-versioning. This will prevent any conflicts with
naming.

Next, run `pipenv run make local` to build Sphinx only using the local files. In this format, there
will be one folder (docs/html) where all of the locally built HTML files will be located.

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

To view more than just the tags and the main branch, be sure to add a whitelist.txt file at the top
level of the repo according to the instructions above, providing the name of the currently checked
out branch. Ensure that all changes are committed locally as well before building the documentation,
as it does not use the raw files but rather the git information for local and remote branches to
build the pages.

For more information on the extension, and the different configuration options,
check out their `documentation site
<https://sphinx-contrib.github.io/multiversion/main/index.html>`__.
