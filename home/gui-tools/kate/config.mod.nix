{ ... }: {
  flake.homeModules.kate = { config, lib, ... }: with lib; let
    _config = config;
    _kate   = _config.programs.kate;
  in mkIf _kate.enabled {
    config = {

      xdg.configFile = {

        "katerc" = {
          force   = true;
          enabled = isNull _kate.katerc;
          body    = if (isString _kate.katerc)
            then _kate.katerc
            else lib.generators.toINI _kate.katerc;
        };

        "katevirc" = {
          force   = true;
          enabled = isNull _kate.katevirc;
          body    = if (isString _kate.katevirc)
            then _kate.katevirc
            else lib.generators.toINI _kate.katevirc;
        };

        "kate/lspclient/settings.json" = {
          force   = true;
          enabled = !(isNull _kate.lsp);
          body    = builtins.toJSON _kate.lsp;
        };

      };

    };
  };

}
