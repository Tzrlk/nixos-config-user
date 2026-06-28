{ pkgs, inputs, system, ... }: {
  config = {

    home.packages = with pkgs; [
      inputs.nix-tree.packages.${system}.default
    ];

  };
}
