local lib = LibStub:NewLibrary("LibCooldown", 1.0)
if not lib then return end

lib.startcalls = {}
lib.stopcalls = {}

function lib:RegisterCallback(event, func)
	assert(type(event)=="string" and type(func)=="function", "Usage: lib:RegisterCallback(event{string}, func{function})")
	if event=="start" then
		tinsert(lib.startcalls, func)
	elseif event=="stop" then
		tinsert(lib.stopcalls, func)
	else
		error("Argument 1 must be a string containing \"start\" or \"stop\"")
	end
end

local addon = CreateFrame("Frame")
local band = bit.band
local petflags = COMBATLOG_OBJECT_TYPE_PET
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local spells = {}
local items = {}
local watched = {}
local nextupdate, lastupdate = 0, 0

local function stop(id, class)
	watched[id] = nil

	for _, func in next, lib.stopcalls do
		func(id, class)
	end
end

local function update(self)
	for id, tab in next, watched do
		local duration = watched[id].dur - lastupdate
		if duration < 0 then
			stop(id, watched[id].class)
		else
			watched[id].dur = duration
			if nextupdate < 0 or duration < nextupdate then
				nextupdate = duration
			end
		end
	end
	lastupdate = 0
	
	if nextupdate < 0 then self:Hide() end
end

local function start(id, duration, class)
	update(addon)

	watched[id] = {
		["dur"] = duration,
		["class"] = class,
	}
	addon:Show()
	
	for _, func in next, lib.startcalls do
		func(id, duration, class)
	end
end

-- events --
function addon:SPELL_UPDATE_COOLDOWN()
	for id, tab in next, spells do
		local _, duration, enabled = GetSpellCooldown(tab.name)

		if enabled == 1 and duration > 3 then
			if not watched[id] then
				start(id, duration, tab.class)
			end
		elseif enabled == 1 and watched[id] and duration==0 then
			stop(id, tab.class)
		end
	end
end
function addon:BAG_UPDATE_COOLDOWN()
	for id, name in next, items do
		local _, duration, enabled = GetItemCooldown(id)
		if enabled == 1 and duration > 10 and not watched[id] then
			start(id, duration, "item")
		elseif duration==0 and enabled==1 and watched[id] then
			stop(id, "item")
		end
	end
end
function addon:UNIT_SPELLCAST_SUCCEEDED(unit, name, rank)
	if (unit == "player") then
		local link = GetSpellLink(name, rank) or ""
		local id = string.match(link, ":(%w+)")
		if not id then return end
		spells[id] = {
			["name"] = name,
			["class"] = "spell",
		}
	end
end
function addon:COMBAT_LOG_EVENT_UNFILTERED(_, event, _, _, sourceflags, _, _, _, id, name)
    if event == "SPELL_CAST_SUCCESS" then
        if band(sourceflags, petflags) == petflags and band(sourceflags, mine) == mine then
            spells[id] = {
				["name"] = name,
				["class"] = "pet",
			}
        end
    end
end
addon:BAG_UPDATE_COOLDOWN()
addon:SPELL_UPDATE_COOLDOWN()
addon:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
addon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
addon:RegisterEvent("BAG_UPDATE_COOLDOWN")
PetActionButton1:HookScript("OnShow", function() addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end)
PetActionButton1:HookScript("OnHide", function() addon:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end)
hooksecurefunc("UseAction", function(slot)
	local action, id = GetActionInfo(slot)
	if (action == "item") then
		items[id] = GetItemInfo(id)
	end
end)
hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id, name = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id then
		items[id] = name
	end
end)
hooksecurefunc("UseContainerItem", function(bag, slot)
	local link = GetContainerItemLink(bag, slot) or ""
	local id, name = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id then
		items[id] = name
	end
end)
local function onupdate(self, elapsed)
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then return end

	update(self)
end
addon:SetScript("OnUpdate", onupdate)
addon:Hide()