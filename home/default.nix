{ self, inputs, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
    ./dev-lang
    ./dev-tools
    ./gui-tools
    ./sys-tools
  ];
  flake.homeModules = {
    home = import ./home.nix;

    # By default, include every _other_ defined ;module.
    default = { ... }: {
      imports = builtins.attrValues (removeAttrs self.homeModules [ "default" ]);
    };

  };
}
