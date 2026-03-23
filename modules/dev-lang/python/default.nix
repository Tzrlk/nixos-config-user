{ config, lib, pkgs, ... }: {

	# Each version of python
	config = {

		home.packages = with pkgs; [

			# Because it isn't on nixpkgs as a regular package.
			pdm

		];

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pyenv.enable
		programs.pyenv = {
			enable = true;
			package = pkgs.pyenv;
			enableBashIntegration = true;
			rootDirectory = "${config.xdg.dataHome}/pyenv";
		};

		# Manually install the python versions, since installing them via pyenv
		# is a fresh hell requiring `nix-shell -p openssl zlib xz ...etc`
		# https://nixos.org/manual/nixpkgs/stable/#python
		xdg.dataFile = let

			basePkg = pypkg:
				pypkg.withPackages(pypkgs: with pypkgs; [
					pip
					virtualenv
				]);

		in {

			# General LTS versions
			"python-3" = {
				target = "pyenv/versions/3";
				source = basePkg pkgs.python3;
			};

			# Specific versions needed for annoying tools.
			"python-3.10" = {
				target = "pyenv/versions/3.10";
				source = basePkg pkgs.python310;
			};

		};

	};

}
