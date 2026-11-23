# Hexpress Delivery!
A witch-themed endless runner with delivery mechanics! GameMaker project I made for school. 

https://yakisobadayo.itch.io/hexpress-delivery

<img width="420" height="334" alt="hexpresscovertest" src="https://github.com/user-attachments/assets/f560847e-0c75-4119-bbb3-4ea47de010c7" />


## Update: The Night Shift

Banked money is now worth something, and each shift gets harder the longer it runs.

**Willow's Workshop (upgrade shop)**: open **Shop** from the main menu and spend your wallet on permanent upgrades:

| Upgrade | Effect | Levels |
|---|---|---|
| Bigger Thermos | +15 max energy | 3 |
| Strong Brew | Potions of Caffeine restore +10 energy | 3 |
| Bubble Wrap | Each parcel shrugs off 1 hit or hard landing (shown as a ring on the HUD parcel) | 2 |
| Tip Charm | +10% tips | 3 |

**Saving**: wallet, upgrades and lifetime stats are saved to `hexpress_save.ini`. The menu shows your wallet, best shift, best streak and shifts worked.

**Gameplay**
- **Speed ramp**: the world speeds up a little with every house (4 → 6.5 max), and the parallax backgrounds speed up with it. A popup warns you every 5 houses.
- **Streaks pay**: the streak multiplier (+10% per great delivery, up to 2×) now applies to tips, and the HUD shows your current streak.
- **Delivery popups**: floating "PERFECT!" / "Great!" / "Missed!" text and "+$N" appear where the parcel lands. Coffee pickups show how much energy you got back.
- Energy thresholds (Willow's expressions, bar colour, yawn, coffee spawns) work on percentages, so they still behave with a bigger thermos.

**Shift Report**: the new end-of-shift panel shows money, deliveries, best streak, average rating and houses passed, flashes **NEW BEST!** on records and shows your wallet. Press **SPACE** or click for another shift right away, or **ESC** to go back to the menu.

**Debug** (Konami code on the menu): press `M` in the shop for +$500, or `Shift+Delete` on the menu to wipe your save.
