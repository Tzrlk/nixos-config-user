{ pkgs, inputs, system, ... }: {
  config = {

    home.packages = with pkgs; [
      inputs.nix-output-monitor.packages.${system}.default
    ];

  };
}
