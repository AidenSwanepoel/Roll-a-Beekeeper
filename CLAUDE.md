# Roll a Beekeeper: working notes for Claude

A Roblox game: an exact bee-themed reskin of *Roll a Fisherman*. Read `docs/BUILD_PLAN.md` (what the game is) and `docs/ROADMAP.md` (what to build next, and what is done).

## How we work
- The owner is new to Roblox scripting and wants to **understand every system**. Build **one small system per step**; explain what it does and why in plain language; give an exact test.
- Instructions must say precisely which folder or instance to create, where, and where to paste each script. Don't assume Rojo or command-line knowledge.
- Check `docs/ROADMAP.md` for the current step. Don't jump ahead or bundle several systems.

## Code rules
- **Never put everything in one script.** Three layers:
  - **Config** (`ReplicatedStorage/Shared/Config`): data-only ModuleScripts (rarities, beekeepers, bees, mutations, prices). Balancing = edit data here.
  - **Services** (`ServerScriptService/Server/*Service`): ModuleScripts with logic. They know nothing about parts in the workspace.
  - **Controllers** (`*Controller.server.luau`): the only Scripts; they connect world objects (prompts, parts, GUIs) to services.
- `PlayerData` is the only module that knows how player data is stored. Saving later changes only this module.
- **Server owns the truth** (money, rolls, rebirths, trades). Clients only request and display.
- Match existing style: tabs, `local` everything, short comments that explain why.
- Mark unknown numbers `[TUNE]`; known numbers from the original come from the reference screenshots in `docs/reference`.

## Layout
- `src/` is the real project, mapped by `default.project.json` (Rojo) and mirrored by hand in Studio.
- `prototype/` is an earlier all-in-one build. Reference only; don't extend it.
- `docs/reference/` has screenshots of the original (HUD, map, plots, mutation machine). The "Pet" images are from an unrelated game and were left out.

## Theme names
Fisherman = Beekeeper, fish = bee, bucket = jar, dock = apiary, Gold = Royal Jelly, cash = Honey $, rod = Smoker, Golden Crates = Royal Crates.

## Current state
Steps 1-3 done (roll button, three spots, pick one). Next: step 4, money counter.

## Studio access
Cloud sessions can't reach Studio. In a desktop session, either use a local Studio MCP server if available, or sync with Rojo, or give paste-ready scripts.
