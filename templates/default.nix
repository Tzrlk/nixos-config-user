{ ... }: {

  nixos = {
    path        = ./nixos;
    description = "NixOS and Home manager config";
  };

  ubuntu-wsl = {
    path        = ./ubuntu-wsl;
    description = "System and Home manager config for Ubuntu in WSL2";
  };

}
