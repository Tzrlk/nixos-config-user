{ inputs, ... }: {
  flake.homeModules.nix-output-monitor = { pkgs, ... }: {
    config = {

      home.packages = with pkgs; [
        inputs.nix-output-monitor.packages.${system}.default
      ];

    };
  };
}
