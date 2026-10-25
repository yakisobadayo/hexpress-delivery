// Scenery props for the route background (placeholder art).
// Build: node <pxl>/bin/pxl.js build art/scenery/scenery.px.js
// Then:  python3 art/scenery/export_to_gm.py   (copies PNGs into GameMaker sprites)
//
// Every prop's bottom row sits on the street line (y = 352 in room_run).
// Names ending in _<n> are frames of one GameMaker sprite (same size, picked at random).

// Famicube, plus the few in-game extras (849e9c, 06724f, 5bcdff).
pal({
  K: "#151515", k: "#343434", N: "#0d2030",
  x: "#415d66", X: "#849e9c", z: "#71a6a1",          // slate shadow / glass
  "2": "#7b7b7b", "3": "#a8a8a8", "4": "#d7d7d7", "5": "#ffffff",
  b: "#c59782", B: "#ae6c37", R: "#823c3d", m: "#4f1507",  // red brick
  y: "#e2d7b5", Y: "#cc8f15", A: "#ad4e1a",          // yellow brick
  c: "#ffe9c5", C: "#f5b784",                        // cream render
  g: "#20b562", G: "#06724f", d: "#004e00", l: "#58d332", L: "#8cd612", D: "#172808",
  r: "#e03c28", P: "#cf3c71", p: "#ff82ce", q: "#fec9ed", Q: "#871646",
  o: "#ffbb31", O: "#f68f37", e: "#ffe737",
  u: "#98dcff", U: "#5ba8ff", n: "#0a89ff", v: "#024aca", V: "#00177d",
  t: "#bdffca", T: "#25e2cd", h: "#0a98ac",
  i: "#e2c9ff", I: "#9ba0ef", j: "#a675fe",
  f: "#5c3c0d", F: "#231712",
})
ramps("Kkx2345", "mRBbC", "AYy", "DdGglL", "QPpq", "FfBOoe", "VvnUu", "hTt")

// ---------------------------------------------------------------- shared parts

// slate scallop, one course mark (as in spr_new_houses)
sprite("_slate", "x..x\n.xx.")
// a single brick-course mark (as in spr_new_house)
sprite("_brickmark", "B..\nBBB\n.B.")

// sash window: frame + glass + glazing bar + sill
function sash(c, x, y, w, h, frame = "4", sill = "5") {
  c.rect(x, y, w, h, frame)
  c.rect(x + 1, y + 1, w - 2, h - 2, "x")
  c.vline(x + Math.floor(w / 2), y + 1, h - 2, frame)
  c.hline(x + 1, y + Math.floor(h / 2), w - 2, frame)
  c.px(x + 1, y + 1, "z")                       // glint, top-left pane
  c.hline(x - 1, y + h, w + 2, sill)
  c.hline(x - 1, y + h + 1, w + 2, "3")
}

// panelled front door with fanlight and step
function door(c, x, y, w, h, col, frame = "4") {
  c.rect(x - 1, y - 5, w + 2, h + 5, frame)
  c.rect(x, y - 4, w, 3, "x")                   // fanlight
  c.px(x + Math.floor(w / 2), y - 3, "z")
  c.rect(x, y, w, h, col)
  c.box(x + 1, y + 2, w - 2, Math.floor(h / 2) - 2, col === "K" ? "k" : "x")
  c.px(x + w - 2, y + Math.floor(h / 2) + 1, "o") // knob
  c.hline(x - 2, y + h - 1, w + 4, "3")         // step
}

// slate roof band with eaves gutter
function roof(c, x, y, w, h, slate = "2") {
  c.rect(x, y, w, h, slate)
  for (let row = 0, yy = y + 3; yy < y + h - 3; row++, yy += 5)
    for (let xx = x + 2 + (row % 2) * 5 + ((row * 7) % 3); xx < x + w - 4; xx += 10) c.stamp("_slate", xx, yy)
  c.hline(x, y, w, "3")                          // ridge catches the light
  c.hline(x - 1, y + h, w + 2, "x")             // gutter
}

function chimney(c, x, y, h, brick = "b", dark = "B") {
  c.rect(x, y + 3, 8, h, brick)
  c.vline(x + 7, y + 3, h, dark)
  c.hline(x - 1, y + 3, 10, "3")
  c.rect(x + 1, y, 2, 3, "R"); c.rect(x + 5, y + 1, 2, 2, "R")   // pots
}

