{ config, ... }:
{
  networking.wireless.networks = {
    eduroam ={
      auth = ''
        eap=PEAP
        anonymous_identity="anonymous@tu-dresden.de"
        ca_cert="/etc/ssl/certs/ca-certificates.crt"
        domain_suffix_match="radius-eduroam.zih.tu-dresden.de"
        identity="rose159e@tu-dresden.de"
        password="@EDUROAM_AUTH@"
        phase2="auth=mschapv2"
      '';
      authProtocols = [ "WPA-EAP" ];
    };
    agdsn ={
      auth = ''
        eap=TTLS
        anonymous_identity="anonymous@agdsn.de"
        ca_cert="/etc/ssl/certs/ca-certificates.crt"
        domain_suffix_match="radius.agdsn.de"
        identity="r5"
        password="@AGDSN_AUTH@"
        phase2="auth=PAP"
      '';
      authProtocols = [ "WPA-EAP" ];
    };
  };
}
