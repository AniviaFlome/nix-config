{
  inputs,
  pkgs,
  ...
}:
{
  commands = {
  };
  skills = {
    agent-workspace-linux = "${pkgs.agent-workspace-linux}/share/skills/agent-workspace-linux/agent-workspace-linux";

    context7-cli = "${pkgs.ctx7}/share/skills/ctx7/context7-cli";

    playwright-cli = "${pkgs.playwright-test}/lib/node_modules/playwright-core/lib/tools/skills/playwright-cli";

    caveman-commit = "${inputs.caveman}/skills/caveman-commit";
    caveman-help = "${inputs.caveman}/skills/caveman-help";

    ask-matt = "${inputs.mattpocock-skills}/skills/engineering/ask-matt";
    codebase-design = "${inputs.mattpocock-skills}/skills/engineering/codebase-design";
    code-review = "${inputs.mattpocock-skills}/skills/engineering/code-review";
    diagnosing-bugs = "${inputs.mattpocock-skills}/skills/engineering/diagnosing-bugs";
    domain-modeling = "${inputs.mattpocock-skills}/skills/engineering/domain-modeling";
    grill-with-docs = "${inputs.mattpocock-skills}/skills/engineering/grill-with-docs";
    implement = "${inputs.mattpocock-skills}/skills/engineering/implement";
    implement-spec = "${inputs.mattpocock-skills}/skills/engineering/implement-spec";
    improve-codebase-architecture = "${inputs.mattpocock-skills}/skills/engineering/improve-codebase-architecture";
    prototype = "${inputs.mattpocock-skills}/skills/engineering/prototype";
    pr = "${inputs.mattpocock-skills}/skills/engineering/pr";
    retro = "${inputs.mattpocock-skills}/skills/engineering/retro";
    setup-matt-pocock-skills = "${inputs.mattpocock-skills}/skills/engineering/setup-matt-pocock-skills";
    tdd = "${inputs.mattpocock-skills}/skills/engineering/tdd";
    to-spec = "${inputs.mattpocock-skills}/skills/engineering/to-spec";
    to-tickets = "${inputs.mattpocock-skills}/skills/engineering/to-tickets";
    triage = "${inputs.mattpocock-skills}/skills/engineering/triage";
    wayfinder = "${inputs.mattpocock-skills}/skills/engineering/wayfinder";
    wizard = "${inputs.mattpocock-skills}/skills/engineering/wizard";
    grilling = "${inputs.mattpocock-skills}/skills/productivity/grilling";
    grill-me = "${inputs.mattpocock-skills}/skills/productivity/grill-me";
    handoff = "${inputs.mattpocock-skills}/skills/productivity/handoff";
    teach = "${inputs.mattpocock-skills}/skills/productivity/teach";
    to-questionnaire = "${inputs.mattpocock-skills}/skills/productivity/to-questionnaire";
    wait-what = "${inputs.mattpocock-skills}/skills/productivity/wait-what";
    writing-for-agents = "${inputs.mattpocock-skills}/skills/productivity/writing-for-agents";
  };

  packages = with pkgs; [
    agent-workspace-linux
    ctx7
    playwright-test
  ];
}