function brickmarks(c, x, y, w, h, seed) {
  const r = c.rng(seed)
  for (let yy = y + 4; yy < y + h - 4; yy += 9)
    for (let xx = x + 3 + Math.floor(r() * 6); xx < x + w - 5; xx += 13 + Math.floor(r() * 9))
      if (r() < 0.55 && c.is(xx, yy, "bya")) c.stamp("_brickmark", xx, yy)
}

// ---------------------------------------------------------------- terraced houses
// 48 x 116. variants differ in door colour/side, bay window, dormer.
const TERR_W = 48, TERR_H = 116
function terrace(name, o) {
  sprite(name, { w: TERR_W, h: TERR_H }, (c) => {
    const W = TERR_W, H = TERR_H, top = 34
    chimney(c, 2, 0, 12, o.painted ? "b" : o.brick, o.painted ? "B" : o.dark)
    roof(c, 0, 10, W, top - 10, o.slate || "2")
    if (o.dormer) {
      c.rect(17, 12, 14, 14, "4"); c.hline(16, 11, 16, "5")
      sash(c, 19, 14, 10, 10, "4", "4")
    }
    c.rect(0, top + 1, W, H - top - 1, o.brick)
    if (!o.painted) brickmarks(c, 0, top + 1, W - 2, H - top - 1, o.seed || 1)
    c.rect(W - 2, top + 1, 2, H - top - 1, o.dark)          // party-wall shadow
    c.hline(0, top + 1, W, o.dark)                          // under-eave shadow
    c.hline(0, 74, W - 2, o.dark)                           // string course
    // first floor
    sash(c, 7, 44, 11, 18); sash(c, 29, 44, 11, 18)
    // ground floor: door + window or bay
    const dx = o.doorRight ? 33 : 5, wx = o.doorRight ? 5 : 22
    door(c, dx, 92, 10, 24, o.door)
    if (o.bay) {
      c.rect(wx - 1, 82, 21, 3, "4"); c.hline(wx - 2, 81, 23, "3")
      c.rect(wx, 85, 19, 20, "4")
      for (const px of [1, 7, 13]) { c.rect(wx + px, 86, 5, 17, "x"); c.px(wx + px, 86, "z") }
      c.rect(wx - 1, 105, 21, 11, o.dark)
    } else sash(c, wx + 2, 84, 13, 20)
  })
}

const brickSets = {
  red:    { brick: "b", dark: "B" },
  yellow: { brick: "y", dark: "Y" },
}
const doors = ["r", "G", "v", "K", "o", "P"]
let n = 0
for (const [set, cols] of Object.entries(brickSets))
  for (let i = 0; i < 4; i++, n++)
    terrace(`terrace_${set}_${i}`, {
      ...cols, door: doors[(n * 5 + 1) % doors.length], doorRight: i % 2 === 1,
      bay: i >= 2, dormer: i === 1 || i === 3, seed: n + 3,
    })

// painted terraces (pastel row): plain render, no brick marks
const paints = [
  { brick: "u", dark: "U" }, { brick: "q", dark: "p" }, { brick: "t", dark: "T" },
  { brick: "c", dark: "C" }, { brick: "i", dark: "I" }, { brick: "z", dark: "x" },
]
paints.forEach((p, i) =>
  terrace(`terrace_painted_${i}`, { ...p, painted: true, door: doors[(i * 2 + 3) % doors.length],
    doorRight: i % 2 === 0, bay: i % 3 === 0, dormer: i % 2 === 1 }))

