if not aDB["minimap"].enable == true then return end
-- Minimap cluster
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(aDB["pos"].minimap))
tinsert(UIMovableFrames, Minimap)
Minimap:SetSize(aDB["minimap"].size, aDB["minimap"].size)
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
aDB.SetStyle(Minimap)
aDB.CreatePanelShadow(Minimap)

-- Tracking icon
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetScale(0.8)
MiniMapTracking:SetPoint('TOPLEFT', Minimap, -3, 1)
MiniMapTrackingButton:SetHighlightTexture(nil)
MiniMapTrackingIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	
-- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('TOP', Minimap, 'TOP', 0, 1)
MiniMapMailIcon:SetTexture('Interface\\AddOns\\AltUI\\media\\mail')
	
-- BG icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint('BOTTOMRIGHT', Minimap, 3, -1)
MiniMapBattlefieldFrame:SetScale(0.8)

-- Instance Difficulty icon
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint('TOPRIGHT', Minimap, 3, 1)
MiniMapInstanceDifficulty:SetScale(0.8)
	
-- Random-group icon
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint('BOTTOMLEFT', Minimap, -3, -1)
	MiniMapLFGFrame:SetScale(0.8)
	MiniMapLFGFrame:SetHighlightTexture(nil)
	MiniMapLFGFrameBorder:Hide()
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)
	
-- Mouse Wheel
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

------------------------------------------	
-- Right click menu
------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPParentFrame) end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = locale.minimap_calendar, 
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

local addonmenu = {
	{text = "AtlasLoot",
    func = function() if IsAddOnLoaded("AtlasLoot") then AtlasLootDefaultFrame:Show() end end},
	{text = "Skada",
    func = function() if IsAddOnLoaded("Skada") then Skada:ToggleWindow() end end},
	{text = "WIM",
    func = function() if IsAddOnLoaded("WIM") then WIM.ShowAllWindows() end end},
	{text = "Omen",
    func = function() if IsAddOnLoaded("Omen") then Omen:Toggle() end end},
	{text = "Recount",
    func = function() if IsAddOnLoaded("Recount") then Recount.MainWindow:Show() end end},
}

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" and not InCombatLockdown() then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	elseif button == "MiddleButton" then
		EasyMenu(addonmenu, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)
	
-- Kill ugly things
aDB.Kill(GameTimeFrame)
aDB.Kill(MinimapBorderTop)
aDB.Kill(MinimapNorthTag)
aDB.Kill(MinimapBorder)
aDB.Kill(MinimapZoneTextButton)
aDB.Kill(MinimapZoomOut)
aDB.Kill(MinimapZoomIn)
aDB.Kill(MiniMapVoiceChatFrame)
aDB.Kill(MiniMapWorldMapButton)
aDB.Kill(MiniMapMailBorder)
aDB.Kill(MiniMapBattlefieldBorder)
aDB.Kill(MiniMapTrackingBackground)
aDB.Kill(MiniMapTrackingButtonBorder)
aDB.Kill(MiniMapInstanceDifficulty)