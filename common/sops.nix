# NixOS sops 共通設定
# システム起動時に必要なシークレット（ログイン前に展開される）
# ホスト固有シークレットは hosts/<name>/sops.nix に追加する
{ config, ... }:
{
  # ユーザー管理の age キー（home-manager sops と同じキーファイルを共有）
  sops.age.keyFile = "/home/bspoon/.config/sops/age/keys.txt";

  sops.defaultSopsFile = ../secrets/secrets.yaml;

  sops.secrets = {
    # bspoon ユーザーのハッシュ済みパスワード
    user_password.neededForUsers = true;
  };

  users.users.bspoon.hashedPasswordFile = config.sops.secrets.user_password.path;
}
