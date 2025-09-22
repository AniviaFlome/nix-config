default:
  @just --list

age-gen:
    mkdir -p ~/.config/sops/age \
    nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt

rekey:
  for file in $(ls sops/*.yaml); do \
    sops updatekeys -y $file; \
  done && \
    (pre-commit run --all-files || true) && \
    git add -u && (git commit -m "chore: rekey" || true) && git push

sync USER HOST PATH:
    rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}} -oport=22" . {{USER}}@{{HOST}}:{{PATH}}/nix-secrets
