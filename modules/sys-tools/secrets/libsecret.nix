{ pkgs, ... }: {
	config = {

		home.packages = with pkgs; [
			libsecret
		];

		# TODO: Configure core libsecret integration?

	};
}
