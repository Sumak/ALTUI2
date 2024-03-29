----------------------------------------------------------------------------------------
--	ncCooldownFlash(by Nightcracker)
----------------------------------------------------------------------------------------
if not aDB["cooldown_flash"].enable == true then return end

local lib = LibStub("LibCooldown")
if not lib then error("AltUI_CooldownFlash requires LibCooldown") return end

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- Hearthstone
	},
	["spell"] = {
	},
}

local flash = CreateFrame("Frame", nil, UIParent)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash:SetScript("OnEvent", function()
	local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/GetCVar("uiScale")
	local function scale(x) return mult*math.floor(x+.5) end
	flash:SetPoint(unpack(aDB["pos"].cooldown_icon))
	flash:SetSize(scale(aDB["cooldown_flash"].icon_size), scale(aDB["cooldown_flash"].icon_size))
	flash:SetBackdrop({
	  bgFile = [[Interface\Buttons\WHITE8x8]], 
	  edgeFile = [[Interface\Buttons\WHITE8x8]], 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	flash:SetBackdropColor(0, 0, 0)
	flash:SetBackdropBorderColor(0, 0, 0)
	flash.icon:SetPoint('TOPLEFT', scale(1), scale(-1))
	flash.icon:SetPoint('BOTTOMRIGHT', scale(-1), scale(1))
	flash.icon:SetTexCoord(.08, .92, .08, .92)
	flash:Hide()
	aDB.CreatePanelShadow(flash)
	flash:SetScript("OnUpdate", function(self, e)
		flash.e = flash.e + e
		if flash.e > aDB["cooldown_flash"].fade_out_time then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
	flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
	flash:SetScript("OnEvent", nil)
end)
flash:RegisterEvent("PLAYER_ENTERING_WORLD")

lib:RegisterCallback("stop", function(id, class)
	if filter[class]=="all" or filter[class][id] then return end
	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end)