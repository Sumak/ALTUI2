------------------------------------------	
-- Bar holders
------------------------------------------
local Bar1 = CreateFrame("Frame", "Bar1Holder", UIParent)
Bar1:SetWidth((aDB["actionbar"].button_size * 12) + 33)
Bar1:SetHeight(aDB["actionbar"].button_size + 2)
Bar1:SetPoint(unpack(aDB["actionbar"].bar1))
Bar1:Show()
tinsert(UIMovableFrames, Bar1)

local Bar2 = CreateFrame("Frame", "Bar2Holder", UIParent)
Bar2:SetWidth((aDB["actionbar"].button_size * 12) + 33)
Bar2:SetHeight(aDB["actionbar"].button_size + 2)
Bar2:SetPoint(unpack(aDB["actionbar"].bar2))
Bar2:Show()
tinsert(UIMovableFrames, Bar2)

local Bar3 = CreateFrame("Frame", "Bar3Holder", UIParent)
Bar3:SetHeight((aDB["actionbar"].button_size * 12) + 33)
Bar3:SetWidth(aDB["actionbar"].button_size + 2)
Bar3:Show()
tinsert(UIMovableFrames, Bar3)

local Bar45 = CreateFrame("Frame", "Bar45Holder", UIParent)
Bar45:SetWidth((aDB["actionbar"].button_size * 3) + 6)
Bar45:SetHeight((aDB["actionbar"].button_size * 12) + 33)
Bar45:SetPoint(unpack(aDB["actionbar"].bar45)) 
Bar45:Show()
tinsert(UIMovableFrames, Bar45)

local Pet = CreateFrame("Frame", "PetBarHolder", UIParent)
Pet:SetWidth(aDB["actionbar"].button_size + 2)
Pet:SetHeight((aDB["actionbar"].button_size * 10) + 27)
if aDB["actionbar"].rightbars == 1 then
	Pet:SetPoint('RIGHT', UIParent, 'RIGHT', -31, -100)
elseif aDB["actionbar"].rightbars == 2 then
	Pet:SetPoint('RIGHT', UIParent, 'RIGHT', -61, -100)
elseif aDB["actionbar"].rightbars > 2 then
	Pet:SetPoint('RIGHT', UIParent, 'RIGHT', -91, -100)
end
tinsert(UIMovableFrames, Pet)

local ShiftBar = CreateFrame("Frame", "ShapeShiftHolder", UIParent)
ShiftBar:SetWidth(196)
ShiftBar:SetHeight(aDB["actionbar"].button_size + 2)
ShiftBar:SetPoint(unpack(aDB["actionbar"].stance))
tinsert(UIMovableFrames, ShiftBar)

------------------------------------------	
-- Vehicle button
------------------------------------------
local vehicle = CreateFrame("BUTTON", nil, UIParent, "SecureActionButtonTemplate")
vehicle:SetWidth(aDB["actionbar"].button_size)
vehicle:SetHeight(aDB["actionbar"].button_size)
vehicle:SetPoint(unpack(aDB["actionbar"].vehicle)) 
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function(self) VehicleExit() end)
vehicle:SetNormalTexture('Interface\\AddOns\\AltUI\\media\\vehicle')
vehicle:SetPushedTexture('Interface\\AddOns\\AltUI\\media\\vehicle')
vehicle:SetHighlightTexture('Interface\\AddOns\\AltUI\\media\\vehicle')
vehicle:RegisterEvent("UNIT_ENTERING_VEHICLE")
vehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
vehicle:RegisterEvent("UNIT_EXITING_VEHICLE")
vehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
vehicle:SetScript("OnEvent", function(self, event, ...)
local arg1 = ...;
	if(((event == "UNIT_ENTERING_VEHICLE") or (event == "UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
		vehicle:SetAlpha(1)
	elseif(((event == "UNIT_EXITING_VEHICLE") or (event == "UNIT_EXITED_VEHICLE")) and arg1 == "player") then
		vehicle:SetAlpha(0)
	end
end)  
vehicle:SetAlpha(0)
aDB.SetStyle(vehicle)
aDB.CreatePanelShadow(vehicle)

------------------------------------------	
-- General action bars
------------------------------------------
local i, f

for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(Bar1)
end
ActionButton1:ClearAllPoints()
ActionButton1:SetPoint('BOTTOMLEFT', Bar1, 'BOTTOMLEFT', 0, 0)
for i = 2, 12 do
	local b = _G["ActionButton"..i]
	local b2 = _G["ActionButton"..i - 1]
	b:ClearAllPoints()
	b:SetPoint('LEFT', b2, 'RIGHT', aDB["actionbar"].spacing, 0)
end

BonusActionBarFrame:SetParent(Bar1)
BonusActionBarFrame:SetWidth(0.01)
BonusActionBarTexture0:Hide()
BonusActionBarTexture1:Hide()

BonusActionButton1:ClearAllPoints()
BonusActionButton1:SetPoint('BOTTOMLEFT', Bar1, 'BOTTOMLEFT', 0, 0)
for i = 2, 12 do
	local b = _G["BonusActionButton"..i]
	local b2 = _G["BonusActionButton"..i - 1]
	b:ClearAllPoints()
	b:SetPoint('LEFT', b2, 'RIGHT', aDB["actionbar"].spacing, 0)
end

MultiBarBottomLeftButton1:ClearAllPoints()
MultiBarBottomLeftButton1:SetPoint('BOTTOMLEFT', Bar2, 'BOTTOMLEFT', 0, 0)
for i = 2, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i - 1]
	b:ClearAllPoints()
	b:SetPoint('LEFT', b2, 'RIGHT', aDB["actionbar"].spacing, 0)
end

if aDB["actionbar"].rightbars == 0 then
	Bar45Holder:Hide()
end

MultiBarRight:SetParent(Bar45)
MultiBarRight:ClearAllPoints()
if aDB["actionbar"].rightbars > 0 then
	MultiBarRightButton1:ClearAllPoints()
	MultiBarRightButton1:SetPoint('TOPRIGHT', Bar45, 'TOPRIGHT', 0, 0)
	for i = 2, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i - 1]
		b:ClearAllPoints()
		b:SetPoint('TOP', b2, 'BOTTOM', 0, -aDB["actionbar"].spacing)
	end
end

MultiBarLeft:SetParent(Bar45)
MultiBarLeft:ClearAllPoints()
if aDB["actionbar"].rightbars > 1 then
	MultiBarLeftButton1:ClearAllPoints()
	MultiBarLeftButton1:SetPoint('TOPRIGHT', Bar45, 'TOPRIGHT', -(aDB["actionbar"].button_size + 3), 0)
	for i = 2, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i - 1]
		b:ClearAllPoints()
		b:SetPoint('TOP', b2, 'BOTTOM', 0, -aDB["actionbar"].spacing)
	end
