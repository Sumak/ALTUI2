local SetStyle = function(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self.menu = menu
	self.colors = Set_oUF_Colors
	self:SetAttribute('type2', 'menu')
	
	if unit == 'raid' or unit == 'party' then
		self:SetAttribute('initial-height', 25)
		self:SetAttribute('initial-width', 90)
	end
	
	-- Health bar
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(aDB["media"].texture)
	self.Health:SetStatusBarColor(.35, .35, .35)
	self.Health:SetHeight(6)
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
	
	self.Info = CreateFS(self.Health)
	if unit == 'raid' or unit == 'party' then
		self.Info:SetPoint('LEFT', self, 'RIGHT', 0, 12)
		self:Tag(self.Info, "[alt:afkdnd] [alt:color][NameShort]")
	end
	
	-- Leader icon
	self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('TOPLEFT', self, 0, 8)
	self.Leader:SetHeight(12)
	self.Leader:SetWidth(12)
	
	-- Raid mark icon
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('TOPRIGHT', self, 0, 8)
	self.RaidIcon:SetHeight(12)
	self.RaidIcon:SetWidth(12)
	
	-- Assistant icon
	self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	self.Assistant:SetPoint('TOPLEFT', 0, 8)
	self.Assistant:SetHeight(12)
	self.Assistant:SetWidth(12)
	
	-- Master-looter icon
	self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	self.MasterLooter:SetPoint('TOP', 0, 8)
	self.MasterLooter:SetHeight(12)
	self.MasterLooter:SetWidth(12)
	
	if unit == 'raid' or unit == 'party' then
		self.Range = {insideAlpha = aDB["unitframe"].inside_alpha, outsideAlpha = aDB["unitframe"].outside_alpha}
	end
end

-- Spawn units
oUF:RegisterStyle('AltUF', SetStyle)
oUF:Factory(function(self)
	oUF:SetActiveStyle('AltUF')
	local raid = self:SpawnHeader('oUF_Raid', nil, 'solo,raid',
		'showRaid', aDB["unitframe"].show, 
		'showSolo', aDB["unitframe"].showSolo,
		'xoffset', 0,
		'yOffset', -10,
		'point', 'LEFT',
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 25,
		'unitsPerColumn', 1,
		'columnSpacing', -15,
		'columnAnchorPoint', 'BOTTOM'
	)
	raid:SetPoint(unpack(aDB["unitframe"].raid))
	tinsert(UIMovableFrames, raid)	
	
	local party = self:SpawnHeader("oUF_Party", nil, visible, 'showParty', aDB["unitframe"].showParty, 'yOffset', 15)
	party:SetPoint(unpack(aDB["unitframe"].party))
	tinsert(UIMovableFrames, party)
	party:Show()
end)
