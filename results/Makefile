# Build the notebooks from a template using papermill

PARAMETER_FILES := $(shell find . -name 'benchmark*.yaml')

NOTEBOOKS := $(PARAMETER_FILES:%.yaml=%.ipynb)

.PHONY: clean

benchmark%.ipynb: benchmark%.yaml template.ipynb
	papermill template.ipynb $@ -f $<

notebooks: $(NOTEBOOKS)

clean:
	for file in $(NOTEBOOKS) ; do \
	  \rm -rf $$file ; \
	done
