local _G = _G

local modActionButtonDown = function(id)
	local button
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = true
end
  
local modActionButtonUp = function(id)
	local button
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = false
end

local modMultiActionButtonDown = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = true
end
  
local modMultiActionButtonUp = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = false
end

local modActionButton_UpdateState = function(button)
	local action = button.action
	if not button.bd then return end
	if IsCurrentAction(action) or IsAutoRepeatAction(action) then
		button.checked = true
	else
		button.checked = false
	end
end
  
local setStyle = function(bname)
	local button = _G[bname]
	local icon   = _G[bname.."Icon"]
	local flash  = _G[bname.."Flash"]
	
	flash:SetTexture("")
	button:SetNormalTexture("")
	styleButton(button)
	
	if not button.bd then
		button:SetWidth(aDB["actionbar"].button_size)
		button:SetHeight(aDB["actionbar"].button_size)
		
		local bd = CreateFrame("Frame", nil, button)
		bd:SetPoint('TOPLEFT', 0, 0)
		bd:SetPoint('BOTTOMRIGHT', 0, 0)
		bd:SetFrameStrata('BACKGROUND')
		aDB.SetStyle(bd)
		aDB.CreatePanelShadow(bd)
		button.bd = bd
		
		button:HookScript("OnEnter", function(self)
			self.hover = true
		end)
		button:HookScript("OnLeave", function(self)
			self.hover = false
		end)
	end
	
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint('TOPLEFT', button, 'TOPLEFT', 1, -1)
	icon:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 1)
end

local modActionButton_Update = function(self)
	local action = self.action
	local name = self:GetName()
	local button = self
	local count = _G[name.."Count"]
	local border = _G[name.."Border"]
	local hotkey = _G[name.."HotKey"]
	local macro = _G[name.."Name"]

	border:Hide()
	
	if aDB["actionbar"].macro_text == true then 
		macro:ClearAllPoints()
		macro:SetPoint('BOTTOM', 0, 0)
		macro:SetFont(aDB["fonts"].actionbar_font, aDB["fonts"].actionbar_font_size, aDB["fonts"].actionbar_font_style)
		macro:SetShadowOffset(0, 0)
		macro:SetWidth(aDB["actionbar"].button_size)
		macro:SetHeight(aDB["actionbar"].button_size / 1.5)
	else
		macro:Hide()
	end
	
	count:ClearAllPoints()
	count:SetPoint('BOTTOMRIGHT', 1, 2)
	count:SetFont(aDB["fonts"].actionbar_font, aDB["fonts"].actionbar_font_size, aDB["fonts"].actionbar_font_style)
	
	hotkey:ClearAllPoints()
	hotkey:SetPoint('TOPRIGHT', 0, 2)
	hotkey:SetWidth(aDB["actionbar"].button_size)
	hotkey:SetHeight(aDB["actionbar"].button_size / 2)
	hotkey:SetFont(aDB["fonts"].actionbar_font, aDB["fonts"].actionbar_font_size, aDB["fonts"].actionbar_font_style)
	if aDB["actionbar"].hotkey ~= true then
		hotkey:Hide()
	end

	setStyle(name)
	if IsEquippedAction(action) then
		button.equipped = true
	else
		button.equipped = false
	end
end

local modPetActionBar_Update = function()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]

		setStyle(name)
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		
		local autocast = _G["PetActionButton"..i.."AutoCastable"]
		autocast:SetWidth(aDB["actionbar"].button_size + 25)
		autocast:SetHeight(aDB["actionbar"].button_size + 25)
		autocast:ClearAllPoints()
		autocast:SetPoint('CENTER', button, 0, 0)
		
		local cd = _G["PetActionButton"..i.."Cooldown"]
		cd:ClearAllPoints()
		cd:SetPoint('TOPLEFT', button, 1, -1)
		cd:SetPoint('BOTTOMRIGHT', button, -1, 1)
	end  
end

local buttonNames = {
	"ActionButton",
	"BonusActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"ShapeshiftButton",
	"MultiCastActionButton",
}

for _, name in ipairs( buttonNames ) do
	for index = 1, 20 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]		
 
		if ( button == nil or cooldown == nil ) then
			break;
		end
 
		cooldown:ClearAllPoints()
		cooldown:SetPoint('TOPLEFT', button, 'TOPLEFT', 1, -1)
		cooldown:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 1)
	end
end
  
local modShapeshiftBar_UpdateState = function()    
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
  
		setStyle(name)
		local texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
	end    
end

local modActionButton_UpdateHotkeys = function(self, actionButtonType)
	if (not actionButtonType) then
		actionButtonType = "ACTIONBUTTON"
	end
	local hotkey = _G[self:GetName().."HotKey"]
	local key = GetBindingKey(actionButtonType..self:GetID()) or GetBindingKey("CLICK "..self:GetName()..":LeftButton")
	local text = GetBindingText(key, "KEY_", 1)
	hotkey:SetText(text)
	
	if aDB["actionbar"].hotkey == true then
		hotkey:ClearAllPoints()
		hotkey:SetPoint('TOPRIGHT', 0, 2)
		hotkey:SetWidth(aDB["actionbar"].button_size)
		hotkey:SetHeight(aDB["actionbar"].button_size / 2)
	else
		hotkey:Hide()
	end
