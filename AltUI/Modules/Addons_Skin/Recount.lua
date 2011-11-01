if not aDB["addons_skin"].recount == true then return end
local Recount = _G.Recount

if IsAddOnLoaded("Recount") then
local function SkinFrame(frame)
	frame.bgMain = CreateFrame("Frame", nil, frame)
	aDB.SetStyle(frame.bgMain)
	aDB.CreatePanelShadow(frame.bgMain)
	frame.bgMain:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT')
	frame.bgMain:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT')
	frame.bgMain:SetPoint('TOP', frame, 'TOP', 0, -6)
	frame.bgMain:SetFrameLevel(frame:GetFrameLevel())
	frame.CloseButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -1, -8)
	frame:SetBackdrop(nil)
	frame.TitleBackground = CreateFrame("Frame", nil, frame.bgMain)
	frame.TitleBackground:SetPoint('TOP', 0)
	frame.TitleBackground:SetPoint('LEFT', 0)
	frame.TitleBackground:SetPoint('RIGHT', 0)
	frame.TitleBackground:SetHeight(25)
	aDB.SetStyle(frame.TitleBackground)
	frame.Title:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
	frame.Title:SetShadowColor(0, 0, 0)
	frame.Title:SetShadowOffset(0, 0)
	frame.Title:SetParent(frame.TitleBackground)
	frame.Title:ClearAllPoints()
	frame.Title:SetPoint('LEFT', 4, 0)
	frame.CloseButton:SetNormalTexture("")
	frame.CloseButton:SetPushedTexture("")
	frame.CloseButton:SetHighlightTexture("")
	frame.CloseButton.t = frame.CloseButton:CreateFontString(nil, "OVERLAY")
	frame.CloseButton.t:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
	frame.CloseButton.t:SetShadowColor(0, 0, 0)
	frame.CloseButton.t:SetShadowOffset(0, 0)
	frame.CloseButton.t:SetPoint('CENTER', 0, 1)
	frame.CloseButton.t:SetText("X")
end

Recount.UpdateBarTextures = function(self)
	for k, v in pairs(Recount.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(aDB["media"].texture)
		v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		v.StatusBar:GetStatusBarTexture():SetVertTile(false)
		v.LeftText:SetPoint('LEFT', 4, 1)
		v.LeftText:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
		v.LeftText:SetShadowColor(0, 0, 0)
		v.LeftText:SetShadowOffset(0, 0)
		v.RightText:SetPoint('RIGHT', -4, 1)
		v.RightText:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
		v.RightText:SetShadowColor(0, 0, 0)
		v.RightText:SetShadowOffset(0, 0)
	end
end
Recount.SetBarTextures = Recount.UpdateBarTextures

Recount.SetupBar_ = Recount.SetupBar
Recount.SetupBar = function(self, bar)
	self:SetupBar_(bar)
	bar.StatusBar:SetStatusBarTexture(aDB["media"].texture)
end

Recount.CreateFrame_ = Recount.CreateFrame
Recount.CreateFrame = function(self, Name, Title, Height, Width, ShowFunc, HideFunc)
	local frame = self:CreateFrame_(Name, Title, Height, Width, ShowFunc, HideFunc)
	SkinFrame(frame)
	return frame
end

local elements = {
	Recount.MainWindow,
	Recount.ConfigWindow,
	Recount.GraphWindow,
	Recount.DetailWindow,
	Recount.ResetFrame,
}

for i = 1, getn(elements) do
	local frame = elements[i]
	if frame then
		SkinFrame(frame)
	end
end
Recount:UpdateBarTextures()
Recount.MainWindow.FileButton:HookScript("OnClick", function(self) if LibDropdownFrame0 then LibDropdownFrame0:SetTemplate() end end)
end