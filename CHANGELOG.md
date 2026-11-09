# Changelog

All notable changes to the Forge 26.3 generator are recorded in this file.

## 2026.3-1.0.15.16-beta

### New Content

- Basic living entity generation with Forge `EntityType`, attributes, spawn placement and renderers.
- Entity registration and client renderer registration for living entities.
- Living entity spawn eggs and Forge `forge:add_spawns` biome modifiers.
- Living entity sound, animation, AI base and attribute generation inherited from the 26.3 template set.

### Changes

- Living entity water behavior uses `ForgeMod.WATER_TYPE` / `ForgeMod.SWIM_SPEED`.
- Poison immunity uses the vanilla `DamageTypes.MAGIC` damage type.
- Plugin version raised to `2026.3-1.0.15.16-beta`.

### Known Limitations

- Living entity inventory capabilities are not registered yet.
- Projectile and special entity templates are staged but not yet validated in this batch.
- Villager/raider enum extensions and NeoForge data maps remain unsupported.

## 2026.3-1.0.14.15-beta

### New Content

- Basic custom armor model support through Forge `IClientItemExtensions` and `HumanoidModel`.
- Helmet, chestplate, leggings and boots can use their configured MCreator model parts while retaining the equipment asset texture.

### Changes

- Plugin version raised to `2026.3-1.0.14.15-beta`.

### Known Limitations

- Custom armor animations and translucent armor buffers are not ported yet.
- Custom armor model textures beyond the equipment asset texture are not ported yet.

## 2026.3-1.0.13.14-beta

### New Content

- Advanced block base support for stairs, slabs, fences, walls, fence gates, trapdoors, doors, panes, leaves, end rods, pressure plates, buttons, signs and hanging signs.
- Forge-native sign support with custom sign `BlockEntityType` registration, ticking and sign renderers.
- Forge-native `DeferredSoundType` material for custom block and plant sound events.
- Sign item generation now uses `StandingAndWallBlockItem` and `HangingSignItem`.

### Changes

- Wood types use the public 26.3 `WoodType` constructor instead of the removed registry helper.
- Wall sign and wall hanging sign blocks are registered alongside their standing variants.
- Plugin version raised to `2026.3-1.0.13.14-beta`.

### Known Limitations

- Custom armor models and animations, living entities, projectiles, GUIs, menus, screens, keybinds and overlays are not part of this batch.
- Hanging sign text behavior should be validated in-game; the custom sign block entity uses the shared 26.3 text implementation.
- Fluid bucket texture copying still requires the current `processResources` refresh and is pending retest.

## 2026.3-1.0.12.13-beta

### Changes

- The workspace `processResources` task now always runs so its generated texture copies are refreshed even when the regular resource inputs are unchanged.
- Plugin version raised to `2026.3-1.0.12.13-beta`.

## 2026.3-1.0.11.12-beta

### Changes

- The workspace resource-copy task now resolves the processed resource directory through the main source set output instead of assuming `build/resources/main`.
- Plugin version raised to `2026.3-1.0.11.12-beta`.

### Fixes

Fixed 1 bug(s).

- Fluid item textures and equipment armor textures are now copied into the ForgeGradle `build/sourceSets/main` resource output used by the client.

## 2026.3-1.0.10.11-beta

### Changes

- The workspace `processResources` resource-copy logic captures the output directory at configuration time and uses file-system operations at execution time.
- Plugin version raised to `2026.3-1.0.10.11-beta`.

### Fixes

Fixed 1 bug(s).

- The resource-copy task is now compatible with Gradle configuration cache.

## 2026.3-1.0.9.10-beta

### Changes

- Fluid resource generation now writes an item-atlas texture marker for each generated bucket.
- The workspace resource task copies the marked fluid still texture and its animation metadata into `textures/item`.
- The workspace resource task migrates legacy `textures/models/armor` files into the equipment humanoid and leggings folders.
- Plugin version raised to `2026.3-1.0.9.10-beta`.

### Fixes

Fixed 2 bug(s).

- Fluid buckets now resolve their fluid still texture from the item atlas instead of rendering a missing purple/black texture.
- Armor equipment assets now resolve generated layer textures even when the workspace still has legacy armor texture paths.

