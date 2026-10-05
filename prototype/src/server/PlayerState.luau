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
