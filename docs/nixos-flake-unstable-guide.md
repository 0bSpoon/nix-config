# NixOS Flake + Home Manager で unstable パッケージを使う方法

> **Note:** 現在はリポジトリ全体が `nixos-unstable` を使用しているため、このパターンは不要。参考資料として保持。

## 概要

安定版チャネルをベースにしつつ、一部のパッケージだけ unstable から取得するパターン。

## 1. flake.nix の構成

### inputs に unstable を追加

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager/release-24.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### outputs で inputs を各モジュールに渡す

```nix
outputs =
  { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };          # NixOSモジュール用
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };  # Home Manager用
          home-manager.users.myuser = import ./home.nix;
        }
      ];
    };
  };
```

**ポイント:**

- `specialArgs` → NixOS モジュール（`configuration.nix`）に渡す
- `home-manager.extraSpecialArgs` → Home Manager モジュール（`home.nix`）に渡す
- アーキテクチャ（system）を flake.nix にハードコードしない

## 2. モジュール側での使い方（home.nix）

```nix
{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;   # ← ハードコードせず pkgs から取得
    config = pkgs.config;   # ← allowUnfree 等の設定を引き継ぐ
  };
in {
  home.packages = with pkgs; [
    ripgrep              # 安定版
    fd                   # 安定版
    unstable.neovim      # unstable
    unstable.obsidian    # unstable
  ];
}
```

**ポイント:**

- `pkgs.system` を使うことでアーキテクチャのハードコードを回避（macOS対応も容易）
- `pkgs.config` を渡すことで `configuration.nix` の `nixpkgs.config`（`allowUnfree` 等）をそのまま引き継ぐ
- `with pkgs;` のスコープ内でも `unstable.xxx` のプレフィックス付き記述で混在可能

## 3. programs モジュールで unstable を使う

`package` オプションがあるモジュールは直接指定できる。

```nix
programs.firefox = {
  enable = true;
  package = unstable.firefox;
};

programs.claude-code = {
  enable = true;
  package = unstable.claude-code;
};
```

**注意:** `home.packages` と `programs.xxx` の両方に同じパッケージを入れると競合エラーになる。どちらか片方だけにすること。

## 4. package オプションがないモジュールの場合

overlay で `pkgs` 自体を差し替える。

```nix
# configuration.nix や flake の module 内
nixpkgs.overlays = [
  (final: prev: {
    some-package = (import inputs.nixpkgs-unstable {
      system = prev.system;
      config = prev.config;
    }).some-package;
  })
];
```

これにより `pkgs.some-package` 自体が unstable 版になり、`package` オプションがないモジュールでも自動的に unstable が使われる。

## まとめ

| やりたいこと | 方法 |
|---|---|
| `home.packages` で使う | `unstable.パッケージ名` |
| `programs.xxx` で使う | `package = unstable.パッケージ名;` |
| `package` オプションがない | `nixpkgs.overlays` で pkgs を差し替え |
