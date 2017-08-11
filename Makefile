HEXBIN_OUT = images/hexbin.jpg _data/hexbin.json
HEXBIN_IN = _data/hexbin.yaml _data/hexbin.py

NOTEBOOKS := $(shell find . -name '*.ipynb' -not -path "*.ipynb_checkpoints/*" -not -path "./_site/*" -not -path "./_data/*")
NOTEBOOKS_HTML := $(NOTEBOOKS:%.ipynb=%.ipynb.raw.html)
NOTEBOOKS_MD := $(NOTEBOOKS:%.ipynb=%.ipynb.md)

YAML_FILES_IN := $(wildcard _data/simulations/*/meta.y*ml)
YAML_FILES_OUT_TMP := $(subst meta.yaml,meta.yaml.out,$(YAML_FILES_IN))
YAML_FILES_OUT := $(subst meta.yml,meta.yml.out,$(YAML_FILES_OUT_TMP))



.PHONY: clean build_charts

all: hexbin notebooks simulations

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

%.ipynb.raw.html: %.ipynb
	jupyter-nbconvert $< --output $(notdir $@) --to html --template basic

%.ipynb.md: %.ipynb
	cp ./template.ipynb.md $@
	sed -i -- 's/notebook_name/$(notdir $<)/' $@

kwalify:

%.yaml.out: %.yaml
	pykwalify -d $< -s _data/simulations/example/schema.yaml

%.yml.out: %.yml
	pykwalify -d $< -s _data/simulations/example/schema.yaml

yamllint: $(YAML_FILES_OUT)

build_charts: _data/simulations.py $(YAML_FILES_OUT)
	python _data/simulations.py

data_table: _data/data_table.py
	python _data/data_table.py

%.html: %.yaml
	cp _data/sim_stub.html simulations/all/$<

sim_landing

simulations: yamllint build_charts data_table

hexbin: $(HEXBIN_OUT)

notebooks: $(NOTEBOOKS_HTML) $(NOTEBOOKS_MD)

print-%  : ; @echo $* = $($*)
