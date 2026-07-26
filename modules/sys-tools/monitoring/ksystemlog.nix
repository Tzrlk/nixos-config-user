{ config, pkgs, lib, ... }: let
  _config = config;
  _ksystemlog = _config.programs.ksystemlog;
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf;
in {

  options.programs.ksystemlog = with types; mkOption {
    type = submodule ({ ... }: {
      options = {

        enable = mkEnableOption "ksystemlog";

        package = mkPackageOption pkgs "kdePackages.ksystemlog" {};

#        config

      };
    });
  };

  config = mkIf _ksystemlog.enable {
    home.packages = [ _ksystemlog.package ];

    xdg.configFile = {
#      "ksystemlog/ksystemlogrc" = {};
    };
  };

}
