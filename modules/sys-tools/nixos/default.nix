{ inputs, system, ... }: {

	imports = [
		./settings.nix
	];

	config = {

		home.packages = [

			# Make sure we have the currently included version of system
			# manager available.
			inputs.system-manager.packages.${system}.default

		];

	};

}
