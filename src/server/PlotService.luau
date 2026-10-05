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
