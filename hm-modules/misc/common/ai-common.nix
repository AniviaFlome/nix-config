{
  inputs,
  ...
}:
{
  commands = {

  };
  context = "";
  skills = {
    canvas-design = "${inputs.anthropics-skills}/skills/canvas-design";
    docx = "${inputs.anthropics-skills}/skills/docx";
    frontend-design = "${inputs.anthropics-skills}/skills/frontend-design";
    pdf = "${inputs.anthropics-skills}/skills/pdf";
    pptx = "${inputs.anthropics-skills}/skills/pptx";
    webapp-testing = "${inputs.anthropics-skills}/skills/webapp-testing";
  };
}
