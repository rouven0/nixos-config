{ pkgs, config, ... }:
{
  programs.command-not-found.enable = false;
  environment.systemPackages = with pkgs; [
    fzf
    bat
    exa
    trash-cli
  ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
      ls = "exa --icons";
      l = "ls -l";
      ll = "ls -la";
      la = "ls -a";
      less = "bat";
      update = "cd /etc/nixos && nix flake update && cat ${../images/another-cat.sixel}";
      garbage = "sudo nix-collect-garbage -d && cat ${../images/cat-garbage.sixel}";
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

        zsh-newuser-install () {}

        switch() {
          OUT_PATH=/tmp/nixos-rebuild-nom-$(date +%s)
          ${pkgs.nix-output-monitor}/bin/nom build /etc/nixos#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel -o $OUT_PATH
          sudo $OUT_PATH/bin/switch-to-configuration switch
          unlink $OUT_PATH
        }

      '';

    # Hacky way to bind Ctrl+R to fzf. Otherwise it will be overridden 
    promptInit =
      ''
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        if [[ "$(hostname)" == "thinkpad" ]]
        then
          cat ${../images/cat.sixel}
        fi
      '';
  };
}