end

-- Range coloring
local modActionButton_UpdateUsable = function(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	local isUsable, notEnoughMana = IsUsableAction(action)
	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.8, 0.1, 0.1, 1)
		return
	elseif notEnoughMana then
		icon:SetVertexColor(0.1, 0.3, 1, 1)
		return
	elseif isUsable then
		icon:SetVertexColor(1, 1, 1, 1)
		return
	else
		icon:SetVertexColor(0.4, 0.4, 0.4, 1)
		return
	end
end

local modActionButton_OnUpdate = function(self, elapsed)
	local t = self.mod_range
	if not t then
		self.mod_range = 0
		return
	end
	t = t + elapsed
	if t < 0.1 then
		self.mod_range = t
		return
	else
		self.mod_range = 0
		modActionButton_UpdateUsable(self)
	end
end

ActionButton_OnUpdate = modActionButton_OnUpdate

hooksecurefunc("ActionButton_Update", modActionButton_Update)
hooksecurefunc("ActionButton_UpdateState", modActionButton_UpdateState)
hooksecurefunc("ActionButtonDown", modActionButtonDown)
hooksecurefunc("ActionButtonUp", modActionButtonUp)
hooksecurefunc("MultiActionButtonDown", modMultiActionButtonDown)
hooksecurefunc("MultiActionButtonUp", modMultiActionButtonUp)

hooksecurefunc("ShapeshiftBar_OnLoad", modShapeshiftBar_UpdateState)
hooksecurefunc("ShapeshiftBar_Update", modShapeshiftBar_UpdateState)

hooksecurefunc("PetActionBar_Update", modPetActionBar_Update)

hooksecurefunc("ActionButton_UpdateUsable",   modActionButton_UpdateUsable)

hooksecurefunc("ActionButton_UpdateHotkeys", modActionButton_UpdateHotkeys)

----------------------------------------------------------------------------------------
--	Shaman Totem Bar Skin(by Darth-Android)
----------------------------------------------------------------------------------------
local buttonsize = aDB["actionbar"].button_size
local flyoutsize = 30
local buttonspacing = 4
local borderspacing = 1

local bordercolors = {
	{.23,.45,.13},	-- Earth
	{.58,.23,.10},	-- Fire
	{.19,.48,.60},	-- Water
	{.42,.18,.74},	-- Air
	{.39,.39,.12}	-- Summon / Recall
}

local function SkinFlyoutButton(button)
	button.skin = CreateFrame("Frame", nil, button)
	aDB.SetStyle(button.skin)
	button:GetNormalTexture():SetTexture(nil)
	button:ClearAllPoints()
	button.skin:ClearAllPoints()
	button.skin:SetFrameStrata('LOW')

	button:SetWidth(buttonsize+borderspacing)
	button:SetHeight(buttonspacing * 3 + borderspacing - 1)
	button.skin:SetWidth(buttonsize + borderspacing)
	button.skin:SetHeight(buttonspacing * 2)
	button:SetPoint('BOTTOM', button:GetParent(), 'TOP', 0, 0)    
	button.skin:SetPoint('TOP', button, 'TOP', 0, 0)

	button:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]],"HIGHLIGHT")
	button:GetHighlightTexture():ClearAllPoints()
	button:GetHighlightTexture():SetPoint('TOPLEFT', button.skin, 'TOPLEFT', borderspacing, -borderspacing)
	button:GetHighlightTexture():SetPoint('BOTTOMRIGHT', button.skin, 'BOTTOMRIGHT', -borderspacing, borderspacing)
end

local function SkinActionButton(button, colorr, colorg, colorb)
	aDB.SetStyle(button)
	button:SetBackdropBorderColor(colorr, colorg, colorb)
	button:ClearAllPoints()
	button:SetAllPoints(button.slotButton)
	button.overlay:SetTexture(nil)
	button:GetRegions():SetDrawLayer('ARTWORK')
end

local function SkinButton(button, colorr, colorg, colorb)
	aDB.SetStyle(button)
	if button.actionButton then
		aDB.SetStyle(button.actionButton)
		button.actionButton:SetPushedTexture(nil)
		button.actionButton:SetCheckedTexture(nil)
	end
	button.background:SetDrawLayer('ARTWORK')
	button.background:ClearAllPoints()
	button.background:SetPoint('TOPLEFT', button, 'TOPLEFT', borderspacing, -borderspacing)
	button.background:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -borderspacing, borderspacing)
	button.overlay:SetTexture(nil)
	button:SetSize(buttonsize, buttonsize)
	button:SetBackdropBorderColor(colorr,colorg,colorb)
end

