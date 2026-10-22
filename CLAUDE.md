# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Hexpress Delivery is a witch-themed endless runner with delivery mechanics, built in GameMaker (GML). The player, Willow, flies a broom, dodges obstacles, and drops parcels onto house porches for money and ratings. It is published at https://yakisobadayo.itch.io/hexpress-delivery.

The project was last saved with GameMaker IDE `2024.13.1.193` on the monthly (non-LTS) branch. Keep resources compatible with that version.

## Building and running

There is no build script, linter, or test suite. You build and run the game from the GameMaker IDE by opening `HexpressDelivery.yyp`. A GameMaker runtime is not available in the cloud container, so changes there can't be compiled or played. Check GML changes by reading them carefully.

## Editing GameMaker resources by hand

- Code lives in `.gml` files. Object event code is in `objects/<obj>/<Event>_<n>.gml`, for example `Create_0`, `Step_0`, `Draw_0`, `Draw_75` (Draw GUI), `Alarm_N`, `Other_2` (Game Start), `KeyPress_13` (Enter), `Mouse_4` (left pressed), and `Collision_<obj>`. Script resources are in `scripts/<scr>/<scr>.gml`.
- Each resource has a `.yy` metadata file, and every resource is registered in `HexpressDelivery.yyp`. To add a new event, the `.gml` file needs a matching entry in the object's `.yy` `eventList`. To add a new resource, it needs a `.yy` file plus entries in `HexpressDelivery.yyp` and `HexpressDelivery.resource_order`. Without these, GameMaker ignores the file.
- Script resources run at game start. That is why `scr_condition_init` and `scr_money_functions` define globals at file scope.

## Architecture

**Rooms.** `room_menu` is the main menu (`obj_menu_manager`), followed by `room_run`, the gameplay room. `room_run` has three instance layers that the code refers to by name: `Managers`, `Instances`, and `BackgroundObjects`.

**`obj_manager` is the run controller and holds the game state.** Other objects reach into it directly (`obj_manager.stamina`, `obj_manager.register_delivery(...)`, and so on). Its `Create_0` defines the game state enum `GameState { PENDING, ACTIVE, FINISHED }` and the economy/rating functions (`register_hit`, `register_delivery`, `register_rating`, `get_rating_multiplier`, `house_spawn`, `drop_parcel`, `next_delivery`). Its `Step_0` runs the state machine:
- **PENDING:** waits for `global.space_pressed`.
- **ACTIVE:** stamina drains over time, and `section_timer_ticking` counts down by `global.gamespeed`. When the timer hits zero, a new section starts: it destroys everything on the `Managers` layer, spawns a house, rolls new conditions, and spawns their managers. The run ends when stamina reaches 0. Coffee pickups and random car/witch hazards also spawn here.
- **FINISHED:** shows the results; ESC returns to the menu.

**Sections, conditions, and managers.** The obstacle system is data-driven:
1. `scr_condition_init` defines condition structs `{ type, manager }` and two pools: `global.routeConditionsPrimary` (terrain: Horizontal/Vertical/Diagonal) and `global.routeConditionsSecondary` (hazards: Birds/Ghosts/Cars/Witches).
2. `roll_section()` (in `scr_managing_functions`) picks one primary condition. It adds a secondary hazard 50% of the time once `current_section > 1`, and always in debug mode.
3. `spawn_managers()` creates each condition's manager on the `Managers` layer and passes `type` as an instance variable. One manager object can serve several types: `obj_obstacle_manager` branches on `type` for terrain, and `obj_car_manager` handles both Cars and Witches.

To add a new obstacle type, define a condition struct, add it to a pool, and handle its `type` in a manager. Use a new manager object only if the existing ones don't fit.

**Collision via parent objects.** `obj_player` collides against two parent objects:
- `obj_collide` is solid: the player stops on it. Its children are `obj_obstacle` (which in turn is the parent of `obj_obstaclevert` and `obj_obstaclediagonal`), `obj_obstaclehori` (the mushroom bounce pad), `obj_cloud_ceiling`, and `obj_projectile`.
- `obj_kill` damages the player. Its children are `obj_bird`, `obj_car`, `obj_witch`, and `obj_riser`.

Either kind of contact calls `get_hit()`, which damages the parcel, stuns the player, and starts i-frames. `obj_boundary` is the floor and ceiling. A new hazard should usually inherit from one of these parents rather than add new checks to the player.

**Scrolling world.** The player stays in place horizontally while world objects move left. Scrolling objects call `auto_scroll()` and `destroy_offscreen()` from `scr_scrolling_functions`, both driven by `global.gamespeed`.

**How a delivery works.**
1. A house spawns with each section. `obj_house` creates an `obj_house_porch_hitbox` to go with it.
2. When the player drops a parcel near the nearest undelivered house, `obj_manager.drop_parcel()` creates an `obj_parcel` and passes the `current_parcel` struct (`hits`/`max_hits`) as instance variables.
3. When the parcel lands, it computes `hit multiplier × distance multiplier`. The distance tiers, from best to worst, are full porch, partial porch, house, partial house, and miss. The result is converted to a 0–5 star rating, then passed to `register_rating` and `register_delivery`.
4. If a house scrolls offscreen without a delivery, its `Destroy_0` event registers a 0-star rating and resets the streak.

Tips are calculated as `base_tip × delivery multiplier × rating multiplier`. Stamina also affects flight: `obj_player.stamina_mod()` weakens boosting and strengthens gravity when stamina is below 33%.

**Globals.** `obj_menu_manager`'s Game Start event (`Other_2`) initialises `global.debug_mode`, `global.mute_music`, `global.mute_sfx`, and `global.space_pressed`. `obj_manager` sets `global.gamespeed`. `global.money` persists across runs.

**Debug mode.** Enter the Konami code on the menu to toggle `global.debug_mode`. It shows a debug overlay in `obj_manager`'s `Draw_0`, forces a secondary hazard every section, and makes Enter spawn a car or witch. `show_debug_message` is used heavily for tracing.

**Audio.** Music is in `audiogroup_music`, which `obj_menu_manager` loads. The `obj_toggle_music` and `obj_toggle_sfx` buttons control muting.

## Dead code

Much of the codebase is commented out with `/*/ ... */` toggles, and there are unused functions such as `roll_random_section()`, which references a `global.route_conditions` that no longer exists. Treat these as historical, not live behaviour.
