# Sets-up treefmt-nix and its core config.
{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = { ... }: {
    treefmt = {
      projectRootFile = "flake.nix";
    };
  };
}
