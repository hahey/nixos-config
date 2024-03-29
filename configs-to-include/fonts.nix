
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # wm
    font-awesome
    powerline-fonts
    siji
    iosevka
    terminus_font_ttf
    (nerdfonts.override { fonts = [ "Iosevka" "FantasqueSansMono" ]; })
    comfortaa

    # korean
    nanum-gothic-coding
    noto-fonts-cjk
  ];
}
