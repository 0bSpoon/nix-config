# niri config.kdl 日本語リファレンス

設定ファイル: `common/desktop/niri/config.kdl`
フォーマット: KDL (https://kdl.dev)
公式Wiki: https://yalter.github.io/niri/Configuration:-Introduction

`/-` を先頭に付けると、続くノードがコメントアウトされる。

---

## input - 入力デバイス設定

Wiki: https://yalter.github.io/niri/Configuration:-Input

### keyboard

```kdl
keyboard {
    xkb {
        // rules, model, layout, variant, options を設定できる。
        // 詳細: xkeyboard-config(7)
        //
        // 例:
        // layout "us,ru"
        // options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
        //
        // このセクションが空の場合、niri は org.freedesktop.locale1 から
        // xkb設定を取得する。localectl set-x11-keymap で制御可能。
    }

    // 起動時にNumLockを有効化。この設定を省略すると無効になる。
    numlock
}
```

### touchpad

```kdl
touchpad {
    // off                        // タッチパッドを無効化
    tap                           // タップでクリック
    // dwt                        // タイピング中はタッチパッド無効化
    // dwtp                       // トラックポイント使用中はタッチパッド無効化
    // drag false                 // ドラッグを無効化
    // drag-lock                  // ドラッグロック
    natural-scroll                // ナチュラルスクロール（逆方向）
    // accel-speed 0.2            // 加速度
    // accel-profile "flat"       // 加速プロファイル
    // scroll-method "two-finger" // スクロール方式
    // disabled-on-external-mouse // 外部マウス接続時に無効化
}
```

### mouse

```kdl
mouse {
    // off                        // マウスを無効化
    // natural-scroll             // ナチュラルスクロール
    // accel-speed 0.2            // 加速度
    // accel-profile "flat"       // 加速プロファイル
    // scroll-method "no-scroll"  // スクロール方式
}
```

### trackpoint

```kdl
trackpoint {
    // off                            // トラックポイントを無効化
    // natural-scroll                 // ナチュラルスクロール
    // accel-speed 0.2                // 加速度
    // accel-profile "flat"           // 加速プロファイル
    // scroll-method "on-button-down" // ボタン押下時スクロール
    // scroll-button 273              // スクロールボタン番号
    // scroll-button-lock             // スクロールボタンロック
    // middle-emulation               // 中ボタンエミュレーション
}
```

### その他の入力設定

```kdl
// フォーカスが移動した時、マウスカーソルをウィンドウ中央にワープさせる。
// warp-mouse-to-focus

// マウスカーソルの移動先にあるウィンドウ/出力に自動でフォーカスを移す。
// max-scroll-amount="0%" を設定すると、画面内に完全に表示されているウィンドウのみ対象。
// focus-follows-mouse max-scroll-amount="0%"
```

---

## output - 出力（モニター）設定

Wiki: https://yalter.github.io/niri/Configuration:-Outputs

`niri msg outputs` で出力名の一覧を確認できる。
ノートPCの内蔵モニターは通常 `"eDP-1"` という名前。
`/-` を外してノードを有効化すること。

```kdl
/-output "eDP-1" {
    // off                         // この出力を無効化

    // 解像度とリフレッシュレート。
    // 形式: "<幅>x<高さ>" または "<幅>x<高さ>@<リフレッシュレート>"
    // リフレッシュレート省略時は最高値が選択される。
    // mode自体を省略/無効値の場合は自動選択。
    // `niri msg outputs` で利用可能なモードを確認できる。
    mode "1920x1080@120.030"

    // 整数または小数のスケール。例: 1.5 で150%スケール。
    scale 2

    // 出力を反時計回りに回転。有効な値:
    // normal, 90, 180, 270, flipped, flipped-90, flipped-180, flipped-270
    transform "normal"

    // グローバル座標空間での出力位置。
    // "focus-monitor-left" などの方向指定アクションやカーソル移動に影響する。
    // カーソルは直接隣接する出力間でのみ移動可能。
    // 配置にはスケールと回転を考慮する必要がある（論理ピクセル単位）。
    // 例: 3840x2160でscale 2.0の場合、論理サイズは1920x1080になるので、
    //      右隣に配置するにはxを1920に設定する。
    // 未設定または重複する場合は自動配置。
    position x=1280 y=0
}
```

---

## layout - ウィンドウ配置・サイズ設定

Wiki: https://yalter.github.io/niri/Configuration:-Layout

### 基本設定

```kdl
// ウィンドウ間のギャップ（論理ピクセル単位）。
gaps 16

// フォーカス変更時にカラムを中央揃えするタイミング:
// - "never"      : デフォルト。画面外のカラムにフォーカスすると画面端に寄せる。
// - "always"     : フォーカスしたカラムを常に中央揃え。
// - "on-overflow": 前のフォーカスカラムと一緒に表示しきれない場合に中央揃え。
center-focused-column "never"
```

### preset-column-widths

`switch-preset-column-width` (Mod+R) で切り替えるプリセット幅。

```kdl
preset-column-widths {
    // proportion: 出力幅に対する割合（ギャップ考慮）。
    // 例: proportion 0.25 を4つ並べるとぴったり収まる。
    // デフォルトは 1/3, 1/2, 2/3。
    proportion 0.33333
    proportion 0.5
    proportion 0.66667

    // fixed: 論理ピクセル単位での固定幅。
    // fixed 1920
}
```

### default-column-width

```kdl
// 新しいウィンドウのデフォルト幅。
default-column-width { proportion 0.5; }
// 空のブラケットにすると、ウィンドウ自身が初期幅を決定する。
// default-column-width {}
```

### preset-window-heights

```kdl
// `switch-preset-window-height` (Mod+Shift+R) で切り替えるプリセット高さ。
// preset-window-heights { }
```

### focus-ring - フォーカスリング

```kdl
// デフォルトではフォーカスリングとボーダーはウィンドウの背後に
// 矩形として描画される。半透明ウィンドウ越しに表示される。
// CSD（クライアント側装飾）を使うウィンドウは任意の形状を持つため。
//
// これが嫌な場合は `prefer-no-csd` を有効化する。
// CSDを省略するウィンドウの*周囲*にリング/ボーダーが描画される。
//
// ウィンドウルール `draw-border-with-background` でオーバーライドも可能。

focus-ring {
    // off                        // フォーカスリングを無効化

    // リングがウィンドウから外側に伸びる論理ピクセル数。
    width 4

    // 色の指定方法:
    // - CSS色名: "red"
    // - RGB hex: "#rgb", "#rgba", "#rrggbb", "#rrggbbaa"
    // - CSS記法: "rgb(255, 127, 0)", rgba(), hsl() など。

    // アクティブモニター上のリング色。
    active-color "#7fc8ff"

    // 非アクティブモニター上のリング色。
    // フォーカスリングはアクティブウィンドウのみに描画されるので、
    // inactive-color が見えるのは他のモニター上のみ。
    inactive-color "#505050"

    // グラデーションも使用可能（単色より優先される）。
    // CSS linear-gradient(angle, from, to) と同じ形式。
    // angle は省略可（デフォルト: 180 = 上から下）。
    // Web上のCSS linear-gradientツールで設定できる。
    // 色空間の変更もサポート（Wikiを参照）。
    //
    // active-gradient from="#80c8ff" to="#c7ff7f" angle=45

    // ウィンドウ単体ではなくワークスペース全体に対して
    // グラデーションを適用するには relative-to="workspace-view" を設定。
    //
    // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
}
```

### border - ボーダー

```kdl
// フォーカスリングに似ているが、常に表示される。
border {
    // 設定はフォーカスリングと同じ。
    // ボーダーを有効にする場合、フォーカスリングは無効にした方がよい。
    off

    width 4
    active-color "#ffc87f"
    inactive-color "#505050"

    // 注意を要求するウィンドウのボーダー色。
    urgent-color "#9b0000"

    // グラデーションは異なる色空間を使用可能。
    // 例: in="oklch longer hue" でパステルレインボーグラデーション。
    //
    // active-gradient from="#e5989b" to="#ffb4a2" angle=45 relative-to="workspace-view" in="oklch longer hue"
    // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
}
```

### shadow - ドロップシャドウ

```kdl
shadow {
    // on                         // シャドウを有効化

    // デフォルトではシャドウはウィンドウの周囲のみに描画され、背後には描画されない。
    // 以下を有効にするとウィンドウの背後にも描画される。
    //
    // 注意: niri はCSDウィンドウの角丸半径を知る方法がない。
    // 四角い角を前提とするため、CSDの角丸内にシャドウのアーティファクトが発生する。
    // この設定でそのアーティファクトを修正できる。
    //
    // 代わりに prefer-no-csd や geometry-corner-radius を設定する方法もある。
    // niri が角丸半径を把握でき、背後に描画せずとも正しくシャドウを描画できる。
    // CSD側のシャドウも除去される。
    //
    // draw-behind-window true

    // シャドウの見た目を変更可能。値は論理ピクセル単位で、
    // CSS box-shadow プロパティに対応。

    // ぼかし半径。
    softness 30

    // シャドウの拡張。
    spread 5

    // ウィンドウに対するシャドウのオフセット。
    offset x=0 y=5

    // シャドウの色と不透明度。
    color "#0007"
}
```

### struts - ストラッツ

```kdl
// layer-shellパネルと同様に、ウィンドウの占有領域を縮小する。
// 外側ギャップの一種。論理ピクセル単位で設定。
// 左右のストラッツは隣のウィンドウを常に表示させる。
// 上下のストラッツはlayer-shellパネルと通常のギャップに加えて外側ギャップを追加。
struts {
    // left 64
    // right 64
    // top 64
    // bottom 64
}
```

---

## spawn-at-startup - 起動時のプロセス実行

```kdl
// 起動時にプロセスを実行する。
// niri をセッションとして実行する場合、xdg-desktop-autostart がサポートされており、
// そちらの方が便利な場合がある。

// Waylandコンポジタ向けのバー waybar を起動。
spawn-at-startup "waybar"

// シェルコマンド（変数、パイプなど）を実行するには spawn-sh-at-startup を使用:
// spawn-sh-at-startup "qs -c ~/source/qs/MyAwesomeShell"
```

---

## hotkey-overlay - ホットキーオーバーレイ

```kdl
hotkey-overlay {
    // 起動時の「重要なホットキー」ポップアップを無効化。
    // skip-at-startup
}
```

---

## prefer-no-csd - CSD（クライアント側装飾）の抑制

```kdl
// クライアントにCSDを省略するよう要求する（可能な場合）。
// クライアントが明示的にCSDを要求した場合はそちらが優先される。
// ウィンドウがタイル化されていることも通知され、CSD側の角丸が除去される。
// 半透明ウィンドウの背後にボーダー/フォーカスリングが描画される問題も修正される。
// 有効/無効を切り替えた後、アプリの再起動が必要。
// prefer-no-csd
```

---

## screenshot-path - スクリーンショット保存先

```kdl
// スクリーンショットの保存パスを変更可能。
// 先頭の ~ はホームディレクトリに展開される。
// strftime(3) でフォーマットされ、日時が挿入される。
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

// null に設定するとディスクへの保存を無効化。
// screenshot-path null
```

---

## animations - アニメーション設定

Wiki: https://yalter.github.io/niri/Configuration:-Animations

```kdl
animations {
    // off          // すべてのアニメーションを無効化
    // slowdown 3.0 // すべてのアニメーションをこの倍率で減速。1未満で加速。
}
```

---

## window-rule - ウィンドウルール

Wiki: https://yalter.github.io/niri/Configuration:-Window-Rules

個々のウィンドウの動作を調整できる。

```kdl
// WezTermの初期設定バグの回避策。空の default-column-width を設定。
// この正規表現はデフォルト設定のため、誤検出を避けるため意図的に厳密にしている。
// app-id="wezterm" だけでも動作する。
window-rule {
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}

// Firefox のPicture-in-Pictureプレイヤーをデフォルトでフローティングにする。
// この正規表現はホスト版Firefox（app-id: "firefox"）と
// Flatpak版Firefox（app-id: "org.mozilla.firefox"）の両方に対応。
window-rule {
    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    open-floating true
}

// 例: 2つのパスワードマネージャーを画面キャプチャからブロック。
// （"/-" でコメントアウトされている）
/-window-rule {
    match app-id=r#"^org\.keepassxc\.KeePassXC$"#
    match app-id=r#"^org\.gnome\.World\.Secrets$"#

    block-out-from "screen-capture"

    // サードパーティのスクリーンショットツールでは表示したい場合はこちら:
    // block-out-from "screencast"
}

// 例: すべてのウィンドウに角丸を有効化。
// （"/-" でコメントアウトされている）
/-window-rule {
    geometry-corner-radius 12
    clip-to-geometry true
}
```

---

## binds - キーバインド

キーは `+` で区切られた修飾キーの後にXKBキー名を指定する。
特定のキーのXKB名を調べるには `wev` などのツールを使用。

`Mod` は特殊な修飾キーで、TTY上では Super、winit ウィンドウ上では Alt と等価。

ここでバインドできるほとんどのアクションは `niri msg action <アクション名>` でも実行可能。

### プログラム起動

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+T | spawn "alacritty" | ターミナルを開く |
| Mod+D | spawn "fuzzel" | アプリランチャーを起動 |
| Super+Alt+L | spawn "swaylock" | 画面をロック |
| Super+Alt+S | spawn-sh "pkill orca \|\| exec orca" | スクリーンリーダー(orca)を切り替え（ロック中も有効） |

### 音量・メディア（ロック中も有効）

| キー | アクション |
|------|-----------|
| XF86AudioRaiseVolume | 音量+10%（上限100%） |
| XF86AudioLowerVolume | 音量-10% |
| XF86AudioMute | ミュート切り替え |
| XF86AudioMicMute | マイクミュート切り替え |
| XF86AudioPlay | 再生/一時停止 |
| XF86AudioStop | 停止 |
| XF86AudioPrev | 前の曲 |
| XF86AudioNext | 次の曲 |

### 画面輝度（ロック中も有効）

| キー | アクション |
|------|-----------|
| XF86MonBrightnessUp | 輝度+10% |
| XF86MonBrightnessDown | 輝度-10% |

### オーバービュー

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+O | toggle-overview | ワークスペースとウィンドウの俯瞰表示を切り替え。左上ホットコーナーや4本指スワイプアップでも可能。 |

### ウィンドウ操作

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+Q | close-window | ウィンドウを閉じる |

### フォーカス移動

| キー | アクション |
|------|-----------|
| Mod+Left / Mod+H | 左のカラムにフォーカス |
| Mod+Down / Mod+J | 下のウィンドウにフォーカス |
| Mod+Up / Mod+K | 上のウィンドウにフォーカス |
| Mod+Right / Mod+L | 右のカラムにフォーカス |
| Mod+Home | 最初のカラムにフォーカス |
| Mod+End | 最後のカラムにフォーカス |

### ウィンドウ/カラム移動

| キー | アクション |
|------|-----------|
| Mod+Ctrl+Left / Mod+Ctrl+H | カラムを左に移動 |
| Mod+Ctrl+Down / Mod+Ctrl+J | ウィンドウを下に移動 |
| Mod+Ctrl+Up / Mod+Ctrl+K | ウィンドウを上に移動 |
| Mod+Ctrl+Right / Mod+Ctrl+L | カラムを右に移動 |
| Mod+Ctrl+Home | カラムを先頭に移動 |
| Mod+Ctrl+End | カラムを末尾に移動 |

代替コマンド（カラムの端でワークスペースをまたぐ移動）:
- `focus-window-or-workspace-down` / `focus-window-or-workspace-up`
- `move-window-down-or-to-workspace-down` / `move-window-up-or-to-workspace-up`

### モニター間フォーカス移動

| キー | アクション |
|------|-----------|
| Mod+Shift+Left / Mod+Shift+H | 左のモニターにフォーカス |
| Mod+Shift+Down / Mod+Shift+J | 下のモニターにフォーカス |
| Mod+Shift+Up / Mod+Shift+K | 上のモニターにフォーカス |
| Mod+Shift+Right / Mod+Shift+L | 右のモニターにフォーカス |

### モニター間カラム移動

| キー | アクション |
|------|-----------|
| Mod+Shift+Ctrl+Left / H | カラムを左のモニターに移動 |
| Mod+Shift+Ctrl+Down / J | カラムを下のモニターに移動 |
| Mod+Shift+Ctrl+Up / K | カラムを上のモニターに移動 |
| Mod+Shift+Ctrl+Right / L | カラムを右のモニターに移動 |

代替: ウィンドウ単体の移動 (`move-window-to-monitor-*`) や
ワークスペースごとの移動 (`move-workspace-to-monitor-*`) も可能。

### ワークスペース操作

| キー | アクション |
|------|-----------|
| Mod+Page_Down / Mod+U | 下のワークスペースにフォーカス |
| Mod+Page_Up / Mod+I | 上のワークスペースにフォーカス |
| Mod+Ctrl+Page_Down / Mod+Ctrl+U | カラムを下のワークスペースに移動 |
| Mod+Ctrl+Page_Up / Mod+Ctrl+I | カラムを上のワークスペースに移動 |
| Mod+Shift+Page_Down / Mod+Shift+U | ワークスペースを下に移動 |
| Mod+Shift+Page_Up / Mod+Shift+I | ワークスペースを上に移動 |
| Mod+1-9 | ワークスペース1-9にフォーカス |
| Mod+Ctrl+1-9 | カラムをワークスペース1-9に移動 |

niri は動的ワークスペースシステムなので、インデックス指定は「ベストエフォート」。
現在のワークスペース数より大きいインデックスは最下部（空の）ワークスペースを参照する。
例: ワークスペース2つ + 空1つ の状態で、インデックス3, 4, 5... はすべて3番目を参照。

代替: `focus-workspace-previous` で前回のワークスペースとの切り替え。

### マウスホイールバインド

natural-scroll 設定に応じて方向が変わる。

| キー | アクション | 備考 |
|------|-----------|------|
| Mod+WheelScrollDown/Up | ワークスペース移動 | cooldown-ms=150（高速切り替え防止） |
| Mod+Ctrl+WheelScrollDown/Up | カラムをワークスペース移動 | cooldown-ms=150 |
| Mod+WheelScrollRight/Left | カラム間フォーカス移動 | |
| Mod+Ctrl+WheelScrollRight/Left | カラム移動 | |
| Mod+Shift+WheelScrollDown/Up | カラム間フォーカス移動（横スクロール代替） | |
| Mod+Ctrl+Shift+WheelScrollDown/Up | カラム移動（横スクロール代替） | |

タッチパッドスクロール「ティック」もバインド可能（連続スクロールを離散間隔に分割）:
```
// Mod+TouchpadScrollDown { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"; }
// Mod+TouchpadScrollUp   { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"; }
```

### カラム内ウィンドウ操作

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+BracketLeft | consume-or-expel-window-left | 左隣のカラムに吸収/カラムから排出 |
| Mod+BracketRight | consume-or-expel-window-right | 右隣のカラムに吸収/カラムから排出 |
| Mod+Comma | consume-window-into-column | 右のウィンドウをカラム下部に吸収 |
| Mod+Period | expel-window-from-column | カラム下部のウィンドウを右に排出 |

### サイズ・レイアウト変更

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+R | switch-preset-column-width | プリセット幅を切り替え |
| Mod+Shift+R | switch-preset-window-height | プリセット高さを切り替え |
| Mod+Ctrl+R | reset-window-height | ウィンドウ高さをリセット |
| Mod+F | maximize-column | カラムを最大化 |
| Mod+Shift+F | fullscreen-window | フルスクリーン |
| Mod+Ctrl+F | expand-column-to-available-width | 他の可視カラムが使っていない空間を埋める |
| Mod+C | center-column | カラムを中央揃え |
| Mod+Ctrl+C | center-visible-columns | 可視カラムをすべて中央揃え |

### 幅・高さの微調整

ピクセル指定("1000")、ピクセル増減("-5"/"+5")、パーセント指定("25%")、パーセント増減("-10%"/"+10%")が可能。
ピクセルサイズは論理（スケール済み）ピクセル。scale 2.0 の出力で "100" を設定すると物理200ピクセルになる。

| キー | アクション |
|------|-----------|
| Mod+Minus | 幅-10% |
| Mod+Equal | 幅+10% |
| Mod+Shift+Minus | 高さ-10% |
| Mod+Shift+Equal | 高さ+10% |

### フローティング・タブ

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+V | toggle-window-floating | タイリング/フローティングを切り替え |
| Mod+Shift+V | switch-focus-between-floating-and-tiling | フローティングとタイリング間でフォーカス切り替え |
| Mod+W | toggle-column-tabbed-display | タブ表示モードを切り替え（縦タブとして表示） |

### レイアウト切り替え

```kdl
// xkbのオプションで同じホットキーを設定している場合は競合に注意。
// 両方設定すると二重切り替えが発生する。
// Mod+Space       { switch-layout "next"; }
// Mod+Shift+Space { switch-layout "prev"; }
```

### スクリーンショット

| キー | アクション |
|------|-----------|
| Print | 範囲選択スクリーンショット |
| Ctrl+Print | 画面全体のスクリーンショット |
| Alt+Print | ウィンドウのスクリーンショット |

### その他

| キー | アクション | 説明 |
|------|-----------|------|
| Mod+Escape | toggle-keyboard-shortcuts-inhibit | ショートカット抑制を切り替え。リモートデスクトップクライアント等がキー入力をそのまま転送するために抑制を要求する場合がある。バグのあるアプリに乗っ取られないためのエスケープハッチ（allow-inhibiting=false）。 |
| Mod+Shift+E | quit | niriを終了（確認ダイアログあり） |
| Ctrl+Alt+Delete | quit | niriを終了（確認ダイアログあり） |
| Mod+Shift+P | power-off-monitors | モニターをオフにする。マウス移動やキー入力で復帰。 |
| Mod+Shift+Slash | show-hotkey-overlay | 重要なホットキー一覧を表示（Mod+? と同等） |
