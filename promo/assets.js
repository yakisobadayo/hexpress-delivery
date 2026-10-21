// Procedural flat-vector assets for the Hexpress promo.
// Every asset is built from primitives, using the game sprites and Willow's character sheet as reference.

const C = {
  ink: '#1D1B38', violet: '#6264DC', violetDeep: '#3D34A5', violetLight: '#9BA0EF',
  blue: '#2F8CFF', sky: '#D4E6FF', coral: '#FF6B4A', peach: '#FFB38A', sun: '#FFC83D',
  mint: '#3DD6A8', pink: '#FF8FB1', cream: '#FFF6EC', skin: '#F7DCC5', skinDark: '#E6BB9C',
  hair: '#6B4430', silver: '#C9CBD9',
};

// Willow's courier uniform: periwinkle/navy jacket, reflective stripe, bob haircut, wide-brim hat.
const WILLOW = {
  jacketTop: '#6E70E6', jacketTop2: '#5654CC', jacketBot: '#3E3C7C', jacketBot2: '#2C2A60',
  sleeve: '#3E3C7C', sleeveBack: '#2C2A60', cuff: '#33316C', stripe: '#CDD0DE',
  hatTop: '#6E70E6', hatBot: '#5654CC', hatUnder: '#4342A8',
  hair: '#6B4430', hairDark: '#4E2F20', skin: '#F7DCC5', skinDark: '#E6BB9C', eye: '#3A4366',
  shorts: '#1B1A26', sock: '#FFFFFF', sockShade: '#DADCE8', boot: '#1B1A26', strap: '#1B1A26', logo: true,
};
const RIVAL = {
  jacketTop: '#4FD1AE', jacketTop2: '#2FB592', jacketBot: '#1E7F6D', jacketBot2: '#16604F',
  sleeve: '#1E7F6D', sleeveBack: '#16604F', cuff: '#1A6E5E', stripe: '#FFE08A',
  hatTop: '#3FA88B', hatBot: '#1F6F60', hatUnder: '#17594C',
  hair: '#C2452F', hairDark: '#8E2F1F', skin: '#F2C9A6', skinDark: '#DDA884', eye: '#1D1B38',
  shorts: '#1B1A26', sock: '#FFE08A', sockShade: '#E9C76A', boot: '#3B2A22', strap: '#3B2A22', logo: false,
};

