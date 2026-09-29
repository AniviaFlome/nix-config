{
  inputs,
  pkgs,
  ...
}:
{
  commands = {

  };
  skills = {
    canvas-design = "${inputs.anthropics-skills}/skills/canvas-design";
    docx = "${inputs.anthropics-skills}/skills/docx";
    frontend-design = "${inputs.anthropics-skills}/skills/frontend-design";
    pdf = "${inputs.anthropics-skills}/skills/pdf";
    pptx = "${inputs.anthropics-skills}/skills/pptx";
    webapp-testing = "${inputs.anthropics-skills}/skills/webapp-testing";
    caveman = "${inputs.caveman}/skills/caveman";
    caveman-commit = "${inputs.caveman}/skills/caveman-commit";
    caveman-compress = "${inputs.caveman}/skills/caveman-compress";
    caveman-help = "${inputs.caveman}/skills/caveman-help";
    caveman-review = "${inputs.caveman}/skills/caveman-review";
    caveman-stats = "${inputs.caveman}/skills/caveman-stats";
    agent-workspace-linux = "${inputs.agent-workspace}/skills/agent-workspace-linux";
    computer-use-linux = "${inputs.computer-use}/skills/computer-use-linux";
    context7-mcp = "${inputs.context7}/skills/context7-mcp";
    playwright-cli = "${pkgs.playwright-test}/lib/node_modules/playwright-core/lib/tools/skills/playwright-cli";
  };

  home.packages = with pkgs; [
    playwright-test
  ];
}
