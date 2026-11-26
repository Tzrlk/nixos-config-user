final: prev: {

  tflint = (prev.tflint.override {
    buildGo125Module = prev.buildGo126Module;
  }).overrideAttrs (finalAttrs: prevAttrs: {
    version = "0.64.0";

    src = prev.fetchFromGitHub {
      owner = "terraform-linters";
      repo  = "tflint";
      tag   = "v${finalAttrs.version}";
      hash  = "sha256-5ure5MysZsMcie75ox3gWEETqhor8wRqylQweuDu1qQ=";
    };

    vendorHash = "sha256-o59/JqIywhqKMkcyq/r1XRE9ldk/dE2v3Qj9IXq0G8s=";

  });
}
