# 将来拡張を見据えたリポジトリ設計

このドキュメントは、この `nix-config` リポジトリをホームラボ全体へ拡張する前提で再設計するための方針をまとめたもの。

対象とする管理対象:

- 個人用メイン機 (`targon` のような NixOS デスクトップ)
- サブ機のラップトップ
- ホームラボ内のサーバー
- 仕事用 Windows 上の WSL 環境
- Android 端末 (`nix-on-droid` 想定)

## 前提

この設計では `flake-parts` の導入を前提とする。

理由:

- `flake.nix` を inventory と出力定義の場所として整理しやすい
- `perSystem` と `flake` を分けることで、開発用出力と host 出力の責務を分離できる
- `nixosConfigurations`, `homeConfigurations`, 将来の `nixOnDroidConfigurations` を同じ構造で並べやすい
- ホスト数や platform 数が増えたときの重複を抑えやすい

この repo では、`flake-parts` は optional な整理ツールではなく、将来構成を支える基盤として扱う。

## 背景

現状の構造は、少数の NixOS ホストを管理するには十分に分かりやすい。

一方で、対象が増えると次の問題が出やすい。

- `common/system.nix` に desktop 向け設定が多く、server や WSL に流用しにくい
- `common/home.nix` に personal GUI 設定が多く、work 用や headless 環境に流用しにくい
- `flake.nix` で host ごとの定義が増えるほど重複しやすい
- NixOS 以外の対象 (`WSL`, `Android`) を構造として表現しづらい
- system secrets と user secrets の責務が今後の server 運用では分かりにくくなりやすい

このため、今後は「共通設定を増やす」のではなく、「責務ごとに分離して `flake-parts` 上で組み立てる」構造へ改める。

## 設計目標

- NixOS desktop / laptop / server を同じ原則で管理できる
- WSL と Android のような非 NixOS 環境も同じ repo で扱える
- user 環境を host から切り離して再利用できる
- personal / work の差分を module と profile で切り替えられる
- host が増えても `flake.nix` の重複を最小限に抑えられる
- secrets を `common`, `host`, `user` 単位で整理できる
- `flake-parts` の `perSystem` と `flake` に責務を素直に分配できる

## 基本方針

この repo は次の 4 軸で構成する。

- `platform`: `nixos`, `nixos-wsl`, `home-manager`, `nix-on-droid`
- `role`: `desktop`, `laptop`, `server`, `headless`, `dev`, `work`, `personal`
- `host`: `targon`, `zaun`, `work-wsl`, `phone` などの実体
- `user`: `bspoon`

重要なのは、これらを 1 つの `common/*.nix` に押し込まず、別々の責務として組み合わせること。

## `flake-parts` における責務分離

`flake-parts` 導入後の `flake.nix` では、責務を次の 2 層に分ける。

### `perSystem`

各 architecture / platform ごとに共通な開発用出力を置く。

例:

- `formatter`
- `devShells`
- `checks`
- `packages`
- `apps`

ここには host 固有情報を持ち込まない。

### `flake`

この repo が最終的に管理する host / user 環境そのものを置く。

例:

- `nixosConfigurations`
- `homeConfigurations`
- 将来の `nixOnDroidConfigurations`

ここでは inventory と builder 関数を使い、host ごとの出力を生成する。

## モジュール分割方針

### 1. base modules

どの host / user でも比較的再利用しやすい、最小限の構成を置く。

例:

- Nix の基本設定
- locale / timezone
- SSH の基本方針
- 最低限の shell / git / editor

### 2. role modules

使い方の種類ごとにまとめる。

例:

- `desktop`: greetd, niri, audio, fonts, printing, GUI 関連
- `laptop`: battery, brightness, suspend, wireless 前提の調整
- `server`: headless, monitoring, backup, SSH hardened
- `dev`: 開発ツール群
- `work`: 仕事用 Git/SSH/ブラウザ/証明書/proxy
- `personal`: Obsidian, Spotify, 個人用秘密鍵や同期設定

### 3. host modules

マシン固有の情報だけを置く。

例:

- hostname
- hardware-configuration
- disk layout
- GPU
- dual boot
- NIC や mount の個別事情

host file に personal / desktop のような役割まで持たせない。

### 4. user modules

ユーザー本人に結びつく設定を独立させる。

