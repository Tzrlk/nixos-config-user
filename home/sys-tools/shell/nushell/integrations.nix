{ config, lib, ... }: let
	_config = config;
	_programs = _config.programs;
	_services = _config.services;

in {

	# Only configure NuShell if it's actually enabled.
	config = lib.mkIf _programs.nushell.enable {

		programs = {

			dircolors = lib.mkIf _programs.dircolors.enable {
				enableNushellIntegration = true;
			};

			direnv = lib.mkIf _programs.direnv.enable {
				enableNushellIntegration = true;
			};

			starship = lib.mkIf _programs.starship.enable {
				enableNushellIntegration = true;
			};

		};

		services = {

			gpg-agent = lib.mkIf _services.gpg-agent.enable {
				enableNushellIntegration = true;
			};

			ssh-agent = lib.mkIf _services.ssh-agent.enable {
				enableNushellIntegration = true;
			};

		};

	};

}
