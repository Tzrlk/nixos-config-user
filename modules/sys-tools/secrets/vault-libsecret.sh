#!/usr/bin/env bash

if [ -n "${DEBUG}" ]; then
	echo >&2 "${0} ${*}"
	env >&2
fi

VAULT_ADDR="${VAULT_ADDR:-unknown}"
VAULT_NAMESPACE="${VAULT_NAMESPACE:-unknown}"
VAULT_USER="${VAULT_USER:-unknown}"

# shellcheck disable=SC2001
VAULT_HOST="$(sed -r 's|^(?:.+://)?([^/]+).*$|\1|' <<<"${VAULT_ADDR}")"

case "${1}" in

	get)
		secret-tool lookup \
			server    "${VAULT_HOST}" \
			namespace "${VAULT_NAMESPACE}"
		;;

	store)
		secret-tool store --label="Vault: ${VAULT_NAMESPACE} on ${VAULT_HOST}" \
			server    "${VAULT_HOST}" \
			namespace "${VAULT_NAMESPACE}"
		;;

	erase)
		secret-tool clear \
			server    "${VAULT_HOST}" \
			namespace "${VAULT_NAMESPACE}"
		;;

	*)
		echo >&2 'Error: Provide a valid command: get, store, or erase.'
		exit 2
		;;

esac
