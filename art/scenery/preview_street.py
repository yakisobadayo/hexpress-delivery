#!/usr/bin/env python3
"""Preview the scenery streams outside GameMaker.

A line-for-line port of SceneryStream / scenery_pools() in scr_scenery_functions.gml,
composited over the room's tiled layers. Writes snapshot PNGs and an animated GIF.

Usage (from the repo root):  python3 art/scenery/preview_street.py [out_dir] [seed]
"""
import json, random, re, sys
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
ROOM_W, ROOM_H, BASELINE, MARGIN, GAMESPEED = 640, 384, 352, 96, 4


def load_sprite(name):
    t = (ROOT / f"sprites/{name}/{name}.yy").read_text()
    d = json.loads(re.sub(r",(\s*[}\]])", r"\1", t))
    return [Image.open(ROOT / f"sprites/{name}/{f['name']}.png").convert("RGBA") for f in d["frames"]]


SPR = {}
def spr(name):
    if name not in SPR:
        SPR[name] = load_sprite(name)
    return name


def entry(s, weight, run=(1, 1), spacing=(0, 0), gap=(0, 0), edge=None, plain=-1, flip=False):
    return dict(spr=s, weight=weight, run=run, spacing=spacing, gap=gap, edge=edge, plain=plain, flip=flip)


def pools():
    s = lambda n: spr("spr_scn_" + n)
    trees = [s(n) for n in ["tree_oak", "tree_young", "tree_lime", "tree_autumn", "tree_blossom", "tree_poplar", "tree_pine", "tree_topiary"]]
    shops = [s(n) for n in ["shop_news", "shop_bakery", "shop_florist", "shop_chippy", "shop_cafe", "pub"]]
    return {
        "houses": [
            entry(s("terrace_red"), 5, run=(3, 7), gap=(0, 24)),
            entry(s("terrace_yellow"), 4, run=(3, 6), gap=(0, 24)),
            entry(s("terrace_painted"), 3, run=(3, 6), gap=(0, 24)),
            entry(shops, 3, run=(2, 4), gap=(0, 16)),
            entry(s("villa"), 1.5, gap=(8, 32), flip=True),
            entry(s("church"), 0.6, gap=(16, 48)),
            entry(s("flats"), 0.6, gap=(16, 40)),
        ],
        "trees": [
            entry(trees, 6, run=(1, 3), spacing=(-14, 6), gap=(24, 96), flip=True),
            entry(s("lamp"), 3, gap=(32, 96)),
            entry(s("postbox"), 1, gap=(24, 64)),
            entry(s("phonebox"), 0.7, gap=(24, 64)),
            entry(s("busstop"), 0.8, gap=(32, 80)),
            entry(s("sign"), 0.7, gap=(24, 64), flip=True),
            entry(s("bench"), 0.8, gap=(16, 48)),
        ],
        "wall": [
            entry(s("wall_brick"), 5, run=(4, 10), plain=0.75, edge=s("wall_pier")),
            entry(s("wall_railing"), 3, run=(3, 8), edge=s("wall_pier")),
            entry(s("wall_hedge"), 3, run=(3, 8), plain=0.6),
            entry(s("wall_picket"), 2, run=(3, 6)),
            entry(s("wall_stone"), 2, run=(3, 8)),
            entry(s("wall_fence"), 2, run=(3, 6)),
            entry(s("wall_gate"), 0.6),
            entry(s("wall_cat"), 0.4),
            entry(s("wall_bin"), 0.5),
        ],
    }


def pick_entry(pool, exclude, rng):
    total = sum(e["weight"] for e in pool if e is not exclude)
    r = rng.random() * total
    for e in pool:
        if e is exclude:
            continue
        r -= e["weight"]
        if r < 0:
            return e
    return pool[-1]


