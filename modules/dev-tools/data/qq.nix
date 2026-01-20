{ pkgs, lib, ... }: pkgs.buildGoModule (final: {
	name    = "qq";
	pname   = "qq-jfryy";
	version = "0.3.1";

	meta = {
		homepage    = "https://github.com/JFryy/qq";
		license     = lib.licenses.mit;
		description = lib.strings.join " " [
			"jq, but with many interoperable configuration format transcodings"
			"and interactive querying"
		];
		longDescription = lib.strings.join " " [
			"`qq` is an interoperable configuration format transcoder with `jq`"
			"query syntax powered by `gojq`. `qq` is multi modal, and can be"
			"used as a replacement for `jq` or be interacted with via a REPL"
			"with autocomplete and realtime rendering preview for building"
			"queries."
		];
		mainProgram = "qq";
	};

	src = pkgs.fetchFromGitHub {
		owner = "JFryy";
		repo  = "qq";
		tag   = "v${final.version}";
		hash  = "sha256-+3XK8wufbcXBiryaV78TH4HFzqTzLnCDmGv2aCNaKdk=";
	};

	vendorHash = "sha256-rAVTvlFBVHv4ruM+mRsCleOwgmC9UdTy2MUUdeanPfY=";

})
