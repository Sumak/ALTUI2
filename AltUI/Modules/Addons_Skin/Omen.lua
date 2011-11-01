if not aDB["addons_skin"].omen == true then return end

if (IsAddOnLoaded("Omen")) then
local Omen = LibStub("AceAddon-3.0"):GetAddon("Omen")
if not aDB then return end
if not Omen then return end

Omen.UpdateBackdrop_ = Omen.UpdateBackdrop
Omen.UpdateBackdrop = function(self)
    self:UpdateBackdrop_()
    aDB.SetStyle(self.BarList)
	aDB.CreatePanelShadow(self.BarList)
    aDB.SetStyle(self.Title)
	aDB.CreatePanelShadow(self.Title)
    self.BarList:SetPoint('TOPLEFT',  self.Title, 'BOTTOMLEFT', 0, -1)
end

Omen.UpdateTitleBar_ = Omen.UpdateTitleBar
Omen.UpdateTitleBar = function(self)
    self:UpdateTitleBar_()
    self.TitleText:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
	self.TitleText:SetShadowColor(0, 0, 0)
	self.TitleText:SetShadowOffset(0, 0)
    self.BarList:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, -1)
end
Omen.UpdateBarTextureSettings_ = Omen.UpdateBarTextureSettings
Omen.UpdateBarTextureSettings = function(self)
    for i, v in ipairs(self.Bars) do
        v.texture:SetTexture(aDB["media"].texture)
    end
end

Omen.UpdateBarLabelSettings_ = Omen.UpdateBarLabelSettings
Omen.UpdateBarLabelSettings = function(self)
    self:UpdateBarLabelSettings_()
    for i, v in ipairs(self.Bars) do
        v.Text1:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
		v.Text1:SetShadowColor(0, 0, 0)
		v.Text1:SetShadowOffset(0, 0)
        v.Text2:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
		v.Text2:SetShadowColor(0, 0, 0)
		v.Text2:SetShadowOffset(0, 0)
        v.Text3:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
		v.Text3:SetShadowColor(0, 0, 0)
		v.Text3:SetShadowOffset(0, 0)
    end
end

local meta = getmetatable(Omen.Bars)
local oldidx = meta.__index
meta.__index = function(self, barID)
    local bar = oldidx(self, barID)
    Omen:UpdateBarTextureSettings()
    Omen:UpdateBarLabelSettings()
    return bar
end
Omen.db.profile.Scale = 1
Omen.db.profile.Background.EdgeSize = 1
Omen.db.profile.Background.BarInset = 2
Omen.db.profile.Bar.Spacing = 1
Omen.db.profile.TitleBar.UseSameBG = true

Omen:UpdateBarTextureSettings()
Omen:UpdateBarLabelSettings()
Omen:UpdateTitleBar()
Omen:UpdateBackdrop()
Omen:ReAnchorBars()
Omen:ResizeBars()
end