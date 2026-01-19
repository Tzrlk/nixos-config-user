{ pkgs, ... }: {

	config = {

		# TODO: Terraform providers?
		home.packages = with pkgs; [

			# Terraform config synthesis
			cdktf-cli

			# The official CLI
			terraform

			# Documentation generation
			terraform-docs

			# Official language server
			terraform-ls

			# Tool for handling complex projects
			terragrunt

			# Linting tool + rulesets.
			tflint
			tflint-plugins.tflint-ruleset-aws

			# Tool for handling complex migrations
			tfmigrate

		];

		# Enable libsecret integration via secret-tool.
		home.file = {
			".local/bin/terraform-credentials-libsecret" = {
				source = ./terraform-credentials-libsecret.sh;
				executable = true;
			};
		};

	};

}
