{ inputs, ... }: {
  flake.homeModules.nix-tree = { pkgs, ... }: {
    config = {

      home.packages = with pkgs; [
        inputs.nix-tree.packages.${system}.default
      ];

    };
  };
}
