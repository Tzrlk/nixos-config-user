{ config, inputs, pkgs, lib, ... }: let
  _config = config;
  _lnav   = _config.programs.lnav;
  inherit (lib)
    pipe
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf;
  inherit (builtins)
    fetchurl
    fromJSON
    toJSON
    readFile;
  inherit (inputs.fromJsonSchema.lib)
    fromJsonSchema;
in {

  options.programs.lnav = let

    loadSchema = opts @ { url, sha256 }: pipe opts [
      fetchurl
      readFile
      fromJSON
      fromJsonSchema
    ];

    configSchemaRef = {
      "$schema" = "https://lnav.org/schemas/config-v1.schema.json";
    };
    configSchema = loadSchema {
      url    = configSchemaRef."$schema";
      sha256 = "";
    };

    formatSchemaRef = {
      "$schema" = "https://lnav.org/schemas/format-v1.schema.json";
    };
    formatSchema = loadSchema {
      url    = formatSchemaRef."$schema";
      sha256 = "";
    };

  in mkOption {
    type = types.submodule ({ ... }: {
      options = {

        enable = mkEnableOption "lnav";

        package = mkPackageOption pkgs "lnav" {};

        config = mkOption {
          description = ''https://docs.lnav.org/en/v0.14.0/config.html'';
          type    = configSchema.options;
          default = {};
        };

        configs = mkOption {
          description = ''https://docs.lnav.org/en/v0.14.0/config.html'';
          type    = types.attrsOf (types.attrsOf configSchema.options);
          default = {};
        };

        formats = mkOption {
          description = ''https://docs.lnav.org/en/v0.14.0/formats.html'';
          type    = types.attrsOf (types.attrsOf formatSchema.options);
          default = {};
        };

      };
    });
  };

  config = mkIf _inav.enable {

    home.packages = [ _lnav.package ];

    xdg.configFile = let

      convertConfigs = schemaRef:
       concatMapAttrs (group: files:
         concatMapAttrs (file: config: {
           "${group}/${file}.json" = {
             text   = toJSON (config // schemaRef);
             enable = config != {};
           };
         }));

    in {

      "lnav/config.json" = {
        text   = toJSON (_lnav.config // configSchemaRef);
        enable = _lnav.config != {};
      };

    }
    // (convertConfigs configSchemaRef _lnav.configs)
    // (convertConfigs formatSchemaRef _lnav.formats);

    # .config/lnav/configs/*/*.json
    # .config/lnav/formats/*/config.*.json - log format definitions.
    # .config/lnav/config.json - local customisation via :config cmd
    # .config/lnav/configs/* - reserved for use with '-i'
    # {
    #    "$schema": "https://lnav.org/schemas/config-v1.schema.json"
    # }

  };

}
