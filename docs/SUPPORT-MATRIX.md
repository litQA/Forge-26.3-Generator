# Forge 26.3 Generator Support Matrix

This matrix describes the current state of the Forge 26.3 generator. It is not the
final feature matrix.

## Supported

| Area | Status | Notes |
| --- | --- | --- |
| Generator plugin metadata | Supported | `plugin.json` version `2026.3-1.0.105.106-beta` |
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
| Custom armor models | Supported | Basic `HumanoidModel` part mapping through Forge `IClientItemExtensions` |
| Custom armor translucency | Supported | Translucent render type for custom armor models |
| Living entities | Supported | Basic entity type, attributes, spawn placement, renderer and spawn egg |
| Living entity biome spawning | Supported | Forge `forge:add_spawns` biome modifiers |
| Projectiles | Supported | Basic arrow-style projectiles, custom renderer and shoot helpers |
| Special entities | Supported | Basic boat/raft entities with model layers, renderers and items |
| Overlays | Supported | Basic HUD and screen overlays using Forge render events |
| GUIs | Supported | Basic menus/screens, Forge slots and server button/slider/slot procedures |
| Keybinds | Supported | Forge key mapping registration and SimpleChannel press/release procedures |
| Block entity | Supported | Inventory, energy storage and single-tank fluid storage |
| Block entity inventory | Supported | Forge `IItemHandler` backed by `InvWrapper` |
| Block entity energy | Supported | Forge `EnergyStorage` / `IEnergyStorage` |
| Block entity fluid tank | Supported | Forge `FluidTank` / `IFluidHandler` |
| Fluids | Supported | Source and flowing fluids, fluid block, dynamic bucket model; Forge default movement |
| Procedure element | Supported | Java generation with event parameter and chat output templates |
| `player_right_click_block` trigger | Supported | Forge `PlayerInteractEvent.RightClickBlock` |
| Custom feature / tree | Supported | Datapack `configured_feature` + `placed_feature`; custom trees are data-driven and do not require Mixin |
| Custom biome JSON | Supported | Datapack `worldgen/biome`; used by custom dimensions and by the overworld injection path |
| Custom biome overworld generation | Supported (experimental) | Runtime `BiomeSource` wrapper replaces the overworld source; this is not a Forge public API and is documented below |
| Procedure templates | Supported (ported, 513 templates) | NeoForge 26.3 procedure snippets imported and Forge-specific API references fixed |
| Trigger templates | Supported (64 of 65) | 58 direct Forge events plus 6 compatibility/client-side triggers ported; only the sapling Mixin trigger remains in `docs/TRIGGERS.md` |
| Loot tables | Supported | Datapack `loot_table` JSON; NeoForge-only loot modifier is not generated |
| Recipes | Supported | Smelting, blasting, campfire, smoking, crafting, stonecutting, smithing and brewing JSON |
| Advancements | Supported | Datapack advancement JSON plus localization keys |
| Enchantments | Supported | Datapack enchantment JSON and enchantment tags |
| Functions | Supported | Datapack `.mcfunction` generation |
| Villager trades | Supported | Datapack villager trade JSON and trade-set tags |
| Villager professions | Experimental | Forge `RegistryObject` adaptation; POI/trade-set semantics still need a runtime test |
| Custom elements | Supported | No Forge-specific template required; MCreator emits the user-provided Java element |
| Commands | Supported (basic) | Forge `RegisterCommandsEvent`; permission-level checks are omitted pending a Forge 26.3 permission API port |
| Item extensions | Experimental | Fuel/compost/dispense templates are present; NeoForge context-provider APIs still require Forge-specific replacement |
| Item inventories | Experimental | Forge `ItemStackHandler` capability path; runtime GUI/item binding still needs a real-game regression |
| Variables and player data | Experimental | Forge capability scaffolding generated; all variable types and sync still need regression |
| Static validation | Supported | YAML, FreeMarker, template references, mappings |

## Not yet supported

