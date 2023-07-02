*************************************************
Template for Open Ephys Documentation
*************************************************
This repo serves as the template is for Open Ephys documentation sites.

The documentation files are written in reStructuredText and saved in the 'source' folder. Sphinx is a documentation generator that converts these .rst files to HTML, so that browsers can display them. This Sphinx 'build' step can be performed locally so that you can preview pages in a browser. Once your local changes are pushed to the :code:`main` branch on GitHub, they will be built automatically and pushed to :code:`open-ephys.github.io/<name-of-site>`

Sphinx is a Python project, and each Sphinx site relies on a specific list of Python packages. These are listed in the Pipfile so that local or remote builds know which packages to install. This project uses :code:`pipenv`, allowing the user to create a virtual environment in which the correct version of all required packages is installed (see 'local build').

How to use this template
####################################

- Click the green 'use this template' button to make a new repo. Keep in mind GitHub pages can only be built from public repos.

- You probably want to clone this new repository to your local computer.

- Make the changes described below under 'What to customize' and build the site locally in order to preview it.

- Once you're happy with the modifications, commit them using :code:`git` and push the changes to GitHub. If they are small edits, they can be pushed directly to the :code:`main` branch. Larger edits should be pushed to a separate branch so you can create a pull request that can be reviewed by others. 

- Any changes to the :code:`main` branch will trigger a remote build, which will create the :code:`gh-pages` branch.

- Once the :code:`gh-pages`` branch exists, navigate to Settings/Pages. Select Source: Deploy from a branch and select the branch gh=pages / root. Save!

- Your page should start building; once it's done check that it looks as expected by browsing to the appropriate URL.

What to customize
####################################
Each documentation page is saved as an individual .rst file in the :code:`source`` folder. Docs are written primarily in reStructuredText, and HTML can be used within the .rst file. Images are saved under :code:`_static`. Assuming you are making a new Open Ephys Doc site, besides obviously customizing the content of the pages, you will need to make sure to update:

* source/index.rst
   * Insert a new main image
   * Insert a description of the device
   * Change the content of the HTML "cards"
* conf.py:
   * project = "OE docs"  # change to your project name
   * "github_user": "open-ephys",  # change to the GitHub username from which the page will be deployed
   * "github_repo": "doc-template",  # change to new repo
   * html_logo = "_static/images/oe_logo_name.svg" # change to svg with your logo (see instructions below)
* source_static/theme_overrides.css
   * Change overhead navigation bar colour (.navbar { background: yourfavecolour })
* .github/workflows/sphinx-build.yml
   * git clone https://github.com/open-ephys/doc-template.git # change to your repo

If you are using this template for your own device outside of Open Ephys you will need to edit more of the conf.py file.

Logo customization
--------------------

Each site should include the Open Ephys logo in the navigation bar, with custom text to indicate the name of the software/device being documented. Follow these steps to customize the logo:

- Make sure you have the font `Sofia Sans Extra Condensed <https://fonts.google.com/specimen/Sofia+Sans+Extra+Condensed>`_ installed on your system.
- Open :code:`navbar_logo_template.pdf` in Adobe Illustrator or Inkscape
- Create a new layer for the current project
- Copy and paste one of the project names into the new layer, in the same location as the original name (ctrl-shift-V in Illustrator)
- Change the name displayed in the new layer
- Hide all layers except "Circle", "Logo", and the layer with the new name. The name should disappear, as the background should be hidden as well.
- Choose "Export as..." and select "SVG". Name the file :code:`oe_logo_name.svg`. **Important** Do not "Save as..." an SVG, as this will remove the transparency in the logo. Instead, the original file should remain in PDF format. 


Building remotely
########################

Pushing to the main branch of the repo triggers GitHub Actions. Gh-actions will generate a virtual environment, build the HTML pages, and then commit and push these to the 'gh-pages' branch, by following the instructions under .github/workflows/sphinx-build. Finally, if under repo settings gh pages is enabled and is set to be deployed from the 'gh-pages' branch, the docs site will be generated at https://username.github.io/reponame. To activate gh pages, go to your repo settings, Pages menu, and under "Build and Deployment", choose gh-pages in the dropdown menu. It should say "Your GitHub Pages sites is currently being built from the gh-pages branch".

Building locally
######################

Building HTML files locally allows you to preview changes before updating the live site. We recommend working with 'virtual environments' in which you can install the (versions of the) python packages that the site needs, without messing up your own installs. Here's how:

With pipenv (recommended)
-------------------------------------------------

Requirements (system)

* make

Requirements (Python 3):

* pipenv (will automatically download all the project requirements from pypi)

Create a virtual environment with pipenv (will use the Pipfile for installing the necessary packages)

.. code:: shell

   pipenv install

You can then spawn a subshell with

.. code:: shell

   pipenv shell

and then you can use ``make`` the usual way

.. code:: shell

   make html     # for html
   make latex    # for latex
   make latexpdf # for latex (will require latexpdf installed)
   make          # list all the available output format

all the outputs will be in docs folder (for html: docs/html)

Exit the virtualenv with

.. code:: exit

   exit


Troubleshooting 
######################################

No :code:`gh-pages`` branch? 
If the :code:`gh-pages`` branch is not automatically created, the build will fail and complain that there is no such branch. In that case, make an empty branch as follows: 

.. code:: empty

  git checkout --orphan gh-pages
  git reset --hard
  git commit --allow-empty -m "Initialising gh-pages branch"
  git push origin gh-pages
  git checkout main
  
Error while building? 
By default github pages `will use Jekyll <https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#static-site-generators>`_ to generate a static site. To override this, check that there is a .nojekyll file in the gh-pages branch (just an empty file called '.nojekyll'). 


Acknowledgements
####################################

This documentation's source template was taken from the `Spinal HDL <https://github.com/SpinalHDL/SpinalDoc-RTD>`_ project.

The theme is based on the `PyData Sphinx Theme <https://pydata-sphinx-theme.readthedocs.io/en/latest/>`_
