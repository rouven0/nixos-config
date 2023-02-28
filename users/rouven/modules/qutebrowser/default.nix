{ config, ... }:
{
  programs.qutebrowser = {
    #enable = true; it's broken at the momant
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://nixos.wiki/index.php?search={}";
      wp = "https://en.wikipedia.org/wiki/Special:Search?search={}";
      y = "http://localhost:8090/yacysearch.html?query={}";
      yt = "https://www.youtube.com/results?search_query={}";
      g = "https://www.google.com/search?hl=en&q={}";
    };
    quickmarks = {
      nix-search = "https://search.nixos.org/options?";
      home-search = "https://mipmip.github.io/home-manager-option-search/";
      jexam = "https://jexam.inf.tu-dresden.de";
      opal = "https://bildungsportal.sachsen.de/opal/home?2";
      fruitbasket = "https://github.com/fsr/fruitbasket";
    };
    keyBindings = {
      normal = {
        "<Ctrl-m>" = "hint links spawn mpv {hint-url}";
      };
    };
    settings = {
      colors.webpage = {
        darkmode.enabled = false;
        preferred_color_scheme = "dark";
      };
      content.blocking = {
        enabled = true;
        method = "both";
      };
      statusbar.show = "in-mode";
      tabs.show = "switching";
    };
  };
}
