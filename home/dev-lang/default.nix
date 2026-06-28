{ ... }: {
  imports = [
    ./nix
  ];
  flake.homeModules = {
		bash      = ./bash;
		dotnet    = ./dotnet;
		golang    = ./golang;
		groovy    = ./groovy;
		java      = ./java;
		k8s       = ./k8s;
		kotlin    = ./kotlin;
		nodejs    = ./nodejs;
		python    = ./python;
		ruby      = ./ruby;
		scala     = ./scala;
		terraform = ./terraform;
	};
}
