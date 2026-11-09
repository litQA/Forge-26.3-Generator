# Changelog

All notable changes to the Forge 26.3 generator are recorded in this file.

## 2026.3-1.0.86.87-beta

### Fixes

- Rebuild `ChunkGenerator.featuresPerStep` from the wrapped BiomeSource. The vanilla lazy captures the original source, so `refreshFeaturesPerStep()` alone left custom biome features out of the index map and caused `IndexOutOfBoundsException` during biome decoration.

## 2026.3-1.0.85.86-beta

### Fixes

- Replaced the dev-run Mixin config dependency with a Forge access transformer that makes `ChunkGenerator.biomeSource` writable, then injects the overworld `BiomeSource` wrapper directly at `ServerAboutToStartEvent`.

## 2026.3-1.0.84.85-beta

### Fixes

- Restored the conditional `[[mixins]]` block in `mods.toml` via the `fragments.mixin` context; the previous `biomes` condition was unavailable in base-template rendering and caused `mods.toml` generation to be skipped.

## 2026.3-1.0.83.84-beta

### Features

- Added a Mixin accessor for `ChunkGenerator.biomeSource` and an overworld `BiomeSource` wrapper. This injects custom biomes without the private `Preset.SourceProvider` type or access transformers.

## 2026.3-1.0.82.83-beta

### Fixes

- Removed the Java 25 Mixin/AT path again because Forge's early-window `DummyProvider` fails before the game starts. Stable datapack rendering/tree output remains enabled.

## 2026.3-1.0.81.82-beta

### Fixes

- Captured tree resource source/target directories at configuration time so `copyTreePlacement` works with Gradle configuration cache.

## 2026.3-1.0.80.81-beta

### Fixes

- Custom tree placed-feature resources are now copied into both merged resource output directories after `processResources`, preventing `Unbound values ... test:test_biome_tree` registry failures.
- The copy task also removes the vanilla oak-sapling survival predicate from custom tree placement.

## 2026.3-1.0.79.80-beta

### Fixes

- Removed the ASM 9.8 downgrade; Forge 66 already bundles a newer ASM. Mixin compatibility is set to the supported `JAVA_21` level, with annotation processing/refmap generation retained.

## 2026.3-1.0.78.79-beta

### Fixes

- Restored biome-injection Mixin support with `JAVA_21` compatibility and ASM 9.8 dependencies, avoiding the Mixin 0.8.7 `JAVA_25` compatibility rejection.
- Added tree placement patching so custom biome tree placed-features no longer require an oak sapling to survive on custom ground blocks.

## 2026.3-1.0.77.78-beta

### Fixes

- Added a post-generation `patchNetworkJava` task that scans generated `*Message.java` classes and registers them on the `SimpleChannel`. This does not depend on MCreator's GUI/keybind template collections.

## 2026.3-1.0.76.77-beta

### Fixes

- Keybind message packets are registered unconditionally for every generated keybind, preventing `Attempted to send invalid message TestKeybindMessage` at runtime.

## 2026.3-1.0.75.76-beta

### Fixes

- The network channel is now generated unconditionally and its GUI/keybind loops use the base `guis`/`keybinds` collections with safe defaults. This guarantees `TestModNetwork.java` is recreated after a clean regeneration.

## 2026.3-1.0.74.75-beta

### Fixes

- Network-channel generation now checks `types.guis` and iterates `types.guis`, so regenerating after removing temporary files recreates `TestModNetwork` for menu/keybind messages.

## 2026.3-1.0.73.74-beta

### Changes

- Removed the experimental Mixin/access-transformer biome injection path because Forge 26.3's bundled Mixin/ASM does not support `JAVA_25` bytecode.
- Biomes/features now use the stable datapack `configured_feature` / `placed_feature` / `forge:biome_modifier` path.
- Removed generated Mixin, AT, refmap and manifest configuration.

## 2026.3-1.0.72.73-beta

### Fixes

- Added Mixin annotation processor and `test.refmap.json` generation to the workspace build; mixin config now declares its refmap.
- Kept the dev-run `-Dmixin.config` argument as a fallback.

## 2026.3-1.0.71.72-beta

### Fixes

- Feature biome modifiers now write to `data/<modid>/forge/biome_modifier` instead of the NeoForge directory path.
- Features without explicit restriction biomes now default to `#minecraft:is_overworld` using the Forge biome modifier format.

## 2026.3-1.0.70.71-beta

### Fixes

- Mixin configuration is now passed through the ForgeGradle `minecraft.runs.configureEach` JVM arguments, covering dev client/server runs that do not use the jar manifest.

