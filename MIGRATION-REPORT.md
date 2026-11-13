# Forge 26.3 Generator Migration Report

## Scope

The generator is a Forge-only conversion of the official MCreator NeoForge 26.3
generator. Its active target is MCreator `2026.3.44621`, Minecraft `26.3`,
Forge `26.3-66.1.8`, Gradle `9.8.0` and Java `25`.

## Completed Migration Work

- Forge registries, lifecycle events, item capabilities and menu providers were
  converted to Forge 26.3 signatures.
- The 65 reference triggers were classified. Direct Forge event mappings and
  compatibility mappings are implemented except for the Mixin-dependent
  `sapling_glow` trigger.
- Procedures were imported from the NeoForge reference and corrected for Forge
  APIs, including mob-effect holders, damage registries and fluid handlers.
- Generated workspaces use ForgeGradle 7, the Forge MDK dependency and the public
  Gradle distribution URL.
- Wrapper scripts resolve the workspace root from `WORKSPACE_ROOT` or the project
  location and keep Gradle caches under `<workspace-root>/caches`.

## Known Limitations

- `sapling_glow` remains disabled because it requires a client Mixin that is not
  packaged by this generator.
- Event cancellation generated from procedure templates is compile-safe but does
  not cancel every Forge 26.3 event. Templates whose Forge event no longer
  exposes the required cancellation accessor are documented as unsupported
  cancellation paths.
- Item inventories and player-variable persistence are implemented through Forge
  capabilities, but not every scope/type combination has a complete networking
  path.
- Networking coverage is partial for client-to-server procedure calls and
  variable synchronization.
- The local ForgeGradle access-transformer task can fail with
  `ReadOnlyFileSystemException` in the bundled MCreator runtime. A valid Mavenizer
  cache entry is required in affected environments.
- The Forge `66.1.8` dependency is resolved from the official Maven repository;
  the local reference MDK remains at `66.1.5` and is used only for API comparison.
- The Gradle wrapper defaults to the public distribution URL and embeds no local
  path. Environments without network access must pre-populate
  `<workspace-root>/caches/gradle` (or set `GRADLE_USER_HOME`) before the first
  build; the wrapper does not automatically select a local archive.

## Validation

- Plugin validation passed with 76 YAML documents, 871 FTL templates and 182
  template references.
- The plugin build completed with Gradle `9.8.0` and produced
  `build/dist/generator-forge-26.3.zip`.
- The Windows wrapper was run without `WORKSPACE_ROOT` or `GRADLE_USER_HOME`
  and resolved Gradle `9.8.0` from `<workspace-root>/caches/gradle`.
- A generated-workspace copy was rebuilt against
  `net.minecraftforge:forge:26.3-66.1.8`; Mavenizer resolved the dependency,
  all Java sources compiled and `build/libs/modid-1.0.jar` was produced.
- The packaged generator metadata reports version
  `2026.3-1.0.111.114-beta`, Forge `66.1.8` and the public Gradle URL.
