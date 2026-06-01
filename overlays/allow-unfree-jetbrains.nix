final: prev: {
	config = prev.config // {

		allowUnfreeList = (prev.config.allowUnfreeList or []) ++ [
			"idea"
			"idea-with-plugins"
			"jetbrains-toolbox"
		];

	};
}
