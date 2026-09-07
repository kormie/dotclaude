SHELL := /bin/bash
.DEFAULT_GOAL := ci

SHELL_FILES := bin/claude-switch $(wildcard scripts/*.sh) scripts/tmux-claude-workspace

.PHONY: ci lint shell-parse shellcheck shfmt json actions docs docs-install docs-build stow-layout flipper flipper-generate flipper-pack

# Native, repository-only equivalents of the devenv tasks. These targets do
# not invoke Stow, an OS package manager, an installer, or write beneath HOME.
ci: lint docs flipper

lint: shell-parse shellcheck shfmt json actions stow-layout

shell-parse:
	@for file in $(SHELL_FILES); do bash -n "$$file"; done

shellcheck:
	shellcheck --severity=error $(SHELL_FILES)

shfmt:
	shfmt -d -i 4 $(SHELL_FILES)

json:
	@git ls-files -co --exclude-standard '*.json' | python3 -c 'import json,sys; from pathlib import Path; files=[Path(line.rstrip()) for line in sys.stdin if line.rstrip()]; [json.loads(p.read_text()) for p in files]; print(f"validated {len(files)} JSON file(s)")'

actions:
	actionlint

docs: docs-build

docs-install:
	cd docs && bun install --frozen-lockfile

docs-build: docs-install
	cd docs && bun run docs:build

stow-layout:
	@python3 -c 'from pathlib import Path; root=Path("stow"); packages=sorted(p for p in root.iterdir() if p.is_dir()); assert packages, "no Stow packages found"; empty=[str(p) for p in packages if not any(x.is_file() or x.is_symlink() for x in p.rglob("*"))]; assert not empty, "empty Stow packages: "+", ".join(empty); bad=[str(x) for p in packages for x in p.rglob("*") if x.is_symlink() and not x.resolve(strict=False).is_relative_to(p.resolve())]; assert not bad, "links escaping package roots: "+", ".join(bad); print(f"validated {len(packages)} Stow source package(s)")'

flipper: flipper-pack

flipper-generate:
	@tmp=$$(mktemp -d); trap 'rm -rf "$$tmp"' EXIT; cp -R flipper "$$tmp/flipper"; python3 "$$tmp/flipper/generate_assets.py"; test -s "$$tmp/flipper/preview.png"

flipper-pack: flipper-generate
	@tmp=$$(mktemp -d); trap 'rm -rf "$$tmp"' EXIT; cp -R flipper "$$tmp/flipper"; python3 "$$tmp/flipper/generate_assets.py"; python3 "$$tmp/flipper/pack.py"; test -d "$$tmp/flipper/dist/kormie"
