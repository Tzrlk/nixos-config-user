{ ... }: {
  # TODO: https://github.com/oppiliappan/statix ?
  imports = [
    ./git-hooks.nix
    ./nixfmt.nix
    #    ./nixtest.nix
    ./treefmt.nix
  ];
}
