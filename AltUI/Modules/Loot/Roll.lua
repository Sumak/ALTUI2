----------------------------------------------------------------------------------------
--	alRollFrame(by Allez)
----------------------------------------------------------------------------------------
local lootFrames = {}

local CreateBG = function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -1, 1)
	bg:SetPoint('BOTTOMRIGHT', parent,'BOTTOMRIGHT', 1, -1)
	bg:SetFrameStrata('LOW')
	aDB.SetStyle(bg)
	aDB.CreatePanelShadow(bg)
	return bg
end

local OnUpdate = function(self, elapsed)
	self:SetValue(GetLootRollTimeLeft(self.rollId))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:SetLootRollItem(self:GetParent().rollId)
	CursorUpdate(self)
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	RollOnLoot(self:GetParent().rollId, self.rollType)
end

local CreateLootFrame = function()
	local frame = CreateFrame("StatusBar", nil, UIParent)
	frame:SetWidth(aDB["lootroll"].roll_width)
	frame:SetHeight(aDB["lootroll"].roll_height)
	frame:SetStatusBarTexture(aDB["media"].texture)
	
	frame.bg = CreateBG(frame)
	
	frame.button = CreateFrame("Button", nil, frame)
	frame.button:SetWidth(aDB["lootroll"].icon_size)
	frame.button:SetHeight(aDB["lootroll"].icon_size)
	frame.button:SetPoint('RIGHT', frame, 'LEFT', -3, 0)
	frame.button.bg = CreateBG(frame.button)
	frame.button:SetScript("OnEnter", OnEnter)
	frame.button:SetScript("OnLeave", OnLeave)
	
	frame.need = CreateFrame("Button", nil, frame)
	frame.need:SetSize(17, 17)
	frame.need:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
	frame.need:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
	frame.need:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")
	frame.need:SetScript("OnClick", OnClick)
	frame.need:SetPoint('LEFT', frame, 'LEFT', 3, 0)
	frame.need.rollType = 1
	
	frame.greed = CreateFrame("Button", nil, frame)
	frame.greed:SetSize(17, 17)
	frame.greed:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Up")
	frame.greed:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Down")
	frame.greed:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Highlight")
	frame.greed:SetScript("OnClick", OnClick)
	frame.greed:SetPoint('LEFT', frame.need, 'RIGHT', 3, 0)
	frame.greed.rollType = 2
	
	frame.dis = CreateFrame("Button", nil, frame)
	frame.dis:SetSize(17, 17)
	frame.dis:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-DE-Up")
	frame.dis:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-DE-Down")
	frame.dis:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-DE-Highlight")
	frame.dis:SetScript("OnClick", OnClick)
	frame.dis:SetPoint('LEFT', frame.greed, 'RIGHT', 3, 0)
	frame.dis.rollType = 3
	
	frame.pass = CreateFrame("Button", nil, frame)
	frame.pass:SetSize(17, 17)
	frame.pass:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
	frame.pass:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down")
	frame.pass:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Highlight")
	frame.pass:SetScript("OnClick", OnClick)
	frame.pass:SetPoint('LEFT', frame.dis, 'RIGHT', 3, 0)
	frame.pass.rollType = 0
	
	frame.name = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.name:SetPoint('LEFT', frame.pass, 'RIGHT', 3, 1)
	frame.name:SetPoint('RIGHT', frame, 'RIGHT', -3, 1)
	frame.name:SetFont(aDB["fonts"].roll_frame_font, aDB["fonts"].roll_frame_font_size, aDB["fonts"].roll_frame_font_style)
	frame.name:SetShadowOffset(0, 0)
	frame.name:SetJustifyH('LEFT')
	frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 350, -50 - (#lootFrames * (25 + 2 + 4)))
	frame:Hide()
	tinsert(lootFrames, frame)
	return frame
end

local GetLootFrame = function()
	for i, v in pairs(lootFrames) do
		if not v.rollId then
			return v
		end
	end
	return CreateLootFrame()
end

local OnEvent = function(self, event, ...)
	if event == "START_LOOT_ROLL" then
		local rollId, rollTime = ...
		local lootFrame = GetLootFrame()
		local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(rollId)
		lootFrame.rollId = rollId
		lootFrame.rollTime = rollTime
		if canNeed then
			GroupLootFrame_EnableLootButton(lootFrame.need)
		else
			GroupLootFrame_DisableLootButton(lootFrame.need)
		end
		if canGreed then
			GroupLootFrame_EnableLootButton(lootFrame.greed)
		else
			GroupLootFrame_DisableLootButton(lootFrame.greed)
		end
		if canDisenchant then
			GroupLootFrame_EnableLootButton(lootFrame.dis)
		else
			GroupLootFrame_DisableLootButton(lootFrame.dis)
		end
		if bindOnPickUp then
			lootFrame.button:SetBackdropColor(144, 255, 0)
		else
			lootFrame.button:SetBackdropColor(0, 0, 0)
		end
		local color = ITEM_QUALITY_COLORS[quality]
		lootFrame:SetStatusBarColor(color.r, color.g, color.b)
		lootFrame:SetMinMaxValues(0, rollTime)
		lootFrame:SetValue(rollTime)
		lootFrame.button:SetNormalTexture(texture)
		lootFrame.button:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
		lootFrame.name:SetText(name)
		lootFrame:SetScript("OnUpdate", OnUpdate)
		lootFrame:Show()
	elseif event == "CANCEL_LOOT_ROLL" then
		local rollId = ...
		for i, v in pairs(lootFrames) do
			if v.rollId == rollId then
				v.rollId = nil
				v.rollTime = nil
				v:SetScript("OnUpdate", nil)
				v:Hide()
				return
			end
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("START_LOOT_ROLL")
addon:RegisterEvent("CANCEL_LOOT_ROLL")
UIParent:UnregisterEvent("START_LOOT_ROLL")