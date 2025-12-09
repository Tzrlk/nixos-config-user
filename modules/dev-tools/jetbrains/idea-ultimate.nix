{ config, pkgs, inputs, system, ... }: {

	options.programs.idea-ultimate = with pkgs.lib; mkOption {
		description = concatStringsSep "" [
			"Local configuration for installation of IntelliJ IDEA Ultimate."
		];
		type    = types.submodule;
		default = {};
		options = {

			vmoptions = mkOption {
				description = concatStringsSep "" [
					"Values to populate $IDEA_HOME/idea64.vmoptions with."
				];
				type = types.nullOr(types.listOf(types.string));
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
				type = types.listOf(types.string);
				default = [
					"com.intellij.kubernetes"
					"com.intellij.properties"
					"com.intellij.swagger"
					"Docker"
					"name.kropp.intellij.makefile"
					"net.sjrx.intellij.plugins.systemdunitfiles"
					"nix-idea"
					"org.editorconfig.editorconfigjetbrains"
					"org.intellij.plugins.hcl"
					"org.jetbrains.idea.maven"
					"org.jetbrains.kotlin"
					"org.jetbrains.plugins.github"
					"org.jetbrains.plugins.remote-run"
					"org.jetbrains.plugins.rest"
					"org.jetbrains.plugins.ruby"
					"org.jetbrains.plugins.ruby-chef"
					"org.jetbrains.plugins.terminal"
					"org.jetbrains.plugins.yaml"
					"org.jetbrains.security.package-checker"
					"org.sonarlint.idea"
					"org.toml.lang"
					"PythonCore"
					"Pythonid"
					"ru.adelf.idea.dotenv"
				];
			};

		};
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

	in {

		# Add our package to the remote list.
		programs.jetbrains-remote.ides = [ idea-ultimate ];

		# Add our package to the install list.
		home.packages = [ idea-ultimate ];

		xdg.configFile = {

			# Control virtual machine configuration
			"idea64.vmoptions" = {
				enable = cfg.vmoptions != null;
				target = "JetBrains/${idea_edition}/idea64.vmoptions";
				text   = pkgs.lib.concatStringsSep "\n" cfg.vmoptions;
			};

		};

	};

}
