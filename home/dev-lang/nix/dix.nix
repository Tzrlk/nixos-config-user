{ inputs, ... }: {
  flake.homeModules.dix = { pkgs, ... }: {
    config = {

      home.packages = with pkgs; [
        inputs.dix.packages.${system}.default
      ];

    };
  };
}
