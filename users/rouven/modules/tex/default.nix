{ pkgs, ... }:
{
  home.packages = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-full;
    })
  ];
}
