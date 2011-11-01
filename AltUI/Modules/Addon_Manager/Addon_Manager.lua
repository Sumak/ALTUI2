----------------------------------------------------------------------------------------
--	Addon Manager aLoad(by Fernir aka Wildbreath)
----------------------------------------------------------------------------------------
local loadf = CreateFrame("frame", "aLoadFrame", UIParent)
loadf:SetWidth(300)
loadf:SetHeight(450)
loadf:SetPoint('CENTER')
loadf:SetFrameStrata('DIALOG')
loadf:Hide()
loadf:SetScript("OnHide", function(self) end)
aDB.SetStyle(loadf)
aDB.CreatePanelShadow(loadf)

local NewButton = function(text,parent)
	local result = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
	local label = result:CreateFontString(nil,"OVERLAY","GameFontNormal")
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)
	return result
end

local scrollf = CreateFrame("ScrollFrame", "aload_Scroll", loadf, "UIPanelScrollFrameTemplate")
local mainf = CreateFrame("frame", nil, scrollf)

scrollf:SetPoint('TOPLEFT', loadf, 'TOPLEFT', 10, -30)
scrollf:SetPoint('BOTTOMRIGHT', loadf, 'BOTTOMRIGHT', -28, 40)
scrollf:SetScrollChild(mainf)

local reloadb = NewButton("Reload UI", loadf)
reloadb:SetWidth(150)
reloadb:SetHeight(22)
reloadb:SetNormalTexture("")
reloadb:SetHighlightTexture("")
reloadb:SetPushedTexture("")
aDB.SetStyle(reloadb)
aDB.LolSkin(reloadb)
reloadb:SetPoint('BOTTOM', 0, 10)
reloadb:SetScript("OnClick", function() ReloadUI() end)

local close = CreateFrame("Button", "CloseButton", loadf)
close:SetPoint('TOPRIGHT', loadf, 'TOPRIGHT', -5, -5)
close:SetSize(20, 20)
aDB.SetStyle(close)
aDB.CreatePanelShadow(close)
close:SetScript("OnClick", function()
	loadf:Hide()
end)

local cc = close:CreateFontString(nil, "OVERLAY")
cc:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
cc:SetText("X")
cc:SetPoint('CENTER', close, 0, 1)

local makeList = function()
	local self = mainf
	aDB.SetStyle(scrollf)
	self:SetPoint("TOPLEFT")
	self:SetWidth(scrollf:GetWidth())
	self:SetHeight(scrollf:GetHeight())
	self.addons = {}
	for i=1, GetNumAddOns() do
		self.addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(self.addons)

	local oldb

	for i,v in pairs(self.addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)

		if name then
			local bf = _G[v.."_cbf"] or CreateFrame("CheckButton", v.."_cbf", self, "OptionsCheckButtonTemplate")
			bf:EnableMouse(true)
			bf.title = title.."|n"
			if notes then bf.title = bf.title.."|cffffffff"..notes.."|r|n" end
			if (GetAddOnDependencies(v)) then
				bf.title ="|cffff4400Dependencies: "
				for i=1, select("#", GetAddOnDependencies(v)) do
					bf.title = bf.title..select(i,GetAddOnDependencies(v))
					if (i>1) then bf.title=bf.title..", " end
				end
				bf.title = bf.title.."|r"
			end
				
			if i==1 then
				bf:SetPoint('TOPLEFT',self, 'TOPLEFT', 10, -15)
			else
				bf:SetPoint('TOP', oldb, 'BOTTOM', 0, -20)
			end
			
			bf:SetNormalTexture("")
			bf:SetHighlightTexture("")
			bf:SetPushedTexture("")
			aDB.SetStyle(bf)
	
			bf:SetScript("OnEnter", function(self)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, ANCHOR_TOPRIGHT)
				GameTooltip:AddLine(self.title)
				GameTooltip:Show()
			end)
			
			bf:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			
			bf:SetScript("OnClick", function()
				local _, _, _, enabled = GetAddOnInfo(name)
				if enabled then
					DisableAddOn(name)
				else
					EnableAddOn(name)
				end
			end)
			bf:SetChecked(enabled)
			
			_G[v.."_cbfText"]:SetText(title) 

			oldb = bf
		end
	end
end
makeList()

SLASH_ALOAD1 = "/am"
SlashCmdList["ALOAD"] = function (msg)
   loadf:Show()
end