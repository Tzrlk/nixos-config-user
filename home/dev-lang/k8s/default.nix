{ pkgs, ... }: {

	imports = [
		./k9s.nix
	];

	config = {
		home.packages = with pkgs; [

			# Framework for generating kubernetes manifests.
			cdk8s-cli

		];
	};

}
