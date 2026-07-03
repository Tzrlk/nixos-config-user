{ ... }: {
  imports = [
    ./dix.nix
    ./manix.nix
    ./nh.nix
    ./nix-output-monitor.nix
    ./nix-tree.nix
    ./optnix.nix
  ];
  flake.homeModules = {
    nix-du = ./nix-du.nix;
    nixd = ./nixd.nix;
    nixdoc = ./nixdoc.nix;
    nixfmt = ./nixfmt.nix;
  };
}
