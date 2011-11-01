----------------------------------------------------------------------------------------
--	alBags(by Allez)
----------------------------------------------------------------------------------------
local addon = cargBags:NewImplementation("Bags")
local button = addon:GetItemButtonClass()
local container = addon:GetContainerClass()
local bag = addon:GetClass("BagButton", true, "BagButton")

addon:RegisterBlizzard()

function addon:OnInit()
	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyKeyring =	function(item) return item.bagID == -2 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end

	local main = container:New("Main", {
		Columns = 10,
		Scale = 1,
		Bags = "backpack+bags",
	})
	main:SetFilter(onlyBags, true)
	main:SetPoint(unpack(aDB["bags"].inventory))

	local bank = container:New("Bank", {
		Columns = 12,
		Scale = 1,
		Bags = "bankframe+bank",
	})
	bank:SetFilter(onlyBank, true)
	bank:SetPoint(unpack(aDB["bags"].bank))
	bank:Hide()
end

function addon:OnBankOpened()
	self:GetContainer("Bank"):Show()
end

function addon:OnBankClosed()
	self:GetContainer("Bank"):Hide()
end

function button:OnCreate()
	self:SetPushedTexture("")
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetSize(aDB["bags"].button_size, aDB["bags"].button_size)
	styleBagButton(self)
	aDB.SetStyle(self)
	
	self.Count:SetPoint('BOTTOMRIGHT', 0, 1)
	self.Count:SetFont(aDB["fonts"].bags_font, aDB["fonts"].bags_font_size, aDB["fonts"].bags_font_style)
	
	self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.Icon:SetPoint('TOPLEFT', 1, -1)
	self.Icon:SetPoint('BOTTOMRIGHT', -1, 1)
	self:HookScript('OnEnter', function()
		self.oldColor = {self:GetBackdropBorderColor()}
	end)
	self:HookScript('OnLeave', function()
		self:SetBackdropBorderColor(unpack(self.oldColor))
	end)
	_G[self:GetName()..'IconQuestTexture']:SetSize(0.01, 0.01)
end

function button:OnUpdate(item)
	if item.questID or item.isQuestItem then
		self:SetBackdropBorderColor(1, 1, 0, 1)
	elseif item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self:SetBackdropBorderColor(r, g, b, 1)
	else
		self:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	end
end

function container:OnContentsChanged()
	self:SortButtons("bagSlot")
	local width, height = self:LayoutButtons('grid', self.Settings.Columns, 3, 7, -7)
	self:SetSize(width + 14, height + 34)
end

function container:OnCreate(name, settings)
	self.Settings = settings
	self:EnableMouse(true)
	self:SetClampedToScreen(true)
	self:SetParent(addon)
	self:SetFrameStrata('HIGH')
	settings.Columns = settings.Columns or 8
	
	aDB.SetStyle(self)
	aDB.CreatePanelShadow(self)

	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint('BOTTOMLEFT', 7, 0)
	infoFrame:SetPoint('BOTTOMRIGHT', -7, 0)
	infoFrame:SetHeight(25)

	local space = self:SpawnPlugin("TagDisplay", "[space:free/max] free", infoFrame)
	space:SetFont(aDB["fonts"].bags_font, aDB["fonts"].bags_font_size, aDB["fonts"].bags_font_style)
	space:SetPoint('RIGHT', infoFrame, 'RIGHT')
	space:SetShadowColor(0, 0, 0, 0)
	space:SetShadowOffset(0, 0)
	space.bags = cargBags:ParseBags(settings.Bags)
	
	local tagDisplay = self:SpawnPlugin("TagDisplay", "[currencies][money]", infoFrame)
	tagDisplay:SetFont(aDB["fonts"].bags_font, aDB["fonts"].bags_font_size, aDB["fonts"].bags_font_style)
	tagDisplay:SetPoint('LEFT', infoFrame, 'LEFT')
	tagDisplay:SetShadowColor(0, 0, 0, 0)
	tagDisplay:SetShadowOffset(0, 0)

	local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
	local width, height = bagBar:LayoutButtons('grid', 4, 7, 7, -7)
	bagBar:SetSize(width + 14, height + 14)
	aDB.SetStyle(bagBar)
	aDB.CreatePanelShadow(bagBar)
	if (name == "Bank") then
		bagBar:SetPoint('TOPLEFT', self, 'TOPRIGHT', 2, 0)
	else
		bagBar:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 42)
	end

	local search = self:SpawnPlugin("SearchBar", infoFrame)
	aDB.SetStyle(search)
end

function bag:OnCreate()
	self:SetPushedTexture("")
	self:SetNormalTexture("")
	self:SetCheckedTexture("")
	self:SetHighlightTexture("")
	self:SetSize(aDB["bags"].bag_button_size, aDB["bags"].bag_button_size)
	styleBagButton(self)
	aDB.SetStyle(self)
	
	self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.Icon:SetPoint('TOPLEFT', 1, -1)
	self.Icon:SetPoint('BOTTOMRIGHT', -1, 1)
	self:HookScript('OnEnter', function()
		self.oldColor = {self:GetBackdropBorderColor()}
	end)
	self:HookScript('OnLeave', function()
		self:SetBackdropBorderColor(unpack(self.oldColor))
		self:OnUpdate()
	end)
end

function bag:OnUpdate()
	if self:GetChecked() then
		self:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	else
		self:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	end
end