{ pkgs, ... }:
{
  programs.command-not-found.enable = false;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
      ls = "exa --icons";
      l = "ls -l";
      ll = "ls -la";
      la = "ls -a";
      switch = "sudo nixos-rebuild switch && cat ${../images/another-cat-2.sixel}";
      update = "cd /etc/nixos && nix flake update && cat ${../images/another-cat.sixel}";
      garbage = "sudo nix-collect-garbage -d && cat ${../images/cat-garbage.sixel}";
      q = "exit";
    };
    histSize = 100000;
    histFile = "~/.local/share/zsh/history";
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=#00bbbb,bold";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "gh" ];
      theme = "agnoster";
    };

    shellInit =
      ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

        function c() {
            if [ $# -eq 0 ]; then
                cd $(find -maxdepth 4 -not -path '*[cC]ache*' -not -path '*[tT]rash*' -type d | fzf --preview '${pkgs.tree}/bin/tree -C {}')
            else
                $1 $(find -maxdepth 5 -not -path '*[cC]ache*' -not -path '*[tT]rash*' | fzf --preview '${pkgs.tree}/bin/tree -C {}')
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
        cat ${../images/cat.sixel}
      '';
  };
}

