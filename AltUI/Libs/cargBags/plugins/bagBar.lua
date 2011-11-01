--[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION
	A collection of buttons for the bags.

	The buttons are not positioned automatically, use the standard-
	function :LayoutButtons() for this
DEPENDENCIES
	mixins/plugins
	mixins/layout (optional)
	mixins/parseBags (optional)
	mixins/filters (optional)
CALLBACKS
	BagButton:OnCreate(bagID)

]]

local BagButton = cargBags:NewClass("BagButton", nil, "CheckButton")

-- Default attributes
BagButton.checkedTex = [[Interface\Buttons\CheckButtonHilight]]
BagButton.bgTex = [[Interface\Paperdoll\UI-PaperDoll-Slot-Bag]]
BagButton.itemFadeAlpha = 0.1

local buttonNum = 0
function BagButton:Create(bagID)
	buttonNum = buttonNum+1
	local name = "cargBagsBagButton"..buttonNum

	local button = setmetatable(CreateFrame("CheckButton", name, nil, "ItemButtonTemplate"), self.__index)

	local invID = ContainerIDToInventoryID(bagID)
	button.invID = invID
	button:SetID(invID)
	button.bagID = bagID

	button:RegisterForDrag("LeftButton", "RightButton")
	button:RegisterForClicks("anyUp")
	button:SetCheckedTexture(self.checkedTex, "ADD")

	button:SetSize(37, 37)

	button.Icon = 		_G[name.."IconTexture"]
	button.Count = 		_G[name.."Count"]
	button.Cooldown = 	_G[name.."Cooldown"]
	button.Quest = 		_G[name.."IconQuestTexture"]
	button.Border =		_G[name.."NormalTexture"]

	cargBags.SetScriptHandlers(button, "OnClick", "OnReceiveDrag", "OnEnter", "OnLeave", "OnDragStart")

	if(button.OnCreate) then button:OnCreate(bagID) end

	return button
end

function BagButton:Update()
	local icon = GetInventoryItemTexture("player", self.invID)
	self.Icon:SetTexture(icon or self.bgTex)
	self.Icon:SetDesaturated(IsInventoryItemLocked(self.invID))

	if(self.bagID > NUM_BAG_SLOTS) then
		if(self.bagID-NUM_BAG_SLOTS <= GetNumBankSlots()) then
			self.Icon:SetVertexColor(1, 1, 1)
			self.notBought = nil
		else
			self.notBought = true
			self.Icon:SetVertexColor(1, 0, 0)
		end
	end

	self:SetChecked(not self.hidden and not self.notBought)

	if(self.OnUpdate) then self:OnUpdate() end
end

function BagButton.HighlightFunction(button, bagID, fadeAlpha)
	if(not bagID or bagID == button.bagID) then
		button:SetAlpha(1)
	else
		button:SetAlpha(fadeAlpha)
	end
end

function BagButton:OnEnter()
	if(self.HighlightFunction) then
		self.bar.container:ApplyToButtons(self.HighlightFunction, self.bagID, self.itemFadeAlpha)
	end
	BagSlotButton_OnEnter(self)
end

function BagButton:OnLeave()
	if(self.HighlightFunction) then
		self.bar.container:ApplyToButtons(self.HighlightFunction, nil, self.itemFadeAlpha)
	end
	GameTooltip:Hide()
end

function BagButton:OnClick()
	if(self.notBought) then
		self:SetChecked(nil)
		BankFrame.nextSlotCost = GetBankSlotCost(GetNumBankSlots())
		return StaticPopup_Show("CONFIRM_BUY_BANK_SLOT")
	end

	if(PutItemInBag(self.invID)) then return end

	local container = self.bar.container
	if(container and container.filters) then
		if(not self.filter) then
			local bagID = self.bagID
			self.filter = function(i) return i.bagID ~= bagID end
		end
		self.hidden = not self.hidden
		container.filters[self.filter] = not container.filters[self.filter]
		container.implementation:OnEvent("BAG_UPDATE", self.bagID)
	end
end
BagButton.OnReceiveDrag = BagButton.OnClick

function BagButton:OnDragStart()
	PickupBagFromSlot(self.invID)
end

-- Updating the icons
local function updater(self, event)
	for i, button in pairs(self.buttons) do
		button:Update()
	end
end

local function onLock(self, event, bagID, slotID)
	if(bagID == -1 and slotID > NUM_BANKGENERIC_SLOTS) then
		bagID, slotID = ContainerIDToInventoryID(slotID-NUM_BANKGENERIC_SLOTS+NUM_BAG_SLOTS)
	end
	
	if(slotID) then return end

	for i, button in pairs(self.buttons) do
		if(button.invID == bagID) then
			return button:Update()
		end
	end
end

local disabled = {
	[-2] = true,
	[-1] = true,
	[0] = true,
}

-- Register the plugin
cargBags:RegisterPlugin("BagBar", function(self, bags)
	if(cargBags.ParseBags) then
		bags = cargBags:ParseBags(bags)
	end

	local bar = CreateFrame("Frame",  nil, self)
	bar.container = self

	bar.layouts = cargBags.classes.Container.layouts
	bar.LayoutButtons = cargBags.classes.Container.LayoutButtons

	local buttonClass = self.implementation:GetClass("BagButton", true, "BagButton")
	bar.buttons = {}
	for i=1, #bags do
		if(not disabled[bags[i]]) then -- Temporary until I include fake buttons for backpack, bankframe and keyring
			local button = buttonClass:Create(bags[i])
			button:SetParent(bar)
			button.bar = bar
			table.insert(bar.buttons, button)
		end
	end

	self.implementation:RegisterCallback("BAG_UPDATE", bar, updater)
	self.implementation:RegisterCallback("PLAYERBANKBAGSLOTS_CHANGED", bar, updater)
	self.implementation:RegisterCallback("ITEM_LOCK_CHANGED", bar, onLock)

	return bar
end)