// ---------------------------------------------------------------- shops
// 56 x 116: flat upstairs, shopfront with fascia + striped awning below.
function shop(name, o) {
  const W = 56, H = 116
  sprite(name, { w: W, h: H }, (c) => {
    chimney(c, 44, 0, 12)
    roof(c, 0, 10, W, 24, "2")
    c.rect(0, 35, W, H - 35, o.wall)
    if (o.brickmarks) brickmarks(c, 0, 35, W - 2, 40, 7)
    c.rect(W - 2, 35, 2, H - 35, o.wallDark)
    c.hline(0, 35, W, o.wallDark)
    sash(c, 7, 44, 11, 18); sash(c, 22, 44, 11, 18); sash(c, 37, 44, 11, 18)
    // shopfront
    c.rect(0, 70, W, H - 70, o.front)
    c.rect(1, 71, W - 2, 10, o.fascia)                       // fascia board
    c.hline(1, 81, W - 2, "K")
    c.text(Math.floor(W / 2), 73, o.sign, o.ink, { align: "c" })
    // awning: stripes 4px, scalloped hem
    for (let x = 0; x < W; x++) {
      const col = Math.floor(x / 4) % 2 ? o.awn2 : o.awn1
      c.vline(x, 83, 8, col)
      if (x % 4 !== 3) c.px(x, 91, col)
    }
    c.hline(0, 83, W, "K")
    // window display below the awning
    c.rect(3, 93, 32, 18, "x"); c.rect(3, 93, 32, 1, "K")
    c.px(4, 94, "z"); c.px(5, 94, "z"); c.px(4, 95, "z")
    if (o.goods) o.goods(c)
    c.rect(39, 92, 12, 24, o.door); c.rect(41, 94, 8, 10, "x")  // shop door
    c.hline(0, H - 4, W, o.frontDark || "K")                     // stallriser
    c.rect(3, H - 4, 32, 4, o.frontDark || "K")
  })
}

shop("shop_news_0", { wall: "b", wallDark: "B", brickmarks: true, front: "v", frontDark: "V", fascia: "V",
  sign: "NEWS", ink: "o", awn1: "r", awn2: "5", door: "v",
  goods: (c) => { for (let x = 6; x < 33; x += 6) { c.rect(x, 100, 4, 6, x % 12 ? "5" : "o"); c.hline(x, 101, 4, "r") } } })
shop("shop_bakery_0", { wall: "c", wallDark: "C", front: "P", frontDark: "Q", fascia: "q",
  sign: "BAKERY", ink: "Q", awn1: "q", awn2: "5", door: "P",
  goods: (c) => { for (let x = 6; x < 33; x += 8) { c.ellipse(x + 2, 105, 3, 2, "O"); c.hline(x, 104, 4, "o") } } })
shop("shop_florist_0", { wall: "y", wallDark: "Y", brickmarks: true, front: "G", frontDark: "d", fascia: "d",
  sign: "FLOWERS", ink: "5", awn1: "g", awn2: "5", door: "G",
  goods: (c) => { for (let x = 6; x < 33; x += 5) { c.vline(x + 1, 104, 6, "g"); c.circ(x + 1, 103, 1, ["p", "e", "r", "5"][x % 4]) } } })
shop("shop_chippy_0", { wall: "b", wallDark: "B", brickmarks: true, front: "n", frontDark: "v", fascia: "u",
  sign: "CHIPS", ink: "v", awn1: "n", awn2: "u", door: "n",
  goods: (c) => { c.rect(5, 104, 28, 6, "3"); c.hline(5, 104, 28, "4"); for (let x = 8; x < 32; x += 7) c.rect(x, 101, 4, 3, "o") } })
shop("shop_cafe_0", { wall: "z", wallDark: "x", front: "K", frontDark: "k", fascia: "k",
  sign: "CAFE", ink: "e", awn1: "G", awn2: "c", door: "k",
  goods: (c) => { for (let x = 7; x < 33; x += 9) { c.rect(x, 104, 4, 5, "5"); c.hline(x + 1, 102, 2, "4") } } })

// ---------------------------------------------------------------- pub (64 wide)
sprite("pub_0", { w: 64, h: 116 }, (c) => {
  const W = 64
  chimney(c, 4, 0, 12); chimney(c, 52, 0, 12)
  roof(c, 0, 10, W, 24, "2")
  c.rect(0, 35, W, 81, "c"); c.rect(W - 2, 35, 2, 81, "C"); c.hline(0, 35, W, "C")
  sash(c, 8, 44, 11, 18); sash(c, 26, 44, 11, 18); sash(c, 44, 44, 11, 18)
  // dark green pub front with gold lettering
  c.rect(0, 70, W, 46, "d"); c.rect(0, 70, W, 2, "D")
  c.rect(2, 73, W - 4, 9, "D"); c.text(26, 75, "THE CROWN", "o", { align: "c" })
  c.hline(0, 83, W, "o")
  for (const x of [4, 40]) { c.rect(x, 88, 20, 20, "o"); c.rect(x + 1, 89, 18, 18, "x"); c.vline(x + 10, 89, 18, "o")
    c.hline(x + 1, 95, 18, "o"); c.px(x + 2, 90, "z"); c.rect(x + 2, 100, 7, 6, "O"); c.rect(x + 11, 100, 7, 6, "O") }  // warm light
  c.rect(27, 90, 10, 26, "D"); c.box(27, 90, 10, 26, "o")
  // hanging sign on bracket
  c.hline(W - 12, 64, 12, "K"); c.vline(W - 11, 64, 3, "K"); c.vline(W - 4, 64, 3, "K")
  c.rect(W - 13, 67, 12, 12, "o"); c.rect(W - 12, 68, 10, 10, "V")
  c.poly([W - 10, 75, W - 10, 71, W - 8, 73, W - 7, 70, W - 6, 73, W - 4, 71, W - 4, 75], "o")   // crown
})

