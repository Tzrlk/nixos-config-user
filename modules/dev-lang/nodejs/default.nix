{ pkgs, ... }: {

	config = {
		home.packages = with pkgs; [

			# RbEnv for nodejs, essentially.
			nodeenv

		];
	};

}
