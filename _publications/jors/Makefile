PROJECT=paper

.PHONY: all clean

all:
	mkdir -p build
	latexmk -pdf -jobname=./build/${PROJECT} ${PROJECT}

clean:
	rm -rf build
