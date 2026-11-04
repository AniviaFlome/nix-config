{
  pkgs,
  ...
}:
{
  commands = {
    i-have-adhd = builtins.readFile "${pkgs.i-have-adhd}/share/opencode-commands/i-have-adhd.md";
    impeccable = builtins.readFile "${pkgs.impeccable}/share/opencode-commands/impeccable.md";
    idea-gen = builtins.readFile ./prompts/idea-gen.md;
    mobile-app-build = builtins.readFile ./prompts/mobile-app-build.md;
    repo-analysis = builtins.readFile ./prompts/repo-analysis.md;
  };
  skills = {
    agent-workspace-linux = "${pkgs.agent-workspace-linux}/share/skills/agent-workspace-linux/agent-workspace-linux";
    context7-cli = "${pkgs.ctx7}/share/skills/ctx7/context7-cli";
    mobile-automation = "${pkgs.mobile-mcp}/share/skills/mobile-automation";
    playwright-cli = "${pkgs.playwright-test}/lib/node_modules/playwright-core/lib/tools/skills/playwright-cli";
    i-have-adhd = "${pkgs.i-have-adhd}/share/skills/i-have-adhd";
    impeccable = "${pkgs.impeccable}/share/skills/impeccable";
  };
}
