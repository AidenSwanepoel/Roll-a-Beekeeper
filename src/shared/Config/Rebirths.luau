-- Tier 1 matches the reference screenshot (100K, x1.5 money, +30min offline, x3 roll luck,
-- +1 dock expansion, +1 slot, resets money only). Later costs follow the wiki (3.75M, 150M, 3B).
return {
	{ cost = 100_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 3_750_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 150_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 3_000_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 },
	{ cost = 100_000_000_000, moneyMult = 1.5, offlineMinutes = 30, rollLuck = 3, expansions = 1, slots = 1 }, -- [TUNE]
}
