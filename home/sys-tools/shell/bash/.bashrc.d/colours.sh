#!/usr/bin/env bash

###############################################################################
debug "${BASH_SOURCE[0]}" 'starting.'

###############################################################################
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	debug "${BASH_SOURCE[0]}" 'loading dircolours'

	# Customise for bash.
	opts='--bourne-shell'

	# If the user has colour settings, include them.
	[ -r ~/.dircolors ] && \
		opts+=' ~/.dircolors'

	# Evaluate the generated config.
	eval "$(dircolors "${opts}")"

fi

###############################################################################
debug "${BASH_SOURCE[0]}" 'Defining aliases.'

alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

###############################################################################
debug "${BASH_SOURCE[0]}" 'complete.'
