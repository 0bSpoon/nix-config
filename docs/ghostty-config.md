# Ghostty 設定リファレンス（Linux向け）

Ghostty ターミナルエミュレータの設定リファレンス。macOS固有の設定は除外している。

設定ファイルの場所: `$XDG_CONFIG_HOME/ghostty/config` または `~/.config/ghostty/config`

---

## 1. 一般

### `language`

Ghostty の GUI 言語をシステムデフォルトとは異なる言語に設定する。

```
language = de
```

ドイツ語でGUIの文字列を表示する。Ghostty内で実行されるプログラムの言語には影響しない。また、翻訳されていないGUI以外の要素にも影響しない。

- **デフォルト値**: 未設定（システムデフォルト）
- **注意**: ランタイムでのリロード不可。変更にはGhosttyの完全再起動が必要
- **対象**: GTK のみ
- **Available since**: 1.3.0

---

## 2. フォント

### `font-family`

使用するフォントファミリーを指定する。

```
ghostty +list-fonts
```

で有効な値の一覧を取得できる。

複数回指定してフォールバックフォントを設定可能。プライマリフォントに要求されたコードポイントがない場合に使用される。多言語対応やシンボルフォントに有用。

絵文字について: Linuxではデフォルトで Noto Emoji が使用される。絵文字グリフを含むフォントファミリーを指定することでオーバーライド可能。

特定のスタイル（ボールド、イタリック、ボールドイタリック）は明示的に設定する必要はない。スタイルが設定されていない場合、レギュラースタイルからスタイルバリアントが検索される。

以前の設定値をリセットするには空文字列を使う:

```
font-family = ""
font-family = "My Favorite Font"
```

- **バリアント**: `font-family-bold`, `font-family-italic`, `font-family-bold-italic`
- **デフォルト値**: 未設定

### `font-style`

各ターミナルフォントスタイルに使用する名前付きフォントスタイルを指定する。フォント自体がアドバタイズするスタイル文字列に基づいてルックアップされる。例: "Iosevka Heavy" のスタイルは "Heavy"。

値を `false` に設定するとそのフォントスタイルを完全に無効化できる。

- **バリアント**: `font-style-bold`, `font-style-italic`, `font-style-bold-italic`
- **デフォルト値**: default

### `font-synthetic-style`

フォントファミリーに要求されたスタイルがない場合に、Ghosttyがスタイルを合成するかを制御する。

ボールドはアウトライン描画、イタリックはスラント適用で合成される。

- `false` / `true` で完全に無効/有効化
- `no-bold`, `no-italic`, `no-bold-italic` で個別に無効化可能（カンマ区切りで複数指定）
- **有効なスタイルキー**: `bold`, `italic`, `bold-italic`
- **デフォルト値**: 有効

**注意**: `bold` や `italic` を無効にしても `bold-italic` は無効にならない。`bold-italic` を無効にするには明示的に指定が必要。

### `font-feature`

フォントフィーチャーを適用する。複数回指定またはカンマ区切りで複数指定可能。

構文:
- 有効化: `feat`, `+feat`, `feat on`, `feat=1`
- 無効化: `-feat`, `feat off`, `feat=0`
- 値の設定: `feat=2`, `feat = 3`

プログラミングリガチャを無効にするには `-calt` を使用。一般的にリガチャを無効にするには `-calt, -liga, -dlig`。

- **デフォルト値**: 未設定

### `font-size`

フォントサイズ（ポイント単位）。小数値も可能で、最も近い整数ピクセルサイズが選択される。

例: 13.5pt @ 2px/pt = 27px

Linux（GTK）ではディスプレイスケールとテキストスケーリング係数に従ってスケーリングされる。

- **デフォルト値**: `12`

### `font-variation`

可変フォントのバリエーション値を設定する。フォーマットは `id=value`（`id` は4文字の軸識別子）。

一般的な軸: `wght`（ウェイト）, `slnt`（スラント）, `ital`（イタリック）, `opsz`（オプティカルサイズ）, `wdth`（幅）, `GRAD`（グラデーション）等。

- **バリアント**: `font-variation-bold`, `font-variation-italic`, `font-variation-bold-italic`
- **デフォルト値**: 未設定

### `font-codepoint-map`

Unicode コードポイントまたは範囲を特定のフォントにマッピングする。

構文: `codepoint=fontname`

- 単一コードポイント: `U+ABCD=fontname`
- 範囲: `U+ABCD-U+DEFG=fontname`
- 複数範囲: `U+ABCD-U+DEFG,U+1234-U+5678=fontname`

複数回指定可能。ランタイム変更は新しいターミナルにのみ影響する。

- **デフォルト値**: 未設定

### `font-shaping-break`

フォントシェイピングを複数のランに分割するポイントを制御する。

「ラン」はまとめてシェイピングされるテキストの連続セグメント。リガチャの形成などに関わる。

カンマで複数のオプションを組み合わせ、`no-` プレフィックスで無効化可能。

**オプション**:
- `cursor` — カーソル下でランを分割する

- **デフォルト値**: デフォルト有効
- **Available since**: 1.2.0

---

## 3. フォント調整

フォントによって決定される各種メトリクスを調整する設定群。値は整数（`1`, `-1` 等）またはパーセンテージ（`20%`, `-15%` 等）で指定し、元の値からの変化量を表す。

検証が限られるため、不適切な値（例: `-100%`）はターミナルが使用不能になる可能性がある。注意して使用すること。

### `adjust-cell-width` / `adjust-cell-height`

セルの幅/高さの調整。`adjust-cell-height` は以下の追加動作がある:
- フォントはセル内で垂直中央に配置
- カーソルサイズはフォントと同じ（`adjust-cursor-height` で別途調整可能）
- Powerline グリフはセル高さに合わせて調整

- **デフォルト値**: 未設定（null）

### `adjust-font-baseline`

セル底部からテキストベースラインまでの距離の調整。増加でベースラインが上に、減少で下に移動。

### `adjust-underline-position` / `adjust-underline-thickness`