// Witch on a broom, facing right. viewBox 0 0 420 320, broom handle at y≈214.
function witchSVG(id, P = WILLOW) {
  const g = (n) => `${id}-${n}`;
  // Corporate-memphis proportions: long shins, chunky boots.
  const leg = (dx, shorts, skin, sock, shade) => `
    <path d="M${200 + dx} 210 L${238 + dx} 216" stroke="${shorts}" stroke-width="25" stroke-linecap="round"/>
    <path d="M${236 + dx} 216 L${252 + dx} 218 L${264 + dx} 266" stroke="${skin}" stroke-width="15" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M${262 + dx} 254 L${268 + dx} 288" stroke="${sock}" stroke-width="17" stroke-linecap="round"/>
    <path d="M${259 + dx} 258 L${273 + dx} 256" stroke="${shade}" stroke-width="4" stroke-linecap="round"/>
    <path d="M${252 + dx} 290 C${252 + dx} 280 ${274 + dx} 278 ${280 + dx} 284 L${304 + dx} 296 C${314 + dx} 302 ${311 + dx} 314 ${298 + dx} 314 L${258 + dx} 314 C${248 + dx} 314 ${248 + dx} 302 ${252 + dx} 290 Z" fill="${P.boot}"/>
    <path d="M${251 + dx} 309 L${308 + dx} 309" stroke="#3A3950" stroke-width="6" stroke-linecap="round"/>
    <path d="M${266 + dx} 288 l7 3 M${273 + dx} 285 l7 3 M${280 + dx} 288 l7 3" stroke="#FFFFFF" stroke-width="2.6" stroke-linecap="round" opacity="0.8"/>`;
  return `<svg class="witch" id="${id}" viewBox="0 0 420 320" overflow="visible">
  <defs>
    <linearGradient id="${g('top')}" x1="0" y1="0" x2="0.4" y2="1"><stop offset="0" stop-color="${P.jacketTop}"/><stop offset="1" stop-color="${P.jacketTop2}"/></linearGradient>
    <linearGradient id="${g('bot')}" x1="0" y1="0" x2="0.3" y2="1"><stop offset="0" stop-color="${P.jacketBot}"/><stop offset="1" stop-color="${P.jacketBot2}"/></linearGradient>
    <linearGradient id="${g('hat')}" x1="0.1" y1="0" x2="0.9" y2="1"><stop offset="0" stop-color="${P.hatTop}"/><stop offset="1" stop-color="${P.hatBot}"/></linearGradient>
    <linearGradient id="${g('stick')}" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#8E552A"/><stop offset="1" stop-color="#D0935A"/></linearGradient>
    <linearGradient id="${g('straw')}" x1="1" y1="0" x2="0" y2="0"><stop offset="0" stop-color="#F2C46D"/><stop offset="1" stop-color="#D99447"/></linearGradient>
    <clipPath id="${g('torso')}"><path d="M198 124 C186 150 180 182 174 208 C196 218 234 218 254 206 C248 178 244 150 238 124 Z"/></clipPath>
  </defs>
  <path class="w-hairtail" fill="${P.hairDark}" d=""/>
  <path d="M208 140 C226 176 242 196 262 204" stroke="${P.sleeveBack}" stroke-width="24" fill="none" stroke-linecap="round"/>
  <circle cx="270" cy="208" r="12" fill="${P.skinDark}"/>
  <circle cx="262" cy="204" r="14" fill="${P.sleeveBack}"/>
  <g class="w-broom">
    <path fill="url(#${g('straw')})" d="M128 200 C96 192 54 178 12 168 C22 182 24 194 18 202 C26 208 26 218 10 236 C54 232 96 226 128 222 Z"/>
    <path d="M114 205 L42 190 M114 211 L28 212 M114 217 L44 230" stroke="#C47E36" stroke-width="3.5" stroke-linecap="round" opacity="0.6"/>
    <rect x="118" y="196" width="18" height="30" rx="6" fill="${P.jacketTop2}"/>
    <rect x="130" y="208" width="282" height="12" rx="6" fill="url(#${g('stick')})"/>
    <circle cx="410" cy="214" r="7" fill="#8E552A"/>
  </g>
  <g opacity="0.92">${leg(-12, '#12111A', P.skinDark, P.sockShade, '#C4C6D4')}</g>
  ${leg(0, P.shorts, P.skin, P.sock, P.sockShade)}
  <g clip-path="url(#${g('torso')})">
    <rect x="160" y="110" width="110" height="60" fill="url(#${g('top')})"/>
    <rect x="160" y="168" width="110" height="60" fill="url(#${g('bot')})"/>
    <path d="M160 164 L214 164 L220 156 L227 164 L270 164 L270 176 L160 176 Z" fill="${P.stripe}"/>
    <path d="M160 168 L270 168" stroke="#FFFFFF" stroke-width="2" opacity="0.6"/>
    <path d="M206 128 C196 142 190 152 184 166" stroke="${P.stripe}" stroke-width="6" fill="none" stroke-linecap="round"/>
    <rect x="212" y="184" width="34" height="22" rx="5" fill="${P.jacketBot2}"/>
    <path d="M212 190 L246 190" stroke="${P.jacketBot}" stroke-width="3"/>
    ${P.logo ? `<path d="${sparklePath(232, 142, 5)}" fill="#FFFFFF" opacity="0.9"/><path d="M216 147 Q226 151 236 146" stroke="#FFFFFF" stroke-width="1.6" fill="none" opacity="0.8"/>` : ''}
  </g>
  <path d="M234 128 L186 198" stroke="${P.strap}" stroke-width="5" stroke-linecap="round"/>
  <rect x="210" y="110" width="13" height="16" rx="5" fill="${P.skinDark}"/>
  <path d="M200 112 L236 112 L240 130 C226 136 210 136 196 130 Z" fill="url(#${g('top')})"/>
  <path d="M206 112 L232 112 L234 120 L204 120 Z" fill="${P.jacketTop2}"/>
  <g class="w-head">
    <path fill="${P.hair}" d="M196 76 C188 92 186 108 186 122 C196 126 206 124 214 118 L214 76 Z"/>
    <circle cx="214" cy="90" r="27" fill="${P.hair}"/>
    <circle cx="226" cy="97" r="22" fill="${P.skin}"/>
    <path fill="${P.hair}" d="M200 72 C216 62 242 68 249 90 Q244 94 240 92 Q238 86 234 94 Q230 86 225 93 Q222 85 216 88 C210 88 204 82 200 72 Z"/>
    <path fill="${P.hair}" d="M212 84 C206 98 208 112 214 124 C220 120 222 108 220 94 Z"/>
    <path fill="${P.skin}" d="M246 98 C251 100 251 106 246 107 Z"/>
    <ellipse cx="236" cy="108" rx="5" ry="3.2" fill="#FF8FA0" opacity="0.45"/>
    <g class="w-eye w-eye-open"><ellipse cx="238" cy="98" rx="3.5" ry="5.2" fill="${P.eye}"/><circle cx="239.2" cy="95.6" r="1.4" fill="#FFFFFF"/></g>
    <g class="w-eye w-eye-tired" style="display:none"><path d="M233 97 Q238 95 243 97" stroke="${P.eye}" stroke-width="2.6" fill="none" stroke-linecap="round"/><path d="M234.5 98 Q238 102 241.5 98" fill="${P.eye}"/></g>
    <g class="w-eye w-eye-closed" style="display:none"><path d="M233 98 Q238 102 243 98" stroke="${P.eye}" stroke-width="2.6" fill="none" stroke-linecap="round"/></g>
    <g class="w-eye w-eye-star" style="display:none"><path d="${sparklePath(238, 97, 7)}" fill="${C.sun}"/></g>
    <g class="w-mouth w-mouth-smile"><path d="M236 112 Q240 115 244 111" stroke="${C.ink}" stroke-width="2.2" fill="none" stroke-linecap="round"/></g>
    <g class="w-mouth w-mouth-flat" style="display:none"><path d="M237 113 L244 112" stroke="${C.ink}" stroke-width="2.2" fill="none" stroke-linecap="round"/></g>
    <g class="w-mouth w-mouth-yawn" style="display:none"><ellipse cx="241" cy="114" rx="4" ry="5.6" fill="${C.ink}"/><ellipse cx="241" cy="117" rx="2.5" ry="2" fill="${C.coral}"/></g>
    <g class="w-mouth w-mouth-o" style="display:none"><ellipse cx="242" cy="113" rx="2.8" ry="3.4" fill="${C.ink}"/></g>
  </g>
  <g class="w-hat">
    <path class="w-hatcone" fill="url(#${g('hat')})" d="M186 70 C190 44 182 26 156 14 C176 6 200 10 214 24 C228 38 242 52 250 64 Z"/>
    <path d="M190 52 C206 48 230 46 244 52" stroke="${P.hatBot}" stroke-width="4" fill="none" opacity="0.6" stroke-linecap="round"/>
    <path fill="${P.hatUnder}" d="M148 80 C160 67 198 61 232 59 C266 57 292 62 294 70 C292 78 266 83 236 85 C198 87 160 89 148 80 Z"/>
    <path fill="url(#${g('hat')})" d="M148 78 C160 63 198 57 232 55 C266 53 292 58 294 66 C290 72 266 76 236 78 C198 80 160 86 148 78 Z"/>
  </g>
  <path d="M228 136 C250 164 264 188 286 200" stroke="${P.sleeve}" stroke-width="27" fill="none" stroke-linecap="round"/>
  <path d="M230 140 C246 160 256 176 270 188" stroke="#FFFFFF" stroke-width="3" fill="none" opacity="0.12" stroke-linecap="round"/>
  <circle cx="301" cy="213" r="13" fill="${P.skin}"/><path d="M296 222 Q304 226 310 220" stroke="${P.skinDark}" stroke-width="3" fill="none" stroke-linecap="round"/>
  <path d="M276 196 L298 188 Q306 196 302 210 L282 212 Z" fill="${P.cuff}"/>
</svg>`;
}

