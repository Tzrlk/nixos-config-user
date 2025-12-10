#!/usr/bin/env bash

debug 'starting.'

# RBENV config (even if not installed)
export RBENV_SHELL=bash
export RBENV_ROOT="${XDG_CONFIG_HOME}/rbenv"
if [ -d "${RBENV_ROOT}" ]; then

	# Ensure that rbenv is available on the path if not already linked.
	[ -d "${XDG_BIN_HOME}" ] \
		|| mkdir -p "${XDG_BIN_HOME}"
	[ -s "${XDG_BIN_HOME}/rbenv" ] \
		|| ln -sf "${RBENV_ROOT}/bin/rbenv" "${XDG_BIN_HOME}/rbenv"

	# Add generated shims to the path.
	export PATH="${RBENV_ROOT}/shims:${PATH}"

	# Trigger a rehash to ensure version list is up to date.
	command rbenv rehash 2>/dev/null

	# Redefine rbenv as a function so we can mess with the parameters.
	rbenv() {
		local command
		command="${1:-}"

		# Drop the command argument if present
		[ "$#" -gt 0 ] && shift

		case "$command" in
		rehash|shell)
			eval "$(rbenv "sh-$command" "$@")";;
		*)
			command rbenv "$command" "$@";;
		esac
	}
fi

debug 'complete.'
