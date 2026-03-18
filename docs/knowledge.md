# ナレッジベース

このリポジトリの運用で得られた知見をまとめる。

## Home Manager で VSCode の拡張機能・設定を管理する際の注意

Home Manager の `programs.vscode` で拡張機能や `userSettings` を宣言的に管理する場合、
既に VSCode が自前で作成したファイルが存在すると、Nix 管理のシンボリックリンクが正しく適用されない。

### 症状

- `userSettings` で設定した内容が反映されない
- 宣言した拡張機能が VSCode 上で認識されない

### 原因

- `~/.config/Code/User/settings.json` が通常ファイルとして既に存在し、Home Manager がシンボリックリンクで上書きできない
- `~/.vscode/extensions/` 内に VSCode が自前でインストールした拡張機能ディレクトリが残っている
- `~/.vscode/extensions/.obsolete` に古いバージョンが記録され、Nix 管理の拡張機能が無効扱いになる

### 対処法

既存ファイルを削除してからリビルドする。

```bash
# settings.json の既存ファイルを削除
rm ~/.config/Code/User/settings.json

# VSCode が自前でインストールした拡張機能と管理ファイルを削除
rm -rf ~/.vscode/extensions/*-linux-x64  # VSCode がインストールしたディレクトリ
rm -f ~/.vscode/extensions/.obsolete
rm -f ~/.vscode/extensions/extensions.json

# リビルド
sudo nixos-rebuild switch --flake ~/src/nix-config#<host>
```

削除後にリビルド（または再起動）すると、Home Manager がシンボリックリンクを作成し、Nix で宣言した設定・拡張機能が正しく反映される。
