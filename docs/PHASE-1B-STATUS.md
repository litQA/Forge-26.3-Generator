# Phase 1B Status

Version: `2026.3-1.0.106.107-beta`

This document tracks the Phase 1B feature surface of the Forge 26.3 generator.
Only Forge 26.3 APIs and resources are used by the generator templates.

## Implemented

| Area | Status |
| --- | --- |
| Advanced block bases | Stairs, slabs, fences, walls, fence gates, trapdoors, doors, panes, leaves, end rods, pressure plates, buttons |
| Signs | Standing signs, wall signs, hanging signs, custom sign block entities and renderers |
| Custom block/plant sounds | Forge-native `DeferredSoundType` with registry lookup at playback time |
| Custom armor models | Forge `IClientItemExtensions` / `HumanoidModel` part mapping |
| Custom armor translucency | Custom models can use the translucent render type |
| Living entities | Entity type, attributes, spawn placement, renderer, spawn egg and biome spawn modifier |
| Projectiles | Arrow-style projectiles, custom renderer, shoot helpers and hit procedures |
| Special entities | Basic boat/raft entities with model layers and items |
| GUIs | Basic menus/screens, `ItemStackHandler` slots, button/slider/slot procedures and menu-state sync |
| Keybinds | Forge key mapping registration and `SimpleChannel` press/release procedures |
| Overlays | HUD `ForgeLayeredDraw` overlays and screen-target `ScreenEvent.Render.Post` overlays |
| Dynamic fluid buckets | Forge `forge:fluid_container` model and item-atlas texture copying |
| Custom features/trees | Datapack `configured_feature` / `placed_feature`; trees are data-driven |
| Custom biome overworld generation | Experimental runtime `BiomeSource` wrapper; no public Forge API (see `SUPPORT-MATRIX.md`) |

## Known Limitations

- MCreator armor elements do not expose animation clip fields; external custom
  armor animation clips are outside the element model.
- Screen overlays target known screen classes; arbitrary screen matching is not
  exposed by the element.
- Resources still require a real MCreator/ForgeGradle build and client test.
- Dynamic fluid bucket rendering and custom block/plant sound playback need
  final in-game confirmation.

## Required Regression Test

1. Regenerate the workspace.
2. Run `build`.
3. Test advanced blocks and signs.
4. Test living entity, projectile and boat/raft.
5. Test basic GUI, slots, button/slider/slot procedures.
6. Test keybind press/release.
7. Test HUD and screen overlays.
8. Test custom block/plant sounds.
9. Test dynamic fluid bucket rendering.
