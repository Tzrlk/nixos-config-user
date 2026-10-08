{ config, pkgs, lib, ... }: let
  _config = config;
  _java = _config.programs.java;
in {

  # Extend the existing home-manager module so we don't have to set JAVA_HOME
  # or deal with default package logic ourselves.
  # https://home-manager-options.extranix.com/?query=programs.java
  options.programs.java = {

    # Making this an option allows us to drive other config off it as well,
    # such as maven's toolchain config.
    extras = lib.mkOption {
      description = "List of extra Java packages to install";
      type = lib.types.listOf lib.types.package;
      default = [];
    };

  };

  config = lib.mkIf _java.enable {
    home.file = builtins.listToAttrs (builtins.map
      (pkg: {
        name = ".jdks/${pkg.pname}-${pkg.version}";
        value = {
          source = "${pkg.home}";
        };
      })
      (lib.flatten [ _java.package _java.extras ]));
  };

}
