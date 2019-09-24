PROJECT=paper
BUILD=./build

.PHONY: all clean

all:
	mkdir -p ${BUILD}
	latexmk -pdf -jobname=${BUILD}/${PROJECT} ${PROJECT}
	cp ${BUILD}/${PROJECT}.pdf ./
clean:
	rm -rf ${BUILD}