## 2026.3-1.0.8.9-beta

### Changes

- Plugin version raised to `2026.3-1.0.8.9-beta`.

### Fixes

Fixed 1 bug(s).

- The generated fluid model registry now uses the fully qualified `ModelEvent.BakeFluidModels` type, so the import formatter no longer emits an unresolved nested-class import.

## 2026.3-1.0.7.8-beta

### New Content

- Forge fluid model registration through `BakeFluidModels`, with still and flowing materials for custom fluids.
- Dynamic Forge fluid-container item models for fluid buckets.
- Equipment asset armor textures using `humanoid` and `humanoid_leggings` layer files.
- Shears attack speed attributes when a non-default attack speed is configured.

### Changes

- Armor textures are now written to `textures/entity/equipment/humanoid`; the workspace copies them into `humanoid_leggings` during resource processing.
- Fluid bucket item models now point to the generated dynamic fluid-container model.
- Plugin version raised to `2026.3-1.0.7.8-beta`.

### Fixes

Fixed 3 bug(s).

- Custom fluid blocks no longer render with missing purple/black textures.
- Fluid buckets now use the fluid-container model instead of the empty bucket model.
- Armor equipment assets now resolve the generated layer textures instead of missing texture paths.

### Known Limitations

- Custom armor models and animations remain deferred.
- Custom fluid movement hooks remain deferred; Forge default movement is used.
- Tool attack speed follows the MCreator attack-speed value; non-melee tool types such as shields and fishing rods do not apply an attack-speed modifier.

## 2026.3-1.0.6.7-beta

### Changes

- Plugin version raised to `2026.3-1.0.6.7-beta`.

### Fixes

Fixed 1 bug(s).

- The fluid type template now closes the generated class after the protected `move` override was removed.

## 2026.3-1.0.5.6-beta

### Changes

- Fluid types no longer override `FluidType#move`; fluid movement uses Forge defaults in this batch.
- Access transformer fragments and generated AT files were removed from the Phase 1A build.
- The Forge workspace base no longer enables default access-transformer processing.
- Plugin version raised to `2026.3-1.0.5.6-beta`.

### Fixes

Fixed 1 bug(s).

- Generated fluid types no longer call the protected `LivingEntity#travelInWater` method, fixing the Phase 1A compile failure.

### Known Limitations

- Custom fluid movement behavior is deferred until access-transformer support is reintroduced.
- Item inventories, custom armor models and dynamic fluid bucket rendering remain deferred.

## 2026.3-1.0.4.5-beta

### New Content

- Basic plant element support with plant block, block entity, configured/placed generation JSON and wood type templates.
- Tool element support for pickaxes, axes, shovels, hoes and swords.
- Armor element support for helmets, chestplates, leggings and boots with equipment assets.
- Block entity support with Forge `IItemHandler` inventory capabilities.
- Block entity energy support with Forge `EnergyStorage` and `IEnergyStorage`.
- Block entity fluid tank support with Forge `FluidTank` and `IFluidHandler`.
- Fluid element support with source/flowing registration, fluid block and bucket.
- Generated access transformer support for fluid movement hooks.

### Changes

- Block entity registration now uses `ForgeRegistries.BLOCK_ENTITY_TYPES` and `BlockEntityType` with a block set.
- Fluid registration now uses `ForgeRegistries.FLUIDS` and `ForgeRegistries.FLUID_TYPES`.
- Fluid types now register client extensions through Forge `FluidType#initializeClient`.
- Fluid bucket item models use standard vanilla item models; dynamic fluid-container rendering is deferred.
- Plugin version raised to `2026.3-1.0.4.5-beta`.

### Known Limitations

- Item inventories stop generation with an explicit message; block entity inventories are supported.
- Custom armor models, animations and dynamic fluid bucket rendering are not ported yet.
- Custom block and plant sound types are not ported yet.
- Energy and fluid transfer procedures are not ported yet; the block entity storage APIs are available for later batches.
- Advanced block bases and world generation elements remain pending.

## 2026.3-1.0.3.4-beta

### New Content

- `world_send_chat` and `entity_send_chat` procedure templates, so chat output procedures generate real code.

### Changes

