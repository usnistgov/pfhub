JS_DIR = js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

HEXBIN_OUT = images/hexbin.jpg data/hexbin.json
HEXBIN_IN = _data/hexbin.yaml _data/hexbin.py

NOTEBOOKS := $(shell find . -name '*.ipynb' -not -path "*.ipynb_checkpoints/*")
NOTEBOOKS_HTML := $(NOTEBOOKS:%.ipynb=%.ipynb.raw.html)

.PHONY: handlebars clean preprocess

all: coffee hexbin notebooks

clean:
	rm -rf $(COFFEE_JS)

$(JS_DIR)/%.js: $(COFFEE_DIR)/%.coffee
	coffee --compile --output js $<

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

%.ipynb.raw.html: %.ipynb
	jupyter-nbconvert $< --output $@ --to html --template basic


coffee: $(COFFEE_JS)

hexbin: $(HEXBIN_OUT)

notebooks: $(NOTEBOOKS_HTML)

print-%  : ; @echo $* = $($*)
