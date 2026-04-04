{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.obsidian ];

  systemd.user.services.clone-obsidian-vault = {
    Unit = {
      Description = "Clone Obsidian vault on first login";
      After = [ "sops-nix.service" ];
      Requires = [ "sops-nix.service" ];
      ConditionPathExists = [
        "%h/.ssh/github_key"
        "!%h/Documents/vault/.git"
      ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "clone-obsidian-vault" ''
          set -eu

          mkdir -p "$HOME/Documents"

          export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -F /dev/null -i $HOME/.ssh/github_key -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
          exec ${pkgs.git}/bin/git clone git@github.com:0bSpoon/obsidian-vault.git "$HOME/Documents/vault"
        ''
      );
    };

    Install.WantedBy = [ "default.target" ];
  };
}
