# Just sets up git-hooks for execution of check and fmt actions, along with
# some extra check activations that aren't complex enough for their own file.
{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];
  perSystem = { pkgs, ... }: {
    pre-commit = {
      inherit pkgs;
      settings = {
        enable = true;
        hooks = {

          # Bash
          shellcheck.enable = true;

          # Editorconfig
          editorconfig-checker.enable = true;

          # JSON
          check-json.enable = true;

          # Markdown
          mdsh.enable = true;
          markdownlint.enable = true;

          # Nix
          statix.enable = true;

          # TOML
          check-toml.enable = true;

          # YAML
          yamllint.enable = true;

          # TODO: https://github.com/cachix/git-hooks.nix
          # * https://github.com/commitizen-tools/commitizen
          # * gitlint?
          #

        };
      };
    };
  };
}
