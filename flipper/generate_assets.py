#!/usr/bin/env python3
"""
Generate the "kormie" Flipper Zero asset pack (Momentum firmware).

All source art is drawn as BLACK ink on a WHITE background in 1-bit (mode "1").
Momentum's scripts/asset_packer.py converts these PNGs to the device .bmx format
(it runs `img.convert("1")` then `ImageOps.invert(...)`), so black source pixels
become the dark/foreground pixels on the Flipper's orange screen.

Outputs (relative to this file):
    asset_packs/kormie/
        Anims/
            manifest.txt
            kormie_whoami/
                meta.txt
                frame_0.png ... frame_7.png
        Icons/
            Passport/
                passport_128x64.png
                passport_happy_46x49.png
                passport_okay_46x49.png
                passport_bad_46x49.png

Run:  python3 generate_assets.py
A preview contact-sheet is written to flipper/preview.png for inspection.
"""

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
PACK = HERE / "asset_packs" / "kormie"
ANIM = PACK / "Anims" / "kormie_whoami"
PASS = PACK / "Icons" / "Passport"

BLACK, WHITE = 0, 1  # mode "1": 0 = black (foreground), 1 = white (lit/background)

FONT = ImageFont.load_default()  # crisp ~6px bitmap font, thresholds cleanly to 1-bit


def new(w, h):
    """White (lit) canvas in 1-bit mode."""
    img = Image.new("1", (w, h), WHITE)
    return img, ImageDraw.Draw(img)


def text(d, xy, s, fill=BLACK):
    d.text(xy, s, fill=fill, font=FONT)


# --------------------------------------------------------------------------- #
# Passport background  (128x64)
# --------------------------------------------------------------------------- #
# Collision-safe: the firmware paints the dolphin mood face (top-left) and the
# name / level / mood text on top of this. We only draw a frame, a bottom
# "barcode" strip (stock-passport style), and corner brackets — never over the
# text region.
def passport_bg():
    img, d = new(128, 64)
    d.rectangle([0, 0, 127, 63], outline=BLACK)            # outer frame
    d.rectangle([2, 2, 125, 61], outline=BLACK)            # inner double frame

    # corner brackets (terminal vibe)
    for (cx, cy, hx, vy) in [(5, 5, 1, 1), (122, 5, -1, 1),
                             (5, 58, 1, -1), (122, 58, -1, -1)]:
        d.line([cx, cy, cx + hx * 6, cy], fill=BLACK)
        d.line([cx, cy, cx, cy + vy * 6], fill=BLACK)

    # bottom "barcode" strip, like the stock passport
    bars = "1011011101011001011101101001011011100101101"
    x = 8
    for ch in bars:
        if x > 120:
            break
        if ch == "1":
            d.line([x, 56, x, 59], fill=BLACK)
            d.line([x + 1, 56, x + 1, 59], fill=BLACK)
            x += 3
        else:
            d.line([x, 56, x, 59], fill=BLACK)
            x += 2
    return img


# --------------------------------------------------------------------------- #
# Mood faces — a CRT-terminal mascot ("Termy"), 46x49
# --------------------------------------------------------------------------- #
def mascot(mood):
    img, d = new(46, 49)

    # monitor body + screen
    d.rounded_rectangle([3, 2, 42, 35], radius=3, outline=BLACK)
    d.rounded_rectangle([4, 3, 41, 34], radius=3, outline=BLACK)   # 2px bezel
    screen = (8, 7, 37, 30)                                        # inner screen
    # neck + base (stand)
    d.rectangle([20, 35, 25, 39], outline=BLACK)
    d.line([13, 44, 32, 44], fill=BLACK)
    d.line([13, 45, 32, 45], fill=BLACK)
    d.line([16, 40, 13, 44], fill=BLACK)
    d.line([29, 40, 32, 44], fill=BLACK)

    cx = 22  # screen center x

    if mood == "happy":
        # cool shades + grin  (>= level / good mood)
        d.rectangle([11, 13, 33, 18], fill=BLACK)        # sunglasses bar
        d.line([10, 14, 11, 14], fill=BLACK)
        d.line([34, 14, 35, 14], fill=BLACK)
        d.line([21, 15, 24, 15], fill=BLACK)             # bridge (cut as white)
        d.rectangle([21, 14, 24, 17], fill=WHITE)
        d.arc([14, 18, 30, 28], start=10, end=170, fill=BLACK)  # grin
        d.point((9, 9), fill=BLACK)                      # screen sparkle
        d.point((10, 9), fill=BLACK)
    elif mood == "okay":
        # neutral pixel eyes + flat mouth
        d.rectangle([15, 14, 18, 17], fill=BLACK)
        d.rectangle([27, 14, 30, 17], fill=BLACK)
        d.line([17, 24, 28, 24], fill=BLACK)             # flat mouth
    else:  # bad
        # x_x eyes + frown  (butthurt / low mood)
        for ex in (16, 28):
            d.line([ex - 2, 12, ex + 2, 16], fill=BLACK)
            d.line([ex - 2, 16, ex + 2, 12], fill=BLACK)
        # explicit downturned mouth (unambiguous frown: middle high, sides low)
        d.line([(15, 28), (19, 25), (23, 24), (27, 25), (31, 28)], fill=BLACK)

    # scanline hint on screen
    d.line([screen[0] + 1, 29, screen[2] - 1, 29], fill=BLACK)
    return img


