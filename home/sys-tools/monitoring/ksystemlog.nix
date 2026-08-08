{ self, ... }: {

  flake.homeModules.ksystemlog = { config, pkgs, lib, ... }: let
    _ksystemlog = config.programs.ksystemlog;
    repoFileLink = config.lib.file
      "nixos-config-user" ./.;
    inherit (lib)
      types
      mkOption
      mkEnableOption
      mkPackageOption
      mkIf;
  in {

    imports = [
      self.homeModules.links
    ];

    options.programs.ksystemlog = mkOption {
      default = {};
      type = types.submodule ({ ... }: {
        options = {
          enable  = mkEnableOption "ksystemlog";
          package = mkPackageOption pkgs "ksystemlog" {};
        };
      });
    };

    config = mkIf _ksystemlog.enable {
      home.packages = [ _ksystemlog.package ];
      xdg.configFile = {
        "ksystemlogrc" = {
          source = repoFileLink ./ksystemlog.ini;
        };
      };
    };

  };

}
