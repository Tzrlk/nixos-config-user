{ pkgs, ... }: {

	home = {

		sessionPath = [
			"\${XDG_DATA_HOME}/gem/ruby/3.1.0/bin"
			"\${XDG_DATA_HOME}/gem/ruby/3.2.0/bin"
		];

		file = {
			".gemrc".source = ./.gemrc;
			".bashrc.d/10-rbenv.sh".source = ./rbenv-activation.sh;
		};

	};

	programs.rbenv = {
		enable = false; # TODO
		enableBashIntegration = true;
		plugins = [ {
			name = "rbenv-chef-workstation";
			src  = pkgs.fetchFromGithub {
				owner = "docwhat";
				repo  = "rbenv-chef-workstation";
				rev   = "4c5ad26";
			};
		} {
			name = "rbenv-gemset";
			src  = pkgs.fetchFromGithub {
				owner = "jf";
				repo  = "rbenv-gemset";
				rev   = "a819fc2";
			};
		} {
			name = "rbenv-path";
			src  = pkgs.fetchFromGithub {
				owner = "taqtiqa";
				repo  = "rbenv-path";
			};
		} {
			name = "rbenv-plugin";
			src  = pkgs.fetchFromGithub {
				owner = "taqtiqa";
				repo  = "rbenv-plugin";
				rev   = "60a46ba";
			};
		} {
			name = "ruby-build";
			src  = pkgs.fetchFromGithub {
				owner = "rbenv";
				repo  = "ruby-build";
				rev   = "v20250811";
			};
		} {
			name = "update-rubies";
			src  = pkgs.fetchFromGithub {
				owner = "toy";
				repo  = "rbenv-update-rubies";
				rev   = "b69a563";
			};
		} {
			name = "whatis";
			src  = pkgs.fetchFromGithub {
				owner = "toy";
				repo  = "rbenv-whatis";
				rev   = "738e386";
			};
		} ];
	};

}
