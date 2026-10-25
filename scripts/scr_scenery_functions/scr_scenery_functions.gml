/// Scenery: background props spawned in streams instead of tiled background layers.
///
/// Each parallax layer (Houses, Trees, Wall) gets one obj_scenery_layer holding a SceneryStream.
/// A stream walks a cursor along the street, picking weighted entries from its pool and placing
/// their sprites edge to edge (plus spacing/gaps), so the street never repeats on a fixed period.
///
/// Pool entry options (all optional, ranges are [min, max] in px or counts):
///   run     - how many times the entry repeats before another is picked (a terrace row)
///   spacing - space between items inside a run (negative overlaps, e.g. clumped trees)
///   gap     - space after the run ends
///   edge    - sprite placed before and after a run (e.g. wall piers)
///   plain   - chance of frame 0 on multi-frame sprites; other frames share the rest (rare details)
///   flip    - may be mirrored horizontally

#macro SCENERY_BASELINE 352   // street line: bottom row of every prop sits here
#macro SCENERY_MARGIN   96    // spawn this far past the right edge of the room

/// @func scenery_entry(_spr, _weight, [_opts])
/// @param {Asset.GMSprite|Array<Asset.GMSprite>} _spr  One sprite, or several to pick from per item
function scenery_entry(_spr, _weight, _opts = {}) {
    return {
        spr     : _spr,
        weight  : _weight,
        run     : _opts[$ "run"]     ?? [1, 1],
        spacing : _opts[$ "spacing"] ?? [0, 0],
        gap     : _opts[$ "gap"]     ?? [0, 0],
        edge    : _opts[$ "edge"]    ?? undefined,
        plain   : _opts[$ "plain"]   ?? -1,
        flip    : _opts[$ "flip"]    ?? false,
    };
}

/// @func scenery_pick_entry(_pool, _exclude)
/// @desc  Weighted random pick, never returning _exclude (unless it's the only entry)
function scenery_pick_entry(_pool, _exclude) {
    var _total = 0;
    for (var i = 0; i < array_length(_pool); i++) {
        if (_pool[i] != _exclude) _total += _pool[i].weight;
    }
    var _r = random(_total);
    for (var i = 0; i < array_length(_pool); i++) {
        var _e = _pool[i];
        if (_e == _exclude) continue;
        _r -= _e.weight;
        if (_r < 0) return _e;
    }
    return _pool[array_length(_pool) - 1];
}

/// @func SceneryStream(_parallax, _pool)
/// @param {Real}          _parallax  Fraction of global.gamespeed this layer scrolls at
/// @param {Array<Struct>} _pool      Entries made with scenery_entry()
function SceneryStream(_parallax, _pool) constructor {
    parallax = _parallax;
    pool     = _pool;
    props    = [];                // { spr, img, x, flip }
    cursor   = -irandom(64);      // x where the next prop starts
    entry    = undefined;         // entry of the current run
    run_left = 0;
    last_spr = -1;
    last_img = -1;

    static step = function() {
        var _dx = global.gamespeed * parallax;
        cursor -= _dx;
        for (var i = array_length(props) - 1; i >= 0; i--) {
            var _p = props[i];
            _p.x -= _dx;
            if (_p.x + sprite_get_width(_p.spr) < 0) array_delete(props, i, 1);
        }
        while (cursor < room_width + SCENERY_MARGIN) spawn_next();
    }

    static draw = function() {
        for (var i = 0; i < array_length(props); i++) {
            var _p = props[i];
            var _w = sprite_get_width(_p.spr);
            draw_sprite_ext(_p.spr, _p.img,
                floor(_p.x) + (_p.flip ? _w : 0), SCENERY_BASELINE - sprite_get_height(_p.spr),
                _p.flip ? -1 : 1, 1, 0, c_white, 1);
        }
    }

    static place = function(_spr, _img, _flip) {
        array_push(props, { spr: _spr, img: _img, x: cursor, flip: _flip });
        cursor += sprite_get_width(_spr);
    }

    static spawn_next = function() {
        // Start a new run
        if (run_left <= 0) {
            entry    = scenery_pick_entry(pool, entry);
            run_left = irandom_range(entry.run[0], entry.run[1]);
            if (entry.edge != undefined) place(entry.edge, 0, false);
        }

        // Pick a sprite (avoiding the one just placed) and a frame
        var _spr = entry.spr;
        if (is_array(_spr)) {
            var _n = array_length(_spr);
            do { _spr = entry.spr[irandom(_n - 1)]; } until (_n == 1 || _spr != last_spr);
        }
        var _frames = sprite_get_number(_spr);
        var _img = 0;
        if (_frames > 1) {
            if (entry.plain >= 0) {
                _img = (random(1) < entry.plain) ? 0 : irandom_range(1, _frames - 1);
            } else {
                do { _img = irandom(_frames - 1); } until (_spr != last_spr || _img != last_img);
            }
        }

        place(_spr, _img, entry.flip && irandom(1));
        last_spr = _spr;
        last_img = _img;

        // Spacing within the run, or close the run off
        run_left -= 1;
        if (run_left > 0) {
            cursor += irandom_range(entry.spacing[0], entry.spacing[1]);
        } else {
            if (entry.edge != undefined) place(entry.edge, 0, false);
            cursor += irandom_range(entry.gap[0], entry.gap[1]);
        }
    }

    // Fill the screen straight away so the route doesn't start empty
    // (after the statics above are declared, so they exist on first construction)
    while (cursor < room_width + SCENERY_MARGIN) spawn_next();
}

