final: prev: import prev {
	nixpkgs = import prev.nixpkgs {
		overlays = [ ./nixpkgs ];
	};
}