# --------------------------------------------------------------------------- #
# Idle animation — a terminal running `whoami`  (128x64, 8 frames)
# --------------------------------------------------------------------------- #
def terminal_frame(cmd, output, cursor_on):
    img, d = new(128, 64)
    d.rectangle([0, 0, 127, 63], outline=BLACK)          # window border

    # title bar
    d.rectangle([1, 1, 126, 13], fill=BLACK)
    text(d, (4, 2), "kormie@flipper", fill=WHITE)
    # little window dots, right side
    for i, x in enumerate((110, 116, 122)):
        d.rectangle([x, 5, x + 2, 7], outline=WHITE)

    # body
    prompt = "kormie:~$ "
    d.text((5, 16), prompt + cmd, fill=BLACK, font=FONT)

    # blinking block cursor after the typed command
    cw = d.textlength(prompt + cmd, font=FONT)
    if cursor_on:
        d.rectangle([6 + cw, 16, 6 + cw + 4, 24], fill=BLACK)

    # output line(s)
    y = 30
    for line in output:
        text(d, (5, y), line)
        y += 11
    return img


def animation_frames():
    typed = "whoami"
    frames = []
    # type the command out, cursor blinking
    for i in range(len(typed) + 1):
        frames.append(terminal_frame(typed[:i], [], cursor_on=(i % 2 == 0)))
    # reveal output
    frames.append(terminal_frame(typed, ["> hacker dolphin", "> KOHO // hjkl"], True))
    frames.append(terminal_frame(typed, ["> hacker dolphin", "> KOHO // hjkl"], False))
    return frames  # 8 frames total (0..7)


# --------------------------------------------------------------------------- #
# Metadata files
# --------------------------------------------------------------------------- #
def write_meta(n_frames, frame_rate=3):
    order = " ".join(str(i) for i in range(n_frames))
    (ANIM / "meta.txt").write_text(
        "Filetype: Flipper Animation\n"
        "Version: 1\n\n"
        "Width: 128\n"
        "Height: 64\n"
        f"Passive frames: {n_frames}\n"
        "Active frames: 0\n"
        f"Frames order: {order}\n"
        "Active cycles: 0\n"
        f"Frame rate: {frame_rate}\n"
        "Duration: 3600\n"
        "Active cooldown: 0\n\n"
        "Bubble slots: 0\n"
    )


def write_manifest():
    (PACK / "Anims" / "manifest.txt").write_text(
        "Filetype: Flipper Animation Manifest\n"
        "Version: 1\n\n"
        "Name: kormie_whoami\n"
        "Min butthurt: 0\n"
        "Max butthurt: 14\n"
        "Min level: 1\n"
        "Max level: 30\n"
        "Weight: 8\n"
    )


# --------------------------------------------------------------------------- #
def preview(passport, moods, frames):
    """Scaled-up contact sheet for visual inspection."""
    scale = 3
    pad = 8
    rows = []

    def up(img):
        return img.convert("L").resize(
            (img.width * scale, img.height * scale), Image.NEAREST)

    sheet = Image.new("L", (128 * scale + 2 * pad, 0), 128)
    tiles = [("passport", passport)] + [(f"mood:{m}", img) for m, img in moods.items()]
    tiles += [(f"frame_{i}", f) for i, f in enumerate(frames)]

    y = pad
    canvas = Image.new("L", (128 * scale + 2 * pad, len(tiles) * (64 * scale + pad) + pad), 128)
    for name, img in tiles:
        canvas.paste(up(img), (pad, y))
        y += img.height * scale + pad
    canvas.save(HERE / "preview.png")


def main():
    ANIM.mkdir(parents=True, exist_ok=True)
    PASS.mkdir(parents=True, exist_ok=True)

    passport = passport_bg()
    passport.save(PASS / "passport_128x64.png")

    moods = {m: mascot(m) for m in ("happy", "okay", "bad")}
    for m, img in moods.items():
        img.save(PASS / f"passport_{m}_46x49.png")

    frames = animation_frames()
    for i, f in enumerate(frames):
        f.save(ANIM / f"frame_{i}.png")
    write_meta(len(frames))
    write_manifest()

    preview(passport, moods, frames)
    print(f"Wrote pack to {PACK}")
    print(f"  passport background + {len(moods)} mood faces")
    print(f"  animation 'kormie_whoami' with {len(frames)} frames")
    print(f"Preview: {HERE / 'preview.png'}")


if __name__ == "__main__":
    main()
