{ inputs, lib, pkgs, ... }: let

	ruby = pkgs.ruby_3_4.withPackages (rpkgs: with rpkgs; [
#		gel
	]);

in {

	imports = [
#		./module.nix
	];

	config = {
		home.packages = [ ruby ];

#		applications.ruby = {
#			enabled = true;
#			version = "3";
#			gems    = known: with known; [
#				gel
#			];
#		};

		# TODO: Run gel setup on profile start
		#       `eval "$(gel shell-setup)"`

	};
}
