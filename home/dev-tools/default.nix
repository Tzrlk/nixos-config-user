{ ... }: {
  imports = [
    ./jetbrains
  ];
  flake.homeModules = {
    cloud     = ./cloud;
    codegen   = ./codegen;
    data      = ./data;
    docs      = ./docs;
    git       = ./git;
    vim       = ./vim;
    vscode    = ./vscode;
  };
}
