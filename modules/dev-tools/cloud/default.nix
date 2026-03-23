{ pkgs, ... }: {

	config = {

		home.packages = with pkgs; [

			# AWS
			awscli2

			# Azure
			azure-cli

		];

		programs = {

			awscli = {
				enable  = true;
				package = pkgs.awscli2;
				# Manage settings manually / via symlink.
			};

		};

	};

}
