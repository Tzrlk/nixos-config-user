{ pkgs, ... }: {

	config = {

		home.packages = with pkgs; [

			# Fast Node Manager (nvm but faster).
			fnm

		];

		home.file = {

			".bashrc.d/fnm-init.sh" = {
				source = ./fnm-init.sh;
			};

		};

	};

}
