final: prev: {
	config = prev.config // {

		allowUnfreePredicate = pkg:
			builtins.elem
				(pkg.pname or (builtins.parseDrvName pkg.name).name)
				final.config.allowUnfreeList;

		allowUnfreeList = prev.config.allowUnfreeList or [];

	};
}
