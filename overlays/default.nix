{ self, ... }: {
  flake.overlays = {

    allow-unfree = import /allow-unfree.nix;

    default =
      final: prev:
      prev.lib.composeManyExtensions (builtins.attrValues (removeAttrs self.overlays [ "default" ]));

  };
}
