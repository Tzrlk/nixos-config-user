{ ... }: {
  flake.homeModules = {
    cloud     = ./cloud;
    codegen   = ./codegen;
    data      = ./data;
    docs      = ./docs;
    git       = ./git;
    jetbrains = ./jetbrains;
    vim       = ./vim;
    vscode    = ./vscode;
  };
}
