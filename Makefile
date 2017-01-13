HEXBIN_OUT = images/hexbin.jpg data/hexbin.json
HEXBIN_IN = data/hexbin.yaml _data/hexbin.py

NOTEBOOKS := $(shell find . -name '*.ipynb' -not -path "*.ipynb_checkpoints/*" -not -path "./_site/*" -not -path "./_data/*")
NOTEBOOKS_HTML := $(NOTEBOOKS:%.ipynb=%.ipynb.raw.html)
NOTEBOOKS_MD := $(NOTEBOOKS:%.ipynb=%.ipynb.md)

YAML_FILES := $(shell find . -name 'meta.yaml')
YAML_DIRS := $(subst meta.yaml,,$(YAML_FILES))

vpath meta.yaml $(YAML_DIRS)

YAML_FILES_IN := $(wildcard _data/simulations/*/meta.yaml)
YAML_FILES_OUT := $(subst meta.yaml,meta.yaml.out,$(YAML_FILES_IN))
# MODULES   := widgets test ui
# SRC_DIR   := $(addprefix src/,$(MODULES))
# BUILD_DIR := $(addprefix build/,$(MODULES))

# SRC       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.cpp))
# OBJ       := $(patsubst src/%.cpp,build/%.o,$(SRC))
# INCLUDES  := $(addprefix -I,$(SRC_DIR))
# vpath %.yaml

.PHONY: clean build_charts

all: hexbin notebooks simulations

$(JS_DIR)/%.js: $(COFFEE_DIR)/%.coffee
	coffee --compile --output js $<

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

simulations: yamllint build_charts

# simulations: yaml
# 	for FILE in _data/simulations/*/meta.yaml; do echo ""; echo $$FILE; pykwalify -d $$FILE -s _data/simulations/example/schema.yaml; done && python _data/simulations.py

# something:
# 	pykwalify -d _data/simulations/mmsp_1c_raspi/meta.yaml -s _data/simulations/example/schema.yaml;

hexbin: $(HEXBIN_OUT)

notebooks: $(NOTEBOOKS_HTML) $(NOTEBOOKS_MD)

print-%  : ; @echo $* = $($*)
