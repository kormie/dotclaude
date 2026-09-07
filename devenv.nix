{ pkgs, ... }:

{
  # This environment is intentionally limited to repository development. Host
  # setup and dotfile deployment remain explicit operations under scripts/.
  packages = with pkgs; [
    git
    shellcheck
    shfmt
  ];

  languages.javascript.bun.enable = true;
  languages.python.enable = true;

  tasks = {
    "docs:build".exec = ''
      cd docs
      bun install --frozen-lockfile
      bun run docs:build
    '';

    "shell:lint".exec = ''
      shell_files=(
        bin/claude-switch
        scripts/*.sh
        scripts/tmux-claude-workspace
      )
      shellcheck --severity=error "''${shell_files[@]}"
      for file in "''${shell_files[@]}"; do
        shfmt --to-json < "$file" > /dev/null
      done
    '';

    "flipper:validate".exec = ''
      python - <<'PY'
      import ast
      from pathlib import Path

      sources = sorted(Path("flipper").glob("*.py"))
      if not sources:
          raise SystemExit("no Flipper Python sources found")
      for source in sources:
          ast.parse(source.read_text(), filename=str(source))
          print(f"validated {source}")
      PY
    '';

    "check:all" = {
      after = [
        "docs:build"
        "shell:lint"
        "flipper:validate"
      ];
      before = [ "devenv:enterTest" ];
      exec = ''echo "All contributor checks passed."'';
    };
  };
}
