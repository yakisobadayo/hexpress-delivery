// Hexpress promo timeline. 48s at 120 BPM (one bar = 2s), built to sit on the game's route music.
// Everything is a pure function of time: GSAP owns entrances/transitions, `procs` own continuous motion,
// and window.renderAt(t) renders any frame deterministically for capture.

const $ = (s) => document.querySelector(s);
const $$ = (s) => [...document.querySelectorAll(s)];
const put = (sel, html) => ($(sel).innerHTML = html);
const E = (n) => gsap.parseEase(n);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const prog = (t, t0, t1) => clamp((t - t0) / (t1 - t0), 0, 1);
const lerp = (a, b, u) => a + (b - a) * u;
const bump = (t, t0, dur) => (t < t0 || t > t0 + dur ? 0 : Math.sin(((t - t0) / dur) * Math.PI));
const keys = (t, ks) => {
  if (t <= ks[0][0]) return ks[0][1];
  for (let i = 1; i < ks.length; i++) {
    if (t <= ks[i][0]) {
      const [t0, v0] = ks[i - 1], [t1, v1, e] = ks[i];
      return lerp(v0, v1, E(e || 'sine.inOut')((t - t0) / (t1 - t0)));
    }
  }
  return ks[ks.length - 1][1];
};
const mixColor = (stops, u) => {
  u = clamp(u, 0, 1) * (stops.length - 1);
  const i = Math.min(Math.floor(u), stops.length - 2);
  return gsap.utils.interpolate(stops[i], stops[i + 1], u - i);
};

const tl = gsap.timeline({ paused: true });
const procs = [];
const SFX = []; // [time, file, gain] consumed by render.mjs
const sfx = (t, name, gain = 0.7) => SFX.push([t, name, gain]);

// Split text into masked words for the classic slide-up reveal.
function splitWords(sel) {
  $$(sel).forEach((el) => {
    const walk = (node) => {
      [...node.childNodes].forEach((n) => {
        if (n.nodeType === 3) {
          const frag = document.createDocumentFragment();
          n.textContent.split(/(\s+)/).forEach((part) => {
            if (!part) return;
            if (/^\s+$/.test(part)) frag.appendChild(document.createTextNode(' '));
            else {
              const w = document.createElement('span');
              w.className = 'w';
              w.innerHTML = `<span class="wi">${part}</span>`;
              frag.appendChild(w);
            }
          });
          n.replaceWith(frag);
        } else if (n.nodeType === 1 && !n.classList.contains('marker') && n.tagName !== 'SUP') walk(n);
      });
    };
    walk(el);
  });
}
const wordsIn = (sel, at, stagger = 0.08, dur = 0.6) =>
  tl.from(`${sel} .wi`, { yPercent: 115, duration: dur, stagger, ease: 'power3.out' }, at);
const wordsOut = (sel, at, stagger = 0.03) =>
  tl.to(`${sel} .wi`, { yPercent: -115, duration: 0.35, stagger, ease: 'power2.in' }, at);
const popIn = (sel, at, extra = {}) =>
  tl.from(sel, { scale: 0, duration: 0.6, ease: 'back.out(1.7)', ...extra }, at);

// Sparkle trail: particles are emitted on a fixed time grid so every frame is reproducible.
function makeTrail(layerSel, n = 22, dt = 0.032, life = 0.7) {
  const layer = $(layerSel);
  const els = [];
  for (let i = 0; i < n; i++) {
    const d = document.createElement('div');
    d.className = 'sparkle';
    const col = [C.sun, '#FFFFFF', C.violetLight, '#FFFFFF'][i % 4];
    d.innerHTML = `<svg viewBox="0 0 28 28"><path d="${sparklePath(14, 14, 13)}" fill="${col}"/></svg>`;
    layer.appendChild(d);
    els.push(d);
  }
  return (t, pos, active = true) => {
    const base = Math.floor(t / dt);
    els.forEach((el, k) => {
      const te = (base - k) * dt;
      const age = t - te;
      const p = active && age < life ? pos(te, age) : null;
      if (!p) return (el.style.visibility = 'hidden');
      const s = (1 - age / life) * (0.6 + 0.5 * ((Math.abs(Math.sin(te * 91.7)) * 1) % 1));
      el.style.visibility = 'visible';
      el.style.transform = `translate(${p[0]}px, ${p[1]}px) scale(${s}) rotate(${age * 240}deg)`;
    });
  };
}

// Mount a witch with an animated hair tail; returns per-frame updater.
function mountWitch(sel, id, palette, viewBox) {
  let svg = witchSVG(id, palette);
  if (viewBox) svg = svg.replace('viewBox="0 0 420 320"', `viewBox="${viewBox}"`);
  put(sel, svg);
  const root = $('#' + id);
  const hair = root.querySelector('.w-hairtail');
  return { root, hair: (t, gust = 1) => hair.setAttribute('d', hairPath(t, gust)) };
}

// Scene visibility windows (later scenes stack on top).
const WINDOWS = { s1: [0, 4.0], s2: [3.95, 8.0], s3: [7.4, 14.0], s4: [13.6, 16.05], s5: [15.55, 28.0], s7: [27.5, 32.05], s8: [31.55, 39.9], s9: [39.85, 99] };
procs.push((t) => {
  for (const [id, [a, b]] of Object.entries(WINDOWS)) $('#' + id).style.visibility = t >= a && t < b ? 'visible' : 'hidden';
});

// Gentle float for decorative memphis shapes.
function floaters(sel, amp = 12) {
  const els = $$(sel);
  procs.push((t) => els.forEach((el, i) => {
    el.style.translate = `${Math.sin(t * 0.9 + i * 1.7) * amp}px ${Math.cos(t * 1.1 + i * 2.3) * amp}px`;
    el.style.rotate = `${Math.sin(t * 0.6 + i) * 6}deg`;
  }));
}

// Inject extra scenery (from the corporate-memphis references) into a scene.
function addDecor(sceneSel, items, before) {
  const scene = $(sceneSel);
  const ref = before ? $(before) : scene.firstChild;
  items.forEach(([html, x, y, w, h, extra = '']) => {
    const d = document.createElement('div');
    d.className = 'abs deco';
    d.style.cssText = `left:${x}px;top:${y}px;width:${w}px;height:${h}px;${extra}`;
    d.innerHTML = html;
    scene.insertBefore(d, ref);
  });
}

