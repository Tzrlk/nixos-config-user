{ ... }: {

	imports = [
		./idea-ultimate.nix
		./remote.nix
		./toolbox.nix
	];

	config = {

		programs = {

			idea-ultimate = {
				enable = true;
				plugins = [
					"com.euphoricity.gitignore"
					"com.github.copilot"
					"com.github.xepozz.gitcodeowners"
					"com.intellij.kubernetes"
					"com.intellij.properties"
					"com.intellij.swagger"
					"com.microsoft.tooling.msservices.intellij.azure"
					"com.redhat.devtools.lsp4ij"
					"Docker"
					"name.kropp.intellij.makefile"
					"net.sjrx.intellij.plugins.systemdunitfiles"
					"nix-idea"
					"org.asciidoctor.intellij.asciidoc"
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
					"PlantUML integration"
					"PythonCore"
					"Pythonid"
					"ru.adelf.idea.dotenv"
				];
			};

		};

	};

}
