{ pkgs, inputs, system, ... }: {
  config = {
    home.packages = with pkgs; [
      inputs.nix-gui.packages.${system}.nix-gui
    ];
  };
}
