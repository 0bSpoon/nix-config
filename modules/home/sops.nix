{ config, username, ... }:
{
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

  sops.secrets.github_ssh_private_key = {
    mode = "0600";
    path = "${config.home.homeDirectory}/.ssh/github_key";
    sopsFile = ../../secrets/users/${username}.yaml;
  };
}
