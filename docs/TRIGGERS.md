# Forge 26.3 Trigger Classification

This classification covers all 65 trigger templates from the official NeoForge
26.3 generator reference (`neoforge-26.3/triggers`).

## Easy / direct Forge event

These use Forge events represented by a direct Forge event class and do not
need client-to-server payloads or Mixin hooks. They are present in
`forge-26.3/triggers`.

`block_break`, `block_multiplace`, `block_place`, `bonemeal_used`,
`bucket_filled`, `chat_sent`, `command_executed`, `crop_attempts_growth`,
`entity_attacked`, `entity_blocks`, `entity_change_equipment`, `entity_dies`,
`entity_dropxp`, `entity_falls`, `entity_grief`, `entity_healed`,
`entity_joins_world`, `entity_jumps`, `entity_pickupxp`,
`entity_sets_attack_target`, `entity_spawns`, `entity_struck_by_lightning`,
`entity_switch_hand`, `entity_tamed`, `entity_ticks`,
`entity_travels_to_dimension`, `entity_uses_totem`, `explosion_occurs`,
`farmland_trampled`, `gem_dropped`, `gem_expired`, `item_crafted`,
`item_destroyed`, `item_smelted`, `minecraft_world_loaded`,
`minecraft_world_unloaded`, `mod_clientload`, `mod_load`, `mod_serverload`,
`player_completes_advancement`, `player_critical_hit`, `player_fishes_item`,
`player_left_click_block`, `player_log_in`, `player_log_out`, `player_respawn`,
`player_right_click_block`, `player_right_click_entity`, `player_right_click_item`,
`player_ticks`, `player_useitem_finish`, `player_useitem_start`,
`player_useitem_stop`, `player_wakes_up`, `player_xp_change`,
`player_xp_level_change`, `village_siege`, `world_ticks`

## Complex

These compatibility triggers were completed with Forge event substitutions:

- `entity_item_pickup` — `EntityItemPickupEvent`
- `entity_pre_hurt` — `LivingDamageEvent`
- `player_in_bed` — `PlayerSleepInBedEvent`

Remaining complex / Mixin trigger:

- `sapling_glow` — no matching Forge event; requires a Mixin into the sapling growth path

`player_left_click_air`, `player_right_click_empty_hand`, and `player_use_hoe`
are now ported as client-side Forge event triggers. They do not yet forward the
client event through a server packet, so their server-side procedure effects
remain a known limitation.

## Dangerous / Very Hard

- Client events (`player_left_click_air`, `player_right_click_empty_hand`) are
  currently client-side only; adding a packet bridge is desync-sensitive.
- `sapling_glow` Mixin is version-sensitive and should not be enabled until a
  controlled runtime test exists.

## Implementation status

- 64 of 65 trigger templates are ported.
- The remaining template is intentionally not enabled yet: `sapling_glow`.
- Plugin validation passes with the ported trigger set.
