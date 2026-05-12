{ config, pkgs, lib, inputs, system, ... }: with lib; {

	options.programs.idea-ultimate = mkOption {
		description = concatStringsSep "" [
			"Local configuration for installation of IntelliJ IDEA Ultimate."
		];
		default = {};
		type    = types.submodule ({ ... }: {
			options = {

				enable = mkEnableOption "idea-ultimate";

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
					default = [
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
	};

	config = let

		cfg = config.programs.idea-ultimate;

		jetbrains-plugins = {
			plugins = inputs.nix-jetbrains-plugins.plugins.${system};
			lib     = inputs.nix-jetbrains-plugins.lib.${system};
		};

		buildIde = jetbrains-plugins.lib.buildIdeWithPlugins pkgs.jetbrains;

		# https://github.com/theCapypara/nix-jetbrains-plugins/blob/main/generated/ides/idea-ultimate-2025.2.4.json
		idea-ultimate = buildIde "idea-ultimate" cfg.plugins;

		# TODO: Get this from the package.
		idea_edition = "IntelliJIdea2025.2";

	in mkIf cfg.enable {

		# Add our package to the remote list.
		programs.jetbrains-remote.ides = [ idea-ultimate ];

		# Add our package to the install list.
		home.packages = [ idea-ultimate ];

		xdg.configFile = {

			# Control virtual machine configuration
			"idea64.vmoptions" = {
				enable = cfg.vmoptions != null;
				target = "JetBrains/${idea_edition}/idea64.vmoptions";
				text   = concatStringsSep "\n" cfg.vmoptions;
			};

		};

	};

}
