{ pkgs, inputs, system, ... }: {
  config = {

    home.packages = with pkgs; [
      inputs.dix.packages.${system}.default
    ];

  };
}
