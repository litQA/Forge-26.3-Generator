<img width="1000" alt="forge generator banner 26 3" src="https://github.com/user-attachments/assets/187b4a72-4576-4b8a-89c3-154fee7666a1" />

# Forge 26.3 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge 26.3.

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-26.3` |
| Generator id | `forge-26.3` |
| Plugin version | `2026.3-1.0.111.114-beta` |
| Minecraft / Forge | `26.3` / `66.1.8` |
| Gradle for generated mods | Gradle 9.8.0 + ForgeGradle 7 |
| Java for Gradle / MCreator | 25 |
| License | CC BY-NC 4.0 |

## Features

- Basic block registration with special information tooltips.
- Advanced block bases: stairs, slabs, fences, walls, fence gates, trapdoors, doors, panes, leaves, end rods, pressure plates and buttons.
- Standing, wall and hanging signs with Forge sign block entities and renderers.
- Custom block and plant sound types through Forge-native sound resolution.
- Basic item registration, block items and special information tooltips.
- Custom creative tabs.
- Basic plants, tools and armor.
- Basic custom armor model part mapping through Forge client item extensions.
- Translucent custom armor models.
- Basic living entities with attributes, spawn eggs, renderers and biome spawn modifiers.
- Basic arrow-style projectiles with custom renderers and shoot helpers.
- Basic boat/raft special entities with model layers and items.
- Basic HUD and screen overlays.
- Basic GUI menus and screens with client-side components.
- Basic Forge `ItemStackHandler` GUI slots.
- Forge GUI button/slider/slot procedure networking.
- Keybind registration and Forge SimpleChannel press/release procedures.
- Block entity inventories, energy storage and fluid tanks.
- Source and flowing fluids with fluid blocks and buckets.
- Procedure elements with chat output.
- `player_right_click_block` trigger.

The detailed support matrix is in [docs/SUPPORT-MATRIX.md](docs/SUPPORT-MATRIX.md).

## Build the plugin

```bat
cd plugin-branch-2026.3
set JAVA_HOME=<JDK 25 home>
set WORKSPACE_ROOT=<workspace root>
gradlew.bat --no-daemon clean build
```

`WORKSPACE_ROOT` is optional when the plugin directory is directly below the
workspace root. The wrapper otherwise resolves the root from the plugin location.
The wrapper uses the public Gradle distribution URL by default and stores all
Gradle caches under `<workspace-root>/caches/gradle` unless `GRADLE_USER_HOME` is
already defined.

Expected output:

```text
VALIDATION PASSED
BUILD SUCCESSFUL
```

The plugin archive is written to:

```text
build/dist/generator-forge-26.3.zip
```

The Gradle wrapper uses
`https://services.gradle.org/distributions/gradle-9.8.0-bin.zip` by default.
No local path is stored in the wrapper and it does not select a local archive
automatically. Offline builds must pre-populate `<workspace-root>/caches/gradle`
or set `GRADLE_USER_HOME`; all Gradle caches then stay under that workspace
directory.

## Install

1. Close MCreator.
2. Copy `build/dist/generator-forge-26.3.zip` to the MCreator `plugins` folder.
3. Start MCreator.
4. Create a workspace with generator `Forge for 26.3 (66.1.8)`.

## Layout

```text
plugin-branch-2026.3/
  build.gradle
  gradle.properties
  settings.gradle
  src/main/resources/plugin.json
  src/main/resources/forge-26.3/
    generator.yaml
    block.definition.yaml
    item.definition.yaml
    tab.definition.yaml
    procedure.definition.yaml
    templates/
    procedures/
    triggers/
    utils/
    mappings/
    workspacebase/
  src/validator/java/
  docs/
```

# MCreator - Minecraft Mod Maker

[![MCreator](https://mcreator.net/image/brand/mcreator300s.png)](https://mcreator.net/)

MCreator is an open-source software used to make Minecraft Java Edition mods, Minecraft Bedrock Edition Add-Ons, resource packs, and data packs using an intuitive easy-to-learn interface or with an integrated code editor. It is used worldwide by Minecraft players, aspiring mod developers, for education, online classes, and STEM workshops.

NOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.

NOT AN OFFICIAL MCREATOR PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH PYLO.
