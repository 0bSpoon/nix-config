# nixpkgs のパッケージバグに対する一時的なワークアラウンド集
#
# 使い方:
#   - バグが修正されたら該当エントリのコメントごと削除する
#   - overlays リストが空になっても問題なし (このファイルは恒久的なインフラ)
#   - 新しいワークアラウドを追加する場合は mkPinnedPkgs で別コミットを参照する
#
# 新しいワークアラウドの追加例:
#   (final: prev:
#     let pkgs-pinned = mkPinnedPkgs { rev = "abc123..."; sha256 = "0xxx..."; } prev.stdenv.hostPlatform.system;
#     in { some-package = pkgs-pinned.some-package; })
#
# sha256 の取得方法:
#   1. 古い flake.lock から narHash を確認: git show HEAD:flake.lock | grep -A5 '"nixpkgs"'
#   2. nix hash convert --hash-algo sha256 --to base32 "<narHash>"

{ ... }:

let
  # 特定の nixpkgs コミットから pkgs セットを生成するヘルパー
  # rev: nixpkgs の git コミットハッシュ
  # sha256: nix hash convert --hash-algo sha256 --to base32 で変換した narHash
  mkPinnedPkgs =
    { rev, sha256 }:
    system:
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
        inherit sha256;
      })
      {
        inherit system;
        config.allowUnfree = true;
      };
in
{
  nixpkgs.overlays = [

    # [workaround] vscode-extensions.anthropic.claude-code 2.1.92 の vsix hash が nixpkgs 側で誤っている
    # 症状: hash mismatch in fixed-output derivation anthropic-claude-code.vsix
    # 削除条件: nixpkgs が claude-code vscode 拡張の hash を修正したとき
    # 固定コミット: nixpkgs 6c9a78c (vscode-extensions.anthropic.claude-code が正しくビルドできる版)
    (
      final: prev:
      let
        pkgs-pinned = mkPinnedPkgs {
          rev = "6c9a78c09ff4d6c21d0319114873508a6ec01655";
          sha256 = "0szij1c0cl4xvjhzb0cwvskkl54dyw11skb9hgmnhamcmmsm6bji";
        } prev.stdenv.hostPlatform.system;
      in
      {
        vscode-extensions = prev.vscode-extensions // {
          anthropic = (prev.vscode-extensions.anthropic or { }) // {
            claude-code = pkgs-pinned.vscode-extensions.anthropic.claude-code;
          };
        };
      }
    )

  ];
}
