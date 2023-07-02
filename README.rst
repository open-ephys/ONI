*************************************************
Template for Open Ephys Documentation
*************************************************
This template is for building documentation of Open Ephys devices or software.

What is this template
####################################
The documentation files are written in reStructuredText and saved in the 'source' folder. Sphinx is a documentation generator that converts these .rst files to HTML, so that browsers can display them. This sphinx 'build' can be performed locally so that you can preview pages in a browser, or it can be done by github remotely (see below for build instructions).

Sphinx is a Python project, and each sphinx site relies on a specific list of python packages. These are listed in the Pipfile so that local or remote builds know which packages to install. This project uses pipenv, allowing the user to create a virtual environment in which the correct version of all required packages is installed (see 'local build').

How to use this template
####################################

- Click the green 'use this template' button to make a new repo. Keep in mind Github pages can only be built from public repos.

- You probably want to clone this new repository to your local computer.

- Make the changes described below under 'What to customize' and commit these changes to GitHub.

- This will trigger the remote build, and the generation of the branch 'gh-pages'.

- Once the 'gh-pages' branch exists, on the Github repo, navigate to Settings/ Pages. Select Source: Deploy from a branch and select the branch gh=pages / root. Save!

- Your page should start building; once it's done check it looks as expected.

What to customize
####################################
Each documentation page is saved as an individual .rst file in the 'source' folder. Docs are written primarily in reStructuredText, and HTML can be used within the .rst file. Images are saved under _static. Assuming you are making a new Open Ephys Doc site, besides obviously customizing the content of the pages, you will need to make sure to update:

* source/index.rst
   * Change License text at the end as appropriate
* conf.py:
   * project = "OE docs"  # change to your project name
   * "github_user": "open-ephys",  # change to the GitHub username from which the page will be deployed
   * "github_repo": "doc-template",  # change to new repo
   * html_logo = "_static/images/oe_logo_template.svg" # change to svg with your logo

      Change the device name on the logo "oe_logo_name.svg"
      Miso, Bold, 36 pt, Kerning: Optical
      Be sure to expand text before saving as .svg as Miso will not load as font.
* source_static/theme_overrides.css
   * Change overhead navigation bar colour (.navbar { background: yourfavecolour })
* .github/workflows/sphinx-build.yml
   * git clone https://github.com/open-ephys/doc-template.git # change to your repo

If you are using this template for your own device outside of Open Ephys you will need to edit more of the conf.py file.

Building remotely
*************************************************
Pushing to the main branch of the repo triggers GitHub Actions. Gh-actions will generate a virtual environment, build the HTML pages, and then commit and push these to the 'gh-pages' branch, by following the instructions under .github/workflows/sphinx-build. Finally, if under repo settings gh pages is enabled and is set to be deployed from the 'gh-pages' branch, the docs site will be generated at https://username.github.io/reponame. To activate gh pages, go to your repo settings, Pages menu, and under "Build and Deployment", choose gh-pages in the dropdown menu. It should say "Your GitHub Pages sites is currently being built from the gh-pages branch".

Building locally
*************************************************
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

No gh-pages branch? 
If the gh-pages branch is not automatically made, the build will fail and complain that there is no such branch. In that case, make an empty branch as follows: 

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