アンダーラインの位置と太さの調整。位置は増加で下に、減少で上に移動。

### `adjust-strikethrough-position` / `adjust-strikethrough-thickness`

取り消し線の位置と太さの調整。

### `adjust-overline-position` / `adjust-overline-thickness`

オーバーラインの位置と太さの調整。

### `adjust-cursor-thickness` / `adjust-cursor-height`

バーカーソルとアウトラインカーソルの太さ/高さの調整。高さは全カーソルタイプに適用される。

### `adjust-box-thickness`

罫線文字（Box Drawing）の太さの調整。

### `adjust-icon-height`

Nerd Fontアイコンの最大高さの調整。正の値で最大高さが増加、負の値で減少。Powerlineシンボルなどには影響しない。

- **Available since**: 1.2.0

---

## 4. レンダリング

### `grapheme-width-method`

書記素クラスタのセル幅計算方法。

- `legacy` — レガシー方式（wcwidth等）。レガシープログラムとの互換性最大化だが、一部書記素の幅が不正確
- `unicode` — Unicode標準に基づく

ターミナルモード2027が有効化されると、設定に関わらず `unicode` が強制される。

- **デフォルト値**: `unicode`

### `freetype-load-flags`

FreeType のロードフラグを設定する。カンマ区切りで複数指定可能。`no-` プレフィックスで無効化。`true` / `false` で全フラグの一括設定も可能。

FreeType を使用するビルド（通常Linux）にのみ適用。

**フラグ**:
- `hinting` — ヒンティング有効化（デフォルト: 有効）
- `force-autohint` — 常にFreeTypeオートヒンターを使用（デフォルト: 無効）
- `monochrome` — 1ビットモノクロレンダリング。アンチエイリアシング無効（デフォルト: 無効）
- `autohint` — FreeTypeオートヒンター有効化（デフォルト: 有効）
- `light` — 軽量ヒンティング。グリフ形状をより保持（デフォルト: 有効）

### `alpha-blending`

アルファブレンディングで使用する色空間。テキストや透明画像の見た目に影響する。

- `native` — OS ネイティブ色空間（Linuxでは sRGB）
- `linear` — リニア空間でのブレンディング。テキスト端の暗くなるアーティファクトを排除するが、暗いテキストが細く、明るいテキストが太く見える
- `linear-corrected` — `linear` と同じだが、テキスト補正ステップ付き。`native` とほぼ同じ見た目で暗化アーティファクトなし

- **デフォルト値**: `linear-corrected`（Linux）
- **Available since**: 1.1.0

---

## 5. テーマ・カラー

### `theme`

使用するテーマ。ビルトインテーマ名、カスタムテーマ名、またはカスタムテーマファイルへの絶対パス。

テーマの検索ディレクトリ:
1. `$XDG_CONFIG_HOME/ghostty/themes`
2. Ghostty リソースの `share/ghostty/themes`

テーマ一覧の確認: `ghostty +list-themes`

テーマファイルは通常のGhostty設定ファイルと同じ構文。ライト/ダークモードで別テーマを指定可能:

```
theme = light:Rose Pine Dawn,dark:Rose Pine
```

- **デフォルト値**: 未設定

### `background` / `foreground`

ウィンドウの背景色/前景色。hex（`#RRGGBB` または `RRGGBB`）またはX11カラー名で指定。

- **デフォルト値**: background=`#282C34`, foreground=`#FFFFFF`

### `palette`

256色パレット。構文は `N=COLOR`（N: 0-255, COLOR: `#AABBCC` 等）。

パレットインデックスは10進数、2進数（`0b`）、8進数（`0o`）、16進数（`0x`）で指定可能。

ほとんどのテーマでは最初の16色（0-15）のみ設定すればよい。

- **デフォルト値**: デフォルトパレット

### `palette-generate`

基本16色ANSIカラーから拡張256色パレット（16-255）を自動生成する。

有効にすると、6×6×6カラーキューブと24段階グレースケールが基本パレットの補間から生成される。`palette` で明示的に設定された色は上書きされない。

- **デフォルト値**: `false`
- **Available since**: 1.3.0

### `palette-harmonious`

`palette-generate` で生成されるパレット色の順序を反転する。ライト/ダークモード両方でパレットベースのアプリケーションが適切に動作するようにする。

- **デフォルト値**: `false`
- **Available since**: 1.3.0

### `bold-color`

ボールドテキストに使用する色を変更する。

- 特定の色: `#RRGGBB` 等（常にデフォルトのボールドテキスト色として使用）
- `bright` — ボールドテキストにブライトカラーパレットを使用

- **デフォルト値**: 未設定
- **Available since**: 1.2.0

### `faint-opacity`

薄いテキスト（faint）の不透明度。1が完全不透明、0が完全透明。

- **デフォルト値**: `0.5`
- **Available since**: 1.2.0

### `minimum-contrast`

前景色と背景色の最小コントラスト比（1〜21）。WCAG 2.0仕様に基づく。

- `1` — コントラストなし（黒on黒を許可）
- `1.1` — 不可視テキスト回避に良い値
- `3` 以上 — 読みにくいテキスト回避に良い値

絵文字や画像には適用されない。

- **デフォルト値**: `1`

### `selection-foreground` / `selection-background`

選択テキストの前景色/背景色。未設定時はウィンドウ背景色と前景色の反転が使用される。

hex、X11カラー名、`cell-foreground`、`cell-background` が指定可能。

- **デフォルト値**: 未設定

### `selection-clear-on-typing`

タイピング時に選択テキストをクリアするか。

- **デフォルト値**: `true`
- **Available since**: 1.2.0

### `selection-clear-on-copy`

コピー後に選択テキストをクリアするか。`copy-on-select` によるコピーではクリアされない。

- **デフォルト値**: `false`

### `selection-word-chars`

テキスト選択時の単語境界文字。ダブルクリック選択などで使用される。

デフォルト: `` \t'"│`|:;,()[]{}<>$ ``

- **Available since**: 1.3.0

### `search-foreground` / `search-background`

