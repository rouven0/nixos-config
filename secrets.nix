let
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2X5hdT9/6BIrRWSE+XBbc4+ocVkPqoAGO2DMSYiJB/";
  nuc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH6pI2rVvnEMG7oHzA47NRahEKQj99pagrat+Q7pOT2v";
  falkenstein = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxar1P+KXVPzHCaIcGg33Gvog+a5Z8snHWSFqbY3WC6";
  rouven = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkxTuzjS3EswMfj+wSKu9ciRyStvjDlDUXzkqEUGDaP";
in
{
  "secrets/thinkpad/wireless.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/tud.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/wireguard/dorm/private.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/wireguard/dorm/preshared.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/borg/passphrase.age".publicKeys = [ rouven thinkpad ];
  "secrets/thinkpad/borg/key.age".publicKeys = [ rouven thinkpad ];
}
