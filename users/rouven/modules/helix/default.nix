{ pkgs, helix, ... }:
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
  ];
  programs.helix = {
    enable = true;
    # pull helix from the flake to fix random coredumps
    package = helix.packages.x86_64-linux.default;
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