// ─────────────────────────────────────────────────────────────── S1 · cold open (0–4)
put('#s1-blob', texturedBlobSVG('#E6E6FF', '#D3D4FB', 3));
put('#s1-half', halfCircle(C.coral, '#FF9F43'));
put('#s1-tri', triangle(C.sun, '#FFB547'));
put('#s1-squig', squiggle(C.mint, 240, 16, 5, 12));
put('#s1-dots', dotGrid(C.pink, 5, 3, 30, 6));
put('#s1-ring', ring(C.violet, 18));
put('#s1-plus', plus(C.coral, 20));
put('#s1-parcel', parcelSVG('p1'));
addDecor('#s1', [
  [doodleSVG(C.violetLight, 4), 560, 40, 520, 260, 'opacity:0.7'],
  [outlineCloudSVG(C.violetLight), 1450, 620, 220, 88, 'opacity:0.8'],
  [sprigSVG('#9BA0EF', '#6264DC', 6), 60, 520, 120, 280],
], '#s1-a');
splitWords('#s1-a, #s1-b, #s1-c');
tl.from('.s1-shape', { scale: 0, rotation: -40, duration: 0.7, stagger: 0.09, ease: 'back.out(1.8)' }, 0.0);
tl.from('#s1 .deco', { scale: 0, opacity: 0, duration: 0.6, stagger: 0.12, ease: 'back.out(1.6)' }, 0.3);
floaters('.s1-shape', 10);
wordsIn('#s1-a', 0.3, 0.12);
wordsOut('#s1-a', 1.7);
wordsIn('#s1-b', 2.0, 0.07, 0.5);
wordsIn('#s1-c', 2.3, 0.05, 0.35);
tl.from('#s1-marker', { scaleX: 0, duration: 0.3, ease: 'power3.out' }, 2.55);
tl.fromTo('#s1-parcel', { x: -250, rotation: -8 }, { x: 2100, rotation: 8, duration: 0.5, ease: 'power2.in' }, 2.95);
tl.fromTo('#s1-speed', { x: -560, opacity: 0 }, { x: 1800, opacity: 1, duration: 0.5, ease: 'power2.in' }, 2.95);
tl.fromTo('#s1-hex', { scale: 0, rotation: -30 }, { scale: 13, rotation: 60, duration: 0.55, ease: 'power3.in' }, 3.45);
sfx(2.95, 'snd_button_hover', 0.5);

// ─────────────────────────────────────────────────────────────── S2 · logo (4–8)
put('#s2-ring', ring('#FFFFFF', 18));
put('#s2-plus', plus('#FFFFFF', 20));
put('#s2-squig', squiggle('#FFFFFF', 260, 16, 5, 12));
put('#s2-dots', dotGrid('#FFFFFF', 6, 4, 30, 6));
addDecor('#s2', [
  [doodleSVG('#FFFFFF', 9), 1280, 60, 520, 260, 'opacity:0.25'],
  [outlineCloudSVG('#FFFFFF'), 220, 470, 220, 88, 'opacity:0.3'],
], '#s2-mark');
put('#s2-mark', logoMarkSVG('lm2', true));
put('#s2-word', wordmarkSVG('wm2', '#FFFFFF', C.sun));
splitWords('#s2-tag');
floaters('#s2 .s2-deco, #s2 .deco', 14);
popIn('#s2-mark', 4.05, { rotation: -120, duration: 0.8 });
tl.fromTo('#s2-word', { clipPath: 'inset(0% 100% 0% 0%)' }, { clipPath: 'inset(0% 0% -20% 0%)', duration: 0.6, ease: 'power3.inOut' }, 4.5);
const swoosh2 = $('#wm2 .wm-swoosh');
const swooshLen = swoosh2.getTotalLength();
gsap.set('.wm-swoosh', { strokeDasharray: swooshLen, strokeDashoffset: swooshLen });
tl.to('#wm2 .wm-swoosh', { strokeDashoffset: 0, duration: 0.5, ease: 'power2.inOut' }, 4.85);
tl.from('#wm2 .wm-spark', { scale: 0, rotation: -180, transformOrigin: '50% 50%', duration: 0.6, ease: 'back.out(2.5)' }, 5.2);
sfx(5.2, 'snd_ding', 0.6);
wordsIn('#s2-tag', 5.55, 0.07);
tl.to('#s2-mark', { scale: 1.12, duration: 0.15, yoyo: true, repeat: 1, ease: 'power1.inOut' }, 6.8);
const w2 = mountWitch('#s2-willow', 'w2', WILLOW);
const trail2 = makeTrail('#s2-trail');
const s2x = (t) => lerp(-520, 2250, E('power1.inOut')(prog(t, 6.2, 7.3)));
const s2y = (t) => 1000 - Math.sin(prog(t, 6.2, 7.3) * Math.PI) * 120;
procs.push((t) => {
  if (t < 3.9 || t > 8.1) return;
  w2.hair(t, 1.4);
  $('#s2-willow-o').style.transform = `translate(${s2x(t) - 260}px, ${s2y(t) - 214}px) rotate(-4deg)`;
  trail2(t, (te, age) => (te < 6.2 || te > 7.3 ? null : [s2x(te) - 245 - age * 80, s2y(te) - 10 + age * 40]));
});

