#!/usr/bin/env make

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

CMD_NIX ?= nix \
	--extra-experimental-features 'flakes nix-command' \
	--accept-flake-config
CMD_HOME_MANAGER ?= $(shell command -v home-manager \
	|| echo "${CMD_NIX} run 'github:nix-community/home-manager' --")

USER ::= m811632
NAME ::= NZ8797LP5474

FILES_HOME  := $(shell find ./home -type f)
FILES_UTILS := $(shell find ./utils -type f)

debug:
	@echo "home-manager:   ${CMD_HOME_MANAGER}"

## MAIN #######################################################################
EXEC ?= switch

home: \
		flake.nix \
		${FILES_HOME} \
		${FILES_UTILS}
	@${CMD_HOME_MANAGER} ${EXEC} \
		--option accept-flake-config true \
		--flake .\#${USER}
.PHONY: home

###############################################################################

## CHECK ######################################################################

#: Runs flake tests and assertions.
check: flake.lock
	@${CMD_NIX} flake check
.PHONY: check

###############################################################################

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
###############################################################################
