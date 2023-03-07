# Build the notebooks from a template using papermill

PARAMETER_FILES := $(shell find . -name 'benchmark*.yaml')

NOTEBOOKS_MD := $(PARAMETER_FILES:%.yaml=%.md)

NOTEBOOKS_IPYNB := $(PARAMETER_FILES:%.yaml=%.ipynb)

.PHONY: clean

template.ipynb: template.md
	jupytext template.md --to ipynb

benchmark%.ipynb: benchmark%.yaml template.ipynb
	papermill template.ipynb $@ -f $<

benchmark%.md: benchmark%.ipynb
	jupytext $< --to md

notebooks: $(NOTEBOOKS_MD) $(NOTEBOOKS_IPYNB)

clean:
	for file in $(NOTEBOOKS_MD) ; do \
	  \rm -rf $$file ; \
	done
	for file in $(NOTEBOOKS_IPYNB) ; do \
	  \rm -rf $$file ; \
	done
	\rm -rf template.ipynb
