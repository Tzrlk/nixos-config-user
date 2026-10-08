{ config, pkgs, lib, ... }: let
  _config = config;
  _maven = _config.programs.maven;
  _java = _config.programs.java;
in {

  options.programs.maven = lib.mkOption {
    description = "Java build tool.";
    default = {};
    type = lib.types.submodule ({ ... }: {
      options = {
        enable = lib.mkEnableOption "maven";
        package = lib.mkPackageOption pkgs "maven" {};
      };
    });
  };

  config = lib.mkIf _maven.enable {
    programs.java.enable = true;

    home.packages = lib.flatten [ _maven.package ];

    home.file.".m2/toolchains.xml" = {
      text = lib.concatStringsSep "\n" (lib.flatten [

        ''
          <?xml version="1.0" encoding="UTF-8"?>
          <toolchains
                  xmlns="http://maven.apache.org/TOOLCHAINS/1.1.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xsi:schemaLocation="
                          http://maven.apache.org/TOOLCHAINS/1.1.0
                          https://maven.apache.org/xsd/toolchains-1.1.0.xsd
                  ">
        ''

        # Might need to have more comprehensive config after all.
        (builtins.map
          (pkg: let
            pkgType = if (lib.hasPrefix "jdk" pkg.id) then "jdk"
              else if (lib.hasPrefix "jre" pkg.id) then "jre"
              else pkg.id;
            pkgVersion = builtins.head (builtins.match "^([0-9]+).+$" pkg.version);
          in ''
            <toolchain>
              <type>jdk</type>
              <provides>
                <version>${pkgVersion}</version>
                <vendor>${pkg.pname}</vendor>
              </provides>
              <configuration>
                <jdkHome>${pkg.home}</jdkHome>
              </configuration>
            </toolchain>
          '')
          (lib.flatten [ _java.package _java.extras ])
        )

        ''
          </toolchains>
        ''

      ]);
    };

  };


}