// ─────────────────────────────────────────────────────────────── S3 · meet Willow (7.4–14)
put('#s3-blob', texturedBlobSVG('#E3E4FF', '#D3D4FA', 5));
$$('.s3-cloud').forEach((el) => (el.innerHTML = cloudSVG('#FFFFFF')));
put('#s3-ring', ring(C.coral, 16));
put('#s3-tri', triangle(C.sun, '#FFB547'));
put('#s3-star', starSVG());
addDecor('#s3', [
  [bigLeafSVG('#C9CBFF', '#9BA0EF'), -40, 700, 200, 280, 'rotate:-24deg'],
  [sprigSVG('#9BA0EF', '#6264DC', 7), 790, 640, 120, 340],
  [outlineCloudSVG(C.violetLight), 420, 150, 200, 80, 'opacity:0.8'],
  [dotGrid(C.violetLight, 4, 4, 28, 6), 880, 280, 100, 100],
  [doodleSVG(C.violetLight, 2), 300, 860, 520, 220, 'opacity:0.6'],
], '#s3-trail');
tl.fromTo('#s3', { clipPath: 'circle(0% at 86% 32%)' }, { clipPath: 'circle(150% at 86% 32%)', duration: 0.6, ease: 'power2.in' }, 7.4);
floaters('#s3 .deco, #s3-ring, #s3-tri', 10);
splitWords('#s3-title');
tl.from('#s3-eyebrow', { y: 24, opacity: 0, duration: 0.5, ease: 'power3.out' }, 8.45);
wordsIn('#s3-title', 8.55, 0.12, 0.7);
tl.from('#s3-sub', { x: 40, opacity: 0, duration: 0.6, ease: 'power3.out' }, 9.4);
tl.from('#s3-fine', { opacity: 0, y: 10, duration: 0.5, ease: 'power2.out' }, 10.0);
tl.from('#s3-card', { y: 120, opacity: 0, duration: 0.7, ease: 'back.out(1.4)' }, 10.55);
tl.from('.s3-tag', { scale: 0, duration: 0.45, stagger: 0.18, ease: 'back.out(2)' }, 11.25);
sfx(10.55, 'snd_button_hover', 0.5);
sfx(11.25, 'snd_increment_4', 0.5); sfx(11.43, 'snd_increment_4', 0.5); sfx(11.61, 'snd_increment_4', 0.5);
tl.to('#s3', { x: -640, duration: 0.45, ease: 'power3.in' }, 13.6);
const w3 = mountWitch('#s3-willow', 'w3', WILLOW);
const av3 = mountWitch('#s3-avatar', 'av3', WILLOW, '150 18 160 160');
const trail3 = makeTrail('#s3-trail', 18);
const s3x = (t) => keys(t, [[7.5, -760], [8.45, 30, 'power3.out'], [13.3, 60, 'sine.inOut'], [13.95, 2300, 'power2.in']]);
const s3y = (t) => 560 + Math.sin(t * 2.6) * 18;
procs.push((t) => {
  if (t < 7.3 || t > 14.1) return;
  w3.hair(t, 1);
  av3.hair(t, 0);
  const x = s3x(t), y = s3y(t);
  // wrapper is 1.6× the 420×320 rig; broom centre at (260,214)
  $('#s3-willow-o').style.transform = `translate(${x}px, ${y - 214 * 1.6 - 250}px) rotate(${Math.sin(t * 2.6 + 1) * 1.6}deg)`;
  setFace(w3.root, t > 13.3 ? 'star' : 'open', t > 9 && t < 9.6 ? 'o' : 'smile');
  $('#s3-count').textContent = Math.round(1204 * E('power2.out')(prog(t, 10.8, 11.9))).toLocaleString('en-US');
  trail3(t, (te, age) => [s3x(te) - 60 + 30 * 1.6 - age * 340 - (s3x(t) - s3x(te)) * 0, s3y(te) - 4 + age * 50]);
});

// ─────────────────────────────────────────────────────────────── S4 · our process (13.6–16)
put('#s4-blob', texturedBlobSVG('#E3E4FF', '#D3D4FA', 7));
put('#s4-parcel', parcelSVG('p4'));
put('#s4-coin', coinSVG());
put('#s4-coin2', coinSVG());
addDecor('#s4', [
  [doodleSVG(C.violetLight, 6), 1100, 40, 520, 260, 'opacity:0.6'],
  [checkboxSVG(C.violet), 1700, 210, 60, 60],
  [checkboxSVG(C.violetLight), 1790, 120, 46, 46],
  [dotGrid(C.pink, 5, 3, 28, 5), 760, 200, 130, 70],
], '#s4-title');
splitWords('#s4-title');
tl.fromTo('#s4', { x: 1920 }, { x: 0, duration: 0.45, ease: 'power3.inOut' }, 13.6);
wordsIn('#s4-title', 13.95, 0.1, 0.5);
tl.from('#s4-sub', { opacity: 0, y: 12, duration: 0.4 }, 14.3);
tl.from('.s4-card', { y: 160, opacity: 0, rotation: 4, duration: 0.55, stagger: 0.5, ease: 'back.out(1.5)' }, 14.0);
sfx(14.0, 'snd_increment_4', 0.6); sfx(14.5, 'snd_increment_4', 0.6); sfx(15.0, 'snd_increment_4', 0.6);
tl.from('#s4-eventually', { scale: 0, rotation: -12, transformOrigin: '0% 50%', duration: 0.45, ease: 'back.out(3)' }, 15.3);
tl.to('.s4-card', { y: -140, duration: 0.45, stagger: 0.05, ease: 'power2.in' }, 15.55);
procs.push((t) => {
  if (t < 13.5 || t > 16.1) return;
  $('#s4-arrow').style.transform = `translateY(${-Math.abs(Math.sin(t * Math.PI * 2)) * 16}px)`;
  const ph = (t * 1.25) % 1;
  $('#s4-parcel').style.transform = `translateY(${E('power2.in')(ph) * 90}px)`;
  $('#s4-parcel').style.opacity = ph > 0.85 ? (1 - ph) / 0.15 : 1;
  $('#s4-coin2').style.transform = `translateY(${Math.sin(t * 5) * 8}px) rotate(${Math.sin(t * 3) * 10}deg)`;
});

// ─────────────────────────────────────────────────────────────── S5/S6 · commute + delivery (15.55–28)
const V = 1000;
const WX = 700; // Willow's broom centre on screen
const speed = (t) => (t < 24 ? V : lerp(V, 120, E('power2.out')(prog(t, 24, 24.9))));
const W_T0 = 14, W_DT = 1 / 600, W_TABLE = [0];
for (let i = 1; i <= (30 - W_T0) / W_DT; i++) W_TABLE.push(W_TABLE[i - 1] + speed(W_T0 + i * W_DT) * W_DT);
const W = (t) => {
  const f = (clamp(t, W_T0, 30) - W_T0) / W_DT, i = Math.floor(f);
  return lerp(W_TABLE[i], W_TABLE[Math.min(i + 1, W_TABLE.length - 1)], f - i);
};
const tile = (svg) => `<div style="display:flex">${svg}${svg}</div>`;
let cloudTile = '';
[[60, 120, 260], [520, 40, 200], [900, 160, 300], [1400, 70, 240], [1700, 200, 180]].forEach(([x, y, w]) => {
  cloudTile += `<div class="abs" style="left:${x}px;top:${y}px;width:${w}px;height:${w * 0.4}px">${cloudSVG('#FFFFFF')}</div>`;
});
put('#s5-clouds', `<div class="abs" style="left:0;top:0;width:1920px;height:400px">${cloudTile}</div><div class="abs" style="left:1920px;top:0;width:1920px;height:400px">${cloudTile}</div>`);
put('#s5-far', tile(skylineSVG(1920, 480, 11, '#D2D0F7', '#C2C0F0', null, 150, 380)));
put('#s5-mid', tile(skylineSVG(1920, 400, 23, '#A7AAF0', '#8E91DE', '#C4C7FA', 120, 330)));
put('#s5-trees', tile(treesSVG(1920, 260, 7)));
let dashes = '';
for (let x = 0; x < 1920; x += 160) dashes += `<rect x="${x}" y="0" width="90" height="12" rx="6" fill="#8E91B8"/>`;
put('#s5-road', tile(`<svg width="1920" height="12" viewBox="0 0 1920 12">${dashes}</svg>`));
put('#s5-house', houseSVG('h5'));
put('#s5-parcel', parcelSVG('p5'));
put('#s5-hud-parcel', parcelSVG('p5hud'));
put('#s5-money-coin', coinSVG());
$('#s5-stars').innerHTML = [0, 1, 2, 3, 4].map((i) => `<span class="star s5-star" style="width:44px;height:44px">${starSVG('#E3E2EE')}</span>`).join('');

