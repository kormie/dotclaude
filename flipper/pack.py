#!/usr/bin/env python3
"""
Non-interactive wrapper around Momentum's scripts/asset_packer.py.

CI (and you, locally) use this to compile the source PNG pack under
`asset_packs/` into the on-device `.bm`/`.bmx`/binary-meta format that the
Flipper actually loads, written to `dist/`.

The packer itself is NOT vendored. It is downloaded pinned to a firmware tag
(default: the firmware you run, mntm-012) so the output always matches the
device. Override with the MOMENTUM_REF env var.

Usage:
    pip install Pillow heatshrink2
    python3 pack.py                  # -> flipper/dist/kormie/...
"""

import importlib.util
import os
import pathlib
import sys
import urllib.request

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE / "asset_packs"
DIST = HERE / "dist"
REF = os.environ.get("MOMENTUM_REF", "mntm-012")
PACKER_URL = (
    f"https://raw.githubusercontent.com/Next-Flip/Momentum-Firmware/{REF}/scripts/asset_packer.py"
)


def load_packer() -> "module":
    """Fetch asset_packer.py at the pinned ref and import it without running
    its interactive __main__ block (guarded by __name__)."""
    local = HERE / ".asset_packer.py"
    if not local.is_file():
        print(f"Fetching asset_packer.py @ {REF}")
        with urllib.request.urlopen(PACKER_URL) as r:
            local.write_bytes(r.read())
    spec = importlib.util.spec_from_file_location("asset_packer", local)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main() -> int:
    if not SRC.is_dir():
        print(f"No source packs at {SRC}", file=sys.stderr)
        return 1
    DIST.mkdir(parents=True, exist_ok=True)
    packer = load_packer()
    packer.pack(SRC, DIST, logger=print)
    packed = sorted(p.name for p in DIST.iterdir() if p.is_dir())
    print(f"\nPacked {len(packed)} pack(s) to {DIST}: {', '.join(packed)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