function setFace(el, eye, mouth) {
  el.querySelectorAll('.w-eye').forEach((e) => (e.style.display = e.classList.contains('w-eye-' + eye) ? '' : 'none'));
  el.querySelectorAll('.w-mouth').forEach((e) => (e.style.display = e.classList.contains('w-mouth-' + mouth) ? '' : 'none'));
}

// Bob-haircut ends fluttering in the wind. Called every frame.
function hairPath(t, gust = 1) {
  const w = (k) => Math.sin(t * 10 + k) * 3 * gust;
  const tx = 170 - gust * 8;
  return `M204 72 C188 76 178 92 ${174 - gust * 4 + w(0)} 108 ` +
    `Q${tx + w(1)} 118 ${tx + 4 + w(2)} 124 Q${tx + 10 + w(3)} 122 ${tx + 12 + w(4)} 128 ` +
    `Q${tx + 22 + w(5)} 126 ${tx + 26} 132 C196 132 210 128 214 118 Z`;
}

// White Hexpress box with the periwinkle brand band (from the character sheet).
function parcelSVG(id, dented = 0) {
  return `<svg class="parcel" id="${id}" viewBox="0 0 120 110" overflow="visible">
    <path fill="#FFFFFF" d="M12 36 L58 16 L108 32 L62 54 Z"/>
    <path fill="#EEF0F7" d="M12 36 L62 54 L62 104 L12 84 Z"/>
    <path fill="#D3D7E6" d="M62 54 L108 32 L108 82 L62 104 Z"/>
    <path fill="#E2E5EF" d="M30 28 L78 46 L86 42.5 L38 24.6 Z"/>
    <path fill="${C.violet}" d="M12 72 L62 92 L62 100 L12 80 Z"/>
    <path fill="${C.violetDeep}" d="M62 92 L108 70 L108 78 L62 100 Z"/>
    <path d="M${45} 70 l1.4 3.6 3.6 1.4 -3.6 1.4 -1.4 3.6 -1.4 -3.6 -3.6 -1.4 3.6 -1.4 Z" fill="${C.violet}"/>
    <path d="M18 60 Q30 68 40 68" stroke="${C.violet}" stroke-width="2.5" fill="none" stroke-linecap="round"/>
    ${dented ? '<path d="M80 50 L90 58 L82 66 L94 74" stroke="#8C90A8" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>' : ''}
  </svg>`;
}

function coinSVG(id = '') {
  return `<svg class="coin" ${id ? `id="${id}"` : ''} viewBox="0 0 60 60">
    <circle cx="30" cy="30" r="28" fill="#F0A21C"/>
    <circle cx="30" cy="28" r="26" fill="${C.sun}"/>
    <circle cx="30" cy="28" r="18" fill="none" stroke="#F0A21C" stroke-width="4"/>
    <path d="M30 17 L33.2 25 L41.5 26 L35 31.6 L37 40 L30 35.4 L23 40 L25 31.6 L18.5 26 L26.8 25 Z" fill="#FFF3C4"/>
  </svg>`;
}

function starSVG(fill = C.sun) {
  return `<svg viewBox="0 0 40 40"><path d="M20 2 L25.3 13.5 L38 15 L28.6 23.6 L31.2 36 L20 29.8 L8.8 36 L11.4 23.6 L2 15 L14.7 13.5 Z" fill="${fill}" stroke-linejoin="round"/></svg>`;
}

