local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local Util = require(Shared.Util)
local Beekeepers = require(Shared.Config.Beekeepers)
local Bees = require(Shared.Config.Bees)
local Mutations = require(Shared.Config.Mutations)

local nameOf, perSec, mutMult = {}, {}, {}
for _, k in Beekeepers do nameOf[k.id] = k end
for _, b in Bees do perSec[b.id] = b.perSecond end
for _, m in Mutations do mutMult[m.name] = m.multiplier end

local gui = Instance.new("ScreenGui")
gui.Name = "BeekeeperHud"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local function label(text, pos, color)
	local l = Instance.new("TextLabel")
	l.Size, l.Position = UDim2.fromOffset(220, 40), pos
	l.BackgroundTransparency = 1
	l.Font, l.TextSize, l.TextColor3 = Enum.Font.FredokaOne, 30, color
	l.TextStrokeTransparency = 0
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Text = text
	l.Parent = gui
	return l
end

local function button(text, pos, color, size)
	local b = Instance.new("TextButton")
	b.Size, b.Position = size or UDim2.fromOffset(150, 50), pos
	b.BackgroundColor3, b.Text = color, text
	b.Font, b.TextSize, b.TextColor3 = Enum.Font.FredokaOne, 26, Color3.new(1, 1, 1)
	b.Parent = gui
	return b
end

local money = label("0$", UDim2.new(0, 16, 1, -60), Color3.fromRGB(80, 255, 80))
local jelly = label("0", UDim2.new(0, 16, 1, -100), Color3.fromRGB(255, 220, 60))
local sell = button("Sell", UDim2.new(0.5, 4, 0, 10), Color3.fromRGB(220, 50, 50))
local place = button("Place Best", UDim2.new(0.5, -160, 0, 10), Color3.fromRGB(40, 150, 240))

local state
Remotes.StateChanged.OnClientEvent:Connect(function(s)
	state = s
	money.Text = Util.formatNumber(s.money) .. "$"
	jelly.Text = Util.formatNumber(s.jelly)
end)

sell.Activated:Connect(function() Remotes.SellAll:FireServer() end)

place.Activated:Connect(function()
	if not state then return end
	-- Put the best inventory bee on the first empty stand, or replace the weakest placed bee.
	local function value(bee) return (perSec[bee.id] or 0) * (mutMult[bee.mutation or "Normal"] or 1) end
	local bestIdx, bestVal = nil, -1
	for i, bee in state.inventory do
		if value(bee) > bestVal then bestIdx, bestVal = i, value(bee) end
	end
	if not bestIdx then return end
	local target, weakest = nil, math.huge
	for i, st in state.stands do
		local v = st.bee and value(st.bee) or -1
		if v < weakest then target, weakest = i, v end
	end
	if target and bestVal > weakest then Remotes.PlaceBee:FireServer(bestIdx, target) end
end)

-- Three-candidate roll picker.
local picker = Instance.new("Frame")
picker.Size, picker.Position = UDim2.fromOffset(560, 200), UDim2.new(0.5, -280, 0.5, -100)
picker.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
picker.Visible = false
picker.Parent = gui
local layout = Instance.new("UIListLayout")
layout.FillDirection, layout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 10)
layout.HorizontalAlignment, layout.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center
layout.Parent = picker

Remotes.RollOffer.OnClientEvent:Connect(function(ids)
	for _, c in picker:GetChildren() do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for i, id in ids do
		local k = nameOf[id]
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(170, 170)
		b.BackgroundColor3 = Color3.fromRGB(255, 190, 40)
		b.Font, b.TextSize, b.TextWrapped = Enum.Font.FredokaOne, 22, true
		b.Text = string.format("%s\n%s\nJar: %d", k.name, k.rarity, k.capacity)
		b.Parent = picker
		b.Activated:Connect(function()
			picker.Visible = false
			Remotes.PickBeekeeper:FireServer(i)
		end)
	end
	picker.Visible = true
end)
