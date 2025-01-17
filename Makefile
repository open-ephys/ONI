# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    			= -Dversion=$(shell git tag --sort=committerdate | tail -1)
SPHINXBUILD   			= sphinx-build
SPHINXBUILDMULTIVERSION = sphinx-multiversion
SOURCEDIR     			= source
BUILDDIR      			= docs
BUILDDIRHTML			= $(BUILDDIR)/html

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)"

.PHONY: help Makefile

html: Makefile
	@$(SPHINXBUILDMULTIVERSION) "$(SOURCEDIR)" "$(BUILDDIRHTML)" $(SPHINXOPTS) $(O)
	cp source/_templates/redirect.html "$(BUILDDIRHTML)/index.html"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
