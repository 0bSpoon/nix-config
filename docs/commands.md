# NixOS クイックリファレンス

このリポジトリ (`nix-config`) で使うコマンド集。

## 設定の適用

```bash
# targon に適用
sudo nixos-rebuild switch --flake .#targon

# vm-nixos-test に適用
sudo nixos-rebuild switch --flake .#vm-nixos-test

# 適用前にビルドだけ試す（ドライラン）
nixos-rebuild dry-build --flake .#targon

# ビルドして次回起動時に適用（即時切替しない）
sudo nixos-rebuild boot --flake .#targon

# テスト適用（再起動で元に戻る）
sudo nixos-rebuild test --flake .#targon
```

## Flake の更新

```bash
# すべての inputs を更新
nix flake update

# 特定の input だけ更新
nix flake update nixpkgs
nix flake update home-manager

# flake.lock の内容を確認
nix flake metadata
```

## ガベージコレクション

```bash
# 古い世代を削除（30日以上前）
sudo nix-collect-garbage --delete-older-than 30d

# ユーザープロファイルのガベージコレクション
nix-collect-garbage --delete-older-than 30d

# すべての古い世代を削除
sudo nix-collect-garbage -d
```

## 起動プロファイルの整理

```bash
# システムプロファイルの世代一覧
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 古い世代を削除（30日以上前）
sudo nix-env --delete-generations +30d --profile /nix/var/nix/profiles/system

# 特定の世代を削除
sudo nix-env --delete-generations 1 2 3 --profile /nix/var/nix/profiles/system

# ブートローダーのエントリを更新（世代削除後に実行）
sudo /run/current-system/bin/switch-to-configuration boot
```

## ストア管理

```bash
# ストアの使用量を確認
nix store info

# ストアの最適化（重複排除）
sudo nix store optimise

# 特定パッケージのストアパスを確認
nix path-info --closure-size /run/current-system
```

## デバッグ・調査

```bash
# 現在のシステム世代を確認
nixos-version

# flake の評価チェック（構文エラーの検出）
nix flake check

# 特定パッケージが利用可能か検索
nix search nixpkgs パッケージ名

# NixOS オプションの値を確認
nixos-option fonts.fontconfig.hinting.style

# 設定の差分を確認（世代間）
nvd diff /nix/var/nix/profiles/system-*-link
```

## Home Manager

```bash
# home-manager の世代一覧
home-manager generations

# home-manager のガベージコレクション
home-manager expire-generations "-30 days"
```
