local max = math.max
local floor = math.floor

------------------------------------------------------------------------
-- UF's Functions
------------------------------------------------------------------------
Set_oUF_Colors = setmetatable({
	power = setmetatable({
		["MANA"] = {0.31, 0.45, 0.63},
		["RAGE"] = {0.69, 0.31, 0.31},
		["FOCUS"] = {0.71, 0.43, 0.27},
		["ENERGY"] = {0.65, 0.63, 0.35},
		["HAPPINESS"] = {0.19, 0.58, 0.58},
		["RUNES"] = {0.55, 0.57, 0.61},
		["RUNIC_POWER"] = {0, 0.82, 1},
		["FUEL"] = {0, 0.55, 0.5},
	}, {__index = oUF.colors.power}),
	reaction = setmetatable({
		[1] = { 222/255, 95/255,  95/255 }, -- Hated
		[2] = { 222/255, 95/255,  95/255 }, -- Hostile
		[3] = { 222/255, 95/255,  95/255 }, -- Unfriendly
		[4] = { 218/255, 197/255, 92/255 }, -- Neutral
		[5] = { 75/255,  175/255, 76/255 }, -- Friendly
		[6] = { 75/255,  175/255, 76/255 }, -- Honored
		[7] = { 75/255,  175/255, 76/255 }, -- Revered
		[8] = { 75/255,  175/255, 76/255 }, -- Exalted	
	}, {__index = oUF.colors.reaction}),
	runes = setmetatable({
		[1] = {0.77, 0.12, 0.23},
		[2] = {0, 0.5, 0},
		[3] = {0, 0.4, 0.7},
		[4] = {0.8, 0.8, 0.8}
	}, {__index = oUF.colors.runes})
}, {__index = oUF.colors})

function menu(self)
	local unit = self.unit:gsub("(.)", string.upper, 1) 
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif self.unit:match("party") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

CreateFS = function(frame, fsize, fstyle, sfont)
	local fstring = frame:CreateFontString(nil, 'OVERLAY')
	fstring:SetFont(aDB["fonts"].unitframe_font, aDB["fonts"].unitframe_font_size, aDB["fonts"].unitframe_font_style)
	fstring:SetShadowColor(0, 0, 0, 0)
	fstring:SetShadowOffset(0, 0)
	return fstring
end

CreateBG = function(parent)
	local BG = CreateFrame("Frame", nil, parent)
	BG:SetPoint('TOPLEFT', parent, 'TOPLEFT', -1, 1)
	BG:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 1, -1)
	BG:SetFrameLevel(parent:GetFrameLevel() - 1)
	aDB.SetUFStyle(BG)
	aDB.CreatePanelShadow(BG)
	return BG
end

OnCastbarUpdate = function(self, elapsed)
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.1f | |cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
			end
		else
			self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
	else
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
end

PostCastStart = function(self, unit, name, rank, text)
	local r, g, b, color
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		color = oUF.colors.class[class]
	else
		local reaction = UnitReaction(unit, "player");
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r;
			g = FACTION_BAR_COLORS[reaction].g;
			b = FACTION_BAR_COLORS[reaction].b;
		else
			r, g, b = 1, 1, 1
		end
	end

	if color then
		r, g, b = color[1], color[2], color[3]
	end
	if aDB["unitframe"].own_statusbar_color == true then
		self:SetAlpha(1)
		self:SetStatusBarColor(.36, .36, .36, 1)
		self.bg:SetVertexColor(0.1, 0.1, 0.1, 0.35)
	else
		self:SetAlpha(1)
		self:SetStatusBarColor(r, g, b, 1)
		self.bg:SetVertexColor(r, g, b, 0.35)
	end
end

PostCastStop = function(self, unit, name, rank, castid)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end

local FormatTime = function(s)
	local DAY, HOUR, MINUTE = 86400, 3600, 60
	if s >= DAY then
		return format('%dd', floor(s/DAY + 0.5)), s % DAY
	elseif s >= HOUR then
		return format('%dh', floor(s/HOUR + 0.5)), s % HOUR
	elseif s >= MINUTE then
		return format('%dm', floor(s/MINUTE + 0.5)), s % MINUTE
	end
	return floor(s + 0.5), s - floor(s)
