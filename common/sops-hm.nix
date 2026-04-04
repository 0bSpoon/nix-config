# home-manager sops 設定
# 新しいユーザー共通シークレットは sops.secrets に追記する
# ホスト固有シークレットは hosts/<name>/sops-hm.nix に追記する
{ config, ... }:
{
  # ユーザー管理の age キー（KeePass 等にバックアップ）
  # sops CLI と共通: $XDG_CONFIG_HOME/sops/age/keys.txt
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

  # ユーザー共通シークレット
  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.secrets = {
    # GitHub SSH 秘密鍵
    # 展開先: ~/.ssh/github_key (home-manager activation 後に存在)
    github_ssh_private_key = {
      mode = "0600";
      path = "${config.home.homeDirectory}/.ssh/github_key";
    };
  };
}
