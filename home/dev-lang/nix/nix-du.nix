/**
  # [`nix-du`](https://github.com/symphorien/nix-du)
  `nix-du` is a tool aimed at helping answer the following questions:
  * What gc-roots should I remove in my nix store to free some space?
  * What packages should I remove from my profile to free some space?
*/
{ pkgs, ... }: {
  config = {

    home.packages = with pkgs; [
      nix-du
    ];

  };
}
