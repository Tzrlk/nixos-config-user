{ config, pkgs, lib, inputs, ... }: with lib; {

	options.programs.idea = mkOption {
		description = concatStringsSep "" [
			"Local configuration for installation of IntelliJ IDEA."
		];
		type = types.submodule ({ ... }: {
			options = {

				enable = mkEnableOption "idea";

				vmoptions = mkOption {
					description = concatStringsSep "" [
						"Values to populate $IDEA_HOME/idea64.vmoptions with."
					];
					type = with types; nullOr (listOf str);
					default = null;
					example = [
						"-Dide.managed.by.toolbox=false"
						"-Xmx1735m"
					];
				};

				plugins = mkOption {
					description = concatStringsSep "" [
						"IDs of the plugins to install with the IDE."
					];
					type = with types; listOf str;
					default = [];
					example = [
						"Docker"
						"name.kropp.intellij.makefile"
						"nix-idea"
						"org.editorconfig.editorconfigjetbrains"
						"org.jetbrains.plugins.terminal"
						"org.jetbrains.plugins.yaml"
					];
				};

			};
		});
		default = {};
	};

	config = let

		cfg = config.programs.idea;

		# https://github.com/theCapypara/nix-jetbrains-plugins/
		idea = with inputs.nix-jetbrains-plugins.lib;
			buildIdeWithPlugins pkgs "idea" cfg.plugins;

	in mkIf cfg.enable {

		# Add our package to the install list.
		home.packages = [ idea ];

		# Add our package to the remote list.
		programs.jetbrains-remote.ides = [ idea ];

# TODO: Figure this out.
#		nixpkgs.overlays = [
#			(final: prev: {
#
#				jetbrains.idea = prev.jetbrains.idea.overrideAttrs (old: {
#					vmopts = if cfg.vmoptions != null
#						then concatStringsSep "\n" cfg.vmoptions
#						else null;
#				});
#
#			})
#		];

	};

}
