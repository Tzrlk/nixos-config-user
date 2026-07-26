{
  lib,
  pkgs,
  mkWindowsApp,
  wine,
  wineArch ? "win64",
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  ...
}: mkWindowsApp rec {
  pname   = "herolab";
  version = "8.9h";

  dontUnpack = true;

  inherit wine wineArch;
  persistRuntimeLayer = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  winAppInstall = let

    installer = fetchurl {
      url    = "https://www.lonewolfdevel.com/download/hp/hl89h_win_install.exe";
      sha256 = "0y954rsrw0akfhr9sp6wk4rwzkr1a99fj1511yayv9m7pwgaraiz";
    };

  in ''
    wine "${installer}" \
      /LOG="$out/share/${pname}/install.log" \
      /LOGCLOSEAPPLICATIONS \
      /DIR="C:\HeroLab" \
      /LANG=english \
      /SUPPRESSMSGBOXES \
      /VERYSILENT \
      /NORESTART \
      /NOICONS \
      /SP-
  '';

  winAppRun = ''
    data_dir="$HOME/.local/share/${pname}"
    app_dir="$WINEPREFIX/drive_c/HeroLab"

    # Data Persistence setup
    mkdir -p "$data_dir"

    ARGS+=" -dataroot=Z:\\home\\$USER\\.local\\share\\${pname}"
    ARGS+=" -userroot=Z:\\home\\$USER\\.local\\share\\${pname}"

    # Run the application
    wine "$app_dir/${pname}.exe" "$ARGS"

  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/${pname}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      type = "Application";
      desktopName = "Hero Lab";
      exec = pname;
      icon = pname;
      genericName = "TTRPG Character Manager";
      categories  = [ "Game" "Development" ];
#      additionalCategories = [ "GameTool" "RolePlaying" ];
      keywords    = [ "D&D" "RPG" ];
    })
  ];

  meta = with lib; {
    description     = "TTRPG Character Manager";
    longDescription = ''
      Hero Lab Classic makes character creation a breeze, automatically
      tracking modifiers for every stat, ability, item, spell, and option you
      select. Our automated validation engine verifies that all prerequisites,
      minimums, and other requirements have been met, pointing out where your
      character conflicts with the rules.
    '';
    homepage         = "https://www.wolflair.com/hero-lab-classic/";
    downloadPage     = "https://www.lonewolfdevel.com/submit/get_product.asp?product=hp&platform=win";
    license          = licenses.unfree;
    sourceProvenance = [ source-types.binaryNativeCode ];
    platforms        = [ "x86_64-linux" ];
  };

}

