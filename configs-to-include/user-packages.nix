
{ config, lib, pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    extraPackages = (tpkgs: { inherit (tpkgs) scheme-medium paralist; });
  };

  home.packages = with pkgs; [
    # system tools
    file
    htop
    tree
    conky
    procps
    psmisc
    pavucontrol
    appimage-run

    # git related
    gitAndTools.qgit
    tig

    # browsers
    firefox-esr
    ungoogled-chromium
    google-chrome

    # pdf
    okular
    pdftk
    ipe

    # network
    wget
    curl
    openssh
    sshpass
    wirelesstools
    networkmanager-vpnc
    networkmanager-openvpn

    # securities
    gnupg
    pinentry-qt
    tomb
    cryptsetup
    steghide
    keepass
    keepass-otpkeyprov

    # other applications
    wine
    akregator
    blender
    gimp
    musescore
    audacity
    betterlockscreen

    # python
    (python3.withPackages(ps: [
      ps.python-language-server
      ps.pyls-mypy ps.pyls-isort ps.pyls-black ps.flake8
    ]))

    # TODO: boostnote
  ];
}
