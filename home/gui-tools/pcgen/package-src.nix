# NOTE: Maybe https://github.com/raphiz/buildGradleApplication will work?
{ pkgs, stdenv, fetchFromGitHub, ... }: let
  inherit (stdenv) mkDerivation;

  pname   = "pcgen";
  version = "6.08.00RC10";
  src     = fetchFromGitHub {
    owner = "PCGen";
    repo  = "pcgen";
    rev   = "${version}";
    hash  = "sha256-JPKGucnebUFR1LrD6f/pcfxDAmym+Ys9k0ZyU8kzhII=";
  };

  deps = mkDerivation {
    name = "${pname}-deps-${version}";
    inherit src;
    nativeBuildInputs = [
      pkgs.gradle
      pkgs.openjdk
    ];
    buildPhase = ''
      export GRADLE_USER_HOME="$(mktemp -d)"
      gradle build --no-daemon --dry-run
    '';
    installPhase = ''
      mkdir -p $out
      cp -r $GRADLE_USER_HOME/caches $out/
    '';
    outputHashAlgo = "sha256";
    outputHash     = pkgs.lib.fakeHash;
  };

in mkDerivation {
  inherit pname version src;
  nativeBuildInputs = [
    pkgs.gradle
    pkgs.openjdk
  ];
  buildPhase = ''
    export GRADLE_USER_HOME="$(mktemp -d)"
    ln -s ${deps}/caches $GRADLE_USER_HOME/caches
    gradle build --offline --no-daemon
  '';
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp build/libs/*.jar $out/share/java
    makeWrapper ${pkgs.openjdk}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';
}