function sparklePath(cx, cy, r) {
  const k = r * 0.22;
  return `M${cx} ${cy - r} C${cx + k} ${cy - k} ${cx + k} ${cy - k} ${cx + r} ${cy} C${cx + k} ${cy + k} ${cx + k} ${cy + k} ${cx} ${cy + r} C${cx - k} ${cy + k} ${cx - k} ${cy + k} ${cx - r} ${cy} C${cx - k} ${cy - k} ${cx - k} ${cy - k} ${cx} ${cy - r} Z`;
}


// App-icon mark: rounded hexagon, sparkle and swoosh.
function logoMarkSVG(id, light = false) {
  const bg1 = light ? '#FFFFFF' : '#7C7EF0', bg2 = light ? '#ECEBFF' : '#3D34A5';
  const fg = light ? C.violet : '#FFFFFF';
  return `<svg class="logomark" id="${id}" viewBox="0 0 200 200" overflow="visible">
    <defs><linearGradient id="${id}-g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${bg1}"/><stop offset="1" stop-color="${bg2}"/></linearGradient></defs>
    <path class="lm-hex" fill="url(#${id}-g)" d="M100 8 Q108 8 116 12.5 L172 45 Q180 49.5 180 58 L180 142 Q180 150.5 172 155 L116 187.5 Q108 192 100 192 Q92 192 84 187.5 L28 155 Q20 150.5 20 142 L20 58 Q20 49.5 28 45 L84 12.5 Q92 8 100 8 Z"/>
    <path class="lm-swoosh" d="M44 128 C76 150 120 148 150 112" stroke="${fg}" stroke-width="12" fill="none" stroke-linecap="round"/>
    <path class="lm-spark" fill="${fg}" d="${sparklePath(104, 88, 42)}"/>
    <path class="lm-spark2" fill="${C.sun}" d="${sparklePath(150, 52, 14)}"/>
  </svg>`;
}

// Wordmark after the character sheet: italic serif "Hexpress", underline swoosh, sparkle.
function wordmarkSVG(id, color = C.ink, accent = C.violet) {
  return `<svg class="wordmark" id="${id}" viewBox="0 0 700 210" overflow="visible">
    <text class="wm-text" x="20" y="128" font-family="DM Serif Display" font-style="italic" font-size="148" fill="${color}" letter-spacing="-2">Hexpress</text>
    <path class="wm-swoosh" d="M78 166 C220 202 470 198 612 124" stroke="${color}" stroke-width="9" fill="none" stroke-linecap="round"/>
    <path class="wm-spark" fill="${accent}" d="${sparklePath(640, 104, 40)}"/>
  </svg>`;
}

// House after the resprite's spr_new_house: dusty brick, slate roof with dormers, red door.
function houseSVG(id) {
  const win = (x, y, w, h) => `<rect x="${x - 6}" y="${y - 6}" width="${w + 12}" height="${h + 12}" rx="6" fill="#F4F2EE"/><rect x="${x}" y="${y}" width="${w}" height="${h}" rx="3" fill="#4F7480"/><path d="M${x + 6} ${y + h - 8} L${x + w - 10} ${y + 6}" stroke="#7FA6B0" stroke-width="7" stroke-linecap="round"/><rect x="${x + w / 2 - 2}" y="${y}" width="4" height="${h}" fill="#F4F2EE"/>`;
  return `<svg class="house" id="${id}" viewBox="0 0 520 520" overflow="visible">
    <defs>
      <linearGradient id="${id}-wall" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#DDB09A"/><stop offset="1" stop-color="#C38B75"/></linearGradient>
      <linearGradient id="${id}-roof" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#9A9DA8"/><stop offset="1" stop-color="#727684"/></linearGradient>
    </defs>
    <rect x="96" y="22" width="32" height="70" rx="5" fill="#823C3D"/><rect x="90" y="16" width="44" height="12" rx="5" fill="#9E5051"/>
    <rect x="380" y="22" width="32" height="70" rx="5" fill="#823C3D"/><rect x="374" y="16" width="44" height="12" rx="5" fill="#9E5051"/>
    <path fill="url(#${id}-roof)" d="M52 190 L86 74 Q90 64 102 64 L404 64 Q416 64 420 74 L454 190 Z"/>
    <path fill="#823C3D" d="M454 190 L420 74 Q430 72 436 84 L486 196 L486 500 L454 500 Z"/>
    <g>${win(150, 96, 52, 58)}<path d="M138 92 L176 72 L214 92 Z" fill="#F4F2EE"/>${win(302, 96, 52, 58)}<path d="M290 92 L328 72 L366 92 Z" fill="#F4F2EE"/></g>
    <rect x="58" y="190" width="396" height="310" fill="url(#${id}-wall)"/>
    <rect x="44" y="184" width="420" height="16" rx="6" fill="#F4F2EE"/>
    <rect x="58" y="330" width="396" height="10" fill="#F4F2EE" opacity="0.8"/>
    <g fill="#B97A64" opacity="0.7"><rect x="76" y="226" width="26" height="9" rx="3"/><rect x="88" y="242" width="18" height="9" rx="3"/><rect x="404" y="360" width="26" height="9" rx="3"/><rect x="392" y="376" width="18" height="9" rx="3"/><rect x="80" y="430" width="26" height="9" rx="3"/><rect x="250" y="226" width="22" height="9" rx="3"/></g>
    <g>${win(118, 226, 72, 84)}${win(322, 226, 72, 84)}${win(118, 366, 72, 84)}${win(322, 366, 72, 84)}</g>
    <path d="M204 394 A56 56 0 0 1 316 394 Z" fill="#F4F2EE"/>
    <path d="M216 394 A44 44 0 0 1 304 394 Z" fill="#4F7480"/>
    <path d="M260 394 L260 352 M260 394 L232 362 M260 394 L288 362" stroke="#F4F2EE" stroke-width="4"/>
    <rect x="204" y="394" width="112" height="106" rx="4" fill="#F4F2EE"/>
    <rect x="218" y="402" width="84" height="98" rx="4" fill="#E03C28"/>
    <rect x="228" y="412" width="28" height="36" rx="4" fill="#C2301F"/><rect x="264" y="412" width="28" height="36" rx="4" fill="#C2301F"/>
    <rect x="228" y="456" width="28" height="36" rx="4" fill="#C2301F"/><rect x="264" y="456" width="28" height="36" rx="4" fill="#C2301F"/>
    <circle cx="292" cy="452" r="5" fill="${C.sun}"/>
    <rect x="186" y="496" width="148" height="16" rx="6" fill="#8A8D99"/>
    <g class="h-mat"><rect x="216" y="486" width="88" height="12" rx="6" fill="${C.violet}"/></g>
  </svg>`;
}

