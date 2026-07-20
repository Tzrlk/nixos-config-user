{ config, pkgs, ... }: let
  _config   = config;
  _snowflake-cli = _config.programs.snowflake-cli;
  inherit (pkgs.lib)
    types
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption;
  inherit (pkgs.formats)
    toml;
in {

  options.programs.snowflake-cli = with types; let

    optsConfigCliFeatures = submodule ({ ... }: {
      options = {

        enable_separate_authentication_policy_id = {
          description = ''
            The `enable_separate_authentication_policy_id` configuration
            parameter lets you enable access to Snowflake CLI separately from
            the drivers. When this access is enabled, specified users can
            access Snowflake CLI but not the other Snowflake drivers.

            **Warning:**
            If you already have an authentication policy that allows access
            only to drivers and don’t have one that allows access to Snowflake
            CLI only, enabling the `enable_separate_authentication_policy_id`
            parameter will cause the users to lose access to Snowflake CLI if
            you don’t create the new policy first. Make sure to add
            `SNOWFLAKE_CLI` to your authentication policy before enabling the
            configuration parameter.
          '';
          type    = bool;
          default = false;
        };

      };
    });

    optsConfigCliLogs = submodule ({ ... }: {
      options = {

        save_logs = {
          description = ''
            Indicates whether to save logs to files.
          '';
          type    = bool;
          default = true;
        };

        level = {
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

        path = {
          description = ''
            Specifies the absolute path to save the log files. If not
            specified, the command creates a logs directory in the default
            config.toml file location.
          '';
          type    = externalPath;
          default = "${_config.xdg.configHome}/snowflake-cli/logs";
        };

      };
    });

    optsConfigCli = submodule ({ ... }: {
      options = {

        features = {
          description = ''
          '';
          type    = optsConfigCliFeatures;
          default = {};
        };

        logs = {
          description = ''
            By default, Snowflake CLI automatically saves INFO, WARNING, and
            ERROR level messages to log files. To disable or customize logging,
            create a [cli.logs] section in your config.toml file.
          '';
          type    = optsConfigCliLogs;
          default = {};
        };

      };
    });

    optsConfig = submodule ({ ... }: {
      options = {

        default_connection_name = {
          description = ''
          '';
          type    = str;
          default = "";
        };

        cli = {
          description = ''
          '';
          type    = optsConfigCli;
          default = {};
        };

      };
    });

    optsConnection = submodule ({ ... }: {
      options = {

        account = {
          description = ''
            Your account identifier. The account identifier does not include
            the snowflakecomputing.com suffix.
          '';
          type = str;
        };

        user = {
          description = ''
            Login name for the user.
          '';
          type = str;
        };

        password = {
          description = ''
            Password for the user.
          '';
          type = str;
        };

        application = {
          description = ''
            Name that identifies the application making the connection.
          '';
          type    = nullOr str;
          default = null;
        };

        region = {
          description = ''
            *Deprecated* This description of the parameter is for backwards
            compatibility only..
          '';
          type    = nullOr str;
          default = null;
        };

        host = {
          description = ''
            Host name.
          '';
          type    = nullOr str;
          default = null;
        };

        port = {
          description = ''
            Port number (`443` by default).
          '';
          type    = int;
          default = 443;
        };

        database = {
          description = ''
            Name of the default database to use. After login, you can use
            `USE DATABASE` to change the database.
          '';
          type    = nullOr str;
          default = null;
        };

        schema = {
          description = ''
            Name of the default schema to use for the database. After login,
            you can use `USE SCHEMA` to change the schema.
          '';
          type    = nullOr str;
          default = null;
        };

        role = {
          description = ''
            Name of the default role to use. After login, you can use
            `USE ROLE` to change the role.
          '';
          type    = nullOr str;
          default = null;
        };

        warehouse = {
          description = ''
            Name of the default warehouse to use. After login, you can use
            `USE WAREHOUSE` to change the warehouse.
          '';
          type    = nullOr str;
          default = null;
        };

        passcode_in_password = {
          description = ''
            `False` by default. Set this to True if the MFA (Multi-Factor
            Authentication) passcode is embedded in the login password.
          '';
          type    = bool;
          default = false;
        };

        passcode = {
          description = ''
            The passcode provided by Duo when using MFA (Multi-Factor
            Authentication) for login.
          '';
          type    = nullOr str;
          default = null;
        };

        private_key = {
          description = ''
            The private key used for authentication. For more information, see
            "Using key-pair authentication and key-pair rotation".
          '';
          type    = nullOr str;
          default = null;
        };

        private_key_file = {
          description = ''
            Specifies the path to the private key file for the specified user.
            See "Using key-pair authentication and key-pair rotation".
          '';
          type    = nullOr path;
          default = null;
        };

        private_key_file_pwd = {
          description = ''
            Specifies the passphrase to decrypt the private key file for the
            specified user. See "Using key-pair authentication and key-pair
            rotation".
          '';
          type    = nullOr str;
          default = null;
        };

        autocommit = {
          description = ''
            `None` by default, which honors the Snowflake parameter
            `AUTOCOMMIT`. Set to True or False to enable or disable autocommit
            mode in the session, respectively.
          '';
          type    = nullOr (enum [ "None" "True" "False" ]);
          default = "None";
        };

        # TODO: Shit-ton more: https://docs.snowflake.com/en/developer-guide/python-connector/python-connector-api#label-snowflake-connector-methods-connect

      };
    });

    opts = submodule ({ ... }: {
      options = {

        enable = mkEnableOption "snowflake-cli";

        package = mkPackageOption "snowflake-cli" {};

        config = mkOption {
          description = ''
            Configuration for the Snowflake CLI.
          '';
          type = nullOr optsConfig;
          default = null;
        };

        connections = {
          description = ''
            Connection config for the Snowflake CLI.
          '';
          type    = nullOr (attrsOf optsConnection);
          default = null;
        };

      };
    });

  in mkOption {
    description = "Command line client for the Snowflake database.";
    type        = opts;
    default     = {};
  };

  config = mkIf _snowflake-cli.enable {

    environment.systemPackages = [
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
