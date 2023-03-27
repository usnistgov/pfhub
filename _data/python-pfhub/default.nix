{ lib
, buildPythonPackage
, pytestCheckHook
, python
, numpy
, pytest
, toolz
, pyyaml
, pandas
, plotly
, pytestcov
, jupyter
, nbval
, requests-cache
, chevron
, zlib
, zip
, unzip
}:
buildPythonPackage rec {
  pname = "pfhub";
  version = "0.1";

  src = lib.cleanSource ./.;

  propagatedBuildInputs = [
    numpy
    pytest
    toolz
    pyyaml
    pandas
    plotly
    pytestcov
    jupyter
    nbval
    requests-cache
    chevron
    zlib
    zip
    unzip
  ];

  checkInputs = [
    python
  ];

  checkPhase = ''
    ${python.interpreter} -c "import pfhub; pfhub.test()"
  '';

  pythonImportsCheck = ["pfhub"];

  meta = with lib; {
    homepage = "https://github.com/usnistgov/pfhub";
    description = "The Phase Field Community Hub";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
