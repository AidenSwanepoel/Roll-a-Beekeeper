local Util = {}

local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi" }

function Util.formatNumber(n: number): string
	local i = 1
	while n >= 1000 and i < #SUFFIXES do
		n /= 1000
		i += 1
	end
	if i == 1 then
		return tostring(math.floor(n))
	end
	return string.format("%.2f%s", n, SUFFIXES[i])
end

-- Pick one entry from `entries` where each entry's weight is `weightOf(entry)`.
function Util.weightedPick<T>(entries: { T }, weightOf: (T) -> number, rng: Random?): T
	local r = rng or Random.new()
	local total = 0
	for _, e in entries do
		total += weightOf(e)
	end
	local roll = r:NextNumber() * total
	for _, e in entries do
		roll -= weightOf(e)
		if roll <= 0 then
			return e
		end
	end
	return entries[#entries]
end

return Util
