{ ... }: {

  flake.homeModules.links = { config, lib, ... }: let
    inherit (lib) types mkOption;
    inherit (config.lib.file) mkOutOfStoreSymlink;
    inherit (lib.path.subpath) join;
    inherit (lib) removePrefix;
    inherit (builtins) typeOf;
    inherit (config) localRepos;

    /**
     * (path: path) -> (file: path) -> string
     */
    relativePath = path: file:
      removePrefix "${path}/" file;

    /**
     * (repo: string) -> (path: string) -> path
     * (repo: string) -> (path: path) -> (file: path) -> path
     */
    repoFileLink = repo: path:
      if typeOf path == "string" then
        let inherit (localRepos."${repo}") source; in
        mkOutOfStoreSymlink (join [ source path ])
      else
        let relativeFile = relativePath path; in
        file: repoFileLink repo (relativeFile file);

  in {

    options.localRepos = mkOption {
      type    = types.attrSetOf types.string;
      default = {};
    };

    config.lib.file = {
      inherit
        relativePath
        repoFileLink;
    };

  };

#  flake.checks = {
#
#    testRelativePathIsRelative = {
#      expr     = relativePath ./. ./links.nix;
#      expected = "home/links.nix";
#    };
#
#  };

}