検索マッチ（非フォーカス/候補マッチ）の前景色/背景色。

hex、X11カラー名、`cell-foreground`、`cell-background` が指定可能。

- **デフォルト値**: 黒テキストにゴールドイエロー背景

### `search-selected-foreground` / `search-selected-background`

現在選択中の検索マッチの前景色/背景色。

- **デフォルト値**: 黒テキストにソフトピーチ背景

---

## 6. 背景画像

### `background-image`

ターミナルの背景画像パス。PNG または JPEG ファイルのパス。

背景画像は現在ターミナル単位（ウィンドウ単位ではない）で、分割時に繰り返される。

**警告**: 背景画像はターミナルごとにVRAMで複製される。大きな画像はメモリ使用量の大幅な増加につながる可能性がある。

- **デフォルト値**: 未設定
- **Available since**: 1.2.0

### `background-image-opacity`

背景画像の不透明度。`background-opacity` との相対値。

- `1.0` — 背景画像が一般的な背景色の上に配置され、`background-opacity` で調整
- `1.0` 未満 — 背景画像と背景色が混合された後に `background-opacity` で調整
- `1.0` 超 — 背景画像が一般的な背景色より高い不透明度に

- **デフォルト値**: `1.0`
- **Available since**: 1.2.0

### `background-image-position`

背景画像の配置位置。

**有効な値**: `top-left`, `top-center`, `top-right`, `center-left`, `center`, `center-right`, `bottom-left`, `bottom-center`, `bottom-right`

- **デフォルト値**: `center`
- **Available since**: 1.2.0

### `background-image-fit`

背景画像のフィット方法。

- `contain` — アスペクト比を保持し、画像全体が表示される最大サイズにスケール
- `cover` — アスペクト比を保持し、ターミナルを完全にカバーする最小サイズにスケール
- `stretch` — アスペクト比を保持せずターミナル全体に引き伸ばし
- `none` — スケールなし

- **デフォルト値**: `contain`
- **Available since**: 1.2.0

### `background-image-repeat`

背景画像の繰り返し。`true` にすると、画像がターミナル領域を完全に埋めない場合に繰り返される。

- **デフォルト値**: `false`
- **Available since**: 1.2.0

---

## 7. カーソル

### `cursor-color`

カーソルの色。hex、X11カラー名、`cell-foreground`、`cell-background` が指定可能。

- **デフォルト値**: 未設定（自動選択）

### `cursor-opacity`

カーソルの不透明度（0〜1）。

- **デフォルト値**: `1.0`

### `cursor-style`

カーソルのスタイル。実行中のプログラムはエスケープシーケンスでオーバーライド可能。シェル統合は自動的にプロンプトでバーカーソルを設定する（`shell-integration-features = no-cursor` で無効化可能）。

**有効な値**: `block`, `bar`, `underline`, `block_hollow`

- **デフォルト値**: `block`

### `cursor-style-blink`

カーソルの点滅状態のデフォルト。実行中のプログラムは `DECSCUSR` でオーバーライド可能。

- 未設定（null） — デフォルトで点滅、DEC Mode 12 を尊重
- `true` / `false` — 点滅有効/無効、DEC mode 12 を無視

- **デフォルト値**: 未設定（点滅）

### `cursor-text`

カーソル下のテキストの色。hex、X11カラー名、`cell-foreground`、`cell-background` が指定可能。

- **デフォルト値**: 未設定（自動選択）

### `cursor-click-to-move`

プロンプト内のテキストをクリックしてカーソルを移動する機能。シェル統合（OSC 133によるプロンプトマーキング）が必要。

- **デフォルト値**: `true`

---

## 8. マウス

### `mouse-hide-while-typing`

タイピング時にマウスを非表示にする。マウスの使用（ボタン、移動等）で再表示。

- **デフォルト値**: `false`

### `mouse-shift-capture`

実行中のプログラムがマウスクリックでShiftキーを検出できるかを制御する。通常、Shiftキーはマウス選択の拡張に使用される。

- `false`（デフォルト） — Shiftはマウスプロトコルに送信されず選択を拡張。プログラムが `XTSHIFTESCAPE` でオーバーライド可能
- `true` — Shiftをマウスプロトコルに送信。プログラムが `XTSHIFTESCAPE` でオーバーライド可能
- `never` — `false` と同じだが、プログラムがオーバーライド不可
- `always` — `true` と同じだが、プログラムがオーバーライド不可

### `mouse-reporting`

マウスレポートの有効/無効。`false` にするとターミナルアプリケーションがマウスイベントをキャプチャできなくなる。

`toggle_mouse_reporting` キーバインドアクションでランタイム切替可能。

- **デフォルト値**: `true`

### `mouse-scroll-multiplier`

マウスホイールのスクロール距離の倍率。

`precision:` または `discrete:` プレフィックスでデバイスタイプ別に設定可能。カンマ区切りで両方設定可能（例: `precision:0.1,discrete:3`）。

値の範囲: 0.01〜10,000

- **デフォルト値**: discrete=`3`, precision=`1`

### `scroll-to-bottom`

サーフェスを一番下にスクロールするタイミング。カンマ区切りで複数オプション指定可能。`no-` プレフィックスで無効化。

- `keystroke` — キー押下時にスクロール
- `output` — 新しいデータ表示時にスクロール

- **デフォルト値**: `keystroke, no-output`

### `click-repeat-interval`

クリックをリピート（ダブル、トリプル等）と判定する間隔（ミリ秒）。0でプラットフォームデフォルト（Linux: 500ms）。

- **デフォルト値**: `0`

### `copy-on-select`

選択テキストを自動的にクリップボードにコピーするか。

- `true` — 選択クリップボードにコピー
- `clipboard` — 選択クリップボードとシステムクリップボードの両方にコピー
- `false` — 自動コピーしない

中クリックペーストは常に選択クリップボードを使用し、常に有効。

- **デフォルト値**: `true`（Linux）

### `right-click-action`

右クリック時のアクション。

**有効な値**: `context-menu`, `paste`, `copy`, `copy-or-paste`, `ignore`

