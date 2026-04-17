{ inputs, pkgs, ... }:
let
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./tui/claude-code.nix
    ./tui/tmux.nix
  ];

  home.packages = with pkgs; [
    aria2
    btop
    llmAgentsPkgs.cli-proxy-api
    cowsay
    dnsutils
    ethtool
    eza
    fastfetch
    file
    ghq
    gawk
    glow
    gnupg
    gnused
    gnutar
    iftop
    ipcalc
    iperf3
    iotop
    jq
    ldns
    lm_sensors
    lsof
    ltrace
    mtr
    nix-output-monitor
    nmap
    p7zip
    pciutils
    ripgrep
    socat
    strace
    sysstat
    tree
    unzip
    usbutils
    which
    xz
    yq-go
    zip
    zstd
  ];
}
