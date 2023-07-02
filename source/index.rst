:notoc:

*************************************************
NAME OF DEVICE
*************************************************

**Date**: |today|

This site provides documentation for [INSERT PROJECT HERE], that [SHORT DESCRIPTION OF STUFF PROJECT DOES].

It is currently under construction
####################################

It will eventually include the following information:

* Point 1
* Point 2
* Point 3

What to customize
####################################
Each documentation page is saved as an individual .rst file in the 'source' folder. Docs are written primarily in reStructuredText, and HTML can be used within the .rst file. Images are saved under _static. Besides obviously customizing the content of the pages, you will need to make sure to update:

* license (at the end of primary index page)
* conf.py:
   * project = "OE docs"  # change to your project name
   * "github_repo": "doc-template",  # change to new repo
   * html_logo = "_static/images/oe_logo_template.svg" # change to svg with your logo

      Change the device name on the logo "oe_logo_name.svg"
      Miso, Bold, 36 pt, Kerning: Optical
      Be sure to expand text before saving as .svg as Miso will not load as font.
* theme_overrides.css
   * Change overhead navigation bar colour (.navbar { background: yourfavecolour })
* .github/workflows/sphinx-build.yml
   * git clone https://github.com/open-ephys/doc-template.git # change to your repo

.. raw:: html

    <h2 style = "text-align: center"> Getting Started </h2>

    <div class="container">
      <div class="row row-cols-lg-4 row-cols-md-2 row-cols-sm-1 row-cols-xs-1">
        <div class="col mb-4">
          <div class="card h-100 text-center intro-card shadow">
            <a href = About/example1.html>
                <img src="_static/images/noun_screwdriver.svg" class="card-img-top" height="160">
                <div class="card-body flex-fill">
                  <p class="card-reference">TOPIC 1</p>
                </div>
            </a>
          </div>
        </div>
        <div class="col mb-4">
          <div class="card h-100 text-center intro-card shadow">
            <a href =  About/example2.html>
                <img src="_static/images/noun_books.svg" class="card-img-top" height="160">
                <div class="card-body flex-fill">
                  <p class="card-reference">TOPIC 2</p>
                </div>
            </a>
          </div>
        </div>
        <div class="col mb-4">
          <div class="card h-100 text-center intro-card shadow">
            <a href = "About/index.html" target="_blank" rel="noopener noreferrer">
              <img src="_static/images/paper.svg" class="card-img-top" height="160">
              <div class="card-body flex-fill">
                <p class="card-reference">TOPIC 3 </p>
              </div>
            </a>

          </div>
        </div>
        <div class="col mb-4">
          <div class="card h-100 text-center intro-card shadow">
            <a href = "https://github.com/open-ephys" target="_blank" rel="noopener noreferrer">
              <img src="_static/images/noun_macbook.svg" class="card-img-top" height="160" >
              <div class="card-body flex-fill">
                <p class="card-reference">TOPIC 4 IS EXTERNAL LINK<i class="fas fa-external-link-alt" style = "font-size:0.5em; vertical-align: super"></i></p>
              </div>
            </a>
          </div>
        </div>
      </div>
    </div>

License
#################################################

This work is licensed under CC BY-SA 4.0.

To view a copy of this license, visit https://creativecommons.org/licenses/by-sa/4.0/

.. toctree::
    :hidden:
    :maxdepth: 2
    :titlesonly:

    About/index
