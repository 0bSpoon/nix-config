# プロファイル構築ガイド

profile は module を人が使いやすい単位に束ねるための層。

このリポジトリでは次の責務で分ける。

- `modules/`: 小さく再利用可能な設定
- `profiles/`: 用途別の組み合わせ
- `hosts/`: machine 固有情報
- `users/`: ユーザー固有設定

## 既存 profile の見方

- `profiles/nixos/desktop.nix`: desktop 共通の system profile
- `profiles/nixos/laptop.nix`: desktop に laptop 差分を足した profile
- `profiles/nixos/server.nix`: headless 寄りの system profile
- `profiles/home/personal-desktop.nix`: 個人 GUI + 開発環境
- `profiles/home/server-admin.nix`: サーバー管理向け user 環境

## profile を作る基準

新しい profile を作るのは、再利用したい組み合わせが明確なときだけにする。

作らない方がよい例:

- 1 台の host にしか使わない単発設定
- module を 1 つ import するだけの薄すぎる profile

作る価値がある例:

- 複数の desktop で共有したい GUI 構成
- work / personal で切り替えたい user 環境
- server 群で共有したい ssh / backup / monitoring 構成

## 新しい profile を追加する手順

### 1. 先に module を分ける

例:

- `modules/home/work.nix`
- `modules/nixos/server.nix`

module には再利用可能な設定だけを入れる。

## 2. profile で束ねる

例: `profiles/home/work-dev.nix`

```nix
{ ... }:
{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/dev.nix
    ../../modules/home/work.nix
  ];
}
```

例: `profiles/nixos/server.nix`

```nix
{ ... }:
{
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/sops.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/server.nix
  ];
}
```

## 3. inventory で選ぶ

profile の選択は `flake.nix` の inventory で行う。

```nix
zaun = {
  kind = "nixos";
  system = "x86_64-linux";
  username = "bspoon";
  homeDirectory = "/home/bspoon";
  hostModule = ./hosts/zaun;
  userModule = ./users/bspoon/home.nix;
  nixosProfile = ./profiles/nixos/server.nix;
  homeProfile = ./profiles/home/server-admin.nix;
};
```

## 判断基準

- host 固有なら `hosts/`
- 個人情報や identity なら `users/`
- 役割や用途の差なら `modules/` / `profiles/`

迷ったときは、他の host でも同じまま使えるかで切り分ける。
