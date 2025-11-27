{ ... }: {

	# Just try and use the main windows version of edge.
	home.sessionVariables = {
		BROWSER = "wsl-open";
	};

	# Attempting to fix mime associations.
	xdg.mimeApps = {

		defaultApplications = {
			"application/pdf" = [  "wsl-open" ];
			"application/rdf+xml" = [  "wsl-open" ];
			"application/rss+xml" = [  "wsl-open" ];
			"application/xhtml+xml" = [  "wsl-open" ];
			"application/xhtml_xml" = [  "wsl-open" ];
			"application/xml" = [  "wsl-open" ];
			"image/gif" = [  "wsl-open" ];
			"image/jpeg" = [  "wsl-open" ];
			"image/png" = [  "wsl-open" ];
			"image/webp" = [  "wsl-open" ];
			"text/html" = [  "wsl-open" ];
			"text/xml" = [  "wsl-open" ];
			"x-scheme-handler/http" = [  "wsl-open" ];
			"x-scheme-handler/https" = [  "wsl-open" ];
		};

	};

}
