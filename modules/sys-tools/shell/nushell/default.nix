{ config, pkgs, lib, ... }: let
	_config   = config;
	_programs = _config.programs;
	_nushell  = _programs.nushell;

in {

	imports = [
		./integrations.nix
		./plugins.nix
	];

	# Only configure NuShell if it's actually enabled.
	config = lib.mkIf _nushell.enable {

		programs.nushell = {
		};

	};

}
