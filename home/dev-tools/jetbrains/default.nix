{ pkgs, jetbrains-plugins, ... }: let
	buildIde = jetbrains-plugins.lib.buildIdeWithPlugins pkgs.jetbrains;

	# https://github.com/theCapypara/nix-jetbrains-plugins/blob/main/generated/ides/idea-ultimate-2025.2.4.json
	idea-ultimate = buildIde "idea-ultimate" [
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

in {

	home = {

		# Toolbox for registration.
		packages = with pkgs; [
			jetbrains-toolbox
			idea-ultimate
		];

		sessionPath = [
			"\${XDG_DATA_HOME}/JetBrains/Toolbox/scripts"
		];

	};

	xdg = {

		mimeApps.defaultApplications = {
			"x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
		};

	};

	# Just in case I switch back to using the remote version.
	programs.jetbrains-remote = {
		enable = true;
		ides   = [
			idea-ultimate
		];
	};


}
