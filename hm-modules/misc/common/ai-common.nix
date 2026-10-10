{
  pkgs,
  ...
}:
{
  commands = {
  };
  skills = {
    agent-workspace-linux = "${pkgs.agent-workspace-linux}/share/skills/agent-workspace-linux/agent-workspace-linux";

    context7-cli = "${pkgs.ctx7}/share/skills/ctx7/context7-cli";

    mobile-automation = "${pkgs.mobile-mcp}/share/skills/mobile-automation";

    playwright-cli = "${pkgs.playwright-test}/lib/node_modules/playwright-core/lib/tools/skills/playwright-cli";

    cavecrew = "${pkgs.caveman-skills}/share/skills/cavecrew";
    caveman = "${pkgs.caveman-skills}/share/skills/caveman";
    caveman-commit = "${pkgs.caveman-skills}/share/skills/caveman-commit";
    caveman-compress = "${pkgs.caveman-skills}/share/skills/caveman-compress";
    caveman-discover = "${pkgs.caveman-skills}/share/skills/caveman-discover";
    caveman-evidence-review = "${pkgs.caveman-skills}/share/skills/caveman-evidence-review";
    caveman-explore = "${pkgs.caveman-skills}/share/skills/caveman-explore";
    caveman-help = "${pkgs.caveman-skills}/share/skills/caveman-help";
    caveman-learn = "${pkgs.caveman-skills}/share/skills/caveman-learn";
    caveman-manage = "${pkgs.caveman-skills}/share/skills/caveman-manage";
    caveman-optimize = "${pkgs.caveman-skills}/share/skills/caveman-optimize";
    caveman-review = "${pkgs.caveman-skills}/share/skills/caveman-review";
    caveman-setup = "${pkgs.caveman-skills}/share/skills/caveman-setup";
    caveman-stats = "${pkgs.caveman-skills}/share/skills/caveman-stats";
    investigate-first = "${pkgs.caveman-skills}/share/skills/investigate-first";
    lean-build = "${pkgs.caveman-skills}/share/skills/lean-build";
    megacave = "${pkgs.caveman-skills}/share/skills/megacave";
    migration = "${pkgs.caveman-skills}/share/skills/migration";
    safe-refactor = "${pkgs.caveman-skills}/share/skills/safe-refactor";
    surgical-patch = "${pkgs.caveman-skills}/share/skills/surgical-patch";
    ultracave = "${pkgs.caveman-skills}/share/skills/ultracave";
    verify-and-stop = "${pkgs.caveman-skills}/share/skills/verify-and-stop";

    ask-matt = "${pkgs.matt-pocock-skills}/share/skills/ask-matt";
    codebase-design = "${pkgs.matt-pocock-skills}/share/skills/codebase-design";
    code-review = "${pkgs.matt-pocock-skills}/share/skills/code-review";
    diagnosing-bugs = "${pkgs.matt-pocock-skills}/share/skills/diagnosing-bugs";
    domain-modeling = "${pkgs.matt-pocock-skills}/share/skills/domain-modeling";
    grill-with-docs = "${pkgs.matt-pocock-skills}/share/skills/grill-with-docs";
    implement = "${pkgs.matt-pocock-skills}/share/skills/implement";
    implement-spec = "${pkgs.matt-pocock-skills}/share/skills/implement-spec";
    improve-codebase-architecture = "${pkgs.matt-pocock-skills}/share/skills/improve-codebase-architecture";
    prototype = "${pkgs.matt-pocock-skills}/share/skills/prototype";
    pr = "${pkgs.matt-pocock-skills}/share/skills/pr";
    research = "${pkgs.matt-pocock-skills}/share/skills/research";
    retro = "${pkgs.matt-pocock-skills}/share/skills/retro";
    setup-matt-pocock-skills = "${pkgs.matt-pocock-skills}/share/skills/setup-matt-pocock-skills";
    tdd = "${pkgs.matt-pocock-skills}/share/skills/tdd";
    to-spec = "${pkgs.matt-pocock-skills}/share/skills/to-spec";
    to-tickets = "${pkgs.matt-pocock-skills}/share/skills/to-tickets";
    triage = "${pkgs.matt-pocock-skills}/share/skills/triage";
    wayfinder = "${pkgs.matt-pocock-skills}/share/skills/wayfinder";
    wizard = "${pkgs.matt-pocock-skills}/share/skills/wizard";
    grilling = "${pkgs.matt-pocock-skills}/share/skills/grilling";
    grill-me = "${pkgs.matt-pocock-skills}/share/skills/grill-me";
    handoff = "${pkgs.matt-pocock-skills}/share/skills/handoff";
    teach = "${pkgs.matt-pocock-skills}/share/skills/teach";
    to-questionnaire = "${pkgs.matt-pocock-skills}/share/skills/to-questionnaire";
    wait-what = "${pkgs.matt-pocock-skills}/share/skills/wait-what";
    writing-for-agents = "${pkgs.matt-pocock-skills}/share/skills/writing-for-agents";
  };
}
