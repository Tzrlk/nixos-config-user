{ ... }: {
	programs.vim = {

		settings = {

			# Display
			background     = "dark";
			number         = true;
			relativenumber = false;

			# Storage
			backupdir = [ "~/.vim/backup/" ];
			directory = [ "~/.vim/swap/" ];
			undodir   = [ "~/.vim/undo/" ];

			# Indent
			expandtab  = false;
			shiftwidth = 4;
			tabstop    = 4;

			# Control
			modeline = true;

			# Mouse (https://vimdoc.sourceforge.net/htmldoc/options.html#'mouse')
			mouse = "a"; # all modes
			mousehide = true;
			mousemodel = "popup_setpos";

		};

		extraConfig = builtins.readFile ./.vimrc;

	};
}