| Area | Status | Planned batch |
| --- | --- | --- |
| Custom armor animations | Pending | Phase 1B |
| GUIs, menus, screens, keybinds, overlays | Supported | Basic GUIs, overlays, keybinds and Forge GUI procedure networking |
| Biomes, dimensions, features, structures | Supported | Biome/feature/tree generation is implemented; overworld biome injection is experimental (see below) |
| Potions, effects, particles, attributes, gamerules | Pending | Phase 1C |
| Remaining procedures (567 total) | Supported (ported templates) | 513 NeoForge 26.3 procedure templates imported; procedures using NeoForge inventory APIs still need individual regression |
| Remaining triggers (64 of 65) | Pending | Phase 3 |
| Variables and player data persistence | Experimental | Forge capability scaffolding added; all variable/player-data flows still need regression |
| Networking | Partial | Forge `SimpleChannel` menu/keybind messages work; variable sync is pending |
| Mixin packaging | Not applicable | Current Forge biome path avoids Mixin; Forge 26.3 + Java 25 Mixin 0.8.7 is not a stable packaging target |

## Phase 2 API comparison

| Area | Official NeoForge 26.3 generator | Forge 26.3 equivalent | Status |
| --- | --- | --- | --- |
| Item inventories | `ItemAccess`, `ItemAccessItemHandler`, `ResourceHandler<ItemResource>`, item `ITEM` capability | Forge `IItemHandler`, `ItemStackHandler`, `ICapabilitySerializable<CompoundTag>`, `ForgeCapabilities.ITEM_HANDLER` | Forge path implemented experimentally; NeoForge item-access API does not exist in Forge |
| Procedures | `net.neoforged.bus.api.Event`, NeoForge item/energy/fluid capabilities | `net.minecraftforge.eventbus.api.Event`, Forge capability APIs | 513 templates imported; most are API-neutral, inventory/energy/fluid procedures need targeted replacement |
| Global/session variables | Static fields in `${JavaModName}Variables` | Same Forge-compatible static fields | Implemented; needs regression |
| World/map variables | `SavedData` | Forge `SavedData` (same Minecraft API) | Implemented; needs regression |
| Player variables | NeoForge `AttachmentType` / player attachments | Forge `AttachCapabilitiesEvent<Entity>` + `ICapabilitySerializable<CompoundTag>` | Implemented scaffold; no direct AttachmentType equivalent; needs regression |
| Networking | `CustomPacketPayload` + NeoForge payload registrar | Forge `SimpleChannel` | Menu/keybind channel supported; variable sync pending |
| Mixin packaging | Reference biome generator uses `Preset.SourceProvider` Mixin + AT | Forge has no public biome-source hook; runtime wrapper is used instead | Mixin not used; Forge 26.3/Java 25 Mixin packaging is not a stable target |

The item-inventory and procedure rows are template-porting work, not a claim
that every NeoForge-only inventory primitive has a Forge API equivalent.
Player-data persistence must be implemented with Forge capabilities rather
than NeoForge attachments.

## Overworld biome generation: NeoForge reference vs Forge

This section explains why the Forge generator uses a runtime wrapper while the
official NeoForge 26.3 generator uses Mixin templates.

### Official NeoForge 26.3 generator

The reference generator declares these pieces in `biome.definition.yaml`:

| Piece | Implementation |
| --- | --- |
| Biome JSON | Datapack `worldgen/biome` |
| Custom tree/feature | Datapack `configured_feature` / `placed_feature` |
| Overworld biome source | `mixin_biomesourcepreset.java.ftl` replaces the private `MultiNoiseBiomeSourceParameterList.Preset.SourceProvider` |
| Surface material rules | `mixin_noisegeneratorsettings.java.ftl` wraps `NoiseGeneratorSettings.materialRule()` |
| Private-type access | Access Transformer for `MultiNoiseBiomeSourceParameterList$Preset$SourceProvider` |
| Mixin registration | `mixin.fragment.yaml` + `mixin.json.ftl` + `[[mixins]]` |

The NeoForge path is **not a public NeoForge API**. It is a generator-specific
Mixin/AT workaround that assumes the NeoForge Mixin/ModDevGradle environment.

