fun! SetupVAM()

	let c = get(g:, 'vim_addon_manager', {})
	let g:vim_addon_manager = c

	let c.plugin_root_dir = expand(s:vimdir . '/vim-addons')
	let s:vamdir = expand(c.plugin_root_dir . '/vim-addon-manager')
	let &rtp.=(empty(&rtp)?'':',') . s:vamdir
	let vam_autoload_dir = expand(s:vamdir . '/autoload')

	if !isdirectory(vam_autoload_dir)
		silent execute '!git clone --depth=1 https://github.com/MarcWeber/vim-addon-manager.git '
		\       shellescape(s:vamdir, 1)
	endif

	call vam#ActivateAddons([])

endfun

"call SetupVAM()

"" Filetype specific plugins
"au FileType lojban   VAMActivate git:https://github.com/devyn/lojban.vim.git
"au FileType asciidoc VAMActivate git:https://github.com/asciidoc/vim-asciidoc.git
"au FileType xml      VAMActivate git:https://github.com/othree/xml.vim.git
"