const OBST = [
  { kind: 'sword', tc: 16.9, y: 330, w: 84, h: 378, html: swordSVG('o-sword'), label: ['Swords', '(decorative?)'], below: true },
  { kind: 'baguette', tc: 17.8, y: 789, w: 81, h: 342, html: baguetteSVG('o-bag'), label: ['Baguettes', '(artisanal)'] },
  { kind: 'gull', tc: 18.7, y: 380, w: 220, h: 140, own: 320, html: seagullSVG('o-gull'), label: ['Seagulls', '(unionised)'], below: true },
  { kind: 'bramble', tc: 19.6, y: 760, w: 100, h: 380, html: brambleSVG('o-br'), label: ['Brambles', '(organic)'] },
  { kind: 'car', tc: 20.5, y: 962, w: 306, h: 180, html: carSVG('o-car'), label: ['Cars', '(surprisingly bouncy)'], lx: 330, ly: 930 },
  { kind: 'crystal', tc: 21.4, y: 330, w: 96, h: 336, html: crystalSVG('o-cr'), label: ['Crystals', '(premium hazard)'], below: true },
  { kind: 'rival', tc: 22.3, y: 330, w: 357, h: 272, own: 520, html: witchSVG('o-rival', RIVAL), label: ['The competition', '(non-compete pending)'], below: true },
  { kind: 'mush', tc: 23.15, y: 848, w: 280, h: 224, html: mushroomSVG('o-mush'), label: ['Mushrooms', '(free bounce)'], lx: 320, ly: 800 },
];
OBST.forEach((o) => {
  const el = document.createElement('div');
  el.className = 'abs';
  el.style.cssText = `left:0;top:0;width:${o.w}px;height:${o.h}px;`;
  el.innerHTML = o.kind === 'rival' ? `<div class="fill" style="width:100%;height:100%;transform:scaleX(-1)">${o.html}</div>` : o.html;
  $('#s5-obstacles').appendChild(el);
  o.el = el;
  const lb = document.createElement('div');
  lb.className = 'abs';
  lb.style.cssText = 'left:0;top:0';
  lb.innerHTML = `<div class="chip" style="font-size:28px;padding:12px 26px;transform:translate(-50%,-50%)"><b>${o.label[0]}</b><small>${o.label[1]}</small></div>`;
  $('#s5-labels').appendChild(lb);
  o.lb = lb;
  o.tIn = o.tc - (1920 + o.w / 2 - 260 - WX) / (V + (o.own || 0));
});
const rivalHair = $('#o-rival .w-hairtail');
const s5w = mountWitch('#s5-willow', 'w5', WILLOW);
const trail5 = makeTrail('#s5-trail', 24, 0.03, 0.75);
const yW = (t) => keys(t, [
  [15.6, 600], [16.5, 780], [17.2, 770], [17.55, 420], [18.1, 420], [18.45, 780], [19.0, 770], [19.35, 410], [19.9, 430],
  [20.5, 862, 'power2.in'], [20.95, 450, 'power2.out'], [21.25, 770], [21.7, 780], [22.0, 790], [22.45, 790], [22.85, 560],
  [23.15, 636, 'power1.in'], [23.6, 380, 'power2.out'], [24.2, 400], [25.0, 410], [25.55, 400], [26.5, 160, 'power2.in'], [28, 160],
]);
// After the drop Willow heads off to the next job, leaving the stage to the review and tip.
const xW = (t) => keys(t, [[25.55, WX], [26.5, 2500, 'power2.in']]);
const HIT = 20.5, BOING = 23.15, DROP = 24.6, LAND = 25.1, LAND_X = 770;
const houseDoorX = (t) => LAND_X + (W(LAND) - W(t));

splitWords('#s5-header .h1');
wordsIn('#s5-header .h1', 16.0, 0.06, 0.5);
tl.from('#s5-header', { y: -220, duration: 0.6, ease: 'back.out(1.4)' }, 15.85);
tl.from('#s5-hud', { x: 520, duration: 0.6, ease: 'back.out(1.4)' }, 16.05);
tl.from('#s5-money', { x: 520, duration: 0.6, ease: 'back.out(1.4)' }, 16.2);
tl.to('#s5-header', { y: -260, duration: 0.45, ease: 'power2.in' }, 25.25);
tl.fromTo('#s5-review', { y: -360 }, { y: 0, duration: 0.6, ease: 'back.out(1.3)' }, 25.55);
[25.85, 26.0, 26.15, 26.3].forEach((at, i) => {
  tl.to(`.s5-star:nth-child(${i + 1}) path`, { fill: C.sun, duration: 0.01 }, at);
  tl.from(`.s5-star:nth-child(${i + 1})`, { scale: 0.3, duration: 0.4, ease: 'back.out(3)' }, at);
  sfx(at, 'snd_increment_4', 0.55);
});
tl.to('.s5-star:nth-child(5)', { rotation: 18, duration: 0.08, yoyo: true, repeat: 5, ease: 'none' }, 26.55);
sfx(15.85, 'snd_button_hover', 0.4);
sfx(18.62, 'snd_caw', 0.7);
sfx(HIT, 'snd_impact_fragile', 0.85);
sfx(BOING, 'snd_boing', 0.7);
sfx(DROP, 'snd_button_hover', 0.45);
sfx(LAND, 'snd_place', 0.9);
sfx(LAND + 0.08, 'snd_ding', 0.6);
sfx(26.45, 'snd_kaching', 0.75);
sfx(26.8, 'snd_cash', 0.6);

