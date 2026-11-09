# Forge 26.3 Generator Support Matrix

This matrix describes the current state of the Forge 26.3 generator. It is not the
final feature matrix.

## Supported

| Area | Status | Notes |
| --- | --- | --- |
| Generator plugin metadata | Supported | `plugin.json` version `2026.3-1.0.13.14-beta` |
| Forge workspace base | Supported | ForgeGradle 7, Gradle 9.8.0, Java 25 |
| `mods.toml` | Supported | Forge `loaderVersion="[66,)"`, Forge/Minecraft dependencies |
| Basic block | Supported | Basic cube geometry, registration and special information tooltips |
| Advanced block bases | Supported | Stairs, slabs, fences, walls, fence gates, trapdoors, doors, panes, leaves, end rods, pressure plates and buttons |
| Signs | Supported | Standing/wall signs and hanging signs with custom Forge sign block entities and renderers |
| Custom block/plant sounds | Supported | Forge-native `DeferredSoundType` resolves sounds at use time |
| Basic item | Supported | Generic item and block item registration, special information tooltips |
| Creative tab | Supported | Custom tabs and vanilla tab contents |
| Plants | Supported | Basic cross/crop/sapling plants, models, loot tables and tags |
| Tools | Supported | Pickaxe, axe, shovel, hoe and sword |
| Armor | Supported | Helmet, chestplate, leggings and boots with equipment assets |
| Block entity | Supported | Inventory, energy storage and single-tank fluid storage |
| Block entity inventory | Supported | Forge `IItemHandler` backed by `InvWrapper` |
| Block entity energy | Supported | Forge `EnergyStorage` / `IEnergyStorage` |
| Block entity fluid tank | Supported | Forge `FluidTank` / `IFluidHandler` |
| Fluids | Supported | Source and flowing fluids, fluid block, dynamic bucket model; Forge default movement || Procedure element | Supported | Java generation with event parameter and chat output templates |
| `player_right_click_block` trigger | Supported | Forge `PlayerInteractEvent.RightClickBlock` |
| Static validation | Supported | YAML, FreeMarker, template references, mappings |

## Not yet supported

| Area | Status | Planned batch |
| --- | --- | --- |
| Item inventories | Pending | Phase 2 |
| Custom armor models and animations | Pending | Phase 1B |
| Living entities, projectiles, special entities | Pending | Phase 1B |
| GUIs, menus, screens, keybinds, overlays | Pending | Phase 1B |
| Biomes, dimensions, features, structures | Pending | Phase 1C |
| Potions, effects, particles, attributes, gamerules | Pending | Phase 1C |
| Remaining procedures (567 total) | Pending | Phase 2 |
| Remaining triggers (64 of 65) | Pending | Phase 3 |
| Variables and player data persistence | Pending | Phase 2 |
| Networking | Pending | Phase 2 |
| Mixin packaging | Pending | Phase 3 |

## Known limitations

- Block entity inventory exposes the full container; side-specific slot restrictions are not applied yet.
- Energy and fluid block entity storage use Forge capability wrappers; transfer procedures are not ported yet.
- Fluid buckets use the Forge `forge:fluid_container` model.
- Custom fluid movement hooks and access-transformer-based extensions are deferred to a later batch; fluid movement uses Forge defaults.
- Item inventories stop generation with an explicit message instead of emitting unsupported code.
- Hanging sign text metrics use the shared `SignBlockEntity` implementation and should be validated in-game.
- Custom armor models, animations, living entities and GUI elements are not yet ported.
- `enumextensions`, NeoForge data maps and item model property events are not ported.
