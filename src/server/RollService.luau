local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = ReplicatedStorage.Shared.Config

local Rarities = require(Config.Rarities)
local Beekeepers = require(Config.Beekeepers)

local RollService = {}

-- Rolls from the rarest tier down. The first tier that hits wins.
local function rollRarityIndex()
	for i = #Rarities, 2, -1 do
		if math.random(1, Rarities[i].oneIn) == 1 then
			return i
		end
	end
	return 1
end

local function beekeepersOfRarity(rarityName)
	local pool = {}
	for _, keeper in Beekeepers do
		if keeper.rarity == rarityName then
			table.insert(pool, keeper)
		end
	end
	return pool
end

-- Returns a beekeeper: { name = ..., rarity = ... }
function RollService.rollBeekeeper()
	local index = rollRarityIndex()
	local pool = beekeepersOfRarity(Rarities[index].name)
	-- If a tier has no beekeepers yet, fall back to the next tier down.
	while #pool == 0 and index > 1 do
		index -= 1
		pool = beekeepersOfRarity(Rarities[index].name)
	end
	return pool[math.random(1, #pool)]
end

function RollService.getRarityColor(rarityName)
	for _, rarity in Rarities do
		if rarity.name == rarityName then
			return rarity.color
		end
	end
	return Color3.new(1, 1, 1)
end

return RollService
