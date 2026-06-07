#!/usr/bin/env dash
# Initialize a dev environment from the-nix-way/dev-templates
# Usage: nixdev [template]

set -eu

TEMPLATES="bun c-cpp clojure csharp cue deno dhall elixir elm empty gleam go hashi haskell haxe java jupyter kotlin latex lean4 nickel nim nix node ocaml odin opa php platformio protobuf pulumi purescript python r ruby rust scala shell swi-prolog swift typst vlang zig"

if [ -n "${1:-}" ]; then
  TEMPLATE="$1"
else
  TEMPLATE=$(echo "$TEMPLATES" | tr ' ' '\n' | fzf --prompt="dev template> " --height=~40% --layout=reverse)
fi

if [ -z "$TEMPLATE" ]; then
  echo "No template selected."
  exit 1
fi

if ! echo "$TEMPLATES" | grep -qw "$TEMPLATE"; then
  echo "Unknown template: $TEMPLATE"
  echo "Available: $TEMPLATES"
  exit 1
fi

echo "Initializing $TEMPLATE dev environment..."
nix flake init -t "github:the-nix-way/dev-templates#$TEMPLATE"
