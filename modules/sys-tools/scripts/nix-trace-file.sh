#!/usr/bin/env bash
set -e

# Handle input args.

path="${1}"
if [ -z "${path}" ]; then
	echo >&2 "An inspection path must be provided."
	exit 2
fi
if [ ! -r "${path}" ]; then
	echo >&2 "The provided path is not readable."
	exit 2
fi

# Resolve path in case it's a symlink.
path="$(readlink -f "${path}")"
context=""

# Do the rest of the work in a function, since we're going to use recursion.
function trace-path() {
	local path="${1}"
	local indent="${2:-}"

	# Extract the derivation name and file path if present.
	derivation="$(echo "${path}" | cut -d / -f 4)"
	file="$(echo "${path}" | cut -d / -f 5-)"

	# Extract key info from the derivation.
	package="$(echo "${derivation}" | cut -d - -f 2-)"
	digest="$(echo "${derivation}" | cut -d - -f 1)"

	# Assemble the info into a useful name.
	name="${package} ${digest} ${file}"

	# Check if our context already has it.
	if grep -q "${name}" <<<"${context}"; then
		return
	fi
	context="$(echo -e "${context}\n${name}" | sort)"
	#echo >&2 -e "---\n${context}\n---"

	# Print the package name, then hash, then subpath (if any) then hash.
	echo -e "${indent}\e[37m${package} \e[33m${digest} \e[32m${file}\e[0m"

	# Get referring derivations from the store.
	mapfile -t results < <(nix-store --query --referrers "${path}")

	for item in "${results[@]}"; do
		trace-path "${item}" "${indent}  " "${context}"
	done

}

trace-path "${path}"

