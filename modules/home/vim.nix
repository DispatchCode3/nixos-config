{ config, lib, ... }:

let
  userName = config.home.username;
  extraPath = ../../users + "/${userName}/dotfiles/vim/extra.vim";
  extraExists = builtins.pathExists extraPath;
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    extraConfig =
      ''
        set nocompatible
        syntax on
        filetype plugin indent on

        set number
        set expandtab
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set autoindent
        set smartindent
        set hidden
        set backspace=indent,eol,start
        set ignorecase
        set smartcase
      ''
      + lib.optionalString extraExists ("\n" + builtins.readFile extraPath);
  };
}
