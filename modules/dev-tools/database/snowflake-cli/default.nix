{ config, pkgs, lib, ... }: let
  _config        = config;
  _snowflake-cli = _config.programs.snowflake-cli;
  inherit (lib)
    mkOption
    mkIf;
  inherit (lib.types)
    submodule;
  inherit (lib.formats)
    toml;
in {

  options.programs.snowflake-cli = mkOption {
    description = "Command line client for the Snowflake database.";
    type        = submodule (args: import ./opts.nix (args // { inherit pkgs; }));
    default     = {};
  };

  config = mkIf _snowflake-cli.enable {

    home.packages = [
      _snowflake-cli.package
    ];

    xdg.configFile = {

      "snowflake/config.toml" = {
        source = toml.generate "config.toml" _snowflake-cli.config;
        enable = _snowflake-cli.config != null;
      };

      "snowflake/connections.toml" = {
        source = toml.generate "connections.toml" _snowflake-cli.connections;
        enable = _snowflake-cli.connections != null;
      };

    };

  };

}
