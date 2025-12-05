# Ultra-fancy autocomplete
{ pkgs, ... }: {

	home.packages = with pkgs; [ blesh ];

	# see ./.bashrc.d/blesh.sh for activation.

	# TODO: Some kind of customisation?
	# https://github.com/akinomyoga/ble.sh/wiki/Manual-%C2%A72-Graphics
	# https://github.com/akinomyoga/ble.sh/wiki/Manual-%C2%A77-Completion

}
