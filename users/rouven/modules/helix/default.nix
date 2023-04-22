{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lldb
    rust-analyzer
    nil
    (python3.withPackages (ps: with ps; [
      pyls-isort
      pylsp-mypy
      python-lsp-black
      python-lsp-server

      # pylsp optional dependencies
      types-requests
      flake8
      mccabe
      pycodestyle
      pydocstyle
      pyflakes
      pylint
    ]))
    clang-tools
  ];
  programs.helix = {
    enable = true;
    themes.dracula-transparent = {
      inherits = "dracula";
      # hacky way to get the background transparent
      "ui.background" = "{}";
    };
    settings = {
      theme = "dracula-transparent";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };

    };
  };
}
