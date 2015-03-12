JS_DIR = js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

.PHONY: handlebars clean

all: coffee

clean:
	rm -rf $(COFFEE_JS)

$(COFFEE_JS): $(COFFEE_SCRIPTS)
	coffee --compile --output js $<

coffee: $(COFFEE_JS)

print-%  : ; @echo $* = $($*)

