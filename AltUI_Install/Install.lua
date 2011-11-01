----------------------------------------------------------------------------------------
--	Install UI(by Haleth)
----------------------------------------------------------------------------------------
local function SetupUI()
	-- Don't need to set CVar multiple time
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("showClock", 0)
	SetCVar("showItemLevel", 1)
	SetCVar("previewTalents", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("chatStyle", "classic")
	SetCVar("hidePartyInRaid", 0)
	SetCVar("showArenaEnemyFrames", 0)
	SetCVar("autoSelfCast", 1)
	SetCVar("chatBubblesParty", 1)
	SetCVar("chatBubbles", 1)
	SetCVar("buffDurations", 1)
	SetCVar("lootUnderMouse", 0)
	SetCVar("chatMouseScroll", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("chatStyle", "im")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("colorblindMode", 0)
	SetCVar("rotateMinimap", 0)
	SetCVar("showItemLevel", 1)
end

local function InstallUI()
	if not IsAddOnLoaded("Prat") or not IsAddOnLoaded("Chatter") then					
		FCF_SetLocked(ChatFrame1, 1)

		for i = 1, NUM_CHAT_WINDOWS do
			local frame = _G[format("ChatFrame%s", i)]
			local chatFrameId = frame:GetID()
			local chatName = FCF_GetChatWindowInfo(chatFrameId)
			
			-- Move general chat to bottom left
			if i == 1 then
				frame:ClearAllPoints()
				frame:SetPoint(unpack(aDB["chat"].chatframe))
			end
			
			FCF_SavePositionAndDimensions(frame)
			FCF_SetChatWindowFontSize(nil, frame, aDB["chat"].font_size)
			
			-- Rename combat log tab
			if i == 2 then 
				FCF_SetWindowName(frame, GUILD_BANK_LOG)
			end
		end
		
		-- This option not to include each time in chat options (Class color name) 
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	end
end

local _, class = UnitClass("player")
local c = RAID_CLASS_COLORS[class]

local function InstallShadow(f) 
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
	Shadow:SetBackdropBorderColor(c.r, c.g, c.b)
	f.Shadow = Shadow
	return Shadow
end

local b = CreateFrame("Frame", "AltUI_Install_BG", UIParent)
b:SetWidth(UIParent:GetWidth() + 5000)
b:SetHeight(UIParent:GetHeight() + 5000)
b:SetPoint('CENTER', UIParent, 'CENTER')
b:SetFrameStrata('BACKGROUND')
b:SetBackdrop({
	bgFile = [=[Interface\Buttons\WHITE8x8]=],
	edgeFile = [=[Interface\Buttons\WHITE8x8]=],
	insets = {left = 0, right = 0, top = 0, bottom = 0},
	edgeSize = 0
})
b:SetBackdropColor(0, 0, 0, 0.8)

local f = CreateFrame("Frame", "AltUI_Install", UIParent)
f:SetSize(400, 300)
f:SetPoint('CENTER', 0, 0)
aDB.SetStyle(f)
aDB.CreatePanelShadow(f)
f:Hide()

local f1 = CreateFrame("Button", "AltUI_FirstFrame_Install", UIParent)
f1:SetSize(150, 50)
f1:SetPoint('CENTER', 0, 0)
f1:SetFrameStrata('HIGH')
f1:SetFrameLevel(30)
aDB.SetStyle(f1)
f1:SetBackdropBorderColor(c.r, c.g, c.b)
InstallShadow(f1)
f1:SetScript("OnClick", function()
	f:Show()
	f1:Hide()
end)

local cc1 = f1:CreateFontString(nil, "OVERLAY")
cc1:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size * 2, aDB["fonts"].panel_font_style)
cc1:SetText(loc.install_o9)
cc1:SetPoint('CENTER', close, 'CENTER', 0, 2)

local sb = CreateFrame("StatusBar", nil, f)
sb:SetStatusBarTexture(aDB["media"].texture)
sb:SetPoint('BOTTOM', f, 0, 30)
sb:SetHeight(15)
sb:SetWidth(f:GetWidth()-80)
sb:SetFrameStrata('HIGH')
sb:Hide()

local sbd = CreateFrame("Frame", nil, sb)
aDB.SetStyle(sbd)
sbd:SetPoint('TOPLEFT', sb, -1, 1)
sbd:SetPoint('BOTTOMRIGHT', sb, 1, -1)
sbd:SetFrameStrata('LOW')

local head = f:CreateFontString(nil, "OVERLAY")
head:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
head:SetPoint('TOP', f, 0, -10)

local text1 = f:CreateFontString(nil, "OVERLAY")
text1:SetJustifyH('LEFT')
text1:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
text1:SetWidth(f:GetWidth()-40)
text1:SetPoint('TOPLEFT', f, 'TOPLEFT', 20, -30)

local text2 = f:CreateFontString(nil, "OVERLAY")
text2:SetJustifyH('LEFT')
text2:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
text2:SetWidth(f:GetWidth()-40)
text2:SetPoint('TOPLEFT', text1, 'BOTTOMLEFT', 0, -20)

local text3 = f:CreateFontString(nil, "OVERLAY")
text3:SetJustifyH('LEFT')
text3:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
text3:SetWidth(f:GetWidth()-40)
text3:SetPoint('TOPLEFT', text2, 'BOTTOMLEFT', 0, -20)

local text4 = f:CreateFontString(nil, "OVERLAY")
text4:SetJustifyH('LEFT')
text4:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
text4:SetWidth(f:GetWidth()-40)
text4:SetPoint('TOPLEFT', text3, 'BOTTOMLEFT', 0, -20)

local sbt = sb:CreateFontString(nil, "OVERLAY")
sbt:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
sbt:SetPoint('CENTER', sb)

local option1 = CreateFrame("Button", "AltUI_Install_Option1", f, "UIPanelButtonTemplate")
option1:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 39, 5)
option1:SetSize(110, 20)
option1:SetNormalTexture("")
option1:SetHighlightTexture("")
option1:SetPushedTexture("")
aDB.SetStyle(option1)
aDB.LolSkin(option1)

