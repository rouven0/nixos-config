{config, pkgs, ...}:
{
  xsession.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks
      vicious
    ];
  };
  home.file.".config/awesome/rc.lua".source = ./rc.lua;
}
