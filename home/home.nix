{ ... }: {
  config = {

    fonts.fontconfig.enable = true;

    home.preferXdgDirectories = true;

    # Let home-manager manage itself.
    programs.home-manager.enable = true;

    manual = {
      json.enable = true; # <profile>/share/doc/home-manager/options.json
      manpages.enable = true;
    };

    # Reload systemd when config changes.
    systemd.user = {
      startServices = "sd-switch";
    };

  };
}
