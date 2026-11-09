# Phase 2 Status

Version: `2026.3-1.0.92.93-beta`

## Reference implementation

The Phase 2 work follows the official NeoForge 26.3 generator resources under
`reference_resources/generator-26.3.x/neoforge-26.3`.

| Area | NeoForge 26.3 | Forge 26.3 implementation | Status |
| --- | --- | --- | --- |
| Procedures | 513 procedure templates | Imported and validator-checked; Forge-only API replacements applied | Template port complete, runtime regression pending |
| Item inventories | `ItemAccess` + `ResourceHandler<ItemResource>` capabilities | `IItemHandler` / `ItemStackHandler` + `ICapabilitySerializable<CompoundTag>` | Implemented, GUI regression pending |
| Global variables | `${JavaModName}Variables` static fields | Static Forge class fields | Implemented, regression pending |
| World/map variables | `SavedData` | Forge/Minecraft `SavedData` | Implemented, regression pending |
| Player variables | `AttachmentType` | `AttachCapabilitiesEvent<Entity>` + capability | Implemented, death/sync regression pending |
| Networking | NeoForge payload registrar | Forge `SimpleChannel` | Menu/keybind supported; variable sync pending |
| Mixin packaging | Biome `Preset.SourceProvider` mixin + AT | Runtime BiomeSource wrapper / Forge internals | Not applicable to current path |

## Build evidence

- Plugin validation passed with 771 FTL templates and 158 template references.
- `compileJava` and `jar` complete for the current workspace once a valid
  Mavenizer cache is present.
- Client launch reaches resource loading and can load `TestWorld` through
  `--quickPlaySingleplayer`.
- The local Gradle wrapper can fail after the build while writing
  `build/reports/problems/problems-report.html` when that file is locked;
  this is a Gradle report-file issue, not a Java compilation failure.

## Remaining work

- Exercise an item-inventory element through the generated item GUI.
- Exercise number/string/logic/vector/itemstack/blockstate/direction/damage
  source/entity variables in all scopes.
- Port variable sync to the Forge channel.
- Run representative procedures from the 513-template set.
- Re-run the client after MCreator regeneration of the new elements.
