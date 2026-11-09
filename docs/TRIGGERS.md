# Forge 26.3 Trigger Classification

This classification covers all 65 trigger templates from the official NeoForge
26.3 generator reference (`neoforge-26.3/triggers`).

## Easy

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

These need a compatibility or behavior rewrite because the Forge 26.3 event
shape differs from the NeoForge reference:

- `entity_item_pickup` — no equivalent direct `ItemEntityPickupEvent.Pre`
- `entity_pre_hurt` — Forge damage event naming/semantics differ
- `player_in_bed` — Forge sleep events have different validation semantics
- `player_use_hoe` — Forge 26.3 does not expose the same dedicated use-on-block event

## Complex / Mixin

These need a client-side hook or a Mixin because Forge does not expose the
equivalent event:

- `player_left_click_air` — client-only interaction event; needs a packet bridge
- `player_right_click_empty_hand` — client-only interaction event; needs a packet bridge
- `sapling_glow` — no matching Forge event; requires a Mixin into the sapling growth path

## Dangerous / Very Hard

- Client events forwarded through custom packets (`player_left_click_air`,
  `player_right_click_empty_hand`) are desync/duplication sensitive.
- `sapling_glow` Mixin is version-sensitive and should not be enabled until a
  controlled runtime test exists.
- `player_in_bed` and `entity_pre_hurt` must not be marked supported until
  their cancellation/result semantics are verified.

## Implementation status

- 58 of 65 trigger templates are ported as easy triggers.
- The 7 remaining templates are intentionally not enabled yet.
- Plugin validation passes with the ported trigger set.
