# nix-config

`flake-parts` を基盤に、NixOS ホストと Home Manager 環境をまとめて管理するリポジトリ。

現在は `targon`、`zaun`、`vm-nixos-test` の NixOS 構成を管理しつつ、将来的な WSL / Android 追加を見据えた構造にしている。

## 概要

- `flake.nix` は inventory と flake 出力の入口
- `lib/` は host / user 環境を組み立てる builder 関数
- `modules/` は再利用可能な最小単位の設定
- `profiles/` は module を用途別に束ねた構成
- `hosts/` はマシン固有設定
- `users/` はユーザー固有設定
- `secrets/` は common / host / user 単位の secret

## ディレクトリ構造

```text
.
├── flake.nix
├── flake.lock
├── lib/
│   ├── mk-android.nix
│   ├── mk-home.nix
│   └── mk-nixos-host.nix
├── modules/
│   ├── flake-parts/
│   ├── home/
│   └── nixos/
├── profiles/
│   ├── home/
│   └── nixos/
├── users/
│   └── bspoon/
├── hosts/
│   ├── targon/
│   ├── vm-nixos-test/
│   └── zaun/
├── overlays/
├── secrets/
│   ├── common.yaml
│   ├── hosts/
│   └── users/
└── docs/
    ├── guides/
    ├── knowledge.md
    ├── commands.md
    └── repository-architecture.md
```

## 設計方針

- `flake-parts` の `perSystem` には formatter や dev shell を置く
- `flake` には inventory から生成される `nixosConfigurations` と `homeConfigurations` を置く
- host 固有情報は `hosts/<name>/default.nix` に閉じ込める
- desktop / server / personal などの役割は `profiles/` と `modules/` で表現する
- user 固有設定は `users/<name>/` に寄せ、複数 platform で再利用しやすくする

## よく使う場所

- host を追加する: `docs/guides/add-host.md`
- secret を追加する: `docs/guides/manage-secrets.md`
- profile を追加・組み立てる: `docs/guides/build-profiles.md`
- 運用上の知見を確認する: `docs/knowledge.md`
- よく使うコマンドを見る: `docs/commands.md`

## 基本コマンド

```bash
# flake 出力の評価
nix flake show "path:$PWD" --all-systems

# ホスト設定の適用
sudo nixos-rebuild switch --flake .#targon

# Home Manager 構成の評価
nix eval ".#homeConfigurations.\"bspoon@targon\".config.home.username" --raw
```

`git` 管理下の新規ファイルをまだ add していない段階では、`nix flake show .` ではなく `nix flake show "path:$PWD"` を使うと作業中の未追跡ファイルも含めて評価できる。
