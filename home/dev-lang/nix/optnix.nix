{ pkgs, inputs, system, ... }: {
  config = {
    home.packages = with pkgs; [
      inputs.optnix.packages.${system}.optnix
    ];
  };
}
