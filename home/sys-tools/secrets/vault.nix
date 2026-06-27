{ pkgs, lib, config, ... }: with lib; let

	vshOpts = types.submodule ({ ... }: {
		options = {
			enable  = mkEnableOption "vsh";
			package = mkPackageOption pkgs "vsh" {};
		};
	});

	hcpOpts = types.submodule ({ ... }: {
		options = {
			enable  = mkEnableOption "hcp";
			package = mkPackageOption pkgs "hcp" {};
		};
	});

	utilOpts = types.submodule ({ ... }: {
		options = {

			vsh = mkOption {
				description = "Interactive vault shell.";
				type        = vshOpts;
				default     = {};
			};

			hcp = mkOption {
				description = "Vault cloud cli.";
				type        = hcpOpts;
				default     = {};
			};

		};
	});

	vaultOpts = types.submodule ({ ... }: {
		options = {

			# Core options
			enable  = mkEnableOption "vault";
			package = mkPackageOption pkgs "vault" {};

			# Features
			util = mkOption {
				description = "Additional optional utils.";
				type        = utilOpts;
				default     = {};
			};

		};
	});

in {

	options.programs.vault = mkOption {
		description = "HashiCorp Vault";
		type        = vaultOpts;
		default     = {};
	};

	config = let
		cfg = config.programs.vault;

	in mkIf cfg.enable {

		home.packages = with cfg.util; [ cfg.package ]
		++ optionals vsh.enable [ vsh.package ]
		++ optionals hcp.enable [ hcp.package ];

		home.file = {

			# Vault CLI config file.
			".vault".text = concatStringsSep "\n" [
				"token_helper = \"${config.xdg.dataHome}/bin/vault-libsecret\""
				""
			];

		};

		xdg.dataFile = {

			# Token helper script.
			"bin/vault-libsecret" = {
				source     = ./vault-libsecret.sh;
				executable = true;
			};

		};

	};

}
