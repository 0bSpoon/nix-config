{ inputs, pkgs, ... }:
let
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.claude-code = {
    enable = true;
    package = llmAgentsPkgs.claude-code;
  };
}
