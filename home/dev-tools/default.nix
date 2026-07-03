{ ... }: {
  imports = [
    ./jetbrains
    ./git
  ];
  flake.homeModules = {
    cloud   = ./cloud;
    codegen = ./codegen;
    data    = ./data;
    docs    = ./docs;
    vim     = ./vim;
    vscode  = ./vscode;
  };
}