## 2026.3-1.0.69.70-beta

### Fixes

- The generated workspace passes `-Dmixin.config=<config>` to `runClient`/`runServer`, so mixin configs are active in ForgeGradle development runs even when the run uses class directories rather than the built jar manifest.

## 2026.3-1.0.68.69-beta

### Fixes

- Forge 26.3 discovers mixin configs from the jar manifest, not only `mods.toml`. The generated jar now sets `MixinConfigs` from any `*.mixins.json` resource.

## 2026.3-1.0.67.68-beta

### Fixes

- Added `mixin.fragment.yaml`, `mixin.json.ftl` and the `[[mixins]]` mods.toml entry, so the restored biome source/preset mixins are actually loaded at runtime.

## 2026.3-1.0.66.67-beta

### Fixes

- Restored biome source injection mixins with Forge access transformers, enabling custom biomes to participate in overworld/nether noise presets.
- Added the generated `META-INF/accesstransformer.cfg` and enabled `useDefaultAccessTransformer()` in the workspace build.
- Fixed tree decorator and dimension POI listeners to use the mod bus.

## 2026.3-1.0.65.66-beta

### Fixes

Fixed 1 bug(s).

- Dimension teleporter POI registration now subscribes to the Forge mod bus. `RegisterEvent` is a mod-bus event; the previous game-bus listener never ran, leaving `poi` null when creating a portal.

## 2026.3-1.0.64.65-beta

### Fixes

Fixed 1 bug(s).

- Tree decorator `RegisterEvent` listeners now subscribe to the Forge mod bus. Previously they used the game bus, so `test:test_biome_tree_*_decorator` types were never registered and the biome tree feature failed registry loading.

## 2026.3-1.0.63.64-beta

### Fixes

Fixed 1 bug(s).

- Mod-constructor registry conditions now use `types.attributes`, `types.gamerules`, `types.potions`, `types.potioneffects`, `types.particles` and `types.base_features`, matching the collections MCreator actually exposes in the mod template.

## 2026.3-1.0.62.63-beta

### Fixes

Fixed 1 bug(s).

- Phase 1C deferred registries are now registered from the mod constructor: attributes, gamerules, potions, mob effects, particle types and feature types. This prevents unbound `Holder` access during Forge attribute registration.

## 2026.3-1.0.61.62-beta

### Fixes

- Fixed custom armor animation overrides to subclass `HumanoidModel` with a `HumanoidRenderState` signature and correct constructor argument order.
- Removed biome mixin generation that required private `SourceProvider` access.
- Removed the unsupported honey-bottle component event from mob effects.
- Fixed attribute registration and `Holder` conversion for attributes and potion effects.

## 2026.3-1.0.60.61-beta

### Fixes

- Removed generated biome mixin classes that depended on private `SourceProvider` access.
- Removed the unsupported NeoForge honey-bottle component hook from mob effects.
- Fixed Forge attribute registration and holder conversion.
- Fixed potion `MobEffectInstance` holder conversion.
- Removed the invalid custom-armor `setupAnim` anonymous subclass; animation delegation will be reintroduced separately.

## 2026.3-1.0.59.60-beta

### Fixes

- Corrected `RegistryObject` generic arity in attribute, feature, gamerule, particle, potion and villager templates after the Phase 1C port.
- Armor animation delegation is retained while armor materials are upgraded by the post-generation task.

## 2026.3-1.0.58.59-beta

### New Content

- Added Phase 1C element definitions and templates for biomes, dimensions, features, structures, potions, mob effects, particles, attributes and gamerules.
- Added custom Java armor-model animation delegation in `HumanoidModel#setupAnim`.

### Changes

- Copied the datapack-backed biome/dimension/feature/structure JSON definitions and the Forge-side Java templates.
- Removed copied `DeferredHolder`/`@EventBusSubscriber` usage in favor of Forge `RegistryObject` and `@Mod.EventBusSubscriber`.

## 2026.3-1.0.57.58-beta

### Fixes

Fixed 1 bug(s).

- Per-piece armor equipment JSON files are generated directly by separate JSON templates (one file per enabled piece) instead of relying on the marker build task. The armor Java template remains stable and is upgraded after generation by `patchArmorJava`.

## 2026.3-1.0.56.57-beta

### Fixes

Fixed 1 bug(s).

- Armor generation now uses the stable single-material FTL template. A post-generation `patchArmorJava` task upgrades generated armor classes to per-piece equipment assets before compilation, so custom textures do not break MCreator's armor element generation.

## 2026.3-1.0.55.56-beta

### Fixes

Fixed 1 bug(s).

