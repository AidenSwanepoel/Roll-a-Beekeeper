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
