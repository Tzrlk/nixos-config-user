{ pkgs, ... }: {
	config = {

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

	};
}
