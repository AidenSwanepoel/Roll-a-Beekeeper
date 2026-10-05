-- The one place that knows how a player's owned beekeepers are stored.
-- Right now: a Folder under the player. Later we swap this for real saving
-- and nothing else has to change.
local PlayerData = {}

function PlayerData.addBeekeeper(player, keeper)
	local folder = player:FindFirstChild("Beekeepers")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Beekeepers"
		folder.Parent = player
	end

	local entry = Instance.new("StringValue")
	entry.Name = keeper.rarity
	entry.Value = keeper.name
	entry.Parent = folder
	print(player.Name .. " now owns " .. keeper.name .. " (" .. keeper.rarity .. ")")
end

return PlayerData
