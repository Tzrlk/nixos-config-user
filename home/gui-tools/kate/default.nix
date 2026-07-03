{ ... }: {
  flake.homeModules.kate = { ... }: {
    imports = [
      ./config.mod.nix
      ./options.mod.nix
    ];
  };
}
