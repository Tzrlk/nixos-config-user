{ pkgs, ... }: {
	config = {

		home.packages = with pkgs; [

			# The official CLI
			terraform

			# Documentation generation
			terraform-docs

			# Official language server
			terraform-ls

			# Linting tool + rulesets.
			tflint
			tflint-plugins.tflint-ruleset-aws

		];

	};
}
