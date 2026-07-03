{ config, lib, ... }: with lib; let
  _config = config;
  _kate   = _config.programs.kate;

  # TODO: Somehow get mkOptions injected into lib.
  mkOptions = opts: types.submodule ({ ... }: {
    options = opts;
  });

  optsKateLspServer = mkOptions {

    command = mkOption {
      description = "The command & args needed to run the server.";
      type        = types.listOf types.str;
      example     = [ "nixd" ];
    };

    url = mkOption {
      description = "Reference url for server.";
      type        = types.nullOr types.str;
      example     = "https://github.com/nix-community/nixd";
    };

    highlightingModeRegex = mkOption {
      description = "?";
      type        = types.nullOr types.str;
      example     = "^Nix$";
    };

  };

  optsKateLsp = mkOptions {

    servers = mkOption {
      description = "Custom LSP server config.";
      type        = types.nullOr types.attrsOf optsKateLspServer;
      default     = null;
    };

  };

  optsKate = mkOptions {
    enable  = mkEnableOption "kate";
    package = mkPackageOption pkgs "kate" {};

    katerc = mkOption {
      description = "Kate config";
      type        = types.nullOr (types.attrsOf (types.attrsOf types.anything));
      default     = null;
    };

    katevirc  = mkOption {
      description = "VI-mode config";
      type        = types.nullOr (types.attrsOf (types.attrsOf types.anything));
      default     = null;
    };

    lsp = mkOption {
      description = "LSP server config.";
      type        = types.nullOr optsKateLsp;
      default     = null;
    };

  };

in {

  options.programs.kate = mkOption {
    description = "GUI text editor for KDE.";
    type        = optsKate;
    default     = {};
  };

}
