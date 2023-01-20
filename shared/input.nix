{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xmodmap
  ];
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak-alt-intl";

  # Port this to wayland TODO. doesn't even work with gdm lmao
  #services.xserver.displayManager.setupCommands =
  #"${pkgs.xorg.xmodmap}/bin/xmodmap ${pkgs.writeText  "xkb-layout" ''
  #keycode 108 = Mode_switch
  #keycode  94 = Shift_L NoSymbol Shift_L
  #keysym a = a A adiaeresis Adiaeresis
  #keysym o = o O odiaeresis Odiaeresis
  #keysym u = u U udiaeresis Udiaeresis
  #keysym s = s S ssharp
  #''}";
}
