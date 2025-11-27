{ pkgs, ... }: let

	# Simply wraps listToAttrs so it can be curried.
	mapToAttrs = mapper: items:
		builtins.listToAttrs (map mapper items);

	# Convert one plugin instance into a file config entry.
	from_plugin = base_dir: plugin: {
		name  = "${base_dir}/${plugin.name}";
		value = {
			source = plugin;
		};
	};

	# Convert a list of plugins into a map of file config entries.
	use_plugins = pack: type:
		mapToAttrs (from_plugin ".vim/pack/${pack}/${type}");

in {

#	programs.vim.plugins = [];

	home.file = with pkgs.vimPlugins; {

		# Autoloaded config scripts.
		".vim/plugin".source = ./plugin;

	}
	// use_plugins "main" "start" [
		editorconfig-vim
		vim-fugitive
		vim-indent-guides # https://github.com/preservim/vim-indent-guides
		vim-plugin-AnsiEsc
		vim-sensible
		tabular
	]
	// use_plugins "main" "opt" [
		jq-vim
		rust-vim
		vim-json
		vim-jsonpath
		vim-lsp
		vim-ps1
		vim-ruby
	];

}
