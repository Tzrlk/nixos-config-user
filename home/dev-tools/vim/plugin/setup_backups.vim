" Ensures backup directories exist and are configured.
" TODO: Replace directory creation with nix config to do the same.
fun! SetupBackups()
	let s:vimdir = expand($HOME . '/.vim')

	if !isdirectory(s:vimdir)
		echo 'Creating ' . s:vimdir
		silent execute '!mkdir ' . s:vimdir
	endif

	" Save your backups to a less annoying place than the current directory.
	let s:backupdir = expand(s:vimdir . '/backup')
	if !isdirectory(s:backupdir)
		echo 'Creating ' . s:backupdir
		silent execute '!mkdir ' . s:backupdir
	endif

	let &backupdir = expand(s:backupdir . '//')
	set backup

	" Save your swp files to a less annoying place than the current directory.
	let s:swapdir = expand(s:vimdir . '/swap')
	if isdirectory(s:swapdir) == 0
		echo 'Creating ' . s:swapdir
		silent execute '!mkdir ' . s:swapdir
	endif

	let &directory = expand(s:swapdir . '//')

	" viminfo stores the the state of your previous editing session
	let &viminfo .= ',n' . expand(s:vimdir . '/viminfo')

	if exists("+undofile")

		" undofile - This allows you to use undos after exiting and restarting
		" :help undo-persistence
		" This is only present in 7.3+
		let s:undodir = expand(s:vimdir . '/undo')
		if isdirectory(s:undodir) == 0
			echo 'Creating ' . s:undodir
			silent execute '!mkdir ' . s:undodir
		endif

		let &undodir = expand(s:undodir . '//')
		set undofile

	endif

endfun

call SetupBackups()