local option2 = CreateFrame("Button", "AltUI_Install_Option2", f, "UIPanelButtonTemplate")
option2:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -39, 5)
option2:SetSize(110, 20)
option2:SetNormalTexture("")
option2:SetHighlightTexture("")
option2:SetPushedTexture("")
aDB.SetStyle(option2)
aDB.LolSkin(option2)

local close = CreateFrame("Button", "AltUI_Install_CloseButton", f)
close:SetPoint('TOPRIGHT', f, 'TOPRIGHT', -5, -5)
close:SetSize(20, 20)
aDB.SetStyle(close)
aDB.CreatePanelShadow(close)
close:SetScript("OnClick", function()
	f:Hide()
	b:Hide()
	DisableAddOn("AltUI_Install")
end)

local cc = close:CreateFontString(nil, "OVERLAY")
cc:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
cc:SetText("X")
cc:SetPoint('CENTER', close, 0, 1)

local step3 = function()
	sb:SetValue(3)
	PlaySoundFile("Sound\\interface\\LevelUp.wav")
	head:SetText(loc.install_c3)
	text1:SetText(loc.installz_23)
	text2:SetText(loc.installz_24)
	text3:SetText("")
	text4:SetText(loc.installz_25)
	sbt:SetText("3/3")
	option1:Hide()
	option2:SetText(loc.install_o8)

	option2:SetScript("OnClick", function()
		DisableAddOn("AltUI_Install")
		ReloadUI()
	end)
end

local step2 = function()
	sb:SetValue(2)
	head:SetText(loc.install_c2)
	text1:SetText(loc.installz_21)
	text2:SetText(loc.installz_22)
	text3:SetText("")
	sbt:SetText("2/3")

	option1:SetScript("OnClick", step3)
	option2:SetScript("OnClick", function()
		InstallUI()
		step3()
	end)
end

local step1 = function()
	sb:SetMinMaxValues(0, 3)
	sb:Show()
	sb:SetValue(1)
	sb:SetStatusBarColor(0.26, 1, 0.22)
	head:SetText(loc.install_c1)
	text1:SetText(loc.installz_18)
	text2:SetText(loc.installz_19)
	text3:SetText(loc.installz_20)
	text4:SetText("")
	sbt:SetText("1/3")

	option1:Show()

	option1:SetText(loc.install_o6)
	option2:SetText(loc.install_o7)

	option1:SetScript("OnClick", step2)
	option2:SetScript("OnClick", function()
		SetupUI()
		step2()
	end)
end

local tut6 = function()
	sb:SetValue(6)
	head:SetText(loc.install_w5)
	text1:SetText(loc.installz_15)
	text2:SetText(loc.installz_16)
	text3:SetText(loc.installz_17)
	text4:SetText("")

	sbt:SetText("6/6")

	option1:Show()

	option1:SetText(loc.install_o4)
	option2:SetText(loc.install_o5)

	option1:SetScript("OnClick", function()
		DisableAddOn("AltUI_Istall")
	end)
	option2:SetScript("OnClick", step1)
end

local tut5 = function()
	sb:SetValue(5)
	head:SetText(loc.install_w6)
	text1:SetText(loc.install_w16)
	text2:SetText(loc.install_w17)
	text3:SetText(loc.install_w18)
	text4:SetText(loc.isntall_w19)

	sbt:SetText("5/6")

	option2:SetScript("OnClick", tut6)
end

local tut4 = function()
	sb:SetValue(4)
	head:SetText(loc.install_w4)
	text1:SetText(loc.installz_12)
	text2:SetText(loc.installz_13)
	text3:SetText(loc.installz_14)
	text4:SetText("")

	sbt:SetText("4/6")

	option2:SetScript("OnClick", tut5)
end

local tut3 = function()
	sb:SetValue(3)
	head:SetText(loc.install_w3)
	text1:SetText(loc.installz_9)
	text2:SetText(loc.installz_10)
	text3:SetText(loc.installz_11)
	text4:SetText("")

	sbt:SetText("3/6")

	option2:SetScript("OnClick", tut4)
end

local tut2 = function()
	sb:SetValue(2)
	head:SetText(loc.install_w2)
	text1:SetText(loc.intsallz_5)
	text2:SetText(loc.installz_6)
	text3:SetText(loc.installz_7)
	text4:SetText(loc.installz_8)

	sbt:SetText("2/6")

	option2:SetScript("OnClick", tut3)
end

local tut1 = function()
	sb:SetMinMaxValues(0, 6)
	sb:Show()
	sb:SetValue(1)
	sb:SetStatusBarColor(0, 0.76, 1)
	head:SetText(loc.install_w1)
	text1:SetText(loc.installz_1)
	text2:SetText(loc.installz_2)
	text3:SetText(loc.installz_3)
	text4:SetText(loc.installz_4)
	sbt:SetText("1/6")

	option1:Hide()

	option2:SetText(loc.install_o3)

	option2:SetScript("OnClick", tut2)
end

head:SetText("")
text1:SetText(loc.install_2)
text2:SetText(loc.install_3)
text3:SetText("")
text4:SetText(loc.install_4)

option1:SetText(loc.install_o1)
option2:SetText(loc.install_o2)

option1:SetScript("OnClick", tut1)
option2:SetScript("OnClick", step1)