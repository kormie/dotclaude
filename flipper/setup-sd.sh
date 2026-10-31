#!/usr/bin/env bash
#
# setup-sd.sh — stage Flipper Zero SD content into a /ext-shaped folder you can
# copy onto the card in one pass (card reader or qFlipper — both merge safely).
# Idempotent: re-run anytime to refresh to the latest upstream.
#
# Stages (default: all):
#   --irdb     Flipper-IRDB           -> infrared/      universal IR remote DB
#   --dict     expanded MIFARE dict   -> nfc/assets/mf_classic_dict_user.nfc
#   --amiibo   FlipperAmiibo library  -> nfc/amiibo/     pre-converted .nfc amiibo
#   --clean    wipe the staging dir first
#
# Examples:
#   ./setup-sd.sh                     # everything
#   ./setup-sd.sh --irdb --dict       # pick components
#   STAGE=/tmp/flip ./setup-sd.sh     # custom staging location
#   DICT_URL=https://… ./setup-sd.sh  # point the dict at a bigger community list
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGE="${STAGE:-$here/sd-staging}"

IRDB_REPO="${IRDB_REPO:-https://github.com/Lucaslhm/Flipper-IRDB.git}"
AMIIBO_REPO="${AMIIBO_REPO:-https://github.com/Gioman101/FlipperAmiibo.git}"
# Momentum's bundled MIFARE Classic dictionary, pinned to the firmware you run.
DICT_URL="${DICT_URL:-https://raw.githubusercontent.com/Next-Flip/Momentum-Firmware/mntm-012/applications/main/nfc/resources/nfc/assets/mf_classic_dict.nfc}"

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; }

do_irdb=0; do_amiibo=0; do_dict=0; clean=0
for arg in "$@"; do
  case "$arg" in
    --all)            do_irdb=1; do_amiibo=1; do_dict=1 ;;
    --irdb)           do_irdb=1 ;;
    --amiibo)         do_amiibo=1 ;;
    --dict|--nfc-dict) do_dict=1 ;;
    --clean)          clean=1 ;;
    -h|--help)        usage; exit 0 ;;
    *) echo "unknown option: $arg" >&2; usage; exit 2 ;;
  esac
done
# no component chosen → do all
if [ $((do_irdb + do_amiibo + do_dict)) -eq 0 ]; then do_irdb=1; do_amiibo=1; do_dict=1; fi

require() { command -v "$1" >/dev/null 2>&1 || { echo "error: missing required tool '$1'" >&2; exit 1; }; }
require curl                                                  # dict download
if [ "$do_irdb" -eq 1 ] || [ "$do_amiibo" -eq 1 ]; then       # repo cloning
  require git; require rsync
fi

[ "$clean" -eq 1 ] && { echo "Wiping $STAGE"; rm -rf "$STAGE"; }
mkdir -p "$STAGE"

# shallow-clone a repo and mirror its content (minus VCS/meta) into $2
stage_repo() {
  local repo="$1" dest="$2" tmp
  tmp="$(mktemp -d)"
  echo "  cloning $repo"
  git clone --depth 1 --quiet "$repo" "$tmp"
  mkdir -p "$dest"
  rsync -a --delete \
    --exclude '.git' --exclude '.github' --exclude '.DS_Store' \
    --exclude '*.md' --exclude 'LICENSE*' --exclude '.gitignore' --exclude '.gitattributes' \
    "$tmp"/ "$dest"/
  rm -rf "$tmp"
}

if [ "$do_irdb" -eq 1 ]; then
  echo "[IRDB]  Flipper-IRDB -> infrared/"
  stage_repo "$IRDB_REPO" "$STAGE/infrared"
  echo "        $(find "$STAGE/infrared" -name '*.ir' | wc -l | tr -d ' ') .ir files staged"
fi

if [ "$do_dict" -eq 1 ]; then
  echo "[DICT]  MIFARE dict -> nfc/assets/mf_classic_dict_user.nfc"
  mkdir -p "$STAGE/nfc/assets"
  curl -fsSL "$DICT_URL" -o "$STAGE/nfc/assets/mf_classic_dict_user.nfc"
  echo "        $(grep -c . "$STAGE/nfc/assets/mf_classic_dict_user.nfc" | tr -d ' ') keys staged"
fi

if [ "$do_amiibo" -eq 1 ]; then
  echo "[AMIIBO] FlipperAmiibo -> nfc/amiibo/"
  stage_repo "$AMIIBO_REPO" "$STAGE/nfc/amiibo"
  echo "        $(find "$STAGE/nfc/amiibo" -name '*.nfc' | wc -l | tr -d ' ') amiibo .nfc files staged"
fi

echo
echo "Staging ready: $STAGE  ($(du -sh "$STAGE" 2>/dev/null | cut -f1))"
cat <<EOF

Copy onto the SD card (/ext = SD root). Both ways MERGE — they will NOT wipe
your existing nfc saves:

  # card reader (replace NAME with your SD volume):
  rsync -av "$STAGE"/ /Volumes/NAME/

  # or qFlipper File Manager: drag the folders into /ext

WARNING: do NOT drag the top-level 'nfc' folder onto the card in Finder —
Finder REPLACES same-named folders instead of merging and would delete your
saved cards. Use the rsync command above (or qFlipper), which merge safely.

Then on the Flipper:
  - IR remotes: Infrared > browse the new database
  - MIFARE:     NFC > Read runs the expanded dictionary automatically
  - Amiibo:     NFC > Saved > amiibo  (emulate, or write to NTAG215)

The app loadout is NOT file-copied — install it from the Apps catalog
(mobile app 'Apps' tab / qFlipper): NFC access-control auditor, Metroflip,
NFC Magic, Spectrum Analyzer, POCSAG, Weather Station, TPMS, Bad-KB,
GPIO/I2C scanner, WiFi Marauder, FlipWiFi/FlipStore, Flipper Authenticator
(TOTP), DOOM, Wolfenduino.
EOF
