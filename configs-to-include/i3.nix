{ config, lib, pkgs, ... }:

{

  xsession.windowManager.i3 = with builtins;
    let
       modifier = config.xsession.windowManager.i3.config.modifier;
       terminal = config.xsession.windowManager.i3.config.terminal;
       menu = config.xsession.windowManager.i3.config.menu;
     in  {
   enable = true;
   config.bars = [ ];
   config.startup = [
     { command = "exec systemctl --user restart polybar"; always = true; notification = false; }
     { command = "exec xrandr --output eDP --primary --output DisplayPort-3 --left-of eDP --mode 1920x1080 --output DisplayPort-2 --auto --right-of eDP"; always = true; notification = false; }
     { command = "exec conky -d"; always = true; notification = false; }
     { command = "exec setxkbmap -layout us,de,kr -option grp:alt_space_toggle"; notification = false; }
     { command = "exec gpg-agent"; notification = false; }
     { command = "exec ibus-daemon --daemonize --xim"; notification = false; }
   ];
   config.modifier = "Mod4";
   config.terminal = "konsole";
   config.menu = "rofi -show run -modi run -location 1";
   config.keybindings =
     {
       "${modifier}+Return" = "exec ${terminal}";
       "${modifier}+Shift+q" = "kill";
       "${modifier}+d" = "exec ${menu}";
       "${modifier}+x" = "exec bash /home/heuna/nixos-config/external-config/powermenu.sh";

       "${modifier}+h" = "focus left";
       "${modifier}+j" = "focus down";
       "${modifier}+k" = "focus up";
       "${modifier}+l" = "focus right";

       "${modifier}+Left" = "focus left";
       "${modifier}+Down" = "focus down";
       "${modifier}+Up" = "focus up";
       "${modifier}+Right" = "focus right";

       "${modifier}+Shift+h" = "move left";
       "${modifier}+Shift+j" = "move down";
       "${modifier}+Shift+k" = "move up";
       "${modifier}+Shift+l" = "move right";

       "${modifier}+Shift+Left" = "move left";
       "${modifier}+Shift+Down" = "move down";
       "${modifier}+Shift+Up" = "move up";
       "${modifier}+Shift+Right" = "move right";

       "${modifier}+p" = "split h";
       "${modifier}+v" = "split v";
       "${modifier}+f" = "fullscreen toggle";

       "${modifier}+s" = "layout stacking";
       "${modifier}+w" = "layout tabbed";
       "${modifier}+e" = "layout toggle split";

       "${modifier}+Tab" = "floating toggle";
       "${modifier}+Shift+Tab" = "focus mode_toggle";

       "${modifier}+o" = "focus parent";

       "${modifier}+Shift+minus" = "move scratchpad";
       "${modifier}+minus" = "scratchpad show";

       "${modifier}+1" = "workspace number 1";
       "${modifier}+2" = "workspace number 2";
       "${modifier}+3" = "workspace number 3";
       "${modifier}+4" = "workspace number 4";
       "${modifier}+5" = "workspace number 5";
       "${modifier}+6" = "workspace number 6";
       "${modifier}+7" = "workspace number 7";
       "${modifier}+8" = "workspace number 8";
       "${modifier}+9" = "workspace number 9";
       "${modifier}+0" = "workspace number 10";

       "${modifier}+Shift+1" = "move container to workspace number 1";
       "${modifier}+Shift+2" = "move container to workspace number 2";
       "${modifier}+Shift+3" = "move container to workspace number 3";
       "${modifier}+Shift+4" = "move container to workspace number 4";
       "${modifier}+Shift+5" = "move container to workspace number 5";
       "${modifier}+Shift+6" = "move container to workspace number 6";
       "${modifier}+Shift+7" = "move container to workspace number 7";
       "${modifier}+Shift+8" = "move container to workspace number 8";
       "${modifier}+Shift+9" = "move container to workspace number 9";
       "${modifier}+Shift+0" = "move container to workspace number 10";

       "${modifier}+Shift+c" = "reload";
       "${modifier}+Shift+r" = "restart";
       "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

       "${modifier}+r" = "mode resize";
       "${modifier}+a" = "mode application";
     };
     config.modes = {
          resize = {
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";

            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";

            "Escape" = "mode default";
            "Return" = "mode default";
            "${modifier}+r" = "mode default";
      };

          application = {
            "f" = "exec firefox";
            "b" = "exec appimage-run ~/Downloads/boost-note-linux.AppImage";
            "g" = "exec google-chrome-stable";
            "c" = "exec chromium";
            "p" = "exec pavucontrol";

            "Escape" = "mode default";
            "Return" = "mode default";
            "${modifier}+a" = "mode default";
      };
    };
    extraConfig = ''
            workspace 1 output eDP
            workspace 2 output DisplayPort-2
            workspace 3 output DisplayPort-3
            workspace 4 output eDP
            workspace 5 output DisplayPort-2
            workspace 6 output DisplayPort-3
            workspace 7 output eDP
            workspace 8 output DisplayPort-2
            workspace 9 output DisplayPort-3
            workspace 10 output eDP
    '';
  };
}
