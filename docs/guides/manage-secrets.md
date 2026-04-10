# シークレット管理ガイド

このリポジトリでは secret を `common`、`host`、`user` の 3 単位で分ける。

## 配置ルール

- `secrets/common.yaml`: 全環境で共有する secret
- `secrets/hosts/<host>.yaml`: ホスト固有 secret
- `secrets/users/<user>.yaml`: ユーザー固有 secret

module 側では `sops.secrets.<name>.sopsFile` を明示し、builder で secrets を混ぜない。

## 現在の参照例

system 側:

```nix
sops.secrets.user_password = {
  neededForUsers = true;
  sopsFile = ../../secrets/common.yaml;
};
```

Home Manager 側:

```nix
sops.secrets.github_ssh_private_key = {
  mode = "0600";
  path = "${config.home.homeDirectory}/.ssh/github_key";
  sopsFile = ../../secrets/users/${username}.yaml;
};
```

## 新しい secret を追加する手順

### 1. 保存先を決める

- 複数ホスト共通なら `common.yaml`
- 特定ホストだけなら `hosts/<host>.yaml`
- 特定ユーザーだけなら `users/<user>.yaml`

## 2. sops で編集する

例: user secret を編集する場合

```bash
nix shell nixpkgs#sops -c sops secrets/users/bspoon.yaml
```

例: host secret を新規作成する場合

```bash
mkdir -p secrets/hosts
nix shell nixpkgs#sops -c sops secrets/hosts/example-host.yaml
```

`.sops.yaml` の `creation_rules` に一致するパスであれば、自動で適切な鍵が使われる。

## 3. module から参照する

system secret の例:

```nix
sops.secrets.server_api_key = {
  sopsFile = ../../secrets/hosts/${hostName}.yaml;
};
```

user secret の例:

```nix
sops.secrets.my_token = {
  path = "${config.home.homeDirectory}/.config/my-app/token";
  mode = "0600";
  sopsFile = ../../secrets/users/${username}.yaml;
};
```

## 4. 評価する

```bash
nix flake show "path:$PWD" --all-systems
```

## 運用メモ

- system 用 age key は `/persist/var/lib/sops-nix/key.txt` を前提にしている
- user 用 age key は `${config.xdg.configHome}/sops/age/keys.txt` を前提にしている
- 既存 secret の置き場に迷ったら、OS 起動前に必要か、ログイン後だけ必要かで判断する
