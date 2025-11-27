#!/usr/bin/env bash

[[ $- == *i* ]] \
	&& source -- "$(blesh-share)"/ble.sh --attach=none

[[ ! ''${BLE_VERSION-} ]] \
	|| ble-attach