// coins flying from the porch to the earnings card
const COINS = 9;
for (let i = 0; i < COINS; i++) {
  const c = document.createElement('div');
  c.className = 'abs s5-coin';
  c.style.cssText = 'left:0;top:0;width:54px;height:54px;margin:-27px 0 0 -27px;visibility:hidden';
  c.innerHTML = coinSVG();
  $('#s5-coins').appendChild(c);
}
const coinEls = $$('.s5-coin');

procs.push((t) => {
  if (t < 15.5 || t > 28.1) return;
  const w = W(t);
  const shake = t > HIT && t < HIT + 0.35 ? (1 - (t - HIT) / 0.35) * 14 : 0;
  $('#s5').style.transform = shake ? `translate(${Math.sin(t * 90) * shake}px, ${Math.cos(t * 77) * shake}px) scale(1.02)` : '';
  const off = (k) => -((w * k) % 1920);
  $('#s5-clouds').style.transform = `translateX(${off(0.08)}px)`;
  $('#s5-far').style.transform = `translateX(${off(0.2)}px)`;
  $('#s5-mid').style.transform = `translateX(${off(0.42)}px)`;
  $('#s5-trees').style.transform = `translateX(${off(0.7)}px)`;
  $('#s5-road').style.transform = `translateX(${off(1)}px)`;
  // house: door (x=247 in the 494px box) lines up with the landing spot at LAND
  $('#s5-house-o').style.transform = `translateX(${houseDoorX(t) - 247}px)`;

  // obstacles + labels
  OBST.forEach((o) => {
    const x = WX + (W(o.tc) - w) + (o.own || 0) * (o.tc - t);
    const vis = x > -400 && x < 2300;
    o.el.style.visibility = o.lb.style.visibility = vis ? 'visible' : 'hidden';
    if (!vis) return;
    let extra = '';
    if (o.kind === 'sword') extra = `rotate(${t * 220}deg)`;
    if (o.kind === 'crystal') extra = `rotate(35deg)`;
    if (o.kind === 'gull') extra = `translateY(${Math.sin(t * 8) * 10}px)`;
    if (o.kind === 'rival') extra = `translateY(${Math.sin(t * 3) * 12}px)`;
    if (o.kind === 'mush') extra = `scale(${1 + 0.12 * bump(t, BOING, 0.3)}, ${1 - 0.2 * bump(t, BOING, 0.3)})`;
    o.el.style.transformOrigin = o.kind === 'mush' ? '50% 100%' : '50% 50%';
    o.el.style.transform = `translate(${x - o.w / 2}px, ${o.y - o.h / 2}px) ${extra}`;
    const s = E('back.out(2.2)')(prog(t, o.tIn + 0.15, o.tIn + 0.5));
    const ly = o.ly ?? (o.below ? o.y + o.h / 2 + 60 : o.y - o.h / 2 - 54);
    o.lb.style.transform = `translate(${x + (o.lx || 0)}px, ${ly}px) scale(${s})`;
  });
  $$('#o-gull .gull-wing, #o-gull .gull-wing-back').forEach((g) => {
    g.style.transformOrigin = '120px 66px';
    g.style.transform = `scaleY(${0.35 + 0.65 * Math.abs(Math.sin(t * 9))})`;
  });
  $$('#o-car .wheel').forEach((g) => { g.style.transformBox = 'fill-box'; g.style.transformOrigin = 'center'; g.style.transform = `rotate(${-t * 900}deg)`; });
  rivalHair.setAttribute('d', hairPath(t, 1.2));

  // Willow
  const y = yW(t);
  const vy = (yW(t + 0.02) - yW(t - 0.02)) / 0.04;
  const rot = clamp(vy * 0.012, -12, 12) + Math.sin(t * 2.5) * 1.5;
  const hurt = t > HIT && t < HIT + 1.0;
  $('#s5-willow-o').style.transform = `translate(${xW(t) - 260}px, ${y - 214}px) rotate(${rot}deg)`;
  $('#s5-willow-o').style.opacity = hurt && Math.floor((t - HIT) / 0.08) % 2 === 0 ? 0.45 : 1;
  s5w.hair(t, 1.2);
  if (t > HIT && t < HIT + 0.45) setFace(s5w.root, 'closed', 'o');
  else if (t > BOING && t < BOING + 0.5) setFace(s5w.root, 'star', 'o');
  else if (t > LAND && t < 28) setFace(s5w.root, 'star', 'smile');
  else setFace(s5w.root, 'open', 'smile');
  trail5(t, (te, age) => (te > 24.4 && te < 25.6 ? null : [xW(te) - 240 - (w - W(te)) - age * 60, yW(te) - 4 + age * 30]));

  // impact burst
  const ib = prog(t, HIT, HIT + 0.35);
  $('#s5-impact').style.visibility = ib > 0 && ib < 1 ? 'visible' : 'hidden';
  $('#s5-impact').style.transform = `translate(${WX + 30}px, ${yW(HIT) + 90}px) scale(${0.3 + E('power2.out')(ib) * 0.9}) rotate(${ib * 40}deg)`;
  $('#s5-impact').style.opacity = 1 - ib;
  $('#s5-flash').style.opacity = 0.18 * bump(t, HIT, 0.2);

  // HUD: lose a pip on the hit
  const hitDone = t >= HIT;
  $('#s5-pips').lastElementChild.style.background = hitDone ? '#E3E2EE' : C.mint;
  $('#s5-cond').textContent = hitDone ? 'Mostly fine' : 'Pristine';
  $('#s5-cond').style.color = hitDone ? C.coral : C.ink;
  $('#s5-hud').style.translate = `${Math.sin(t * 80) * 10 * bump(t, HIT, 0.4)}px 0`;
  $('#p5hud').style.transform = `rotate(${Math.sin(t * 60) * 12 * bump(t, HIT, 0.4)}deg)`;

  // parcel drop
  const pe = $('#s5-parcel');
  if (t < DROP) pe.style.visibility = 'hidden';
  else {
    pe.style.visibility = 'visible';
    const u = prog(t, DROP, LAND);
    const x0 = xW(DROP) + 45, y0 = yW(DROP) + 10, yEnd = 935 - 44;
    const x = t < LAND ? lerp(x0, LAND_X, u) : houseDoorX(t);
    const yy = t < LAND ? lerp(y0, yEnd, E('power2.in')(u)) : yEnd;
    const sq = bump(t, LAND, 0.25);
    pe.style.transformOrigin = '50% 100%';
    pe.style.transform = `translate(${x - 48}px, ${yy - 44}px) rotate(${t < LAND ? u * 340 - 340 : 0}deg) scale(${1 + sq * 0.15}, ${1 - sq * 0.2})`;
  }
  // delivered bubble
  const bb = $('#s5-bubble');
  bb.style.visibility = t > LAND ? 'visible' : 'hidden';
  bb.style.transform = `translate(${houseDoorX(t) - 130}px, ${560 + Math.sin(t * 3) * 6}px) scale(${E('back.out(2)')(prog(t, LAND, LAND + 0.4))})`;
  // coins
  coinEls.forEach((c, i) => {
    const t0 = 26.45 + i * 0.05, u = prog(t, t0, t0 + 0.7);
    if (u <= 0 || u >= 1) return (c.style.visibility = 'hidden');
    c.style.visibility = 'visible';
    const sx = houseDoorX(t0) + (i - 4) * 14, sy = 840, ex = 1500, ey = 294, cx = lerp(sx, ex, 0.3) + (i - 4) * 40, cy = 200 + i * 20;
    const k = E('power1.inOut')(u);
    const bx = (1 - k) ** 2 * sx + 2 * (1 - k) * k * cx + k * k * ex, by = (1 - k) ** 2 * sy + 2 * (1 - k) * k * cy + k * k * ey;
    c.style.transform = `translate(${bx}px, ${by}px) scale(${1 - u * 0.4}) rotate(${u * 360}deg)`;
  });
  $('#s5-money-n').textContent = Math.round(25 * E('power2.out')(prog(t, 26.75, 27.3)));
  $('#s5-money').style.scale = 1 + 0.08 * bump(t, 26.75, 0.3);
});

