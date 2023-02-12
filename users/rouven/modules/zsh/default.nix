{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "gh" "pass" ];
      theme = "agnoster";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "14f66e4d3d0b366552c0412eb08ca9e0f7c797bd";
          sha256 = "YkfHPSuSKParz7JidR924CJSuXO6Rk0RZTlxPOBwLJk=";
        };
      }
    ];

    localVariables = {
      COMPLETION_WAITING_DOTS = "true";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#00bbbb,bold";
      # ZSH_AUTOSUGGEST_STRATEGY="(history completion)";
    };

    initExtra =
      ''
        function c() {
            if [ $# -eq 0 ]; then
                cd $(find -maxdepth 4 -not -path '*[cC]ache*' -not -path '*[tT]rash*' -type d | fzf --preview 'tree -C {}')
            else
                $1 $(find -maxdepth 5 -not -path '*[cC]ache*' -not -path '*[tT]rash*' | fzf --preview 'tree -C {}')
            fi
        }
 
        function svpn() {
          unit=$(systemctl list-unit-files | grep "openconnect\|wg-quick\|wireguard\|openvpn" | cut -d "." -f1 | fzf --preview 'systemctl status {}')
          if [ $(systemctl is-active $unit) = "inactive" ]; then
          	systemctl start $unit
          else
          	systemctl stop $unit
          fi
        }
 
        prompt_dir() {
            prompt_segment blue $CURRENT_FG '%c'
        }
      '';
  };
}
