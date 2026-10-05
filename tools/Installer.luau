-- Roll a Beekeeper installer. Paste into Studio's Command Bar (View > Command Bar) and press Enter.
-- Creates all folders and scripts. Safe to re-run: it deletes the old copies first.
local function find(path)
	local obj = game
	for part in string.gmatch(path, "[^%.]+") do
		obj = obj:FindFirstChild(part)
		if not obj then return nil end
	end
	return obj
end
local function make(parentPath, name, class, source)
	local parent = find(parentPath)
	local old = parent:FindFirstChild(name)
	if old then old:Destroy() end
	local inst = Instance.new(class)
	inst.Name = name
	if source then inst.Source = source end
	inst.Parent = parent
end
make("ReplicatedStorage", "Shared", "Folder")
make("ReplicatedStorage.Shared", "Config", "Folder")
make("ReplicatedStorage.Shared.Config", "Rarities", "ModuleScript", [=====[
-- Rarity ladder. Order matters: index 1 is the most common.
-- baseOdds is "1 in N rolls" for a plain roll with no luck. Epic/Legendary/Mythical
-- values come from the reference game's roll sign; the rest are [TUNE] placeholders.
return {
	{ name = "Common", color = Color3.fromRGB(120, 220, 90), oneIn = 1 },
	{ name = "Rare", color = Color3.fromRGB(70, 160, 255), oneIn = 4 },
	{ name = "Epic", color = Color3.fromRGB(185, 90, 255), oneIn = 22 },
	{ name = "Legendary", color = Color3.fromRGB(255, 190, 40), oneIn = 102 },
	{ name = "Mythical", color = Color3.fromRGB(255, 70, 70), oneIn = 247 },
	{ name = "Divine", color = Color3.fromRGB(255, 240, 160), oneIn = 1200 },
	{ name = "Hive Exclusive", color = Color3.fromRGB(40, 255, 220), oneIn = 6000 },
}
]=====])
make("ReplicatedStorage.Shared.Config", "Mutations", "ModuleScript", [=====[
-- All multipliers and chances are [TUNE] placeholders; the original game's values are unpublished.
return {
	{ name = "Normal", multiplier = 1, chance = 1 },
	{ name = "Shiny", multiplier = 1.5, chance = 0.10 },
	{ name = "Molten", multiplier = 2, chance = 0.06 },
	{ name = "Plasma", multiplier = 3, chance = 0.035 },
	{ name = "Pixel", multiplier = 4, chance = 0.02 },
	{ name = "Galaxy", multiplier = 6, chance = 0.01 },
	{ name = "Glitched", multiplier = 10, chance = 0.005 },
	{ name = "Lava", multiplier = 15, chance = 0.002 },
}
]=====])
make("ReplicatedStorage.Shared.Config", "Bees", "ModuleScript", [=====[
-- Common $/s values follow the reference screenshots (3 to 11). Everything else is [TUNE].
return {
	{ id = "sprout_bee", name = "Sprout Bee", rarity = "Common", perSecond = 3 },
	{ id = "star_bee", name = "Star Bee", rarity = "Common", perSecond = 5 },
	{ id = "bumble_bee", name = "Bumble Bee", rarity = "Common", perSecond = 7 },
	{ id = "angel_bee", name = "Angel Bee", rarity = "Common", perSecond = 8 },
	{ id = "clover_bee", name = "Clover Bee", rarity = "Common", perSecond = 11 },
	{ id = "carpenter_bee", name = "Carpenter Bee", rarity = "Rare", perSecond = 40 },
	{ id = "mason_bee", name = "Mason Bee", rarity = "Rare", perSecond = 65 },
	{ id = "orchid_bee", name = "Orchid Bee", rarity = "Epic", perSecond = 300 },
	{ id = "royal_bee", name = "Royal Bee", rarity = "Legendary", perSecond = 2000 },
	{ id = "phoenix_bee", name = "Phoenix Bee", rarity = "Mythical", perSecond = 15000 },
}
]=====])
make("ReplicatedStorage.Shared.Config", "Beekeepers", "ModuleScript", [=====[
-- Capacities for the first tiers mirror the reference (2, 5, 7, 12). Rest are [TUNE].
-- workSeconds = seconds per bee gathered at base speed.
return {
	{ id = "hobby_beekeeper", name = "Hobby Beekeeper", rarity = "Common", capacity = 2, luck = 1, workSeconds = 8 },
	{ id = "rookie_sam", name = "Rookie Sam", rarity = "Common", capacity = 5, luck = 1, workSeconds = 7 },
	{ id = "meadow_mae", name = "Meadow Mae", rarity = "Rare", capacity = 7, luck = 1.2, workSeconds = 6 },
	{ id = "uncle_bob", name = "Uncle Bob", rarity = "Epic", capacity = 12, luck = 1.5, workSeconds = 5 },
	{ id = "queens_guard", name = "Queen's Guard", rarity = "Legendary", capacity = 20, luck = 2, workSeconds = 4 },
	{ id = "hive_wizard", name = "Hive Wizard", rarity = "Mythical", capacity = 30, luck = 3, workSeconds = 3 },
}
]=====])
make("ReplicatedStorage.Shared.Config", "Rebirths", "ModuleScript", [=====[
-- Tier 1 matches the reference screenshot (100K, x1.5 money, +30min offline, x3 roll luck,
-- +1 dock expansion, +1 slot, resets money only). Later costs follow the wiki (3.75M, 150M, 3B).
return {
	{ cost = 100_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 3_750_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 150_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 3_000_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 100_000_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 }, -- [TUNE]
}
]=====])
make("ReplicatedStorage.Shared", "Util", "ModuleScript", [=====[
local Util = {}

local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi" }

function Util.formatNumber(n: number): string
	local i = 1
	while n >= 1000 and i < #SUFFIXES do
		n /= 1000
		i += 1
	end
	if i == 1 then
		return tostring(math.floor(n))
	end
	return string.format("%.2f%s", n, SUFFIXES[i])
end

-- Pick one entry from `entries` where each entry's weight is `weightOf(entry)`.
function Util.weightedPick<T>(entries: { T }, weightOf: (T) -> number, rng: Random?): T
	local r = rng or Random.new()
	local total = 0
	for _, e in entries do
		total += weightOf(e)
	end
	local roll = r:NextNumber() * total
	for _, e in entries do
		roll -= weightOf(e)
		if roll <= 0 then
			return e
		end
	end
	return entries[#entries]
end

return Util
]=====])
make("ReplicatedStorage.Shared", "Remotes", "ModuleScript", [=====[
-- Creates (server) or waits for (client) every RemoteEvent by name.
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NAMES = { "RollOffer", "PickBeekeeper", "RequestRoll", "SellAll", "PlaceBee", "StateChanged" }

local folder
if RunService:IsServer() then
	folder = Instance.new("Folder")
	folder.Name = "Remotes"
	for _, n in NAMES do
		local r = Instance.new("RemoteEvent")
		r.Name = n
		r.Parent = folder
	end
	folder.Parent = ReplicatedStorage
else
	folder = ReplicatedStorage:WaitForChild("Remotes")
end

return folder
]=====])
make("ServerScriptService", "Server", "Folder")
make("ServerScriptService.Server", "PlayerState", "ModuleScript", [=====[
-- In-memory state per player. DataService (phase 3) will load/save this.
local Players = game:GetService("Players")

local PlayerState = {}
local states: { [Player]: any } = {}

local function fresh()
	return {
		money = 0,
		jelly = 0,
		rolls = 0,
		slots = 5, -- hive stands unlocked
		beekeeperSlots = 3,
		rollLuck = 1,
		beeLuck = 1,
		sellMult = 1,
		moneyMult = 1,
		beekeepers = {}, -- { {id=..., jar = { bee,... }, progress = 0} }
		beeInventory = {}, -- { {id=..., mutation="Normal"} }
		stands = {}, -- [standIndex] = { bee = {...}, pending = number }
	}
end

function PlayerState.get(player: Player)
	return states[player]
end

function PlayerState.init(player: Player)
	states[player] = fresh()
	return states[player]
end

Players.PlayerRemoving:Connect(function(p)
	states[p] = nil
end)

function PlayerState.all()
	return states
end

return PlayerState
]=====])
make("ServerScriptService.Server", "Economy", "ModuleScript", [=====[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Bees = require(Shared.Config.Bees)
local Mutations = require(Shared.Config.Mutations)

local Economy = {}

local beeById, mutByName = {}, {}
for _, b in Bees do beeById[b.id] = b end
for _, m in Mutations do mutByName[m.name] = m end

function Economy.beeDef(id: string) return beeById[id] end

function Economy.perSecond(bee): number
	local def = beeById[bee.id]
	local mut = mutByName[bee.mutation or "Normal"] or mutByName.Normal
	return def.perSecond * mut.multiplier
end

-- Sell price is one minute of income [TUNE].
function Economy.sellValue(bee): number
	return Economy.perSecond(bee) * 60
end

return Economy
]=====])
make("ServerScriptService.Server", "RollService", "ModuleScript", [=====[
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Rarities = require(Shared.Config.Rarities)
local Beekeepers = require(Shared.Config.Beekeepers)
local Util = require(Shared.Util)

local RollService = {}

local function pickTier(luck: number, rng: Random)
	return Util.weightedPick(Rarities, function(r)
		if r.oneIn == 1 then
			return 1
		end
		return luck / r.oneIn
	end, rng)
end

local function pickKeeper(tierName: string, rng: Random)
	local pool = {}
	for _, k in Beekeepers do
		if k.rarity == tierName then
			table.insert(pool, k)
		end
	end
	if #pool == 0 then
		return nil
	end
	return pool[rng:NextInteger(1, #pool)]
end

-- Returns three beekeeper ids. Tiers with no content yet fall back to a lower tier.
function RollService.rollThree(luck: number, rng: Random?): { string }
	local r = rng or Random.new()
	local out = {}
	for _ = 1, 3 do
		local tier = pickTier(luck, r)
		local keeper = pickKeeper(tier.name, r)
		local idx = table.find(Rarities, tier) or 1
		while not keeper and idx > 1 do
			idx -= 1
			keeper = pickKeeper(Rarities[idx].name, r)
		end
		table.insert(out, keeper and keeper.id or Beekeepers[1].id)
	end
	return out
end

return RollService
]=====])
make("ServerScriptService.Server", "WorkService", "ModuleScript", [=====[
-- Beekeepers fill their jars; stands accrue money. Runs once per second.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Beekeepers = require(Shared.Config.Beekeepers)
local Bees = require(Shared.Config.Bees)
local Rarities = require(Shared.Config.Rarities)
local Mutations = require(Shared.Config.Mutations)
local Util = require(Shared.Util)

local PlayerState = require(script.Parent.PlayerState)
local Economy = require(script.Parent.Economy)

local WorkService = {}
local rng = Random.new()

local keeperById = {}
for _, k in Beekeepers do keeperById[k.id] = k end

local function rollBee(luck: number)
	local tier = Util.weightedPick(Rarities, function(r)
		return r.oneIn == 1 and 1 or luck / r.oneIn
	end, rng)
	local idx = table.find(Rarities, tier) or 1
	while idx >= 1 do
		local pool = {}
		for _, b in Bees do
			if b.rarity == Rarities[idx].name then table.insert(pool, b) end
		end
		if #pool > 0 then
			local def = pool[rng:NextInteger(1, #pool)]
			local mut = "Normal"
			for i = #Mutations, 2, -1 do
				if rng:NextNumber() < Mutations[i].chance then mut = Mutations[i].name break end
			end
			return { id = def.id, mutation = mut }
		end
		idx -= 1
	end
end

function WorkService.tick(state, dt: number)
	for _, keeper in state.beekeepers do
		local def = keeperById[keeper.id]
		if def and #keeper.jar < def.capacity then
			keeper.progress += dt
			if keeper.progress >= def.workSeconds then
				keeper.progress = 0
				local bee = rollBee(def.luck * state.beeLuck)
				if bee then table.insert(keeper.jar, bee) end
			end
		end
	end
	for _, stand in state.stands do
		if stand.bee then
			stand.pending += Economy.perSecond(stand.bee) * state.moneyMult * dt
		end
	end
end

function WorkService.start(onChanged: (Player) -> ())
	task.spawn(function()
		while true do
			task.wait(1)
			for player, state in PlayerState.all() do
				WorkService.tick(state, 1)
				onChanged(player)
			end
		end
	end)
end

return WorkService
]=====])
make("ServerScriptService.Server", "PlotService", "ModuleScript", [=====[
-- Builds a simple apiary per player out of Parts so the loop is testable with no authored art.
-- Replace the generated parts with real models later; the attribute/prompt contract stays the same.
local Players = game:GetService("Players")

local PlotService = {}

local PLOT_COUNT = 6
local plots = {} -- [index] = { owner = Player?, model = Model }
local byPlayer = {}

local function part(parent, name, size, pos, color)
	local p = Instance.new("Part")
	p.Name, p.Size, p.Position, p.Color = name, size, pos, color
	p.Anchored = true
	p.Material = Enum.Material.Plastic
	p.Parent = parent
	return p
end

local function prompt(parent, action, object, key)
	local pp = Instance.new("ProximityPrompt")
	pp.ActionText, pp.ObjectText = action, object
	pp.HoldDuration = 0
	pp.RequiresLineOfSight = false
	pp.Parent = parent
	return pp
end

function PlotService.build()
	for i = 1, PLOT_COUNT do
		local model = Instance.new("Model")
		model.Name = "Plot" .. i
		local side = (i <= 3) and -1 or 1
		local x = ((i - 1) % 3 - 1) * 70
		local origin = Vector3.new(x, 2, side * 90)

		part(model, "Deck", Vector3.new(50, 1, 50), origin, Color3.fromRGB(205, 130, 60))
		local rollPad = part(model, "RollPad", Vector3.new(6, 2, 6), origin + Vector3.new(0, 1.5, -15), Color3.fromRGB(230, 60, 60))
		prompt(rollPad, "Roll", "Beekeeper", Enum.KeyCode.E).Name = "RollPrompt"

		for s = 1, 5 do
			local sp = origin + Vector3.new(-18 + (s - 1) * 9, 1, 15)
			local stand = part(model, "Stand" .. s, Vector3.new(7, 1, 7), sp, Color3.fromRGB(80, 150, 230))
			stand:SetAttribute("StandIndex", s)
			local collect = part(model, "Collect" .. s, Vector3.new(5, 0.4, 5), sp + Vector3.new(0, 0, 7), Color3.fromRGB(60, 220, 60))
			collect:SetAttribute("StandIndex", s)
			prompt(collect, "Collect", "Stand " .. s, Enum.KeyCode.E).Name = "CollectPrompt"
		end

		for k = 1, 3 do
			local kp = origin + Vector3.new(-12 + (k - 1) * 12, 1, 0)
			local slot = part(model, "KeeperSlot" .. k, Vector3.new(5, 0.4, 5), kp, Color3.fromRGB(255, 200, 60))
			slot:SetAttribute("KeeperIndex", k)
			prompt(slot, "Collect Jar", "Beekeeper " .. k, Enum.KeyCode.E).Name = "JarPrompt"
		end

		model.Parent = workspace
		plots[i] = { owner = nil, model = model, spawn = origin + Vector3.new(0, 4, -25) }
	end
end

function PlotService.assign(player: Player)
	for i, plot in plots do
		if not plot.owner then
			plot.owner = player
			byPlayer[player] = plot
			plot.model:SetAttribute("OwnerId", player.UserId)
			return plot
		end
	end
end

function PlotService.of(player: Player) return byPlayer[player] end

function PlotService.release(player: Player)
	local plot = byPlayer[player]
	if plot then
		plot.owner = nil
		plot.model:SetAttribute("OwnerId", nil)
		byPlayer[player] = nil
	end
end

function PlotService.teleport(player: Player)
	local plot = byPlayer[player]
	local char = player.Character
	if plot and char then char:PivotTo(CFrame.new(plot.spawn)) end
end

Players.PlayerRemoving:Connect(PlotService.release)

return PlotService
]=====])
make("ServerScriptService.Server", "Main", "Script", [=====[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Remotes = require(Shared.Remotes)
local Beekeepers = require(Shared.Config.Beekeepers)

local PlayerState = require(script.Parent.PlayerState)
local PlotService = require(script.Parent.PlotService)
local RollService = require(script.Parent.RollService)
local WorkService = require(script.Parent.WorkService)
local Economy = require(script.Parent.Economy)

local ROLL_COOLDOWN = 3 -- seconds [TUNE]; x2 Roll Speed pass halves it later
local pending = {} -- [Player] = { ids }
local lastRoll = {}
local keeperById = {}
for _, k in Beekeepers do keeperById[k.id] = k end

local function push(player: Player)
	local s = PlayerState.get(player)
	if not s then return end
	local jars, stands = {}, {}
	for i, k in s.beekeepers do jars[i] = { id = k.id, count = #k.jar } end
	for i, st in s.stands do stands[i] = { bee = st.bee, pending = math.floor(st.pending) } end
	Remotes.StateChanged:FireClient(player, {
		money = math.floor(s.money), jelly = s.jelly,
		beekeepers = jars, inventory = s.beeInventory, stands = stands,
	})
end

PlotService.build()
WorkService.start(push)

Players.PlayerAdded:Connect(function(player)
	local s = PlayerState.init(player)
	s.money = 50 -- starter cash [TUNE]
	for i = 1, s.slots do s.stands[i] = { bee = nil, pending = 0 } end
	PlotService.assign(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		PlotService.teleport(player)
	end)
	push(player)
end)

-- Roll: give three candidates, player picks one.
local function ownsPlot(player, inst)
	local plot = PlotService.of(player)
	return plot and inst:IsDescendantOf(plot.model)
end

local function hookPrompts()
	for _, d in workspace:GetDescendants() do
		if d:IsA("ProximityPrompt") then
			d.Triggered:Connect(function(player)
				local s = PlayerState.get(player)
				if not s or not ownsPlot(player, d) then return end

				if d.Name == "RollPrompt" then
					if os.clock() - (lastRoll[player] or 0) < ROLL_COOLDOWN then return end
					lastRoll[player] = os.clock()
					pending[player] = RollService.rollThree(s.rollLuck)
					Remotes.RollOffer:FireClient(player, pending[player])

				elseif d.Name == "JarPrompt" then
					local keeper = s.beekeepers[d.Parent:GetAttribute("KeeperIndex")]
					if keeper then
						for _, bee in keeper.jar do table.insert(s.beeInventory, bee) end
						table.clear(keeper.jar)
						push(player)
					end

				elseif d.Name == "CollectPrompt" then
					local stand = s.stands[d.Parent:GetAttribute("StandIndex")]
					if stand and stand.pending > 0 then
						s.money += stand.pending
						stand.pending = 0
						push(player)
					end
				end
			end)
		end
	end
end
hookPrompts()

Remotes.PickBeekeeper.OnServerEvent:Connect(function(player, choice)
	local offer, s = pending[player], PlayerState.get(player)
	if not offer or not s or typeof(choice) ~= "number" or not offer[choice] then return end
	pending[player] = nil
	if #s.beekeepers >= s.beekeeperSlots then return end -- slots full; Replace flow comes with Inventory UI
	table.insert(s.beekeepers, { id = offer[choice], jar = {}, progress = 0 })
	s.rolls += 1
	push(player)
end)

Remotes.SellAll.OnServerEvent:Connect(function(player)
	local s = PlayerState.get(player)
	if not s then return end
	for _, bee in s.beeInventory do s.money += Economy.sellValue(bee) * s.sellMult end
	table.clear(s.beeInventory)
	push(player)
end)

Remotes.PlaceBee.OnServerEvent:Connect(function(player, invIndex, standIndex)
	local s = PlayerState.get(player)
	if not s or typeof(invIndex) ~= "number" or typeof(standIndex) ~= "number" then return end
	local bee, stand = s.beeInventory[invIndex], s.stands[standIndex]
	if not bee or not stand then return end
	if stand.bee then table.insert(s.beeInventory, stand.bee) end
	table.remove(s.beeInventory, invIndex)
	stand.bee = bee
	push(player)
end)
]=====])
make("StarterPlayer.StarterPlayerScripts", "Main", "LocalScript", [=====[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local Util = require(Shared.Util)
local Beekeepers = require(Shared.Config.Beekeepers)
local Bees = require(Shared.Config.Bees)
local Mutations = require(Shared.Config.Mutations)

local nameOf, perSec, mutMult = {}, {}, {}
for _, k in Beekeepers do nameOf[k.id] = k end
for _, b in Bees do perSec[b.id] = b.perSecond end
for _, m in Mutations do mutMult[m.name] = m.multiplier end

local gui = Instance.new("ScreenGui")
gui.Name = "BeekeeperHud"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local function label(text, pos, color)
	local l = Instance.new("TextLabel")
	l.Size, l.Position = UDim2.fromOffset(220, 40), pos
	l.BackgroundTransparency = 1
	l.Font, l.TextSize, l.TextColor3 = Enum.Font.FredokaOne, 30, color
	l.TextStrokeTransparency = 0
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Text = text
	l.Parent = gui
	return l
end

local function button(text, pos, color, size)
	local b = Instance.new("TextButton")
	b.Size, b.Position = size or UDim2.fromOffset(150, 50), pos
	b.BackgroundColor3, b.Text = color, text
	b.Font, b.TextSize, b.TextColor3 = Enum.Font.FredokaOne, 26, Color3.new(1, 1, 1)
	b.Parent = gui
	return b
end

local money = label("0$", UDim2.new(0, 16, 1, -60), Color3.fromRGB(80, 255, 80))
local jelly = label("0", UDim2.new(0, 16, 1, -100), Color3.fromRGB(255, 220, 60))
local sell = button("Sell", UDim2.new(0.5, 4, 0, 10), Color3.fromRGB(220, 50, 50))
local place = button("Place Best", UDim2.new(0.5, -160, 0, 10), Color3.fromRGB(40, 150, 240))

local state
Remotes.StateChanged.OnClientEvent:Connect(function(s)
	state = s
	money.Text = Util.formatNumber(s.money) .. "$"
	jelly.Text = Util.formatNumber(s.jelly)
end)

sell.Activated:Connect(function() Remotes.SellAll:FireServer() end)

place.Activated:Connect(function()
	if not state then return end
	-- Put the best inventory bee on the first empty stand, or replace the weakest placed bee.
	local function value(bee) return (perSec[bee.id] or 0) * (mutMult[bee.mutation or "Normal"] or 1) end
	local bestIdx, bestVal = nil, -1
	for i, bee in state.inventory do
		if value(bee) > bestVal then bestIdx, bestVal = i, value(bee) end
	end
	if not bestIdx then return end
	local target, weakest = nil, math.huge
	for i, st in state.stands do
		local v = st.bee and value(st.bee) or -1
		if v < weakest then target, weakest = i, v end
	end
	if target and bestVal > weakest then Remotes.PlaceBee:FireServer(bestIdx, target) end
end)

-- Three-candidate roll picker.
local picker = Instance.new("Frame")
picker.Size, picker.Position = UDim2.fromOffset(560, 200), UDim2.new(0.5, -280, 0.5, -100)
picker.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
picker.Visible = false
picker.Parent = gui
local layout = Instance.new("UIListLayout")
layout.FillDirection, layout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 10)
layout.HorizontalAlignment, layout.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center
layout.Parent = picker

Remotes.RollOffer.OnClientEvent:Connect(function(ids)
	for _, c in picker:GetChildren() do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for i, id in ids do
		local k = nameOf[id]
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(170, 170)
		b.BackgroundColor3 = Color3.fromRGB(255, 190, 40)
		b.Font, b.TextSize, b.TextWrapped = Enum.Font.FredokaOne, 22, true
		b.Text = string.format("%s\n%s\nJar: %d", k.name, k.rarity, k.capacity)
		b.Parent = picker
		b.Activated:Connect(function()
			picker.Visible = false
			Remotes.PickBeekeeper:FireServer(i)
		end)
	end
	picker.Visible = true
end)
]=====])
print("Roll a Beekeeper installed. Press Play.")
