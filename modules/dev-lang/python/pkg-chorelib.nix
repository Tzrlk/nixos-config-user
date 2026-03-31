{
	pkgs ? import <nixpkgs>,
	pypkgs,
	fetchFrom ? "github",
	switch ? (input: options: options.${input}),
	...
}: pypkgs.buildPythonPackage rec {
	pname   = "chorelib";
	version = "0.2.0";
	meta    = rec {
		description     = "A Python build automation framework — like Make, but in Python.";
		longDescription = pkgs.lib.joinStringsSep " " [
			"chorelib focuses on keeping Make-style speed and rebuild behavior while letting you write build logic in"
			"real Python. chorelib uses a decorator-based DSL for defining build rules and tasks, with dependency"
			"management, parallel execution, and mtime-based rebuild detection."
		];
		homepage        = "https://github.com/atsuoishimoto/chorelib";
		downloadPage    = "${homepage}/releases";
		changelog       = "${downloadPage}/tag/${version}";
		license         = pkgs.lib.licenses.mit;
	};

	src = switch fetchFrom {

		# Pre-packaged
		pypi = pkgs.fetchPypi {
			inherit pname version;
			hash = "sha256-ddbc97aafdb7fca28ef5371f1e8208226459cc76fe0099b652cf9e002c672722";
		};

		# Compile from sources.
		github = pkgs.fetchFromGitHub {
			owner  = "atsuoishimoto";
			repo   = pname;
			rev    = "v${version}";
			sha256 = "sha256-isOVkEEJdmPBKvebKQSM95uOYYBQJiM6VwctIjoaSsY=";
		};

	};

	# Build config.
	pyproject    = true;
	doCheck      = false; # Don't run tests
	build-system = with pypkgs; [
		uv-build
	];
	postPatch = ''
		substituteInPlace pyproject.toml \
			--replace-fail "uv_build>=0.8.15,<0.9.0" "uv_build>=0.8.15"
	'';

}
