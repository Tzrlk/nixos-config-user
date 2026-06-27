{ config, pkgs, lib, ... }: let
	_config   = config;
	_programs = _config.programs;
	_nushell  = _programs.nushell;

in {

	# Only configure NuShell if it's actually enabled.
	config = lib.mkIf _nushell.enable {

		# https://github.com/nushell/awesome-nu/blob/main/plugin_details.md
		programs.nushell.plugins = with pkgs; [

			## Core Plugins ###################################################
			# https://www.nushell.sh/book/plugins.html

			nushell-plugin-formats

			# https://www.nushell.sh/commands/docs/gstat.html
			nushell-plugin-gstat

			# https://github.com/pola-rs/polars
			nushell-plugin-polars

			# https://www.nushell.sh/commands/docs/query.html
			nushell-plugin-query

			## Third-Party Plugins ############################################

			# https://github.com/devyn/nu_plugin_dbus
			nushell-plugin-dbus

			# https://github.com/Yethal/nu_plugin_hcl
			nushell-plugin-hcl

			# https://github.com/abusch/nu_plugin_semver
			nushell-plugin-semver

			# https://github.com/fennewald/nu_plugin_net
			nushell-plugin-net

			# https://github.com/cptpiepmatz/nu-plugin-highlight
			nushell-plugin-highlight

			# https://github.com/JosephTLyons/nu_plugin_units
			nushell-plugin-units

			# https://github.com/Kissaki/nu_plugin_bson
			nushell-plugin-bson

			# https://github.com/idanarye/nu_plugin_skim
			# https://github.com/skim-rs/skim
			nushell-plugin-skim

		];

	};

}
