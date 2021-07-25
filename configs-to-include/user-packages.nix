
{ config, lib, pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    extraPackages = (tpkgs: { inherit (tpkgs) scheme-medium paralist hyphenat wrapfig; });
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
    (appimage-run.override {
      extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
    })

    # git related
    gitAndTools.qgit
    tig

    # browsers
    firefox
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
    networkmanager-openvpn

    # securities
    gnupg
    pinentry-qt
    tomb
    # cryptsetup
    # steghide
    keepassxc

    # other applications
    playonlinux
    akregator
    # blender
    gimp
    musescore
    audacity
    betterlockscreen

    python3
    # (python3.withPackages(ps: [
    # ps.pyls-mypy ps.pyls-isort ps.pyls-black ps.flake8
    # ]))

    transcribe

    # TODO: boostnote
  ];
}
