# This just enables and configures nixfmt within treefmt-nix.
{ pkgs, ... }: {
  imports = [
    ./git-hooks.nix
    ./treefmt.nix
  ];
  perSystem = { pkgs, ... }: {

    treefmt.programs.nixfmt = {
      enable = true;
      package = pkgs.nixfmt;
    };

    pre-commit.settings.hooks.nixpkgs-fmt = {
      enable = true;
      package = pkgs.nixfmt;
    };

  };
}
