{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.obsidian ];

  # home.activation.cloneObsidianVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   if [ ! -d "$HOME/Documents/vault/.git" ]; then
  #     export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh"
  #     run ${pkgs.git}/bin/git clone git@github.com:0bSpoon/obsidian-vault.git "$HOME/Documents/vault"
  #   fi
  # '';
}
