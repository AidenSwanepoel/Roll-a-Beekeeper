# Roll a Beekeeper: Step-by-Step Roadmap

Rule: **one system per step.** Each step ends with something the owner can see working in Studio before the next begins. Every step follows the layout in `CLAUDE.md` (Config = data, Service = logic, Controller = connects to the world).

Legend: [x] done, [ ] to do. Details of each original system are in `BUILD_PLAN.md` section 4.

## Phase A: Core loop

- [x] **1. Roll button**: ProximityPrompt rolls a rarity (1 in N odds).
- [x] **2. Spots**: three spots show the rolled beekeepers as labels.
- [x] **3. Pick one**: pick prompt on each spot; chosen beekeeper saved under the player. Refactored into Config / RollService / PlayerData / RollStationController.
- [ ] **4. Money counter**: Honey $ shown on screen. Add `Currency` service (add/spend, server-owned) and a small client HUD script. Starting cash 50.
- [ ] **5. Beekeeper slots**: limit owned/equipped beekeepers (start 3). A picked beekeeper appears on the plot at a slot. Full slots: ask to replace.
- [ ] **6. Jar and gathering**: each equipped beekeeper fills a jar with bees over time (capacity and work speed per beekeeper). Add Bees config (species, rarity, $/s).
- [ ] **7. Collect jar**: prompt at the beekeeper empties the jar into the bee inventory.
- [ ] **8. Hive stands**: place a bee on a stand; stand earns $/s. "Place best" first, real inventory UI later.
- [ ] **9. Collect pad**: walk onto the pad to collect what the stand earned.
- [ ] **10. Sell**: Sell button sells inventory bees for Honey $.

## Phase B: Persistence and plots

- [ ] **11. Plots**: six plots, one assigned per player, roll station and stands per plot (replace the single shared station).
- [ ] **12. Saving**: DataStore (ProfileStore or similar) behind `PlayerData`. Nothing else should change.
- [ ] **13. Offline earnings**: `min(time away, max offline time) * $/s`, shown as "You earn X/h offline".

## Phase C: Progression

- [ ] **14. Upgrades stall** (Royal Jelly): Work Speed, Bee Luck, Mutation Luck, Roll Luck, Sell Price, Offline Time, Jelly Luck.
- [ ] **15. Smoker stall**: tool tiers raising Bee Luck. Hotbar: Items, Pick Up, Smoker.
- [ ] **16. Rebirth**: tier 1 costs 100K; x1.5 money, +30 min offline, x3 roll luck, +1 dock expansion, +1 slot; resets money only. Later tiers 3.75M, 150M, 3B.
- [ ] **17. Mutations**: Shiny, Molten, Plasma, Pixel, Galaxy, Glitched, Fiery, Flaming, Lava; multipliers on $/s; natural chance plus Mutation Luck.
- [ ] **18. Mutation Machine**: place a bee, pay, roll a mutation.
- [ ] **19. Index**: discovery tracker (species x mutation), milestone rewards.

## Phase D: Meta and economy

- [ ] **20. Free Wheel Spin**: timed free spin, rewards: bee, cash, spins, beekeeper, Jelly, Golden Spin.
- [ ] **21. HUD polish**: Dock and Sell buttons, left menu with badges, Auto Sell / Auto Collect toggles, hotbar, luck indicators (clover, orb). Match `docs/reference/ui-hud`.
- [ ] **22. Shop and gamepasses**: x2 Money 14, Auto Sell 75, x2 Roll Speed 109, x2 Work Speed 145, x2 Capacity 145, Auto Collect 289, Royal Crates 149/449/749, bundle 255, gifting.
- [ ] **23. Achievements and Titles**: hex-grid screen, 5 tabs (Progression, Milestones, Completionist, The Long Road, RNG Path), Claim All.
- [ ] **24. Leaderboards**: Playtime, Royal Jelly, Money/s, Bees Caught (OrderedDataStore).

## Phase E: Social and ship

- [ ] **25. Trading**: server-validated escrow, player list, history.
- [ ] **26. Auctions**: list for Jelly, fixed duration, small fee.
- [ ] **27. Hub map and art pass**: hub island, stalls (Smoker, Upgrades, Sell), six piers, palms, signs, honeycomb styling. Use `docs/reference/map`.
- [ ] **28. Audio, QA, balance, launch.**

## Per-step checklist

1. Say what the step teaches and what the owner will see.
2. Name exactly which folders/instances to create and where.
3. Give each script in full, saying where to paste it.
4. Give a test: what to press and what Output should print.
5. Mirror the code into `src/` and commit.