- Armor texture selection moved out of the armor FTL templates into a small marker plus `copyArmorEquipmentTextures` build task. This keeps armor Java generation intact while creating per-piece equipment assets for helmet, chestplate, leggings and boots.

## 2026.3-1.0.54.55-beta

### Fixes

Fixed 1 bug(s).

- Restored the exact pre-custom-texture armor definition and equipment template that previously generated armor Java classes successfully. This isolates the missing-armor generation regression.

## 2026.3-1.0.53.54-beta

### Fixes

Fixed 1 bug(s).

- Armor now has separate equipment assets per enabled piece without using template variables. Helmet custom textures no longer replace the chestplate/boots humanoid texture, and each piece binds to its matching equipment asset.

## 2026.3-1.0.52.53-beta

### Fixes

Fixed 1 bug(s).

- Restored the stable armor Java template and removed per-piece template variables that caused armor elements to fail code generation. Custom helmet model textures are applied through the single equipment asset; custom model textures are copied into the equipment texture folder.

## 2026.3-1.0.51.52-beta

### Fixes

Fixed 1 bug(s).

- Custom armor model textures now flow through per-piece Forge equipment assets. Each armor piece has its own `ArmorMaterial`/equipment asset, custom model textures are copied into `textures/entity/equipment/humanoid`, and custom model textures are used instead of the fallback "From armor" texture.

## 2026.3-1.0.50.51-beta

### New Content

- Added the complete `aitasks` template set, enabling MCreator AI task blocks (wander, attack, avoid, follow, doors, swim, panic, look, etc.) for living entities.
- Added Forge `java_models` configuration and `copy_models` / `copy_model_animations` source-setup tasks, so MCreator Java model elements generate `client.model` classes and animation classes.
- The Java model layer registry template now triggers through `hasJavaModels()`.

## 2026.3-1.0.49.50-beta

### Fixes

Fixed 1 bug(s).

- Hanging signs now use `HangingSignBlockEntity` and a typed `BlockEntityType<HangingSignBlockEntity>` instead of plain `SignBlockEntity`. This makes the client open `HangingSignEditScreen` and use the 16x16 `hanging_signs` texture path correctly.

## 2026.3-1.0.48.49-beta

### Fixes

Fixed 1 bug(s).

- Hanging-sign GUI textures are now copied to both `assets/minecraft/textures/gui/hanging_signs` and `assets/minecraft/textures/gui/signs`. The generated hanging sign block entity is a plain `SignBlockEntity`, so the game may open `SignEditScreen` and request the normal `signs` path.

## 2026.3-1.0.47.48-beta

### Fixes

Fixed 1 bug(s).

- `copySignGuiTextures` now captures its source and target `File` instances at configuration time. This makes the task compatible with Gradle's configuration cache while still copying sign GUI textures after `processResources`.

## 2026.3-1.0.46.47-beta

### Fixes

Fixed 1 bug(s).

- Added a post-`processResources` sign texture copy task targeting the actual ForgeGradle `build/sourceSets/main/assets` output. Both `textures/gui/signs` and `textures/gui/hanging_signs` are mirrored into `assets/minecraft`, which `SignEditScreen` and `HangingSignEditScreen` require.

## 2026.3-1.0.45.46-beta

### Fixes

Fixed 2 bug(s).

- Block-entity GUIs now bind their slots to the block entity's Forge `IItemHandler` capability instead of creating a new `ItemStackHandler`, so stored items survive closing and reopening the GUI.
- Sign editor textures are copied into `assets/minecraft/textures/gui/signs` and `assets/minecraft/textures/gui/hanging_signs`, matching `SignEditScreen` and `HangingSignEditScreen` hard-coded namespace paths.

## 2026.3-1.0.44.45-beta

### Fixes

Fixed 1 bug(s).

- Wood type names are now emitted without the `modid:` prefix. Forge 26.3 uses the wood type name directly in the sign GUI texture path, so the namespace prefix caused `Non [a-z0-9/._-] character in path of location` and disconnected the client when editing a sign.

## 2026.3-1.0.43.44-beta

### Fixes

Fixed 1 bug(s).

- Corrected the Forge 26.3 spawner schema again: each `spawners` array entry is a `SpawnerData` with `type`, `count`, and `weight` at the same level. `count` is an `IntProvider` constant or a `minecraft:uniform` object when min/max differ. This replaces the invalid `data` wrapper from 1.0.42.43.

## 2026.3-1.0.42.43-beta

### Fixes

Fixed 1 bug(s).

- Entity spawn biome modifiers now emit the Forge 26.3 weighted-list JSON shape: a `spawners` array containing `data` and `weight` objects. This prevents registry loading failures and corrupted data-pack errors when creating or opening a world.

