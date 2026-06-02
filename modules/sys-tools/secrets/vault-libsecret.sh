#!/usr/bin/env bash
set -e

[ -n "${DEBUG}" ] && echo >&2 "${0} ${*}"

VAULT_HOST="${VAULT_ADDR}"
if [ -n "${VAULT_HOST}" ]; then
	# shellcheck disable=SC2001
	VAULT_HOST="$(sed -r 's|^([^/]+://)?([^/]+).*$|\2|' <<<"${VAULT_HOST}")"
fi

args=(
	service   vault
	server    "${VAULT_HOST}"
	namespace "${VAULT_NAMESPACE:-unknown}"
	username  "${VAULT_USER:-unknown}"
)

[ -n "${DEBUG}" ] && echo >&2 "${args[*]}"

case "${1}" in

	get)
		if token="$(secret-tool lookup "${args[@]}")"; then
			printf "%s" "${token}"
		else
			echo >&2 'No token found.'
		fi
		;;

	store)
		label="Vault"
		[ -n "${VAULT_USER}" ] && label+="${VAULT_USER}@"
		[ -n "${VAULT_HOST}" ] && label+="${VAULT_HOST}"
		[ -n "${VAULT_NAMESPACE}" ] && label+="#${VAULT_NAMESPACE}"
		secret-tool store \
			--label="${label}" \
			"${args[@]}"
		;;

	erase)
		if ! secret-tool clear "${args[@]}"; then
			echo >&2 'No token found to erase.'
		fi
		;;

	*)
		echo >&2 'Error: Provide a valid command: get, store, or erase.'
		exit 2
		;;

esac
