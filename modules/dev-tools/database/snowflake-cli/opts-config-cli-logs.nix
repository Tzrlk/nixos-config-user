{ lib, ... }: let
  inherit (lib)
    mkOption;
  inherit (lib.types)
    externalPath
    bool
    enum
    str;
in {
  options = {

    save_logs = mkOption {
      description = ''
        Indicates whether to save logs to files.
      '';
      type    = bool;
      default = true;
    };

    level = mkOption {
      description = ''
        Specifies which levels of messages to save to log files. Choose
        from the following levels, which include all levels below the
        selected one:
        * `debug` - Warning: Switching to the debug logging level can
                    expose sensitive information, such as executed SQL
                    queries. Use caution when enabling this level.
        * `info`
        * `warning`
        * `error`
      '';
      type = enum [ "debug" "info" "warning" "error" ];
      default = "info";
    };

    path = mkOption {
      description = ''
        Specifies the absolute path to save the log files. If not
        specified, the command creates a logs directory in the default
        config.toml file location.
      '';
      type    = externalPath;
      default = "\${XDG_CONFIG_HOME}/snowflake-cli/logs";
    };

  };
}
