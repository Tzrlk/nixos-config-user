{ self, ... }: {

  # This exposes the overlay to add all these general functions to nixpkgs.lib;
  flake.overlays.lib = final: prev: prev // {
    lib = prev.lib // self.lib;
  };

  # Theoretically this is supposed to apply the overlay, but it doesn't appear to work.
  flake.homeModules.lib = { ... }: {
    config.nixpkgs.overlays = [
      self.overlays.lib
    ];
  };

  # All general functions.
  flake.lib = {

    /**
     * Creates an attribute set with only one entry.
     * Trivial and stupid function designed badly.
     */
    soloAttr = name: body: {
      ${name} = body;
    };

  };

}
