{ config, lib, pkgs, ... }:

{

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

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
        venv_name=$1
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

      # export LD_LIBRARY_PATH="/nix/store/ai5054xzilz0q285c0ldabmkvhyyl6yq-glib-2.64.6/lib/:/nix/store/1waaha9ax2nr660y9iz5zpdg67r2sfzj-pango-1.45.5/lib/:/run/current-system/sw/lib/:/nix/var/nix/profiles/per-user/heuna/profile/lib/:/home/heuna/.nix-profile/lib/:$LD_LIBRARY_PATH"
      '';
  };
}