例:

- Git identity
- SSH 設定
- shell alias
- editor 設定
- user secrets の参照

これにより、NixOS host の中でも、WSL でも、Android でも再利用しやすくなる。

## 目標ディレクトリ構成

```text
flake.nix
flake.lock

lib/
  mk-nixos-host.nix
  mk-home.nix
  mk-android.nix

overlays/
  workarounds.nix

modules/
  nixos/
    base.nix
    ssh.nix
    desktop.nix
    laptop.nix
    server.nix
    audio.nix
    fonts.nix
    wsl.nix
    sops.nix
  home/
    base.nix
    dev.nix
    desktop.nix
    work.nix
    personal.nix
    sops.nix
    gui/
      vscode.nix
      ghostty.nix
      obsidian.nix
      assets/
        niri/
          config.kdl
    tui/
      tmux.nix
      cli-tools.nix
  flake-parts/
    per-system.nix
    hosts.nix
    homes.nix
    android.nix

profiles/
  nixos/
    desktop.nix
    laptop.nix
    server.nix
  home/
    personal-desktop.nix
    work-dev.nix
    server-admin.nix
  android/
    personal-mobile.nix

users/
  bspoon/
    home.nix
    git.nix
    ssh.nix

hosts/
  targon/
    default.nix
    hardware-configuration.nix
    disk-config.nix
    gpu.nix
    dualboot.nix
  zaun/
    default.nix
    hardware-configuration.nix
    disk-config.nix
  vm-nixos-test/
    default.nix
    disk-config.nix
  work-wsl/
    default.nix
  phone/
    default.nix

secrets/
  common.yaml
  hosts/
    targon.yaml
    zaun.yaml
  users/
    bspoon.yaml

docs/
  repository-architecture.md
```

`docs/` は補助文書の置き場として現状位置を維持し、Nix config 自体の評価構造には組み込まない。

## `mk-nixos-host.nix` と `mk-home.nix` の役割

### `mk-nixos-host.nix`

1 台の NixOS ホスト全体を組み立てる関数。

責務:

- `nixpkgs.lib.nixosSystem` を呼ぶ
- host 固有 module を束ねる
- role/profile module を束ねる
- Home Manager を NixOS module として差し込む
- system secrets と specialArgs を渡す

向いている対象:

- NixOS desktop
- NixOS laptop
- NixOS server
- `NixOS-WSL` を採用する場合の WSL

### `mk-home.nix`

1 ユーザー分の Home Manager 環境を組み立てる関数。

責務:

- `home-manager.lib.homeManagerConfiguration` を呼ぶ
- user module と profile module を束ねる
- user secrets と extraSpecialArgs を渡す

向いている対象:

- Ubuntu/Debian ベースの WSL
- 既存 Linux 上の user 環境のみ管理したい場合
- host OS は別管理だが dotfiles / dev env だけ共有したい場合

### 分ける理由

この repo が管理する対象は全部 NixOS とは限らない。

- NixOS machine は OS 全体を宣言したい
- WSL は user 環境だけ共有したい可能性がある
- Android は `nix-on-droid` 用の組み立てが必要になる

このため、OS 全体の組み立てと user 環境の組み立てを分離しておく。

## Profile の考え方

profile は、module を人が使いやすい単位に束ねたものとして扱う。

例:

- `profiles/nixos/desktop.nix`
  NixOS desktop に必要な module を集約
- `profiles/nixos/server.nix`
  headless server 向け module を集約
- `profiles/home/personal-desktop.nix`
  個人用 GUI + dev 環境を集約
- `profiles/home/work-dev.nix`
  work 用の dev 環境を集約
- `profiles/android/personal-mobile.nix`
  Android 用の mobile profile を集約

profile は「再利用しやすい組み合わせ」を提供し、profile の選択は inventory だけで行う。
host file は machine 固有情報だけを持つ薄いファイルにする。

## Host file の責務

`hosts/<name>/default.nix` は、できるだけ薄く保つ。

期待する内容:

- hostname
- hardware import
- disk import
- その host にだけ必要な local override

期待しない内容:

- desktop 一式の定義
- personal/work の切り替え
- 開発ツール一式の定義
- profile の選択

それらは inventory または profile 側に寄せる。

## `flake.nix` の方針

