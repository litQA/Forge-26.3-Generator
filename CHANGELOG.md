# Changelog

All notable changes to the Forge 26.3 generator are recorded in this file.

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
