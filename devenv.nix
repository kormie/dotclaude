{ pkgs, lib, ... }:

let
  shellPackages = with pkgs; [
    actionlint
    bun
    git
    jq
    python311
    shellcheck
    shfmt
  ];
  testPackages = with pkgs; [ stow ];
in
{
  packages = shellPackages;

  languages.python = {
    enable = true;
    package = pkgs.python311;
  };

  scripts = {
    "docs:dev".exec = "bun run --cwd docs docs:dev";
    "docs:build".exec = "bun run --cwd docs docs:build";
    "lint:shell".exec = ''shellcheck scripts/*.sh bin/claude-switch'';
    "lint:format".exec = ''shfmt -d scripts/*.sh bin/claude-switch'';
    "lint:actions".exec = "actionlint";
    "flipper:generate".exec = "python3 flipper/generate_assets.py";
    "flipper:pack".exec = "python3 flipper/pack.py";
  };

  # Shell activation is deliberately informational only. Potentially destructive
  # setup and host-management commands remain explicit contributor actions.
  enterShell = ''
    echo "DotClaude tasks: docs:dev, docs:build, lint:shell, lint:format, lint:actions, flipper:generate, flipper:pack"
  '';

  # GNU Stow is intentionally test-only, rather than part of the interactive
  # development shell. This checks the Nix-provided binary without touching HOME.
  enterTest = ''
    export PATH="${lib.makeBinPath testPackages}:$PATH"
    stow --version >/dev/null
  '';
}
