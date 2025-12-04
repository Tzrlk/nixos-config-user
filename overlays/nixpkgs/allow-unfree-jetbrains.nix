final: prev: {

	config.allowUnfreeList = (prev.config.allowUnfreeList or []) ++ [
		"idea-ultimate"
		"idea-ultimate-with-plugins"
		"jetbrains-toolbox"
	];

}