// ─────────────────────────────────────────────────────────────── S7 · stamina (27.5–32)
put('#s7-blob', texturedBlobSVG('#E3E4FF', '#D6D7FB', 8));
$$('.s7-cloud').forEach((el) => (el.innerHTML = outlineCloudSVG(C.violetLight)));
put('#s7-coffee', coffeeSVG('cf7'));
addDecor('#s7', [
  [bigLeafSVG('#C9CBFF', '#9BA0EF'), -30, 760, 200, 280, 'rotate:-20deg'],
  [bigLeafSVG('#B5B8FA', '#8E91DE'), 90, 820, 160, 230, 'rotate:14deg'],
  [sprigSVG('#9BA0EF', '#6264DC', 6), 1820, 780, 110, 300],
  [dotGrid(C.pink, 4, 4, 26, 5), 870, 120, 100, 100],
  [checkboxSVG(C.violetLight), 840, 860, 56, 56],
], '#s7-sparkles');
tl.fromTo('#s7', { clipPath: 'polygon(110% 0%, 160% 0%, 160% 100%, 140% 100%)' }, { clipPath: 'polygon(-60% 0%, 160% 0%, 160% 100%, -40% 100%)', duration: 0.55, ease: 'power2.inOut' }, 27.45);
splitWords('#s7-q1, #s7-q2, #s7-i2');
tl.from('#s7-bar-card', { y: 80, opacity: 0, duration: 0.55, ease: 'back.out(1.4)' }, 28.0);
wordsIn('#s7-q1', 28.15, 0.1, 0.55);
wordsIn('#s7-q2', 28.9, 0.08, 0.5);
tl.to('#s7-q1, #s7-q2', { y: -60, opacity: 0, duration: 0.3, ease: 'power2.in' }, 29.8);
tl.from('#s7-i1', { y: 20, opacity: 0, duration: 0.4, ease: 'power3.out' }, 30.0);
wordsIn('#s7-i2', 30.1, 0.08, 0.55);
tl.from('#s7-i2 sup', { opacity: 0, scale: 0, duration: 0.3, ease: 'back.out(3)' }, 30.45);
tl.from('#s7-i3', { x: 30, opacity: 0, duration: 0.5, ease: 'power3.out' }, 31.0);
tl.from('#s7-i4', { opacity: 0, duration: 0.4 }, 31.4);
tl.fromTo('#s7-coffee-o', { y: -760, rotation: -20 }, { y: 0, rotation: 0, duration: 0.45, ease: 'bounce.out' }, 30.05);
tl.fromTo('#s7-burst', { scale: 0.3, opacity: 0 }, { scale: 1.1, opacity: 1, duration: 0.25, ease: 'power2.out' }, 30.35);
tl.to('#s7-burst', { opacity: 0, duration: 0.3 }, 30.6);
tl.to('#s7-coffee-o', { x: -110, y: 120, scale: 0.75, rotation: -24, duration: 0.25, ease: 'power2.inOut' }, 30.65);
tl.to('#s7-coffee-o', { scale: 0, opacity: 0, duration: 0.2, ease: 'power2.in' }, 30.9);
sfx(28.0, 'snd_button_hover', 0.4);
sfx(28.95, 'snd_yawn', 0.9);
sfx(30.4, 'snd_impact_subdued', 0.6);
sfx(30.85, 'snd_restore', 0.85);
const w7 = mountWitch('#s7-willow', 'w7', WILLOW);
const f7 = mountWitch('#s7-face', 'f7', WILLOW, '160 30 140 140');
const energy = (t) => keys(t, [[28.05, 1], [29.5, 0.1, 'power1.in'], [30.85, 0.07, 'none'], [31.3, 1, 'back.out(1.6)']]);
const sparks7 = [];
for (let i = 0; i < 14; i++) {
  const d = document.createElement('div');
  d.className = 'sparkle';
  d.style.width = d.style.height = '44px';
  d.innerHTML = `<svg viewBox="0 0 28 28"><path d="${sparklePath(14, 14, 13)}" fill="${[C.sun, C.violet, C.mint, C.pink][i % 4]}"/></svg>`;
  $('#s7-sparkles').appendChild(d);
  sparks7.push(d);
}
procs.push((t) => {
  if (t < 27.4 || t > 32.1) return;
  const en = clamp(energy(t), 0, 1.05);
  const droop = 1 - Math.min(en, 1);
  $('#s7-willow-o').style.transform = `translate(0px, ${Math.sin(t * 2.4) * 14 * (0.4 + en) + droop * 50}px) rotate(${droop * 9 + Math.sin(t * 2.4 + 1) * 1.5}deg)`;
  w7.hair(t, 0.8);
  f7.hair(t, 0);
  $$('.s7-cloud').forEach((c, i) => (c.style.transform = `translateX(${2000 - ((t * (220 + i * 90) + i * 700) % 2400)}px)`));
  let eye = 'open', mouth = 'smile', state = 'Thriving';
  if (en < 0.66) { mouth = 'flat'; state = 'Fine'; }
  if (en < 0.33) { eye = 'tired'; state = 'Running on fumes'; }
  if (en < 0.12) { eye = 'closed'; state = 'Asleep (technically)'; }
  if (t > 28.95 && t < 29.6) { eye = 'closed'; mouth = 'yawn'; }
  if (t > 30.85 && t < 32.1) { eye = 'star'; mouth = 'smile'; state = 'Unstoppable'; }
  setFace(w7.root, eye, mouth);
  setFace(f7.root, eye, mouth);
  $('#s7-state').textContent = state;
  $('#s7-pct').textContent = Math.round(clamp(en, 0, 1) * 100) + '%';
  const fill = $('#s7-fill');
  fill.style.width = clamp(en, 0.02, 1) * 100 + '%';
  fill.style.background = mixColor([C.coral, C.sun, C.mint], (en - 0.1) / 0.8);
  $('#s7-bar-card').style.translate = `${Math.sin(t * 70) * 8 * bump(t, 30.85, 0.3)}px 0`;
  // Zzz while asleep
  const zOn = t > 29.55 && t < 30.75;
  $('#s7-zzz').innerHTML = zOn ? [0, 1, 2].map((i) => {
    const a = ((t - 29.55) * 0.9 + i / 3) % 1;
    return `<span style="position:absolute;left:${a * 90 + i * 10}px;top:${-a * 160}px;opacity:${Math.sin(a * Math.PI)};font-size:${40 + a * 40}px">z</span>`;
  }).join('') : '';
  // sparkle burst on refill
  sparks7.forEach((d, i) => {
    const u = prog(t, 30.85, 31.65);
    if (u <= 0 || u >= 1) return (d.style.visibility = 'hidden');
    const a = (i / sparks7.length) * Math.PI * 2;
    const r = 120 + E('power2.out')(u) * 260;
    d.style.visibility = 'visible';
    d.style.transform = `translate(${400 + Math.cos(a) * r}px, ${600 + Math.sin(a) * r * 0.8}px) scale(${1 - u}) rotate(${u * 180}deg)`;
  });
});

