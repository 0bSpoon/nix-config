# ホスト追加ガイド

このリポジトリでは、ホスト追加は `flake.nix` の inventory を更新し、必要な host module と profile を揃える流れで行う。

## 追加先の考え方

- machine 固有情報は `hosts/<name>/`
- 再利用可能な設定は `modules/`
- 用途ごとの組み合わせは `profiles/`
- inventory 登録は `flake.nix`

`hosts/<name>/default.nix` には machine 固有情報だけを置き、desktop / server / personal の選択は inventory 側で行う。

## 手順

### 1. host ディレクトリを作る

例: `example-host` を追加する場合

```text
hosts/
  example-host/
    default.nix
    hardware-configuration.nix
    disk-config.nix
```

最低限 `default.nix` を用意し、必要に応じて `hardware-configuration.nix` や `disk-config.nix` を追加する。

`hosts/example-host/default.nix` の例:

```nix
{ lib, ... }:
{
  imports =
    lib.optionals (builtins.pathExists ./hardware-configuration.nix) [ ./hardware-configuration.nix ]
    ++ lib.optionals (builtins.pathExists ./disk-config.nix) [ ./disk-config.nix ];

  networking.hostName = "example-host";
  system.stateVersion = "25.11";
}
```

## 2. inventory に登録する

`flake.nix` の `inventory` attrset に追加する。

```nix
example-host = {
  kind = "nixos";
  system = "x86_64-linux";
  username = "bspoon";
  homeDirectory = "/home/bspoon";
  hostModule = ./hosts/example-host;
  userModule = ./users/bspoon/home.nix;
  nixosProfile = ./profiles/nixos/server.nix;
  homeProfile = ./profiles/home/server-admin.nix;
};
```

主な項目:

- `kind`: 現状は `nixos` を使用
- `system`: `x86_64-linux` などの target system
- `hostModule`: `hosts/<name>` を指す
- `nixosProfile`: system 側 profile
- `homeProfile`: Home Manager 側 profile

## 3. 必要な secret を追加する

- 全ホスト共通なら `secrets/common.yaml`
- そのホスト固有なら `secrets/hosts/<host>.yaml`
- ユーザー固有なら `secrets/users/<user>.yaml`

詳細は `manage-secrets.md` を参照。

## 4. 評価する

```bash
nix flake show "path:$PWD" --all-systems
nix eval "path:$PWD#nixosConfigurations.example-host.config.networking.hostName" --raw
```

## 5. 適用する

```bash
sudo nixos-rebuild switch --flake .#example-host
```

## 注意点

- profile の選択を `hosts/<name>/default.nix` に書かない
- 共通化したい設定は `modules/` か `profiles/` に寄せる
- host 固有 override が増えた場合も、まず module 化できないか確認する
