{ inputs, ... }: {
  flake.homeModules.idea = { config, pkgs, lib, ... }: with lib; let
    _config = config;
    _idea   = _config.programs.idea;
    inherit (inputs) nix-jetbrains-plugins;
  in {

    options.programs.idea = mkOption {
      description = concatStringsSep "" [
        "Local configuration for installation of IntelliJ IDEA."
      ];
      type = types.submodule ({ ... }: {
        options = {

          enable = mkEnableOption "idea";

          vmoptions = mkOption {
            description = concatStringsSep "" [
              "Values to populate $IDEA_HOME/idea64.vmoptions with."
            ];
            type = with types; nullOr (listOf str);
            default = null;
            example = [
              "-Dide.managed.by.toolbox=false"
              "-Xmx1735m"
            ];
          };

          plugins = mkOption {
            description = concatStringsSep "" [
              "IDs of the plugins to install with the IDE."
            ];
            type = with types; listOf str;
            default = [];
            example = [
              "Docker"
              "name.kropp.intellij.makefile"
              "nix-idea"
              "org.editorconfig.editorconfigjetbrains"
              "org.jetbrains.plugins.terminal"
              "org.jetbrains.plugins.yaml"
            ];
          };

        };
      });
      default = {};
    };

    config = let

      # https://github.com/theCapypara/nix-jetbrains-plugins/
      idea = with nix-jetbrains-plugins.lib;
        buildIdeWithPlugins pkgs "idea" _idea.plugins;

    in mkIf _idea.enable {

      # Add our package to the install list.
      home.packages = [ idea ];

      # Add our package to the remote list.
      programs.jetbrains-remote.ides = [ idea ];

  # TODO: Figure this out.
  #		nixpkgs.overlays = [
  #			(final: prev: {
  #
  #				jetbrains.idea = prev.jetbrains.idea.overrideAttrs (old: {
  #					vmopts = if cfg.vmoptions != null
  #						then concatStringsSep "\n" cfg.vmoptions
  #						else null;
  #				});
  #
  #			})
  #		];

    };

  };
}
