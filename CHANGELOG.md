# Changelog

All notable changes to the Forge 26.3 generator are recorded in this file.

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