// ─────────────────────────────────────────────────────────────── S8 · KPI dashboard (31.55–40)
put('#s8-blob', texturedBlobSVG('#E3E4FF', '#D3D4FA', 4));
put('#s8-dots', dotGrid(C.violetLight, 6, 4, 30, 6));
put('#s8-coffee', coffeeSVG('cf8'));
put('#s8-award-star', starSVG('#FFFFFF'));
addDecor('#s8', [
  [doodleSVG(C.violetLight, 12), 1200, 0, 520, 260, 'opacity:0.5'],
  [outlineCloudSVG(C.violetLight), 1500, 900, 220, 88, 'opacity:0.7'],
  [checkboxSVG(C.violet), 1780, 280, 56, 56],
  [sprigSVG('#9BA0EF', '#6264DC', 6), 10, 760, 110, 300],
], '#s8-zzz');
$('#s8-boxes').innerHTML = Array.from({ length: 6 }, (_, i) => `<div class="s8-box" style="width:44px;height:40px">${parcelSVG('pb' + i, i === 4)}</div>`).join('');
$('#s8-bars').innerHTML = [0.35, 0.5, 0.62, 0.8, 1].map((h) => `<div class="s8-bar" style="flex:1;height:${h * 100}%;border-radius:12px 12px 6px 6px;background:linear-gradient(180deg,#8587F5,#6264DC);transform-origin:50% 100%"></div>`).join('');
splitWords('#s8-title, #s8-title2');
tl.fromTo('#s8', { clipPath: 'circle(0% at 50% 50%)' }, { clipPath: 'circle(80% at 50% 50%)', duration: 0.5, ease: 'power2.in' }, 31.55);
popIn('#s8-chip', 32.0, { transformOrigin: '0% 50%' });
wordsIn('#s8-title', 32.1, 0.07, 0.55);
tl.from('.s8-card', { y: 140, opacity: 0, duration: 0.6, stagger: 0.5, ease: 'back.out(1.5)' }, 32.5);
[32.5, 33.0, 33.5, 34.0].forEach((at) => sfx(at, 'snd_increment_4', 0.55));
const line8 = $('#s8-line'), lineLen = line8.getTotalLength();
gsap.set(line8, { strokeDasharray: lineLen, strokeDashoffset: lineLen });
tl.to(line8, { strokeDashoffset: 0, duration: 0.9, ease: 'power2.inOut' }, 32.7);
tl.from('.s8-box', { y: -60, opacity: 0, duration: 0.4, stagger: 0.08, ease: 'bounce.out' }, 33.2);
tl.from('.s8-bar', { scaleY: 0, duration: 0.5, stagger: 0.08, ease: 'back.out(1.8)' }, 33.7);
tl.to('.s8-card', { y: 900, rotation: (i) => [-8, 5, -4, 9][i], duration: 0.6, stagger: 0.07, ease: 'power2.in' }, 35.75);
tl.to('#s8-chip', { opacity: 0, duration: 0.3 }, 35.8);
wordsOut('#s8-title', 35.8);
wordsIn('#s8-title2', 36.2, 0.07, 0.55);
tl.from('#s8-award', { x: 260, opacity: 0, duration: 0.6, ease: 'back.out(1.6)' }, 37.1);
tl.from('#s8-award-star', { rotation: -180, scale: 0, duration: 0.6, ease: 'back.out(2)' }, 37.25);
tl.fromTo('#s8-hex', { scale: 0, rotation: -30 }, { scale: 13, rotation: 60, duration: 0.55, ease: 'power3.in' }, 39.35);
sfx(37.15, 'snd_ding', 0.6);
const w8 = mountWitch('#s8-willow', 'w8', WILLOW);
procs.push((t) => {
  if (t < 31.5 || t > 40) return;
  $('#s8-n1').textContent = (4 * E('power2.out')(prog(t, 32.6, 33.4))).toFixed(1);
  $('#s8-n2').textContent = (99.8 * E('power2.out')(prog(t, 33.1, 33.9))).toFixed(1);
  $('#s8-n3').textContent = (1 + E('power2.out')(prog(t, 33.6, 34.3))).toFixed(1);
  $('#s8-n4').style.transform = `rotate(${Math.sin(t * 40) * 8 * bump(t, 34.2, 0.4)}deg)`;
  const x = keys(t, [[35.9, -720], [37.0, 260, 'power3.out'], [40, 330, 'none']]);
  const y = 500 + Math.sin(t * 1.4) * 14;
  $('#s8-willow-o').style.transform = `translate(${x}px, ${y}px) rotate(${6 + Math.sin(t * 1.4) * 2}deg)`;
  w8.hair(t, 0.4);
  setFace(w8.root, 'closed', 'flat');
  $('#s8-zzz').innerHTML = t > 36.6 ? [0, 1, 2].map((i) => {
    const a = ((t - 36.6) * 0.7 + i / 3) % 1;
    return `<span style="position:absolute;left:${x + 360 + a * 110 + i * 12}px;top:${y + 40 - a * 200}px;opacity:${Math.sin(a * Math.PI)};font-size:${44 + a * 44}px">z</span>`;
  }).join('') : '';
});

