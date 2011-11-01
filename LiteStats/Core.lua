----------------------------------------------------------------------------------------
--	LiteStats(by Katae)
----------------------------------------------------------------------------------------

local P = "player" -- Because I'm tired of typing it.
local realm, char, class, layout = GetRealmName(), UnitName(P), select(2, UnitClass(P)), {}

local tthead = {r=0.40, g=0.78, b=1.00} -- Headers
local ttsubh = {r=0.75, g=0.90, b=1.00} -- Subheaders

local strata, level = "HIGH", 10

local modules = LPSTAT_CONFIG
local profiles = LPSTAT_PROFILES
local font = LPSTAT_FONT
local t_icon = LTIPICONSIZE or 20
local allcombat = HIDE_IN_COMBAT
local IsAltKeyDown = IsAltKeyDown
local UpdateMemUse = UpdateAddOnMemoryUsage
local format = string.format
local strmatch = string.match
local strfind = string.find
local strtrim = strtrim
local unpack = unpack
local pairs = pairs
local ipairs = ipairs
local floor = math.floor
local select = select
local max = max
local gsub = gsub

-- Locale
local locale = LSTLOCALE or {}
local function L(str) return locale[str] or str end

-- Lazy Events Reg
local function RegEvents(f,l) for _,e in ipairs{strsplit(" ",l)} do f:RegisterEvent(e) end end

------------------------------------------
-- Saved Vars Init / Coords
local ls, coordX, coordY, conf, Coords = CreateFrame'frame', 0, 0, {}
RegEvents(ls,"ADDON_LOADED PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED")
ls:SetScript("OnEvent", function(_,event,addon)
	if event == "ADDON_LOADED" and addon == "LiteStats" then
		if not modules then
			-- Missing config, print an error message.
			print(format("|cffFFFFFFLite|cff44CCFFStats|cffFFFFFF: "..L"Copy %s to %s and restart.","|cffFF9912config_default.lua|r","|cffFF9912config.lua|r"))
			return
		end
		if not LPSTAT then LPSTAT = {} end
		if not LPSTAT[realm] then LPSTAT[realm] = {} end
		if not LPSTAT[realm][char] then LPSTAT[realm][char] = {} end
		conf = LPSTAT[realm][char]
		
		-- Migrating older saved vars, pre-0.9.8
		for charstr,config in pairs(LPSTAT) do
			if strmatch(charstr," %- ") then
				local char, realm = strmatch(charstr,"(.-) %- (.*)")
				if not LPSTAT[realm] then LPSTAT[realm] = {} end
				conf = config
				LPSTAT[charstr] = nil
			end
		end	
		-- true/false defaults for autosell and autorepair
		if conf.AutoSell == nil then conf.AutoSell = true end
		if conf.AutoRepair == nil then conf.AutoRepair = false end
	end
	if event == "ZONE_CHANGED_NEW_AREA" and not WorldMapFrame:IsShown() then
		SetMapToCurrentZone()
	end
	-- Combat fading
	if event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
		for n,t in pairs(modules) do
			if t.incombat or (allcombat and t.incombat ~= false) then
				if event == "PLAYER_REGEN_DISABLED" then UIFrameFadeOut(_G['LP_'..n].text,0.5,font.alpha or 1,0)
				else UIFrameFadeIn(_G['LP_'..n].text,0.5,0,font.alpha or 1) end
			end
		end
	end
end)
if modules and ((modules.Coords and modules.Coords.enabled) or (modules.Location and modules.Location.enabled)) then
	ls:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	ls:SetScript("OnUpdate", function() coordX, coordY = GetPlayerMapPosition(P) end)
	WorldMapFrame:HookScript("OnHide", SetMapToCurrentZone)
	function Coords() return format(modules.Coords and modules.Coords.fmt or "%d,%d", coordX*100, coordY*100) end
end

-- Set profile
if profiles then for _,p in ipairs{class,format("%s - %s",char,realm)} do
	if profiles[p] then for k,v in pairs(profiles[p]) do
		for _k,_v in pairs(v) do modules[k][_k] = _v end
	end end
end profiles = nil end

-- Config missing?
if not modules then return end

------------------------------------------
local function zsub(s,...) local t={...} for i=1,#t,2 do s=gsub(s,t[i],t[i+1]) end return s end

local function formatgold(style, amount)
	local gold, silver, copper = floor(amount * 0.0001), floor(mod(amount * 0.01, 100)), floor(mod(amount, 100))
	if style == 1 then
		return (gold > 0 and format("%s|cffffd700%s|r ",gold,GOLD_AMOUNT_SYMBOL) or "")
			.. (silver > 0 and format("%s|cffc7c7cf%s|r ",silver,SILVER_AMOUNT_SYMBOL) or "")
			.. ((copper > 0 or (gold == 0 and silver == 0)) and format("%s|cffeda55f%s|r",copper,COPPER_AMOUNT_SYMBOL) or "")
	elseif style == 2 or not style then	
		return format("%.1f|cffffd700%s|r", amount * 0.0001, GOLD_AMOUNT_SYMBOL)
	elseif style == 3 then
		return format("|cffffd700%s|r.|cffc7c7cf%s|r.|cffeda55f%s|r", gold, silver, copper)
	elseif style == 4 then
		return (gold > 0 and format(GOLD_AMOUNT_TEXTURE,gold,12,12) or "") .. (silver > 0 and format(SILVER_AMOUNT_TEXTURE,silver,12,12) or "")
		 	.. ((copper > 0 or (gold == 0 and silver == 0)) and format(COPPER_AMOUNT_TEXTURE,copper,12,12) or "") .. " "
	end
