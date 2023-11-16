let
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2X5hdT9/6BIrRWSE+XBbc4+ocVkPqoAGO2DMSYiJB/";
  nuc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH6pI2rVvnEMG7oHzA47NRahEKQj99pagrat+Q7pOT2v";
  falkenstein = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxar1P+KXVPzHCaIcGg33Gvog+a5Z8snHWSFqbY3WC6";
  rouven = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkxTuzjS3EswMfj+wSKu9ciRyStvjDlDUXzkqEUGDaP";
in
{
  # thinkpad
  "secrets/thinkpad/wireless.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/tud.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/wireguard/dorm/private.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/wireguard/dorm/preshared.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/borg/passphrase.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/borg/key.age".publicKeys = [ rouven thinkpad ];

  # nuc
  "secrets/nuc/nextcloud/adminpass.age".publicKeys = [ rouven nuc ];
  "secrets/nuc/matrix/shared.age".publicKeys = [ rouven nuc ];
  "secrets/nuc/matrix/sync.age".publicKeys = [ rouven nuc ];
  "secrets/nuc/vaultwarden.age".publicKeys = [ rouven nuc ];
  "secrets/nuc/borg/passphrase.age".publicKeys = [ rouven nuc ];
  "secrets/nuc/borg/key.age".publicKeys = [ rouven nuc ];

  # falkenstein
  "secrets/falkenstein/purge.age".publicKeys = [ rouven falkenstein ];
  "secrets/falkenstein/pfersel.age".publicKeys = [ rouven falkenstein ];
  "secrets/falkenstein/wireguard/dorm/private.age".publicKeys = [ rouven falkenstein ];
  "secrets/falkenstein/wireguard/dorm/preshared.age".publicKeys = [ rouven falkenstein ];
  "secrets/falkenstein/borg/passphrase.age".publicKeys = [ rouven falkenstein ];
  "secrets/falkenstein/borg/key.age".publicKeys = [ rouven falkenstein ];

  # rouven (home manager)
  "secrets/rouven/mail/rfive.age".publicKeys = [ rouven ];
  "secrets/rouven/mail/ifsr.age".publicKeys = [ rouven ];
  "secrets/rouven/mail/tu-dresden.age".publicKeys = [ rouven ];
  "secrets/rouven/mail/agdsn.age".publicKeys = [ rouven ];
  "secrets/rouven/mail/google.age".publicKeys = [ rouven ];
  "secrets/rouven/ssh/git.age".publicKeys = [ rouven ];
  "secrets/rouven/spotify.age".publicKeys = [ rouven ];
}
