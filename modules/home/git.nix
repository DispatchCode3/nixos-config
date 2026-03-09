{ config, lib, pkgs, ... }:

let
  userName = config.home.username;
  extraPath = ../../users + "/${userName}/dotfiles/git/extra.gitconfig";
  extraExists = builtins.pathExists extraPath;
in
{
  programs.git = {
    enable = true;
    package = pkgs.git;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "vim";
    };

    includes = lib.optionals extraExists [
      { path = extraPath; }
    ];
  };
}
