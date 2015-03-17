JS_DIR = js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

CODES_OUT = data/codes.json
CODES_IN = _data/codes.yaml _data/codes.py

HEXBIN_OUT = images/hexbin.jpg data/hexbin.json
HEXBIN_IN = _data/hexbin.yaml _data/hexbin.py

.PHONY: handlebars clean preprocess

all: coffee hexbin codes

clean:
	rm -rf $(COFFEE_JS)

$(JS_DIR)/%.js: $(COFFEE_DIR)/%.coffee
	coffee --compile --output js $<

$(HEXBIN_OUT): $(HEXBIN_IN)
	python _data/hexbin.py

$(CODES_OUT): $(CODES_IN)
	python _data/codes.py

coffee: $(COFFEE_JS)

hexbin: $(HEXBIN_OUT)

codes: $(CODES_OUT)

print-%  : ; @echo $* = $($*)

