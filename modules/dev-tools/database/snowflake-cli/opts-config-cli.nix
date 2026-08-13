{ lib, ... }: let
  inherit (lib)
    mkOption;
  inherit (lib.types)
    submodule;
in {
  options = {

    features = mkOption {
      description = ''
      '';
      type    = submodule (import ./opts-config-cli-features.nix);
      default = {};
    };

    logs = mkOption {
      description = ''
        By default, Snowflake CLI automatically saves INFO, WARNING, and
        ERROR level messages to log files. To disable or customize logging,
        create a [cli.logs] section in your config.toml file.
      '';
      type    = submodule (import ./opts-config-cli-logs.nix);
      default = {};
    };

  };
}
