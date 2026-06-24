#!/usr/bin/env make

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

USER ?= $(error 'USER needs to be set in the environment')
NAME ?= $(shell hostname)

CMD_NIX ?= nix \
	--extra-experimental-features 'flakes nix-command' \
	--accept-flake-config
CMD_SYSTEM_MANAGER ?= $(shell command -v system-manager \
	|| echo "${CMD_NIX} run 'github:numtide/system-manager' --")
CMD_HOME_MANAGER   ?= $(shell command -v home-manager \
	|| echo "${CMD_NIX} run 'github:nix-community/home-manager' --")

FILES_HOME   := $(shell find ./home -type f)
FILES_SYSTEM := $(shell find ./system -type f)
FILES_UTILS  := $(shell find ./utils -type f)

debug:
	@echo "system-manager: ${CMD_SYSTEM_MANAGER}"
	@echo "home-manager:   ${CMD_HOME_MANAGER}"

## MAIN #######################################################################

flake-%: .ALWAYS
	${CMD_NIX} flake ${*} \
		$(if ${INPUT_CONFIG_WSL},--override-input config-wsl ${INPUT_CONFIG_WSL}) \
		$(if ${INPUT_CONFIG_USER},--override-input config-user ${INPUT_CONFIG_USER})
flake: \
	flake-show \
	.ALWAYS
check: \
	flake-check \
	.ALWAYS
show: \
	flake-show \
	.ALWAYS

system-%:
	@sudo ${CMD_SYSTEM_MANAGER} ${*} \
		--nix-option accept-flake-config true \
		$(if ${INPUT_CONFIG_WSL},--override-input config-wsl ${INPUT_CONFIG_WSL}) \
		$(if ${INPUT_CONFIG_USER},--override-input config-user ${INPUT_CONFIG_USER}) \
		--flake .\#${NAME}
system: \
	system-switch \
	.ALWAYS

home-%: .ALWAYS
	@${CMD_HOME_MANAGER} ${*} \
		--option accept-flake-config true \
		$(if ${INPUT_CONFIG_WSL},--override-input config-wsl ${INPUT_CONFIG_WSL}) \
		$(if ${INPUT_CONFIG_USER},--override-input config-user ${INPUT_CONFIG_USER}) \
		--flake .\#${USER} \
		--show-trace
home: \
	home-switch \
	.ALWAYS

###############################################################################

## CHECK ######################################################################

#: Runs flake tests and assertions.
flake-check: flake.lock
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
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
###############################################################################
