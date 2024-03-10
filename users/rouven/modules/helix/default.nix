{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gdb
    lldb
    rust-analyzer
    nil
    nixpkgs-fmt
    typst-lsp
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
      language-server.nil = {
        command = "nil";
        config = { nil.formatting.command = [ "nixpkgs-fmt" ]; };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nil" ];
        }
      ];
    };

    settings = {
      theme = "dracula";
      editor = {
        color-modes = true;
        line-number = "relative";
        cursor-shape.insert = "bar";
        completion-trigger-len = 0;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };
  };
}
