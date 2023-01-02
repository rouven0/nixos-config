{ config, ... }:
{
  # This is a fix for zsh in the home manager
  # If you only enable it in home manager, some important files for completion are missing
  programs.zsh.enable = true;
}