// ---------------------------------------------------------------- landmarks
// church: stone nave + tall spire with clock (72 x 188)
sprite("church_0", { w: 72, h: 188 }, (c) => {
  const s = "3", S = "2", L = "4"
  // spire + tower (left)
  c.poly([14, 0, 15, 0, 28, 64, 1, 64], S); c.poly([14, 0, 15, 0, 15, 64, 1, 64], s)
  c.rect(14, 0, 1, 2, "o"); c.vline(14, -1, 1, "o")
  c.rect(0, 64, 30, 124, s); c.rect(24, 64, 6, 124, S); c.hline(0, 64, 30, L)
  for (let y = 70; y < 186; y += 6) c.hline(0, y, 24, "4")         // ashlar courses
  for (let y = 70, r = 0; y < 186; y += 6, r++) for (let x = 3 + (r % 2) * 5; x < 24; x += 10) c.vline(x, y + 1, 5, "4")
  c.circ(12, 82, 7, "5"); c.ring(12, 82, 7, "o"); c.line(12, 82, 12, 77, "K"); c.line(12, 82, 15, 82, "K")
  c.rect(7, 100, 10, 20, "x"); c.circ(11, 100, 5, "x"); c.rect(6, 100, 1, 20, L); c.vline(12, 96, 24, s)
  c.rect(8, 160, 9, 28, "f"); c.circ(12, 160, 4, "f"); c.vline(12, 157, 31, "F")
  // nave (right)
  c.poly([30, 110, 51, 92, 72, 110], "x"); c.poly([30, 110, 51, 92, 51, 110], S)
  c.rect(30, 111, 42, 77, s); c.rect(68, 111, 4, 77, S)
  for (let y = 116; y < 186; y += 6) c.hline(30, y, 38, "4")
  for (const x of [36, 54]) { c.rect(x, 124, 9, 26, "U"); c.circ(x + 4, 124, 4, "U"); c.vline(x + 4, 121, 29, "3")
    c.hline(x, 136, 9, "3"); c.px(x + 2, 126, "e"); c.px(x + 6, 140, "r"); c.px(x + 2, 145, "g") }   // stained glass
})

// flats: 1960s block, 4 storeys with coloured balcony panels (80 x 164)
sprite("flats_0", { w: 80, h: 164 }, (c) => {
  c.rect(4, 0, 14, 8, "3"); c.rect(16, 0, 2, 8, "2")                // lift housing
  c.rect(0, 8, 80, 156, "4"); c.rect(74, 8, 6, 156, "3"); c.hline(0, 8, 80, "5"); c.hline(0, 9, 80, "3")
  const panels = ["U", "O", "g", "p"]
  for (let f = 0; f < 4; f++) {
    const y = 18 + f * 34
    c.hline(0, y - 4, 74, "3")                                          // floor slab
    for (let b = 0; b < 3; b++) {
      const x = 4 + b * 24
      c.rect(x, y, 18, 16, "x"); c.vline(x + 9, y, 16, "4"); c.px(x + 1, y + 1, "z"); c.px(x + 2, y + 1, "z")
      c.rect(x - 1, y + 16, 20, 8, panels[(f + b * 3) % 4])           // balcony front
      c.hline(x - 1, y + 16, 20, "5"); c.hline(x - 1, y + 23, 20, "2")
    }
  }
  c.rect(30, 150, 14, 14, "x"); c.rect(31, 151, 12, 13, "z"); c.vline(37, 151, 13, "x")   // entrance
})

