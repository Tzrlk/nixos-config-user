# NOTE: Maybe https://github.com/raphiz/buildGradleApplication will work?
{ pkgs, stdenv, fetchzip, makeWrapper, ... }: let
  inherit (stdenv) mkDerivation;
  srcHashes = {
    "6.08.00RC10" = "sha256-XYw2Rb1CbqRuRzp88Y1BPrMTES5hlLiyYsITel5M/ag=";
  };

in mkDerivation rec {
  pname   = "pcgen";
  version = "6.08.00RC10";
  src     = fetchzip {
    url  = "https://github.com/PCGen/pcgen/releases/download/${version}/pcgen-${version}.zip";
    hash = srcHashes.${version};
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    mkdir -p $out/share/${pname} $out/bin
    cp -r $src/* $out/share/${pname}/
    makeWrapper ${pkgs.openjdk}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}/${pname}.jar"
  '';
  postInstall = ''
    target=$out/share/applications/${pname}.desktop
    mkdir -p "$(dirname $target)"
    printf '%s\n' \
      '[Desktop Entry]' \
      'Type=Application' \
      'Name=PCgen' \
      'Exec=$out/bin/pcgen' \
      'Categories=Games;' \
      > $target
    chmod +x $target
  '';
}
