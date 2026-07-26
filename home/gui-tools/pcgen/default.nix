{ self, ... }: {

  flake.homeModules.pcgen = import ./module.nix;

  flake.overlays.pcgen = final: prev: {
    pcgen = self.packages.${final.stdenv.system}.pcgen;
  };

  perSystem = { pkgs, ... }: {
    packages.pcgen = pkgs.callPackage ./package-zip.nix {};
  };

}
