{ pkgs, ... }:

let
  script-name = "tmux-cht.sh";
  tmux-cht = (pkgs.writeScriptBin script-name (builtins.readFile ./tmux-cht.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ tmux-cht ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${tmux-cht} --prefix PATH : $out/bin";
}