- README no longer tracks development batch progress; the banner and MCreator information sections are reserved for project-owner maintenance.
- Plugin metadata description now identifies the plugin only as a Forge 26.3 generator for MCreator; credits list MCreator, Pylo and Forge.
- Plugin version raised to `2026.3-1.0.3.4-beta`.

### Fixes

Fixed 2 bug(s).

- Block items with special information now use the generated block item class, so tooltip text is displayed.
- The `player_right_click_block` trigger can now produce an observable chat message through the `world_send_chat` procedure template.

### Known Limitations

- Advanced procedures, block bases, entities, fluids, GUIs, dimensions, biomes, networking and capabilities remain pending.
- Generated workspace compilation still requires a real MCreator/ForgeGradle environment; the local access-transformer cache remains environment-dependent.

## 2026.3-1.0.2.3-beta

### Changes

- The Forge workspace base now applies the `java` plugin before `base.archivesName` is configured.
- The NeoForge-specific `MCREATOR_JVM_OPTIONS` run configuration was removed because ForgeGradle 7 does not expose the `jvmArgument` DSL.

### Fixes

Fixed 2 bug(s).

- Workspace creation no longer fails with `Could not get unknown property 'base'`.
- Workspace creation no longer fails with `Could not get unknown property 'java'` or a missing `JavaPluginExtension`.

### Known Limitations

- Phase 0 scope is unchanged: basic blocks, basic items, block items, creative tabs, procedures and the `player_right_click_block` trigger only.
- Generated workspace compilation still requires a real MCreator/ForgeGradle environment; the local access-transformer cache remains environment-dependent.

## 2026.3-1.0.1.2-beta

### New Content

- Generator plugin scaffold with Forge 26.3 plugin metadata, ForgeGradle 7 workspace base and a static generator validator.
- `forge-26.3` generator directory with a datapack-only import and Forge-specific import formatting.
- Basic block, basic item, block item and custom creative tab registration for Forge `DeferredRegister` and `RegistryObject`.
- Procedure element with a Forge-compatible event parameter.
- `player_right_click_block` trigger using Forge `PlayerInteractEvent.RightClickBlock`.
- Phase 0 support matrix and a reproducible plugin build pipeline.

### Changes

- Plugin version raised to `2026.3-1.0.1.2-beta`.
- Generator build output is written to `build/dist/generator-forge-26.3.zip`.
- Local Gradle wrapper is pinned to `reference_resources/gradle-9.8.0-bin.zip`.

### Fixes

Fixed 2 bug(s).

- Validator resolves relative template includes through both the `templates` and `utils` roots.
- Shared datapack template utilities are bundled so generator validation does not depend on the external datapack plugin at build time.

### Known Limitations

- Phase 0 supports only basic blocks, basic items, block items, creative tabs, procedures and the `player_right_click_block` trigger.
- Generated workspace compilation has not yet been verified in this environment because the local ForgeGradle access-transformer step is blocked; the user must run the Phase 0 test workspace build in a normal MCreator/ForgeGradle environment.
- Advanced block bases, entities, fluids, GUIs, dimensions, biomes, networking, capabilities and the remaining 64 triggers are deferred to later batches.

## 2026.3-1.0.0.1-beta

### New Content

- Project assessment covering the MCreator 2026.3 baseline, the Forge 66.1.5 API surface, the NeoForge 26.3 generator inventory, and the Fabric 26.3 conversion precedent.
- Loader gap matrix for registration, event bus, events, networking, capabilities, variables, client registration, data assets, Mixin and access transformers.
- Full trigger inventory for 65 triggers with Easy, Hard and Impossible classification.
- Architecture decision for a full generator fork with a datapack-only import.
- Phase plan, batch boundaries, risk register, acceptance criteria and Phase 0 success criteria.

### Changes

- Repository documentation baseline established under `docs/PROJECT-ASSESSMENT.md`.
- Initial version recorded as `2026.3-1.0.0.1-beta`.

### Known Limitations

- No generator templates are shipped in this assessment round.
- Gradle and ForgeGradle validation is blocked in the current environment by the bundled JBR writability behavior and by the access transformer processing failure; both are recorded as Phase 0 gates.
- NeoForge enum extensions, NeoForge data maps and NeoForge item model property events have no direct Forge 26.3 equivalent and require a product decision.
