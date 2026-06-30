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
            kormie_whoami/   meta.txt + frame_*.png   (terminal `whoami`)
            kormie_vim/      meta.txt + frame_*.png   (vim splash, hjkl)
            kormie_beam/     meta.txt + frame_*.png   (OTP supervision tree)
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
ANIMS = PACK / "Anims"
PASS = PACK / "Icons" / "Passport"

BLACK, WHITE = 0, 1  # mode "1": 0 = black (foreground), 1 = white (lit/background)

FONT = ImageFont.load_default()  # crisp ~6px bitmap font, thresholds cleanly to 1-bit


def new(w, h):
    """White (lit) canvas in 1-bit mode."""
    img = Image.new("1", (w, h), WHITE)
    return img, ImageDraw.Draw(img)


def text(d, xy, s, fill=BLACK):
    d.text(xy, s, fill=fill, font=FONT)


def ctext(d, y, s, fill=BLACK):
    """Horizontally-centered text."""
    w = d.textlength(s, font=FONT)
    d.text(((128 - w) // 2, y), s, fill=fill, font=FONT)


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

    for (cx, cy, hx, vy) in [(5, 5, 1, 1), (122, 5, -1, 1),
                             (5, 58, 1, -1), (122, 58, -1, -1)]:
        d.line([cx, cy, cx + hx * 6, cy], fill=BLACK)
        d.line([cx, cy, cx, cy + vy * 6], fill=BLACK)

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

    d.rounded_rectangle([3, 2, 42, 35], radius=3, outline=BLACK)
    d.rounded_rectangle([4, 3, 41, 34], radius=3, outline=BLACK)   # 2px bezel
    screen = (8, 7, 37, 30)
    d.rectangle([20, 35, 25, 39], outline=BLACK)                   # neck
    d.line([13, 44, 32, 44], fill=BLACK)                           # base
    d.line([13, 45, 32, 45], fill=BLACK)
    d.line([16, 40, 13, 44], fill=BLACK)
    d.line([29, 40, 32, 44], fill=BLACK)

    if mood == "happy":
        d.rectangle([11, 13, 33, 18], fill=BLACK)                  # sunglasses
        d.line([10, 14, 11, 14], fill=BLACK)
        d.line([34, 14, 35, 14], fill=BLACK)
        d.rectangle([21, 14, 24, 17], fill=WHITE)                  # bridge gap
        d.arc([14, 18, 30, 28], start=10, end=170, fill=BLACK)     # grin
        d.point((9, 9), fill=BLACK)
        d.point((10, 9), fill=BLACK)
    elif mood == "okay":
        d.rectangle([15, 14, 18, 17], fill=BLACK)                  # eyes
        d.rectangle([27, 14, 30, 17], fill=BLACK)
        d.line([17, 24, 28, 24], fill=BLACK)                       # flat mouth
    else:  # bad
        for ex in (16, 28):
            d.line([ex - 2, 12, ex + 2, 16], fill=BLACK)
            d.line([ex - 2, 16, ex + 2, 12], fill=BLACK)           # x_x eyes
        d.line([(15, 28), (19, 25), (23, 24), (27, 25), (31, 28)], fill=BLACK)  # frown

    d.line([screen[0] + 1, 29, screen[2] - 1, 29], fill=BLACK)     # scanline
    return img


# --------------------------------------------------------------------------- #
# Animation 1 — terminal running `whoami`  (128x64)
# --------------------------------------------------------------------------- #
def window(d, title):
    """Shared terminal-window chrome: border + title bar."""
    d.rectangle([0, 0, 127, 63], outline=BLACK)
    d.rectangle([1, 1, 126, 13], fill=BLACK)
    text(d, (4, 2), title, fill=WHITE)
    for x in (110, 116, 122):
        d.rectangle([x, 5, x + 2, 7], outline=WHITE)


def terminal_frame(cmd, output, cursor_on):
    img, d = new(128, 64)
    window(d, "kormie@flipper")
    prompt = "kormie:~$ "
    d.text((5, 16), prompt + cmd, fill=BLACK, font=FONT)
    cw = d.textlength(prompt + cmd, font=FONT)
    if cursor_on:
        d.rectangle([6 + cw, 16, 6 + cw + 4, 24], fill=BLACK)
    y = 30
    for line in output:
        text(d, (5, y), line)
        y += 11
    return img


def whoami_frames():
    typed = "whoami"
    frames = [terminal_frame(typed[:i], [], i % 2 == 0) for i in range(len(typed) + 1)]
    out = ["> hacker dolphin", "> KOHO // hjkl"]
    frames.append(terminal_frame(typed, out, True))
    frames.append(terminal_frame(typed, out, False))
    return frames  # 9 frames


# --------------------------------------------------------------------------- #
# Animation 2 — vim splash with animated hjkl  (128x64)
# --------------------------------------------------------------------------- #
def vim_frame(hl, cursor_on):
    img, d = new(128, 64)
    d.rectangle([0, 0, 127, 63], outline=BLACK)

    for y in range(6, 52, 8):                              # ~ gutter
        text(d, (3, y), "~")

    ctext(d, 7, "VIM - Vi IMproved")
    ctext(d, 18, "~ kormie ~")
    ctext(d, 29, "leader: ,   netrw <3")

    text(d, (28, 41), "move:")                             # hjkl hint
    letters = ["h", "j", "k", "l"]
    sx, gap, ly = 72, 12, 41
    for i, ch in enumerate(letters):
        lx = sx + i * gap
        if i == hl:
            d.rectangle([lx - 2, ly - 1, lx + 7, ly + 9], fill=BLACK)
            d.text((lx, ly), ch, fill=WHITE, font=FONT)
        else:
            d.text((lx, ly), ch, fill=BLACK, font=FONT)

    d.rectangle([1, 53, 126, 62], fill=BLACK)              # status line
    text(d, (3, 53), "-- NORMAL --", fill=WHITE)
    text(d, (96, 53), ":w", fill=WHITE)
    if cursor_on:
        d.rectangle([108, 54, 112, 61], fill=WHITE)
    return img


def vim_frames():
    return [vim_frame(i % 4, i % 2 == 0) for i in range(8)]


# --------------------------------------------------------------------------- #
# Animation 3 — Elixir / OTP supervision tree, "let it crash"  (128x64)
# --------------------------------------------------------------------------- #
def elixir_drop(d, px, py):
    """Small Elixir-style teardrop, apex at (px, py)."""
    d.ellipse([px - 5, py + 3, px + 5, py + 13], fill=BLACK)
    d.polygon([(px, py), (px - 5, py + 8), (px + 5, py + 8)], fill=BLACK)
    d.arc([px - 3, py + 5, px + 5, py + 13], start=20, end=160, fill=WHITE)  # inner gleam


def worker(d, cx, top, state="ok"):
    box = [cx - 9, top, cx + 9, top + 12]
    if state == "gone":
        for x in range(box[0], box[2], 4):                 # dotted ghost
            d.point((x, top), fill=BLACK)
            d.point((x, top + 12), fill=BLACK)
        return
    d.rectangle(box, outline=BLACK)
    d.ellipse([cx - 2, top + 4, cx + 2, top + 8], fill=BLACK)   # PID dot
    if state == "crash":
        d.line([box[0], box[1], box[2], box[3]], fill=BLACK)    # X
        d.line([box[0], box[3], box[2], box[1]], fill=BLACK)
    if state == "restart":
        for (sx, sy) in [(cx - 12, top - 3), (cx + 11, top - 2), (cx, top + 15)]:
            d.line([sx - 2, sy, sx + 2, sy], fill=BLACK)        # sparkles
            d.line([sx, sy - 2, sx, sy + 2], fill=BLACK)


def beam_frame(state, caption, cursor_on):
    img, d = new(128, 64)
    window(d, "iex(1)>")
    cw = d.textlength("iex(1)>", font=FONT)
    if cursor_on:
        d.rectangle([6 + cw + 2, 3, 6 + cw + 6, 9], fill=WHITE)

    elixir_drop(d, 116, 16)

    # supervisor node
    d.rounded_rectangle([50, 15, 78, 26], radius=2, outline=BLACK)
    ctext(d, 16, "Sup")

    centers = [(24, "ok"), (64, state), (104, "ok")]       # middle worker varies
    for cx, st in centers:
        # connector supervisor -> worker
        if cx == 64 and state == "gone":
            for y in range(27, 38, 3):
                d.point((64, y), fill=BLACK)               # dashed (down)
        else:
            d.line([64, 26, cx, 38], fill=BLACK)
        worker(d, cx, 38, st)

    ctext(d, 53, caption)
    return img


def beam_frames():
    seq = [
        ("ok", "all systems :ok", True),
        ("ok", "all systems :ok", False),
        ("crash", "** (EXIT) :boom", True),
        ("gone", "let it crash", True),
        ("gone", "supervisor...", False),
        ("restart", ":restarting", True),
        ("ok", "back up :ok", True),
        ("ok", "back up :ok", False),
    ]
    return [beam_frame(*s) for s in seq]


# --------------------------------------------------------------------------- #
# Metadata
# --------------------------------------------------------------------------- #
def write_anim(name, frames, frame_rate):
    folder = ANIMS / name
    folder.mkdir(parents=True, exist_ok=True)
    for i, f in enumerate(frames):
        f.save(folder / f"frame_{i}.png")
    order = " ".join(str(i) for i in range(len(frames)))
    (folder / "meta.txt").write_text(
        "Filetype: Flipper Animation\n"
        "Version: 1\n\n"
        "Width: 128\n"
        "Height: 64\n"
        f"Passive frames: {len(frames)}\n"
        "Active frames: 0\n"
        f"Frames order: {order}\n"
        "Active cycles: 0\n"
        f"Frame rate: {frame_rate}\n"
        "Duration: 3600\n"
        "Active cooldown: 0\n\n"
        "Bubble slots: 0\n"
    )


def write_manifest(entries):
    blocks = [
        f"Name: {name}\n"
        "Min butthurt: 0\n"
        "Max butthurt: 14\n"
        "Min level: 1\n"
        "Max level: 30\n"
        f"Weight: {weight}\n"
        for name, weight in entries
    ]
    (ANIMS / "manifest.txt").write_text(
        "Filetype: Flipper Animation Manifest\nVersion: 1\n\n" + "\n".join(blocks)
    )


# --------------------------------------------------------------------------- #
def preview(passport, moods, anims):
    scale, pad = 3, 8
    tiles = [("passport", passport)]
    tiles += [(f"mood:{m}", img) for m, img in moods.items()]
    for name, (frames, _rate) in anims.items():
        tiles += [(f"{name}[{i}]", f) for i, f in enumerate(frames)]

    height = sum(img.height * scale + pad for _, img in tiles) + pad
    canvas = Image.new("L", (128 * scale + 2 * pad, height), 128)
    y = pad
    for _, img in tiles:
        up = img.convert("L").resize((img.width * scale, img.height * scale), Image.NEAREST)
        canvas.paste(up, (pad, y))
        y += img.height * scale + pad
    canvas.save(HERE / "preview.png")


def main():
    ANIMS.mkdir(parents=True, exist_ok=True)
    PASS.mkdir(parents=True, exist_ok=True)

    passport = passport_bg()
    passport.save(PASS / "passport_128x64.png")

    moods = {m: mascot(m) for m in ("happy", "okay", "bad")}
    for m, img in moods.items():
        img.save(PASS / f"passport_{m}_46x49.png")

    anims = {
        "kormie_whoami": (whoami_frames(), 3),
        "kormie_vim": (vim_frames(), 4),
        "kormie_beam": (beam_frames(), 3),
    }
    weights = {"kormie_whoami": 6, "kormie_vim": 8, "kormie_beam": 8}
    for name, (frames, rate) in anims.items():
        write_anim(name, frames, rate)
    write_manifest([(n, weights[n]) for n in anims])

    preview(passport, moods, anims)
    print(f"Wrote pack to {PACK}")
    print(f"  passport background + {len(moods)} mood faces")
    for name, (frames, _r) in anims.items():
        print(f"  anim '{name}': {len(frames)} frames")
    print(f"Preview: {HERE / 'preview.png'}")


if __name__ == "__main__":
    main()
