{ inputs, ... }: {
  flake.homeModules.manix = { pkgs, ... }: {
    config = {

      home.packages = with pkgs; [
        inputs.manix.packages.${system}.manix
      ];

    };
  };
}
