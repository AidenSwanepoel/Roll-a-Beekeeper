local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Rarities = require(Shared.Config.Rarities)
local Beekeepers = require(Shared.Config.Beekeepers)
local Util = require(Shared.Util)

local RollService = {}

-- Picks a rarity using "1 in N" odds scaled by luck, then a beekeeper of that rarity.
-- Rarer tiers have larger N, so weight = luck-adjusted 1/N for tiers above Common.
function RollService.roll(luck: number, rng: Random?)
	local tier = Util.weightedPick(Rarities, function(r)
		if r.oneIn == 1 then
			return 1
		end
		return luck / r.oneIn
	end, rng)

	local pool = {}
	for _, k in Beekeepers do
		if k.rarity == tier.name then
			table.insert(pool, k)
		end
	end
	if #pool == 0 then
		pool = Beekeepers -- fall back until all tiers have content
	end
	return pool[(rng or Random.new()):NextInteger(1, #pool)]
end

return RollService
