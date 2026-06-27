#!/usr/bin/env bash
set -e

action="${1}"
if [ "${VAULT_LIBSECRET_ACTION}" = "${action}" ]; then
	echo >&2 "Recursive ${action} detected."
	exit 0
fi

export VAULT_LIBSECRET_ACTION="${action}"

function debug() {
	if [ -n "${DEBUG}" ]; then
		echo >&2 "${@}"
	fi
}

debug "${0} ${*}"

# TODO: If VAULT_ADDR is not set, query secrets to find all the stored hosts
#       and present an interactive option to select one of them or add another.
#       If VAULT_NAMESPACE isn't set, do the same thing for selecting a
#       namespace.
#       Also prompt for VAULT_USER if it's missing.
#       Finally, check the token expiry and trigger a login if it's expired,
#       storing the new expiry on the token as well.

# Get parent process args and if any explicit settings were passed, use them to
# set or override the corresponding environment variable.
debug "Trying to read parent process (${PPID}) args:"
if mapfile -d '' parent_args < "/proc/${PPID}/cmdline"; then
	debug "Discovered: ${parent_args[*]}"
	for ((i = 0; i < ${#parent_args[@]}; i++)); do
		debug "Evaluating ${parent_args[$i]}"
		case "${parent_args[$i]}" in
			-address)
				debug 'Found -address'
				export VAULT_ADDR="${parent_args[$((++i))]}"
				;;
			-address=*)
				debug 'Found -address=*'
				export VAULT_ADDR="${parent_args[$i]#*=}"
				;;
			-namespace)
				debug 'Found -namespace'
				export VAULT_NAMESPACE="${parent_args[$((++i))]}"
				;;
			-namespace=*)
				debug 'Found -namespace=*'
				export VAULT_NAMESPACE="${parent_args[$i]#*=}"
				;;
			username=*)
				debug 'Found username=*'
				export VAULT_USER="${parent_args[$i]#*=}"
				;;
		esac
	done
fi

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

VAULT_USER="${VAULT_USER:-${USER}}"
if [ -n "${VAULT_USER}" ]; then
	args+=( username "${VAULT_USER}" )
else
	echo >&2 'WARN: Setting VAULT_USER provides more precise token location.'
fi

debug "Secret Attrs: ${args[*]}"

case "${1}" in

	get)
		debug "Retrieving token..."

		# Make sure we don't get caught infinitely recursing.
		if [ "${VAULT_LIBSECRET_ACTION}" = 'get' ]; then
			echo >&2 'Recursive get detected.'
			exit 0
		fi
		export VAULT_LIBSECRET_ACTION=get

		# Don't just lookup the secret, since we need to check the expiry time and
		# trigger a login if it's expired.
		debug "Performing search..."
		result="$(secret-tool search "${args[@]}" 2>&1)"
		if [ -n "${result}" ]; then
			debug "Found result: ${result}"

			expiry="$(grep -Po '^(?<=attribute\.expiry = ).+$' <<<"${result}")"
			if [ -n "${expiry}" ] && [ "$(date +%s)" -lt "${expiry}" ]; then
				debug "Secret is still valid! Extracting value from result..."
				secret="$(grep -Po '^(?<=secret = ).+$' <<<"${result}")"
				printf '%s' "${secret}"
				exit 0
			fi

			# Remove the expired token so we don't create duplicates.
			debug 'Clearing old entry...'
			secret-tool clear "${args[@]}" 2>/dev/null || true
			echo >&2 'Token has expired, triggering login.'

		else
			echo >&2 'No token found.'
		fi

		if [ -e "${VAULT_USER}" ]; then
			echo >&2 'No user to trigger login with.'
			exit 0
		fi

		echo >&2 'Triggering login.'
		auth="$(vault login -format=json -method=ldap username="${VAULT_USER}")"

		# Record the token expiry time in the secret attributes.
		lease="$(jq -r '.auth.lease_duration' <<<"${auth}")"
		expiry="$(date -d "+${lease} seconds" +%s)"
		args+=( expiry "${expiry}" )

		# Store the token in the keyring for next time.
		token="$(jq -r '.auth.client_token' <<<"${auth}")"
		secret-tool store \
			--label="Vault: ${VAULT_ADDR}?namespace=${VAULT_NAMESPACE}" \
			"${args[@]}" \
			<<<"${token}"

		# Print the token to stdout for vault to consume.
		printf "%s" "${token}"

		;;

	store)
		debug "Storing token..."
		label="Vault: ${VAULT_ADDR}?namespace=${VAULT_NAMESPACE}"
		secret-tool store \
			--label="${label}" \
			"${args[@]}"
		;;

	erase)
		debug "Clearing token..."
		if ! secret-tool clear "${args[@]}"; then
			echo >&2 'No token found to erase.'
		fi
		;;

	*)
		echo >&2 'Error: Provide a valid command: get, store, or erase.'
		exit 2
		;;

esac
