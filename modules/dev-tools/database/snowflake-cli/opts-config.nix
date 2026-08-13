{ lib, ... }: let
  inherit (lib)
    mkOption;
  inherit (lib.types)
    submodule
    str;
in {
  options = {

    default_connection_name = mkOption {
      description = ''
      '';
      type    = str;
      default = "";
    };

    cli = lib.mkOption {
      description = ''
      '';
      type    = submodule (import ./opts-config-cli.nix);
      default = {};
    };

  };
}
