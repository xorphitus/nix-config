# OpenAI Codex CLI policy. managed_config.toml is deliberately not used:
# it loads above per-session parameters and would break the Claude Code
# Codex plugin's per-thread approval/sandbox settings.
{
  environment.etc = {
    "codex/config.toml".source = ./config/codex/config.toml;
    "codex/requirements.toml".source = ./config/codex/requirements.toml;
  };
}