function swordSVG(id) {
  return `<svg id="${id}" viewBox="0 0 80 360" overflow="visible">
    <defs><linearGradient id="${id}-b" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#E8F4FF"/><stop offset="0.5" stop-color="#B9D3EE"/><stop offset="0.5" stop-color="#8FB1D6"/><stop offset="1" stop-color="#A9C4E2"/></linearGradient></defs>
    <path fill="url(#${id}-b)" d="M40 0 L56 30 L56 250 L24 250 L24 30 Z"/>
    <rect x="0" y="246" width="80" height="20" rx="10" fill="${C.sun}"/>
    <rect x="30" y="264" width="20" height="64" rx="8" fill="${C.violet}"/>
    <circle cx="40" cy="338" r="16" fill="${C.sun}"/>
  </svg>`;
}

function baguetteSVG(id) {
  return `<svg id="${id}" viewBox="0 0 90 380" overflow="visible">
    <defs><linearGradient id="${id}-g" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#E9A35A"/><stop offset="1" stop-color="#B86A2C"/></linearGradient></defs>
    <rect x="5" y="0" width="80" height="380" rx="40" fill="url(#${id}-g)"/>
    <g stroke="#FFD99A" stroke-width="10" stroke-linecap="round"><path d="M30 60 L58 92"/><path d="M30 130 L58 162"/><path d="M30 200 L58 232"/><path d="M30 270 L58 302"/></g>
  </svg>`;
}

function brambleSVG(id) {
  let thorns = '';
  for (let i = 0; i < 8; i++) {
    const y = 30 + i * 44, side = i % 2 ? 1 : -1;
    const x = 50 + Math.sin(i * 1.3) * 16;
    thorns += `<path d="M${x + side * 10} ${y} L${x + side * 36} ${y - 10} L${x + side * 12} ${y + 12} Z" fill="${C.pink}"/>`;
    if (i % 3 === 1) thorns += `<ellipse cx="${x - side * 24}" cy="${y + 14}" rx="16" ry="8" transform="rotate(${side * 30} ${x - side * 24} ${y + 14})" fill="#7ED957"/>`;
  }
  let d = 'M50 0';
  for (let i = 1; i <= 20; i++) d += ` L${(50 + Math.sin(i * 0.6) * 16).toFixed(1)} ${i * 19}`;
  return `<svg id="${id}" viewBox="0 0 100 380" overflow="visible">
    <path d="${d}" stroke="#2E9E58" stroke-width="22" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="${d}" stroke="#58C977" stroke-width="8" fill="none" stroke-linecap="round" stroke-linejoin="round" transform="translate(-4 0)"/>
    ${thorns}
  </svg>`;
}

function crystalSVG(id) {
  return `<svg id="${id}" viewBox="0 0 120 420" overflow="visible">
    <path d="M60 0 L100 60 L100 360 L60 420 L20 360 L20 60 Z" fill="#3FC6F5"/>
    <path d="M60 0 L60 420 L20 360 L20 60 Z" fill="#8BE3FF"/>
    <path d="M60 0 L100 60 L60 80 L20 60 Z" fill="#D6F6FF"/>
    <path d="M36 110 L36 300" stroke="#FFFFFF" stroke-width="8" stroke-linecap="round" opacity="0.8"/>
  </svg>`;
}

