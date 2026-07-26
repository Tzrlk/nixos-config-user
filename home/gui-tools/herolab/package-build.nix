{ pkgs, makeFontsConf, fetchurl, ... }: pkgs.stdenv.mkDerivation rec {
  pname   = "herolab";
  version = "8.9h";
  src     = fetchurl {
    url    = "https://www.lonewolfdevel.com/download/hp/hl89h_win_install.exe";
    sha256 = "0y954rsrw0akfhr9sp6wk4rwzkr1a99fj1511yayv9m7pwgaraiz";
  };

  nativeBuildInputs = with pkgs; [

    # Post-install "shortcut" generation
    makeWrapper

    # Installer execution
    wineWow64Packages.full

    # Headless install
    xvfb-run
    xauth

    # Avoids a hanging build
    fontconfig
    dejavu_fonts

  ];

  dontUnpack = true;

  env = {
    WINEARCH        = "win64";
    XDG_CACHE_HOME  = "/tmp/cache";
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ pkgs.dejavu_fonts ];
    };
  };

  installPhase = ''

    # Build context
    export WINEPREFIX="$out/share/${pname}/.wine"
    mkdir -p "$WINEPREFIX" "$XDG_CACHE_HOME" "/tmp/.X11-unix

    # Run the installer
    xvfb-run \
        --server-args="-nolisten unix" \
        --error-file /dev/stderr \
      wine "$src" \
        /LOG="$out/share/${pname}/install.log" \
        /LOGCLOSEAPPLICATIONS \
        /DIR="C:\Program Files\Hero Lab" \
        /LANG=english \
        /SUPPRESSMSGBOXES \
        /VERYSILENT \
        /NORESTART \
        /NOICONS \
        /SP-
  '';

  postInstall = ''

    # Launch script
    mkdir -p $out/bin
    makeWrapper ${pkgs.wineWow64Packages.full}/bin/wine $out/bin/${pname} \
      --add-flags "$WINEPREFIX/drive_c/Program\ Files/Hero\ Lab/${pname}.exe" \
      --set WINEPREFIX "$WINEPREFIX" \
      --set WINEARCH "$WINEARCH"

    # Desktop entry
    mkdir -p $out/share/applications
    cat <<-DOC > "$out/share/applications/${pname}.desktop"
      [Desktop Entry]
      Name="Hero Lab"
      GenericName="TTRPG Character Manager"
      Type=Application
      Exec="$out/bin/${pname}" %f
      Path="$out/share/${pname}"
      Icon="$WINEPREFIX/drive_c/Program\ Files/Hero\ Lab/icon.png"
      Categories=Games;
      Keywords=D&D;RPG;
    DOC

    chmod +x \
      "$out/bin/${pname}" \
      "$out/share/applications/${pname}"

  '';

}
