-- Order matters: first entry is the most common, last is the rarest.
-- oneIn = "1 in N rolls".
return {
	{ name = "Common", oneIn = 1, color = Color3.fromRGB(120, 220, 90) },
	{ name = "Rare", oneIn = 4, color = Color3.fromRGB(70, 160, 255) },
	{ name = "Epic", oneIn = 22, color = Color3.fromRGB(185, 90, 255) },
	{ name = "Legendary", oneIn = 102, color = Color3.fromRGB(255, 190, 40) },
	{ name = "Mythical", oneIn = 247, color = Color3.fromRGB(255, 70, 70) },
}
