#!/usr/bin/env bash
# Finds all desktop .svg icons and renders them as .ico so wslg can use them,
# then updates the desktop files to point to the .ico files.
# This script assumes there are no colons in any of the paths.
# TODO: Add support for converting /usr/share/icons as well.
set -e

# Check if the 'convert' command from ImageMagick is available.
if ! builtin type -P convert &>/dev/null; then
	echo >&2 "< ImageMagick is required to convert the svgs."
	exit 1
fi

# Define function used to convert the images.
function svg_convert() {
	convert \
		"$( [ "${3}" = 'true' ] && printf '-verbose' )" \
		-background transparent \
		-define 'icon:auto-resize=16,24,32,64' \
		"${1}" "${2}"
}

# Define the list of expected targets.
paths=(
	~/.local/share/applications
	/var/lib/snapd/desktop/applications
	/usr/local/share/applications
	/usr/share/applications
)

force=false
verbose=false

# Check for flags
for arg in "${@}"; do
	case "${arg}" in

		--force)
			force=true
			;;

		--debug)
			verbose=true
			;;

	esac
done

for path in "${paths[@]}"; do
	echo >&2 "> Processing '${path}'."

	# Make sure we have permission to actually do anything to the folder.
	if ! [ -d "${path}" ] || ! [ -w "${path}" ]; then
		echo >&2 '>< Folder not writable. Skipping.'
		continue
	fi

	# Work through all the desktop files in the given path.
	for desktop in "${path}"/*.desktop; do
		echo >&2 ">> Processing '${desktop}'."

		# Ensure file is writable.
		if ! [ -f "${desktop}" ] || ! [ -w "${desktop}" ]; then
			echo >&2 '>>< File not writable. Skipping.'
			continue
		fi

		# Extract svg references
		svgs="$(grep '\.svg' "${desktop}" | cut -d= -f2)"
		if [ -z "${svgs}" ]; then
			echo >&2 '>>> No svg references found. Checking icons.'

			# See if there are any icon references present in the file.
			icos="$(grep '\.ico' "${desktop}" | cut -d= -f2)"
			if [ -z "${icos}" ]; then
				echo >&2 '>>< No ico references found. Skipping.'
				continue
			fi

			# Verify that all the needed icons exist.
			for ico in ${icos}; do
				echo >&2 ">>> Checking '${ico}'."

				# Check that the icon exists.
				if [ -f "${ico}" ] && [ ${force} != 'true' ]; then
					echo >&2 '>>>< File exists. Done.'
					continue
				fi

				# Generate an svg file name from the ico.
				svg="${ico%.*}.svg"

				# Ensure the source svg actually exists.
				if ! [ -f "${svg}" ]; then
					echo '>>>< Source svg does not exist. Skipping.'
					continue
				fi

				# Re-transform the svg.
				echo >&2 '>>>> Converting file to ico.'
				svg_convert "${svg}" "${ico}" "${verbose}" >&2 || {
					echo >&2 '<<<< Icon conversion failed. Failing process.'
					exit 1
				}

				echo >&2 '>>>< Done.'
			done

			echo >&2 '>>< Done.'
			continue
		fi

		# Process the svg references.
		for svg in ${svgs}; do
			echo >&2 ">>> Processing '${svg}'."

			# Generate the new .ico file name.
			ico="${svg%.*}.ico"

			# If an icon file already exists, skip conversion.
			if [ ! -f "${ico}" ] || [ "${force}" = 'true' ]; then

				echo >&2 '>>>> Converting file to ico.'
				svg_convert "${svg}" "${ico}" "${verbose}" >&2 || {
					echo >&2 '<<<< Icon conversion failed. Failing process.'
					exit 1
				}

			else
				echo >&2 '>>>> .ico file already exists. Skipping convert.'
			fi

			# Update the file in-place (should be fine to do multiple times).
			echo >&2 '>>>> Updating desktop file with .ico path'
			sed -i "s|${svg}|${ico}|" "${desktop}" || {
				echo >&2 '<<<< Desktop file update failed. Failing process.'
				exit 1
			}

			echo >&2 '>>>< Done.'
		done

		echo >&2 '>>< Done.'
	done

	echo >&2 '>< Done. '
done

echo >&2 '< Done.'

