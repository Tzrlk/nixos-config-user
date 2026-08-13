{ lib, pkgs, ... }: let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption;
  inherit (lib.types)
    submodule
    attrsOf
    nullOr;
in {
  options = {

    enable = mkEnableOption "snowflake-cli";

    package = mkPackageOption pkgs "snowflake-cli" {};

    config = mkOption {
      description = ''
        Configuration for the Snowflake CLI.
      '';
      type = nullOr (submodule (import ./opts-config.nix));
      default = null;
    };

    connections = lib.mkOption {
      description = ''
        Connection config for the Snowflake CLI.
      '';
      type    = nullOr (attrsOf (submodule (import ./opts-connection.nix)));
      default = null;
    };

  };
}