## 2026.3-1.0.41.42-beta

### Fixes

Fixed 1 bug(s).

- The mod constructor now registers the GUI menu `DeferredRegister` and initializes the shared network channel when `types.guis` is present, preventing `Registry Object not present: test:test_gui` during client setup.

## 2026.3-1.0.40.41-beta

### Fixes

Fixed 1 bug(s).

- Event subscriber annotations now select the correct Forge bus. Entity renderers, entity registration, creative tabs, key mappings, sign renderers and model layers use `Bus.FORGE`; client setup classes continue to use `Bus.MOD`. This prevents `BusGroup "modBus..." requires IModBusEvent` crashes during client startup.

## 2026.3-1.0.39.40-beta

### Fixes

Fixed 1 bug(s).

- Removed the generated `DistExecutor` client branch from `MenuStateUpdateMessage`; Forge 26.3 does not expose `net.minecraftforge.fml.DistExecutor`. Menu-state packets now update the server-side sender menu.

## 2026.3-1.0.37.38-beta

### New Content

- GUI menu-state packets now update the client menu and screen accessor on the client side.
- Server-side menu state continues to update through the sender's open menu.

### Changes

- Plugin version raised to `2026.3-1.0.37.38-beta`.

## 2026.3-1.0.36.37-beta

### Fixes

Fixed 1 bug(s).

- GUI menu-state packets now pass `ServerPlayer` directly to `PacketDistributor.PLAYER.with` instead of a supplier.

## 2026.3-1.0.35.36-beta

### Changes

- The validator now rejects removed Forge APIs (`RenderGuiEvent`, `EventPriority`, `ItemStacksResourceHandler`, `getEnchantmentLevel`) in generator resources.
- Plugin version raised to `2026.3-1.0.35.36-beta`.

## 2026.3-1.0.34.35-beta

### Changes

- Template include validation no longer falls back to the templates root for relative paths, preventing missing keybind-style messages from passing validation.
- Plugin version raised to `2026.3-1.0.34.35-beta`.

## 2026.3-1.0.33.34-beta

### New Content

- Forge `MenuStateUpdateMessage` over the shared `SimpleChannel`.
- GUI text field, checkbox and slider state synchronization between client and server menus.

### Changes

- Plugin version raised to `2026.3-1.0.33.34-beta`.

## 2026.3-1.0.32.33-beta

### Fixes

Fixed 1 bug(s).

- The keybind message template now includes `procedures.java.ftl` from the template root, so keybind message classes are generated.

## 2026.3-1.0.31.32-beta

### Changes

- The generator validator now rejects NeoForge references (`net.neoforged`, `neoforge:`, `NeoForgeMod`, `CommonHooks`) in generator YAML and FreeMarker resources.
- Plugin version raised to `2026.3-1.0.31.32-beta`.

## 2026.3-1.0.30.31-beta

### Fixes

Fixed 1 bug(s).

- Overlay classes now register a client setup hook so their static layer registration is guaranteed to execute.

## 2026.3-1.0.29.30-beta

### New Content

- Screen-target overlays now register through Forge `ScreenEvent.Render.Post` instead of rendering as HUD overlays.
- HUD overlays continue to use `AddGuiOverlayLayersEvent` and `ForgeLayer`.

### Changes

- Plugin version raised to `2026.3-1.0.29.30-beta`.

## 2026.3-1.0.28.29-beta

### Fixes

Fixed 2 bug(s).

- HUD overlays now register through Forge `AddGuiOverlayLayersEvent` and `ForgeLayer`; removed the removed `RenderGuiEvent`/`EventPriority` APIs.
- GUI/keybind network generation now keys off the actual `guis` collection, fixing missing generated network classes when a GUI exists without a keybind.

## 2026.3-1.0.27.28-beta

### Changes

- Living entity GUI inventories now use Forge `ItemStackHandler` and `IItemHandler`.
- Entity equipment wrappers no longer depend on NeoForge combined resource handlers.
- Plugin version raised to `2026.3-1.0.27.28-beta`.

### Known Limitations

- Living entity inventories are exposed through the generated handler but entity capability registration remains limited.
- Custom armor animations and final dynamic bucket/sound confirmation remain pending.

## 2026.3-1.0.26.27-beta

### Fixes

Fixed 3 bug(s).

- Overlays now use fully qualified Forge `RenderGuiEvent` and `EventPriority` names.
- Plant crop growth now uses Forge `ForgeHooks.onCropsGrowPre` / `onCropsGrowPost`.
- Projectile knockback enchantment lookup now uses `EnchantmentHelper.getItemEnchantmentLevel`.

