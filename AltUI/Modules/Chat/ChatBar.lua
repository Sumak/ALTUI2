----------------------------------------------------------------------------------------
--	ChatBar(FavChatBar by Favorit) Alt edit.
----------------------------------------------------------------------------------------
if not aDB["chat"].chat_bar == true then return end

local c = RAID_CLASS_COLORS["PALADIN"]
local d = RAID_CLASS_COLORS["DRUID"]
local dz = RAID_CLASS_COLORS["DEATHKNIGHT"]

function aDB.ChatBarShadow1(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(0.8, 0.8, 0.8)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow2(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(c.r, c.g, c.b)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow3(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(0, 0.6, 0)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow4(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(0, 0.3, 0.6)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow5(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(d.r, d.g, d.b)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow6(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(dz.r, dz.g, dz.b)
	f.Shadow = Shadow
	return Shadow
end

function aDB.ChatBarShadow7(f) 
	if f.Shadow then return end
	local Shadow = CreateFrame("Frame", nil, f)
	Shadow:SetFrameLevel(92)
	Shadow:SetPoint('TOPLEFT', -2, 2)
	Shadow:SetPoint('BOTTOMRIGHT', 2, -2)
	Shadow:SetBackdrop({
			edgeFile = aDB["media"].glow_texture, edgeSize = 3,
			insets = {top = 3, left = 3, bottom = 3, right = 3},
		})
	Shadow:SetBackdropBorderColor(0.8, 0.6, 0.6)
	f.Shadow = Shadow
	return Shadow
end

local cbar = CreateFrame("Frame", "favchat", favchat)
cbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
cbar:RegisterEvent("ADDON_LOADED")

function cbar:S(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/s ", SELECTED_DOCK_FRAME);	
	end
end

function cbar:W(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/r ", SELECTED_DOCK_FRAME);		
	end
end

function cbar:GO(button)
	if(button == "RightButton") then
		ChatFrame_OpenChat("/o ", SELECTED_DOCK_FRAME);		
	else
		ChatFrame_OpenChat("/g ", SELECTED_DOCK_FRAME);	
	end
end

function cbar:P(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/p ", SELECTED_DOCK_FRAME);	
	end
end

function cbar:R(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/raid ", SELECTED_DOCK_FRAME);		
	elseif(button == "RightButton") then
	 ChatFrame_OpenChat("/bg ", SELECTED_DOCK_FRAME);	
	end
end

function cbar:Y(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/y ", SELECTED_DOCK_FRAME);		
	end
end

function cbar:GTG(button)
	if(button == "LeftButton") then
		ChatFrame_OpenChat("/1 ", SELECTED_DOCK_FRAME);		
	elseif(button == "RightButton") then
		ChatFrame_OpenChat("/3 ", SELECTED_DOCK_FRAME);	
	else
		ChatFrame_OpenChat("/2 ", SELECTED_DOCK_FRAME);	
	end
end

function cbar:Style()
	favchat:ClearAllPoints()
	favchat:SetParent(UIParent)

	sw = CreateFrame("Button", "sw", favchat)
	sw:ClearAllPoints()
	sw:SetParent(favchat)
	sw:SetPoint('LEFT', ChatBar, 8, 0)
	sw:SetSize(30, 4)
	sw:SetFrameLevel(92)
	aDB.ChatBarShadow1(sw)
	sw:SetBackdropBorderColor(0.8, 0.8, 0.8)
	sw:RegisterForClicks("AnyUp")
	sw:SetScript("OnClick", cbar.S)
	swtex = sw:CreateTexture(nil, "ARTWORK")
	swtex:SetTexture('Interface\\Buttons\\WHITE8x8')
	swtex:SetVertexColor(0.8, 0.8, 0.8)
	swtex:SetPoint('TOPLEFT', sw, 'TOPLEFT', 1, -1)
	swtex:SetPoint('BOTTOMRIGHT', sw, 'BOTTOMRIGHT', -1, 1)
	
	w = CreateFrame("Button", "w", favchat)
	w:ClearAllPoints()
	w:SetParent(favchat)
	w:SetPoint('LEFT', sw, 'RIGHT', 7, 0)
	w:SetSize(30, 4)
	aDB.ChatBarShadow2(w)
	w:SetBackdropBorderColor(0, 0, 0)
	w:RegisterForClicks("AnyUp")
	w:SetScript("OnClick", cbar.W)
	wtex = sw:CreateTexture(nil, "ARTWORK")
	wtex:SetTexture('Interface\\Buttons\\WHITE8x8')
	wtex:SetVertexColor(c.r, c.g, c.b)
	wtex:SetPoint('TOPLEFT', w, 'TOPLEFT', 1, -1)
	wtex:SetPoint('BOTTOMRIGHT', w, 'BOTTOMRIGHT', -1, 1)
	
	go = CreateFrame("Button", "go", favchat)
	go:ClearAllPoints()
	go:SetParent(favchat)
	go:SetPoint('LEFT', w, 'RIGHT', 7, 0)
	go:SetSize(30, 4)
	aDB.ChatBarShadow3(go)
	go:SetBackdropBorderColor(0, 0, 0)
	go:RegisterForClicks("AnyUp")
	go:SetScript("OnClick", cbar.GO)
	gotex = sw:CreateTexture(nil, "ARTWORK")
	gotex:SetTexture('Interface\\Buttons\\WHITE8x8')
	gotex:SetVertexColor(0, 0.6, 0)
	gotex:SetPoint('TOPLEFT', go, 'TOPLEFT', 1, -1)
	gotex:SetPoint('BOTTOMRIGHT', go, 'BOTTOMRIGHT', -1, 1)
	
	p = CreateFrame("Button", "rp", favchat)
	p:ClearAllPoints()
	p:SetParent(favchat)
	p:SetPoint('LEFT', go, 'RIGHT', 7, 0)
	p:SetSize(30, 4)
	aDB.ChatBarShadow4(p)
	p:SetBackdropBorderColor(0, 0, 0)
	p:RegisterForClicks("AnyUp")
	p:SetScript("OnClick", cbar.P)
	ptex = rp:CreateTexture(nil, "ARTWORK")
	ptex:SetTexture('Interface\\Buttons\\WHITE8x8')
	ptex:SetVertexColor(0, 0.3, 0.6)
	ptex:SetPoint('TOPLEFT', p, 'TOPLEFT', 1, -1)
	ptex:SetPoint('BOTTOMRIGHT', p, 'BOTTOMRIGHT', -1, 1)
	
	r = CreateFrame("Button", "r", favchat)
	r:ClearAllPoints()
	r:SetParent(favchat)
	r:SetPoint('LEFT', p, 'RIGHT', 7, 0)
	r:SetSize(30, 4)
	aDB.ChatBarShadow5(r)
	r:SetBackdropBorderColor(0, 0, 0)
	r:RegisterForClicks("AnyUp")
	r:SetScript("OnClick", cbar.R)
	rtex = rp:CreateTexture(nil, "ARTWORK")
	rtex:SetTexture('Interface\\Buttons\\WHITE8x8')
	rtex:SetVertexColor(d.r, d.g, d.b)
	rtex:SetPoint('TOPLEFT', r, 'TOPLEFT', 1, -1)
	rtex:SetPoint('BOTTOMRIGHT', r, 'BOTTOMRIGHT', -1, 1)
	
	y = CreateFrame("Button", "y", favchat)
	y:ClearAllPoints()
	y:SetParent(favchat)
	y:SetPoint('LEFT', r, 'RIGHT', 7, 0)
	y:SetSize(30, 4)
	aDB.ChatBarShadow6(y)
	y:SetBackdropBorderColor(0, 0, 0)
	y:RegisterForClicks("AnyUp")
	y:SetScript("OnClick", cbar.Y)
	ytex = rp:CreateTexture(nil, "ARTWORK")
	ytex:SetTexture('Interface\\Buttons\\WHITE8x8')
	ytex:SetVertexColor(dz.r, dz.g, dz.b)
	ytex:SetPoint('TOPLEFT', y, 'TOPLEFT', 1, -1)
	ytex:SetPoint('BOTTOMRIGHT', y, 'BOTTOMRIGHT', -1, 1)
	
	g = CreateFrame("Button", "g", favchat)
	g:ClearAllPoints()
	g:SetParent(favchat)
	g:SetPoint('LEFT', y, 'RIGHT', 7, 0)
	g:SetSize(30, 4)
	aDB.ChatBarShadow7(g)
	g:SetBackdropBorderColor(0, 0, 0)
	g:RegisterForClicks("AnyUp")
	g:SetScript("OnClick", cbar.GTG)
	gtex = rp:CreateTexture(nil, "ARTWORK")
	gtex:SetTexture('Interface\\Buttons\\WHITE8x8')
	gtex:SetVertexColor(0.8, 0.6, 0.6)
	gtex:SetPoint('TOPLEFT', g, 'TOPLEFT', 1, -1)
	gtex:SetPoint('BOTTOMRIGHT', g, 'BOTTOMRIGHT', -1, 1)
	cbar:Hide()
end

local CC = CreateFrame("Button", "CC", UIParent)
CC:SetSize(16, 16)
CC:SetPoint('LEFT', LDTX, 'RIGHT', 1, 0)
aDB.SetStyle(CC)
aDB.CreatePanelShadow(CC)
CC:SetAlpha(0)				
CC:HookScript("OnEnter", function(CC) CC:SetAlpha(1) end)	
CC:HookScript("OnLeave", function(CC) CC:SetAlpha(0) end)
CC:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and not InCombatLockdown() then
		LDTX:Hide()
		cbar:Show()
		ChatBar:Show()
	elseif button == "RightButton" then
		LDTX:Show()
		cbar:Hide()
		ChatBar:Hide()
	end
end)

local CCT = CC:CreateFontString(nil, 'LOW')
CCT:SetFont(aDB["fonts"].datatext_font, aDB["fonts"].datatext_font_size * 2, aDB["fonts"].datatext_font_style)
CCT:SetText("<>")
CCT:SetTextColor(0.69, 0.31, 0.31)
CCT:SetPoint('CENTER', CC, 0, 1)

function cbar:ADDON_LOADED(event, name)
	self:Style()
end