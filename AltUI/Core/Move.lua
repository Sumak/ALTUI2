----------------------------------------------------------------------------------------
--	MoveUI module(by Allez)
----------------------------------------------------------------------------------------
UISavedPositions = {}
UIMovableFrames = {}

local moving = false
local movers = {}

local SetPosition = function(mover)
	local ap, _, rp, x, y = mover:GetPoint()
	UISavedPositions[mover.frame:GetName()] = {ap, "UIParent", rp, x, y}
end

local OnDragStart = function(self)
	self:StartMoving()
	self.frame:ClearAllPoints()
	self.frame:SetAllPoints(self)
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	SetPosition(self)
end

local CreateMover = function(frame)
	local mover = CreateFrame("Frame", nil, UIParent)
	mover:SetAllPoints(frame)
	mover:SetFrameStrata('TOOLTIP')
	mover:EnableMouse(true)
	mover:SetMovable(true)
	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", OnDragStart)
	mover:SetScript("OnDragStop", OnDragStop)
	mover.frame = frame
	mover.name = mover:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	mover.name:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
	mover.name:SetShadowColor(0, 0, 0, 0)
	mover.name:SetTextColor(1, 1, 1)
	mover.name:SetPoint('CENTER')
	mover.name:SetText(frame:GetName())
	movers[frame:GetName()] = mover
	aDB.SetStyle(mover)
	aDB.CreatePanelShadow(mover)
end

local GetMover = function(frame)
	if movers[frame:GetName()] then
		return movers[frame:GetName()]
	else
		return CreateMover(frame)
	end
end

StaticPopupDialogs["MOVE_UI"] = {
	text = "Reload UI for apply changes?", 
	button1 = ACCEPT, 
	button2 = CANCEL,
	OnAccept = ReloadUI,
	timeout = 0, 
	whileDead = 1,
	hideOnEscape = 1, 
}

local InitMove = function(msg)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if msg and msg == 'reset' then
		UISavedPositions = {}
		ReloadUI()
		return
	end
	if not moving then
		for i, v in pairs(UIMovableFrames) do
			local mover = GetMover(v)
			if mover then mover:Show() end
		end
		moving = true
	else
		for i, v in pairs(movers) do
			v:Hide()
		end
		moving = false
		StaticPopup_Show("MOVE_UI")
	end
end

local RestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			RestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end
	for frame_name, point in pairs(UISavedPositions) do
		if _G[frame_name] then
			_G[frame_name]:ClearAllPoints()
			_G[frame_name]:SetPoint(unpack(point))
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	RestoreUI(self)
end)

SlashCmdList["MoveUI"] = InitMove
SLASH_MoveUI1 = "/move"