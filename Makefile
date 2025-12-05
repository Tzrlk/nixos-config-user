#!/usr/bin/env make

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

CMD_NIX ?= nix
CMD_HOME_MANAGER ?= $(shell command -v home-manager \
	|| echo "${CMD_NIX} run 'github:nix-community/home-manager' --")

SYSTEM ?= x86_64-linux

## NIX ########################################################################

define .nix
${CMD_NIX} ${1} \
	--extra-experimental-features 'flakes nix-command' \
	--accept-flake-config
endef

nix-%:
	$(call .nix,${*})

repl: .ALWAYS
	$(call .nix,${*})

develop: .ALWAYS
	$(call .nix,${*})

## FLAKE ######################################################################

define .nix-flake
$(call .nix,flake ${1})
endef

flake-%: .ALWAYS
	$(call .nix-flake,${*})

show: .ALWAYS
	$(call .nix-flake,${@})

## HOME #######################################################################

define .home
${CMD_HOME_MANAGER} ${1} \
	--option accept-flake-config true \
	--flake .\#${SYSTEM}
endef

home-%: .ALWAYS
	$(call .home,${*})

build: .ALWAYS
	$(call .home,${@})

switch: .ALWAYS
	$(call .home,${@})

## SETUP ######################################################################

setup: \
		/home/${USER}/.vimrc \
		| /home/${USER}/.config/home-manager/ \
		/home/${USER}/.local/state/nix/profiles/
.PHONY: setup

/home/${USER}/.config/home-manager/: \
		| /home/${USER}/.config/
	@ln -s "${ROOT_DIR}" "/home/${USER}/.config/home-manager"

/home/${USER}/.config/:
	@mkdir -p ${@}

/home/${USER}/.local/state/nix/profiles/:
	@mkdir -p ${@}

# Make config more editable.
/home/${USER}/.vimrc:
	@ln -sf '${ROOT_DIR}/home/vim/.vimrc' '${@}'

###############################################################################

## META #######################################################################
.ONESHELL:
.ALWAYS:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
###############################################################################
