#!/usr/bin/env bash
# A credential helper script designed to integrate Terraform auth with
# libsecret. Reference docs for TF credential helpers available at:
# https://developer.hashicorp.com/terraform/internals/credentials-helpers

set -e

# Capture script args to array so we can index properly.
argv=("${@}")

echo >&2 "Running ${0} ${*}"
case "${#argv[@]}" in
	3)
		userid="${argv[1]}";
		action="${argv[2]}";
		target="${argv[3]}";
		;;
	2)
		userid="unspecified";
		action="${argv[1]}";
		target="${argv[2]}";
		;;
	*)
		echo >&2 "Invalid number of arguments provided."
		exit 2
		;;
esac

# Add necessary locating attributes to provided ones.
# Be careful that input args are pairs, since we don't validate.
attrs=(
	service  terraform
	server   "${target}"
	username "${userid}"
)

case "${action}" in

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#get-retrieve-the-credentials-for-the-given-hostname
	get)
		echo >&2 "Looking up existing token for ${target}..."
		if token="$(secret-tool lookup "${attrs[@]}")"; then
			# Using jq here to avoid any string escaping issues.
			jq -n '{ token: $token }' --arg token "${token}"
		else
			echo >&2 'No entry found.'
			printf '{}\n'
		fi
		;;

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#store-store-new-credentials-for-the-given-hostname
	store)
		echo >&2 "Storing new token for ${target}..."
		jq -r '.token' | secret-tool store \
			--label="Terraform: ${target}" \
			"${attrs[@]}"
		;;

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#forget-delete-any-stored-credentials-for-the-given-hostname
	forget)
		echo >&2 "Clearing token for ${target}..."
		secret-tool clear \
			"${attrs[@]}"
		;;

	*)
		echo >&2 "The specified action (${action}) is invalid."
		exit 2

esac
