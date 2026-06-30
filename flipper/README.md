# `kormie` — Flipper Zero asset pack

A personal [Momentum firmware](https://github.com/Next-Flip/Momentum-Firmware)
asset pack + custom passport, themed to match the rest of this dotfiles repo:
terminal/hacker aesthetic, KOHO palette, `kormie@flipper:~$` prompt, vim `hjkl`.
Built to pair with the decked-out Momentum (`mntm-012`) build.

Inspired by [Kuronons/FZ_graphics](https://github.com/Kuronons/FZ_graphics).

## What's in it

| Asset | File | Notes |
|-------|------|-------|
| **Passport background** | `Icons/Passport/passport_128x64.png` | Framed "terminal" border + corner brackets + stock-style barcode strip. Deliberately leaves the dolphin/name/level regions clear so firmware text stays readable. |
| **Mood faces** | `Icons/Passport/passport_{happy,okay,bad}_46x49.png` | A CRT-monitor mascot ("Termy"): shades + grin when you're a high-level good-mood dolphin, neutral when okay, `x_x` + frown when butthurt. |
| **Idle animation** | `Anims/kormie_whoami/` | A terminal types `whoami` and answers `> hacker dolphin` / `> KOHO // hjkl`, blinking block cursor. 9 frames @ 3 fps. |

All source art is **1-bit black-on-white PNG**. Momentum's packer inverts to the
device bit convention, so black source pixels render as the dark pixels on the
Flipper's orange screen.

## Regenerating / editing the art

The pack is fully reproducible — edit the drawing code and re-run:

```bash
cd flipper
python3 generate_assets.py     # needs Pillow:  pip install Pillow
```

This rewrites everything under `asset_packs/kormie/` and a scaled-up
`preview.png` contact sheet for eyeballing the art before you flash it.

## Installing on the Flipper (Momentum)

The files here are the **source** pack. Momentum needs them packed to `.bmx`
first. Two ways:

### Option A — official packer (recommended)

```bash
# from a checkout of Next-Flip/Momentum-Firmware
cp -r /path/to/dotclaude/flipper/asset_packs/kormie ./
python3 scripts/asset_packer.py        # packs every folder next to the script
```

Copy the resulting packed `kormie` folder to your SD card under
`/ext/asset_packs/` (mount the SD directly — qFlipper is slow for bulk copies).

### Option B — online packer

Drop the `asset_packs/kormie` folder into the Momentum asset-pack web packer and
download the packed result, then copy it to `/ext/asset_packs/`.

### Activate it

1. **Apps → ... or Settings → Momentum → Asset Pack →** select `kormie`. Reboot.
2. **Set the passport name** (this is a device setting, not part of the pack):
   **Settings → Desktop → ... Passport / Name →** set to `kormie`.
3. The mood faces and `whoami` idle animation show up on the desktop/passport
   once the pack is active and the animation weight wins a roll.

## Layout

```
flipper/
├── generate_assets.py        # reproducible generator (Pillow)
├── preview.png               # contact sheet (regenerated)
└── asset_packs/kormie/
    ├── Anims/
    │   ├── manifest.txt
    │   └── kormie_whoami/
    │       ├── meta.txt
    │       └── frame_0.png … frame_8.png
    └── Icons/Passport/
        ├── passport_128x64.png
        ├── passport_happy_46x49.png
        ├── passport_okay_46x49.png
        └── passport_bad_46x49.png
```

## References

- [Momentum Asset Packs spec](https://momentum-fw.dev/wiki/Assets/)
- [Momentum `asset_packer.py`](https://github.com/Next-Flip/Momentum-Firmware/blob/dev/scripts/asset_packer.py)
- [Kuronons/FZ_graphics](https://github.com/Kuronons/FZ_graphics)
