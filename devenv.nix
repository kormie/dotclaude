{ pkgs, ... }:

let
  shellInputs = [ "bin/claude-switch" "scripts" ];
  repoInputs = [ "devenv.nix" "Makefile" ];
  mkCheck = target: inputs: {
    exec = "make ${target}";
    execIfModified = inputs ++ repoInputs;
  };
in
{
  # Repository QA only. Nothing in this environment installs host packages,
  # invokes Stow, runs an installer, or writes beneath $HOME.
  packages = with pkgs; [
    actionlint
    git
    gnumake
    shellcheck
    shfmt
    (python3.withPackages (ps: with ps; [ heatshrink2 pillow ]))
  ];

  # languages.javascript.enable must be set too: the module only adds its
  # packages (including Bun) to the shell when the language itself is enabled.
  languages.javascript = {
    enable = true;
    bun.enable = true;
    nodejs.enable = false; # docs build runs on Bun alone
  };
  languages.python.enable = true;

  tasks = {
    # The qa:* tasks are the full, deterministic entry points used by CI and
    # releases. local:* uses execIfModified strictly as a developer shortcut.
    "qa:shell-parse".exec = "make shell-parse";
    "qa:shellcheck".exec = "make shellcheck";
    "qa:shfmt".exec = "make shfmt";
    "qa:json".exec = "make json";
    "qa:actions".exec = "make actions";
    "qa:docs-install".exec = "make docs-install";
    "qa:docs-build" = {
      after = [ "qa:docs-install" ];
      exec = "make docs-build";
    };
    "qa:stow-layout".exec = "make stow-layout";
    "qa:flipper-generate".exec = "make flipper-generate";
    "qa:flipper-pack" = {
      after = [ "qa:flipper-generate" ];
      exec = "make flipper-pack";
    };

    "local:shell-parse" = mkCheck "shell-parse" shellInputs;
    "local:shellcheck" = mkCheck "shellcheck" shellInputs;
    "local:shfmt" = mkCheck "shfmt" shellInputs;
    "local:json" = mkCheck "json" [ ".github" "docs/package.json" "docs/bun.lock" "stow" ];
    "local:actions" = mkCheck "actions" [ ".github/workflows" ];
    "local:docs" = mkCheck "docs" [ "docs" ];
    "local:stow-layout" = mkCheck "stow-layout" [ "stow" ];
    "local:flipper" = mkCheck "flipper" [ "flipper" ];

    "ci:lint" = {
      after = [
        "qa:shell-parse"
        "qa:shellcheck"
        "qa:shfmt"
        "qa:json"
        "qa:actions"
        "qa:stow-layout"
      ];
      exec = ''echo "Static repository lint passed."'';
    };
    "ci:all" = {
      after = [ "ci:lint" "qa:docs-build" "qa:flipper-pack" ];
      before = [ "devenv:enterTest" ];
      exec = ''echo "All repository QA passed."'';
    };
  };
}
