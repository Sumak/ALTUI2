----------------------------------------------------------------------------------------
--	Based on m_Map(by Monolit)
----------------------------------------------------------------------------------------
WORLDMAP_RATIO_MINI = 0.75
WORLDMAP_WINDOWED_SIZE = WORLDMAP_RATIO_MINI

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("WORLD_MAP_UPDATE")

local SmallerMap = GetCVarBool("miniWorldMap")
if SmallerMap == nil then
	SetCVar("miniWorldMap", 1)
end

local MoveMap = GetCVarBool("advancedWorldMap")
if MoveMap == nil then
	SetCVar("advancedWorldMap", 1)
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		SetCVar("questPOI", 1)
		SetCVar("advancedWorldMap", 1)
		WorldMapBlobFrame.Show = aDB.dummy
		WorldMapBlobFrame.Hide = aDB.dummy
	elseif event == "WORLD_MAP_UPDATE" then
		if (GetNumDungeonMapLevels() == 0) then
			WorldMapLevelUpButton:Hide()
			WorldMapLevelDownButton:Hide()
		else
			WorldMapLevelUpButton:Show()
			WorldMapLevelDownButton:Show()
			WorldMapLevelUpButton:ClearAllPoints()
			WorldMapLevelUpButton:SetPoint('TOPLEFT', WorldMapFrameCloseButton, 'BOTTOMLEFT', 8, 8)
			WorldMapLevelUpButton:SetFrameStrata('MEDIUM')
			WorldMapLevelUpButton:SetFrameLevel(90)
			WorldMapLevelDownButton:ClearAllPoints()
			WorldMapLevelDownButton:SetPoint('TOP', WorldMapLevelUpButton, 'BOTTOM', 0, -2)
			WorldMapLevelDownButton:SetFrameStrata('MEDIUM')
			WorldMapLevelDownButton:SetFrameLevel(90)
		end
	end
end)

local MapShrink = function()
	local WorldMapScaleDown = WORLDMAP_RATIO_MINI
	local bgframe = CreateFrame("Frame", nil, WorldMapButton)
	aDB.SetStyle(bgframe)
	aDB.CreatePanelShadow(bgframe)
	bgframe:SetFrameStrata('LOW')
	bgframe:SetScale (1 / WORLDMAP_RATIO_MINI)
	bgframe:SetPoint('TOPLEFT', WorldMapButton , 'TOPLEFT', -1, 1)
	bgframe:SetPoint('BOTTOMRIGHT', WorldMapButton , 'BOTTOMRIGHT', 1, -1)

	WorldMapPositioningGuide:ClearAllPoints()
	WorldMapPositioningGuide:SetPoint('TOP', UIParent, 'TOP', 0, -30)
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint(unpack(aDB["pos"].map))
	WorldMapButton:SetScale(WorldMapScaleDown)
	WorldMapFrameAreaFrame:SetScale(WorldMapScaleDown)
	WorldMapPOIFrame.ratio = WorldMapScaleDown
	WorldMapTitleButton:Show()
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint('BOTTOMRIGHT', WorldMapButton, 'BOTTOMRIGHT')
	WorldMapFrameCloseButton:SetFrameStrata('HIGH')
	WorldMapFrameCloseButton:Hide()
	WorldMapFrameSizeDownButton:SetPoint('TOPRIGHT', WorldMapFrameMiniBorderRight, 'TOPRIGHT', -66, 5)
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint('TOPLEFT', WorldMapDetailFrame, 3, -1)
	WorldMapFrameTitle:SetFontObject("GameFontNormal")
	WorldMapFrameTitle:SetFont(aDB["fonts"].simple_font, 16, aDB["fonts"].simple_font_style)
	WorldMapFrameTitle:SetParent(WorldMapDetailFrame)
	WorldMapTitleButton:SetFrameStrata('TOOLTIP')
	WorldMapTitleButton:ClearAllPoints()
	WorldMapTitleButton:SetPoint('TOP', WorldMapFrame, 'TOP', 0, -18)
	WorldMapTooltip:SetFrameStrata('TOOLTIP')
	WorldMapFrame_SetPOIMaxBounds()
	WorldMapQuestShowObjectivesText:SetFontObject("GameFontNormal")
	WorldMapQuestShowObjectivesText:SetFont(aDB["fonts"].simple_font, 16, aDB["fonts"].simple_font_style)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint('BOTTOMRIGHT', WorldMapButton, 'BOTTOMRIGHT', 0, 4)
	WorldMapQuestShowObjectives:SetParent(WorldMapDetailFrame)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint('RIGHT', WorldMapQuestShowObjectivesText, 'LEFT', 0, 0)
	WorldMapQuestShowObjectives:SetFrameStrata('TOOLTIP')
	WorldMapQuestShowObjectives:SetFrameLevel(20)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOMLEFT', 0, 0)
	WorldMapTrackQuest:SetFrameStrata('TOOLTIP')
	WorldMapTrackQuest:SetFrameLevel(20)
	WorldMapTrackQuestText:SetFontObject("GameFontNormal")
	WorldMapTrackQuestText:SetFont(aDB["fonts"].simple_font, 16, aDB["fonts"].simple_font_style)
	
	-- 3.3.3, hide the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.0001)
	-- Fix tooltip not hidding after leaving quest
	WorldMapQuestPOI_OnLeave = function()
		WorldMapTooltip:Hide()
	end
