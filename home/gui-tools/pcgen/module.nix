{ config, pkgs, lib, ... }: let
  _config = config;
  _pcgen = _config.programs.pcgen;
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf;
in {

  ## OPTIONS #################################################################
  options.programs.pcgen = mkOption {
    description = ''
      PCGen is a program designed to create and manage player characters in
      pen & paper games like D&D. It works on Windows, Mac & Linux, basically
      anywhere the Java JDK works. It will let you create a character under a
      system of rules, track its levels and abilities as you progress,
      inventory and spells. It supports numerous game systems, most notably:
        * D&D 3.5, 4.0, 5.0
        * Pathfinder 1e
        * Starfinder
    '';
    default = {};
    type = types.submodule ({ ... }: {
      options = {
        enable  = mkEnableOption "pcgen";
        package = mkPackageOption pkgs "pcgen" {};
      };
    });
  };

  ## CONFIG ##################################################################
  config = mkIf _pcgen.enable {
    home.packages = [
      _pcgen.package
    ];
  };

}
