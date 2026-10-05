# Roll a Beekeeper: Build Plan

A reskin of *Roll a Fisherman* with a bee theme. This plan covers what the original does (from your screenshots plus public wiki and guide research), how each system maps to bees, and the order to build it in.

**Confidence tags used below**
- **[SEEN]**: visible in your screenshots.
- **[WIKI]**: from public guides and wikis. I could not open the wiki sites directly from this container, so this comes from search snippets and is less certain.
- **[TUNE]**: my own placeholder. We have no real data for it, so playtest and adjust.

Decisions made so far:
- Collectibles are **bees** (not honey jars).
- The "Pet 1-11" images are from an unrelated game (Pet Tower Defense) and are **ignored**. They are not copied into the repo.
- Same monetization structure as the original, with our own names, art and tuned numbers.
- Delivery is a Rojo-style repo, plus Open Cloud if the host allowlist is changed (see §10).

---

## 1. The core loop

The original is an idle dock tycoon wrapped around an RNG roller. One lap looks like this:

```
 ROLL a worker ──► PLACE worker on a dock slot ──► worker fills its BUCKET with catches
        ▲                                                       │
        │                                                       ▼
  spend $ / Gold on        COLLECT catches ◄──────────── walk to the dock
  luck, speed, rebirth          │
        ▲                       ▼
        └──── $ earned ◄── PLACE catch on a BASE STAND (earns $/s) or SELL it
```

Beekeeper version:

```
 ROLL a beekeeper ──► PLACE on a hive slot ──► beekeeper gathers bees into a JAR (capacity-limited)
        ▲                                                       │
        │                                                       ▼
  spend $ / Royal Jelly on   COLLECT bees ◄──────────── walk to the apiary
  luck, speed, rebirth          │
        ▲                       ▼
        └──── $ earned ◄── PLACE bee on a HIVE STAND (earns $/s) or SELL it
```

What keeps the loop sticky:
1. **Rolling** is the dopamine hit (odds are shown on a sign: "Epic in 22 rolls", "Legendary in 102", "Mythical in 247" [SEEN]).
2. **Capacity limits** (jar size and stand count) force constant upgrading and rebirthing.
3. **Mutations** give every collectible a second rarity axis, which is where the 1339-entry Index comes from.
4. **Offline earnings** make logging off feel safe.
5. **Social layer**: trading, auctions, leaderboards, and every plot visible to everyone.

---

## 2. Theme mapping (fisherman to beekeeper)

| Original [SEEN/WIKI] | Beekeeper | Notes |
|---|---|---|
| Roll a Fisherman | Roll a Beekeeper | |
| Fisherman (rolled worker) | **Beekeeper** | Rarity decides jar capacity and bee luck |
| Fish (collectible) | **Bee** | Species plus mutation, each earns $/s |
| Bucket (worker storage) | **Jar** | Full jar means the beekeeper stops working |
| Dock (player plot) | **Apiary** (wooden platform on a flower meadow) | |
| Blue fish stands + green Collect pads | **Hive stands** + Collect pads | Bees sit on the stand and show name, rarity, $/s |
| Purple pads (locked "Rebirth N") | Same, locked hive slots | |
| Roll pedestal (red button) | Roll button on a honey-pot pedestal | |
| Fishing Rods stall | **Smoker stall** (tool upgrades Bee Luck) | The hotbar "Rod" becomes "Smoker" |
| Upgrades stall (wizard) | Upgrades stall (beekeeper in a veil hat) | |
| Sell stall (life ring) | Sell stall (honey barrel) | |
| Gold (bar icon) | **Royal Jelly** | Premium soft currency |
| Cash ($) | **Honey $** | Keep the $ symbol, e.g. "302$" |
| Mutation Machine | **Mutation Machine** (hive-tech lab) | Place a bee, pay, get a mutation roll |
| Free Wheel Spin | **Free Wheel Spin** (hexagonal honeycomb wheel) | |
| Golden Crates | **Royal Crates** | |
| Vouchers (shop items) | **Vouchers** | |
| Titles | **Titles** | |
| Banana-shaped boats (decor) | Giant honey dippers / flower arches | Pure decoration |

---

## 3. World and map [SEEN]

One shared server of up to ~6 players. Hub in the middle, six player plots around it.

