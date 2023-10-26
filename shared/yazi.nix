{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    zoxide
    ffmpegthumbnailer
    poppler_utils
  ];
  programs.yazi = {
    enable = true;
  };
}
