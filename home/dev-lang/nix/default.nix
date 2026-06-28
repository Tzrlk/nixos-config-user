{ ... }: {
  flake.homeModules = {
    dix = ./dix.nix;
    manix = ./manix.nix;
    nh = ./nh.nix;
    nix-du = ./nix-du.nix;
    nix-gui = ./nix-gui.nix;
    nix-output-monitor = ./nix-output-monitor.nix;
    nix-tree = ./nix-tree.nix;
    nixd = ./nixd.nix;
    nixdoc = ./nixdoc.nix;
    nixfmt = ./nixfmt.nix;
    optnix  = ./optnix.nix;
  };
}
