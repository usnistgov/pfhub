{ pypkgs, toml }:
pypkgs.buildPythonPackage rec {
  pname = "yq";
  version = "2.7.0";
  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "1nx8i7k275m4kfr3cglnmv6n90svfz0w323va4kgnsq5jssy6bgn";
  };
  doCheck=false;
  buildInputs = [
    pypkgs.pyyaml
    toml
    pypkgs.xmltodict
  ];
  catchConflicts = false;
}
