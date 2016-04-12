JS_DIR = js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

HEXBIN_OUT = images/hexbin.jpg data/hexbin.json
HEXBIN_IN = _data/hexbin.yaml _data/hexbin.py

.PHONY: handlebars clean preprocess

all: coffee hexbin

clean:
	rm -rf $(COFFEE_JS)

$(JS_DIR)/%.js: $(COFFEE_DIR)/%.coffee
	coffee --compile --output js $<

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

coffee: $(COFFEE_JS)

hexbin: $(HEXBIN_OUT)

print-%  : ; @echo $* = $($*)