// corner house with a round turret, a little grander (56 x 136)
sprite("villa_0", { w: 56, h: 136 }, (c) => {
  c.poly([2, 30, 10, 2, 11, 2, 19, 30], "x"); c.poly([10, 2, 11, 2, 11, 30, 2, 30], "2"); c.px(10, 0, "o"); c.px(10, 1, "k")
  c.rect(2, 30, 18, 106, "b"); c.rect(17, 30, 3, 106, "B")
  roof(c, 20, 28, 36, 26, "2"); chimney(c, 44, 18, 10)
  c.rect(20, 55, 36, 81, "b"); c.rect(54, 55, 2, 81, "B"); c.hline(20, 55, 36, "B")
  brickmarks(c, 2, 30, 52, 106, 11)
  c.hline(2, 30, 18, "B")
  sash(c, 6, 40, 9, 16); sash(c, 6, 72, 9, 16); sash(c, 6, 104, 9, 16)
  sash(c, 26, 64, 11, 18); sash(c, 41, 64, 11, 18)
  c.hline(2, 95, 52, "B")
  door(c, 40, 112, 10, 24, "V"); sash(c, 25, 104, 11, 20)
})

// ---------------------------------------------------------------- trees (Trees layer)
// leaf clump brush parts, in the style of spr_new_tree's scalloped canopy
sprite("_clump_hi", "..ll..\n.lggl.\nlg..gl")
sprite("_clump_lo", "..GG..\n.G..G.")

// round broadleaf: a core canopy ringed with lobes, lit top-left, scalloped marks
function broadleaf(name, o) {
  sprite(name, { w: o.w, h: o.h }, (c) => {
    const { w, h } = o, cx = Math.floor(w / 2), r = c.rng(o.seed)
    const rx = Math.floor(w / 2) - Math.ceil(o.rad / 2) - 1
    const ry = Math.floor((h - o.trunk) / 2) - Math.ceil(o.rad / 2) + 1
    const cy = ry + Math.ceil(o.rad / 2) + 1
    // trunk + forked branches into the canopy
    c.rect(cx - 2, cy, 5, h - cy, "k"); c.hline(cx - 4, h - 1, 9, "k")
    c.line(cx, cy + 10, cx - 7, cy + 2, "k", 2); c.line(cx + 1, cy + 8, cx + 8, cy, "k", 2)
    const lobes = [[cx, cy, 0]]
    for (let i = 0; i < o.blobs; i++) {
      const a = (i / o.blobs) * Math.PI * 2 + r() * 0.5
      lobes.push([Math.round(cx + Math.cos(a) * rx * 0.8), Math.round(cy + Math.sin(a) * ry * 0.8), a])
    }
    const lr = (a) => Math.floor(o.rad * (0.8 + 0.3 * Math.abs(Math.sin(a * 3 + o.seed))))
    // shadow pass offset down-right, then body, then top-left highlights
    c.ellipse(cx, cy + 2, rx, ry, o.dark)
    for (const [x, y, a] of lobes.slice(1)) c.circ(x + 1, y + 2, lr(a), o.dark)
    c.ellipse(cx, cy, rx - 1, ry - 1, o.mid)
    for (const [x, y, a] of lobes.slice(1)) c.circ(x, y, lr(a) - 1, o.mid)
    for (const [x, y, a] of lobes.slice(1))
      if (Math.cos(a) + Math.sin(a) < 0.3) c.circ(x - 2, y - 2, Math.floor(lr(a) / 2), o.light)
    c.circ(cx - Math.floor(rx / 3), cy - Math.floor(ry / 3), Math.floor(o.rad / 2), o.light)
    c.scatter(o.marks, 0, 0, w, h - o.trunk, o.nmarks, { on: o.mid + o.light, clip: true, seed: o.seed, swap: { G: o.dark } })
  })
}
const leafSets = {
  green:   { dark: "G", mid: "g", light: "l", marks: "_clump_lo" },
  deep:    { dark: "d", mid: "G", light: "g", marks: "_clump_lo" },
  autumn:  { dark: "A", mid: "O", light: "o", marks: "_clump_lo", swapMarks: true },
  blossom: { dark: "P", mid: "p", light: "q", marks: "_clump_lo" },
}
broadleaf("tree_oak_0",     { ...leafSets.green,   w: 64, h: 92,  trunk: 22, rad: 14, blobs: 8, seed: 3, nmarks: 18 })
broadleaf("tree_young_0",   { ...leafSets.green,   w: 56, h: 80,  trunk: 24, rad: 11, blobs: 7, seed: 8, nmarks: 14 })
broadleaf("tree_lime_0",    { ...leafSets.deep,    w: 72, h: 104, trunk: 24, rad: 13, blobs: 9, seed: 5, nmarks: 22 })
broadleaf("tree_autumn_0",  { ...leafSets.autumn,  w: 60, h: 86,  trunk: 22, rad: 13, blobs: 8, seed: 12, nmarks: 16 })
broadleaf("tree_blossom_0", { ...leafSets.blossom, w: 56, h: 76,  trunk: 24, rad: 11, blobs: 7, seed: 21, nmarks: 14 })

