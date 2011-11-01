----------------------------------------------------------------------------------------
--	alLootFrame(by Allez)
----------------------------------------------------------------------------------------
local lootSlots = {}

local CreateFontString = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, 'ARTWORK')
	fstring:SetFont(aDB["fonts"].loot_frame_font, aDB["fonts"].loot_frame_font_size, aDB["fonts"].loot_frame_font_style)
	return fstring
end

local OnClick = function(self)
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self.id))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		LootFrame.selectedSlot = self.id
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.text:GetText()
		LootSlot(self.id)
	end
end

local OnEnter = function(self)
	if LootSlotIsItem(self.id) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetLootItem(self.id);
		CursorUpdate(self);
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local CreateLootSlot = function(self, id)
	local slot = CreateFrame("Button", nil, self)
	slot:SetPoint('TOPLEFT', 3, -20 - (id - 1) * (aDB["lootroll"].slot_size + 3))
	slot:SetWidth(aDB["lootroll"].slot_size)
	slot:SetHeight(aDB["lootroll"].slot_size)
	aDB.SetStyle(slot)
	
	slot.texture = slot:CreateTexture(nil, "ARTWORK")
	slot.texture:SetPoint('TOPLEFT', slot, 1, -1)
	slot.texture:SetPoint('BOTTOMRIGHT', slot,  -1, 1)
	slot.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	
	slot.text = CreateFontString(slot, font_size, font_style)
	slot.text:SetPoint('LEFT', slot, 'RIGHT', 4, 0)
	slot.text:SetPoint('RIGHT', slot:GetParent(), 'RIGHT', -4, 0)
	slot.text:SetJustifyH('LEFT')
	
	slot.count = CreateFontString(slot, font_size, font_style)
	slot.count:SetPoint('BOTTOMRIGHT', 1, 2)
	
	slot:SetScript("OnClick", OnClick)
	slot:SetScript("OnEnter", OnEnter)
	slot:SetScript("OnLeave", OnLeave)
	slot:Hide()
	return slot
end

local GetLootSlot = function(self, id)
	if not lootSlots[id] then 
		lootSlots[id] = CreateLootSlot(self, id)
	end
	return lootSlots[id]
end

local UpdateLootSlot = function(self, id)
	local lootSlot = GetLootSlot(self, id)
	local texture, item, quantity, quality, locked = GetLootSlotInfo(id)
	local color = ITEM_QUALITY_COLORS[quality]
	lootSlot.quality = quality
	lootSlot.id = id
	lootSlot.texture:SetTexture(texture)
	lootSlot:SetBackdropBorderColor(0, 0, 0)
	lootSlot.text:SetText(item)
	lootSlot.text:SetTextColor(color.r, color.g, color.b)
	if quantity > 1 then
		lootSlot.count:SetText(quantity)
		lootSlot.count:Show()
	else
		lootSlot.count:Hide()
	end
	lootSlot:Show()
end

local OnEvent = function(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name == "AltUI" then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetWidth(aDB["lootroll"].loot_frame_width)
			aDB.SetStyle(self)
			aDB.CreatePanelShadow(self)
			self:SetPoint(unpack(aDB["pos"].loot))
			self:SetFrameStrata('HIGH')
			self:SetToplevel(true)
			self.title = CreateFontString(self, font_size, font_style)
			self.title:SetPoint('TOPLEFT', 3, -4)
			self.title:SetPoint('TOPRIGHT', -16, -4)
			self.title:SetJustifyH('LEFT')
			self.button = CreateFrame("Button", nil, self)
			self.button:SetPoint('TOPRIGHT')
			self.button:SetSize(21, 21)
			self.button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			self.button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
			self.button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
			self.button:SetScript("OnClick", function()
				CloseLoot()
			end)
		end
	elseif event == "LOOT_OPENED" then
		local autoLoot = ...
		self:Show()
		if UnitExists("target") and UnitIsDead("target") then
			self.title:SetText(UnitName("target"))
		else
			self.title:SetText(ITEMS)
		end
		local numLootItems = GetNumLootItems()
		self:SetHeight(numLootItems * (aDB["lootroll"].slot_size + 3) + 20)
		if GetCVar("lootUnderMouse") == "1" then
			local x, y = GetCursorPosition()
			x = x / self:GetEffectiveScale()
			y = y / self:GetEffectiveScale()
			local posX = x - 15
			local posY = y + 32
			if posY < 350 then
				posY = 350
			end
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", posX, posY)
			self:GetCenter()
			self:Raise()
		end
		for i = 1, numLootItems do
			UpdateLootSlot(self, i)
		end
		if not self:IsShown() then
			CloseLoot(autoLoot == 0)
		end
	elseif event == "LOOT_SLOT_CLEARED" then
		local slotId = ...
		if not self:IsShown() then return end
		if slotId > 0 then
			if lootSlots[slotId] then
				lootSlots[slotId]:Hide()
			end
		end
	elseif event == "LOOT_SLOT_CHANGED" then
		local slotId = ...
		UpdateLootSlot(self, slotId)
	elseif event == "LOOT_CLOSED" then
		StaticPopup_Hide("LOOT_BIND")
		for i, v in pairs(lootSlots) do
			v:Hide()
		end
		self:Hide()
	elseif event == "OPEN_MASTER_LOOT_LIST" then
		ToggleDropDownMenu(1, nil, GroupLootDropDown, lootSlots[LootFrame.selectedSlot], 0, 0)
	elseif event == "UPDATE_MASTER_LOOT_LIST" then
		UIDropDownMenu_Refresh(GroupLootDropDown)
	end
end

local addon = CreateFrame("frame", nil, UIParent)
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("LOOT_OPENED")
addon:RegisterEvent("LOOT_SLOT_CLEARED")
addon:RegisterEvent("LOOT_SLOT_CHANGED")
addon:RegisterEvent("LOOT_CLOSED")
addon:RegisterEvent("OPEN_MASTER_LOOT_LIST")
addon:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
LootFrame:UnregisterAllEvents()