{ inputs, ... }: {
  flake.homeModules.optnix = { pkgs, ... }: {
    config = {

      home.packages = with pkgs; [
        inputs.optnix.packages.${system}.optnix
      ];

    };
  };
}
