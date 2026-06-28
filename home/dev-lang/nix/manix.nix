{ pkgs, inputs, system, ... }: {
  config = {

    home.packages = with pkgs; [
      inputs.manix.packages.${system}.default
    ];

  };
}
