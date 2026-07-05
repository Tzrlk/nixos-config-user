{
  self,
  inputs,
  lib,
  ...
}:
with lib;
let

  /**
    Creates an attribute set with only one entry.
    Trivial and stupid function designed badly.
  */
  soloAttr = name: body: { ${name} = body; };

  /**
    Makes it a tiny bit easier to define option sets.
  */
  mkOptions =
    opts:
    types.submodule (
      { ... }: {
        options = opts;
      }
    );

  overlayModule = { ... }: {
    config.nixpkgs.overlays = [
      self.overlays.lib
    ];
  };

in
{

  # All general functions.
  flake.lib = {
    inherit
      soloAttr
      mkOptions
      ;
  };

  # This exposes the overlay to add all these general functions to nixpkgs.lib;
  flake.overlays.lib =
    final: prev:
    prev
    // {
      lib = prev.lib // self.lib;
    };

  # Theoretically this is supposed to apply the overlay, but it doesn't appear to work.
  flake.nixosModules.lib = overlayModule;
  flake.homeModules.lib = overlayModule;
  flake.systemModules.lib = overlayModule;

  perSystem = { pkgs, ... }: {
    checks.lib = inputs.nix-flake-tests.lib.check {
      inherit pkgs;
      tests = {

        soloAttr = {
          expr = self.flake.lib.soloAttr "testName" "testBody";
          expected = {
            testName = "testBody";
          };
        };

        mkOptions =
          let
            subject = self.flake.lib.mkOptions {
              testOption = lib.mkOption "testOption" { };
            };
          in
          {
            expr = subject.testOption;
            expected = null;
          };

      };
    };
  };

}
