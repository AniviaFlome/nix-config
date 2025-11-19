[doc('List just options')]
default:
  @just --list

[doc('Generate age keys')]
age-gen:
  mkdir -p ~/.config/sops/age \
  nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt

[doc('Nixos rebuild boot')]
boot SYSTEM:
  nh {{SYSTEM}} boot

[doc('Check for errors in the configuration')]
check:
  nix shell nixpkgs#statix nixpkgs#deadnix -c statix; deadnix

[doc('Nixos rebuild switch')]
switch SYSTEM:
  nh {{SYSTEM}} switch

[doc('Code formatting')]
format:
  nix fmt

[doc('Clean up disk space')]
garbage OPTIONS:
  nh clean {{OPTIONS}}

[doc('Build normal iso')]
iso-normal:
  nix build .#nixosConfigurations.liveiso.config.system.build.isoImage

[doc('Build minimal iso')]
iso-minimal:
  nix build .#nixosConfigurations.liveiso-minimal.config.system.build.isoImage

[doc('Update sops-nix keys')]
rekey:
  for file in $(ls sops/*.yaml); do \
    sops updatekeys -y $file; \
  done && \
    (pre-commit run --all-files || true) && \
    git add -u && (git commit -m "chore: rekey" || true) && git push

[doc('Sync configuration with remote')]
sync USER HOST PATH:
  rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}} -oport=22" . {{USER}}@{{HOST}}:{{PATH}}/nix-config

[doc('Check percentage of nixpkgs cached')]
weather HOST:
  nix shell nixpkgs#nix-weather -c nix-weather --name {{HOST}} --config {{justfile_directory()}}
