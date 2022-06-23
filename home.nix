{ pkgs, lib, ... }:

let
  local = import ./local_auto.nix;
  username = local.username;
in
{
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  programs.home-manager.enable = true;

  programs.autojump.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    nixpkgs-fmt

    nodejs

    pstree
    rsync
    sqlite-interactive
    tree
  ];
}