**Hub island** (grass, sand paths with directional arrows):
- **Three stalls in a row**: *Fishing Rods* (green), *Upgrades* (purple), *Sell* (blue).
- **Mutation Machine** (dark tech block with a glowing pad; prompt "Place Fish" becomes "Place Bee").
- **Four leaderboard boards** along the shore: *Playtime*, *Gold*, *Money/s*, *Fish Caught*. They show 10 players each, with avatar, handle and value (e.g. "$20.67B/s", "582h 17m").
- Community-join sign, decorative palms, stone path tiles.

**Player plots**: 6 piers around the hub, 3 north and 3 south. Each has:
- Rows of blue stands (the placement slots) with green Collect pads beside them.
- The roll pedestal with a sign showing time-to-rarity odds.
- Beekeepers standing on the plot with jars next to them.
- A personal **Free Wheel Spin** with a "READY!" bar.
- A name sign ("Veggie's Dock") plus a trophy and a thumbs-up counter at the entry.
- Locked purple pads labelled "Rebirth 2/3/4/5 Locked" [SEEN].
- "Upgraded" plots (`Upgraded Plot 1/2` in your pack) are the same plot after rebirth expansions: more decks and a bigger footprint.

**World look**: Roblox-brick voxel style, saturated blue water, orange wooden decks. For us: pastel meadow, honey-orange decks, hex-pattern details.

---

## 4. Systems in detail

### 4.1 Rolling [SEEN/WIKI]
- Interact (E) on the pedestal. "Roll" with a cooldown, which the **x2 Roll Speed** pass halves.
- Result is a **Beekeeper** of a given rarity. Odds are shown as "in N rolls".
- Wiki says each roll shows candidates and you pick; the screenshot shows a single pedestal. **Open question 1.**
- Rarity ladder [WIKI]: Common, Rare, Epic, Legendary, Mythical, Divine, and an exclusive top tier ("Deep Exclusive", which becomes **Hive Exclusive**).
- **Roll Luck** shifts weights toward Epic and above.

### 4.2 Beekeepers (workers) [SEEN/WIKI]
- Stats: **jar capacity** and **bee luck**. Examples from the original: Homeless Fisher 2, Rookie Sam 5, Deep Fisher 7, Uncle Bob 12.
- Beekeepers have named perks (e.g. "Koi Fisher: Mutation Surge, Plasma twice as likely").
- They are **equipped** onto the plot (Inventory has *Equip Best* / *Unequip All*, search, and favorite star).
- They work automatically. When the jar is full, they stop until you collect.

### 4.3 Bees (collectibles) [SEEN]
- 11 Common, 8 Rare, and so on up the ladder; a species is shown as a silhouette until discovered.
- Each species has a **$/s** value (Common examples from screenshots: $3/s to $11/s).
- Placing a bee on a hive stand gives its $/s as passive income, and the stand's Collect pad accumulates it.
- Slot count is limited, so players trade up.

### 4.4 Mutations [WIKI]
- Names in the original: Shiny, Molten, Plasma, Pixel, Galaxy, Glitched, plus Fiery, Flaming, Lava in the Index sidebar. Each multiplies the bee's $/s.
- Two sources: (a) a natural chance on catch, boosted by **Mutation Luck**, and (b) the **Mutation Machine** for a fee.
- Beekeeper names for the Index sidebar [TUNE]: Normal, Shiny, Molten, Plasma, Pixel, Galaxy, Glitched, Fiery, Flaming, Lava.
- Multipliers are not published anywhere I could access. See `src/shared/Config/Mutations.luau`, all **[TUNE]**.

### 4.5 Economy [SEEN/WIKI]
- **Money** from placed bees ($/s), plus selling via *Sell* button / stall.
- **Gold -> Royal Jelly**: spent at the Upgrades stall.
- Upgrades stall stats [WIKI]: Fishing Speed (Work Speed), Catch Luck (Bee Luck), Mutation Luck, Roll Luck, Sell Price, Offline Time, Gold Luck (Jelly Luck).
- Smoker stall: better tools raise Bee Luck.

