#!/usr/bin/env bash

apt list --installed 2>/dev/null \
	| tail -n+2 \
	| grep -v automatic \
	| cut -d / -f 1