end

UpdateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(0.69, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

updateAuraTrackerTime = function(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(0.69, 0.31, 0.31)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture("")
			self.text:SetText("")
		end	
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

CreateAuraTimer = function(icon, duration, expTime)
	icon.first = true
	if duration and duration > 0 then
		icon.remaining:Show()
		icon.timeLeft = expTime
		icon:SetScript("OnUpdate", UpdateAuraTimer)
	else
		icon.remaining:Hide()
		icon.timeLeft = 0
		icon:SetScript("OnUpdate", nil)
	end
end

CreateEnchantTimer = function(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon:SetScript("OnUpdate", UpdateAuraTimer)
	end
end

PostUpdateDebuff = function(self, unit, icon, index)
	local name, _, _, _, dtype, duration, expTime = UnitAura(unit, index, icon.filter)
	local c = DebuffTypeColor[dtype] or DebuffTypeColor.none
	icon.bg:SetBackdropBorderColor(c.r, c.g, c.b)
	icon.icon:SetDesaturated(aDB["unitframe"].desaturated_debuffs)
	CreateAuraTimer(icon, duration, expTime)
end

PostUpdateBuff = function(self, unit, icon, index)
	local name, _, _, _, dtype, duration, expTime = UnitAura(unit, index, icon.filter)
	CreateAuraTimer(icon, duration, expTime)
end

PostCreateAuraIcon = function(self, button)
	button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.overlay:SetTexture(nil)
	
	button.remaining = CreateFS(button)
	button.remaining:SetPoint('BOTTOM', 1, 3)
	
	button.count = CreateFS(button)
	button.count:SetPoint('TOPLEFT', 1, 2)
	
	button.bg = CreateBG(button)
end

UpdateCPoints = function(self, event, unit)
	if unit == PlayerFrame.unit and unit ~= self.CPoints.unit then
		self.CPoints.unit = unit
	end
end

PortraitPostUpdate = function(element, unit)
	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
		element:SetAlpha(0)
	else
		element:SetAlpha(1)
	end
end

------------------------------------------------
-- PostUpdateHealth - color health and add value
------------------------------------------------
local ShortValue = function(value)
	if value >= 10000000 then
		return string.format('%.1fm', value / 1000000)
	elseif value >= 1000000 then
		return string.format('%.2fm', value / 1000000)
	elseif value >= 100000 then
		return string.format('%.0fk', value / 1000)
	elseif value >= 10000 then
		return string.format('%.1fk', value / 1000)
	else
		return value
	end
end

PostUpdateHealthBar = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..locale.udc1.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..locale.dead1.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..locale.ghost1.."|r")
		end
	else
	
		local r, g, b
		
		if min ~= max then
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%s%%|r", min, r * 255, g * 255, b * 255, math.floor(min /max*100+.5))
			elseif unit == "pet" then
				health.value:SetFormattedText("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, ShortValue(min))
			else
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%s%%|r", ShortValue(min), r * 255, g * 255, b * 255, math.floor(min /max*100+.5))
			end
		else
			if unit ~= "player" and unit ~= "pet" then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText("|cff559655"..max.."|r")
			end
		end
	end
end

------------------------------------------------
-- PostUpdatePower - color power and add value
------------------------------------------------
PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	local color = Set_oUF_Colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = Set_oUF_Colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					power.value:SetText(ShortValue(min))
				elseif unit == "player" and power:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					power.value:SetFormattedText("%%s%%", math.floor(min /max*100+.5))
				elseif unit == "player" then
					power.value:SetFormattedText("%s%% |cffD7BEA5-|r %d", math.floor(min /max*100+.5), min)
				else
					power.value:SetText(min)
				end
			else
				power.value:SetText(min)
			end
		else
			if unit == "player" then
				power.value:SetText(min)
			else
				power.value:SetText(ShortValue(min))
			end
	end	end
end