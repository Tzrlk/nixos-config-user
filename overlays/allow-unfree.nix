final: prev: {
  config = prev.config // {

    allowUnfreePredicate =
      let
        package_name = pkg: pkg.pname or (builtins.parseDrvName pkg.name).name;
      in
      pkg: builtins.elem package_name final.config.allowUnfreeList;

    allowUnfreeList = prev.config.allowUnfreeList or [ ];

  };
}
