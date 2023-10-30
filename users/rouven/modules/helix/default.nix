{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gdb
    lldb
    rust-analyzer
    rnix-lsp
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
    nodePackages.typescript-language-server
  ];
  programs.helix = {
    enable = true;

    languages = {
      language-server.rnix-lsp = {
        command = "rnix-lsp";
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "rnix-lsp" ];
        }
      ];
    };

    settings = {
      theme = "dracula";
      editor = {
        color-modes = true;
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
