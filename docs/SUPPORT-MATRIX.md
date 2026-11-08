# Phase 0 Support Matrix

This matrix describes the state of the Forge 26.3 generator after the Phase 0 batch.
It is not the final feature matrix.

## Supported

| Area | Status | Notes |
| --- | --- | --- |
| Generator plugin metadata | Supported | `plugin.json` version `2026.3-1.0.1.2-beta` |
| Forge workspace base | Supported | ForgeGradle 7, Gradle 9.8.0, Java 25 |
| `mods.toml` | Supported | Forge `loaderVersion="[66,)"`, Forge/Minecraft dependencies |
| Basic block | Supported | Basic cube geometry and registration |
| Basic item | Supported | Generic item and block item registration |
| Creative tab | Supported | Custom tabs and vanilla tab contents |
| Procedure element | Supported | Java generation, no event-type dependency |
| `player_right_click_block` trigger | Supported | Forge `PlayerInteractEvent.RightClickBlock` |
| Static validation | Supported | YAML, FreeMarker, template references, mappings |

## Not yet supported

| Area | Status | Planned batch |
| --- | --- | --- |
| Block bases (stairs, slabs, fences, walls, doors, signs, etc.) | Pending | Phase 1A/1B |
| Block entities, inventories, energy, fluids | Pending | Phase 1A/1B |
| Tools, armor, item extensions, armor trims | Pending | Phase 1A |
| Living entities, projectiles, special entities | Pending | Phase 1B |
| GUIs, menus, screens, keybinds, overlays | Pending | Phase 1B |
| Biomes, dimensions, features, structures | Pending | Phase 1C |
| Potions, effects, particles, attributes, gamerules | Pending | Phase 1C |
| Remaining procedures (567 total) | Pending | Phase 2 |
| Remaining triggers (64 of 65) | Pending | Phase 3 |
| Variables and player data persistence | Pending | Phase 2 |
| Networking | Pending | Phase 2 |
| Capabilities and resource handlers | Pending | Phase 2 |
| Mixin and access transformer packaging | Pending | Phase 3 |

## Known limitations

- Basic block/item/tab/procedure/trigger only.
- The generated workspace build has not yet been verified in the current environment
  because ForgeGradle access-transformer processing is blocked locally.
- Advanced block bases and element types are not silently generated yet; they are
  outside this batch.
- `enumextensions`, NeoForge data maps and item model property events are not ported.