// poplar: tall narrow
sprite("tree_poplar_0", { w: 28, h: 118 }, (c) => {
  c.rect(12, 104, 4, 14, "k")
  c.ellipse(14, 56, 12, 52, "G"); c.ellipse(13, 54, 11, 50, "g"); c.ellipse(10, 46, 5, 34, "l")
  for (let y = 12; y < 100; y += 9) { c.hline(9 + (y % 2) * 2, y, 3, "G"); c.hline(16 - (y % 3), y + 4, 3, "G") }
})

// conifer: stacked tiers
sprite("tree_pine_0", { w: 44, h: 104 }, (c) => {
  c.rect(20, 92, 4, 12, "f")
  for (let i = 0; i < 5; i++) {
    const y = 4 + i * 17, half = 7 + i * 3
    c.poly([22, y, 22 + half, y + 26, 22 - half, y + 26], "d")
    c.poly([22, y, 22, y + 26, 22 - half, y + 26], "G")
    c.hline(22 - half, y + 25, half * 2, "D")
  }
  c.px(21, 3, "G")
})

// clipped round hedge-tree (topiary) on a short stem
sprite("tree_topiary_0", { w: 28, h: 60 }, (c) => {
  c.rect(12, 30, 3, 30, "f")
  c.circ(14, 15, 13, "G"); c.circ(13, 14, 12, "g"); c.circ(9, 10, 5, "l")
  c.scatter("_clump_lo", 2, 2, 24, 26, 6, { on: "gl", clip: true })
})

// ---------------------------------------------------------------- street furniture (Trees layer)
// Victorian lamp post
sprite("lamp_0", { w: 14, h: 88 }, (c) => {
  c.rect(5, 18, 4, 70, "k"); c.rect(4, 80, 6, 8, "k"); c.rect(3, 86, 8, 2, "k")
  c.rect(4, 30, 6, 2, "k")                                       // ladder bar
  c.poly([2, 6, 12, 6, 10, 16, 4, 16], "k")                      // lantern frame
  c.poly([3, 7, 11, 7, 9, 15, 5, 15], "e"); c.vline(7, 7, 8, "o")
  c.poly([1, 6, 7, 0, 13, 6], "k"); c.px(7, 0, "k"); c.hline(4, 17, 6, "k")
})
// pillar box
sprite("postbox_0", { w: 14, h: 40 }, (c) => {
  c.rect(1, 6, 12, 32, "r"); c.ellipse(7, 6, 6, 4, "r"); c.rect(10, 6, 3, 32, "R")
  c.hline(0, 9, 14, "K"); c.rect(3, 13, 8, 2, "K")              // cap band + slot
  c.rect(4, 18, 6, 5, "o"); c.px(6, 20, "R"); c.rect(0, 37, 14, 3, "K")
})
// red phone box
sprite("phonebox_0", { w: 20, h: 58 }, (c) => {
  c.rect(1, 4, 18, 54, "r"); c.rect(0, 2, 20, 4, "r"); c.ellipse(10, 2, 8, 2, "r")
  c.rect(16, 4, 3, 54, "R")
  c.rect(2, 7, 14, 4, "K"); c.text(9, 7, "TEL", "5", { align: "c" }) // header
  for (let y = 14; y < 50; y += 6) for (const x of [3, 9]) { c.rect(x, y, 5, 5, "x"); c.px(x, y, "z") }
  c.rect(0, 56, 20, 2, "k")
})
// bus stop sign + shelter
sprite("busstop_0", { w: 44, h: 76 }, (c) => {
  // shelter
  c.rect(8, 28, 36, 3, "x"); c.hline(8, 28, 36, "3")
  c.rect(10, 31, 1, 45, "k"); c.rect(42, 31, 1, 45, "k")
  c.rect(11, 32, 31, 30, "z"); c.rect(11, 32, 31, 30, "u")
  c.line(16, 36, 22, 48, "5"); c.line(30, 36, 36, 48, "5")       // reflections on glass
  c.rect(14, 62, 24, 2, "k")                                      // bench
  c.rect(20, 40, 12, 16, "o"); c.rect(21, 41, 10, 14, "c")         // advert
  // flag pole + roundel
  c.rect(3, 12, 2, 64, "k")
  c.circ(4, 7, 6, "r"); c.circ(4, 7, 3, "5"); c.rect(-1, 6, 11, 3, "V")
  c.rect(0, 14, 9, 7, "5"); c.hline(1, 16, 7, "V"); c.hline(1, 18, 5, "V")
})
// finger post / street name sign
sprite("sign_0", { w: 30, h: 60 }, (c) => {
  c.rect(14, 4, 2, 56, "k")
  c.rect(0, 6, 30, 9, "5"); c.box(0, 6, 30, 9, "K"); c.text(15, 8, "HIGH ST", "K", { align: "c" })
  c.hline(1, 7, 28, "r")
})
// bench (low; mostly behind the wall, back rail peeks out)
sprite("bench_0", { w: 32, h: 30 }, (c) => {
  c.rect(1, 6, 30, 3, "B"); c.rect(1, 11, 30, 3, "B"); c.hline(1, 6, 30, "O"); c.hline(1, 11, 30, "O")
  c.rect(1, 17, 30, 2, "B"); c.rect(2, 4, 2, 26, "k"); c.rect(28, 4, 2, 26, "k")
})

