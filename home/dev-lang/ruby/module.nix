{ inputs, lib, config, ... }: let
	system = "x86_64-linux"; # TODO: Get this from somewhere smarter.

	# Back-reference to actually defined config.
	cfg = config.applications.ruby;

	# Resolve the packages we have available.
	ruby_versions = inputs.nixpkgs-ruby.packages.${system};

	# Resolve the package we're after.
	ruby_package = ruby_versions."ruby-${cfg.version}";

	# Customise the package with desired gems.
	ruby = ruby_package.withPackages cfg.gems;

in {

	options = with lib; {

		applications.ruby = {

			enabled = mkEnableOption "Ruby";

			version = mkOption {
				description = "The version of ruby to use.";
				type        = lib.types.string;
				default     = "3";
				example     = "3.1";
			};

			gems = mkOption {
				description = "The gems to include with this ruby install.";
				type        = lib.types.functionTo lib.types.listOf lib.types.package;
				default     = [];
				example     = [ "bundler" ];
			};

		};

	};

	config = lib.mkIf cfg.enabled {

		# Install the package.
		home.packages = [ ruby ];

		# TODO: Run gel setup on profile start
		#       `eval "$(gel shell-setup)"`

	};

}
