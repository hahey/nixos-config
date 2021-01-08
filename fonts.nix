
{ config, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    # wm
    font-awesome-ttf
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
