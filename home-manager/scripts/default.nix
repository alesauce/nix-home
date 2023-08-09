{ nixpkgs, ... }:

let
  pkgs = import nixpkgs;
  allScripts = builtins.readDir ./shell-files;
in

