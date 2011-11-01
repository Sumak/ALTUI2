----------------------------------------------------------------------------------------
--	caelNamePlates(by Caellian)
----------------------------------------------------------------------------------------
if not aDB["nameplates"].enable == true then return end

local AltUI_Nameplates = CreateFrame("Frame", nil, UIParent)
AltUI_Nameplates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local select = select

local IsValidFrame = function(frame)
	if frame:GetName() then
		return
	end

	overlayRegion = select(2, frame:GetRegions())

	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == aDB["media"].over_texture
end

local UpdateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
	end
end

local ShortValue = function(name)	
	local newname = (string.len(name) > 15) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return utf8sub(newname, 15, false)
end

local UpdateFrame = function(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		newr, newg, newb = 0.69, 0.31, 0.31
		self.healthBar:SetStatusBarColor(0.69, 0.31, 0.31)
	elseif r + b == 0 then
		newr, newg, newb = 0.33, 0.59, 0.33
		self.healthBar:SetStatusBarColor(0.33, 0.59, 0.33)
	elseif r + g == 0 then
		newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		newr, newg, newb = 0.65, 0.63, 0.35
		self.healthBar:SetStatusBarColor(0.65, 0.63, 0.35)
	else
		newr, newg, newb = r, g, b
	end

	self.r, self.g, self.b = newr, newg, newb

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint('CENTER', self.healthBar:GetParent())
	self.castBar:SetHeight(3 * UIParent:GetEffectiveScale())
	self.castBar:SetWidth(100 * UIParent:GetEffectiveScale())

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint('BOTTOM', self.healthBar, 0, -12)
	self.healthBar:SetHeight(8 * UIParent:GetEffectiveScale())
	self.healthBar:SetWidth(100 * UIParent:GetEffectiveScale())

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	self.name:SetText(ShortValue(self.oldname:GetText()))

	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint('RIGHT', self.healthBar, 'LEFT', -2, 1)
	if self.boss:IsShown() then
		self.level:SetText('B')
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	elseif not elite and level == mylevel then
		self.level:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local FixCastbar = function(self)
	self.castbarOverlay:Hide()
	self:SetHeight(5)
	self:ClearAllPoints()
	self:SetPoint('TOP', self.healthBar, 'BOTTOM', 0, -8)
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.78, 0.25, 0.25)
		self.cbGlow:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	else
		self.cbGlow:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local OnValueChanged = function(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target") 
	FixCastbar(self)
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local OnHide = function(self)
	self.highlight:Hide()
	self.healthBar:SetBackdropBorderColor(0, 0, 0)
end

local OnEvent = function(self, event, unit)
	if unit == 'target' then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local Abbrev = function(name)	
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return utf8sub(newname, 18, false)
end

local CreateFrame = function(frame)
	local offset = UIParent:GetEffectiveScale()
	
	if frame.done then
		return
	end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = frame:CreateFontString()
	newNameRegion:SetPoint('BOTTOM', healthBar, 'TOP', 2, 4)
	newNameRegion:SetFont(aDB["fonts"].nameplate_font, aDB["fonts"].nameplate_font_size * UIParent:GetEffectiveScale(), aDB["fonts"].nameplate_font_style)
	newNameRegion:SetTextColor(1, 1, 1)
	newNameRegion:SetShadowOffset(0, 0)
	frame.name = newNameRegion

	frame.level = levelTextRegion
	levelTextRegion:SetFont(aDB["fonts"].nameplate_font, aDB["fonts"].nameplate_font_size * UIParent:GetEffectiveScale(), aDB["fonts"].nameplate_font_style)
	levelTextRegion:SetShadowOffset(0, 0)

	healthBar:SetStatusBarTexture(aDB["media"].texture)
	
	healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
	healthBar.bg:SetAllPoints(healthBar)
	healthBar.bg:SetTexture(aDB["media"].texture)
	healthBar.bg:SetVertexColor(0.15, 0.15, 0.15)

	local bgframe = CreateFrame("Frame", nil, healthBar)
	bgframe:SetBackdrop({
		bgFile = 'Interface\\Buttons\\WHITE8x8', 
		edgeFile = 'Interface\\Buttons\\WHITE8x8', 
		tile = false, tileSize = 0, edgeSize = 1 * offset, 
		insets = { left = 0 * offset, right = 0 * offset, top = 0 * offset, bottom = 0 * offset}
	})
	bgframe:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	bgframe:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	bgframe:SetPoint('TOPLEFT', healthBar, 'TOPLEFT', -1 * offset, 1 * offset)
	bgframe:SetPoint('BOTTOMRIGHT', healthBar, 'BOTTOMRIGHT', 1 * offset, -1 * offset)
	bgframe:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
	aDB.CreateNameplatesShadow(bgframe)

	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(aDB["media"].texture)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint('RIGHT', castBar, 'LEFT', 1, 1)
	castBar.time:SetFont(aDB["fonts"].nameplate_font, aDB["fonts"].nameplate_font_size * UIParent:GetEffectiveScale(), aDB["fonts"].nameplate_font_style)
	castBar.time:SetTextColor(1, 1, 1)
	castBar.time:SetShadowOffset(0, 0)

	castBar.cbBackground = castBar:CreateTexture(nil, "BACKGROUND")
	castBar.cbBackground:SetAllPoints(castBar)
	castBar.cbBackground:SetTexture(aDB["media"].texture)
	castBar.cbBackground:SetVertexColor(0.15, 0.15, 0.15)
 
	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetBackdrop({
		bgFile = 'Interface\\Buttons\\WHITE8x8', 
		edgeFile = 'Interface\\Buttons\\WHITE8x8', 
		tile = false, tileSize = 0, edgeSize = 1 * offset, 
		insets = { left = 0 * offset, right = 0 * offset, top = 0 * offset, bottom = 0 * offset}
	})
	castBar.cbGlow:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	castBar.cbGlow:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	castBar.cbGlow:SetPoint('TOPLEFT', castBar, 'TOPLEFT', -1 * offset, 1 * offset)
	castBar.cbGlow:SetPoint('BOTTOMRIGHT', castBar, 'BOTTOMRIGHT', 1 * offset, -1 * offset)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)
	aDB.CreateNameplatesShadow(castBar.cbGlow)
 
	castBar.Holder = CreateFrame("Frame", nil, castBar)
	castBar.Holder:SetFrameLevel(castBar.Holder:GetFrameLevel() + 1)
	castBar.Holder:SetAllPoints()
	
	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetPoint('TOPLEFT', healthBar, 'TOPRIGHT', 10, 0)
	spellIconRegion:SetHeight(20)
	spellIconRegion:SetWidth(20)
	spellIconRegion:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	cbIconborder = CreateFrame("Frame", nil, castBar)
	cbIconborder:SetBackdrop({
		bgFile = 'Interface\\Buttons\\WHITE8x8', 
		edgeFile = 'Interface\\Buttons\\WHITE8x8', 
		tile = false, tileSize = 0, edgeSize = 1 * offset, 
		insets = {left = 0 * offset, right = 0 * offset, top = 0 * offset, bottom = 0 * offset}
	})
	cbIconborder:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	cbIconborder:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	cbIconborder:SetPoint('TOPLEFT', spellIconRegion, 'TOPLEFT', -1 * offset, 1 * offset)
	cbIconborder:SetPoint('BOTTOMRIGHT', spellIconRegion, 'BOTTOMRIGHT', 1 * offset, -1 * offset)
	aDB.CreateNameplatesShadow(cbIconborder)
	
	highlightRegion:SetTexture(aDB["media"].texture)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint('LEFT', healthBar, 'RIGHT', 4, 0)
	raidIconRegion:SetHeight(16)
	raidIconRegion:SetWidth(16)

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion

	frame.done = true

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	UpdateFrame(frame)
	frame:SetScript("OnShow", UpdateFrame)
	frame:SetScript("OnHide", OnHide)

	frame.elapsed = 0
	frame:SetScript("OnUpdate", ThreatUpdate)
end

local numKids = 0
local lastUpdate = 0
local OnUpdate = function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		lastUpdate = 0

		if WorldFrame:GetNumChildren() ~= numKids then
			numKids = WorldFrame:GetNumChildren()
			for i = 1, select("#", WorldFrame:GetChildren()) do
				frame = select(i, WorldFrame:GetChildren())

				if IsValidFrame(frame) then
					CreateFrame(frame)
				end
			end
		end
	end
end

AltUI_Nameplates:SetScript("OnUpdate", OnUpdate)

AltUI_Nameplates:RegisterEvent("PLAYER_REGEN_ENABLED")
function AltUI_Nameplates:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
end

AltUI_Nameplates:RegisterEvent("PLAYER_REGEN_DISABLED")
function AltUI_Nameplates.PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end