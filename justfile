default:
  @just --list

rekey:
  for file in $(ls sops/*.yaml); do \
    sops updatekeys -y $file; \
  done && \
    (pre-commit run --all-files || true) && \
    git add -u && (git commit -m "chore: rekey" || true) && git push

sync USER HOST PATH:
    rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}} -oport=22" . {{USER}}@{{HOST}}:{{PATH}}/nix-secrets

age-gen:
    nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt \
    nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
