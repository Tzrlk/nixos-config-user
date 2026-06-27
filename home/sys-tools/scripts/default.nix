{ ... }: {
  config = {
    home.file = {
      # Misc scripts. Maybe this should be in xdg or outputs?
      # TODO: Look into programs.script-directory.
      "scripts".source = ./files;
    };
  };
}
