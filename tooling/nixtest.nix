# Sets up more advanced unit testing with autodiscovery.
{ inputs, ... }: {

  imports = [ inputs.nixtest.flakeModule ];

  # Automated test discovery for `*_test.nix`
  perSystem =
    { pkgs, ... }:
    let

      ntlib = inputs.nixtests.lib { inherit pkgs; };

    in
    {
      packages.tests = ntlib.mkNixtest {
        modules = ntlib.autodiscover { dir = ../.; };
        args = {
          inherit pkgs ntlib;
        };
      };
    };

}
