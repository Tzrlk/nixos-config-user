#!/usr/bin/env bash

export FNM_DIR="${XDG_DATA_HOME}/fnm"

# If FNM is available, generate the rest of the env config.
if command -v fnm >/dev/null; then
	eval "$(
		fnm env \
			--shell bash \
			--fnm-dir "${XDG_DATA_HOME}/fnm"
	)"
fi
