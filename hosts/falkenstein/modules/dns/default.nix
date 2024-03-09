{ pkgs, ... }:
{
  services.bind = {
    enable = true;
    zones = {
      "rfive.de" = {
        master = true;
        slaves = [
          "185.181.104.96"
        ];
        extraConfig = ''
          also-notify {185.181.104.96;};
        '';
        file = pkgs.writeText "rfive.de_zone.txt" ''
          $TTL 3600
          $ORIGIN rfive.de.
        
          rfive.de.  86400  IN  SOA ns.rfive.de. hostmaster.rfive.de. 2024030832 10800 3600 604800 3600
          @  3600   IN  NS  ns.rfive.de.
          @  3600   IN  NS  ns.inwx.de.
          @  3600   IN  NS  ns2.inwx.de.

          ns.rfive.de. 3600 IN A 23.88.121.184
          ns.rfive.de. 3600 IN AAAA 2a01:4f8:c012:49de::1

          @  IN   A     23.88.121.184
          @  IN   AAAA  2a01:4f8:c012:49de::1
          @  IN   CAA   0 iodef "mailto:ca@rfive.de"
          @  IN   CAA   0 issue "letsencrypt.org"
          @  IN   CAA   0 issuewild ";"

          nuc         IN A 141.30.227.6

          falkenstein IN A 23.88.121.184
          falkenstein IN AAAA 2a01:4f8:c012:49de::1
          falkenstein IN SSHFP 1 1 DE42CA418093CF94EABC124E101AE4D8DE02C69F
          falkenstein IN SSHFP 1 2 149100F5C3CA333E20E7B03EB463B0FB23D34FFE1FC65EFAADDDBE51 8EC35990
          falkenstein IN SSHFP 4 1 70A38677DEE50C5B67AA11400A6BCD4984355C2A
          falkenstein IN SSHFP 4 2 B25AD18A23C885AE965875C4C9EDA4E4EDFD3503334B10F0BFE7527B EB178CB2

          @    IN MX 1 mail.rfive.de.
          mail IN A 23.88.121.184
          mail IN AAAA 2a01:4f8:c012:49de::1

          @                 IN TXT "v=spf1 mx ~all"
          rspamd._domainkey IN TXT "v=DKIM1; k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDoirUMubro4nlmY6a8JMwK9QB2agAXiJzexDU/7ba6KCggONfoSTfUHlrM/XeM1GG/9oKpngApxDPP97adJuxc8/EELyo4HjTyYD8GBFZhg0AN7V8IPaJ1o5k6dGDk8ZLh41ZCnlAVWkhVSKs5pYtzkrlJIfUSzyuoe8nuFsVe3QIDAQAB"
          _dmarc            IN TXT "v=DMARC1; p=none; adkim=s; fo=1; rua=mailto:dmarc@rfive.de; ruf=mailto:dmarc@rfive.de"

          cache      IN CNAME nuc.rfive.de.
          chat       IN CNAME nuc.rfive.de.
          img.trucks IN CNAME falkenstein.rfive.de.
          matrix     IN CNAME nuc.rfive.de.
          purge      IN CNAME falkenstein.rfive.de.
          rspamd     IN CNAME falkenstein.rfive.de.
          seafile    IN CNAME nuc.rfive.de.
          trucks     IN CNAME falkenstein.rfive.de.
          vault      IN CNAME nuc.rfive.de.

          _discord IN TXT "dh=0bcca75b0a56c304f0c23fbdb3f12009411e8c0c"
        '';
      };
    };
  };
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];
}
