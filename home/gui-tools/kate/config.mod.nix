{ config, lib, ... }:
with lib;
let
  _config = config;
  _kate = _config.programs.kate;

in
{
  config = mkIf _kate.enable {
    xdg.configFile = {

      "katerc" = {
        force = true;
        enabled = !(isNull _kate.katevirc);
        body = if (isAttrs _kate.katerc) then generators.toINI _kate.katerc else _kate.katerc;
      };

      "katevirc" = {
        force = true;
        enabled = !(isNull _kate.katevirc);
        body = if (isAttrs _kate.katevirc) then generators.toINI _kate.katevirc else _kate.katevirc;
      };

      "kate/lspclient/settings.json" = {
        force = true;
        enabled = !(isNull _kate.lsp);
        body = builtins.toJSON _kate.lsp;
      };

    };
  };
}