function seagullSVG(id) {
  return `<svg id="${id}" viewBox="0 0 220 140" overflow="visible">
    <path class="gull-wing-back" d="M112 62 C122 34 142 14 174 6 C164 30 150 52 136 68 Z" fill="#C3CCDD"/>
    <path d="M40 74 C40 50 70 42 110 48 L196 66 C190 82 168 92 140 94 L70 96 C52 96 40 88 40 74 Z" fill="#FFFFFF"/>
    <path d="M150 70 L212 52 L206 72 L160 88 Z" fill="#DCE3EE"/>
    <circle cx="58" cy="66" r="5" fill="${C.ink}"/>
    <path d="M42 70 L8 80 L42 82 Z" fill="${C.sun}"/>
    <path d="M24 80 L42 82 L30 86 Z" fill="${C.coral}"/>
    <path class="gull-wing" d="M84 70 C92 40 110 14 146 2 C140 30 128 56 116 74 Z" fill="#9AA8C0"/><path d="M128 18 C136 10 142 6 146 2 C144 12 140 20 136 26 Z" fill="#2E3550"/>
    <path d="M96 96 L92 116 M118 96 L118 116" stroke="${C.coral}" stroke-width="6" stroke-linecap="round"/>
  </svg>`;
}

function carSVG(id) {
  return `<svg id="${id}" viewBox="0 0 340 200" overflow="visible">
    <defs><linearGradient id="${id}-g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFB547"/><stop offset="1" stop-color="#FF7A2F"/></linearGradient></defs>
    <path d="M20 140 C20 112 40 100 64 96 L96 44 C104 30 118 24 136 24 L224 24 C244 24 260 34 268 52 L290 96 C314 100 326 116 326 140 L326 150 C326 158 320 164 312 164 L34 164 C26 164 20 158 20 150 Z" fill="url(#${id}-g)"/>
    <path d="M112 50 C116 42 124 40 134 40 L170 40 L170 94 L88 94 Z" fill="${C.sky}"/>
    <path d="M186 40 L224 40 C236 40 244 46 250 56 L268 94 L186 94 Z" fill="${C.sky}"/>
    <rect x="22" y="118" width="22" height="14" rx="6" fill="#FFF3C4"/>
    <rect x="302" y="118" width="22" height="12" rx="6" fill="${C.coral}"/>
    <g class="wheel"><circle cx="94" cy="164" r="32" fill="${C.ink}"/><circle cx="94" cy="164" r="13" fill="#B8C3D6"/></g>
    <g class="wheel"><circle cx="258" cy="164" r="32" fill="${C.ink}"/><circle cx="258" cy="164" r="13" fill="#B8C3D6"/></g>
  </svg>`;
}

function mushroomSVG(id) {
  return `<svg id="${id}" viewBox="0 0 300 240" overflow="visible">
    <path d="M118 90 L182 90 L192 240 L108 240 Z" fill="#FFE2C2"/>
    <path d="M150 90 L182 90 L192 240 L160 240 Z" fill="#F5C9A0"/>
    <path class="mush-cap" d="M10 110 C10 40 80 0 150 0 C220 0 290 40 290 110 C290 122 280 128 268 128 L32 128 C20 128 10 122 10 110 Z" fill="#FF5252"/>
    <g fill="#FFFFFF"><circle cx="80" cy="56" r="20"/><circle cx="160" cy="32" r="16"/><circle cx="222" cy="72" r="22"/><circle cx="130" cy="94" r="12"/><circle cx="40" cy="104" r="9"/></g>
  </svg>`;
}

function coffeeSVG(id) {
  return `<svg id="${id}" viewBox="0 0 220 300" overflow="visible">
    <defs><linearGradient id="${id}-g" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#5BB4FF"/><stop offset="1" stop-color="#1F6FE0"/></linearGradient></defs>
    <path d="M30 70 L190 70 L168 280 C167 290 160 296 150 296 L70 296 C60 296 53 290 52 280 Z" fill="url(#${id}-g)"/>
    <path d="M40 160 L180 160 L172 236 L48 236 Z" fill="#1F4FB0" opacity="0.35"/>
    <path d="M86 128 L136 128 L136 146 L106 146 L106 170 L130 170 L130 188 L106 188 L106 212 L138 212 L138 230 L86 230 Z" fill="#FFFFFF"/>
    <path d="M56 270 L164 270 L162 284 C161 291 156 296 150 296 L70 296 C64 296 59 291 58 284 Z" fill="#FFFFFF"/>
    <rect x="16" y="44" width="188" height="34" rx="12" fill="#2B3A67"/>
    <path d="M40 46 C44 22 64 14 110 14 C156 14 176 22 180 46 Z" fill="#3D4F86"/>
    <rect x="94" y="0" width="32" height="20" rx="8" fill="#2B3A67"/>
    <rect x="24" y="56" width="172" height="8" rx="4" fill="#6F86C4"/>
  </svg>`;
}

