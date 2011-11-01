local _, class = UnitClass("player")
local c = RAID_CLASS_COLORS[class]

local WFCET = WatchFrameCollapseExpandButton:CreateFontString(WatchFrameCollapseExpandButton)
WFCET:SetPoint('CENTER', 0, 1)
WFCET:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
WFCET:SetTextColor(1, 1, 1)
WFCET:SetText(locale.WFCET)

WatchFrameCollapseExpandButton:SetNormalTexture("")
WatchFrameCollapseExpandButton:SetPushedTexture("")
WatchFrameCollapseExpandButton:SetHighlightTexture("")
WatchFrameCollapseExpandButton:HookScript("OnClick", function(self) 
	if WatchFrame.collapsed then 
		WFCET:SetText(locale.WFCET1) 
	else 
		WFCET:SetText(locale.WFCET2)
	end 
end)
aDB.SetStyle(WatchFrameCollapseExpandButton)
aDB.CreatePanelShadow(WatchFrameCollapseExpandButton)
--------------------------------------------------------------------
-- Datatext panels
--------------------------------------------------------------------
local Bpanel = CreateFrame("Frame", "BottomPanel", UIParent)
Bpanel:SetWidth(UIParent:GetWidth() * 10)
Bpanel:SetHeight(25)
Bpanel:SetPoint('BOTTOM', 0, -5)
aDB.SetStyle(Bpanel)
aDB.CreatePanelShadow(Bpanel)

local ChatBar = CreateFrame("Frame", "ChatBar", UIParent)
ChatBar:SetWidth(aDB["chat"].chatframewidth)
ChatBar:SetHeight(16)
ChatBar:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 2, 11)
ChatBar:SetFrameStrata(Bpanel:GetFrameStrata())
ChatBar:Hide()
aDB.SetStyle(ChatBar)
aDB.CreatePanelShadow(ChatBar)

local LeftDataText = CreateFrame("Frame", "LDTX", UIParent)
LeftDataText:SetWidth(aDB["chat"].chatframewidth)
LeftDataText:SetHeight(16)
LeftDataText:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 2, 11)
LeftDataText:SetFrameStrata(Bpanel:GetFrameStrata())
aDB.SetStyle(LeftDataText)
aDB.CreatePanelShadow(LeftDataText)

local RightDataText = CreateFrame("Frame", "RDTX", UIParent)
RightDataText:SetWidth(aDB["chat"].chatframewidth)
RightDataText:SetHeight(16)
RightDataText:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -2, 11)
RightDataText:SetFrameStrata(Bpanel:GetFrameStrata())
aDB.SetStyle(RightDataText)
aDB.CreatePanelShadow(RightDataText)

local CoordPanel1 = CreateFrame("Frame", "CoordPanel1", WorldMapFrame)
CoordPanel1:SetSize(140, 20)
CoordPanel1:SetPoint('BOTTOMRIGHT', WorldMapFrameCloseButton, 1, -22)
CoordPanel1:SetFrameStrata('BACKGROUND')
CoordPanel1:SetFrameLevel(2)
aDB.SetStyle(CoordPanel1)
aDB.CreatePanelShadow(CoordPanel1)

local CoordPanel2 = CreateFrame("Frame", "CoordPanel2", CoordPanel1)
CoordPanel2:SetSize(140, 20)
CoordPanel2:SetPoint('LEFT', CoordPanel1, -141, 0)
CoordPanel2:SetFrameStrata('BACKGROUND')
CoordPanel2:SetFrameLevel(2)
aDB.SetStyle(CoordPanel2)
aDB.CreatePanelShadow(CoordPanel2)

local ZonePanel = CreateFrame("Frame", "ZonePanel", CoordPanel1)
ZonePanel:SetSize(250, 20)
ZonePanel:SetPoint('TOPLEFT', CoordPanel2, 'TOPLEFT', -251, 0)
ZonePanel:SetFrameStrata('BACKGROUND')
ZonePanel:SetFrameLevel(2)
aDB.SetStyle(ZonePanel)
aDB.CreatePanelShadow(ZonePanel)
--------------------------------------------------------------------
-- Location text on worldmap >.<
--------------------------------------------------------------------
local location = CreateFrame("Frame", "Location", ZonePanel)
location:SetParent(ZonePanel)
location:SetSize(50, 50)
location:SetPoint('CENTER', 0, 1)
location:SetFrameLevel(2)

local lText = location:CreateFontString(nil, 'LOW')
lText:SetFont(aDB["fonts"].worldmap_font, aDB["fonts"].worldmap_font_size, aDB["fonts"].worldmap_font_style)
lText:SetShadowOffset(0, 0)
lText:SetPoint('CENTER', location, 0, 1)
 
local function OnEvent(self, event)
	local loc = GetMinimapZoneText()
	local pvpType, isFFA, zonePVPStatus = GetZonePVPInfo()

	if (pvpType == "sanctuary") then
		loc = "|cff69C9EF"..loc.."|r"
	elseif (pvpType == "friendly") then
		loc = "|cff00ff00"..loc.."|r" 
	elseif (pvpType == "contested") then
		loc = "|cffffff00"..loc.."|r"
	elseif (pvpType == "hostile" or pvpType == "combat" or pvpType == "arena" or not pvpType) then
		loc = "|cffff0000"..loc.."|r"
	else
		loc = loc -- white
	end

	lText:SetText(loc)
	location:SetWidth(lText:GetWidth() + 10)
end

location:RegisterEvent("PLAYER_ENTERING_WORLD")
location:RegisterEvent("ZONE_CHANGED_NEW_AREA")
location:RegisterEvent("ZONE_CHANGED")
location:RegisterEvent("ZONE_CHANGED_INDOORS")
location:HookScript("OnEvent", OnEvent)