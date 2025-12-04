final: prev: {

	config = prev.config.override {

		allowUnfreePredicate = pkg:
			builtins.elem
				(pkg.pname or (builtins.parseDrvName pkg.name).name)
				final.allowUnfreeList;

		allowUnfreeList = prev.allowUnfreeList or [];

	};

}
