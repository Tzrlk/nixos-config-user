{ config, pkgs, lib, ... }: let
	qq = pkgs.callPackage ./qq.nix {};
in {

	config = {

		home.packages = with pkgs; [

			# https://github.com/wader/fq
			fq

			jq
			jq-lsp

			qq

		];

		programs.jq = {
			enable = true;
			package = pkgs.jq;
#			colors = null;
		};

	};

}
