
{ config, lib, pkgs, ... }:

{
  imports = [ "configs-to-include/*.nix" ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };
}
