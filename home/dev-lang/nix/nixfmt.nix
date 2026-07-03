{ pkgs, ... }: {
  config = {

    # Nix formatter.
    home.packages = with pkgs; [
      nixfmt
    ];

  };
}