end

local function abbr(t,s) return t[s] or zsub(_G[strupper(s).."_ONELETTER_ABBR"],"%%d","","^%s*","") end
local function fmttime(sec,t)
	local t = t or {}
	local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
	local string = zsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," ","%s+"," ")
	string = strtrim(gsub(string,"([dhms])",{d=abbr(t,"day"),h=abbr(t,"hour"),m=abbr(t,"minute"),s=abbr(t,"second")})," ")
	return strmatch(string,"^%s*$") and "0"..abbr(t,"second") or string
end

function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1,g1,b1,r2,g2,b2 = select(seg*3+1,1,0,0,1,1,0,0,1,0,0,0,0) -- R -> Y -> G
	local r,g,b = r1+(r2-r1)*relperc,g1+(g2-g1)*relperc,b1+(b2-b1)*relperc
	return format("|cff%02x%02x%02x",r*255,g*255,b*255),r,g,b
end
					
local function HideTT(self) GameTooltip:Hide() self.hovered = false end

local function NewStat(name,stat)
	local m = modules[name]	
	for k,v in pairs{ -- retrieving config variables from LPSTAT_CONFIG
		--name = name, anchor_frame = m.anchor_frame,
		name = name, parent = m.anchor_frame,
		anchor_to = m.anchor_to, anchor_from = m.anchor_from,
		x_off = m.x_off, y_off = m.y_off,
		height = m.height, width = m.width,
		strata = strata, level = level
	} do if not stat[k] then stat[k] = v end end
	if not stat.text then stat.text = {} end
	-- retrieve font variables and insert them into text table
	for k,v in pairs(font) do if not stat.text[k] then stat.text[k] = v end end
	if stat.OnEnter then if stat.OnLeave then hooksecurefunc(stat,"OnLeave",HideTT) else stat.OnLeave = HideTT end end
	tinsert(layout, stat)
end

local pxpx = {height=1,width=1}
local function blank(module)
	-- A fix for anchoring to disabled modules.
	-- If text alignment is off by 1px, this is why.
	NewStat(module,pxpx)
	modules[module] = nil
end

local function AltUpdate(self)
	if not self.hovered then return end
	if IsAltKeyDown() and not self.altdown then self.altdown = true self:GetScript("OnEnter")(self)
	elseif not IsAltKeyDown() and self.altdown then self.altdown = false self:GetScript("OnEnter")(self) end
end

------------------------------------------
--  FPS
if not modules.FPS.enabled then blank'FPS' else
	NewStat("FPS", {
		text = { string = function() return format(modules.FPS.fmt, floor(GetFramerate())) end }
	})
end
------------------------------------------
--  Latency
if not modules.Latency.enabled then blank'Latency' else
	NewStat("Latency", {
		text = {
			string = function()
				local lat,r = select(3,GetNetStats()),750
				return format(gsub(modules.Latency.fmt,"%[color%]",(gradient(1-lat/r))),lat)
			end
		}
	})
