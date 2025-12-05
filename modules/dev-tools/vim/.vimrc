
"==============================================================================
let s:vimdir = expand($HOME . '/.vim')

set runtimepath=s:vimdir,$VIMRUNTIME

" == PLUGINS ===================================================================

" Built-in plugins
filetype indent plugin on | syntax on

" Explicit file type associations
autocmd BufNewFile,BufRead *.adoc set filetype=asciidoc
autocmd BufNewFile,BufRead *.ps1  set filetype=ps1

" File type specific plugin activation
autocmd FileType json  packadd vim-json
autocmd FileType json  packadd vim-jsonpath
autocmd FileType rust  packadd rust-vim
autocmd FileType ps1   packadd vim-ps1
autocmd FileType ruby  packadd vim-ruby
autocmd FileType jq    packadd jq-vim
autocmd FileType nixos packadd vim-lsp

" Custom plugin activation options
let g:indent_guides_enable_on_vim_startup = 1

" == PREFS =====================================================================

" Explicit indent overrides.
au FileType yaml set shiftwidth=2 softtabstop=2 expandtab

" Colours
colorscheme torte

" Line endings
set fileformat=unix

" Character encoding
set encoding=utf-8 fileencoding=utf-8

" Adding a column size
set colorcolumn=80,120
"set textwidth=78
"set formatoptions+=t

" Managing tab size
set shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

" Backspace functionality
" set backspace=indent,eol,start

" Showing whitespace
" set list
" set listchars=tab:│\ ,trail:¬

" Show line numbers
set number norelativenumber

" Modeline processing.
set modeline
