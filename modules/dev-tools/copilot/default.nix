{ config, pkgs, lib, ... }: let
  _config = config;
  _copilot = _config.programs.github-copilot-cli;
  inherit (builtins)
    listToAttrs
    pathExists
    attrNames
    readDir
    filter
    map;
  inherit (lib)
    mapAttrsToList
    nameValuePair
    optionalAttrs
    removeSuffix
    hasSuffix
    pipe;

  # @ts: (dir: string) => (name: string) => { name: string, value: string }
  mdpair = dir: name:
    (nameValuePair
      (removeSuffix ".md" name)
      (dir + ( "/" + name )));

  # @ts: (dir: string) => { [key: string]: string }
  mdfiles = dir:
    (optionalAttrs
      (pathExists dir)
      (pipe dir [
        readDir
        attrNames
        (filter (hasSuffix ".md"))
        (map (mdpair dir))
        listToAttrs
      ]));

  # @ts: (name: string) => (value: string) => { name: string, value: { source: string } }
  instructionPair = name: value:
    (nameValuePair
      "${_copilot.configDir}/instructions/${name}.instructions.md"
      { source = value; });

  # Transforms a regular file name => path map into one suitable for passing
  # into `home.file`.
  # @ts: ({ [key: string]: string }) => ({ [key: string]: string })
  instructionFiles = attrs:
    pipe attrs [
      (mapAttrsToList instructionPair)
      listToAttrs
    ];

in {

  options.programs.github-copilot-cli = {

    cacheDir = lib.mkOption {
      type = with lib.types; path;
      default = _copilot.configDir;
    };

    instructions = lib.mkOption {
      type = with lib.types;
        (either
          path
          (attrsOf (oneOf [
            lines
            path
            str
          ]))
        );
      default = {};
    };

  };

  config = {

    programs.github-copilot-cli = {
      enable       = true;
      configDir    = _config.xdg.configHome + "/copilot";
      cacheDir     = _config.xdg.cacheHome + "/copilot";
      instructions = mdfiles ./instructions;
      agents       = mdfiles ./agents;
      skills       = mdfiles ./skills;
      context      = ./instructions.md;
      settings     = {
        autoUpdate          = false;
        includeCoAuthoredBy = false;
      };

      mcpServers = {
      };

      lspServers = {
        nix = {
          command = "nixd";
          fileExtensions = {
            ".nix" = "nix";
          };
        };
      };

    };

    home.sessionVariables = {
      COPILOT_CACHE_HOME = _copilot.cacheDir;
    };

    home.file = instructionFiles _copilot.instructions;

  };

}