// ---------------------------------------------------------------- front walls (Wall layer)
// 32 wide, laid edge to edge. Heights vary a little; all sit on the street line.
function brickwall(c, y, h, cap = true) {
  c.rect(0, y, 32, h, "b")
  for (let yy = y + 4, r = 0; yy < y + h - 1; yy += 4, r++) {
    c.hline(0, yy, 32, "B")
    for (let x = (r % 2) * 4 + 2; x < 32; x += 8) c.vline(x, yy - 3, 3, "B")
  }
  if (cap) { c.rect(0, y - 3, 32, 3, "4"); c.hline(0, y - 3, 32, "5"); c.hline(0, y, 32, "3") }
  c.hline(0, y + h - 1, 32, "R")
}
sprite("wall_brick_0", { w: 32, h: 24 }, (c) => brickwall(c, 3, 21))
sprite("wall_brick_1", { w: 32, h: 24 }, (c) => { brickwall(c, 3, 21); c.rect(26, 8, 6, 10, "B"); c.hline(27, 9, 4, "R") })     // patched
sprite("wall_brick_2", { w: 32, h: 24 }, (c) => { brickwall(c, 3, 21)                                                         // ivy over the top
  c.rect(4, 0, 14, 4, "G"); c.rect(6, 4, 9, 6, "G"); c.vline(8, 10, 5, "G"); c.vline(13, 10, 3, "G"); c.px(7, 1, "g"); c.px(12, 2, "g"); c.px(9, 5, "g") })

// pier with a ball finial, for the ends of a run
sprite("wall_pier_0", { w: 12, h: 34 }, (c) => {
  c.rect(1, 9, 10, 25, "b"); c.rect(9, 9, 2, 25, "B")
  for (let y = 13; y < 33; y += 4) c.hline(1, y, 10, "B")
  c.rect(0, 7, 12, 3, "4"); c.hline(0, 7, 12, "5")
  c.circ(6, 3, 3, "3"); c.px(5, 2, "5")
})

// railings on a low wall
sprite("wall_railing_0", { w: 32, h: 26 }, (c) => {
  c.hline(0, 4, 32, "k"); c.hline(0, 14, 32, "k")
  for (let x = 2; x < 32; x += 4) { c.vline(x, 2, 14, "k"); c.px(x, 1, "k"); c.px(x - 1, 2, "k"); c.px(x + 1, 2, "k") }
  c.rect(0, 16, 32, 10, "3"); c.hline(0, 16, 32, "4"); c.hline(0, 25, 32, "2")
})

