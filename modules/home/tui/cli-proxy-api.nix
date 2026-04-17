{ inputs, pkgs, config, ... }:
let
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  configPath = "${config.xdg.configHome}/cli-proxy-api/config.yaml";
in
{
  home.packages = [ llmAgentsPkgs.cli-proxy-api ];

  xdg.configFile."cli-proxy-api/config.yaml".text = ''
    host: "127.0.0.1"
    port: 8317
    auth-dir: "${config.home.homeDirectory}/.cli-proxy-api"
    api-keys:
      - "sk-dummy"
    remote-management:
      allow-remote: false
      secret-key: ""
  '';

  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://127.0.0.1:8317";
    ANTHROPIC_AUTH_TOKEN = "sk-dummy";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "gpt-5.4(high)";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "gpt-5.4(medium)";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "gpt-5.4(low)";
  };

  systemd.user.services.cli-proxy-api = {
    Unit = {
      Description = "CLI Proxy API (OpenAI/Gemini/Claude compatible proxy)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${llmAgentsPkgs.cli-proxy-api}/bin/cli-proxy-api -config ${configPath}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