local function SkinSummonButton(button, colorr, colorg, colorb)
	local icon = select(1,button:GetRegions())
	icon:SetDrawLayer('ARTWORK')
	icon:ClearAllPoints()
	icon:SetPoint('TOPLEFT', button, 'TOPLEFT', borderspacing, -borderspacing)
	icon:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -borderspacing, borderspacing)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	select(12, button:GetRegions()):SetTexture(nil)
	select(7, button:GetRegions()):SetTexture(nil)
	aDB.SetStyle(button)
	button:SetSize(buttonsize, buttonsize)
	button:SetPushedTexture(nil)
	button:SetCheckedTexture(nil)
end

local function SkinFlyoutTray(tray)
	local parent = tray.parent
	local buttons = {select(2,tray:GetChildren())}
	local closebutton = tray:GetChildren()
	local numbuttons = 0

	for i,k in ipairs(buttons) do
		local prev = i > 1 and buttons[i-1] or tray

		if k:IsVisible() then numbuttons = numbuttons + 1 end

		if k.icon then
			k.icon:SetDrawLayer('ARTWORK')
			k.icon:ClearAllPoints()
			k.icon:SetPoint('TOPLEFT', k, 'TOPLEFT', borderspacing, -borderspacing)
			k.icon:SetPoint('BOTTOMRIGHT', k, 'BOTTOMRIGHT', -borderspacing, borderspacing)

			aDB.SetStyle(k)
			k:SetBackdropBorderColor(unpack(bordercolors[((parent.idx-1)%5)+1]))
			if k.icon:GetTexture() ~= [[Interface\Buttons\UI-TotemBar]] then
				k.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end

		k:ClearAllPoints()
		k:SetPoint('BOTTOM', prev, 'TOP', 0, buttonspacing)
	end

	tray.middle:SetTexture(nil)
	tray.top:SetTexture(nil)

	aDB.SetStyle(closebutton)
	closebutton:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	closebutton:GetHighlightTexture():SetPoint("TOPLEFT", closebutton, "TOPLEFT", borderspacing, -borderspacing)
	closebutton:GetHighlightTexture():SetPoint("BOTTOMRIGHT", closebutton, "BOTTOMRIGHT", -borderspacing, borderspacing)
	closebutton:GetNormalTexture():SetTexture(nil)

	tray:ClearAllPoints()
	closebutton:ClearAllPoints()
	
	tray:SetWidth(flyoutsize + buttonspacing * 2)
	tray:SetHeight((flyoutsize+buttonspacing) * numbuttons + buttonspacing)
	closebutton:SetHeight(buttonspacing * 2)
	closebutton:SetWidth(tray:GetWidth())

	tray:SetPoint('BOTTOM', parent, 'TOP', 0, buttonspacing + 1)
	closebutton:SetPoint('BOTTOM', tray, 'TOP', 0, 1)
	buttons[1]:SetPoint('BOTTOM', tray, 'BOTTOM', 0, buttonspacing)
end

function pack(...) return {...} end

local AddOn = CreateFrame("Frame")
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
AddOn:SetScript("OnEvent", OnEvent)

function AddOn:PLAYER_ENTERING_WORLD()
	if not aDB.myclass == "SHAMAN" then return end
	local bgframe = CreateFrame("Frame","TotemBG",MultiCastSummonSpellButton)
	bgframe:SetHeight(buttonsize + buttonspacing * 2)
	bgframe:SetWidth(buttonspacing + (buttonspacing + buttonsize) * 6)
	bgframe:SetFrameStrata('LOW')
	bgframe:ClearAllPoints()

	bgframe:SetHeight(buttonsize + buttonspacing * 2)
	bgframe:SetWidth(buttonspacing + (buttonspacing + buttonsize) * 6)
	bgframe:SetPoint("BOTTOMLEFT", MultiCastSummonSpellButton, "BOTTOMLEFT", -buttonspacing, -buttonspacing)

	for i = 1, 12 do
		if i < 6 then
			local button = _G["MultiCastSlotButton"..i] or MultiCastRecallSpellButton
			local prev = _G["MultiCastSlotButton"..(i-1)] or MultiCastSummonSpellButton
			prev.idx = i - 1
			if i == 1 or i == 5 then
				SkinSummonButton(i == 5 and button or prev,unpack(bordercolors[5]))
			end
			if i < 5 then
				SkinButton(button,unpack(bordercolors[((i-1) % 4) + 1]))
			end
			button:ClearAllPoints()
			ActionButton1.SetPoint(button,'LEFT', prev, 'RIGHT', buttonspacing, 0)
		end
		SkinActionButton(_G["MultiCastActionButton"..i],unpack(bordercolors[((i-1) % 4) + 1]))
	end
	MultiCastFlyoutFrame:HookScript("OnShow",SkinFlyoutTray)
	MultiCastFlyoutFrameOpenButton:HookScript("OnShow", function(self) if MultiCastFlyoutFrame:IsShown() then MultiCastFlyoutFrame:Hide() end SkinFlyoutButton(self) end)
	MultiCastFlyoutFrame:SetFrameLevel(4)
end
AddOn:RegisterEvent("PLAYER_ENTERING_WORLD")