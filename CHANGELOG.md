# Changelog

All notable changes to the Forge 26.3 generator are recorded in this file.

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
