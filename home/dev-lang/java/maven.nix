{ config, pkgs, lib, ... }: {

	home = {

		file = {
			# Not really secure.
#			".m2/settings.xml".source          = ./.m2/settings.xml;
#			".m2/settings-security.xml".source = ./.m2/settings-security.xml;

#			".m2/settings.xml".text = xmlDoc
#				[ "settings" {
#					"xmlns"     = "http://maven.apache.org/SETTINGS/1.0.0";
#					"xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
#					"xsi:schemaLocation" = (wrap "\n" (indent (concatStringsSep "\n" [
#							"http://maven.apache.org/SETTINGS/1.0.0"
#							"https://maven.apache.org/xsd/settings-1.0.0.xsd"
#					])))
#				} [
#					[ "proxies" null [
#						[ "proxy" null [
#							[ "nonProxyHosts" null (concatStringsSep "|" [
#								"127.0.0.*"
#								"localhost"
#								"*.local"
#							]) ]
#				] ];
		};

	};

}
