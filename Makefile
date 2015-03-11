JS_DIR = js
HANDLEBARS_DIR = _handlebars
TEMPLATES = $(wildcard $(HANDLEBARS_DIR)/*.handlebars)
TEMPLATE_JS = $(JS_DIR)/templates.js

COFFEE_DIR = _coffee
COFFEE_SCRIPTS = $(wildcard $(COFFEE_DIR)/*.coffee)
COFFEE_JS = $(patsubst $(COFFEE_DIR)/%.coffee,$(JS_DIR)/%.js,$(COFFEE_SCRIPTS))

.PHONY: handlebars clean coffee

all: handlebars coffee

clean:
	rm -rf $(TEMPLATE_JS) $(COFFEE_JS)

$(TEMPLATE_JS): $(TEMPLATES)
	handlebars $(TEMPLATES) -f $(TEMPLATE_JS)

$(COFFEE_JS): $(COFFEE_SCRIPTS)
	coffee --compile --output js $<

handlebars: $(TEMPLATE_JS)

coffee: $(COFFEE_JS)

print-%  : ; @echo $* = $($*)

