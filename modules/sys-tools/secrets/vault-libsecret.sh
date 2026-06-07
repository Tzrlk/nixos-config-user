#!/usr/bin/env bash
set -e

[ -n "${DEBUG}" ] && echo >&2 "${0} ${*}"

# TODO: If VAULT_ADDR is not set, query secrets to find all the stored hosts
#       and present an interactive option to select one of them or add another.
#       If VAULT_NAMESPACE isn't set, do the same thing for selecting a
#       namespace.
#       Also prompt for VAULT_USER if it's missing.
#       Finally, check the token expiry and trigger a login if it's expired,
#       storing the new expiry on the token as well.

if [ -e "${VAULT_ADDR}" ]; then
	echo >&2 "Unable to locate token without VAULT_ADDR being set."
	exit 2
fi

if [ -e "${VAULT_NAMESPACE}" ]; then
	echo >&2 "Unable to locate token without VAULT_NAMESPACE being set."
	exit 2
fi

# shellcheck disable=SC2001
VAULT_HOST="$(sed -r 's|^([^/]+://)?([^/]+).*$|\2|' <<<"${VAULT_ADDR}")"

args=(
	service   vault
	server    "${VAULT_HOST}"
	namespace "${VAULT_NAMESPACE}"
)

if [ -n "${VAULT_USER}" ]; then
	args+=( username "${VAULT_USER}" )
else
	echo >&2 'WARN: Setting VAULT_USER provides more precise token location.'
fi

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
		label="Vault: ${VAULT_ADDR}?namespace=${VAULT_NAMESPACE}"
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