- **デフォルト値**: `context-menu`

---

## 9. 背景・分割

### `background-opacity`

背景の不透明度（0〜1）。

- **デフォルト値**: `1.0`

### `background-opacity-cells`

明示的な背景色を持つセルにも `background-opacity` を適用するか。通常、`background-opacity` はウィンドウ背景にのみ適用される。

- **デフォルト値**: `false`
- **Available since**: 1.2.0

### `background-blur`

`background-opacity` が1未満の場合に背景をぼかすか。

- `false`（または `0`） — ぼかしなし
- `true`（または `20`） — デフォルトのぼかし強度
- 非負整数 — ぼかし強度を指定

対応環境:
- KDE Plasma（Wayland/X11）— ぼかし強度は無視され、KWinのグローバル設定に従う

- **デフォルト値**: `false`

### `unfocused-split-opacity`

非フォーカス分割の不透明度。無効にするには `1` に設定。範囲: 0.15〜1。

- **デフォルト値**: `0.7`

### `unfocused-split-fill`

非フォーカス分割を暗くする色。未設定時は背景色が使用される。

- **デフォルト値**: 未設定（背景色）

### `split-divider-color`

分割の区切り線の色。

- **デフォルト値**: 未設定（自動選択）
- **Available since**: 1.1.0

### `split-preserve-zoom`

ズームされた分割の状態を保持するタイミングを制御する。

- `navigation` — 別の分割にナビゲートする際にズーム状態を保持
- `no-` プレフィックスでオプション無効化

- **デフォルト値**: 未設定
- **Available since**: 1.3.0

---

## 10. キーバインド

### `keybind`

キーバインドの設定。フォーマットは `trigger=action`。

**トリガー**: `+` 区切りのキーとモディファイア。例: `ctrl+a`, `ctrl+shift+b`, `up`

