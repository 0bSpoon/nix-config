# CLAUDE.md

## リポジトリ概要

NixOS のマルチホスト構成管理リポジトリ。Flake ベース。

## 構成

- `flake.nix` - エントリポイント
- `common/` - 全ホスト共通設定 (system.nix, home.nix)
- `hosts/` - ホスト固有設定 (targon, vm-nixos-test, zaun)
- `docs/knowledge.md` - 運用で得られたナレッジベース
- `COMMANDS.md` - NixOS コマンドリファレンス

## コミットメッセージ規約

日本語で記述。プレフィックスは `add:`, `fix:`, `update:`, `refactor:`, `chore:` を使用。

## ナレッジ

トラブルシュートや運用上の知見は `docs/knowledge.md` に蓄積されている。
設定変更やトラブル対応の際は参照すること。
