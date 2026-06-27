#!/usr/bin/env bash

###############################################################################
# Define a debug logging function.
function debug() { echo >/dev/null "no-op"; }
[ -n "${BASH_DEBUG}" ] \
	&& function debug() { echo >&2 "${*}"; }

###############################################################################
debug "${BASH_SOURCE[0]}" 'starting.'

###############################################################################
if [[ $- == *i* ]]; then
	debug "${BASH_SOURCE[0]}" 'initialising bleh.sh.'
	source -- "$(blesh-share)/ble.sh" \
		--attach=none
fi

###############################################################################
# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
	debug "${BASH_SOURCE[0]}" 'activating lesspipe'
	eval "$(lesspipe)"
fi

###############################################################################
debug "${BASH_SOURCE[0]}" 'loading extensions.'
# Delegate to files included in a config dir.
for file in ~/.bashrc.d/*.sh; do
	# shellcheck source=.bashrc.d/*.sh
	. "${file}"
done
unset file

###############################################################################
if command -v starship >/dev/null; then
	debug "${BASH_SOURCE[0]}" "activating starship."
	eval "$(starship init bash)"
fi

###############################################################################
if [[ -n "${BLE_VERSION}" ]]; then
	debug "${BASH_SOURCE[0]}" 'attaching bleh.sh.'
	ble-attach
fi

###############################################################################
debug "${BASH_SOURCE[0]}" 'complete.'
