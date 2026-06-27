#!/usr/bin/env bash

debug 'starting.'

function gradle {
	if [ -f ./gradlew ]; then
		./gradlew "${@}"
	else
		command gradle "${@}"
	fi
}

debug 'complete.'
