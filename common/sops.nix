# NixOS sops 共通設定
# 新しいユーザー共通シークレットは sops.secrets に追記する
# ホスト固有シークレットは hosts/<name>/sops.nix に追記する
{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # ユーザー管理の age キー（KeePass 等にバックアップ）
  # 配置先: /etc/sops/age/keys.txt (root:root, 0600)
  sops.age.keyFile = "/etc/sops/age/keys.txt";

  # ユーザー共通シークレット（github.com/0bSpoon/nix-secrets）
  sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/common/user-bspoon.yaml";

  sops.secrets = {
    # GitHub SSH 秘密鍵
    # 展開先: /run/secrets/github_ssh_private_key (tmpfs, 起動後のみ存在)
    github_ssh_private_key = {
      owner = "bspoon";
      mode = "0600";
    };

    # 新しいシークレット追加例:
    # some_api_key = {
    #   owner = "bspoon";
    #   mode = "0400";
    # };
  };
}
