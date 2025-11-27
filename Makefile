# Some minor automation to make things a bit easier.

# Global Options
.ONESHELL:
.EXPORT_ALL_VARIABLES:
.POSIX:
.SECONDEXPANSION:

# Nix file indexing.
%/index.nix: | $$(filter-out $${@},$$(wildcard %/*.nix))
	@sed 's/^\.\t//g' > ${@} << DOC
	.	{ ... }: {
	.		imports = [$(foreach file,$(notdir ${|}),
	.			./${file})
	.		];
	.	}
	DOC

#RX_IMPORTS := (?<=imports = \[)[\s\S]+?(?=\];)
#%.nix: $$(strip $$(shell cat ${@} | grep -Pzo '$${RX_IMPORTS}'))
#	@touch ${@}

# Specific targets
switch: configuration.nix
	nixos-rebuild switch

# Manual dependencies
configuration.nix: modules.d/index.nix
	touch ${@}

modules.d/containers.nix: modules.d/containers.d/index.nix
	touch ${@}

