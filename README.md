# NixOS Config: User

Re-usable home-manager configuration to my own preferences.

## Categories

### Development Languages (dev-lang)
Tooling and config for specific programming-languages.

### Development Tools (dev-tools)
Tooling and config for any development tools not specific to a programming language.

### sys-tools
Tooling and config not specifically related to software development.

### gui-tools
User interface config and tooling.

## Other

### Templates
Quick-start templates are configured to make initial consumer implementation
of this flake quicker and easier.

## Notes
* Switched to a flake-parts structure due to ongoing complexity.
* All `default.nix` files should be (converted to) flake-parts modules.
* All sources (apart from templates) could be put under a single src/ root,
  but there are definitely trade-offs with that. Maybe keep "home", but put
  the overlays next to where they're actually intended to be used.
