{ self, ... }: {
  flake.defaultTemplate = self.templates.nixos;
  flake.templates = {

    nixos = {
      path        = ./templates/nixos;
      description = "NixOS and Home manager config";
    };

    ubuntu-wsl = {
      path        = ./templates/ubuntu-wsl;
      description = "System and Home manager config for Ubuntu in WSL2";
    };

  };
}
