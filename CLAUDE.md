# lex-cognitive-surplus

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-surplus`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::CognitiveSurplus`

## Purpose

Models cognitive surplus — the available cognitive capacity beyond what is committed to current tasks. Capacity can be committed (reserved for active work), allocated to named activities (exploration, consolidation, speculation, maintenance, creative), or allowed to replenish over time. This models the agent's bandwidth for discretionary cognitive work.

## Gem Info

- **Gemspec**: `lex-cognitive-surplus.gemspec`
- **Require**: `lex-cognitive-surplus`
- **Ruby**: >= 3.4
- **License**: MIT
- **Homepage**: https://github.com/LegionIO/lex-cognitive-surplus

## File Structure

```
lib/legion/extensions/cognitive_surplus/
  version.rb
  helpers/
    constants.rb      # Capacity bounds, surplus/quality label tables, allocation types
    allocation.rb     # Allocation class — a single named capacity reservation
    surplus_engine.rb # SurplusEngine — tracks committed/reserved/allocated capacity
  runners/
    surplus.rb        # Runner module — public API
  actors/
    replenish.rb      # Actor::Replenish — fires replenish_surplus every 60s
  client.rb
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `TOTAL_CAPACITY` | 1.0 | Total cognitive capacity |
| `MIN_RESERVE` | 0.1 | Always-reserved baseline (never allocatable) |
| `SURPLUS_THRESHOLD` | 0.15 | Minimum available surplus required to allocate |
| `REPLENISH_RATE` | 0.05 | Committed capacity reduced per replenish tick |
| `DEPLETION_RATE` | 0.08 | Reference rate (defined, not used in engine) |

Surplus labels: `0.6+` = `:abundant`, `0.3..0.6` = `:moderate`, `0.15..0.3` = `:scarce`, `<0.15` = `:depleted`

Quality labels: `0.8+` = `:peak`, `0.6..0.8` = `:rested`, `0.3..0.6` = `:residual`, `<0.3` = `:degraded`

`ALLOCATION_TYPES`: `[:exploration, :consolidation, :speculation, :maintenance, :creative]`

## Key Classes

### `Helpers::Allocation`

An individual capacity reservation.

- `release!` — marks allocation as released (`@released = true`)
- `active?` — `!released`
- Fields: `id` (UUID), `activity_type`, `amount`, `quality` (quality at time of allocation), `created_at`

### `Helpers::SurplusEngine`

Tracks the three-layer capacity model: committed + reserved + active allocations.

- `available_surplus` — `TOTAL_CAPACITY - committed - reserved - sum(active allocations)`
- `surplus_quality` — `(1.0 - committed) / 1.0`; measures how much unused baseline capacity exists
- `allocate!(activity_type:, amount:)` — fails if type invalid, surplus below threshold, or clamped amount <= 0; creates `Allocation` and returns result hash
- `release!(allocation_id:)` — marks the named allocation released; fails if not found or already released
- `commit!(amount:)` — adds to `@committed`; capped at `TOTAL_CAPACITY - MIN_RESERVE`
- `uncommit!(amount:)` — reduces `@committed`; capped at current committed
- `replenish!` — reduces `@committed` by `REPLENISH_RATE`; returns gained amount and new surplus
- `deplete!(amount:)` — increases `@committed` by amount (capped at `available_surplus`)
- `surplus_report` — full status hash with labels
- `to_h` — `surplus_report` + all allocations

## Runners

Module: `Legion::Extensions::CognitiveSurplus::Runners::Surplus`

| Runner | Key Args | Returns |
|---|---|---|
| `surplus_status` | — | full `surplus_report` hash |
| `allocate_surplus` | `activity_type:`, `amount:` | `{ allocated:, allocation_id:, amount:, quality:, activity_type: }` or `{ allocated: false, reason: }` |
| `release_surplus` | `allocation_id:` | `{ released:, allocation_id:, amount: }` or `{ released: false, reason: }` |
| `commit_capacity` | `amount:` | `{ committed:, available_surplus: }` |
| `uncommit_capacity` | `amount:` | `{ committed:, available_surplus: }` |
| `replenish_surplus` | — | `{ replenished: true, gained:, available_surplus: }` |
| `deplete_surplus` | `amount:` | `{ depleted: true, amount:, available_surplus: }` |
| `surplus_allocations` | — | `{ allocations:, count: }` (active only) |

`allocate_surplus` defaults `amount:` to `SURPLUS_THRESHOLD` if not provided.

## Actors

`Actor::Replenish` — extends `Legion::Extensions::Actors::Every`

- Fires `replenish_surplus` every **60 seconds**
- `run_now?: false`, `use_runner?: false`, `check_subtask?: false`, `generate_task?: false`
- Gradually reduces committed load, simulating cognitive recovery between tasks

## Integration Points

- `replenish_surplus` is called automatically every 60s by `Actor::Replenish`
- `commit_capacity` / `uncommit_capacity` can be called by `lex-tick` action selection phase to gate discretionary work
- Can be used alongside `lex-cognitive-rhythm` to model capacity peaks as surplus windows
- All state is in-memory per `SurplusEngine` instance

## Development Notes

- `available_surplus` computation: `1.0 - committed(0.0) - reserved(0.1) - active_allocated` at initialization = 0.9
- `DEPLETION_RATE` is defined but not used in `deplete!`; `deplete!` uses the caller-provided `amount`
- Releasing an allocation does NOT reduce `@committed`; committed is a separate concept from allocations
- `surplus_allocations` runner filters to active allocations only; released ones remain in `@allocations` hash
- The allocation ID is a UUID string; no sequential symbol scheme
