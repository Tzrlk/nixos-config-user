#!/usr/bin/env make

## LOCAL OVERRIDES ############################################################
# Include all available local config overrides.
ifneq ($(wildcard local.mk),)
	include local.mk
endif

## MAKE SETTINGS ##############################################################
.ONESHELL:
.ALWAYS:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

## COMMAND DEFINITIONS ########################################################
CMD_NIX    ?= nix
CMD_NIXOS  ?= nixos-rebuild
CMD_HOME   ?= $(shell command -v home-manager \
	|| echo "${CMD_NIX} run 'github:nix-community/home-manager' --")
CMD_SYSTEM ?= $(shell command -v system-manager \
	|| echo "${CMD_NIX} run 'github:numtide/system-manager' --")

## ENVIRONMENT SETTINGS #######################################################

USER   ?= $(error 'USER needs to be set in the environment')
NAME   ?= $(shell hostname)
SYSTEM ?= x86_64-linux

INPUT_OVERRIDES := \
$(if ${INPUT_NIXPKGS},--override-input nixpkgs "${INPUT_NIXPKGS}" ,) \
$(if ${INPUT_NIXOS_CONFIG_USER},--override-input nixos-config-user "${INPUT_NIXOS_CONFIG_USER}" ,) \
$(if ${INPUT_NIXOS_CONFIG_WSL},--override-input nixos-config-wsl "${INPUT_NIXOS_CONFIG_WSL}" ,)

NIX_OPTS := ${INPUT_OVERRIDES} \
--extra-experimental-features 'nix-command flakes' \
--accept-flake-config \
--impure

## DIRS #######################################################################
.build/:
	@mkdir -p ${@}

## SHOW ######################################################################
show:
	@${CMD_NIX} flake show ${NIX_OPTS}
.PHONY: show

## CHECK #####################################################################
#: Run flake validation and tests.
check:
	${CMD_NIX} flake check ${NIX_OPTS} \
		--keep-going
.PHONY: check

## FORMAT ####################################################################
#: Autoformats the code
format:
	${CMD_NIX} fmt
.PHONY: format

## REPL ######################################################################
#: Opens a repl in the flake context.
repl:
	@${CMD_NIX} repl . ${NIX_OPTS}
.PHONY: repl

## DOCS ######################################################################
docs:
	${CMD_NIXDOC}
.PHONY: docs

##############################################################################
## NIXOS #####################################################################

#: Apply the current nixos configuration.
nixos:
	@${CMD_NIXOS} switch ${NIX_OPTS} \
		--accept-flake-config \
		--flake ".#${HOSTNAME}" \
		--sudo
.PHONY: nixos

#: Build the current nixos configuration without applying.
nixos-build:
	@${CMD_NIXOS} build ${NIX_OPTS} \
		--accept-flake-config \
		--flake ".#${HOSTNAME}"
.PHONY: nixos

##############################################################################
## HOME ######################################################################

#: Apply the current home-manager configuration.
home:
	@${CMD_HOME} switch ${INPUT_OVERRIDES} \
		--option accept-flake-config true \
		--flake .\#${USER} \
		--show-trace
.PHONY: home

#: Build the current home-manager config without applying.
home-build:
	@${CMD_HOME} build ${INPUT_OVERRIDES} \
		--option accept-flake-config true \
		--flake .\#${USER} \
		--show-trace
.PHONY: home-build

##############################################################################
## SYSTEM ####################################################################

#: Apply the current system-manager configuration.
system:
	@sudo ${CMD_SYSTEM} switch ${INPUT_OVERRIDES} \
		--nix-option accept-flake-config true \
		--flake .\#${NAME}
.PHONY: system

#: Build the current system-manager configuration without applying.
system-build:
	@sudo ${CMD_SYSTEM} build ${INPUT_OVERRIDES} \
		--nix-option accept-flake-config true \
		--flake .\#${NAME}
.PHONY: system
