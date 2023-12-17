{ config, pkgs, ... }:
{
  age.secrets = {
    tud.file = ../../../../secrets/thinkpad/tud.age;
    agdsn.file = ../../../../secrets/thinkpad/agdsn.age;
  };
  networking = {
    wireless.networks = {
      eduroam = {
        auth = ''
          eap=TTLS
          anonymous_identity="anonymous@tu-dresden.de"
          ca_cert="/etc/ssl/certs/ca-certificates.crt"
          domain_suffix_match="radius-eduroam.zih.tu-dresden.de"
          identity="rose159e@tu-dresden.de"
          password="@EDUROAM_AUTH@"
          phase2="auth=PAP"
        '';
        extraConfig = ''
          scan_ssid=1
        '';
        authProtocols = [ "WPA-EAP" ];
      };
      agdsn = {
        auth = ''
          eap=TTLS
          anonymous_identity="wifi@agdsn.de"
          ca_cert="/etc/ssl/certs/ca-certificates.crt"
          domain_suffix_match="radius.agdsn.de"
          identity="r5"
          password="@AGDSN_WIFI_AUTH@"
          phase2="auth=PAP"
        '';
        authProtocols = [ "WPA-EAP" ];
      };
      agdsn-office = {
        priority = 5;
        auth = ''
          eap=TTLS
          anonymous_identity="wifi@agdsn.de"
          ca_cert="/etc/ssl/certs/ca-certificates.crt"
          domain_suffix_match="radius.agdsn.de"
          identity="r5"
          proto=WPA2
          password="@AGDSN_AUTH@"
          phase2="auth=PAP"
        '';
        authProtocols = [ "WPA-EAP" ];
      };
      FSR = {
        psk = "@FSR_PSK@";
        authProtocols = [ "WPA-PSK" ];
      };
      "RoboLab Playground" = {
        psk = "@ROBOLAB_PSK@";
        authProtocols = [ "WPA-PSK" ];
        extraConfig = "disabled=1";
      };
    };
    openconnect.interfaces = {
      TUD-A-Tunnel = {
        # apparently device names have a character limit
        protocol = "anyconnect";
        gateway = "vpn2.zih.tu-dresden.de";
        user = "rose159e@tu-dresden.de";
        passwordFile = config.age.secrets.tud.path;
        autoStart = false;
        extraOptions = {
          authgroup = "A-Tunnel-TU-Networks";
          compression = "stateless";
        };
      };
      TUD-C-Tunnel = {
        protocol = "anyconnect";
        gateway = "vpn2.zih.tu-dresden.de";
        user = "rose159e@tu-dresden.de";
        passwordFile = config.age.secrets.tud.path;
        autoStart = false;
        extraOptions = {
          authgroup = "C-Tunnel-All-Networks";
          compression = "stateless";
        };
      };
    };
  };
  systemd.services = {
    openfortivpn-agdsn = {
      description = "AG DSN Fortinet VPN";
      script = "${pkgs.openfortivpn}/bin/openfortivpn vpn.agdsn.de:443 --realm admin-vpn -u r5 -p $(cat $CREDENTIALS_DIRECTORY/password) --trusted-cert bbbe0df79764c5f1bd4b332e449e43a40e43eec57c983a1e75a1896e6eae4da5";
      requires = [ "network-online.target" ];
      after = [ "network.target" "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        LoadCredential = [
          "password:${config.age.secrets.agdsn.path}"
        ];
        ProtectSystem = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;

        ProtectHome = true;
        ProtectClock = true;
        PrivateTmp = true;

        LockPersonality = true;
      };
    };
  };
}
