{ ... }: {

	config = {

		home = {

			sessionVariables = {

				DOTNET_TOOLS_PATH = "$HOME/.dotnet/tools";

				# Extract self-contained executables under HOME
				# to avoid multi-user issues from using the default '/var/tmp'.
				DOTNET_BUNDLE_EXTRACT_BASE_DIR = "$XDG_CACHE_HOME/dotnet_bundle_extract";

			};

			sessionPath = [
				"$DOTNET_TOOLS_PATH"
			];

		};

	};

}