/// @func scenery_pools()
/// @desc  What each layer is built from. Tweak weights here to change the feel of the street.
function scenery_pools() {
    var _trees = [spr_scn_tree_oak, spr_scn_tree_young, spr_scn_tree_lime, spr_scn_tree_autumn,
                  spr_scn_tree_blossom, spr_scn_tree_poplar, spr_scn_tree_pine, spr_scn_tree_topiary];
    var _shops = [spr_scn_shop_news, spr_scn_shop_bakery, spr_scn_shop_florist, spr_scn_shop_chippy,
                  spr_scn_shop_cafe, spr_scn_pub];
    return {
        // Back row: terraces in runs, a parade of shops now and then, the odd landmark
        houses : [
            scenery_entry(spr_scn_terrace_red,     5,   { run: [3, 7], gap: [0, 24] }),
            scenery_entry(spr_scn_terrace_yellow,  4,   { run: [3, 6], gap: [0, 24] }),
            scenery_entry(spr_scn_terrace_painted, 3,   { run: [3, 6], gap: [0, 24] }),
            scenery_entry(_shops,                  3,   { run: [2, 4], gap: [0, 16] }),
            scenery_entry(spr_scn_villa,           1.5, { gap: [8, 32], flip: true }),
            scenery_entry(spr_scn_church,          0.6, { gap: [16, 48] }),
            scenery_entry(spr_scn_flats,           0.6, { gap: [16, 40] }),
        ],
        // Middle: street trees with lamp posts and street furniture between them
        trees : [
            scenery_entry(_trees,             6,   { run: [1, 3], spacing: [-14, 6], gap: [24, 96], flip: true }),
            scenery_entry(spr_scn_lamp,       3,   { gap: [32, 96] }),
            scenery_entry(spr_scn_postbox,    1,   { gap: [24, 64] }),
            scenery_entry(spr_scn_phonebox,   0.7, { gap: [24, 64] }),
            scenery_entry(spr_scn_busstop,    0.8, { gap: [32, 80] }),
            scenery_entry(spr_scn_sign,       0.7, { gap: [24, 64], flip: true }),
            scenery_entry(spr_scn_bench,      0.8, { gap: [16, 48] }),
        ],
        // Front: an unbroken boundary of walls, railings, hedges and fences
        wall : [
            scenery_entry(spr_scn_wall_brick,   5,   { run: [4, 10], plain: 0.75, edge: spr_scn_wall_pier }),
            scenery_entry(spr_scn_wall_railing, 3,   { run: [3, 8],  edge: spr_scn_wall_pier }),
            scenery_entry(spr_scn_wall_hedge,   3,   { run: [3, 8],  plain: 0.6 }),
            scenery_entry(spr_scn_wall_picket,  2,   { run: [3, 6] }),
            scenery_entry(spr_scn_wall_stone,   2,   { run: [3, 8] }),
            scenery_entry(spr_scn_wall_fence,   2,   { run: [3, 6] }),
            scenery_entry(spr_scn_wall_gate,    0.6),
            scenery_entry(spr_scn_wall_cat,     0.4),
            scenery_entry(spr_scn_wall_bin,     0.5),
        ],
    };
}

/// @func scenery_init()
/// @desc  Creates one obj_scenery_layer per parallax layer. Call once from obj_manager's Create.
function scenery_init() {
    var _pools = scenery_pools();
    // [layer, fraction of gamespeed, pool] - speeds match the old tiled layers (2.0 / 2.75 / 3.2)
    var _layers = [
        ["Houses", 0.5,    _pools.houses],
        ["Trees",  0.6875, _pools.trees],
        ["Wall",   0.8,    _pools.wall],
    ];
    for (var i = 0; i < array_length(_layers); i++) {
        instance_create_layer(0, 0, _layers[i][0], obj_scenery_layer, {
            stream : new SceneryStream(_layers[i][1], _layers[i][2]),
        });
    }
}

/// @func scenery_sync_tiled_layers()
/// @desc  Keeps the remaining tiled layers moving at their share of global.gamespeed,
///        so speeding the route up later doesn't leave them sliding against everything else.
function scenery_sync_tiled_layers() {
    static _tiled = [["Ground", 1], ["City", 0.1], ["Clouds", 0.05], ["Background", 0.05]];
    for (var i = 0; i < array_length(_tiled); i++) {
        var _layer = layer_get_id(_tiled[i][0]);
        if (_layer != -1) layer_hspeed(_layer, -global.gamespeed * _tiled[i][1]);
    }
}
