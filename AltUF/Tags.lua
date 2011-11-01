local _, ns = ...
oUF = ns.oUF or oUF

local format = string.format
local gsub = string.gsub

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

function utf8sub(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

-- Class color values
oUF.Tags['alt:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (u == "pet") and GetPetHappiness() then
		return hex(oUF.colors.happiness[GetPetHappiness()])
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['alt:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

 -- Lenght-name
 oUF.TagEvents['NameLong'] = "UNIT_NAME_UPDATE"
if (not oUF.Tags['NameLong']) then
	oUF.Tags['NameLong'] = function(unit)
		local name = UnitName(unit)
		return utf8sub(name, 13, true)
	end
end

oUF.TagEvents['NameShort'] = "UNIT_NAME_UPDATE"
if (not oUF.Tags['NameShort']) then
	oUF.Tags['NameShort'] = function(unit)
		local name = UnitName(unit)
		return utf8sub(name, 10, true)
	end
end

oUF.Tags['alt:DDG'] = function(u)
	if UnitIsDead(u) then
		return locale.dead
	elseif UnitIsGhost(u) then
		return locale.ghost
	elseif not UnitIsConnected(u) then
		return locale.udc
	end
end
oUF.TagEvents['alt:DDG'] = 'UNIT_HEALTH'

oUF.Tags["alt:afkdnd"] = function(unit) 
	
	return UnitIsAFK(unit) and locale.afk or UnitIsDND(unit) and locale.dnd or ""
end
oUF.TagEvents["alt:afkdnd"] = "PLAYER_FLAGS_CHANGED"