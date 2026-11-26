final: prev: let
  inherit (final.python314Packages)
    buildPythonApplication
    buildPythonPackage;
  inherit (final)
    fetchFromGitHub;

in {

  python314 = prev.python314.override {
    packageOverrides = pyFinal: pyPrev: {

      # NOTE: Compiling this on python 3.13 is a nightmare.
      snowflake-snowpark-python = buildPythonPackage (finalAttrs: {
        pname = "snowflake-snowpark-python";
        version = "1.56.0";

        src = fetchFromGitHub {
          owner = "snowflakedb";
          repo  = "snowpark-python";
          tag   = "v${finalAttrs.version}";
          hash  = "sha256-6I8Zel5zGNL+a3wGOJwRc/0jfEjmYv5tgHO7bEqPSl8=";
        };

        pyproject = true;
        build-system = with pyFinal; [
          setuptools
        ];
        nativeBuildInputs = with final; [
          mypy-protobuf
        ];
        dependencies = with pyFinal; [
          cloudpickle
          mypy-protobuf_3_6
          python-dateutil
          pyyaml
          snowflake-connector-python
          tzlocal
        ];

        pythonRelaxDeps = true;

      });

      aws-sam-translator = pyPrev.aws-sam-translator.overridePythonAttrs (finalAttrs: {
        version = "1.116.0";
        src = fetchFromGitHub {
          owner = "aws";
          repo  = "aws-sam-translator";
          tag   = "v${finalAttrs.version}";
          hash  = final.lib.fakeHash;
        };
        disabled = false; # Disable 3.14 version check.
      });

      chalice = pyPrev.chalice.overridePythonAttrs (finalAttrs: {
        version = "1.34.0";
        src = fetchFromGitHub {
          owner = "aws";
          repo = "chalice";
          tag = finalAttrs.version;
          hash = "sha256-c5xzgrxRFRlvgMnf/L8rhG7rYJLtuMvDZHYsPaHkdRs=";
        };
        disabled = false; # Disable 3.14 version check.
      });

      # For some reason, this _keeps_ trying to fetch the old sources.
      cfn-lint = pyPrev.cfn-lint.overridePythonAttrs (finalAttrs: {
        version = "1.59.0";
        src = fetchFromGitHub {
          owner = "aws";
          repo  = "cfn-lint";
          tag   = "v${finalAttrs.version}";
          hash  = final.lib.fakeHash;
        };
        dependencies = with pyFinal; [
        ];
      });

      aioboto3 = pyPrev.aioboto3.overridePythonAttrs (finalAttrs: {
        version = "15.5.0";
        src = fetchFromGitHub {
          owner = "terrycain";
          repo  = "aioboto3";
          tag   = "v${finalAttrs.version}";
          hash  = "sha256-yGKjcZlXs1f72OGX5rUWvfDKZAYU3ZV2RVQnd0InxBQ=";
        };
        dependencies = with pyFinal; [
        ];
      });

      snowflake-connector-python = pyPrev.snowflake-connector-python.overridePythonAttrs (finalAttrs: {
        version = "4.8.1";
        src = fetchFromGitHub {
          owner = "snowflakedb";
          repo  = "snowflake-connector-python";
          tag   = "v${finalAttrs.version}";
          hash  = "sha256-bJK6U5lomcPMGeKEmv+9m+uM5+3GJKKUA3dEwP/ynVo=";
        };
      });

    };
  };

  python314Packages = final.python314.pkgs;

  snowflake-cli = (prev.snowflake-cli.override {
    python3Packages = final.python314Packages;
  }).overridePythonAttrs (finalAttrs: prevAttrs: {
    version = "3.31.0";

    src = fetchFromGitHub {
      owner = "snowflakedb";
      repo  = "snowflake-cli";
      tag   = "v${finalAttrs.version}";
      hash  = "sha256-VMoyGwDI/RL7ZkIfOU2ftZoKaUcI/+/54o0xtjhMBLQ=";
    };

    # Patch no-longer needed.
    patches = [];

    dependencies = with final.python314Packages; [
      configobj # new
      jaraco-context # new
      keyring # new
      protobuf # new
      python-dotenv # new
      requests
      requirements-parser
      rich
      setuptools
      snowflake-connector-python
      snowflake-core
      snowflake-snowpark-python # new
      tomlkit
      typer
      urllib3
      websocket-client # new
    ];

  });

  config = prev.config // {
    permittedInsecurePackages = [
#      "pypy2.7-setuptools-44.0.0"
#      "pypy2.7-pip-20.3.4"
    ];
  };

}
