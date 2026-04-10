{
  config,
  hostName,
  username,
  ...
}:
{
  sops.age.keyFile = "/persist/var/lib/sops-nix/key.txt";

  sops.secrets.user_password = {
    neededForUsers = true;
    sopsFile = ../../secrets/common.yaml;
  };

  users.users.${username}.hashedPasswordFile = config.sops.secrets.user_password.path;
}
