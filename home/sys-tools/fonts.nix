{ pkgs, ... }: {
  config = {

    home.packages = with pkgs; [
      curl

      # Provide better unicode support for symbols.
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      unifont
      vista-fonts

    ];

  };
}
