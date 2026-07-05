# Just sets up git-hooks for execution of check and fmt actions.
{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

}
