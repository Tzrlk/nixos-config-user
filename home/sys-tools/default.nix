{ pkgs, ... }: {
  flake.homeModules = {
		edge        = ./edge;
		gpg         = ./gpg;
		nixos       = ./nixos;
		podman      = ./podman;
		scripts     = ./scripts;
		secrets     = ./secrets;
		shell       = ./shell;
		ssh         = ./ssh;
		taskwarrior = ./taskwarrior;
		xdg         = ./xdg;
		fonts       = ./fonts.nix;
		less        = ./less.nix;
		man         = ./man.nix;
  };
}
