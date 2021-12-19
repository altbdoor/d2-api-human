---
type: page
layout: single
title: Data interface
weight: 2
---

### Basic interface

Here's a sample JSON data of [Ignition Code](https://www.light.gg/db/items/304659313/ignition-code/), available at either:

- https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/id/304659313.json, or
- https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/name/ignitioncode.json

```json {}
{
  "id": 304659313,
  "name": "Ignition Code",
  "icon": "/common/destiny2_content/icons/392e194e5ca22ba379c482ecde77c029.jpg",
  "watermark": "/common/destiny2_content/icons/b07d89064a1fc9a8e061f59b7c747fa5.png",
  "screenshot": "/common/destiny2_content/screenshots/304659313.jpg",
  "flavor_text": "\"I can decode anything with a grenade launcher.\" —Saint-14",
  "weapon_tier": "legendary",
  "ammo_type": "special",
  "element_class": "kinetic",
  "weapon_type": "grenade_launcher",
  "powercap": null,
  "frame": {
    "name": "Lightweight Frame",
    "description": "One-shot handheld Grenade Launcher with remote detonation. \n[Shoot]  : Fire; release to detonate.",
    "icon": "/common/destiny2_content/icons/530b400d5cec3bf6aca7c5efc46fea20.png"
  },
  "stats": {
    // ...
  },
  "perks": [
    // ...
  ]
}
```

Most of the top level data is pretty self-explanatory, like `id`, `name`, and `icon`. And most of them have basic, primitive data types. The exception are the following properties, that have the following valid values:

```ts {}
export interface Weapon {
  weapon_tier: 'common' | 'exotic' | 'legendary' | 'rare' | 'uncommon';
  ammo_type: 'heavy' | 'primary' | 'special';
  element_class: 'arc' | 'kinetic' | 'solar' | 'stasis' | 'void';
  weapon_type:
    | 'auto_rifle'
    | 'bow'
    | 'fusion_rifle'
    | 'grenade_launcher'
    | 'hand_cannon'
    | 'linear_fusion_rifle'
    | 'machinegun'
    | 'pulse_rifle'
    | 'rocket_launcher'
    | 'scout_rifle'
    | 'shotgun'
    | 'sidearm'
    | 'sniper_rifle'
    | 'submachinegun'
    | 'sword'
    | 'trace_rifle';
}
```

The values are subject to change, of course, should Bungie decide to add a new weapon type, or element class.

### Powercap

`powercap` can either be `null`, to denote that there is no power limit, or a number specifying the power limit. As an example, [The Mountaintop](https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/id/3993415705.json) has `{ "powercap": 1060 }`.

### Frame

Usually all weapons have their own frame, like `Lightweight Frame` or `Aggressive Frame`. But for exotics, they usually have their special perk in here. As an example, [Heir Apparent](https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/id/2084878005.json) has the `Heavy Slug Thrower` perk.

```json {hl_lines=["4", "13"]}
// ignition code
{
  "frame": {
    "name": "Lightweight Frame",
    "description": "One-shot handheld Grenade Launcher with remote detonation. \n[Shoot]  : Fire; release to detonate.",
    "icon": "/common/destiny2_content/icons/530b400d5cec3bf6aca7c5efc46fea20.png"
  }
}

// heir apparent
{
  "frame": {
    "name": "Heavy Slug Thrower",
    "description": "[Aim Down Sights]  : Spins up this weapon. This weapon can be fired only when fully spun up.",
    "icon": "/common/destiny2_content/icons/653012d0d76014430f6688e254e36b67.png"
  }
}
```

### Stats

The `stats` have all the necessary information on the weapon stats. Even hidden stats like `recoil_direction` and `aim_assistance` is provided.

```json {}
{
  "stats": {
    "recoil_direction": 75,
    "magazine": 1,
    "velocity": 75,
    "inventory_size": 64,
    "blast_radius": 55,
    "handling": 68,
    "stability": 35,
    "zoom": 13,
    "aim_assistance": 71,
    "reload_speed": 68,
    "rounds_per_minute": 90
  }
}
```

### Perks

The `perks` are a little more complicated to digest. A weapon usually have three to four perk slots, and Ignition Code has four.

```json {}
{
  "perks": [
    [],     // perks in slot 1
    [],     // perks in slot 2
    [],     // perks in slot 3
    []      // perks in slot 4
  ]
}
```

In each slot, there are different perks that can go into the slot. To demonstrate, here are the first two perks for slot 1 and slot 2.

```json {hl_lines=["7-26", "32-47"]}
{
  "perks": [
    // ====================
    // perks in slot 1
    // ====================
    [
      {
        "icon": "/common/destiny2_content/icons/402765b86ff7b1d97078ac43d5ca39ad.png",
        "description": "This weapon is optimized for an especially explosive payload.\n  •  Greatly increases blast radius\n  •  Slightly decreases handling speed\n  •  Slightly decreases projectile speed",
        "name": "Volatile Launch",
        "stats": {
          "velocity": -5,
          "handling": -5,
          "blast_radius": 15
        }
      },
      {
        "icon": "/common/destiny2_content/icons/c9439f5d740d017dc9551a60a902c797.png",
        "description": "This weapon's launch parameters are particularly stable.\n  •  Greatly increases stability\n  •  Increases blast radius\n  •  Decreases projectile speed",
        "name": "Confined Launch",
        "stats": {
          "velocity": -10,
          "stability": 15,
          "blast_radius": 10
        }
      }
    ],
    // ====================
    // perks in slot 2
    // ====================
    [
      {
        "icon": "/common/destiny2_content/icons/c0dde588e1a32760621859e496d2e657.png",
        "description": "Grenade detonation has a brief blinding effect.\n  •  Greatly decreases blast radius.",
        "name": "Blinding Grenades",
        "stats": {
          "blast_radius": -200
        }
      },
      {
        "icon": "/common/destiny2_content/icons/88869f977fa3d145c1ece3e38c070bd2.png",
        "description": "Grenades fired from this weapon have increased proximity detection but a decreased blast radius.",
        "name": "Proximity Grenades",
        "stats": {
          "blast_radius": -20
        }
      }
    ],
    [],     // perks in slot 3
    []      // perks in slot 4
  ]
}
```

Once again, `icon`, `description`, and `name` is also self-explanatory. The `stats` will have the information that affects the weapon stats.
