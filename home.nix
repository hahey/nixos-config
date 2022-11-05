{config, pkgs, ... }: 
  with builtins; with lib;
  let
    extFilter = filter (strings.hasSuffix ".nix");
    relativize = map (filename: ("/home/USERTOREPLACE/.config/nixpkgs/configs-to-include/${filename}"));
    configFiles = pipe ("/home/USERTOREPLACE/.config/nixpkgs/configs-to-include") [toPath readDir attrNames extFilter relativize];
  in
  {
    imports = configFiles;
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.username = "heuna";
    home.homeDirectory = "/home/heuna";
    programs.zsh.enable = true;
    home.stateVersion = "22.05";
    fonts.fontconfig.enable = true;

    services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
    enableSshSupport = true;
    };

    programs.home-manager.enable = true;
  }
