{ self, inputs, ... }: {

  flake.overlays.nix-gui-python = final: prev: {
    python39 = prev.python3;
  };

  flake.homeModules.nix-gui = { pkgs, ... }: {
    config = {

      # For some reason, this doesn't actually modify the pkgs injected above.
      nixpkgs.overlays = [ self.overlays.nix-gui-python ];

      # This input has a fairly hard package dependency on python39, which
      # isn't in nixpkgs any more.
#      home.packages = with pkgs; [
#        inputs.nix-gui.packages.${system}.nix-gui
#      ];

    };
  };

}
