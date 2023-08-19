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
    };
    histSize = 100000;
    histFile = "~/.local/share/zsh/history";
    syntaxHighlighting.enable = true;
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
        export MCFLY_KEY_SCHEME=vim
        export MCFLY_FUZZY=2
        export MCFLY_DISABLE_MENU=TRUE
        export MCFLY_RESULTS=30
        export MCFLY_INTERFACE_VIEW=BOTTOM
        export MCFLY_PROMPT="❯"
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

        shell() {
          unset PKGS
          for var in "$@"
          do
            PKGS=$PKGS\ nixpkgs/nixos-unstable#$var
          done
          eval ${pkgs.nix-output-monitor}/bin/nom shell $PKGS
        }

      '';
    promptInit =
      ''
        if [[ "$(hostname)" == "thinkpad" ]]
        then
          cat ${../images/cat.sixel}
        fi
        eval "$(${pkgs.mcfly}/bin/mcfly init zsh)"
      '';
  };
}

