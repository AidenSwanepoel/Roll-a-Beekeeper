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
