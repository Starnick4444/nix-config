{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "objection";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HhZ+FXlyC2ijvMMM9F5iv5i6OUIwfMTN9OQgHzkguHo=";
  };

  propagatedBuildInputs =
    with python3Packages;
    [
      frida-python
      click
      prompt-toolkit
      tabulate
      semver
      delegator-py
      requests
      flask
      pygments
      setuptools
    ]
    ++ [ pkgs.litecli ];

  meta = {
    description = "yea";
    homepage = "https://github.com/sensepost/objection";
    maintainers = with lib.maintainers; [ starnick ];
    license = lib.licenses.lgpl3Only;
  };
}
