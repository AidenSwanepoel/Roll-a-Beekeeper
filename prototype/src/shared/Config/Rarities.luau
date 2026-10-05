-- Rarity ladder. Order matters: index 1 is the most common.
-- baseOdds is "1 in N rolls" for a plain roll with no luck. Epic/Legendary/Mythical
-- values come from the reference game's roll sign; the rest are [TUNE] placeholders.
return {
	{ name = "Common", color = Color3.fromRGB(120, 220, 90), oneIn = 1 },
	{ name = "Rare", color = Color3.fromRGB(70, 160, 255), oneIn = 4 },
	{ name = "Epic", color = Color3.fromRGB(185, 90, 255), oneIn = 22 },
	{ name = "Legendary", color = Color3.fromRGB(255, 190, 40), oneIn = 102 },
	{ name = "Mythical", color = Color3.fromRGB(255, 70, 70), oneIn = 247 },
	{ name = "Divine", color = Color3.fromRGB(255, 240, 160), oneIn = 1200 },
	{ name = "Hive Exclusive", color = Color3.fromRGB(40, 255, 220), oneIn = 6000 },
}
