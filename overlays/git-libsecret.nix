final: prev: {

	git = prev.git.override {
		withLibsecret = true;
	};

}