// clipped privet hedge
sprite("wall_hedge_0", { w: 32, h: 30 }, (c) => {
  c.rect(0, 3, 32, 27, "G"); c.rect(0, 2, 32, 5, "g"); c.hline(0, 1, 32, "l")
  for (let x = 0; x < 32; x += 8) c.px(x + 3, 1, "."), c.px(x + 4, 0, "l")
  c.scatter("_clump_lo", 0, 6, 32, 22, 6, { on: "G", clip: true, swap: { G: "d" }, seed: 2 })
  c.hline(0, 29, 32, "d")
})
sprite("wall_hedge_1", { base: "wall_hedge_0" }, (c) => {   // flowering
  for (const [x, y, k] of [[5, 9, "5"], [12, 15, "p"], [20, 8, "5"], [26, 18, "p"], [8, 21, "5"], [17, 24, "q"]]) { c.px(x, y, k); c.px(x + 1, y + 1, k) }
})

// white picket fence
sprite("wall_picket_0", { w: 32, h: 26 }, (c) => {
  c.hline(0, 9, 32, "4"); c.hline(0, 19, 32, "4")
  for (let x = 1; x < 32; x += 5) { c.rect(x, 4, 3, 22, "5"); c.px(x + 1, 3, "5"); c.vline(x + 2, 5, 21, "4") }
  c.scatter("_clump_lo", 0, 20, 32, 6, 4, { swap: { G: "g" }, seed: 4 })
})

// rough stone wall with rounded coping
sprite("wall_stone_0", { w: 32, h: 22 }, (c) => {
  c.rect(0, 3, 32, 19, "3")
  const stones = [[0, 4, 9, 6], [9, 4, 12, 5], [21, 4, 11, 6], [0, 10, 6, 6], [6, 9, 10, 7], [16, 10, 9, 6], [25, 10, 7, 6], [0, 16, 12, 6], [12, 16, 8, 6], [20, 16, 12, 6]]
  for (const [x, y, w, h] of stones) { c.hline(x, y + h - 1, w, "2"); c.vline(x + w - 1, y, h, "2"); c.hline(x, y, w - 1, "4") }
  for (let x = 0; x < 32; x += 4) c.ellipse(x + 2, 2, 2, 2, "2"), c.px(x + 1, 1, "3")
})

// wooden close-board fence
sprite("wall_fence_0", { w: 32, h: 30 }, (c) => {
  for (let x = 0; x < 32; x += 4) { c.rect(x, 2, 4, 28, "B"); c.vline(x + 3, 2, 28, "A"); c.px(x + 1, 1, "B"); c.px(x + 2, 1, "B") }
  c.hline(0, 7, 32, "A"); c.hline(0, 23, 32, "A"); c.rect(0, 28, 32, 2, "f")
})

// cameo segments: a cat on the wall, a wheelie bin, a gate
sprite("wall_cat_0", { w: 32, h: 34 }, (c) => {
  brickwall(c, 13, 21)
  const cat = [
    ".k...k..",
    ".kk.kk..",
    ".kkkkk..",
    ".kekek..",
    ".kkkkk..",
    "..kkk...",
    ".kkkkk..",
    "kkkkkkk.",
    "kkkkkkkk",
    "kkkkkkkk",
  ]
  cat.forEach((row, y) => [...row].forEach((ch, x) => ch !== "." && c.px(18 + x, y + 1, ch)))
  c.vline(26, 10, 6, "k"); c.vline(27, 15, 5, "k"); c.px(26, 20, "k")   // tail down the wall face
})
sprite("wall_bin_0", { base: "wall_brick_0" }, (c) => {
  c.rect(8, 0, 14, 4, "d"); c.rect(9, 4, 12, 20, "G"); c.vline(19, 4, 20, "d"); c.hline(8, 4, 14, "d")
  c.circ(11, 22, 2, "K"); c.text(13, 9, "B", "g")
})
sprite("wall_gate_0", { w: 32, h: 24 }, (c) => {
  brickwall(c, 3, 21); c.rect(6, 0, 20, 24, ".")
  c.rect(6, 0, 20, 24, "_")
  for (let x = 7; x < 26; x += 3) c.vline(x, 3, 21, "k")
  c.hline(6, 6, 20, "k"); c.hline(6, 16, 20, "k"); c.line(7, 16, 25, 6, "k")
  c.rect(4, 0, 3, 24, "b"); c.rect(25, 0, 3, 24, "b"); c.vline(6, 0, 24, "B"); c.vline(27, 0, 24, "B")
  c.rect(3, 0, 5, 2, "4"); c.rect(24, 0, 5, 2, "4")
})