### 4.6 Rebirth [SEEN]
Screenshot: requirement **100K$**. Rewards: x1.5 money multiplier, +30 min max offline time, x3 Rolling Luck, +1 Dock Expansion, +1 Fish Slot. **Resets money only. Keeps fish and fishers.**
- Later tiers [WIKI]: 3.75M, then 150M plus specific fish, then 3B. **Skip Rebirth** (marked OPI) is a Robux button.
- Rebirth also unlocks the locked purple pads ("Rebirth 2-5 Locked").

### 4.7 Wheel [SEEN/WIKI]
- Free spin on a timer. Slice rewards: exclusive bee, cash, extra spin, exclusive beekeeper, a Golden Spin chance, Jelly (e.g. 50), cash (e.g. 1M).
- Codes can grant spins.

### 4.8 Index [SEEN]
- Counter "5/1339 (0%)". Tabs: Fish, Fishers, Titles. Sidebar: mutation filters.
- A progress bar at the bottom ("6/25", reward "x3K") pays out as you hit milestones.
- Our entry count will be far smaller (see §6).

### 4.9 Achievements [SEEN]
- Hex-grid map, 5 tabs: **Progression (2/55), Milestones (1/40), Completionist (0/40), The Long Road (1/8), RNG Path (0/18)**. Nodes show names ("Bucket Starter", "Pirate Hoard", "Double Down", "Born Again"). A **Claim All** button.
- Total is about 161 achievements. We'll reskin names (e.g. "Jar Starter", "Queen's Hoard").

### 4.10 Trade, Auctions, Titles [SEEN]
- **Trade**: pick a player in the server, Send, then a history tab.
- **Auctions**: separate button. Exact rules unknown. **Open question 2.**
- **Titles** are cosmetic tags, shown under names on the avatar ("Collector", "One of a Kind").

### 4.11 Shop and monetization [SEEN]
| Item | Original price (R$) | Ours |
|---|---|---|
| x2 Money | 14 (HUD promo tag reads "Only 14", which looks like limited stock; **Open question**) | same |
| Auto Sell | 75 | same |
| x2 Roll Speed | 109 | same |
| x2 Fishing Speed | 145 | x2 Work Speed |
| x2 Capacity | 145 | same |
| Auto Collect | 289 | same |
| Golden Crates (1 / 5 / 10) | 149 / 449 / 749 | Royal Crates, same |
| "Insane Bundle" (cash + exclusive worker + exclusive fish, shown as best value) | 255 | same shape |
| Gifting | button | same |

**Royal Crate contents** [SEEN]: Hobby Beekeeper 40% and 29% (two roll tiers), then Golden-tier workers 19% / 7.5% / 3.5% with "100% / 110% / 125% BEST" labels, then a 1% **Golden Queen** (earns 1 Jelly/s).

Prices are copied from the screenshots. If you want us to undercut or reprice, tell me.

### 4.12 HUD [SEEN]
- **Top centre**: *Dock* (teleport to your plot) and *Sell* (sell all) buttons.
- **Left**: 6 icon buttons (Shop, Achievements, Rebirth, Trade, Index, Auctions) with red badge counts.
- **Right**: a rainbow **x2 Money** promo tagged "Only 14", plus **Auto Sell** and **Auto Collect** toggles.
- **Bottom left**: Gold and Cash counters with a green "+" (buy).
- **Bottom centre hotbar**: 1 Items, 2 Pick Up (hammer), 3 Rod (-> Smoker).
- **Bottom right**: luck clover "x50" and a 5% orb, plus an "x1" multiplier indicator.
- Top-right: Roblox's own player list, extended with *Rebirths, Money/s, Fish*.
- Style: chunky comic font with dark outline, brick-stud texture on panels, bright red X close buttons.

---

## 5. Tuning numbers (placeholders)

Only these are known from the original. Everything else is **[TUNE]**.

- Roll odds shown for a starter plot: Epic ~1/22, Legendary ~1/102, Mythical ~1/247.
- Rebirth costs: 100K, 3.75M, 150M, 3B.
- Starter capacities: 2, 5, 7, 12.
- Starter $/s: 3 to 11 for Commons.

I generate the rest with simple curves in `src/shared/Config/*.luau` so they can be rebalanced in one place.

---

## 6. Content scope for v1

