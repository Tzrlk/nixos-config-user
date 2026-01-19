#!/usr/bin/env bash
set -e

echo >&2 "Running ${0} ${*}"

# Capture script args to array so we can index properly.
argv=("${@}")

# Get the terraform-provided arguments from the end (reverse order).
target="${argv[-1]}"; unset 'argv[-1]'
action="${argv[-1]}"; unset 'argv[-1]'

# Add necessary locating attributes to provided ones.
# Be careful that input args are pairs, since we don't validate.
argv+=(
	service terraform
	server  "${target}"
)

case "${action}" in

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#get-retrieve-the-credentials-for-the-given-hostname
	get)
		if token="$(secret-tool lookup "${argv[@]}")"; then
			# Using jq here to avoid any string escaping issues.
			jq -n '{ token: $token }' --arg token "${token}"
		else
			printf '{}\n'
		fi
		;;

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#store-store-new-credentials-for-the-given-hostname
	store)
		jq -r '.token' | secret-tool store \
			--label="Terraform: ${target}" \
			"${argv[@]}"
		;;

	# https://developer.hashicorp.com/terraform/internals/credentials-helpers#forget-delete-any-stored-credentials-for-the-given-hostname
	forget)
		secret-tool clear \
			"${argv[@]}"
		;;

	*)
		printf >&2 'The specified action is invalid.\n'
		exit 1

esac