end
hooksecurefunc("WorldMap_ToggleSizeDown", MapShrink)

----------------------------------------------------------------------------------------
--	Creating Coords
----------------------------------------------------------------------------------------
local c = CreateFrame("Frame", "Coords", UIParent)
local player, cursor
local function gen_string(point, X, Y)
	local t = CoordPanel1:CreateFontString(nil, 'ARTWORK')
	t:SetFont(aDB["fonts"].worldmap_font, aDB["fonts"].worldmap_font_size, aDB["fonts"].worldmap_font_style)
	t:SetShadowOffset(0,0)
	t:SetShadowColor(0, 0, 0, 0)
	t:SetPoint(point, WorldMapButton, X, Y)
	t:SetTextColor(0.33, 0.59, 0.33)
	t:SetJustifyH('LEFT')
	return t
end
local function Cursor()
	local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
	return cx, cy
end
local function OnUpdate(player, cursor)
	local cx, cy = Cursor()
	local px, py = GetPlayerMapPosition("player")
	if cx and cy then
		cursor:SetFormattedText('Курсор X:%.2d, Y:%.2d', 100 * cx, 100 * cy)
	else
		cursor:SetText(locale.worldmap_coord1)
	end
	if px == 0 or py == 0 then
		player:SetText(locale.worldmap_coold2)
	else
		player:SetFormattedText('Игрок X:%.2d, Y:%.2d', 100 * px, 100 * py)
	end
	if WorldMapQuestScrollFrame:IsShown() then
		player:SetPoint('BOTTOM', -140, 7)
		cursor:SetPoint('BOTTOM', 0, 7)
	else
		player:SetPoint('BOTTOM', -140, 7)
		cursor:SetPoint('BOTTOM', 0, 7)
	end
end
local function UpdateCoords(self, elapsed)
	self.elapsed = self.elapsed - elapsed
	if self.elapsed <= 0 then
		self.elapsed = 0.1
		OnUpdate(player, cursor)
	end
end
local function gen_coords(self)
	if player or cursor then return end
	player = gen_string('BOTTOM', -90, 50)
	cursor = gen_string('BOTTOM', 50, 50)
end
local function OnLogin(self, event)
	gen_coords(self)
	local cond = false
	if (event == "WORLD_MAP_UPDATE") then 
	-- making sure that coordinates are not calculated when map is hidden
		self:SetScript('OnEvent', function() 
			if not WorldMapFrame:IsVisible() and cond then
				self.elapsed = nil
				self:SetScript('OnUpdate', nil)
				cond = false
			else
				self.elapsed = 0.1
				self:SetScript('OnUpdate', UpdateCoords)
				cond = true
			end
		end)
	end
	self:UnregisterEvent("PLAYER_LOGIN")
end
c:RegisterEvent("PLAYER_LOGIN") 
c:RegisterEvent("WORLD_MAP_UPDATE")
c:SetScript("OnEvent",OnLogin)
	
--------------------------------------------------------------
-- BattlefieldMinimap style
--------------------------------------------------------------
local bm = CreateFrame("Frame")
bm:RegisterEvent("ADDON_LOADED")
bm:SetScript("OnEvent", function(self, event, addon)
	if not BattlefieldMinimap_Update then return end
	self:SetParent(BattlefieldMinimap)
	self:SetScript("OnShow", function()
		BattlefieldMinimapCorner:Hide()
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCloseButton:Hide()
	end)
	local background = CreateFrame("Frame", "BACKGROUND", BattlefieldMinimap)
	aDB.SetStyle(background)
	aDB.CreatePanelShadow(background)
	background:SetFrameLevel(0)
	background:SetPoint('TOPLEFT', -1, 1)
	background:SetPoint('BOTTOMRIGHT', -3, 1)
	
	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)