## 2026.3-1.0.25.26-beta

### New Content

- Forge `SimpleChannel` GUI button, slider and slot messages.
- Server-side GUI button/slider procedures now execute from the received packet.
- Slot change/take/quick-craft messages for GUI slot procedures.

### Changes

- Plugin version raised to `2026.3-1.0.25.26-beta`.

### Known Limitations

- GUI menu-state synchronization remains client-local.
- Custom armor animation clips remain pending.

## 2026.3-1.0.24.25-beta

### New Content

- Custom armor model translucency using a translucent `RenderTypes` render type.
- Helmet, chestplate, leggings and boots custom models can select the translucent render type independently.

### Changes

- Plugin version raised to `2026.3-1.0.24.25-beta`.

### Known Limitations

- Custom armor animation clips remain pending.
- Standard non-custom armor translucency remains pending.
- GUI slot/server-button procedures remain pending.

## 2026.3-1.0.23.24-beta

### New Content

- Forge `ItemStackHandler`-backed GUI slots.
- `SlotItemHandler` custom slot registration and basic quick-move handling.
- Player inventory slots for container-bound GUIs.

### Changes

- GUI menus use a Forge `IItemHandler` instead of NeoForge resource handlers.
- Plugin version raised to `2026.3-1.0.23.24-beta`.

### Known Limitations

- GUI slot change/take/placement procedures and server button/slider procedure networking remain pending.
- Custom armor animations/translucent layers remain pending.

## 2026.3-1.0.22.23-beta

### New Content

- Forge `RegisterKeyMappingsEvent` keybind registration.
- Keybind press/release procedures synchronized through a Forge `SimpleChannel`.
- Keybind category support and client tick handling.

### Changes

- Plugin version raised to `2026.3-1.0.22.23-beta`.

### Known Limitations

- Custom GUI slot item handlers and server-side GUI button/slider procedures remain incomplete.
- Custom armor animations/translucent layers remain pending.

## 2026.3-1.0.21.22-beta

### Fixes

Fixed 1 bug(s).

- Sign block entity types are created through static factory methods, removing the Java self-reference error in the generated `SIGN` and `HANGING_SIGN` initializers.

## 2026.3-1.0.20.21-beta

### New Content

- Basic GUI menu and screen generation for Forge 26.3.
- Forge `IForgeMenuType` menu registration and `MenuScreens` client registration.
- Basic background, image, label, button, checkbox, text field and slider screen rendering.
- Client-local menu state updates without NeoForge payload networking.

### Changes

- GUI container generation now uses a minimal Forge `AbstractContainerMenu` without custom slot item handlers.
- Plugin version raised to `2026.3-1.0.20.21-beta`.

### Known Limitations

- Custom GUI slot item handling and server-bound button/slider procedures are not complete.
- Keybind networking remains pending.
- GUI components such as custom slots should be treated as display-only until the networking/slot batch.

## 2026.3-1.0.19.20-beta

### New Content

- Basic HUD and screen overlays using Forge `RenderGuiEvent` and `ScreenEvent`.
- Overlay image, sprite, label, item and entity-model components.
- Overlay display conditions, priority and screen-target selection.

### Changes

- Plugin version raised to `2026.3-1.0.19.20-beta`.

### Known Limitations

- GUI menus, screens, buttons/sliders networking and keybinds remain pending.
- Overlay rendering needs in-game validation.

## 2026.3-1.0.18.19-beta

### Fixes

Fixed 1 bug(s).

- The generated model registry no longer renders an undefined `javamodels` sequence when only a special entity model layer exists.

## 2026.3-1.0.17.18-beta

### New Content

- Basic boat/raft special entity generation.
- Special entity model layer registration and renderers.
- `BoatItem` item registration for special entities.
- Dispense behavior and entity/item tags for special entities.

### Changes

- Plugin version raised to `2026.3-1.0.17.18-beta`.

### Known Limitations

- Entity inventory capabilities remain unported.
- Special entity model/layer behavior requires in-game validation.

## 2026.3-1.0.16.17-beta

### New Content

- Basic projectile entity generation using the 26.3 `AbstractArrow` implementation.
- Projectile item rendering, custom projectile renderer generation, hit procedures and shoot helpers.
- Projectile registration through the shared Forge entity registry.

### Changes

- Plugin version raised to `2026.3-1.0.16.17-beta`.

### Known Limitations

- Special boat/raft entities remain staged and are not validated in this batch.
- Projectile custom models still follow the shared renderer template and need in-game validation.

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
