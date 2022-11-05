# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override { extraPkgs = pkgs: [pkgs.gnome2.GConf pkgs.mono 
    pkgs.libva1 pkgs.libva1-minimal]; };
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

    # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "HOSTNAME"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "all" ];
    # extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "de_DE.UTF-8"; };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = [ pkgs.ibus-engines.hangul ];
      ibus.panel = null;
    };
  };
  services.xserver.layout = "us,de,kr";

  # enable AMD graphic
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime amdvlk driversi686Linux.amdvlk ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
   "brlaser" "brgenml1cupswrapper" "brgenml1lpr" "google-chrome" "transcribe" # ];
  "steam-original" "steam" "steam-run"];
  services.printing.drivers = with pkgs; [ brlaser brgenml1cupswrapper brgenml1lpr ];

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.USERTOREPLACE = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "dialout"]; # Enable ‘sudo’ for the user.
  };
  nix.settings.allowed-users = [ "@wheel" ];

  home-manager.users.USERTOREPLACE =  { config, lib, pkgs, ... }:
    with builtins; with lib;
    let
      extFilter = filter (strings.hasSuffix ".nix");
      relativize = map (filename: ("/home/heuna/.config/nixpkgs/configs-to-include/${filename}"));
      configFiles = pipe ("/home/heuna/.config/nixpkgs/configs-to-include") [toPath readDir attrNames extFilter relativize];
    in
    {
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.username = "heuna";
    home.homeDirectory = "/home/heuna";
    fonts.fontconfig.enable = true;

    imports = configFiles;
    home.stateVersion = "22.11";
    manual.manpages.enable = false;
    programs.home-manager.enable = true;
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  
  environment.systemPackages = [pkgs.home-manager];

  programs.steam.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
