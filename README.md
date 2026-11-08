# Forge 26.3 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge `26.3-66.1.5`, targeting MCreator EAP
`2026.3.44621` (`EAP2026344621`).

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-26.3` |
| Generator id | `forge-26.3` |
| Plugin version | `2026.3-1.0.1.2-beta` |
| Minecraft / Forge | `26.3` / `66.1.5` |
| Gradle for generated mods | Gradle 9.8.0 + ForgeGradle 7 |
| Java for Gradle / MCreator | 25 |
| License | CC BY-NC 4.0 |

## Phase 0 scope

This is the first development batch. It delivers the generator plugin skeleton, the
Forge 26.3 workspace base, and the smallest end-to-end path:

- basic block registration;
- basic item registration and block items;
- custom creative tab registration;
- procedure element;
- `player_right_click_block` trigger.

Advanced element features (entities, fluids, GUIs, dimensions, biomes, capabilities,
networking, variables and most triggers) are intentionally not part of this batch.
They are listed in [docs/SUPPORT-MATRIX.md](docs/SUPPORT-MATRIX.md) and will be added
in later batches after the Phase 0 gate passes.

## Build the plugin

```bat
cd plugin-branch-2026.3
set JAVA_HOME=<MCreator bundled JDK 25>
set GRADLE_USER_HOME=<project-root>\caches\gradle
gradlew.bat --no-daemon clean build
```

Expected output:

```text
VALIDATION PASSED
BUILD SUCCESSFUL
```

The plugin archive is written to:

```text
build/dist/generator-forge-26.3.zip
```

The Gradle wrapper is pinned to the local
`reference_resources/gradle-9.8.0-bin.zip` distribution. All Gradle caches stay under
`<project-root>/caches/gradle`.

## Install

1. Close MCreator.
2. Copy `build/dist/generator-forge-26.3.zip` to the MCreator `plugins` folder.
3. Start MCreator.
4. Create a workspace with generator `Forge for 26.3 (66.1.5)`.

## Phase 0 test checklist

1. Create a basic block with a custom texture.
2. Create a basic item with a custom texture.
3. Add both to a custom creative tab.
4. Create a procedure that sends a chat message and attach it to the
   `player_right_click_block` trigger.
5. Generate the workspace and run `gradlew build`.
6. Start the client, verify the block/item/tab appear and the trigger executes.

The Phase 0 gate is passed only when the generated workspace builds and the trigger
runs in game. A generated code compile has not yet been verified in the current
environment because the local ForgeGradle access-transformer step is blocked; see
`docs/PROJECT-ASSESSMENT.md` section 11.

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

## License

The project is distributed under CC BY-NC 4.0. MCreator-derived generator templates
retain their original copyright and license headers.
