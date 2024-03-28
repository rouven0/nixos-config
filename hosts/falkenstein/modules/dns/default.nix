{ pkgs, config, ... }:
let
  secondary = "185.181.104.96";
  zonefile = pkgs.writeText "rfive.de.zone.txt" ''
    $TTL 3600
    $ORIGIN rfive.de.

    rfive.de.   86400  IN  SOA ns.rfive.de. hostmaster.rfive.de. (
      2024032601 ; serial
      10800      ; refresh
      3600       ; retry
      604800     ; expire
      3600 )     ; negatives caching, ehem. minimum
    
    @ NS ns.inwx.de.
    @ NS ns2.inwx.de.
    @ NS ns3.inwx.eu.

    @   A    23.88.121.184
    @   AAAA 2a01:4f8:c012:49de::1

    @   CAA 0 iodef "mailto:ca@rfive.de"
    @   CAA 0 issue "letsencrypt.org"
    @   CAA 0 issuewild ";"

    ns   A    23.88.121.184
    ns   AAAA 2a01:4f8:c012:49de::1

    nuc         A     141.30.227.6
    falkenstein A     23.88.121.184
    falkenstein AAAA  2a01:4f8:c012:49de::1
    falkenstein SSHFP 1 1 DE42CA418093CF94EABC124E101AE4D8DE02C69F
    falkenstein SSHFP 1 2 149100F5C3CA333E20E7B03EB463B0FB23D34FFE1FC65EFAADDDBE51 8EC35990
    falkenstein SSHFP 4 1 70A38677DEE50C5B67AA11400A6BCD4984355C2A
    falkenstein SSHFP 4 2 B25AD18A23C885AE965875C4C9EDA4E4EDFD3503334B10F0BFE7527B EB178CB2

    @    MX 1 mail.rfive.de.
    mail A 23.88.121.184
    mail AAAA 2a01:4f8:c012:49de::1

    @                 TXT "v=spf1 mx ~all"
    rspamd._domainkey TXT "v=DKIM1; k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDoirUMubro4nlmY6a8JMwK9QB2agAXiJzexDU/7ba6KCggONfoSTfUHlrM/XeM1GG/9oKpngApxDPP97adJuxc8/EELyo4HjTyYD8GBFZhg0AN7V8IPaJ1o5k6dGDk8ZLh41ZCnlAVWkhVSKs5pYtzkrlJIfUSzyuoe8nuFsVe3QIDAQAB"
    _dmarc            TXT "v=DMARC1; p=none; adkim=s; fo=1; rua=mailto:dmarc@rfive.de; ruf=mailto:dmarc@rfive.de"

    cache      CNAME nuc.rfive.de.
    chat       CNAME nuc.rfive.de.
    matrix     CNAME nuc.rfive.de.
    seafile    CNAME nuc.rfive.de.
    vault      CNAME nuc.rfive.de.

    purge      CNAME falkenstein.rfive.de.
    rspamd     CNAME falkenstein.rfive.de.
    trucks     CNAME falkenstein.rfive.de.
  '';
in
{
  services.bind = rec {
    enable = true;
    directory = "/var/lib/bind";
    extraConfig = ''
      dnssec-policy "split-keys" {
        keys {
          ksk lifetime unlimited algorithm ecdsap256sha256;
          zsk lifetime 60d algorithm ecdsap256sha256;
        };
        publish-safety 1d;
        retire-safety 1d;
      };
    '';
    zones = {
      "rfive.de" = {
        master = true;
        slaves = [
          secondary
        ];
        extraConfig = ''
          also-notify {${secondary};};
          dnssec-policy split-keys;
          inline-signing yes;
          serial-update-method date;
        '';
        file = "${directory}/rfive.de.zone.txt";
      };
    };
  };
  systemd.services.bind.preStart = ''
    # copy the file manually to its destination since signing requires a writable directory
    ${pkgs.coreutils}/bin/cp ${zonefile} ${config.services.bind.directory}/rfive.de.zone.txt
    ${pkgs.coreutils}/bin/chown named:named ${config.services.bind.directory}/rfive.de.zone.txt
  '';
  networking.firewall.extraInputRules = ''
    ip saddr ${secondary}/32 tcp dport 53 accept comment "Allow DNS AXFR access from INWX Servers"
    ip saddr ${secondary}/32 udp dport 53 accept comment "Allow DNS access from INWX Servers"
  '';
  environment.systemPackages = with pkgs; [ dig.out ];
}
