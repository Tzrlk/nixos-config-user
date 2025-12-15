{ config, pkgs, lib, ... }: let

	cfg = config.programs.sshm;

	json = pkgs.formats.json;
	jsonConf = json {
		# Custom settings I assume.
	};

	opts_cfg = with lib; types.submodule {
		options = {

			key_bindings = mkOption {
				description = concatStringsSep " " [
					"SSHM supports customizable key bindings through a
					configuration file. This is particularly useful for users
					who want to modify the default quit behavior."
				];
				type = opts_cfg_binds;
				default = {};
				example = {
					disable_esc_quit = true;
				};
			};

		};
	};

	opts_cfg_binds = with lib; types.submodule {
		options = with types; {

			quit_keys = mkOption {
				description = concatStringsSep " " [
					"Array of keys that will quit the application."
				];
				type = listOf str;
				default = [ "q" "ctrl+c" ];
				example = [ "x" "alt+q" ];
			};

			disable_esc_quit = mkOption {
				description = concatStringsSep " " [
					"Boolean flag to disable ESC key from quitting the"
					"application."
				];
				type = bool;
				default = false;
				example = true;
			};

		};
	};

	package = import ./package.nix {
		inherit pkgs lib;
	};

in {

	options.programs.sshm = with lib; {

		enable = mkEnableOption {
			description = concatStringsSep "" [
				"Install and configure SSHM."
			];
		};

		config = mkOption {
			description = concatStringsSep "" [
				"Configuration for the SSHM application."
			];
			type = opts_cfg;
			default = {};
			example = {
				key_bindings = {
					quit_keys = [ "alt+q" ];
				};
			};
		};

	};

	config = lib.mkIf cfg.enable {

		home.packages = [
			package
		];

		xdg.configFile = {
			"sshm/config.json".source =
				jsonConf.generate "config.json" cfg.config;
		};

	};

}
