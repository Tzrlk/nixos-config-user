/**
 * # [`nh`](https://github.com/nix-community/nh)
 * NH is a modern helper utility that aims to consolidate and reimplement some of
 * the commands and interfaces from various tools within the Nix/NixOS ecosystem.
 * Our goal is to provide a cohesive, easily-understandable interface with more
 * features, better ergonomics and at many times better speed. In addition to
 * acting as a super-convenient, all-in-one utility that reimplements well-known
 * and commonly used Nix commands, NH is a pretty tool that brings together
 * relevant 3rd party projects that you might be familiar with.
 *
 * ## TODO
 * [ ] Implement as nixos and/or system module.
 */
{ pkgs, inputs, system, ... }: {
  config = {

    home.packages = with pkgs; [
      inputs.nh.packages.${system}.default
    ];

  };
}