end

MultiBarBottomRight:SetParent(Bar45)
MultiBarBottomRight:ClearAllPoints()
if aDB["actionbar"].rightbars > 2 then
	MultiBarBottomRightButton1:ClearAllPoints()
	MultiBarBottomRightButton1:SetPoint('TOPRIGHT', Bar45, 'TOPRIGHT', -((aDB["actionbar"].button_size * 2) + 6), 0)
	for i = 2, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i - 1]
		b:ClearAllPoints()
		b:SetPoint('TOP', b2, 'BOTTOM', 0, -aDB["actionbar"].spacing)
	end
end

ShapeshiftBarFrame:SetParent(ShiftBar)
ShapeshiftButton1:ClearAllPoints()
ShapeshiftButton1:SetPoint('BOTTOMLEFT', ShiftBar, 'BOTTOMLEFT', 0, 0)
local function MoveShapeshift()
	ShapeshiftButton1:SetPoint('BOTTOMLEFT', ShiftBar, 'BOTTOMLEFT', 0, 0)
end
if not InCombatLockdown() then
	hooksecurefunc("ShapeshiftBar_Update", MoveShapeshift)
end
for i = 2, 10 do
	local b = _G["ShapeshiftButton"..i]
	local b2 = _G["ShapeshiftButton"..i - 1]
	b:ClearAllPoints()
	b:SetPoint('LEFT', b2, 'RIGHT', aDB["actionbar"].spacing, 0)
end
PossessBarFrame:SetParent(ShiftBar)
PossessButton1:ClearAllPoints()
PossessButton1:SetPoint('BOTTOMLEFT', ShiftBar, 'BOTTOMLEFT')

PetActionBarFrame:SetParent(Pet)
PetActionButton1:ClearAllPoints()
PetActionButton1:SetPoint('TOPRIGHT', Pet, 'TOPRIGHT', 0, 0)
for i = 2, 10 do
	local b = _G["PetActionButton"..i]
	local b2 = _G["PetActionButton"..i - 1]
	b:ClearAllPoints()
	b:SetPoint('TOP', b2, 'BOTTOM', 0, -aDB["actionbar"].spacing)
end

local function showhideactionbuttons(alpha)
	local f = "ActionButton"
	for i = 1, 12 do
		_G[f..i]:SetAlpha(alpha)
	end
end
BonusActionBarFrame:HookScript("OnShow", function(self) showhideactionbuttons(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) showhideactionbuttons(1) end)
if BonusActionBarFrame:IsShown() then
	showhideactionbuttons(0)
end

