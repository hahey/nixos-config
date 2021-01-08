
{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  xsession.windowManager.i3 = with builtins;
    let
       modifier = config.xsession.windowManager.i3.config.modifier;
       terminal = config.xsession.windowManager.i3.config.terminal;
       menu = config.xsession.windowManager.i3.config.menu;
     in  {
   enable = true;
   config.bars = [ ];
   config.startup = [
     { command = "systemctl --user restart polybar"; always = true; notification = false; }
     { command = "xrandr --output eDP --auto --right-of DisplayPort-2"; notification = false; }
     { command = "conky -d"; always = true; notification = false; }
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
            workspace 3 output eDP
            workspace 4 output DisplayPort-2
            workspace 5 output eDP
            workspace 6 output DisplayPort-2
            workspace 7 output eDP
            workspace 8 output DisplayPort-2
            workspace 9 output eDP
            workspace 10 output DisplayPort-2
    '';
  };

  programs.rofi = {
    enable=true;
    font = "Terminus (TTF) 13";
    fullscreen = false;
    theme = "nixos-config/black-minimal.rasi";
    extraConfig = ''
      disable-history: false;
    '';
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
        font-2="Font Awesome 5 Free Solid:size=16;3";
        font-3="Iosevka Nerd Font:style=Medium:size=16;3";

        # system setting
        monitor = "eDP";
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
        click-left = "~/nixos-config/powermenu.sh";
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

     PATH=/home/$USER/.nix-profile/bin/:/run/current-system/sw/bin/:$PATH polybar -r base &
     '';
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    defaultKeymap = "vicmd";
    prezto = {
      enable = true;
      editor.dotExpansion = true;
      pmodules = lib.mkOptionDefault [ "git" ];
      editor.keymap = "vi";
      editor.promptContext = true;
      historySubstring.foundColor = "fg=blue";
      historySubstring.notFoundColor = "fg=red";
      prompt.pwdLength = "long";
      prompt.theme = "agnoster";
      python.virtualenvAutoSwitch = true;
      python.virtualenvInitialize = true;
      syntaxHighlighting.highlighters =  [ "main" "brackets" "pattern" "line" "cursor" "root" ];
      utility.safeOps = true;
    };
    initExtra = ''
      gic () {
        LBUFFER="git commit -m \""
        RBUFFER="\""
      }
      zle -N gic gic
      bindkey "git c" gic

      ssha () {
        LBUFFER="ssh-add ~/.ssh/id_"
      }
      zle -N ssha ssha
      bindkey "ssh-a" ssha

      function sshon(){
          eval "$(ssh-agent)"
          ssh-add ~/.ssh/id_ed25519_github
      }

      #### Python stuff

      function activate_conda(){
        export PATH="$HOME/miniconda3/bin:$PATH"
      }

      function activate_venv(){
          source $1/bin/activate
      }

      function mkvenv(){
        if [ -n "$VIRTUAL_ENV" ] ; then
            echo "You already have a virtualenv active: $VIRTUAL_ENV"
            return 1
        fi
        local venv_name
        venv_name = $1
        [[ -n $1 ]] || venv_name=".venv"
        if [ -e $venv_name ] ; then
            echo "$venv_name already exists, aborting."
            return 1
        fi
        echo "Will setup virtualenv in $venv_name"
        python3 -m venv $venv_name
        activate_venv $venv_name
        pip install -U pip setuptools
      }

      alias venv="activate_venv .venv"

      #### Configure prompt
      export TERM="xterm-256color"

      prompt_python_version () {
        if [[ -n $VIRTUAL_ENV ]]; then
          prompt_segment $color $PRIMARY_FG
          python --version | tr -d '\n'
        fi
      }

      AGNOSTER_PROMPT_SEGMENTS=(
        prompt_status
        prompt_context
        prompt_virtualenv
        prompt_python_version
        prompt_dir
        prompt_git
        prompt_end
      )

      #alias tools
      function netspeed(){
        if [[ ! -e $HOME/.netspeed ]]; then
          mkvenv $HOME/.netspeed
          pip install -U pip speedtest-cli
        fi
        activate_venv $HOME/.netspeed
        speedtest-cli
        deactivate
      }

      alias gotemp='cd "$(mktemp -d)"'

      function mlvenv(){
        mkvenv
        venv
        pip install -r "$CONFIG"/ml_requirements.list
      }

      function dlvenv(){
        ml_venv
        venv
        pip install -r "$CONFIG"/dl_requirements.list
      }

      function make_ml_playground(){
        gotemp
        mlvenv
      }

      alias mkplay='make_ml_playground'
      '';
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "hahey";
    userEmail = "heynaheyna9@gmail.com";
    extraConfig = {
      core.editor = "nvim";
    };
  };

  home.sessionVariables = { EDITOR = "nvim"; };
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    configure = with builtins; {
      customRC = ''
        "basic setup
        set autoindent
        set smartindent

        set textwidth=100
        set wrap
        set nowrapscan

        set visualbell
        set ruler
        set hlsearch
        set number
        set wildmode=full

        set ts=4 sw=4 et
        set listchars=extends:⇒,precedes:⇐,tab:»·,trail:␣,eol:¬
        set list

        syntax enable

        "setting colorscheme
        set background=dark
        if has('gui_running')
            colorscheme solarized
        else
            colorscheme bubblegum-256-dark
            autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0
            let g:airline_theme='bubblegum'
        endif

        ""setting indent guides
        let g:indent_guides_enable_on_vim_startup=1
        let g:indent_guides_default_mapping=1
        let g:indent_guides_auto_colors=0
        let g:indent_guides_guide_size=4

        "setting syntastic
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        let g:syntastic_always_populate_loc_list=1
        let g:syntastic_auto_loc_list=1
        let g:syntastic_check_on_open=1
        let g:syntastic_check_on_wq=0
        let g:syntastic_loc_list_height=4
        let g:syntastic_python_checkers=['flake8']

        "setting airline
        set laststatus=2
        let g:airline#extensions#tabline#tab_nr_type=2
        let g:airline#extensions#tabline#enabled=1
        let g:airline#extensions#tabline#fnamemod=':t'
        let g:airline#extensions#tabline#switch_buffers_and_tabs=1
        let g:airline#extensions#tabline#buffer_nr_show = 1

        "setting airline for fugitive
        set statusline+=%{GitInfo()}
        let g:airline#extensions#hunks#enabled = 1
        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]
        let g:airline#extensions#branch#displayed_head_limit = 10
        let g:airline#extensions#branch#format = 0

        "setting ultisnips
        " Trigger configuration.
        let g:UltiSnipsExpandTrigger="<M-e>"
        let g:UltiSnipsJumpForwardTrigger="<M-b>"
        let g:UltiSnipsJumpBackwardTrigger="<M-z>"

        " If you want :UltiSnipsEdit to split your window.
        let g:UltiSnipsEditSplit="vertical"

        "setting language client
        let g:LanguageClient_serverCommands = { 'python': ['pyls'] }
        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
        nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
        nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
        nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

        set history=50
        set updatetime=2000
        set grepprg=grep\ -nsHE
        set backspace=indent,eol,start
        set mouse=a

        let mapleader = '\'
        let maplocalleader = '\'

        "setting NERDTree
        autocmd VimEnter * NERDTree
        autocmd VimEnter * vertical resize -10
        nmap <f12> :NERDTreeToggle

        " Folding
        set foldmethod=marker

        " map f3 and f4 to cumulatively toggle spellchecking in english and german respectively
        set spelllang=
        function! SetSpelllang(lang)
            if strridx(&spelllang, a:lang) == -1
                execute "set spl+=".a:lang
                echo "activating spell checking for: ".a:lang." -- the following language(s) are now active: ".&spelllang
            else
                execute "set spl-=".a:lang
                echo "deactivating spell checking for: ".a:lang." -- the following language(s) are now active: ".&spelllang
            endif
            set spell
        endfunction
        map <f3> :call SetSpelllang("en_us")<cr>
        map <f4> :call SetSpelllang("de")<cr>
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            vim-nix
            nerdtree
            vim-colorschemes
            vim-airline
            vim-airline-themes
            syntastic
            vim-fugitive
            vim-indent-guides
            vim-obsession
            fzf-vim
            vim-gitgutter
            vim-easymotion
            LanguageClient-neovim
            YouCompleteMe
          ];
        };
      };
    };

  programs.texlive = {
    enable = true;
    extraPackages = (tpkgs: { inherit (tpkgs) scheme-medium paralist; });
  };

  home.packages = with pkgs; [
    # system tools
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
    gnupg
    pinentry-qt

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