// Memphis decoration primitives
function squiggle(color, w = 220, amp = 16, n = 5, sw = 12) {
  let d = `M${sw} ${amp + sw}`;
  const step = (w - sw * 2) / n;
  for (let i = 0; i < n; i++) d += ` q${step / 2} ${i % 2 ? amp * 2 : -amp * 2} ${step} 0`;
  return `<svg viewBox="0 0 ${w} ${amp * 2 + sw * 2}" overflow="visible"><path d="${d}" stroke="${color}" stroke-width="${sw}" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
}
function dotGrid(color, cols = 6, rows = 4, gap = 26, r = 5) {
  let s = '';
  for (let i = 0; i < cols; i++) for (let j = 0; j < rows; j++) s += `<circle cx="${r + i * gap}" cy="${r + j * gap}" r="${r}" fill="${color}"/>`;
  return `<svg viewBox="0 0 ${r * 2 + (cols - 1) * gap} ${r * 2 + (rows - 1) * gap}">${s}</svg>`;
}
function halfCircle(c1, c2) {
  return `<svg viewBox="0 0 200 100"><defs><linearGradient id="hc${c1.slice(1)}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c1}"/><stop offset="1" stop-color="${c2}"/></linearGradient></defs><path d="M0 100 A100 100 0 0 1 200 100 Z" fill="url(#hc${c1.slice(1)})"/></svg>`;
}
function ring(color, sw = 22) {
  return `<svg viewBox="0 0 200 200"><circle cx="100" cy="100" r="${100 - sw / 2}" fill="none" stroke="${color}" stroke-width="${sw}"/></svg>`;
}
function triangle(c1, c2) {
  return `<svg viewBox="0 0 200 180" overflow="visible"><defs><linearGradient id="tr${c1.slice(1)}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c1}"/><stop offset="1" stop-color="${c2}"/></linearGradient></defs><path d="M100 8 Q108 0 114 10 L194 160 Q200 172 186 172 L14 172 Q0 172 6 160 L86 10 Q92 0 100 8 Z" fill="url(#tr${c1.slice(1)})"/></svg>`;
}
function plus(color, sw = 20) {
  return `<svg viewBox="0 0 100 100"><path d="M50 ${sw / 2} V${100 - sw / 2} M${sw / 2} 50 H${100 - sw / 2}" stroke="${color}" stroke-width="${sw}" stroke-linecap="round"/></svg>`;
}
function blob(c1, c2, seed = 1) {
  const pts = [];
  const N = 8;
  for (let i = 0; i < N; i++) {
    const a = (i / N) * Math.PI * 2;
    const r = 80 + Math.sin(seed * 3.1 + i * 2.3) * 14;
    pts.push([100 + Math.cos(a) * r, 100 + Math.sin(a) * r]);
  }
  let d = '';
  for (let i = 0; i < N; i++) {
    const p0 = pts[(i - 1 + N) % N], p1 = pts[i], p2 = pts[(i + 1) % N], p3 = pts[(i + 2) % N];
    if (i === 0) d += `M${p1[0].toFixed(1)} ${p1[1].toFixed(1)}`;
    const c1x = p1[0] + (p2[0] - p0[0]) / 6, c1y = p1[1] + (p2[1] - p0[1]) / 6;
    const c2x = p2[0] - (p3[0] - p1[0]) / 6, c2y = p2[1] - (p3[1] - p1[1]) / 6;
    d += ` C${c1x.toFixed(1)} ${c1y.toFixed(1)} ${c2x.toFixed(1)} ${c2y.toFixed(1)} ${p2[0].toFixed(1)} ${p2[1].toFixed(1)}`;
  }
  const gid = 'bl' + seed;
  return `<svg viewBox="0 0 200 200" overflow="visible"><defs><linearGradient id="${gid}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c1}"/><stop offset="1" stop-color="${c2}"/></linearGradient></defs><path d="${d}Z" fill="url(#${gid})"/></svg>`;
}
function cloudSVG(color = '#FFFFFF') {
  return `<svg viewBox="0 0 300 120" overflow="visible"><path d="M30 120 C0 120 0 80 30 78 C26 44 70 30 92 50 C104 14 160 6 182 40 C204 20 252 30 250 70 C284 66 300 120 262 120 Z" fill="${color}"/></svg>`;
}

// Seeded random for deterministic skylines
function rng(seed) {
  let s = seed >>> 0;
  return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296);
}

function skylineSVG(width, height, seed, c1, c2, winColor, minH, maxH) {
  const r = rng(seed);
  let x = 0, s = '';
  const gid = 'sky' + seed;
  while (x < width) {
    const w = 80 + r() * 120, h = minH + r() * (maxH - minH);
    const y = height - h;
    const kind = r();
    if (kind < 0.25) s += `<path d="M${x} ${height} L${x} ${y + w / 2} A${w / 2} ${w / 2} 0 0 1 ${x + w} ${y + w / 2} L${x + w} ${height} Z" fill="url(#${gid})"/>`;
    else if (kind < 0.45) s += `<path d="M${x} ${height} L${x} ${y + 30} L${x + w / 2} ${y - 10} L${x + w} ${y + 30} L${x + w} ${height} Z" fill="url(#${gid})"/>`;
    else s += `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="6" fill="url(#${gid})"/>`;
    if (winColor) {
      for (let wy = y + 40; wy < height - 30; wy += 34)
        for (let wx = x + 16; wx < x + w - 24; wx += 28) if (r() < 0.55) s += `<rect x="${wx}" y="${wy}" width="12" height="16" rx="3" fill="${winColor}"/>`;
    }
    x += w + 6 + r() * 20;
  }
  return `<svg viewBox="0 0 ${width} ${height}" width="${width}" height="${height}"><defs><linearGradient id="${gid}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${c1}"/><stop offset="1" stop-color="${c2}"/></linearGradient></defs>${s}</svg>`;
}

// Round clustered trees after the resprite's spr_new_tree.
function treesSVG(width, height, seed) {
  const r = rng(seed);
  let x = 0, s = '';
  while (x < width) {
    const h = 90 + r() * 110, w = 80 + r() * 50, cx = x + w / 2, top = height - 40 - h;
    s += `<rect x="${cx - 7}" y="${height - 50}" width="14" height="50" rx="4" fill="#343434"/>`;
    s += `<rect x="${x}" y="${top}" width="${w}" height="${h}" rx="${w / 2}" fill="#06724F"/>`;
    s += `<circle cx="${cx - w * 0.18}" cy="${top + w * 0.42}" r="${w * 0.36}" fill="#20B562"/>`;
    s += `<circle cx="${cx + w * 0.16}" cy="${top + w * 0.3}" r="${w * 0.28}" fill="#3CCB7A"/>`;
    x += w + 50 + r() * 240;
  }
  return `<svg viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">${s}</svg>`;
}