### Why Forge cannot use the same direct API

1. `ForgeBiomeModifiers` only provides `add_features`, `remove_features`,
   `add_spawns` and `remove_spawns`. It does not provide an `add_biomes`
   modifier.
2. `MultiNoiseBiomeSourceParameterList.Preset.SourceProvider` and the
   `Preset.provider` field are package-private implementation details.
   Forge exposes neither an event nor a public registration hook to append
   biome climate points to the overworld preset.
3. `ChunkGenerator.biomeSource`, `featuresPerStep` and
   `generationSettingsGetter` are final internal fields with no public setters.
   Replacing the overworld source therefore requires an internal hook
   (Mixin/AT/reflection), not a Forge API.
4. Mixin/AT is especially fragile in the Forge 26.3 + Java 25 MCreator
   workspace: Mixin 0.8.7 reports `JAVA_21` as its highest compatibility
   level, and the Mavenizer AT/early-window path previously failed in this
   environment.
5. MCreator's Forge generator base exposes datapack biome JSON but has no
   element field or public generation API for “inject this biome into the
   existing overworld noise preset.” This is partly an MCreator template
   limitation; the underlying missing hook is a Forge API limitation.

### Implemented Forge path

The generator now uses this non-Mixin path:

- Registers a custom `BiomeSource` codec through `Registries.BIOME_SOURCE`.
- Wraps the original overworld `BiomeSource`.
- Injects the wrapper into `ChunkGenerator.biomeSource`.
- Rebuilds `ChunkGenerator.featuresPerStep` from the wrapped source.
- Serializes the wrapper through its registered codec, avoiding the
  “unregistered direct holder” save crash.
- Uses `UnsafeHacks` only for the final `ChunkGenerator` fields.

This is **experimental/internal-API support**, not a stable Forge API. It
should be revisited if Forge adds a public biome-source extension point.

## MCreator / Forge hardcoded workarounds


The following build-time workarounds are necessary because MCreator's template
context or Forge's runtime API does not expose a stable template-only hook:

| Workaround | Why it is needed | Owner |
| --- | --- | --- |
| `TestModBiomeSource` runtime wrapper / `UnsafeHacks` | Forge has no public API to add a biome to the existing overworld noise preset and no setter for `ChunkGenerator` source fields. | Forge internal API + MCreator template limitation |
| `patchNetworkJava` | MCreator's base-template `guis`/`keybinds` collections are not reliably populated in `keybind_network.java.ftl`; the task scans generated `*Message.java` classes and registers them on the Forge `SimpleChannel`. | MCreator template context |
| `patchArmorJava` | Forge 26.3 needs per-piece equipment assets, but changing the armor Java template causes MCreator armor element generation to fail; the task upgrades generated armor classes before compilation. | MCreator template generation |
| `copySignGuiTextures` | `SignEditScreen` / `HangingSignEditScreen` hard-code the `minecraft` texture namespace. | Minecraft / Forge hardcoded path |
| `copyArmorEquipmentTextures` | Forge 26.3 equipment assets use `textures/entity/equipment/humanoid` instead of MCreator's legacy armor texture directory. | Forge hardcoded path |

These are compatibility workarounds, not feature requirements. They should be
removed if MCreator/Forge later expose native template or API hooks.

## Known limitations


- Block entity inventory exposes the full container; side-specific slot restrictions are not applied yet.
- Energy and fluid block entity storage use Forge capability wrappers; transfer procedures are not ported yet.
- Fluid buckets use the Forge `forge:fluid_container` model.
- Custom fluid movement hooks and access-transformer-based extensions are deferred to a later batch; fluid movement uses Forge defaults.
- Item inventories now use a Forge item capability, but the item-bound GUI path still needs a real-game regression.
- Hanging sign text metrics use the shared `SignBlockEntity` implementation and should be validated in-game.
- Custom armor models, animations, living entities and GUI elements are not yet ported.
- `enumextensions`, NeoForge data maps and item model property events are not ported.