`flake.nix` は `flake-parts.lib.mkFlake` を入口にして、inventory と builder 関数で各出力を構築する。

大きな方針:

- `systems` はこの repo が開発用に意識する対象 architecture を定義する
- `perSystem` は formatter, devShell, checks だけに集中させる
- `flake` は inventory から `nixosConfigurations`, `homeConfigurations`, `nixOnDroidConfigurations` を生成する
- host 追加は inventory の attrset を更新するのを標準手順とする

inventory は、この repo が管理する対象の唯一の入口とする。

- profile の選択は inventory に一本化する
- `hosts/<name>/default.nix` は profile を選ばない
- builder は inventory を入力として host / user / platform ごとの出力を組み立てる

例:

```nix
hosts = {
  targon = {
    kind = "nixos";
    system = "x86_64-linux";
    username = "bspoon";
    homeDirectory = "/home/bspoon";
    nixosProfile = ./profiles/nixos/laptop.nix;
    homeProfile = ./profiles/home/personal-desktop.nix;
    hostModule = ./hosts/targon;
  };

  zaun = {
    kind = "nixos";
    system = "x86_64-linux";
    username = "bspoon";
    homeDirectory = "/home/bspoon";
    nixosProfile = ./profiles/nixos/server.nix;
    homeProfile = ./profiles/home/server-admin.nix;
    hostModule = ./hosts/zaun;
  };

  work-wsl = {
    kind = "home-manager";
    system = "x86_64-linux";
    username = "bspoon";
    homeDirectory = "/home/bspoon";
    homeProfile = ./profiles/home/work-dev.nix;
  };

  phone = {
    kind = "android";
    system = "aarch64-linux";
    username = "bspoon";
    homeDirectory = "/data/data/com.termux.nix/files/home";
    androidProfile = ./profiles/android/personal-mobile.nix;
  };
};
```

これにより、`flake.nix` は「何を管理するか」を表現する場所になり、host ごとの詳細は別ファイルへ追い出せる。

## secrets 設計

secrets は次の単位で分ける。

- `secrets/common.yaml`: 全環境で共通のもの
- `secrets/hosts/<host>.yaml`: host 固有のもの
- `secrets/users/<user>.yaml`: user 固有のもの

各 secret は `sops.secrets.<name>.sopsFile` で参照元ファイルを明示する。
builder が secrets ファイルを 1 つに統合することはしない。
module 側が必要な secret とその `sopsFile` を宣言し、builder は `hostName`, `username` など参照に必要な引数だけを渡す。

### system secrets

system 起動時や login 前に必要なものは NixOS 側で扱う。

対象例:

- user password hash
- サーバー用認証情報
- host 固有の API key

例:

```nix
sops.secrets.user_password = {
  neededForUsers = true;
  sopsFile = ../../secrets/common.yaml;
};

sops.secrets.server_api_key = {
  sopsFile = ../../secrets/hosts/${hostName}.yaml;
};
```

system 用の age key は、user home 配下ではなく host 永続領域に置く。

候補:

- `/var/lib/sops-nix/key.txt`
- `/persist/var/lib/sops-nix/key.txt`

### user secrets

login 後の user session で使うものは Home Manager 側で扱う。

対象例:

- GitHub SSH private key
- 個人用 token
- user app 用 secret

例:

```nix
sops.secrets.github_ssh_private_key = {
  path = "${config.home.homeDirectory}/.ssh/github_key";
  mode = "0600";
  sopsFile = ../../secrets/users/${username}.yaml;
};
```

これにより、「OS が必要とする秘密情報」と「ユーザー活動で必要な秘密情報」を分離できる。
また、共通 secret と host/user 固有 secret が混ざっても、どのファイルを参照しているかを secret ごとに追跡しやすい。

## Platform ごとの扱い

### NixOS desktop / laptop

- `mk-nixos-host.nix` を使用
- `profiles/nixos/desktop.nix` または `profiles/nixos/laptop.nix`
- `profiles/home/personal-desktop.nix`

### NixOS server

- `mk-nixos-host.nix` を使用
- `profiles/nixos/server.nix`
- 必要なら `profiles/home/server-admin.nix`

### WSL

2 パターンを許容する。

1. `NixOS-WSL` を使う場合
   `mk-nixos-host.nix` で管理する