class Stream:
    def __init__(self, parallax, pool, rng):
        self.parallax, self.pool, self.rng = parallax, pool, rng
        self.props, self.cursor, self.entry, self.run_left = [], -rng.randint(0, 64), None, 0
        self.last_spr, self.last_img = None, -1
        while self.cursor < ROOM_W + MARGIN:
            self.spawn_next()

    def width(self, s):
        return SPR[s][0].width

    def step(self):
        dx = GAMESPEED * self.parallax
        self.cursor -= dx
        for p in self.props:
            p["x"] -= dx
        self.props = [p for p in self.props if p["x"] + self.width(p["spr"]) >= 0]
        while self.cursor < ROOM_W + MARGIN:
            self.spawn_next()

    def place(self, s, img, flip):
        self.props.append(dict(spr=s, img=img, x=self.cursor, flip=flip))
        self.cursor += self.width(s)

    def spawn_next(self):
        rng, e = self.rng, self.entry
        if self.run_left <= 0:
            e = self.entry = pick_entry(self.pool, self.entry, rng)
            self.run_left = rng.randint(*e["run"])
            if e["edge"]:
                self.place(e["edge"], 0, False)
        s = e["spr"]
        if isinstance(s, list):
            while True:
                s = rng.choice(e["spr"])
                if len(e["spr"]) == 1 or s != self.last_spr:
                    break
        n = len(SPR[s])
        img = 0
        if n > 1:
            if e["plain"] >= 0:
                img = 0 if rng.random() < e["plain"] else rng.randint(1, n - 1)
            else:
                while True:
                    img = rng.randint(0, n - 1)
                    if s != self.last_spr or img != self.last_img:
                        break
        self.place(s, img, e["flip"] and rng.random() < 0.5)
        self.last_spr, self.last_img = s, img
        self.run_left -= 1
        if self.run_left > 0:
            self.cursor += rng.randint(*e["spacing"])
        else:
            if e["edge"]:
                self.place(e["edge"], 0, False)
            self.cursor += rng.randint(*e["gap"])

    def draw(self, canvas):
        for p in self.props:
            im = SPR[p["spr"]][p["img"]]
            if p["flip"]:
                im = im.transpose(Image.FLIP_LEFT_RIGHT)
            canvas.alpha_composite(im, (int(p["x"] // 1), BASELINE - im.height)) if p["x"] > -im.width else None


def tiled(canvas, name, x, y):
    im = load_sprite(name)[0]
    x = int(x) % im.width - im.width
    while x < ROOM_W:
        canvas.alpha_composite(im, (x, y)) if x >= 0 else canvas.alpha_composite(im.crop((-x, 0, im.width, im.height)), (0, y))
        x += im.width


def main():
    out = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "art/scenery/out/street"
    seed = int(sys.argv[2]) if len(sys.argv) > 2 else 7
    out.mkdir(parents=True, exist_ok=True)
    rng = random.Random(seed)
    p = pools()
    streams = [Stream(0.5, p["houses"], rng), Stream(0.6875, p["trees"], rng), Stream(0.8, p["wall"], rng)]
    bg = {n: load_sprite(n)[0] for n in []}
    frames, t = [], 0
    for t in range(0, 1201):
        if t % 300 == 0 or (t % 3 == 0 and t <= 600):
            c = Image.new("RGBA", (ROOM_W, ROOM_H), (0, 0, 0, 255))
            tiled(c, "spr_new_sky", -t * 0.2, 12)
            tiled(c, "spr_new_clouds", -t * 0.2, 12)
            tiled(c, "spr_new_city", -t * 0.4, 12)
            for s in streams:
                s.draw(c)
            tiled(c, "spr_ground", -t * 4, 352)
            if t % 300 == 0:
                c.resize((ROOM_W * 2, ROOM_H * 2), Image.NEAREST).save(out / f"street_t{t:04d}.png")
            if t % 3 == 0 and t <= 600:
                frames.append(c.convert("RGB").convert("P", palette=Image.ADAPTIVE, colors=128))
        for s in streams:
            s.step()
    frames[0].save(out / "street.gif", save_all=True, append_images=frames[1:], duration=50, loop=0)
    print("wrote", out)


if __name__ == "__main__":
    main()
