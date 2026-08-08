{ self, inputs, ... }: {

  flake.homeModules.herolab = { config, pkgs, lib, ... }: let
    _config = config;
    _herolab = _config.programs.herolab;
    inherit (lib)
      types
      mkOption
      mkEnableOption
      mkPackageOption
      mkIf;
    inherit (pkgs)
      system;
    inherit (self.packages.${system})
      herolab;
  in {

    options.programs.herolab = mkOption {
        default = {};
        type = types.submodule ({ ... }: {
          options = {
            enable  = mkEnableOption "herolab";
            package = mkPackageOption pkgs herolab {};
          };
        });
      };

      config = mkIf _herolab.enable {
        home.packages = [
          _herolab.package
        ];
      };

  };

  flake.overlays.herolab = final: prev: {
    herolab = self.packages.${final.stdenv.system}.herolab;
  };

  perSystem = { pkgs, system, ... }: {
    packages.herolab = pkgs.callPackage ./package-wrap.nix {
      wine         = pkgs.wineWow64Packages.full;
      mkWindowsApp = inputs.erosanix.lib.${system}.mkWindowsApp;
    };
  };

}