| Content | Original | v1 target |
|---|---|---|
| Bee species | ~100+ (1339 includes mutations) | **40** across 7 rarities |
| Mutations | 10+ | **8** |
| Beekeepers | ~25 | **16** |
| Achievements | ~161 | **30** at launch |
| Plots | 6 | 6 |
| Rebirth tiers | 13+ (leaderboard shows 13) | **5** |

---

## 7. Technical architecture

```
default.project.json            (Rojo mapping)
src/
  shared/Config/                Rarities, Mutations, Bees, Beekeepers, Rebirths (data only)
  shared/Util/                  Number formatting (K, M, B), weighted random
  server/                       RollService, PlotService, EconomyService, DataService, ...
  client/                       UI controllers
```

**Server authority**: money, rolls, rebirths, trades. The client only sends requests via RemoteEvents/Functions and renders results.

**Persistence**: DataStore with session lock, using ProfileStore (or an equivalent wrapper). Data per player: money, jelly, beekeepers, bees (with mutation), placed layout, upgrades, rebirths, index, achievements, last-seen timestamp (for offline earnings).

**Offline earnings**: on join, `min(now - lastSeen, maxOfflineTime) * moneyPerSecond`, with a "You earn X/h Offline!" HUD line [SEEN].

**Leaderboards**: OrderedDataStore (Playtime, Jelly, Money/s, Bees caught), refreshed every few minutes.

**Trading and Auctions**: server-validated escrow, history stored per player.

**Monetization**: gamepasses plus developer products (crates, bundles, Skip Rebirth), using `MarketplaceService`.

---

## 8. Build order

| Phase | What | Done when |
|---|---|---|
| 0 | Repo, Rojo, config data (done in this commit) | Project syncs into Studio |
| 1 | Plot, roll pedestal, rarity roll, beekeeper placed | You can roll and see a beekeeper |
| 2 | Jar fill, collect, bee on stand, $/s, Sell | Core loop works end to end |
| 3 | DataStore save/load, offline earnings | Progress persists |
| 4 | Upgrades stall, Smoker stall, luck stats | Spending loop works |
| 5 | Rebirth with unlocks | Rebirth 1-2 testable |
| 6 | Mutations, Mutation Machine, Index | Collection layer works |
| 7 | HUD and UI polish | Matches reference style |
| 8 | Shop, gamepasses, crates, wheel | Monetization wired |
| 9 | Achievements, titles, leaderboards | Meta layer |
| 10 | Trade, auctions | Social layer |
| 11 | Art pass, audio, QA, launch | Ship |

---

## 9. Decisions (resolved)

| Question | Answer |
|---|---|
| Roll shows 3 candidates or 1? | **3 candidates, player picks one** |
| Auctions | "Yes". No rules were given, so use the default: list a bee or beekeeper for Royal Jelly, fixed duration, small fee. Revisit at the Trade/Auctions step |
| Changes vs original | **None.** Exact same game, adapted to a bee premise |
| Clover "x50" and 5% orb at bottom right of HUD | Unknown. Treat as luck boosts; confirm when building the HUD |
| Currency names | **Royal Jelly** (premium) and **Honey $** (cash) |
| "Only 14" on the x2 Money button | Ignore |
| Pet 1-11 images | Wrong game (Pet Tower Defense). Ignore |
| Monetization | Same structure, rethemed names and tuned numbers |
| How we build | **One small system at a time**, hand-built in Studio so the owner understands each piece. Properly organised: no giant scripts |

## 10. Studio connection status

- Not connected from the cloud. Cloud containers cannot reach a Studio on your computer, and Roblox hosts (`apis.roblox.com`, `create.roblox.com`, `www.roblox.com`) are blocked by the cloud network policy.
- In a **desktop session**, work locally: either edit scripts in the repo and sync with Rojo, or paste scripts into Studio by hand. See `docs/ROADMAP.md` for the step-by-step plan and `CLAUDE.md` for working rules.

## 11. Progress snapshot

Built by hand in Studio so far (code mirrored in `src/`):
- Step 1: Roll button prompt and rarity roll
- Step 2: three beekeeper spots show rolled names
- Step 3: pick one of the three (stored under `Player > Beekeepers`), refactored into Config / Service / Controller

`prototype/` holds an earlier all-in-one prototype (plots, jars, stands, sell, HUD, installer). It is **reference only**, not the build path. Reuse ideas from it as each step comes up.
