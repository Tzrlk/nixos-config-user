{ pkgs, lib, ... }: pkgs.buildGoModule rec {
	pname   = "sshm";
	version = "1.9.0";
	meta    = {
		license     = lib.licenses.mit;
		homepage    = "https://github.com/Gu1llaum-3/sshm";
		description = lib.concatStringsSep " " [
			"SSHM is a beautiful command-line tool that transforms how you"
			"manage and connect to your SSH hosts. Built with Go and featuring"
			"an intuitive TUI interface, it makes SSH connection management"
			"effortless and enjoyable."
		];
	};

	src = pkgs.fetchFromGitHub {
		owner = "Gu1llaum-3";
		repo  = "sshm";
		rev   = "v${version}";
		hash  = "sha256-0jEKBgA8NoQvR56+ssBh8y7YvVvOmBtivZB39/AHvwU=";
	};

	vendorHash = "sha256-aU/+bxcETs/Jq5FVAdiioyuc1AufvWeiqFQ7uo1cK1k=";

	# The check phase tries to create a temporary directory in the users home,
	# so we have to create a temporary directory to avoid permissions errors.
	preCheck = lib.concatStringsSep "\n" [
		"mkdir -p .home"
		"export HOME=\"$${PWD}.home\""
	];

}
