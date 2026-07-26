{ self, config, pkgs, lib, ... }: let
  _config = config;
  _herolab = _config.programs.herolab;
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf;
  inherit (pkgs)
    system;
  inherit (self.packages.${system})
    herolab;
in {

  ## OPTIONS #################################################################
  options.programs.herolab = mkOption {
    default = {};
    type = types.submodule ({ ... }: {
      options = {
        enable  = mkEnableOption "herolab";
        package = mkPackageOption pkgs herolab {};
      };
    });
  };

  ## CONFIG ##################################################################
  config = mkIf _herolab.enable {
    home.packages = [
      _herolab.package
    ];
  };

}
