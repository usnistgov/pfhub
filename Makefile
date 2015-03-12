JS_DIR = js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

JSON = data/codes.json

.PHONY: handlebars clean preprocess

all: coffee preprocess

clean:
	rm -rf $(COFFEE_JS)

$(COFFEE_JS): $(COFFEE_SCRIPTS)
	coffee --compile --output js $<

$(JSON): _data/codes.yaml
	python preprocess.py

coffee: $(COFFEE_JS)

preprocess: $(JSON)

print-%  : ; @echo $* = $($*)

