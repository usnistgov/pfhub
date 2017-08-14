HEXBIN_OUT = images/hexbin.jpg _data/hexbin.json
HEXBIN_IN = _data/hexbin.yaml _data/hexbin.py

NOTEBOOKS := $(shell find . -name '*.ipynb' -not -path "*.ipynb_checkpoints/*" -not -path "./_site/*" -not -path "./_data/*")
NOTEBOOKS_HTML := $(NOTEBOOKS:%.ipynb=%.ipynb.raw.html)
NOTEBOOKS_MD := $(NOTEBOOKS:%.ipynb=%.ipynb.md)

YAML_FILES_IN := $(wildcard _data/simulations/*/meta.yaml)
YAML_FILES_OUT := $(subst meta.yaml,meta.yaml.out,$(YAML_FILES_IN))

HTML_FILES_OUT_TMP := $(subst _data/,,$(YAML_FILES_IN))
HTML_FILES_OUT := $(subst meta.yaml,index.html,$(HTML_FILES_OUT_TMP))

.PHONY: clean build_charts

all: hexbin notebooks simulations

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

%.ipynb.raw.html: %.ipynb
	jupyter-nbconvert $< --output $(notdir $@) --to html --template basic

%.ipynb.md: %.ipynb
	cp ./template.ipynb.md $@
	sed -i -- 's/notebook_name/$(notdir $<)/' $@

%.yaml.out: %.yaml
	pykwalify -d $< -s _data/simulations/example/schema.yaml

yamllint: $(YAML_FILES_OUT)

build_charts: _data/simulations.py $(YAML_FILES_OUT)
	python _data/simulations.py

data_table: _data/data_table.py
	python _data/data_table.py

simulations/%/index.html: _data/simulations/%/meta.yaml _data/sim_stub.html
	mkdir -p $(dir $@)
	cp _data/sim_stub.html $@

sim_landing: $(HTML_FILES_OUT)

simulations: yamllint build_charts data_table sim_landing

hexbin: $(HEXBIN_OUT)

notebooks: $(NOTEBOOKS_HTML) $(NOTEBOOKS_MD)

print-%  : ; @echo $* = $($*)
