#!/usr/bin/env bash

###############################################################################
# Define a debug logging function.
function debug() { echo >/dev/null "no-op"; }
[ -n "${BASH_DEBUG}" ] \
	&& function debug() { echo >&2 "${BASH_SOURCE[0]} ${*}."; }

###############################################################################
debug 'starting.'

# TODO?

###############################################################################
debug 'complete.'
