#!/usr/bin/env python3
"""Copy pxl output (art/scenery/out/sprites/*.png) into GameMaker sprites.

PNGs named <family>_<n>.png become frames of one sprite, spr_scn_<family>.
Re-running is safe: frame/layer ids are derived from the names, so the .yy files
come out identical and only the PNGs are overwritten. New sprites are registered
in HexpressDelivery.yyp under Sprites/Level/Background/Scenery.

Usage (from the repo root):  python3 art/scenery/export_to_gm.py
"""
import json, re, shutil, uuid
from collections import defaultdict
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "art/scenery/out/sprites"
YYP = ROOT / "HexpressDelivery.yyp"
FOLDER_NAME = "Scenery"
FOLDER_PATH = "folders/Sprites/Level/Background/Scenery.yy"
NS = uuid.UUID("6f1c3a52-8f0e-4d6b-9a3e-2b7f1d0c5e11")


def uid(*parts):
    return str(uuid.uuid5(NS, "/".join(parts)))


def frame_json(fid):
    return ('{"$GMSpriteFrame":"v1","%Name":"' + fid + '","name":"' + fid +
            '","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},')


def keyframe_json(name, fid, i):
    return ('{"$Keyframe<SpriteFrameKeyframe>":"","Channels":{"0":{"$SpriteFrameKeyframe":"","Id":{"name":"' + fid +
            '","path":"sprites/' + name + '/' + name + '.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},},'
            '"Disabled":false,"id":"' + uid(name, "key", str(i)) + '","IsCreationKey":false,"Key":' + f"{i:.1f}" +
            ',"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},')


def sprite_yy(name, w, h, bbox, fids, layer_id):
    frames = "\n".join("    " + frame_json(f) for f in fids)
    keys = "\n".join("            " + keyframe_json(name, f, i) for i, f in enumerate(fids))
    l, t, r, b = bbox
    return f'''{{
  "$GMSprite":"v2",
  "%Name":"{name}",
  "bboxMode":0,
  "bbox_bottom":{b},
  "bbox_left":{l},
  "bbox_right":{r},
  "bbox_top":{t},
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
{frames}
  ],
  "gridX":0,
  "gridY":0,
  "height":{h},
  "HTile":false,
  "layers":[
    {{"$GMImageLayer":"","%Name":"{layer_id}","blendMode":0,"displayName":"default","isLocked":false,"name":"{layer_id}","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,}},
  ],
  "name":"{name}",
  "nineSlice":null,
  "origin":0,
  "parent":{{
    "name":"{FOLDER_NAME}",
    "path":"{FOLDER_PATH}",
  }},
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{{
    "$GMSequence":"v1",
    "%Name":"{name}",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{{
      "$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "eventStubScript":null,
    "eventToFunction":{{}},
    "length":{len(fids):.1f},
    "lockOrigin":false,
    "moments":{{
      "$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "name":"{name}",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {{"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
{keys}
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",}},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,}},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":0,
    "yorigin":0,
  }},
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{{
    "name":"Default",
    "path":"texturegroups/Default",
  }},
  "type":0,
  "VTile":false,
  "width":{w},
}}'''


def register(text, section, line, sort_key):
    """Insert `line` into a top-level array of the .yyp text, before the first entry that sorts
    after it (existing entries keep GameMaker's own order), unless it is already there."""
    if line.strip() in text:
        return text
    start = text.index(f'"{section}":[') + len(section) + 4
    end = text.index("\n  ],", start)
    lines = text[start:end].strip("\n").split("\n")
    key = sort_key(line)
    at = next((i for i, l in enumerate(lines) if sort_key(l) > key), len(lines))
    lines.insert(at, line)
    return text[:start] + "\n" + "\n".join(lines) + text[end:]


def name_of(line):
    m = re.search(r'"name":"([^"]+)"', line)
    return m.group(1).lower() if m else line


def main():
    families = defaultdict(list)
    for png in sorted(SRC.glob("*.png")):
        m = re.fullmatch(r"(.+)_(\d+)", png.stem)
        fam, idx = (m.group(1), int(m.group(2))) if m else (png.stem, 0)
        families[fam].append((idx, png))

    yyp = YYP.read_text()
    yyp = register(yyp, "Folders",
                   '    {"$GMFolder":"","%Name":"' + FOLDER_NAME + '","folderPath":"' + FOLDER_PATH +
                   '","name":"' + FOLDER_NAME + '","resourceType":"GMFolder","resourceVersion":"2.0",},',
                   lambda l: re.search(r'"folderPath":"([^"]+)"', l).group(1).lower())

    for fam, items in sorted(families.items()):
        items.sort()
        name = "spr_scn_" + fam
        imgs = [Image.open(p).convert("RGBA") for _, p in items]
        w, h = imgs[0].size
        assert all(i.size == (w, h) for i in imgs), f"{fam}: frames differ in size"
        boxes = [i.getbbox() for i in imgs]
        bbox = (min(b[0] for b in boxes), min(b[1] for b in boxes),
                max(b[2] for b in boxes) - 1, max(b[3] for b in boxes) - 1)

        d = ROOT / "sprites" / name
        if d.exists():
            shutil.rmtree(d)
        layer_id = uid(name, "layer")
        fids = [uid(name, "frame", str(i)) for i in range(len(imgs))]
        for fid, img in zip(fids, imgs):
            (d / "layers" / fid).mkdir(parents=True)
            img.save(d / f"{fid}.png")
            img.save(d / "layers" / fid / f"{layer_id}.png")
        (d / f"{name}.yy").write_text(sprite_yy(name, w, h, bbox, fids, layer_id))
        yyp = register(yyp, "resources",
                       '    {"id":{"name":"' + name + '","path":"sprites/' + name + '/' + name + '.yy",},},',
                       name_of)
        print(f"{name}: {len(imgs)} frame(s), {w}x{h}")

    YYP.write_text(yyp)


if __name__ == "__main__":
    main()
