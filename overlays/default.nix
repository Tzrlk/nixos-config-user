{ self, ... }: {
  flake.overlays = {

    allow-unfree           = import /allow-unfree.nix;
    allow-unfree-jetbrains = import /allow-unfree-jetbrains.nix;
    git-libsecret          = import /git-libsecret.nix;

    default = final: prev: prev.lib.composeManyExtensions [
      self.overlays.allow-unfree
      self.overlays.allow-unfree-jetbrains
      self.overlays.git-libsecret
    ];

  };
}
