# lex-cognitive-surplus

A LegionIO cognitive architecture extension that models cognitive surplus — the available mental bandwidth beyond what is committed to current tasks. Capacity can be committed, allocated to named activities, and automatically replenished over time.

## What It Does

Tracks a single cognitive capacity pool (total = 1.0) divided into three layers:

- **Committed**: capacity actively consumed by ongoing work
- **Reserved**: baseline always held back (0.1) — never allocatable
- **Active allocations**: named reservations for specific activity types

Available surplus is what remains after all three. When surplus falls below 0.15 (the threshold), no new allocations are accepted. The built-in actor replenishes capacity automatically every 60 seconds by reducing committed load.

## Usage

```ruby
require 'lex-cognitive-surplus'

client = Legion::Extensions::CognitiveSurplus::Client.new

# Check current surplus
client.surplus_status
# => { available_surplus: 0.9, surplus_label: :abundant, quality: 1.0, quality_label: :peak, ... }

# Commit capacity to a task
client.commit_capacity(amount: 0.4)
# => { committed: 0.4, available_surplus: 0.5 }

# Allocate some surplus for exploration
result = client.allocate_surplus(activity_type: :exploration, amount: 0.2)
# => { allocated: true, allocation_id: "uuid...", amount: 0.2, quality: 0.6, activity_type: :exploration }

# Release the allocation when done
client.release_surplus(allocation_id: result[:allocation_id])
# => { released: true, allocation_id: "uuid...", amount: 0.2 }

# Uncommit task capacity when work is finished
client.uncommit_capacity(amount: 0.4)
# => { committed: 0.0, available_surplus: 0.9 }

# Simulate a demanding event depleting surplus
client.deplete_surplus(amount: 0.3)
# => { depleted: true, amount: 0.3, available_surplus: 0.6 }

# Manually trigger replenishment (also fires automatically every 60s)
client.replenish_surplus
# => { replenished: true, gained: 0.05, available_surplus: 0.65 }

# List active allocations
client.surplus_allocations
# => { allocations: [...], count: 0 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
