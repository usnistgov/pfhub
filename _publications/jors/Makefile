PROJECT=paper

build/${PROJECT}.pdf: build/${PROJECT}.bbl
	pdflatex --output-directory=build ${PROJECT}

build/${PROJECT}.bbl: build/${PROJECT}.bcf
	biber build/${PROJECT}

build/${PROJECT}.bcf: ${PROJECT}.tex build
	pdflatex --output-directory=build ${PROJECT}

build:
	mkdir -p build

clean:
	rm -rf build
