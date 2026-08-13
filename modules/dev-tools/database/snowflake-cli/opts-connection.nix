{ lib, ... }: {
  options = {

    account = lib.mkOption {
      description = ''
        Your account identifier. The account identifier does not include
        the snowflakecomputing.com suffix.
      '';
      type = lib.types.str;
    };

    user = lib.mkOption {
      description = ''
        Login name for the user.
      '';
      type = lib.types.str;
    };

    password = lib.mkOption {
      description = ''
        Password for the user.
      '';
      type = lib.types.str;
    };

    application = lib.mkOption {
      description = ''
        Name that identifies the application making the connection.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    region = lib.mkOption {
      description = ''
        *Deprecated* This description of the parameter is for backwards
        compatibility only..
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    host = lib.mkOption {
      description = ''
        Host name.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    port = lib.mkOption {
      description = ''
        Port number (`443` by default).
      '';
      type    = lib.types.int;
      default = 443;
    };

    database = lib.mkOption {
      description = ''
        Name of the default database to use. After login, you can use
        `USE DATABASE` to change the database.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    schema = lib.mkOption {
      description = ''
        Name of the default schema to use for the database. After login,
        you can use `USE SCHEMA` to change the schema.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    role = lib.mkOption {
      description = ''
        Name of the default role to use. After login, you can use
        `USE ROLE` to change the role.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    warehouse = lib.mkOption {
      description = ''
        Name of the default warehouse to use. After login, you can use
        `USE WAREHOUSE` to change the warehouse.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    passcode_in_password = lib.mkOption {
      description = ''
        `False` by default. Set this to True if the MFA (Multi-Factor
        Authentication) passcode is embedded in the login password.
      '';
      type    = lib.types.bool;
      default = false;
    };

    passcode = lib.mkOption {
      description = ''
        The passcode provided by Duo when using MFA (Multi-Factor
        Authentication) for login.
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    private_key = lib.mkOption {
      description = ''
        The private key used for authentication. For more information, see
        "Using key-pair authentication and key-pair rotation".
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    private_key_file = lib.mkOption {
      description = ''
        Specifies the path to the private key file for the specified user.
        See "Using key-pair authentication and key-pair rotation".
      '';
      type    = lib.types.nullOr lib.types.path;
      default = null;
    };

    private_key_file_pwd = lib.mkOption {
      description = ''
        Specifies the passphrase to decrypt the private key file for the
        specified user. See "Using key-pair authentication and key-pair
        rotation".
      '';
      type    = lib.types.nullOr lib.types.str;
      default = null;
    };

    autocommit = lib.mkOption {
      description = ''
        `None` by default, which honors the Snowflake parameter
        `AUTOCOMMIT`. Set to True or False to enable or disable autocommit
        mode in the session, respectively.
      '';
      type    = lib.types.nullOr (lib.types.enum [ "None" "True" "False" ]);
      default = "None";
    };

    # TODO: Shit-ton more: https://docs.snowflake.com/en/developer-guide/python-connector/python-connector-api#label-snowflake-connector-methods-connect

  };
}
