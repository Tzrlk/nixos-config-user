{ self, ... }: {
  flake.overlays = {

    allow-unfree = import /allow-unfree.nix;

    default =
      let

        # Exclude self from full overlays to avoid infinite recursion.
        withoutSelf = removeAttrs self.overlays [ "default" ];

        # Extract only the module values from the result.
        asList = builtins.attrValues withoutSelf;

      in
      final: prev: prev.lib.composeManyExtensions asList;

  };
}
