{ pkgs, lib, ... }:
{

  # fixes qt and themes
  environment.variables = {
    "QT_STYLE_OVERRIDE" = lib.mkForce "kvantum";
    "QT_QPA_PLATFORMTHEME" = lib.mkForce "Dracula";
    "GTK_THEME" = "Dracula";
  };
  # open ports for kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
  # enable xdg portals for sway
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [ "wlr" ];
      };
      "org.freedesktop.impl.portal.Secret" = {
        default = [ "gnome-keyring" ];
      };
    };
  };
  # wayland keylogger needs setuid
  programs.wshowkeys.enable = true;
  # home manager needs dconf
  programs.dconf.enable = true;
  # fixes pam entries for swaylock
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.

    auth sufficient pam_unix.so nullok likeauth try_first_pass
    auth sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so
    auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';
  # global wrapper for ausweisapp
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
  # home manager steam is borderline broken
  programs.steam.enable = true;

  # enable java black magic 
  programs.java.enable = true;
}
