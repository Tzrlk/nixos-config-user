{ self, flake-parts-lib, withSystem, ... }: {
  imports = [
    ./dev-lang
    ./dev-tools
    ./sys-tools
  ];
  flake.homeModules = {
    home = import ./home;

    # By default, include every _other_ defined module.
    default = { ... }: {
      imports = builtins.attrValues
        (builtins.removeAttrs
          self.homeModules
          [ "default" ]);
    };

  };
}
