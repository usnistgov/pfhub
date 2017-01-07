HEXBIN_OUT = images/hexbin.jpg data/hexbin.json
HEXBIN_IN = data/hexbin.yaml _data/hexbin.py

NOTEBOOKS := $(shell find . -name '*.ipynb' -not -path "*.ipynb_checkpoints/*" -not -path "./_site/*")
NOTEBOOKS_HTML := $(NOTEBOOKS:%.ipynb=%.ipynb.raw.html)
NOTEBOOKS_MD := $(NOTEBOOKS:%.ipynb=%.ipynb.md)

.PHONY: clean simulations

all: hexbin notebooks

$(JS_DIR)/%.js: $(COFFEE_DIR)/%.coffee
	coffee --compile --output js $<

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

%.ipynb.raw.html: %.ipynb
	jupyter-nbconvert $< --output $(notdir $@) --to html --template basic

%.ipynb.md: %.ipynb
	cp ./template.ipynb.md $@
	sed -i -- 's/notebook_name/$(notdir $<)/' $@

simulations:
	for FILE in _data/simulations/*/meta.yaml; do echo ""; echo $$FILE; pykwalify -d $$FILE -s _data/simulations/example/schema.yaml; done && python _data/simulations.py

hexbin: $(HEXBIN_OUT)

notebooks: $(NOTEBOOKS_HTML) $(NOTEBOOKS_MD)

print-%  : ; @echo $* = $($*)
