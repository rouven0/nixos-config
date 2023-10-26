{ pkgs, nix-colors, ... }:
{

  home.packages = with pkgs; [ libsForQt5.qtstyleplugin-kvantum ];
  colorScheme = nix-colors.colorSchemes.dracula;

  # theme hardcoded to dracula, too lazy to make all this base16
  systemd.user.sessionVariables.GTK_THEME = "Dracula";
  qt = {
    enable = true;
    style = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };
  xdg.configFile = {
    "Kvantum/Dracula/Dracula.kvconfig".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula/Dracula.kvconfig";
    "Kvantum/Dracula/Dracula.svg".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula/Dracula.svg";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Dracula";
  };
}
