{ pkgs, ... }: let

  # Simply wraps listToAttrs so it can be curried.
  # @ts: <I> (mapper: I => { name: string; value: I }) => (items: I[]) => [key: string]I
  mapToAttrs = mapper: items: let
    # @ts: { name: string; value: any }[]
    entryList = map mapper items;
  in
    builtins.listToAttrs entryList;

	# Convert one plugin instance into a file config entry.
	# @ts: <P extends { name: string }> (base_dir: string) => (plugin: P) => { name: string, value: { source: P } }
	from_plugin = base_dir: plugin: {
		name  = "${base_dir}/${plugin.name}";
		value = {
			source = plugin;
		};
	};

	# Convert a list of plugins into a map of file config entries.
	# @ts: <P extends { name: string }> (pack: string) => (type: string) => (plugins: P[]) => [key: string]P
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
		vim-shellcheck
	];

}
