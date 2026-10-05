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
