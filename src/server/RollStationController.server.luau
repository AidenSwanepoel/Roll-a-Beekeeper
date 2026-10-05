local RollService = require(script.Parent.RollService)
local PlayerData = require(script.Parent.PlayerData)

local ROLL_COOLDOWN = 1.5

local rollPrompt = workspace:FindFirstChild("RollButton", true):FindFirstChildWhichIsA("ProximityPrompt", true)
local spots = {
	workspace:FindFirstChild("Spot1", true),
	workspace:FindFirstChild("Spot2", true),
	workspace:FindFirstChild("Spot3", true),
}

-- Finds a Part to attach things to, whether the spot is a Part or a Model.
local function anchorPart(spot)
	if spot:IsA("BasePart") then
		return spot
	end
	return spot:FindFirstChildWhichIsA("BasePart", true)
end

local function clearSpot(spot)
	local part = anchorPart(spot)
	for _, childName in { "KeeperLabel", "PickPrompt" } do
		local old = part:FindFirstChild(childName)
		if old then
			old:Destroy()
		end
	end
end

local function clearAllSpots()
	for _, spot in spots do
		clearSpot(spot)
	end
end

local function showKeeper(spot, keeper)
	clearSpot(spot)
	local part = anchorPart(spot)

	local gui = Instance.new("BillboardGui")
	gui.Name = "KeeperLabel"
	gui.Size = UDim2.fromOffset(200, 60)
	gui.StudsOffset = Vector3.new(0, 4, 0)
	gui.AlwaysOnTop = true
	gui.Adornee = part
	gui.Parent = part

	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Font = Enum.Font.FredokaOne
	text.TextScaled = true
	text.TextColor3 = RollService.getRarityColor(keeper.rarity)
	text.TextStrokeTransparency = 0
	text.Text = keeper.name .. "\n" .. keeper.rarity
	text.Parent = gui

	local pick = Instance.new("ProximityPrompt")
	pick.Name = "PickPrompt"
	pick.ActionText = "Pick"
	pick.ObjectText = keeper.name
	pick.HoldDuration = 0
	pick.RequiresLineOfSight = false
	pick.MaxActivationDistance = 20
	pick.Parent = part

	pick.Triggered:Connect(function(player)
		PlayerData.addBeekeeper(player, keeper)
		clearAllSpots()
	end)
end

local busy = false
rollPrompt.Triggered:Connect(function()
	if busy then
		return
	end
	busy = true

	for _, spot in spots do
		showKeeper(spot, RollService.rollBeekeeper())
	end

	task.wait(ROLL_COOLDOWN)
	busy = false
end)