function handIcon(color = C.ink) {
  return `<svg viewBox="0 0 100 120" overflow="visible"><path d="M40 10 C40 2 54 2 54 10 L54 54 L56 40 C56 32 70 32 70 40 L70 58 L72 48 C72 40 86 40 86 48 L86 80 C86 104 72 116 54 116 L46 116 C34 116 26 110 20 100 L6 72 C2 64 12 56 20 64 L40 84 Z" fill="${C.skin}" stroke="${color}" stroke-width="5" stroke-linejoin="round"/></svg>`;
}

// Memphis scenery from the style references: sprigs, leaves, line doodles, outlined clouds, textured blobs.
function sprigSVG(c1, c2, n = 6, flip = 1) {
  let s = '';
  for (let i = 0; i < n; i++) {
    const y = 360 - i * 52, side = i % 2 ? 1 : -1, sz = 1 - i * 0.08;
    s += `<path d="M60 ${y} C${60 + side * 40 * sz} ${y - 30} ${60 + side * 90 * sz} ${y - 30} ${60 + side * 110 * sz} ${y - 60} C${60 + side * 70 * sz} ${y - 66} ${60 + side * 24 * sz} ${y - 50} 60 ${y} Z" fill="${i % 2 ? c1 : c2}"/>`;
  }
  return `<svg viewBox="-60 0 240 380" overflow="visible" style="transform:scaleX(${flip})"><path d="M60 380 C62 260 56 160 64 40" stroke="${c2}" stroke-width="6" fill="none" stroke-linecap="round"/>${s}</svg>`;
}
function bigLeafSVG(c1, c2) {
  return `<svg viewBox="0 0 300 420" overflow="visible"><path d="M150 410 C40 330 10 180 120 10 C250 150 270 300 150 410 Z" fill="${c1}"/><path d="M150 410 C150 300 140 160 120 20" stroke="${c2}" stroke-width="6" fill="none"/>
    <g stroke="${c2}" stroke-width="4" fill="none" stroke-linecap="round"><path d="M146 320 L90 280"/><path d="M144 250 L76 200"/><path d="M140 180 L92 130"/><path d="M148 290 L206 240"/><path d="M144 210 L200 160"/></g></svg>`;
}
function doodleSVG(color, seed = 1) {
  const r = rng(seed);
  let d = 'M10 150';
  for (let i = 0; i < 4; i++) {
    const x = 60 + i * 110, y = 60 + r() * 120;
    d += ` C${x - 20} ${y - 80} ${x + 70} ${y - 60} ${x + 40} ${y} C${x + 10} ${y + 60} ${x - 40} ${y + 10} ${x + 20} ${y - 30}`;
  }
  return `<svg viewBox="0 0 500 260" overflow="visible"><path d="${d}" stroke="${color}" stroke-width="3" fill="none" stroke-linecap="round"/></svg>`;
}
function outlineCloudSVG(color) {
  return `<svg viewBox="0 0 300 120" overflow="visible"><path d="M30 118 C2 118 2 80 30 78 C26 44 70 30 92 50 C104 14 160 6 182 40 C204 20 252 30 250 70 C284 66 298 118 262 118 Z" fill="none" stroke="${color}" stroke-width="5" stroke-linejoin="round"/></svg>`;
}
function texturedBlobSVG(c1, c2, seed = 2) {
  const r = rng(seed);
  let marks = '';
  for (let i = 0; i < 7; i++) {
    const x = 30 + r() * 140, y = 30 + r() * 140, l = 20 + r() * 30;
    marks += `<path d="M${x} ${y} c${l / 3} ${-l / 2} ${l} ${-l / 3} ${l} ${l / 4} s${l / 2} ${l / 2} ${l / 3} ${l / 2}" stroke="${c2}" stroke-width="7" fill="none" stroke-linecap="round"/>`;
  }
  const b = blob(c1, c1, seed);
  const d = b.match(/<path d="([^"]+)"/)[1];
  return b.replace('</svg>', `<clipPath id="tb${seed}"><path d="${d}"/></clipPath><g clip-path="url(#tb${seed})">${marks}</g></svg>`);
}
function checkboxSVG(color) {
  return `<svg viewBox="0 0 60 60" overflow="visible"><rect x="4" y="10" width="44" height="44" rx="4" fill="none" stroke="${color}" stroke-width="4"/><path d="M14 30 L26 42 L56 4" stroke="${color}" stroke-width="5" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
}
