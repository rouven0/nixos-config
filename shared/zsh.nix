{ pkgs, config, lib, ... }:
{
  programs.command-not-found.enable = false;
  environment.systemPackages = with pkgs; [
    # fzf
    bat
    exa
    duf
    trash-cli
    nix-output-monitor
  ];
  users.defaultUserShell = pkgs.zsh;
  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
      ls = "exa --icons";
      l = "ls -l";
      ll = "ls -la";
      la = "ls -a";
      less = "bat";
      update = "cd /etc/nixos && nix flake update";
      garbage = "sudo nix-collect-garbage -d";
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
          sudo true # ask the password so we can leave during the (sometimes quite long) build process
          OUT_PATH=/tmp/nixos-rebuild-nom-$(date +%s)
          ${lib.getExe pkgs.nix-output-monitor} build /etc/nixos#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel -o $OUT_PATH
          sudo ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set $OUT_PATH
          sudo $OUT_PATH/bin/switch-to-configuration switch 
          unlink $OUT_PATH
        }

      '';
    promptInit =
      ''
        if [[ "$(hostname)" == "thinkpad" ]]
        then
          cat ${../images/cat.sixel}
        fi
      '';
  };
}

