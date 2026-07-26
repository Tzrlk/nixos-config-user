{ self, inputs, ... }: {

  flake.homeModules.herolab = import ./module.nix;

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
