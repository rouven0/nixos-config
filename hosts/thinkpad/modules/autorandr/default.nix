{ config, pkgs, ...}:
let
  fp_eDP-1 = "00ffffffffffff0009e5c608000000001f1d0104a522137803dae5955d59942924505400000001010101010101010101010101010101963b803671383c403020360058c21000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631353646484d2d4e34380a0043";
  fp_HDMI-1 = "00ffffffffffff00410ccfc0fb0100001f19010380301b782a3935a25952a1270c5054bd4b00d1c09500950fb30081c0818001010101023a801871382d40582c4500dd0c1100001e000000ff005a564331353331303030353037000000fc0050484c2032323356350a202020000000fd00384c1e5311000a202020202020017a020322f14f010203050607101112131415161f04230917078301000065030c001000023a801871382d40582c4500dd0c1100001e8c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c110000180000000000000000000000000000000000000000004d";
in
{
  services.autorandr = {
    enable = true;
    profiles = {
      default = {
        fingerprint = {
          eDP-1 = fp_eDP-1;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
          HDMI-1.enable = false;
        };
      };
      home = {
        fingerprint = {
          eDP-1 = fp_eDP-1;
          HDMI-1 = fp_HDMI-1;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
          HDMI-1 = {
            enable = true;
            position = "1920x0";
            mode = "1920x1080";
          };
        };
    
      };
    };
  };
}
