local fdb = aDB["fonts"]

player_buffs = CreateFrame("Frame", "player_buffs", UIParent)
player_buffs:SetSize(450, 55)
player_buffs:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -140, -3)
tinsert(UIMovableFrames, player_buffs)

player_debuffs = CreateFrame("Frame", "player_debuffs", UIParent)
player_debuffs:SetSize(450, 55)
player_debuffs:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -140, -110)
tinsert(UIMovableFrames, player_debuffs)

focus_castbar = CreateFrame("Frame", "focus_castbar", UIParent)
focus_castbar:SetSize(250, 18)
focus_castbar:SetPoint('CENTER', UIParent, 0, 60)
tinsert(UIMovableFrames, focus_castbar)

_G["BuffFrame"]:Hide()
_G["BuffFrame"]:UnregisterAllEvents()
_G["BuffFrame"]:SetScript("OnUpdate", nil)

------------------------------------------	
-- Start here! 
------------------------------------------
local CreateStyle = function(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self.colors = Set_oUF_Colors
	self.menu = menu
	self:SetAttribute('type2', 'menu')
	
	local Lolpanel = CreateFrame("Frame", nil, self)
	Lolpanel:SetFrameLevel(2)
	Lolpanel:SetFrameStrata('BACKGROUND')
	aDB.SetStyle(Lolpanel)
	aDB.CreatePanelShadow(Lolpanel)
	if unit == 'player' then
		Lolpanel:SetPoint('BOTTOM', 0, -13)
		Lolpanel:SetSize(187, 15)
	elseif unit == 'target' then
		Lolpanel:SetPoint('TOP', 0, 17)
		Lolpanel:SetSize(187, 15)
	end
	self.Lolpanel = Lolpanel

	-- HealthBar config
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(aDB["media"].texture)
	self.Health:SetStatusBarColor(.45, .45, .45)
	if unit == 'player' or unit == 'target' then
		self.Health:SetHeight((36 * 2)/3-3)
	else
		self.Health:SetHeight((28 * 2)/3-3)
	end
	self.Health:SetPoint('TOPLEFT')
	self.Health:SetPoint('TOPRIGHT')

	self.Health.frequentUpdates = true
	if aDB["unitframe"].own_statusbar_color == true then
		self.Health.colorTapping = false
		self.Health.colorDisconnected = false
		self.Health:SetStatusBarColor(.36, .36, .36)
	else
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end
	self.Health.Smooth = aDB["unitframe"].smooth_bar
	
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(aDB["media"].texture)
	if aDB["unitframe"].own_statusbar_color == true then
		self.Health.bg:SetVertexColor(0.1, 0.1, 0.1)	
	else
		self.Health.bg.multiplier = 0.3
	end
	
	self.Health.background = CreateBG(self.Health)
	self.Health.PostUpdate = PostUpdateHealthBar
	
	self.Health.value = CreateFS(Lolpanel)
	if unit == 'player' then
		self.Health.value:SetPoint('RIGHT', -1, 2)
	elseif unit == 'target' then
		self.Health.value:SetPoint('RIGHT', -1, 2)
	else
		self.Health.value:SetPoint('RIGHT', 0, 22)
	end
	
	-- PowerBar config 
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetStatusBarTexture(aDB["media"].texture)
	if unit == 'player' or unit == 'target' then
		self.Power:SetHeight(5)
	end
	if unit == 'player' then
		self.Power:SetPoint('TOPLEFT', 0, 8)
		self.Power:SetPoint('TOPRIGHT', 0, 8)
	elseif unit == 'target' then
		self.Power:SetPoint('BOTTOMLEFT', 0, -4)
		self.Power:SetPoint('BOTTOMRIGHT', 0, -4)
	end
	
	self.Power.frequentUpdates = true
	self.Power.colorDisconnected = true
	self.Power.colorTapping = true
	if aDB["unitframe"].own_statusbar_color == true then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.Smooth = aDB["unitframe"].smooth_bar
	
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(aDB["media"].texture)
	self.Power.bg.multiplier = 0.3
	
	self.Power.background = CreateBG(self.Power)
	
	self.Power.PreUpdate = PreUpdatePower
	self.Power.PostUpdate = PostUpdatePower
	
	self.Power.value = CreateFS(Lolpanel)
	if unit == 'player' or unit == 'target' then
		self.Power.value:SetPoint('LEFT', 2, 2)
	end
	
	-- Text tags
	self.Info = CreateFS(Lolpanel)
	if unit == 'target'  then
		self.Info:SetPoint('CENTER', -6, 2)
		self:Tag(self.Info, "[alt:afkdnd] [alt:color][NameLong]")
	elseif unit == 'targettarget' or unit == 'focus' or unit == 'pet' then
		self.Info = CreateFS(self.Health)
		self.Info:SetPoint('CENTER', -6, 2)
		self:Tag(self.Info, "[alt:afkdnd] [alt:color][NameShort]")
	end
	
	-- Rest icon
	if aDB["unitframe"].rest_icon == true then
		self.Resting = self.Health:CreateTexture(nil, "OVERLAY")
		self.Resting:SetHeight(20)
		self.Resting:SetWidth(20)
		self.Resting:SetPoint('RIGHT', self, 0, 4)
	end
	
	-- Combat icon
	self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
	self.Combat:SetHeight(20)
	self.Combat:SetWidth(20)
	self.Combat:SetPoint('LEFT', self, 0, 4)
	self.Combat:SetVertexColor(0.69, 0.31, 0.31)
	
	-- Raid mark icon
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('TOP', self, 0, 4)
	self.RaidIcon:SetHeight(12)
	self.RaidIcon:SetWidth(12)
	
	-- Leader icon
	self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('LEFT', self.RaidIcon, 'RIGHT', 2, 0)
	self.Leader:SetHeight(12)
	self.Leader:SetWidth(12)
	
	-- Assistant icon
	self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	self.Assistant:SetPoint('LEFT', self.Leade, 'RIGHT', 2, 0)
	self.Assistant:SetHeight(12)
	self.Assistant:SetWidth(12)
	
	-- Master-loot icon
	self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	self.MasterLooter:SetPoint('LEFT', self.Assistant, 'RIGHT', 2, 0)
	self.MasterLooter:SetHeight(12)
	self.MasterLooter:SetWidth(12)
	
	------------------------------------------	
	-- Unit class specific
	------------------------------------------	
	if aDB["unitframe"].plugin_rune_bar == true and unit == 'player' and aDB.myclass == 'DEATHKNIGHT' then
		self.Runes = CreateFrame('Frame', nil, self)
		for i = 1, 6 do
			self.Runes[i] = CreateFrame('StatusBar', nil, self.Runes)
			self.Runes[i]:SetStatusBarTexture(aDB["media"].texture)
			if aDB["unitframe"].enable_portraits == true then
				self.Runes[i]:SetSize((205 / 6), 7)
			else
				self.Runes[i]:SetSize((170 / 6), 7)
			end
			self.Runes[i].background = CreateBG(self.Runes[i])
			
			self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
			self.Runes[i].bg:SetAllPoints()
			self.Runes[i].bg:SetTexture(aDB["media"].texture)
			self.Runes[i].bg.multiplier = 0.25
			
			if aDB["unitframe"].enable_portraits == true then
				if i == 1 then
					self.Runes[i]:SetPoint('TOPLEFT', self, 'TOPLEFT', -35, 18)
				else
					self.Runes[i]:SetPoint('LEFT', self.Runes[i-1], 'RIGHT', 3, 0)
				end
			else
				if i == 1 then
					self.Runes[i]:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 18)
				else
					self.Runes[i]:SetPoint('LEFT', self.Runes[i-1], 'RIGHT', 3, 0)
				end
			end
		end
	end

	if aDB["unitframe"].plugin_totem_bar == true and unit == 'player' and aDB.myclass == "SHAMAN" then
		self.TotemBar = {}
		for i = 1, 4 do
			self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
			self.TotemBar[i]:SetStatusBarTexture(aDB["media"].texture)
			if aDB["unitframe"].enable_portraits == true then
				self.TotemBar[i]:SetSize((211 / 4), 7)
			else
				self.TotemBar[i]:SetSize((176 / 4), 7)
			end
			self.TotemBar[i]:SetMinMaxValues(0, 1)
			self.TotemBar[i].bg = CreateBG(self.TotemBar[i])
			
			self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
			self.TotemBar[i].bg:SetAllPoints()
			self.TotemBar[i].bg:SetTexture(aDB["media"].texture)
			self.TotemBar[i].bg.multiplier = 0.25
				
			if aDB["unitframe"].enable_portraits == true then
				if (i == 1) then
					self.TotemBar[i]:SetPoint('TOPLEFT', self, 'TOPLEFT', -35, 18)
				else
					self.TotemBar[i]:SetPoint('LEFT', self.TotemBar[i-1], 'RIGHT', 3, 0)
				end
			else
				if (i == 1) then
					self.TotemBar[i]:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 18)
				else
					self.TotemBar[i]:SetPoint('LEFT', self.TotemBar[i-1], 'RIGHT', 3, 0)
				end
			end
		end
	end

	if aDB["unitframe"].plugin_combo_points and unit == 'target' then
		local CPoints = {}
		CPoints.unit = PlayerFrame.unit
		for i = 1, 5 do
			CPoints[i] = CreateFrame("StatusBar", nil, self)
			if aDB["unitframe"].enable_portraits == true then
				CPoints[i]:SetSize((208 / 5), 7)
			else
				CPoints[i]:SetSize((173 / 5), 7)
			end
			CPoints[i]:SetStatusBarTexture(aDB["media"].texture)
		if i == 1 then
			CPoints[i]:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, -14)
			CPoints[i]:SetStatusBarColor(0.9, 0.1, 0.1)
		else
			CPoints[i]:SetPoint('LEFT', CPoints[i-1], 'RIGHT', 3, 0)
		end
			CPoints[i].overlay = CreateFrame("Frame", nil, CPoints[i])
			CPoints[i].overlay:SetFrameStrata('BACKGROUND')
			CPoints[i].overlay:SetPoint('TOPLEFT', -1, 1)
			CPoints[i].overlay:SetPoint('BOTTOMRIGHT', 1, -1)
			aDB.SetStyle(CPoints[i].overlay)
			aDB.CreatePanelShadow(CPoints[i].overlay)
		end
			CPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
			CPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
			CPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
			CPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)
			self.CPoints = CPoints
		self:RegisterEvent("UNIT_COMBO_POINTS", UpdateCPoints)
	end
	
	-- Mirror Bar
	for _, bar in pairs({
		"MirrorTimer1",
		"MirrorTimer2",
		"MirrorTimer3",
	}) do   
	for i, region in pairs({_G[bar]:GetRegions()}) do
		if (region.GetTexture and region:GetTexture() == "SolidTexture") then
		region:Hide()
		end
	end

	_G[bar.."Border"]:Hide()
	
	_G[bar]:SetParent(UIParent)
	_G[bar]:SetHeight(18)
	_G[bar]:SetWidth(250)
	aDB.CreatePanelShadow(_G[bar])
	
	_G[bar.."Background"] = _G[bar]:CreateTexture(bar.."Background", "BACKGROUND", _G[bar])
	_G[bar.."Background"]:SetTexture(aDB["media"].texture)
	_G[bar.."Background"]:SetAllPoints(bar)
	_G[bar.."Background"]:SetVertexColor(0.3, 0.3, 0.3)

	_G[bar.."Text"]:SetFont(aDB["fonts"].unitframe_font, aDB["fonts"].unitframe_font_size, aDB["fonts"].unitframe_font_style)
	_G[bar.."Text"]:SetShadowColor(0, 0, 0, 0)
	_G[bar.."Text"]:ClearAllPoints()
	_G[bar.."Text"]:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 2)
	
	_G[bar.."StatusBar"]:SetAllPoints(_G[bar])
	_G[bar.."StatusBar"]:SetStatusBarTexture(aDB["media"].texture)

	local border = CreateFrame("Frame", nil, _G[bar])
	border:SetPoint('TOPLEFT', _G[bar], -1, 1)
	border:SetPoint('BOTTOMRIGHT', _G[bar], 1, -1)
	border:SetFrameLevel(0)
	aDB.SetStyle(border)
	end
	
	-- Portraits
	if aDB["unitframe"].enable_portraits == true then
		if unit == 'player' or unit == 'target' then
			self.Portrait = CreateFrame("PlayerModel", nil, self)
			self.Portrait:SetWidth(32)
			self.Portrait:SetHeight(45)
			if unit == 'player' then
				self.Portrait:SetPoint('TOPRIGHT', self.Health, 'BOTTOMLEFT', -3, 29)
			else
				self.Portrait:SetPoint('TOPLEFT', self.Health, 'BOTTOMRIGHT', 3, 37)
			end
			
			self.Portrait.PostUpdate = PortraitPostUpdate
			
			self.PortraitOverlay = CreateFrame("StatusBar", self:GetName().."_PortraitOverlay", self.Portrait)
			self.PortraitOverlay:SetFrameLevel(self.PortraitOverlay:GetFrameLevel() - 1)
			self.PortraitOverlay:SetPoint('TOPLEFT', -1, 1)
			self.PortraitOverlay:SetPoint('BOTTOMRIGHT', 1, -1)
			aDB.SetStyle(self.PortraitOverlay)
			aDB.CreatePanelShadow(self.PortraitOverlay)
		end
	end
	------------------------------------------	
	-- Buffs and Debuffs (Auras)
	------------------------------------------
	if unit == 'target' then
		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetPoint('TOPLEFT', self.Lolpanel, 'TOPLEFT', 1, 22)
		self.Buffs:SetHeight(55)
		self.Buffs:SetWidth(19.2 * 13)
		self.Buffs.size = 19.2
		self.Buffs.spacing = 4.5
		self.Buffs.num = 8
		self.Buffs.disableCooldown = true
		self.Buffs.initialAnchor = 'TOPLEFT'
		self.Buffs['growth-y'] = 'UP'
		self.Buffs['growth-x'] = 'RIGHT'
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateBuff

		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetPoint('TOPRIGHT', self.Buffs, 'TOPRIGHT', -64, 24)
		self.Debuffs:SetHeight(55)
		self.Debuffs:SetWidth(200)
		self.Debuffs.size = 19.2
		self.Debuffs.spacing = 4.5
		self.Debuffs.num = 20
		self.Debuffs.disableCooldown = true
		self.Debuffs.initialAnchor = 'TOPRIGHT'
		self.Debuffs['growth-y'] = 'UP'	
		self.Debuffs['growth-x'] = 'LEFT'
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff
	end

	if unit == 'player' then
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs:SetPoint('CENTER', player_buffs)
		self.Buffs.initialAnchor = 'TOPRIGHT'
		self.Buffs["growth-y"] = 'DOWN'
		self.Buffs["growth-x"] = 'LEFT'
		self.Buffs:SetHeight(55)
		self.Buffs:SetWidth(450)
		self.Buffs.spacing = 4.5
		self.Buffs.size = 26
		self.Buffs.num = 32
		self.Buffs.disableCooldown = true
		self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.PostUpdateIcon = PostUpdateBuff

		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetPoint('CENTER', player_debuffs)
		self.Debuffs.initialAnchor = 'TOPRIGHT'
		self.Debuffs["growth-x"] = 'LEFT'
		self.Debuffs["growth-y"] = 'DOWN'
		self.Debuffs:SetHeight(55)
		self.Debuffs:SetWidth(450)
		self.Debuffs.spacing = 4.5
		self.Debuffs.size = 26
		self.Debuffs.num = 32
		self.Debuffs.disableCooldown = true
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff
	end
	
	if aDB["unitframe"].focus_debuffs == true and unit == 'focus' then
		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetPoint('TOPRIGHT', self.Health, 'TOPLEFT', 20, -20)
		self.Debuffs:SetHeight(25)
		self.Debuffs:SetWidth(200)
		self.Debuffs.size = 19.2
		self.Debuffs.num = 8
		self.Debuffs.spacing = 4.5
		self.Debuffs.disableCooldown = true
		self.Debuffs.initialAnchor = 'TOPRIGHT'
		self.Debuffs['growth-y'] = 'DOWN'	
		self.Debuffs['growth-x'] = 'RIGHT'
		self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff
	end
	------------------------------------------	
	-- Cast Bars
	------------------------------------------
	self.Castbar = CreateFrame('StatusBar', nil, self)
	self.Castbar:SetStatusBarTexture(aDB["media"].texture)
	self.Castbar:SetFrameLevel(30)
	self.Castbar.bg = CreateBG(self.Castbar)
	
	self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
	self.Castbar.bg:SetTexture(aDB["media"].texture)
	self.Castbar.bg:SetAllPoints(self.Castbar)
	
	-- CastBar spell text
	self.Castbar.Text = CreateFS(self.Castbar)
	if unit == 'focus' then
		self.Castbar.Text:SetPoint('LEFT', 2, 1)
	else
		self.Castbar.Text:SetPoint('LEFT', 2, 1)
	end
	
	-- CastBar cast time
	self.Castbar.Time = CreateFS(self.Castbar)
	if unit == 'focus' then
		self.Castbar.Time:SetPoint('RIGHT', -2, 2)
	else
		self.Castbar.Time:SetPoint('RIGHT', -2, 2)
	end
	
	-- Colors
	self.Castbar.CompleteColor = {0.12, 0.86, 0.15}
	self.Castbar.FailColor = {1, 0.2, 0.2}
	
	-- Button 
	self.Castbar.Button = CreateFrame('Frame', nil, self.Castbar)
	self.Castbar.Button:SetHeight(25)
	self.Castbar.Button:SetWidth(25)
	if unit == 'focus' then
		self.Castbar.Button:SetHeight(35)
		self.Castbar.Button:SetWidth(35)
	end
	self.Castbar.Button.bg = CreateBG(self.Castbar.Button)
	
	-- Spell icon
	self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, 'ARTWORK')
	self.Castbar.Icon:SetAllPoints(self.Castbar.Button)
	self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	if unit == 'player' then
		self.Castbar:SetSize(217, 15)
		self.Castbar:SetPoint('TOPLEFT', self.Lolpanel, 1, -1)
		self.Castbar:SetPoint('BOTTOMRIGHT', self.Lolpanel, -1, 1)
		self.Castbar.Button:SetPoint('TOPRIGHT', self.Health, 'TOPLEFT', -38, 8)
		self:RegisterEvent("UNIT_SPELLCAST_SENT", OnCastSent)
	elseif unit == 'target' then
		self.Castbar:SetSize(217, 15)
		self.Castbar:SetPoint('TOPLEFT', self.Lolpanel, 1, -1)
		self.Castbar:SetPoint('BOTTOMRIGHT', self.Lolpanel, -1, 1)
		self.Castbar.Button:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 38, 16)
	elseif unit == 'focus' then
		self.Castbar:SetPoint('CENTER', focus_castbar)
		self.Castbar:SetWidth(250)
		self.Castbar:SetHeight(18)
		self.Castbar.Button:SetPoint('TOP', self.Castbar, 'TOP', 0, 38)
	end
	self.Castbar.OnUpdate = OnCastbarUpdate
	self.Castbar.PostCastStart = PostCastStart
	self.Castbar.PostChannelStart = PostCastStart
	self.Castbar.PostCastStop = PostCastStop
	self.Castbar.PostChannelStop = PostChannelStop
	self.Castbar.PostCastFailed = PostCastFailed
	self.Castbar.PostCastInterrupted = PostCastFailed
	
	-- Frame size 
	if unit == 'player' or unit == 'target' then
		self:SetAttribute('initial-height', 25)
		self:SetAttribute('initial-width', 185)
	elseif unit == 'targettarget' or unit == 'pet' or unit == 'focus' or unit then
		self:SetAttribute('initial-height', 25)
		self:SetAttribute('initial-width', 185)
	end

	-- oUF_WeaponEnchant
	if unit== 'player' then
		self.Enchant = CreateFrame("Frame", nil, self)
		self.Enchant:SetWidth(self.Castbar.Button:GetWidth() * 2)
		self.Enchant:SetHeight(self.Castbar.Button:GetHeight())
		self.Enchant:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -116, -75)
		self.Enchant.size = 26
		self.Enchant.spacing = 4.5
		self.Enchant.showCD = false
		self.Enchant.initialAnchor = 'LEFT'
		self.Enchant["growth-x"] = 'LEFT'
		self.PostCreateEnchantIcon = PostCreateAuraIcon
		self.PostUpdateEnchantIcons = CreateEnchantTimer
	end
	
	-- oUF_AuraTracker
	if aDB["unitframe"].aura_tracker and unit == 'target' then
		self.AuraTracker = CreateFrame("Frame", nil, self)
		self.AuraTracker:SetWidth(self.Portrait:GetWidth())
		self.AuraTracker:SetHeight(self.Portrait:GetHeight())
		self.AuraTracker:SetPoint('CENTER', self.Portrait)
		self.AuraTracker:SetFrameStrata('HIGH')
		
		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, "ARTWORK")
		self.AuraTracker.icon:SetWidth(self.Portrait:GetWidth())
		self.AuraTracker.icon:SetHeight(self.Portrait:GetHeight())
		self.AuraTracker.icon:SetAllPoints(self.Portrait)
		self.AuraTracker.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		
		self.AuraTracker.text = self.AuraTracker:CreateFontString(nil, "OVERLAY")
		self.AuraTracker.text:SetFont(aDB["fonts"].unitframe_font, aDB["fonts"].unitframe_font_size, aDB["fonts"].unitframe_font_style)
		self.AuraTracker.text:SetPoint('BOTTOM', self.AuraTracker, 1, 3)
		
		self.AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
	end
	
	-- oUF_CombatFeedback
	if aDB["unitframe"].combat_feedback == true then
	if unit == 'player' or unit == 'target' then
		self.CombatFeedbackText = CreateFS(self.Health, aDB["fonts"].unitframe_font, fdb.unitframe_font_size * 2, aDB["fonts"].unitframe_font_style)
		self.CombatFeedbackText:SetPoint('CENTER', 0, 2)
	end
	end
	-- FINISH THIS FUCKING LAYOUT!