end
------------------------------------------
--  Memory
if not modules.Memory.enabled then blank'Memory' else
	local function sortdesc(a, b) return a[2] > b[2] end	
	local function formatmem(val,dec)
		return format(format("%%.%df %s",dec or 1,val > 1024 and "MB" or "KB"),val/(val > 1024 and 1024 or 1))
	end
	local memory = {}
	NewStat("Memory", {
		text = {
			string = function(self)
				self.total = 0
				UpdateMemUse()
				local parent = self:GetParent()
				for i = 1, GetNumAddOns() do self.total = self.total + GetAddOnMemoryUsage(i) end
				if parent.hovered then self:GetParent():GetScript("OnEnter")(parent) end
				return self.total >= 1024 and format(modules.Memory.fmt_mb, self.total / 1024) or format(modules.Memory.fmt_kb, self.total)
			end, update = 5,
		},
		OnEnter = function(self)
			collectgarbage()
			self.hovered = true
			GameTooltip:SetOwner(self, modules.Memory.tip_anchor, modules.Memory.tip_x, modules.Memory.tip_y)
			GameTooltip:ClearLines()
			local lat,r = select(3,GetNetStats()),750
			GameTooltip:AddDoubleLine(
				format("|cffffffff%s|r %s, %s%s|r %s",floor(GetFramerate()),FPS_ABBR,gradient(1-lat/r),lat,MILLISECONDS_ABBR),
				format("%s: |cffffffff%s",ADDONS,formatmem(self.text.total)),
				tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
			GameTooltip:AddLine' '
			if modules.Memory.max_addons ~= 0 or IsAltKeyDown() then
				if not self.timer or self.timer + 5 < time() then
					self.timer = time()
					UpdateMemUse()
					for i = 1, #memory do memory[i] = nil end
					for i = 1, GetNumAddOns() do
						local addon, name = GetAddOnInfo(i)
						if IsAddOnLoaded(i) then tinsert(memory,{name or addon, GetAddOnMemoryUsage(i)}) end
					end
					table.sort(memory, sortdesc)
				end
				local exmem = 0
				for i,t in ipairs(memory) do
					if modules.Memory.max_addons and i > modules.Memory.max_addons and not IsAltKeyDown() then
						exmem = exmem + t[2]
					else
						local color = t[2] <= 102.4 and {0,1} -- 0 - 100
							or t[2] <= 512 and {0.75,1} -- 100 - 512
							or t[2] <= 1024 and {1,1} -- 512 - 1mb
							or t[2] <= 2560 and {1,0.75} -- 1mb - 2.5mb
							or t[2] <= 5120 and {1,0.5} -- 2.5mb - 5mb
							or {1,0.1} -- 5mb +
						GameTooltip:AddDoubleLine(t[1],formatmem(t[2]),1,1,1,color[1],color[2],0)
					end
				end
				if exmem > 0 and not IsAltKeyDown() then
					local more = #memory - modules.Memory.max_addons
					GameTooltip:AddDoubleLine(format("%d %s (%s)",more,L"Hidden",L"ALT"),formatmem(exmem),ttsubh.r,ttsubh.g,ttsubh.b,ttsubh.r,ttsubh.g,ttsubh.b)
				end
				GameTooltip:AddDoubleLine(" ","--------------",1,1,1,0.5,0.5,0.5)
			end
			GameTooltip:AddDoubleLine(L"Default UI Memory Usage"..":",formatmem(gcinfo() - self.text.total),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
			GameTooltip:AddDoubleLine(L"Total Memory Usage"..":",formatmem(collectgarbage'count'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
	        GameTooltip:Show()
		end,
		--OnUpdate = AltUpdate,
		OnLeave = function(self) self.hovered = false end,
		OnClick = function(self, button)
			if button == "RightButton" then 
				UpdateMemUse()
				local before = gcinfo()
				collectgarbage()
				UpdateMemUse()
				self.timer, self.text.elapsed = nil, 5
				self:GetScript("OnEnter")(self)
			end
		end
	})
end
------------------------------------------
--  Durability
if not modules.Durability.enabled then blank'Durability' else
	NewStat("Durability", {
		OnLoad = function(self)
			CreateFrame("GameTooltip", "LPDURA")
			LPDURA:SetOwner(WorldFrame,"ANCHOR_NONE")
			if modules.Durability.man then DurabilityFrame.Show = DurabilityFrame.Hide end
			RegEvents(self,"UPDATE_INVENTORY_DURABILITY MERCHANT_SHOW PLAYER_LOGIN")
		end,
		OnEvent = function(self, event, ...)
			if event == "UPDATE_INVENTORY_DURABILITY" or event == "PLAYER_LOGIN" then
				local durability = 100
				for id = 1, 18 do
			        local dur, dmax = GetInventoryItemDurability(id)
					if dur ~= dmax then durability = floor(min(durability,dur/dmax*100)) end
				end
				self.text:SetText(format(gsub(modules.Durability.fmt,"%[color%]",(gradient(durability/100))), durability))
			elseif event == "MERCHANT_SHOW" and not IsAltKeyDown() then
				if conf.AutoRepair and CanMerchantRepair() then
			        local cost, total = GetRepairAllCost(), 0
			        if cost > 0 then
						if modules.Durability.gfunds and CanGuildBankRepair() then RepairAllItems(1) total = cost end
						if GetRepairAllCost() > 0 then
							if not modules.Durability.ignore_inventory and GetRepairAllCost() <= GetMoney() then
								total = GetRepairAllCost(); RepairAllItems()
							else
								for id = 1, 18 do
									local cost = select(3,LPDURA:SetInventoryItem(P,id))
									if cost ~= 0 and cost <= GetMoney() then
										if not InRepairMode() then ShowRepairCursor() end
										PickupInventoryItem(id)
										total = total + cost
									end
								end
							end
							HideRepairCursor()
						end
						if total > 0 then print(format("|cff66C6FF%s |cffFFFFFF%s",REPAIR_COST,formatgold(1, total))) end
					end
			    end
			end
		end,
		OnEnter = function(self)
			GameTooltip:SetOwner(self, modules.Durability.tip_anchor, modules.Durability.tip_x, modules.Durability.tip_y)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(DURABILITY,tthead.r,tthead.g,tthead.b)
			GameTooltip:AddLine' '
			local nodur, totalcost = true, 0
			for slot, string in gmatch("1HEAD3SHOULDER5CHEST6WAIST7LEGS8FEET9WRIST10HANDS16MAINHAND17SECONDARYHAND18RANGED","(%d+)([^%d]+)") do
				local dur, dmax = GetInventoryItemDurability(slot)
				local string = _G[string.."SLOT"]
				if dur ~= dmax then
					local perc = dur ~= 0 and dur/dmax or 0
					local hex = gradient(perc)
					GameTooltip:AddDoubleLine(modules.Durability.gear_icons and format("|T%s:%d|t %s",GetInventoryItemTexture(P,slot),t_icon,string) or string,format("|cffaaaaaa%s/%s | %s%s%%",dur,dmax,hex,floor(perc*100)),1,1,1)
					totalcost, nodur = totalcost + select(3,LPDURA:SetInventoryItem(P,slot))
				end
			end
			if nodur then
				GameTooltip:AddLine("100%",0.1,1,0.1)
			else
				GameTooltip:AddDoubleLine(" ","--------------",1,1,1,0.5,0.5,0.5)
				GameTooltip:AddDoubleLine(REPAIR_COST, formatgold(1, totalcost),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)	
			end
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(" ",L"AutoRepair"..": "..(conf.AutoRepair and "|cff55ff55"..L"ON" or "|cffff5555"..strupper(OFF)),1,1,1,ttsubh.r,ttsubh.g,ttsubh.b)
			GameTooltip:Show()
		end,
		OnClick = function(self, button)
			if button == "RightButton" then
				conf.AutoRepair = not conf.AutoRepair
				self:GetScript("OnEnter")(self)
			elseif GetCVarBool'equipmentManager' and ((button == "LeftButton" and IsShiftKeyDown()) or button == "MiddleButton") then
				local menulist = {{ isTitle=true, text=format(gsub(EQUIPMENT_SETS,":",""),"") }}
				if GetNumEquipmentSets() == 0 then
					tinsert(menulist, {text = NONE, disabled = true})
				else
					for i = 1, GetNumEquipmentSets() do
						local name, icon = GetEquipmentSetInfo(i)
						tinsert(menulist, {text = format("|T%s:%s|t %s",icon,t_icon+5,name), func = function() UseEquipmentSet(name) end})
					end
				end
				EasyMenu(menulist, LSMenus, "cursor", 0, 0, "MENU")
			elseif button == "LeftButton" then
				ToggleCharacter'PaperDollFrame'
			end
		end
	})
end
------------------------------------------
--	Guild
if not modules.Guild.enabled then blank'Guild' else
	hooksecurefunc("SortGuildRoster", function(type) CURRENT_GUILD_SORTING = type end)
	NewStat("Guild", {
		text = {
			string = function()
				if IsInGuild() then
					local online, total = 0, GetNumGuildMembers(true)
					for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end
					return format(modules.Guild.fmt, online, total)
				else return format("%s %s",NO,GUILD) end
			end, update = 5
		},
		OnLoad = function(self)
			GuildRoster()
			SortGuildRoster(modules.Guild.sorting == "note" and "rank" or "note")
			SortGuildRoster(modules.Guild.sorting)
			self:RegisterEvent'PARTY_MEMBERS_CHANGED'
		end,
		OnEvent = function(self) if self.hovered then self:GetScript("OnEnter")(self) end end,
		OnUpdate = function(self,u)
			if IsInGuild() then
				AltUpdate(self)
				if not self.gmotd then
					-- Give me the GMOTD *today* pls.
					if self.elapsed > 1 then GuildRoster(); self.elapsed = 0 end
				 	if GetGuildRosterMOTD() ~= '' then self.gmotd = true; if self.hovered then self:GetScript("OnEnter")(self) end end
					self.elapsed = self.elapsed + u
				end
			end
		end,
		OnClick = function(self,b)
			if b == "LeftButton" then
				ToggleFriendsFrame(3)
			elseif b == "RightButton" then
				local s = CURRENT_GUILD_SORTING
				SortGuildRoster(IsShiftKeyDown() and s or (IsAltKeyDown() and (s == "rank" and "note" or "rank") or s == "class" and "name" or s == "name" and "level" or s == "level" and "zone" or "class"))
				self:GetScript("OnEnter")(self)
			end
		end,
		OnEnter = function(self)
			if IsInGuild() then
				self.hovered = true
				GuildRoster()
				local name, rank, level, zone, note, officernote, connected, status, class, zone_r, zone_g, zone_b, classc, levelc, grouped
				local online, total, gmotd = 0, GetNumGuildMembers(true), GetGuildRosterMOTD()
				for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end
				
				GameTooltip:SetOwner(self, modules.Guild.tip_anchor, modules.Guild.tip_x, modules.Guild.tip_y)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(GetGuildInfo(P),format("%s: %d/%d",GUILD_ONLINE_LABEL,online,total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				if gmotd ~= "" then GameTooltip:AddLine(format("  %s |cffaaaaaa- |cffffffff%s",GUILD_MOTD,gmotd),ttsubh.r,ttsubh.g,ttsubh.b,1) end
				if modules.Guild.maxguild ~= 0 and online > 1 then
					GameTooltip:AddLine' '
					for i = 1, total do
						if modules.Guild.maxguild and i > modules.Guild.maxguild then
							if online > 2 then GameTooltip:AddLine(format("%d %s (%s)",online - modules.Guild.maxguild,L"Hidden",L"ALT"),ttsubh.r,ttsubh.g,ttsubh.b) end
							break
						end
						-- name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName
						name, rank, _, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
						if connected and level >= modules.Guild.threshold and name ~= UnitName(P) then
							if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
							grouped = (UnitInParty(name) or UnitInRaid(name)) and (GetRealZoneText() == zone and " |cff7fff00*|r" or " |cffff7f00*|r") or ""
							if self.altdown then
								GameTooltip:AddDoubleLine(format("%s%s |cff999999- |cffffffff%s",grouped,name,rank),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
								if note ~= "" then GameTooltip:AddLine('  "'..note..'"',ttsubh.r,ttsubh.g,ttsubh.b,1) end
								if officernote ~= "" then GameTooltip:AddLine("  o: "..officernote,0.3,1,0.3,1) end
							else
								GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,(status~="" and " "..status or ""),grouped),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
							end
						end
					end
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine(" ",format("%s %s",L"Sorting by",CURRENT_GUILD_SORTING),1,1,1,ttsubh.r,ttsubh.g,ttsubh.b)
				end
				GameTooltip:Show()
			end
		end
	})
end
------------------------------------------
--	Friends
if not modules.Friends.enabled then blank'Friends' else
	NewStat("Friends", {
		OnLoad = function(self) RegEvents(self,"PLAYER_LOGIN FRIENDLIST_UPDATE PARTY_MEMBERS_CHANGED BN_FRIEND_ACCOUNT_ONLINE BN_FRIEND_ACCOUNT_OFFLINE BN_FRIEND_INVITE_ADDED BN_FRIEND_INVITE_REMOVED") end,
		OnEvent = function(self, event)
			if event ~= "PARTY_MEMBERS_CHANGED" then
				local online, total = 0, GetNumFriends()
				local BNonline, BNtotal = 0, BNGetNumFriends()
				for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
				if BNtotal > 0 then
					for i = 1, BNtotal do if select(7, BNGetFriendInfo(i)) then BNonline = BNonline + 1 end end
				end
				local totalonline = online + BNonline
				self.text:SetText(format(modules.Friends.fmt, totalonline, total + BNtotal))
			end
			if self.hovered then self:GetScript("OnEnter")(self) end
		end,
		OnUpdate = AltUpdate,
		OnClick = function(_,b) (b=="RightButton" and ToggleIgnorePanel or ToggleFriendsPanel)() end,
		OnEnter = function(self)
			ShowFriends()
			self.hovered = true
			local online, total = 0, GetNumFriends()
			local name, level, class, zone, connected, status, note, classc, levelc, zone_r, zone_g, zone_b, grouped
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
			local BNonline, BNtotal = 0, BNGetNumFriends()
			local presenceID, givenName, surname, toonName, toonID, client, isOnline
			if BNtotal > 0 then
				for i = 1, BNtotal do if select(7, BNGetFriendInfo(i)) then BNonline = BNonline + 1 end end
			end
			local totalonline = online + BNonline
			local totalfriends = total + BNtotal
			if online > 0 or BNonline > 0 then
				GameTooltip:SetOwner(self, modules.Friends.tip_anchor, modules.Friends.tip_x, modules.Friends.tip_y)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(FRIENDS_LIST, format("%s: %s/%s",GUILD_ONLINE_LABEL,totalonline,totalfriends),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				if online > 0 then
					GameTooltip:AddLine' '
					GameTooltip:AddLine("World of Warcraft")
					-- name, level, class, area, connected, status, note
					for i = 1, total do
						name, level, class, zone, connected, status, note = GetFriendInfo(i)
						if not connected then break end
						if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
						for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
						if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
							for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
						end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
						grouped = (UnitInParty(name) or UnitInRaid(name)) and (GetRealZoneText() == zone and " |cff7fff00*|r" or " |cffff7f00*|r") or ""
						GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,grouped," "..status),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
						if self.altdown and note then GameTooltip:AddLine("  "..note,ttsubh.r,ttsubh.g,ttsubh.b,1) end
					end
				end
				if BNonline > 0 then
					GameTooltip:AddLine' '
					GameTooltip:AddLine("Battle.Net")
					for i = 1, BNtotal do
						presenceID, givenName, surname, toonName, toonID, client, isOnline = BNGetFriendInfo(i)
						if not isOnline then break end
						if toonID then
							local hasFocus, toonName, client, realmName, faction, race, class, guild, zoneName, level= BNGetToonInfo(toonID)
							GameTooltip:AddDoubleLine("|cffeeeeee"..client.." ("..level.." "..toonName..")|r", "|cffeeeeee"..givenName.." "..surname.."|r")
						else
							GameTooltip:AddDoubleLine("|cffeeeeee"..client..")|r", "|cffeeeeee"..givenName.." "..surname.."|r")
						end
					end
				end
				GameTooltip:Show()
			else HideTT(self) end
		end
	})
end
------------------------------------------
--  Talents
if not modules.Talents.enabled then blank'Talents' else
	local timer = 0
	if modules.Talents.nospam then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_,_,msg)
			if timer > GetTime() - 8 then
				if strfind(msg, gsub(ERR_LEARN_ABILITY_S,'%%s','(.*)')) then return true end
				if strfind(msg, gsub(ERR_LEARN_SPELL_S,'%%s','(.*)')) then return true end
				if strfind(msg, gsub(ERR_SPELL_UNLEARNED_S,'%%s','(.*)')) then return true end
			end
		end)
	end
	NewStat("Talents", { -- height = 11,
		OnLoad = function(self)
			RegEvents(self,"PLAYER_LOGIN PLAYER_TALENT_UPDATE CHARACTER_POINTS_CHANGED PLAYER_ENTERING_WORLD PLAYER_LEAVING_WORLD")
			if modules.Talents.nospam then self:RegisterEvent'UNIT_SPELLCAST_START' end
		end,
		OnEvent = function(self, event, ...)
			if event == "PLAYER_ENTERING_WORLD" then
				self:RegisterEvent'PLAYER_TALENT_UPDATE'
			elseif event == "PLAYER_LEAVING_WORLD" then
				self:UnregisterEvent'PLAYER_TALENT_UPDATE'
			elseif event == "UNIT_SPELLCAST_START" then
				local unit, spell = ...
				if unit == P and (spell == GetSpellInfo(63645) or spell == GetSpellInfo(63644)) then timer = GetTime() end
			else
				if UnitLevel(P) < 10 then
					self.text:SetText(format("%s %s",NO,TALENTS))
				elseif GetNumTalentTabs() == 3 then
					self.talents = {}
					self.unspent = UnitCharacterPoints(P)
					for i = 1, GetNumTalentGroups() do
						tinsert(self.talents, {})
						local tal, pts, icon, name = self.talents[i], -1
						for tree = 1, GetNumTalentTabs() do
							tinsert(tal, {GetTalentTabInfo(tree,nil,nil,i)})
							if tal[tree][3] ~= 0 and tal[tree][3] > pts then
								name, icon, pts = {tal[tree][1],tree}, tal[tree][2], tal[tree][3]
							end
						end
						if not name then name, icon = {format("%s %s",NO,TALENTS)}, "Interface\\Icons\\INV_Misc_QuestionMark" end
						tinsert(tal, name)
						if i == GetActiveTalentGroup() then
						
							self.text:SetText(zsub(modules.Talents.fmt,"%[(.-)%]", {
								name = name[1], shortname = gsub(name[1],".*",modules.Talents.name_subs),
								icon = format("|T%s:%d|t",icon,modules.Talents.iconsize),
								unspent = self.unspent > 0 and format("|cff55ff55+"..self.unspent) or ''
							},"%[spec(.-)%]", function(spec)
								return format(spec == '' and "%d/%d/%d" or gsub(spec,'^ ',''),tal[1][3],tal[2][3],tal[3][3])
							end,' $',''))
							tinsert(tal, 1)
						end
					end
					if self.hovered then self:GetScript("OnEnter")(self) end
				end
			end
		end,
		OnUpdate = function(self)
			if GetNumTalentTabs() == 3 then
				self:SetScript("OnUpdate",nil)
				self:GetScript("OnEvent")(self)
			end
		end,
		OnEnter = function(self)
			self.hovered = true
			if UnitLevel(P) >= 10 then
				GameTooltip:SetOwner(self, modules.Talents.tip_anchor, modules.Talents.tip_x, modules.Talents.tip_y)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(TALENTS,self.unspent > 0 and format("%d %s",self.unspent,UNUSED) or '',tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				for i = 1, GetNumTalentGroups() do
					local tal = self.talents[i]
					local tree = tal[4][2]
					local name, icon, talents = tree and tal[tree][1] or NONE, tree and tal[tree][2] or "Interface\\Icons\\INV_Misc_QuestionMark", format("%d/%d/%d",tal[1][3],tal[2][3],tal[3][3])
					if tal[5] then r,g,b = 0.3,1,0.3 else r,g,b = 0.5,0.5,0.5 end
					GameTooltip:AddDoubleLine(format("|T%s:%d|t %s %s",icon,t_icon,gsub(name,".*",modules.Talents.name_subs),talents), i==1 and PRIMARY or SECONDARY,1,1,1,r,g,b)
				end
				GameTooltip:Show()
			end
		end,
		OnLeave = function(self) self.hovered = false end,
		OnClick = function(_,b)
			if b == "RightButton" and GetNumTalentGroups() > 1 then
				SetActiveTalentGroup(3 - GetActiveTalentGroup())
			elseif b == "LeftButton" then
				ToggleTalentFrame()
			end
		end
	})
end
------------------------------------------
--	Character Stats
if not modules.Stats.enabled then blank'Stats' else
	local function tags(sub)
		local percent, string = true
		if sub == "ap" then
			local base, pos, neg = UnitAttackPower(P)
			string, percent = base + neg + pos
		elseif sub == "rangedap" then		
			local base, pos, neg = UnitRangedAttackPower(P)
			string, percent = base + neg + pos
		elseif sub == "armorpen" then
			string = GetArmorPenetration()
		elseif sub == "expertise" then
			string = GetExpertisePercent()
		elseif strmatch(sub,"hit$") then
			local var = _G["CR_HIT_"..(strupper(strmatch(sub,"(%w-)hit$")) or "")]
			string, percent = var and GetCombatRatingBonus(var) or format("[%s]",sub), var
		elseif strmatch(sub,"haste$") then
			local var = _G["CR_HASTE_"..(strupper(strmatch(sub,"(%w-)haste$")) or "")]
			string, percent = var and GetCombatRatingBonus(var) or format("[%s]",sub), var
		elseif sub == "resilience" then
			string, percent = max(GetCombatRating(CR_CRIT_TAKEN_MELEE), GetCombatRating(CR_CRIT_TAKEN_RANGED), GetCombatRating(CR_CRIT_TAKEN_SPELL))
		elseif sub == "meleecrit" then
			string = GetCritChance()
		elseif sub == "rangedcrit" then
			string = GetRangedCritChance()
		elseif sub == "spellcrit" then
			local rate = 0
			for i = 1, 7 do rate = max(rate, GetSpellCritChance(i)) end
			string = rate
		elseif sub == "spellpower" then
			local power = 0
			for i = 1, 7 do power = max(power, GetSpellBonusDamage(i)) end
			string, percent = power
		elseif sub == "healing" then
			string, percent = GetSpellBonusHealing()
		elseif sub == "spellpen" then
			string, percent = GetSpellPenetration()
		elseif sub == "dodge" then
			string = GetDodgeChance()
		elseif sub == "parry" then
			string = GetParryChance()
		elseif sub == "block" then
			string = GetBlockChance()
		elseif sub == "defense" then
			local base, add = UnitDefense(P)
			string, percent = base + add
		elseif sub == "avoidance" then
			string = GetDodgeChance() + GetParryChance() + GetBlockChance()
		elseif sub == "manaregen" then
			local _,class = UnitClass(P)
			local I5SR = true -- oo5sr/i5sr swapping NYI
			if class == "ROGUE" or class == "WARRIOR" or class == "DEATHKNIGHT" then
				string, percent = "??"
			else
				local base, cast = GetManaRegen()
				string, percent = floor((I5SR and cast or base) * 5)
			end
		elseif sub == "armor" then
			local _,eff = UnitArmor(P)
			string, percent = eff
		else
			string, percent = format("[%s]",sub)
		end
		if not percent then return string end
		return format("%.1f", string)
	end
	NewStat("Stats", {
		OnLoad = function(self)
			RegEvents(self,"PLAYER_LOGIN UNIT_STATS UNIT_DAMAGE UNIT_RANGEDDAMAGE PLAYER_DAMAGE_DONE_MODS UNIT_ATTACK_SPEED UNIT_ATTACK_POWER UNIT_RANGED_ATTACK_POWER")
		end,
		OnEvent = function(self) self.fired = true end,
		OnUpdate = function(self, u)
			self.elapsed = self.elapsed + u
			if self.fired and self.elapsed > 2.5 then
				self.text:SetText(gsub(modules.Stats[format("spec%dfmt",GetActiveTalentGroup())], "%[(%w-)%]", tags))
				self.elapsed, self.fired = 0, false
			end
		end
	})
end

------------------------------------------
--	Experience/Played/Rep
if not modules.Experience.enabled then blank'Experience' else
	local logintime, playedtotal, playedlevel, playedmsg, gained, lastkill, lastquest = GetTime(), 0, 0, 0, 0
	local repname, repcolor, standingname, currep, minrep, maxrep, reppercent
	local mobxp = gsub(COMBATLOG_XPGAIN_FIRSTPERSON,"%%[sd]","(.*)")
	local questxp = gsub(COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED,"%%[sd]","(.*)")
	local function short(num,tt)
		if short or tt then
			num = tonumber(num)
			if num >= 1000000 then
				return gsub(format("%.1f%s", num/1000000, modules.Experience.million or 'm'),"%.0","")
			elseif num >= 1000 then
				return gsub(format("%.1f%s", num/1000, modules.Experience.thousand or 'k'),"%.0","")
			end
		end
		return floor(tonumber(num))
	end
	local function tags(sub,tt)
		local t = modules.Experience
			-- exp tags
		return sub == "level" and UnitLevel(P)
			or sub == "curxp" and short(UnitXP(P),tt)
			or sub == "remainingxp" and short(UnitXPMax(P) - UnitXP(P),tt)
			or sub == "totalxp" and short(UnitXPMax(P),tt)
			or sub == "cur%" and floor(UnitXP(P) / UnitXPMax(P) * 100)
			or sub == "remaining%" and 100 - floor(UnitXP(P) / UnitXPMax(P) * 100)
			or sub == "restxp" and short(GetXPExhaustion() or 0,tt)
			or sub == "rest%" and min(150, floor((GetXPExhaustion() or 0) / UnitXPMax(P) * 100))
			or sub == "sessiongained" and short(gained,tt)
			or sub == "sessionrate" and short(gained / (GetTime() - playedmsg) * 3600,tt)
			or sub == "levelrate" and short(UnitXP(P) / (playedlevel + GetTime() - playedmsg) * 3600,tt)
	 		or sub == "sessionttl" and (gained ~= 0 and fmttime((UnitXPMax(P) - UnitXP(P)) / (gained / (GetTime() - playedmsg)),t) or L"inf")
			or sub == "levelttl" and (UnitXP(P) ~= 0 and fmttime((UnitXPMax(P) - UnitXP(P)) / (UnitXP(P) / (playedlevel + GetTime() - playedmsg)),t) or L"inf")
			or sub == "questsleft" and (lastquest and ceil((UnitXPMax(P) - UnitXP(P)) / lastquest) or "??")
			or sub == "killsleft" and (lastkill and ceil((UnitXPMax(P) - UnitXP(P)) / lastkill) or "??")
			-- time played tags
			or sub == "playedtotal" and fmttime(playedtotal + GetTime() - playedmsg,t)
			or sub == "playedlevel" and fmttime(playedlevel + GetTime() - playedmsg,t)
			or sub == "playedsession" and fmttime(GetTime() - logintime,t)
			-- rep tags
			or sub == "repname" and (t.faction_subs[repname] or repname)
			or sub == "repcolor" and "|cff"..repcolor
			or sub == "standing" and standingname
			or sub == "currep" and abs(currep-minrep)
			or sub == "repleft" and abs(maxrep-currep)
			or sub == "maxrep" and abs(maxrep-minrep)
			or sub == "rep%" and floor(abs(currep-minrep) / abs(maxrep-minrep) * 100)
			or format("[%s]",sub)
	end
	NewStat("Experience", {
		text = {
			string = function(self)
				if conf.ExpMode == "rep" then
					return self:GetText()
				elseif conf.ExpMode == "played" then
					return gsub(modules.Experience.played_fmt,"%[([%w%%]-)%]",tags)
				elseif conf.ExpMode == "xp" then
					return gsub(modules.Experience[format("xp_%s_fmt",(GetXPExhaustion() or 0) > 0 and "rested" or "normal")],"%[([%w%%]-)%]",tags) or " "
				end
			end
		},
		OnLoad = function(self)
			RegEvents(self,"TIME_PLAYED_MSG PLAYER_LOGOUT PLAYER_LOGIN UPDATE_FACTION CHAT_MSG_COMBAT_XP_GAIN PLAYER_LEVEL_UP")
			-- Filter first time played message.
			local ofunc = ChatFrame_DisplayTimePlayed
			function ChatFrame_DisplayTimePlayed() ChatFrame_DisplayTimePlayed = ofunc end
			RequestTimePlayed()
			if not conf.ExpMode or conf.ExpMode == "xp" then
				conf.ExpMode = UnitLevel(P) ~= MAX_PLAYER_LEVEL and "xp" or "played"
			end
		end,
		OnEvent = function(self, event, ...)
			if event == "CHAT_MSG_COMBAT_XP_GAIN" then
				local msg = ...
				if msg:find(mobxp) then
					_, lastkill = strmatch(msg,mobxp)
					gained = gained + lastkill
				elseif msg:find(questxp) then
					lastquest = strmatch(msg,questxp)
					gained = gained + lastquest
				end
			elseif event == "PLAYER_LEVEL_UP" then
				playedlevel, playedmsg = 0, GetTime()
			elseif event == "TIME_PLAYED_MSG" then
				playedtotal, playedlevel = ...
				playedmsg = GetTime()
			elseif (event == "UPDATE_FACTION" or event == "PLAYER_LOGIN") and conf.ExpMode == "rep" then
				local standing
				repname, standing, minrep, maxrep, currep = GetWatchedFactionInfo()				
				if not repname then repname = NONE end
				local color = {}
				if standing == 0 then
					color.r, color.g, color.b = GetItemQualityColor(0)
				elseif standing == 7 then
					color.r, color.g, color.b = GetItemQualityColor(3)
				elseif standing == 8 then
					color.r, color.g, color.b = GetItemQualityColor(4)
				else
					color = FACTION_BAR_COLORS[standing]
				end
				standingname = _G[format("FACTION_STANDING_LABEL%s%s",standing,UnitSex(P) == 3 and "_FEMALE" or "")]
				if not standingname then standingname = UNKNOWN end
				repcolor = format("%02x%02x%02x", min(color.r*255+40,255), min(color.g*255+40,255), min(color.b*255+40,255))
				self.text:SetText(gsub(modules.Experience.faction_fmt,"%[([%w%%]-)%]",tags))
			end
			if event == "PLAYER_LOGOUT" or event == "TIME_PLAYED_MSG" then
				conf.Played = floor(playedtotal + GetTime() - playedmsg)
			end
		end,
		OnEnter = function(self)
			self.hovered = true
			GameTooltip:SetOwner(self, modules.Experience.tip_anchor, modules.Experience.tip_x, modules.Experience.tip_y)
			GameTooltip:ClearLines()
			if conf.ExpMode == "played" then
				GameTooltip:AddLine(TIME_PLAYED_MSG,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(L"Played this session",tags("playedsession",1),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(L"Played this level",tags("playedlevel",1),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddLine' '
				GameTooltip:AddLine(L"Account Played",ttsubh.r,ttsubh.g,ttsubh.b)				
				local total = 0
				for realm, t in pairs(LPSTAT) do
					for name, conf in pairs(t) do
						if conf.Played then
							local r,g,b,player = 1,1,1
							if name == UnitName(P) and realm == GetRealmName() then
								conf.Played,player,r,g,b = floor(playedtotal+GetTime()-playedmsg),true,0.5,1,0.5
							end
							if conf.Played > 3600 or player then -- 1hr threshold displayed
								GameTooltip:AddDoubleLine(format("%s-%s",name,realm), fmttime(conf.Played),r,g,b,1,1,1)
							end
							total = total + conf.Played
						end
					end
				end				
				GameTooltip:AddDoubleLine(" ","------------------",1,1,1,0.5,0.5,0.5)
				GameTooltip:AddDoubleLine(L"Total",fmttime(total),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
			elseif conf.ExpMode == "xp" then
				GameTooltip:AddDoubleLine(COMBAT_XP_GAIN,format(LEVEL_GAINED,UnitLevel(P)),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(L"Current/Max XP",format("%s/%s (%s%%)",tags'curxp',tags'totalxp',tags'cur%'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(L"Remaining XP",format("%s (%s%%)",tags'remainingxp',tags'remaining%'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				if GetXPExhaustion() and GetXPExhaustion() ~= 0 then
					GameTooltip:AddDoubleLine(L"Rested XP",format("%s (%s%%)",tags'restxp',tags'rest%'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				end
				GameTooltip:AddLine' '				
				GameTooltip:AddDoubleLine(L"Session XP rate",format("%s/%s (%s)",tags'sessionrate',L"hr",tags'sessionttl'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(L"Level XP rate",format("%s/%s (%s)",tags'levelrate',L"hr",tags'levelttl'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(format(L"Quests/Kills to %s",UnitLevel(P)+1), format("%s:%s %s:%s",L"Q",tags'questsleft',L"K",tags'killsleft'),ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(L"Played this session",tags'playedsession',ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(L"Played this level",tags'playedlevel',ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
				GameTooltip:AddDoubleLine(L"Played total",tags'playedtotal',ttsubh.r,ttsubh.g,ttsubh.b,1,1,1)
			elseif conf.ExpMode == "rep" then
				local desc, war, watched
				for i = 1, GetNumFactions() do
					_,desc,_,_,_,_,war,_,_,_,_,watched = GetFactionInfo(i)
					if watched then break end
				end
				GameTooltip:AddLine(tags'repname',tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine(desc,ttsubh.r,ttsubh.g,ttsubh.b,1)
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(format("%s%s",tags'repcolor',tags'standing'),war and format("|cffff5555%s",AT_WAR))
				GameTooltip:AddDoubleLine(format("%s%% | %s/%s",tags'rep%',tags'currep',tags'maxrep'),-tags'repleft',ttsubh.r,ttsubh.g,ttsubh.b,1,0.33,0.33)
			end
			GameTooltip:Show()
		end,
		OnClick = function(self, button)
			if button == "RightButton" then
				conf.ExpMode = conf.ExpMode == "xp" and "played"
					or conf.ExpMode == "played" and "rep"
					or (conf.ExpMode == "rep" and UnitLevel(P) ~= MAX_PLAYER_LEVEL) and "xp"
					or conf.ExpMode == "rep" and "played"
				if conf.ExpMode == "rep" then
					self:GetScript("OnEvent")(self,"UPDATE_FACTION")
				else
					self:GetScript("OnUpdate")(self,5)
				end
				self:GetScript("OnEnter")(self)
			elseif button == "LeftButton" and conf.ExpMode == "rep" then
				ToggleCharacter("ReputationFrame")
			end
		end
	})
end
------------------------------------------
-- Applying modules
lpanels:CreateLayout("LiteStats", layout)
lpanels:ApplyLayout(nil, "LiteStats")

NewStat, blank = nil
