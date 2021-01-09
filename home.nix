
{ config, lib, pkgs, ... }:

with builtins; with lib;
let
  extFilter = filter (strings.hasSuffix ".nix");
  relativize = map (filename: (./. + "/configs-to-include/${filename}"));
  configFiles = pipe (./. + "/configs-to-include") [toPath readDir attrNames extFilter relativize];
in
{
  imports = configFiles;

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };
}
