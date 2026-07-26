{ config, pkgs, lib, inputs, ... }: let
  _config = config;
  _idea   = _config.programs.idea;
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    concatStringsSep;
in {

  options.programs.idea = mkOption {
    description = ''
      Local configuration for installation of IntelliJ IDEA.
    '';
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
          description = ''
            IDs of the plugins to install with the IDE.
          '';
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

    ideaPkg = pkgs.jetbrains.idea;

    # https://github.com/theCapypara/nix-jetbrains-plugins/
    idea = with inputs.nix-jetbrains-plugins.lib;
      buildIdeWithPlugins pkgs ideaPkg _idea.plugins;

  in mkIf _idea.enable {

    # Add our package to the install list.
    home.packages = [ idea ];

    xdg.dataFile."applications/idea.desktop" = {
      executable = true;
      text = lib.generators.toINI {} {
        "Desktop Entry" = {
          Name           = "IntelliJ IDEA";
          Type           = "Application";
          Categories     = "Development";
          Comment        = ''
            IDE for Java SE, Groovy & Scala development Powerful environment
            for building Google Android apps Integration with JUnit, TestNG,
            popular SCMs, Ant & Maven. Also known as IntelliJ.
          '';
          GenericName    = "Java, Kotlin, Groovy and Scala IDE from JetBrains";
          Icon           = "${ideaPkg}/idea-ultimate/bin/idea"; # png or svg
          Exec           = "${ideaPkg}/idea-ultimate/bin/idea";
          StartupWMClass = "jetbrains-idea";
          Version        = "1.5";
        };
      };
    };

    # Add our package to the remote list.
    programs.jetbrains-remote.ides = [ idea ];

    # Customise our IDE package.
    nixpkgs.overlays = [
      (final: prev: {

        jetbrains = prev.jetbrains // {
          idea = prev.jetbrains.idea.overrideAttrs (old: {

            vmopts = if _idea.vmoptions != null
              then concatStringsSep "\n" _idea.vmoptions
              else null;

          });
        };

      })
    ];

  };

}
