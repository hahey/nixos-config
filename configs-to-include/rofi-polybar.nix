{ config, lib, pkgs, ... }:
let
  external = "/home/heuna/nixos-config/external-config";
in
{

  programs.rofi = {
    enable=true;
    font = "Terminus (TTF) 13";
    theme = "${external}/black-minimal.rasi";
    extraConfig = {
      disable-history = false;
    };
  };

  services.polybar = with builtins; {
    package = pkgs.polybar.override {
      pulseSupport = true;
      i3GapsSupport = true;
      mpdSupport = true;
      alsaSupport = true;
      githubSupport = true;
    };
    enable = true;
    config = let
      foreground = "#ff5555";
      background = "#1d1f28";
      accent = "#fb8c00";
    in {
      "global/wm" = {
        margin-top = 0;
        margin-bottom = 0;
      };
      "bar/base" = {
        # visual setting
        height = 30;
        width = "100%";
        fixed-center = true;

        offset-x = "0%";
        offset-y = "0%";

        padding = 2;
        module-margin = 1;

        background = "${background}";
        foreground = "${foreground}";
        bottom = false;

        border-color = "${foreground}";
        border-size = 2;

        line-size = 2;

        font-0="Terminus (TTF):size=12;3";
        font-1="Siji:size=16;3";
        #font-1="Font Awesome 5 Free Solid:size=16;3";
        font-2="Iosevka Nerd Font:style=Medium:size=16;3";

        # system setting
        # monitor = "eDP";
        wm-name = "i3";
        enable-ipc=true;

        # module settings
        modules-left = "launcher title ";
        modules-center = "i3mode workspaces";
        modules-right = "alsa battery xkeyboard network date powermenu";
      };

      # module definitions
      "module/launcher" = {
        type = "custom/text";
        content = "";
        content-margin = 1;
        click-left = "rofi -show run -modi run -location 1";
      };
      "module/title" = {
        type = "internal/xwindow";
        label = "  %title:0:53:...%  ";
        label-foreground = "${accent}";
        label-empty = "";
        format-margin = 4;
      };
      "module/i3mode" = {
        type = "internal/i3";
        format = "<label-mode>";
        label-mode = "%mode%";
        label-mode-background = "${accent}";
        label-mode-foreground = "${background}";
        label-mode-padding = 2;
      };
      "module/workspaces" = {
        type = "internal/xworkspaces";
        pin-workspaces = false;
        enable-click = true;
        enable-scroll = true;

        label-active = "";
        label-occupied = "";
        # label-occupied = "";
        label-urgent = "";
        label-empty = "";

        format = "<label-state>";

        label-monitor = "%name%";
        label-active-foreground = "${foreground}";
        label-occupied-foreground = "${foreground}";
        label-urgent-foreground = "${accent}";
        label-empty-foreground = "${foreground}";

        label-active-padding = 1;
        label-urgent-padding = 1;
        label-occupied-padding = 1;
        label-empty-padding = 1;
      };
      "module/alsa" = {
        type = "internal/alsa";

        format-volume = "<ramp-volume> <label-volume>";
        format-volume-background = "${background}";
        format-volume-foreground = "${foreground}";
        format-volume-padding = 2;
        format-volume-margin = 2;
        use-ui-max = true;
        interval = 5;

        label-volume = "%percentage:4:4%%";

        format-muted-prefix = "";
        label-muted = " Muted";
        format-muted-background = "${background}";
        format-muted-foreground = "${accent}";
        format-muted-padding = 2;
        format-muted-margin = 2;

        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";
        ramp-volume-3 = "";
        ramp-volume-4 = "";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        # List of indicators to ignore
        blacklist-0 = "num lock";
        blacklist-1 = "scroll lock";
        format = "<label-layout> <label-indicator>";
        format-spacing = 0;

        label-layout = "%layout%";
        label-layout-padding = 2;

        label-indicator-on = "%icon%";
        label-indicator-off = "%icon%";
        indicator-icon-default = "";
        indicator-icon-0 = "caps lock;-CL;+CL";
        format-padding = 1;
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 2;

        format-charging = "<animation-charging> <label-charging>";
        format-charging-background = "${background}";
        format-charging-foreground = "${foreground}";
        format-charging-padding = 1;

        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-background = "${background}";
        format-discharging-foreground = "${foreground}";
        format-discharging-padding = 1;

        label-charging = "%percentage%%";
        label-discharging = "%percentage%%";

        label-full = "Fully Charged";
        label-full-background = "${background}";
        label-full-foreground = "${foreground}";
        label-full-padding = 1;

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-5 = "";
        ramp-capacity-6 = "";
        ramp-capacity-7 = "";
        ramp-capacity-8 = "";
        ramp-capacity-9 = "";

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-5 = "";
        animation-charging-6 = "";
        animation-charging-7 = "";
        animation-charging-8 = "";
        animation-charging-framerate = 750;
      };
      "module/date" = {
        type = "internal/date";
        interval = "1.0";

        time = " %H:%M";
        time-alt = " %d/%m/%Y%";

        format = "<label>";
        format-background = "${background}";
        format-foreground = "${foreground}";
        format-padding = 1;
        label = "%time%";
      };
      "module/powermenu" = {
        type = "custom/text"; 
        content-padding = 2;
        content = "";
        click-left = "bash ${external}/powermenu.sh";
      };
      "module/network" = {
        type = "internal/network";
        interface = "wlp4s0";
        interval = 3;
        accumulate-stats = true;
        unknown-as-up = true;

        format-connected = "<ramp-signal> <label-connected>";
        format-connected-margin = 3;

        format-disconnected = "<label-disconnected>";
        format-disconnected-margin = 3;

        label-connected = "%essid%";
        label-disconnected = " disconnected";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
     };
   };
   script = ''
     killall -q polybar
     while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

     PATH=/home/$USER/.nix-profile/bin/:/run/current-system/sw/bin:$PATH polybar -r base &
     '';
  };
}