end

-- Spawn units
oUF:Factory(function(self)
oUF:RegisterStyle('Alt', CreateStyle)
	self:SetActiveStyle('Alt')
	
	local player = self:Spawn('player')
	player:SetPoint(unpack(aDB["unitframe"].player))
	tinsert(UIMovableFrames, player)
	
	local target = self:Spawn('target')
	target:SetPoint(unpack(aDB["unitframe"].target))
	tinsert(UIMovableFrames, target)
	
	local targettarget = self:Spawn('targettarget')
	targettarget:SetPoint(unpack(aDB["unitframe"].targettarget))
	tinsert(UIMovableFrames, targettarget)
	
	local pet = self:Spawn('pet')
	pet:SetPoint(unpack(aDB["unitframe"].pet))
	tinsert(UIMovableFrames, pet)
	
	local focus = self:Spawn('focus')
	focus:SetPoint(unpack(aDB["unitframe"].focus))
	tinsert(UIMovableFrames, focus)
	
	-- Hide party frames
	local dummy = function() end
	for i=1,4 do
		local party = "PartyMemberFrame"..i
		local frame = _G[party]

		frame:UnregisterAllEvents()
		frame.Show = dummy
		frame:Hide()

		_G[party..'HealthBar']:UnregisterAllEvents()
		_G[party..'ManaBar']:UnregisterAllEvents()
	end	
end)