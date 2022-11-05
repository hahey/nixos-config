{ config, lib, pkgs, ... }:

with builtins; with lib;
let
  extFilter = filter (strings.hasSuffix ".nix");
  relativize = map (filename: (./. + "/configs-to-include/${filename}"));
  configFiles = pipe (./. + "/configs-to-include") [toPath readDir attrNames extFilter relativize];
in
{
  home.packages = [ pkgs.atool pkgs.httpie ];
  home.username = "heuna";
  home.homeDirectory = "/home/heuna";
  fonts.fontconfig.enable = true;

  imports = configFiles;
  home.stateVersion = "22.05";
}
