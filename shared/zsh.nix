{ pkgs, config, lib, ... }:
{
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
  environment.systemPackages = with pkgs; [
    # fzf
    bat
    eza
    duf
    trash-cli
    nix-output-monitor
    iperf
  ];
  users.defaultUserShell = pkgs.zsh;
  programs.fzf = {
    keybindings = true;
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
      ls = "eza --icons";
      l = "ls -l";
      ll = "ls -la";
      la = "ls -a";
      less = "bat";
      update = "cd /etc/nixos && nix flake update";
      msh = "f() {mosh $1 zsh};f";
    };
    histSize = 100000;
    histFile = "~/.local/share/zsh/history";
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=#00bbbb,bold";
    };
    shellInit = ''
      zsh-newuser-install () {}
    '';

    interactiveShellInit =
      ''
        export MCFLY_KEY_SCHEME=vim
        export MCFLY_FUZZY=2
        export MCFLY_DISABLE_MENU=TRUE
        export MCFLY_RESULTS=30
        export MCFLY_INTERFACE_VIEW=BOTTOM
        export MCFLY_PROMPT="❯"
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source ${pkgs.agdsn-zsh-config}/etc/zsh/zshrc
        unsetopt extendedglob

      
        function svpn() {
          unit=$(systemctl list-unit-files | grep "openconnect\|wg-quick\|wireguard\|openvpn\|openfortivpn" | cut -d "." -f1 | fzf --preview 'systemctl status {}')
          if [ $(systemctl is-active $unit) = "inactive" ]; then
            systemctl start $unit
          else
            systemctl stop $unit
          fi
        }

        prompt_dir() {
            prompt_segment blue $CURRENT_FG '%c'
        }

        switch() {
          sudo true # ask the password so we can leave during the (sometimes quite long) build process
          OUT_PATH=/tmp/nixos-rebuild-nom-$(date +%s)
          ${lib.getExe pkgs.nix-output-monitor} build /etc/nixos\#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel -o $OUT_PATH
          sudo ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set $OUT_PATH
          sudo $OUT_PATH/bin/switch-to-configuration switch 
          unlink $OUT_PATH
        }

        garbage() {
          ${pkgs.home-manager}/bin/home-manager expire-generations "-0 days"
          sudo nix-collect-garbage -d
          echo Cleaning up boot entries...
          sudo /run/current-system/bin/switch-to-configuration boot
          echo Done
        }

        sysdiff() {
          echo System package diff:
          ${config.nix.package}/bin/nix store diff-closures $(command ls -d /nix/var/nix/profiles/system-* | tail -2)
        }
      '';
    promptInit =
      ''
        if [[ "$(hostname)" == "thinkpad" ]]
        then
          cat ${../images/cat.sixel}
        fi
        eval "$(${pkgs.mcfly}/bin/mcfly init zsh)"
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      '';
  };
}