// ─────────────────────────────────────────────────────────────── S9 · end card (39.85–48)
put('#s9-ring', ring('#FFFFFF', 18));
put('#s9-plus', plus('#FFFFFF', 20));
put('#s9-squig', squiggle('#FFFFFF', 260, 16, 5, 12));
put('#s9-dots', dotGrid('#FFFFFF', 6, 4, 30, 6));
put('#s9-tri', triangle('#FFFFFF', '#FFFFFF'));
addDecor('#s9', [
  [doodleSVG('#FFFFFF', 5), 20, 380, 520, 260, 'opacity:0.18'],
  [outlineCloudSVG('#FFFFFF'), 1450, 380, 240, 96, 'opacity:0.3'],
  [sprigSVG('#8E91F0', '#B5B8FA', 7), 40, 760, 120, 340, 'opacity:0.7'],
  [sprigSVG('#8E91F0', '#B5B8FA', 6, -1), 1780, 780, 110, 300, 'opacity:0.7'],
], '#s9-mark');
put('#s9-mark', logoMarkSVG('lm9', true));
put('#s9-word', wordmarkSVG('wm9', '#FFFFFF', C.sun));
put('#s9-parcel', parcelSVG('p9'));
floaters('#s9 .s9-deco, #s9 .deco', 14);
tl.from('.s9-deco, #s9 .deco', { scale: 0, duration: 0.6, stagger: 0.06, ease: 'back.out(1.8)' }, 39.95);
popIn('#s9-mark', 39.95, { rotation: -120, duration: 0.8 });
tl.fromTo('#s9-word', { clipPath: 'inset(0% 100% 0% 0%)' }, { clipPath: 'inset(0% 0% -20% 0%)', duration: 0.55, ease: 'power3.inOut' }, 40.3);
tl.to('#wm9 .wm-swoosh', { strokeDashoffset: 0, duration: 0.45, ease: 'power2.inOut' }, 40.6);
tl.from('#wm9 .wm-spark', { scale: 0, rotation: -180, transformOrigin: '50% 50%', duration: 0.6, ease: 'back.out(2.5)' }, 40.9);
sfx(40.95, 'snd_ding', 0.55);
tl.from('#s9-tag .wi', { yPercent: 115, duration: 0.45, stagger: 0.5, ease: 'power3.out' }, 41.0);
popIn('#s9-btn', 42.3, { duration: 0.65 });
tl.from('#s9-url', { opacity: 0, y: 16, duration: 0.5, ease: 'power2.out' }, 42.6);
tl.fromTo('#s9-cursor', { x: 1500, y: 1120 }, { x: 1090, y: 790, duration: 0.6, ease: 'power3.out' }, 42.65);
tl.to('#s9-btn', { scale: 0.93, duration: 0.08, ease: 'power1.in' }, 43.3);
tl.to('#s9-btn', { scale: 1, duration: 0.4, ease: 'elastic.out(1.2, 0.4)' }, 43.38);
tl.to('#s9-cursor', { scale: 0.85, duration: 0.08, yoyo: true, repeat: 1 }, 43.3);
gsap.set('#s9-ripple', { x: 960, y: 795, opacity: 0 });
tl.fromTo('#s9-ripple', { scale: 0.3, opacity: 0.9 }, { scale: 2.2, opacity: 0, duration: 0.6, ease: 'power2.out', immediateRender: false }, 43.32);
tl.to('#s9-cursor', { x: 1700, y: 1150, duration: 0.6, ease: 'power2.in' }, 44.1);
tl.fromTo('#s9-fine', { x: 1960 }, { x: -2600, duration: 3.6, ease: 'none' }, 44.3);
tl.to('#s9-fade', { opacity: 1, duration: 0.5, ease: 'power1.in' }, 47.5);
sfx(43.3, 'snd_button_press', 0.6);
const w9 = mountWitch('#s9-willow', 'w9', WILLOW);
const trail9 = makeTrail('#s9-trail');
const s9x = (t) => lerp(-420, 2250, prog(t, 43.8, 45.4));
const S9_DROP = 44.75, S9_LAND = 45.3;
sfx(S9_LAND, 'snd_place', 0.8);
procs.push((t) => {
  if (t < 39.8) return;
  const x = s9x(t), y = 170 + Math.sin(t * 3) * 10;
  $('#s9-willow-o').style.transform = `translate(${x - 208}px, ${y - 171}px) rotate(-3deg)`;
  w9.hair(t, 1.3);
  trail9(t, (te, age) => (te < 43.8 || te > 45.4 ? null : [s9x(te) - 195 - age * 90, 170 + Math.sin(te * 3) * 10 - 8 + age * 40]));
  const pe = $('#s9-parcel');
  if (t < S9_DROP) return (pe.style.visibility = 'hidden');
  pe.style.visibility = 'visible';
  const u = prog(t, S9_DROP, S9_LAND);
  const px = lerp(s9x(S9_DROP) + 40, 1330, E('power1.out')(u));
  const py = lerp(200, 795, E('power2.in')(u));
  const sq = bump(t, S9_LAND, 0.25);
  pe.style.transformOrigin = '50% 100%';
  pe.style.transform = `translate(${px - 55}px, ${py - 50}px) rotate(${(1 - u) * -300}deg) scale(${1 + sq * 0.15}, ${1 - sq * 0.2})`;
});

// ─────────────────────────────────────────────────────────────── render API
window.DURATION = 48;
window.SFX = SFX;
window.renderAt = (t) => {
  tl.seek(t, true);
  procs.forEach((f) => f(t));
};
document.fonts.ready.then(() => {
  window.renderAt(0);
  window.READY = true;
});
