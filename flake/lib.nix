{
  inputs,
  lib,
  self,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config.flake.lib = inputs.nixpkgs.lib.extend (
    _final: prev: {
      relativeToRoot = prev.path.append self;
    }
  );
}