local function showhiderightbar(alpha)
	if MultiBarLeft:IsShown() then
		for i = 1, 12 do
			local pb = _G["MultiBarLeftButton"..i]
			pb:SetAlpha(alpha)
		end
	end

	if MultiBarRight:IsShown() then
		for i = 1, 12 do
			local pb = _G["MultiBarRightButton"..i]
			pb:SetAlpha(alpha)
		end
	end

	if MultiBarBottomRight:IsShown() then
		for i = 1, 12 do
			local pb = _G["MultiBarBottomRightButton"..i]
			pb:SetAlpha(alpha)
		end
	end

	for i = 1, NUM_PET_ACTION_SLOTS do
		local pb = _G["PetActionButton"..i]
			pb:SetAlpha(alpha)
	end
end

if aDB["actionbar"].rightbars_mouseover == true then
	Bar45:EnableMouse(true)
	Bar45:SetScript("OnEnter", function(self) showhiderightbar(1) end)
	Bar45:SetScript("OnLeave", function(self) showhiderightbar(0) end)
	
	Bar3:EnableMouse(true)
	Bar3:SetScript("OnEnter", function(self) showhiderightbar(1) end)
	Bar3:SetScript("OnLeave", function(self) showhiderightbar(0) end)
	for i = 1, 12 do
		local pb = _G["MultiBarBottomRightButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) showhiderightbar(1) end)
		pb:HookScript("OnLeave", function(self) showhiderightbar(0) end)
	end
	
	for i = 1, 12 do
		local pb = _G["MultiBarLeftButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) showhiderightbar(1) end)
		pb:HookScript("OnLeave", function(self) showhiderightbar(0) end)
		local pb = _G["MultiBarRightButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) showhiderightbar(1) end)
		pb:HookScript("OnLeave", function(self) showhiderightbar(0) end)
	end
	
	Pet:EnableMouse(true)
	Pet:SetScript("OnEnter", function(self) showhiderightbar(1) end)
	Pet:SetScript("OnLeave", function(self) showhiderightbar(0) end)  
	for i = 1, NUM_PET_ACTION_SLOTS do
		local pb = _G["PetActionButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) showhiderightbar(1) end)
		pb:HookScript("OnLeave", function(self) showhiderightbar(0) end)
	end
end

if aDB["actionbar"].petbar_mouseover == true then
	Pet:EnableMouse(true)
	Pet:SetScript("OnEnter", function(self) showhidepetbar(1) end)
	Pet:SetScript("OnLeave", function(self) showhidepetbar(0) end)  
	for i = 1, NUM_PET_ACTION_SLOTS do
		local pb = _G["PetActionButton"..i]
		pb:SetAlpha(0)
		pb:HookScript("OnEnter", function(self) showhidepetbar(1) end)
		pb:HookScript("OnLeave", function(self) showhidepetbar(0) end)
	end
end

-- Kill func
aDB.Kill(MainMenuBar)
aDB.Kill(VehicleMenuBar)
InterfaceOptionsActionBarsPanelBottomLeft:Hide()
InterfaceOptionsActionBarsPanelBottomRight:Hide()
InterfaceOptionsActionBarsPanelRight:Hide()
InterfaceOptionsActionBarsPanelRightTwo:Hide()
InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Hide()
SlidingActionBarTexture0:SetTexture(nil)
SlidingActionBarTexture1:SetTexture(nil)
ShapeshiftBarLeft:SetTexture(nil)
ShapeshiftBarRight:SetTexture(nil)
ShapeshiftBarMiddle:SetTexture(nil)

----------------------------------------------------------------------------------------
--	aTotemBar(by Arimis) 
----------------------------------------------------------------------------------------
local BlizzardTimers = true 
local aTotemBarTimers = true
local spacing = 8

if not aDB.myclass == "SHAMAN" then return end

local aTotemBar = CreateFrame("Frame", "aTotemBar", UIParent)
aTotemBar:SetWidth(200)
aTotemBar:SetHeight(aDB["actionbar"].button_size + 2)
aTotemBar:SetPoint(unpack(aDB["actionbar"].totem_bar))
tinsert(UIMovableFrames, aTotemBar)

MultiCastActionBarFrame:SetParent(aTotemBar)
MultiCastActionBarFrame:SetWidth(0.01)

MultiCastSummonSpellButton:SetParent(aTotemBar)
MultiCastSummonSpellButton:ClearAllPoints()
MultiCastSummonSpellButton:SetPoint('BOTTOMLEFT', aTotemBar, 5, 5)

for i=1, 4 do
	_G["MultiCastSlotButton"..i]:SetParent(aTotemBar)
end
MultiCastSlotButton1:ClearAllPoints()
MultiCastSlotButton1:SetPoint('LEFT', MultiCastSummonSpellButton, 'RIGHT', spacing, 0)
for i=2, 4 do
	local b = _G["MultiCastSlotButton"..i]
	local b2 = _G["MultiCastSlotButton"..i-1]
	b:ClearAllPoints()
	b:SetPoint('LEFT', b2, 'RIGHT', spacing, 0)
end	
MultiCastRecallSpellButton:ClearAllPoints()
MultiCastRecallSpellButton:SetPoint('LEFT', MultiCastSlotButton4, 'RIGHT', spacing, 0)

for i=1, 12 do
	local b = _G["MultiCastActionButton"..i]
	local b2 = _G["MultiCastSlotButton"..(i % 4 == 0 and 4 or i % 4)]
	b:ClearAllPoints()
	b:SetPoint('CENTER', b2, 'CENTER', 0, 0)
end

local dummy = function() return end
for i=1, 4 do
	local b = _G["MultiCastSlotButton"..i]
	b.SetParent = dummy
	b.SetPoint = dummy
end
MultiCastRecallSpellButton.SetParent = dummy
MultiCastRecallSpellButton.SetPoint = dummy

local defaults = { Anchor = 'CENTER', X = 0, Y = 0, Scale = 1.0, Hide = false }

local TotemTimers = {};
TotemTimers[1] = CreateFrame("Cooldown","TotemTimers1",MultiCastSlotButton2)
TotemTimers[2] = CreateFrame("Cooldown","TotemTimers2",MultiCastSlotButton1)
TotemTimers[3] = CreateFrame("Cooldown","TotemTimers3",MultiCastSlotButton3)
TotemTimers[4] = CreateFrame("Cooldown","TotemTimers4",MultiCastSlotButton4)
TotemTimers[1]:SetAllPoints(MultiCastSlotButton2)
TotemTimers[2]:SetAllPoints(MultiCastSlotButton1)
TotemTimers[3]:SetAllPoints(MultiCastSlotButton3)
TotemTimers[4]:SetAllPoints(MultiCastSlotButton4)

aTotemBar:RegisterEvent("VARIABLES_LOADED")
aTotemBar:RegisterEvent("PLAYER_ENTERING_WORLD")
aTotemBar:RegisterEvent("PLAYER_TOTEM_UPDATE")

aTotemBar:SetScript("OnEvent", function(self,event,...)
    if ( event == "VARIABLES_LOADED" ) then
        aTotemBar_LoadVariables();
    elseif (event=="PLAYER_ENTERING_WORLD") then
		if HasMultiCastActionBar() == false then
			aTotemBar:Hide()
		else
			aTotemBar:Show()
		end
		for i=1, MAX_TOTEMS do
			aTotemBar_Update(i);
		end
	elseif (event=="PLAYER_TOTEM_UPDATE") then
        aTotemBar_Update(select(1,...));
    end
end)

aTotemBar:SetScript("OnMouseDown",function()
	aTotemBar:StartMoving()
end)

aTotemBar:SetScript("OnMouseUp",function()
	aTotemBar:StopMovingOrSizing()
end)

function aTotemBar_Destroy(self, button)
	if (button ~= "RightButton") then return end
	if (self:GetName() == "MultiCastActionButton1") or (self:GetName() == "MultiCastActionButton5") or (self:GetName() == "MultiCastActionButton9") then
		DestroyTotem(2);
	elseif (self:GetName() == "MultiCastActionButton2") or (self:GetName() == "MultiCastActionButton6") or (self:GetName() == "MultiCastActionButton10") then
		DestroyTotem(1);
	elseif (self:GetName() == "MultiCastActionButton3") or (self:GetName() == "MultiCastActionButton7") or (self:GetName() == "MultiCastActionButton11") then
		DestroyTotem(3);
	elseif (self:GetName() == "MultiCastActionButton4") or (self:GetName() == "MultiCastActionButton8") or (self:GetName() == "MultiCastActionButton12") then
		DestroyTotem(4);
	end
end

for i = 1, 12 do
	hooker = _G["MultiCastActionButton"..i];
	hooker:HookScript("OnClick", aTotemBar_Destroy)
end

function aTotemBar_LoadVariables(event)
	if not aTotemBarDB then
		aTotemBarDB = defaults
	end 
	db = aTotemBarDB

	aTotemBar:SetScale(db.Scale)
	aTotemBar:SetPoint(db.Anchor,"UIParent",db.Anchor,db.X, db.Y)
	
	if (db.Hide == true) then
		aTotemBar:SetScale(0.0001)
		aTotemBar:SetAlpha(0.0)
	end
end

function aTotemBar_Update(totemN)
	if BlizzardTimers == false then
		TotemFrame:Hide()
	end
	if aTotemBarTimers == true then
		haveTotem, totemName, startTime, duration = GetTotemInfo(totemN)
       		if (duration == 0) then
			TotemTimers[totemN]:SetCooldown(0, 0);
		else
			TotemTimers[totemN]:SetCooldown(startTime, duration)
		end
	end
end