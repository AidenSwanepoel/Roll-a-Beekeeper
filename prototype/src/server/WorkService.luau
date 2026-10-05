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
