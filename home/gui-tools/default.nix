{ self, ... }: {
  imports = [
  ];
  flake.homeModules = {
    nix-gui = ./nix-gui.nix;
  };
}