2. Ubuntu/Debian 上で Home Manager だけ入れる場合
   `mk-home.nix` で管理する

この repo ではどちらにも対応できる inventory を持つ。

### Android

- `nix-on-droid` を前提に専用 output を持つ
- `mk-android.nix` で profile を束ねる
- user module と profile の再利用を優先する

## 現在のファイルからの対応付け

現状の主要ファイルは、次のように再配置するのが自然。

- `common/system.nix`
  `modules/nixos/base.nix` + `modules/nixos/desktop.nix` に分割
- `common/home.nix`
  `modules/home/base.nix` + `modules/home/dev.nix` + `modules/home/personal.nix` + `modules/home/desktop.nix` に分割
- `common/sops.nix`
  `modules/nixos/sops.nix`
- `common/sops-hm.nix`
  `modules/home/sops.nix`
- `common/gui/*`
  `modules/home/gui/*`
- `common/tui/*`
  `modules/home/tui/*`
- `common/desktop/*`
  `modules/home/desktop.nix` または `modules/nixos/desktop.nix` に責務ごとに分解
- `common/desktop/niri/config.kdl`
  `modules/home/gui/assets/niri/config.kdl` のような module 隣接 asset へ移動
- `overlays/workarounds.nix`
  `overlays/workarounds.nix` のまま維持し、`modules` とは別の cross-cutting な infra として扱う

特に `common/system.nix` は desktop 前提の責務が多いため、最優先で分割対象とする。

## 実装タスク分割

以下は段階運用のためのフェーズではなく、望む最終構成へ到達するための実装タスク分割である。

途中の状態を一定期間運用することは前提にしない。実装はタスク単位で分けるが、適用は目標形まで揃ってから行う。

### Task 1: `flake-parts` の導入

- `inputs` に `flake-parts` を追加する
- `flake.nix` を `flake-parts.lib.mkFlake` ベースへ置き換える
- `systems`, `perSystem`, `flake` の骨組みを作る
- formatter と devShell を `perSystem` へ移す

### Task 2: builder 関数の導入

- `lib/mk-nixos-host.nix` を追加する
- `lib/mk-home.nix` を追加する
- 必要なら `lib/mk-android.nix` を追加する
- host 出力を builder 経由で組み立てる形へ揃える

### Task 3: module/profile の分割

- `modules/nixos/` と `modules/home/` を作る
- `profiles/nixos/`, `profiles/home/`, `profiles/android/` を作る
- 既存 `common/` の内容を base / role / user に分離する
- GUI/TUI 設定を `modules/home/` 配下へ整理する

### Task 4: host inventory の整理

- `flake.nix` に host inventory を定義する
- `targon`, `vm-nixos-test`, `zaun` を inventory に揃えて載せる
- WSL と Android も同じ inventory 方針で表現できるようにする
- `hosts/<name>/configuration.nix` を `hosts/<name>/default.nix` ベースへ寄せる

### Task 5: secrets の再編

- `secrets/secrets.yaml` を `common.yaml`, `hosts/`, `users/` に分割する
- `.sops.yaml` のルールを新構造に合わせて更新する
- system 用 key を host 永続領域へ寄せる
- user secrets の参照を user module 側へ明示する

### Task 6: ドキュメント更新

- host 追加手順
- secrets 追加手順
- profile 追加手順
- `flake-parts` 上での `perSystem` / `flake` の使い分け

## 非目標

現時点で優先しないこと:

- module を細かく分けすぎること
- inventory の抽象化を過剰に進めること
- 使っていない platform 向けの詳細設定を先回りで作り込みすぎること

重要なのは、`flake-parts` を軸にしつつ、役割ごとの境界を repo 構造へ反映すること。

## まとめ

今後この repo は、「NixOS の設定置き場」ではなく、「`flake-parts` を基盤として複数 platform にまたがる host と user 環境を宣言的に管理する repo」として設計する。

そのために必要な中核方針は次の 4 つ。

- `flake-parts` の `perSystem` と `flake` で責務を分ける
- `base`, `role`, `host`, `user` を分離する
- `mk-nixos-host.nix` と `mk-home.nix` で組み立て責務を分ける
- secrets を `common`, `host`, `user` に分離する

この方針を採れば、今後 server, WSL, Android を追加しても、host ごとに別流儀の設定が増殖しにくい構造を維持できる。
