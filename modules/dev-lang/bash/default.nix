{ config, pkgs, ... }: {

	config = {
		home.packages = with pkgs; [

			# linting
			shellcheck

			# TODO: Investigate
#			bashdb
#			bashly
#			bashate
#			bashunit

		];
	};

}
