----------------------------------------------------------------------------------------
--	Auto UI Scale function
----------------------------------------------------------------------------------------
function UIScale()
	if aDB["general"].auto_UI_Scale == true then
	aDB["general"].UIScale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
UIScale()

local nosclaemult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/aDB["general"].UIScale
local function scale(x)
    return nosclaemult*math.floor(x/nosclaemult+.5)
end
function Scale(x) return scale(x) end
nosclaemult = nosclaemult

--	Kill object function
function aDB.Kill(object)
	object.Show = aDB.dummy
	object:Hide()
end

----------------------------------------------------------------------------------------
--	Style functions
----------------------------------------------------------------------------------------
local _, class = UnitClass("player")
local c = RAID_CLASS_COLORS[class]

local function SetModifiedBorder(self)
	local c = RAID_CLASS_COLORS[aDB.myclass]
	self:SetBackdropBorderColor(c.r, c.g, c.b)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	self:SetBackdropBorderColor(unpack(aDB["media"].border_color))
end

function aDB.LolSkin(f)
	f:HookScript("OnEnter", SetModifiedBorder)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

function aDB.SetStyle(f)
	f:SetBackdrop({
		bgFile = [=[Interface\Buttons\WHITE8x8]=], 
		edgeFile = [=[Interface\Buttons\WHITE8x8]=], 
		tile = false, tileSize = 0, edgeSize = nosclaemult, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	f:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	f:SetBackdropBorderColor(unpack(aDB["media"].border_color))
end

function aDB.SetUFStyle(f)
	f:SetBackdrop({
		bgFile = [=[Interface\Buttons\WHITE8x8]=], 
		edgeFile = [=[Interface\Buttons\WHITE8x8]=], 
		tile = false, tileSize = 0, edgeSize = nosclaemult, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	f:SetBackdropColor(0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
end

function aDB.CreateShadow(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(1)
	Shadow:SetFrameStrata(f:GetFrameStrata())
	Shadow:SetPoint('TOPLEFT', -3, 3)
	Shadow:SetPoint('BOTTOMRIGHT', 3, -3)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 5,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(unpack(aDB["media"].shadow_border))
	f.Shadow = Shadow
	return Shadow
end

function aDB.CreatePanelShadow(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(1)
	Shadow:SetFrameStrata(f:GetFrameStrata())
	Shadow:SetPoint('TOPLEFT', -3, 3)
	Shadow:SetPoint('BOTTOMRIGHT', 3, -3)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 4,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(unpack(aDB["media"].shadow_border))
	f.Shadow = Shadow
	return Shadow
end

function aDB.CreateNameplatesShadow(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(1)
	Shadow:SetPoint('TOPLEFT', -3, 3)
	Shadow:SetPoint('BOTTOMRIGHT', 3, -3)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 4,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(unpack(aDB["media"].shadow_border))
	f.Shadow = Shadow
	return Shadow
end

function aDB.SetTex(f, t, texture)
	f:SetBackdrop({
	  bgFile = [=[Interface\Buttons\WHITE8x8]=], 
	  edgeFile = [=[Interface\Buttons\WHITE8x8]=], 
	  tile = false, tileSize = 0, edgeSize = noscalemult, 
	  insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint('TOPLEFT', f, 'TOPLEFT', 1, -1)
	tex:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, 1)
	tex:SetTexture(aDB["media"].texture)
	tex:SetVertexColor(.05, .05, .05)
	tex:SetDrawLayer("BORDER", -8)
	f.tex = tex
	f:SetBackdropColor(0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0, 0)
end

function aDB.Set3PXStyle(f)
	f:SetBackdrop({
		bgFile = [=[Interface\Buttons\WHITE8x8]=], 
		edgeFile = [=[Interface\Buttons\WHITE8x8]=], 
		tile = false, tileSize = 0, edgeSize = nosclaemult, 
		insets = {left = -nosclaemult, right = -nosclaemult, top = -nosclaemult, bottom = -nosclaemult}
	})
	f:SetBackdropColor(0, 0, 0, .5)
	f:SetBackdropBorderColor(.1, .1, .1)
	
	local b = CreateFrame("Frame", nil, f)
	b:SetFrameLevel(0)
	b:SetPoint('CENTER', f, 'CENTER')
	b:SetFrameStrata('BACKGROUND')
	b:SetBackdrop {
		edgeFile = [=[Interface\Buttons\WHITE8x8]=], edgeSize = nosclaemult * 3,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	}
	b:SetBackdropBorderColor(0, 0, 0, 1)
	b:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 1, -1)
end

-- Style buttons by Chiril & Karudon.
function styleButton(b, c) 
    local name = b:GetName()
 
    local button          = _G[name]
    local icon            = _G[name.."Icon"]
    local count           = _G[name.."Count"]
    local border          = _G[name.."Border"]
    local hotkey          = _G[name.."HotKey"]
    local cooldown        = _G[name.."Cooldown"]
    local nametext        = _G[name.."Name"]
    local flash           = _G[name.."Flash"]
    local normaltexture   = _G[name.."NormalTexture"]
	local icontexture     = _G[name.."IconTexture"]
 
    local hover = b:CreateTexture("frame", nil, self) 
    hover:SetTexture(1, 1, 1, 0.3)
    hover:SetHeight(button:GetHeight())
    hover:SetWidth(button:GetWidth())
    hover:SetPoint('TOPLEFT', button, 1, -1)
    hover:SetPoint('BOTTOMRIGHT', button, -1, 1)
    button:SetHighlightTexture(hover)
 
    local pushed = b:CreateTexture("frame", nil, self)
    pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
    pushed:SetHeight(button:GetHeight())
    pushed:SetWidth(button:GetWidth())
    pushed:SetPoint('TOPLEFT', button, 1, -1)
    pushed:SetPoint('BOTTOMRIGHT', button, -1, 1)
    button:SetPushedTexture(pushed)
 
	local checked = b:CreateTexture("frame", nil, self) 
	checked:SetTexture(0, 1, 0, 0.3)
	checked:SetHeight(button:GetHeight())
	checked:SetWidth(button:GetWidth())
	checked:SetPoint('TOPLEFT', button, 1, -1)
	checked:SetPoint('BOTTOMRIGHT', button, -1, 1)
	button:SetCheckedTexture(checked)
 
    local flasht = b:CreateTexture("frame", nil, self) 
    flasht:SetTexture(1, 0, 1, 0)
    flasht:SetHeight(button:GetHeight())
    flasht:SetWidth(button:GetWidth())
    flasht:SetPoint('TOPLEFT', button, 1, -1)
    flasht:SetPoint('BOTTOMRIGHT', button, -1, 1)
    flash:SetTexture(flasht)
end

function styleBagButton(b, c) 
    local name = b:GetName()
 
    local button          = _G[name]
    local icon            = _G[name.."Icon"]
    local count           = _G[name.."Count"]
    local border          = _G[name.."Border"]
    local hotkey          = _G[name.."HotKey"]
    local cooldown        = _G[name.."Cooldown"]
    local nametext        = _G[name.."Name"]
    local flash           = _G[name.."Flash"]
    local normaltexture   = _G[name.."NormalTexture"]
	local icontexture     = _G[name.."IconTexture"]
 
    local hover = b:CreateTexture("frame", nil, self) 
    hover:SetTexture(1, 1, 1, 0.3)
    hover:SetHeight(button:GetHeight())
    hover:SetWidth(button:GetWidth())
    hover:SetPoint('TOPLEFT', button, 1, -1)
    hover:SetPoint('BOTTOMRIGHT', button, -1, 1)
    button:SetHighlightTexture(hover)
 
    local pushed = b:CreateTexture("frame", nil, self)
    pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
    pushed:SetHeight(button:GetHeight())
    pushed:SetWidth(button:GetWidth())
    pushed:SetPoint('TOPLEFT', button, 1, -1)
    pushed:SetPoint('BOTTOMRIGHT', button, -1, 1)
    button:SetPushedTexture(pushed)
end