単一Unicodeコードポイントの場合、キーボードレイアウトに影響される。物理キーコードは [W3C仕様](https://www.w3.org/TR/uievents-code/) に基づく（例: `KeyA`）。物理キーはUnicodeコードポイントより優先される。

`catch_all` はバインドされていないキーにマッチする特殊キー。

**モディファイア**: `shift`, `ctrl`（alias: `control`）, `alt`（alias: `opt`, `option`）, `super`（alias: `cmd`, `command`）

**シーケンス**: `>` で区切って複数トリガーのシーケンスを定義可能。例: `ctrl+a>n=new_window`

**アクション**:
- `ignore` — 入力を無視
- `unbind` — バインドを削除
- `csi:text` — CSIシーケンスを送信
- `esc:text` — エスケープシーケンスを送信
- `text:text` — 文字列を送信（Zig文字列リテラル構文）
- その他は `ghostty +list-actions` で確認

**特殊値**:
- `keybind=clear` — 全キーバインドをクリア

**プレフィックス**:
- `all:` — 全ターミナルサーフェスに適用
- `global:` — グローバルキーバインド（GNOME 48+、KDE Plasma 5.27+等で対応）
- `unconsumed:` — 入力を消費しない
- `performable:` — アクション実行可能時のみ入力を消費

**チェインアクション** (1.3.0+):

```ini
keybind = ctrl+a=new_window
keybind = chain=goto_split:left
```

**キーテーブル** (1.3.0+):

```ini
foo/ctrl+a=new_window
```

テーブルは `activate_key_table:<name>` / `deactivate_key_table` アクションで有効化/無効化。

### `key-remap`

Ghostty内でモディファイアキーをリマップする。フォーマットは `from=to`。

```
key-remap = ctrl=super
key-remap = left_control=right_alt
```

- 一方向のリマップ（`ctrl=super` でCtrlがSuperになるが、SuperはSuperのまま）
- リマップは推移的でない（`ctrl=super` と `alt=ctrl` の場合、Altを押すとCtrlになり、Superにはならない）
- キーバインドマッチングとターミナル入力エンコーディングの両方に影響
- **デフォルト値**: 未設定

---

## 11. ウィンドウ

### `window-padding-x` / `window-padding-y`

ターミナルセルとウィンドウ境界間の水平/垂直パディング（ポイント単位）。

カンマ区切りで左右/上下に異なる値を指定可能（例: `window-padding-x = 2,4`）。

- **デフォルト値**: `2`（上下左右すべて）

### `window-padding-balance`

ビューポートがセルサイズで割り切れない場合の余分なパディングのバランスを取る。

- `false` — バランスなし
- `true` — パディングをバランス。上部パディングにキャップあり
- `equal` — 全辺均等にバランス（Available since: 1.4.0）

- **デフォルト値**: `false`

### `window-padding-color`

パディング領域の色。

- `background` — `background` で指定された背景色
- `extend` — 最も近いグリッドセルの背景色を拡張
- `extend-always` — `extend` と同じだが、常に拡張（ヒューリスティック無効）

- **デフォルト値**: `background`

### `window-inherit-working-directory`

新しいウィンドウが直前のフォーカスウィンドウの作業ディレクトリを継承するか。

- **デフォルト値**: `true`

### `tab-inherit-working-directory`

新しいタブが直前のフォーカスタブの作業ディレクトリを継承するか。

- **デフォルト値**: `true`

### `split-inherit-working-directory`

新しい分割ペインが直前のフォーカス分割の作業ディレクトリを継承するか。

- **デフォルト値**: `true`

### `window-inherit-font-size`

新しいウィンドウ/タブが直前のフォーカスウィンドウのフォントサイズを継承するか。

- **デフォルト値**: `true`

### `window-decoration`

ウィンドウデコレーションの設定。

- `none` — 全デコレーション無効
- `auto` — OS/デスクトップ環境に基づいて自動決定
- `client` — クライアントサイドデコレーション優先（Available since: 1.1.0）
- `server` — サーバーサイドデコレーション優先。KDE Plasma等で有効（Available since: 1.1.0）

互換性のため `true`（= `auto`）/ `false`（= `none`）も受け付ける。

`toggle_window_decorations` キーバインドでランタイム切替可能。

- **デフォルト値**: `auto`

### `window-title-font-family`

ウィンドウとタブタイトルのフォント。固定幅フォントでなくても良い。

- **デフォルト値**: 未設定（システムデフォルト）
- **Available since**: 1.1.0（GTK）

### `window-subtitle`

ウィンドウサブタイトルのテキスト。GTKのみ。

- `false` — サブタイトル無効
- `working-directory` — サーフェスの作業ディレクトリを表示

- **デフォルト値**: `false`
- **Available since**: 1.1.0

### `window-theme`

ウィンドウのテーマ。

- `auto` — ターミナル背景色に基づいて決定
- `system` — システムテーマ
- `light` / `dark` — ライト/ダークテーマ強制
- `ghostty` — Ghostty設定の背景色/前景色を使用（Linux のみ）

- **デフォルト値**: `auto`

### `window-height` / `window-width`

初期ウィンドウサイズ（ターミナルグリッドセル単位）。両方設定する必要がある。新しいタブ/分割には影響しない。

最小サイズ: 10列 × 4行

- **デフォルト値**: `0`（ランタイムが決定）

### `window-save-state`

ウィンドウ状態の保存/復元。

- `default` — システムのデフォルト動作
- `never` — 保存しない
- `always` — 常に保存

- **デフォルト値**: `default`
- **注意**: 現在macOSのみ対応。Linuxでは効果なし

### `window-new-tab-position`

新しいタブの作成位置。

- `current` — 現在フォーカスしているタブの後に挿入
- `end` — タブリストの末尾に挿入

- **デフォルト値**: `current`

### `window-titlebar-background` / `window-titlebar-foreground`

ウィンドウタイトルバーの背景色/前景色。`window-theme = ghostty` の場合のみ有効。GTKのみ。

- **デフォルト値**: 未設定

### `maximize`

ウィンドウを最大化状態で起動するか。

- **デフォルト値**: `false`
- **Available since**: 1.1.0

### `fullscreen`

新しいウィンドウをフルスクリーンで起動するか。

- `false` — フルスクリーンにしない
- `true` — ネイティブフルスクリーン

- **デフォルト値**: `false`

### `title`

ウィンドウタイトルを強制設定。設定すると、プログラムからのタイトル変更エスケープシーケンスを無視する。

空白タイトルにするにはスペースを設定: `title = " "`

- **デフォルト値**: 未設定（プログラムが制御）

### `class`

アプリケーションクラス値。X11の `WM_CLASS` プロパティ、Waylandアプリケーション ID、DBusバス名を制御する。

[GTKドキュメント](https://docs.gtk.org/gio/type_func.Application.id_is_valid.html) の要件に従う必要がある。

- **デフォルト値**: `com.mitchellh.ghostty`
- **対象**: GTK のみ

### `x11-instance-name`

X11 の `WM_CLASS` プロパティのインスタンス名。X11 実行時のみ有効。

- **デフォルト値**: `ghostty`
- **対象**: GTK のみ

### `resize-overlay`

リサイズオーバーレイの表示タイミング。

- `always` — 常に表示
- `never` — 表示しない
- `after-first` — 初回作成時は非表示、以降のリサイズで表示

- **デフォルト値**: `after-first`

### `resize-overlay-position`

リサイズオーバーレイの位置。

**有効な値**: `center`, `top-left`, `top-center`, `top-right`, `bottom-left`, `bottom-center`, `bottom-right`

- **デフォルト値**: `center`

### `resize-overlay-duration`

リサイズオーバーレイの表示時間。

時間単位: `y`, `d`, `h`, `m`, `s`, `ms`, `us`/`µs`, `ns`

- **デフォルト値**: `750ms`

### `focus-follows-mouse`

複数の分割ペインがある場合、マウスでフォーカスするペインを選択するか。

- **デフォルト値**: `false`

---

## 12. タブ

### `window-show-tab-bar`

タブバーの表示。

- `always` — 常に表示（Available since: 1.2.0）
- `auto` — タブが2つ以上のとき自動表示
- `never` — 表示しない

- **デフォルト値**: `auto`
- **対象**: Linux（GTK）のみ

---

## 13. クリップボード

### `clipboard-read` / `clipboard-write`

ターミナル内のプログラムがシステムクリップボードを読み書きすることを許可するか（OSC 52）。

**有効な値**: `ask`, `allow`, `deny`

- **デフォルト値**: read=`ask`, write=`allow`

### `clipboard-trim-trailing-spaces`

クリップボードにコピーされるデータの末尾の空白をトリムする。

- **デフォルト値**: `true`

### `clipboard-paste-protection`

安全でないテキスト（改行を含む）の貼り付け前に確認を要求する。

- **デフォルト値**: `true`

### `clipboard-paste-bracketed-safe`

ブラケットペーストを安全と見なすか。

- **デフォルト値**: `true`

### `clipboard-codepoint-map`

クリップボードへのコピー時にUnicodeコードポイントを置換する。

構文:
- 単一コードポイント: `U+1234=U+ABCD` または `U+1234=replacement_text`
- コードポイント範囲: `U+1234-U+5678=U+ABCD`

例:
- `U+2500=U+002D` — 罫線水平 → ハイフン
- `U+2502=U+007C` — 罫線垂直 → パイプ

- **デフォルト値**: 未設定

---

## 14. コマンド・環境

### `command`

実行するコマンド（通常はシェル）。絶対パスでない場合は `PATH` でルックアップされる。未設定時のデフォルト:

1. `SHELL` 環境変数
2. `passwd` エントリ

追加引数付きの場合、`/bin/sh -c` で実行される。`direct:` プレフィックスでシェル展開を回避。`shell:` プレフィックスで常にシェルでラップ。

- **デフォルト値**: 未設定（システムシェル）

### `initial-command`

Ghostty 起動時の最初のターミナルサーフェスにのみ適用されるコマンド。以降のサーフェスは `command` を使用する。

CLI の `-e` フラグのショートカット: `ghostty -e fish --with --custom --args`

- **デフォルト値**: 未設定

### `working-directory`

コマンド開始後に変更するディレクトリ。`window-inherit-working-directory` が優先される。

- 絶対パス
- `~/` プレフィックス
- `home` — ユーザーのホームディレクトリ
- `inherit` — 起動プロセスの作業ディレクトリ

- **デフォルト値**: 未設定（GTKでデスクトップランチャーから起動時は `home`）

### `env`

ターミナルサーフェスで起動するコマンドに渡す追加環境変数。

```
env = KEY=VALUE
```

空文字列でマップ全体をリセット。キーを空文字列に設定するとそのキーを削除。

- **デフォルト値**: 未設定
- **Available since**: 1.2.0

### `input`

コマンド起動時にPTYへの入力として送信するデータ。

- `raw:<string>` — 生テキストをそのまま送信（Zig文字列リテラル構文）
- `path:<path>` — ファイルパスの内容を読み取って送信（最大10MB）

プレフィックスなしの場合は `raw:` と見なされる。

複数回指定可能（区切り文字なしで連結）。

- **デフォルト値**: 未設定
- **Available since**: 1.2.0

### `wait-after-command`

コマンド終了後もターミナルを開いたままにする。キー押下で閉じる。

- **デフォルト値**: `false`

### `abnormal-command-exit-runtime`

プロセス終了を異常と見なす最小ランタイム（ミリ秒）。

- **デフォルト値**: `250`

---

## 15. スクロールバック

### `scrollback-limit`

スクロールバックバッファのサイズ（バイト単位）。アクティブスクリーンも含む。

スクロールバックは完全にメモリ内に存在する。ターミナルサーフェス単位のサイズ。

- **デフォルト値**: `10000000`（10MB）

### `scrollbar`

スクロールバーの表示タイミング。

- `system` — システム設定に従う
- `never` — 表示しない

- **デフォルト値**: `system`

---

## 16. リンク

### `link`

正規表現でターミナルテキストにマッチし、クリック時のアクションを関連付ける。URL、ファイルパス等に使用可能。

先に設定されたリンクが優先される。デフォルトのURLリンクは常に存在する（`link-url` で無効化可能）。

### `link-url`

URLマッチングの有効/無効。有効時はCtrl押しながらホバーでURLがマッチされ、デフォルトのシステムアプリケーションで開かれる。

- **デフォルト値**: `true`

### `link-previews`

マッチしたURLのリンクプレビュー表示。

- `true` — 全URLに表示
- `false` — 表示しない
- `osc8` — OSC 8で作成されたハイパーリンクにのみ表示

- **デフォルト値**: `true`
- **Available since**: 1.2.0

---

## 17. クイックターミナル

### `quick-terminal-position`

クイックターミナルウィンドウの位置。

**有効な値**: `top`, `bottom`, `left`, `right`, `center`

**注意**: デフォルトのキーバインドはない。`toggle_quick_terminal` アクションをキーにバインドする必要がある。

- **デフォルト値**: `top`

### `quick-terminal-size`

クイックターミナルのサイズ。パーセンテージ（`%` サフィックス）またはピクセル（`px` サフィックス）で指定。

カンマ区切りで2つのサイズを指定可能（例: `50%,500px`）。1つ目はプライマリ軸、2つ目はセカンダリ軸。

- **デフォルト値**: デフォルトサイズ
- **Available since**: 1.2.0

### `quick-terminal-screen`

クイックターミナルを表示するスクリーン。

- `main` — OSが推奨するメインスクリーン
- `mouse` — マウスがホバーしているスクリーン

- **デフォルト値**: `main`

### `quick-terminal-autohide`

フォーカスが別のウィンドウに移った時にクイックターミナルを自動的に非表示にする。

- **デフォルト値**: `false`（Linux）

### `quick-terminal-keyboard-interactivity`

クイックターミナルがキーボード入力を受け取る条件。Wayland のみ。

- `none` — キーボード入力を受け取らない
- `on-demand` — フォーカス時のみ
- `exclusive` — 常に受け取る

- **デフォルト値**: `on-demand`
- **Available since**: 1.2.0

### `gtk-quick-terminal-layer`

クイックターミナルウィンドウのレイヤー。GTK Waylandのみ。

- `overlay` — 全ウィンドウの前面
- `top` — 通常ウィンドウの前面だがフルスクリーンオーバーレイの背面
- `bottom` — 通常ウィンドウの背面だが壁紙の前面
- `background` — 全ウィンドウの背面

- **デフォルト値**: `top`
- **Available since**: 1.2.0

### `gtk-quick-terminal-namespace`

クイックターミナルウィンドウの名前空間。Waylandコンポジタやスクリプトがレイヤーサーフェスのタイプを判別するために使用される。GTK Waylandのみ。

- **デフォルト値**: `ghostty-quick-terminal`
- **Available since**: 1.2.0

---

## 18. シェル統合

### `shell-integration`

シェル統合の自動注入。シェル統合により以下の機能が有効になる:

- 作業ディレクトリの報告（新しいタブ/分割が前のターミナルのディレクトリを継承）
- プロンプトマーキング（`jump_to_prompt` キーバインド）
- プロンプトでのターミナル閉鎖時の確認不要
- 複雑なプロンプトでのウィンドウリサイズの改善

**有効な値**: `none`, `detect`, `bash`, `elvish`, `fish`, `nushell`, `zsh`

- **デフォルト値**: `detect`

### `shell-integration-features`

シェル統合の機能を個別に有効/無効化。カンマ区切りで指定。`no-` プレフィックスで無効化。`true` / `false` で全機能の一括設定。

**機能**:
- `cursor` — プロンプトでカーソルをバーに設定
- `sudo` — terminfoを保持するsudoラッパーを設定
- `title` — シェル統合によるウィンドウタイトル設定
- `ssh-env` — SSH環境変数互換性。TERMを `xterm-256color` に自動変換（Available since: 1.2.0）
- `ssh-terminfo` — リモートホストへのterminfo自動インストール（Available since: 1.2.0）
- `path` — GhosttyのバイナリディレクトリをPATHに追加

---

## 19. 通知

### `notify-on-command-finish`

コマンド終了通知の送信タイミング。シェル統合またはOSC 133エスケープシーケンスが必要。

- `never` — 送信しない
- `unfocused` — サーフェスが非フォーカス時のみ
- `always` — 常に送信

- **デフォルト値**: `never`
- **Available since**: 1.3.0

### `notify-on-command-finish-action`

コマンド終了通知の方法。カンマ区切りで複数指定可能。`no-` プレフィックスで無効化。

- `bell` — ベル音（デフォルト: 有効）
- `notify` — デスクトップ通知（デフォルト: 無効）

- **Available since**: 1.3.0

### `notify-on-command-finish-after`

コマンド終了通知を送信するまでの最小実行時間。

時間単位: `y`, `d`, `h`, `m`, `s`, `ms`, `us`/`µs`, `ns`

- **デフォルト値**: `5s`
- **Available since**: 1.3.0

### `desktop-notifications`

OSC 9 または OSC 777 等のエスケープシーケンスによるデスクトップ通知の有効/無効。

- **デフォルト値**: `true`

### `app-notifications`

Ghostty のアプリ内通知（GTK ではトースト）の制御。

- `clipboard-copy` — クリップボードコピー通知（デフォルト: 有効）
- `config-reload` — 設定リロード通知（デフォルト: 有効）

`no-` プレフィックスで無効化。`true` / `false` で一括設定。

- **デフォルト値**: 全て有効
- **対象**: GTK のみ
- **Available since**: 1.1.0

### `bell-features`

ベル機能の設定。カンマ区切りで複数指定可能。`no-` プレフィックスで無効化。

- `system` — システム通知機能を使用（GNOME の "Sound > Alert Sound"、KDE Plasma の "Accessibility > System Bell" で設定変更可能）
- `audio` — カスタムサウンドを再生
- `attention`（デフォルト: 有効） — 非フォーカス時にユーザーの注意を要求
- `title`（デフォルト: 有効） — ベル絵文字（🔔）をタイトルに付加
- `border` — アラートされたサーフェスにボーダーを表示（Available since: 1.2.0 GTK）

- **Available since**: 1.2.0

### `bell-audio-path`

`audio` ベル機能が有効な場合のオーディオファイルパス。

- **デフォルト値**: 未設定
- **Available since**: 1.2.0（GTK）

### `bell-audio-volume`

`audio` ベル機能の音量（システム音量に対する相対値）。0.0〜1.0。

- **デフォルト値**: `0.5`
- **Available since**: 1.2.0（GTK）

---

## 20. カスタムシェーダー

### `custom-shader`

デフォルトシェーダーの後に実行するカスタムシェーダー。GLSL構文のファイルパスを指定。

**警告**: 無効なシェーダーはGhosttyを使用不能にする可能性がある（ウィンドウが完全に黒くなる等）。

Shadertoy互換。`mainImage` 関数を指定する。

**ユニフォーム変数**:
- `sampler2D iChannel0` — 入力テクスチャ（現在のターミナル画面）
- `vec3 iResolution` — 出力テクスチャサイズ `[width, height, 1]`（px）
- `float iTime` — 最初のフレームからの経過秒数
- `float iTimeDelta` — 前フレームからの経過秒数
- `int iFrame` — レンダリング済みフレーム数

**Ghostty固有の拡張**:
- `vec4 iCurrentCursor` / `iPreviousCursor` — カーソル情報
- `vec4 iCurrentCursorColor` / `iPreviousCursorColor` — カーソル色
- `vec4 iCurrentCursorStyle` / `iPreviousCursorStyle` — カーソルスタイル
- `vec4 iCursorVisible` — カーソルの可視性
- `float iTimeCursorChange` — カーソル変更のタイムスタンプ
- `float iTimeFocus` — サーフェスフォーカスのタイムスタンプ
- `int iFocus` — フォーカス状態（1=フォーカス、0=非フォーカス）
- `vec3 iPalette[256]` — 256色パレット（正規化RGB）
- `vec3 iBackgroundColor` / `iForegroundColor` — 背景色/前景色
- `vec3 iCursorColor` / `iCursorText` — カーソル色/カーソルテキスト色
- `vec3 iSelectionBackgroundColor` / `iSelectionForegroundColor` — 選択色

複数回指定可能（指定順に実行）。ランタイムで変更可能。

- **デフォルト値**: 未設定

### `custom-shader-animation`

カスタムシェーダー使用時のアニメーションループ。

- `true` — フォーカス中のターミナルでアニメーション実行（CPU使用量がやや増加）
- `false` — ターミナル更新時のみレンダリング
- `always` — フォーカスに関わらず常にアニメーション実行

- **デフォルト値**: `true`

---

## 21. GTK固有

### `gtk-opengl-debug`

GTK の OpenGL デバッグログの有効/無効。

- **デフォルト値**: `false`（リリースビルド）
- **Available since**: 1.1.0

### `gtk-single-instance`

GTK アプリケーションをシングルインスタンスモードで実行するか。

- `true` — シングルインスタンス
- `false` — 各プロセスが独立したアプリケーション
- `detect` — 自動検出（`TERM_PROGRAM` 環境変数やCLI引数が存在する場合は `false`）

- **デフォルト値**: `detect`

### `gtk-titlebar`

GTK のフルタイトルバーを表示するか。`window-decoration = none` の場合は効果なし。

- **デフォルト値**: `true`

### `gtk-tabs-location`

GTK タブバーの位置。

**有効な値**: `top`, `bottom`, `hidden`

`hidden` 設定時はタブ数を表示するタブボタンがタイトルバーに表示される。

- **デフォルト値**: `top`

### `gtk-titlebar-hide-when-maximized`

ウィンドウ最大化時にタイトルバーを非表示にするか。

- **デフォルト値**: `false`
- **Available since**: 1.1.0

### `gtk-toolbar-style`

トップ/ボトムバーのタブバーの外観。

- `flat` — フラット
- `raised` — ターミナル領域に影を落とす
- `raised-border` — `raised` に似るが影の代わりにボーダー

- **デフォルト値**: `raised`

### `gtk-titlebar-style`

GTK タイトルバーのスタイル。

- `native` — 従来型タイトルバー
- `tabs` — タブバーとタイトルバーを統合（垂直スペースの節約）

- **デフォルト値**: `native`

### `gtk-wide-tabs`

GTK タブを「ワイド」にするか。ワイドタブは利用可能なスペースを埋める（GNOMEの新しいスタイル）。

- **デフォルト値**: `true`

### `gtk-custom-css`

カスタム CSS ファイルのロード。

- [GTK CSS 概要](https://docs.gtk.org/gtk4/css-overview.html)
- [CSS プロパティ一覧](https://docs.gtk.org/gtk4/css-properties.html)

`env GTK_DEBUG=interactive ghostty` でリアルタイムの CSS 調整が可能。

`?` プレフィックスでファイルが存在しない場合のエラーを抑制。最大5MiB。複数回指定可能。

- **デフォルト値**: 未設定
- **Available since**: 1.1.0

---

## 22. Linux固有

### `linux-cgroup`

各サーフェス（タブ、分割、ウィンドウ）を一時的な `systemd` スコープに配置する。サーフェス単位のリソース管理が可能になる。

- `never` — cgroup を使用しない
- `always` — 常に使用
- `single-instance` — シングルインスタンスモードの場合のみ有効

起動時間がやや遅くなる（約100ミリ秒）。`systemd` が必要。

- **デフォルト値**: `single-instance`（Linux）

### `linux-cgroup-memory-limit`

個別ターミナルプロセスのメモリ制限（バイト単位）。`systemd` の `MemoryHigh`（ソフトリミット）を設定する。

- **デフォルト値**: 未設定（制限なし）

### `linux-cgroup-processes-limit`

個別ターミナルプロセスのプロセス数制限。`systemd` の `TasksMax`（ハードリミット）を設定する。

- **デフォルト値**: 未設定（制限なし）

### `linux-cgroup-hard-fail`

`systemd` スコープ作成の失敗をハードエラーにするか。

- `false` — 失敗を無視（サーフェス作成は成功）
- `true` — 失敗時にサーフェス作成も失敗

- **デフォルト値**: `false`

---

## 23. 端末

### `term`

`TERM` 環境変数に設定する値。

- **デフォルト値**: `xterm-ghostty`

### `enquiry-response`

`ENQ`（`0x05`）受信時に送信する文字列。

- **デフォルト値**: 空文字列

### `osc-color-report-format`

OSC シーケンスによる色情報クエリの報告フォーマット。

- `none` — 応答なし
- `8-bit` — スケールなしコンポーネント（`rr/gg/bb`）
- `16-bit` — スケール済みコンポーネント（`rrrr/gggg/bbbb`）

- **デフォルト値**: `16-bit`

### `vt-kam-allowed`

KAM モード（ANSI mode 2）の使用を許可するか。KAM はアプリケーションの要求でキーボード入力を無効にする。

- **デフォルト値**: `false`

### `title-report`

タイトルレポート（CSI 21 t）の有効/無効。ターミナルタイトルのクエリを許可する。

**警告**: セキュリティリスクあり。悪意のあるタイトルで任意コード実行の可能性。

- **デフォルト値**: `false`
- **Available since**: 1.0.1

### `image-storage-limit`

画像データ（Kitty画像プロトコル等）のターミナルスクリーンあたりの最大バイト数。0で全画像プロトコルを無効化。

プライマリスクリーンとオルタネートスクリーンで別々なので、サーフェスあたりの実効制限は2倍。

- **デフォルト値**: `320000000`（320MB）
- **最大値**: 4,294,967,295（4GiB）

---

## 24. その他

### `config-file`

追加の設定ファイル。複数回指定可能。パスはファイルを含むディレクトリからの相対パス。

`?` プレフィックスでファイルが存在しない場合のエラーを抑制。循環は不可。

**重要**: 設定ファイルは定義されている設定の後に読み込まれる。

### `config-default-files`

デフォルトの設定ファイルパス（`$XDG_CONFIG_HOME/ghostty/config.ghostty`）を読み込むか。

CLIのみの設定。設定ファイル内での設定は効果なし。

- **デフォルト値**: `true`

### `confirm-close-surface`

サーフェスを閉じる前に確認するか。

- `true` — プロセス実行中は確認
- `false` — 確認なし
- `always` — 常に確認

- **デフォルト値**: `true`

### `quit-after-last-window-closed`

最後のサーフェスが閉じられた後に終了するか。

- **デフォルト値**: `true`（Linux）

### `quit-after-last-window-closed-delay`

最後のウィンドウが閉じられてからGhosttyが終了するまでの遅延。`quit-after-last-window-closed = true` の場合のみ有効。最小値は `1s`。

時間単位: `y`, `d`, `h`, `m`, `s`, `ms`, `us`/`µs`, `ns`

- **デフォルト値**: 未設定（即時終了）

### `initial-window`

起動時にウィンドウを作成するか。

- **デフォルト値**: `true`

### `command-palette-entry`

コマンドパレットのカスタムエントリ。

```ini
command-palette-entry = title:Reset Font Style, action:csi:0m
command-palette-entry = title:Crash on Main Thread,description:Causes a crash.,action:crash:main
```

空値でデフォルトエントリをクリア: `command-palette-entry =`

- **デフォルト値**: デフォルトエントリ
- **Available since**: 1.2.0

### `async-backend`

非同期IOのバックエンド。

- `auto` — プラットフォームに最適なバックエンドを自動選択
- `epoll` — `epoll` API
- `io_uring` — `io_uring` API

Linux のみ。完全再起動が必要。

- **デフォルト値**: `auto`
- **Available since**: 1.2.0

### `progress-style`

ConEmu OSC 9;4 エスケープシーケンスによるプログレスバーの有効/無効。

- **デフォルト値**: `true`
