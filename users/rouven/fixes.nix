{ pkgs, ... }:
{
  # nodejs 16 is EOL but bitwarden depends on it
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];
  # fixes pam entries for swaylock
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.

    auth sufficient pam_unix.so nullok likeauth try_first_pass
    auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';
}
