----------------------------------------------------------------------------------------------
--	ChatMode compilation, include some part of code m_Chat(by Monolit), idChat(by Industrial)
----------------------------------------------------------------------------------------------
local Chat = CreateFrame("Frame")
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
Chat:SetScript("OnEvent", OnEvent)
local _G = _G
local replace = string.gsub
local find = string.find
local c = RAID_CLASS_COLORS["PALADIN"]
local d = RAID_CLASS_COLORS["DRUID"]
local dz = RAID_CLASS_COLORS["DEATHKNIGHT"]

local replaceschan = {
	['Гильдия'] = '[Г]',
	['Группа'] = '[Гр]',
	['Рейд'] = '[Р]',
	['Лидер рейда'] = '[ЛР]',
	['Объявление рейду'] = '[ОР]',
	['Офицер'] = '[О]',
	['Поле боя'] = '[ПБ]',
	['Лидер поля боя'] = '[ЛПБ]', 
	['Guilde'] = '[G]',
	['Groupe'] = '[GR]',
	['Chef de raid'] = '[RL]',
	['Avertissement Raid'] = '[AR]',
	['Officier'] = '[O]',
	['Champs de bataille'] = '[CB]',
	['Chef de bataille'] = '[CDB]',
	['Guild'] = '[G]',
	['Party'] = '[P]',
	['Party Leader'] = '[PL]',
	['Dungeon Guide'] = '[DG]',
	['Guide du donjon'] = '[GdD]',
	['Raid'] = '[R]',
	['Raid Leader'] = '[RL]',
	['Raid Warning'] = '[RW]',
	['Officer'] = '[O]',
	['Battleground'] = '[B]',
	['Battleground Leader'] = '[BL]',
	['(%d+)%. .-'] = '[%1]',
}

FriendsMicroButton:SetScript("OnShow", FriendsMicroButton.Hide)
FriendsMicroButton:Hide()

GeneralDockManagerOverflowButton:SetScript("OnShow", GeneralDockManagerOverflowButton.Hide)
GeneralDockManagerOverflowButton:Hide()

local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	_G[chat]:SetClampRectInsets(0,0,0,0)
	_G[chat]:SetClampedToScreen(false)
	_G[chat]:SetFading(false)
	
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end
	aDB.Kill(_G[format("ChatFrame%sTabLeft", id)])
	aDB.Kill(_G[format("ChatFrame%sTabMiddle", id)])
	aDB.Kill(_G[format("ChatFrame%sTabRight", id)])

	aDB.Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	aDB.Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	aDB.Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	
	aDB.Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	aDB.Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	aDB.Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	aDB.Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	aDB.Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	aDB.Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	aDB.Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	aDB.Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	aDB.Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	aDB.Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	aDB.Kill(_G[format("ChatFrame%sButtonFrame", id)])
	aDB.Kill(_G["ChatFrameMenuButton"])
	
	aDB.Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	aDB.Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	aDB.Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])
	
	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); aDB.Kill (a); aDB.Kill (b); aDB.Kill (c)

	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	_G[chat.."EditBox"]:Hide()
	
	_G[chat.."EditBox"]:ClearAllPoints();
	_G[chat.."EditBox"]:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -14, 15)
	_G[chat.."EditBox"]:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 14, 15)
	

	_G[chat.."EditBox"]:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)

	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)

	if _G[chat] == _G["ChatFrame2"] then
		FCF_SetWindowName(_G[chat], "Log")
	end
	
	local EditBoxBackground = CreateFrame("frame", "ChatchatEditBoxBackground", ChatFrame1)
	EditBoxBackground:SetSize(100, 20)
	EditBoxBackground:ClearAllPoints()
	
	local nnmouseoveralpha = 1
	local nomouseoveralpha = 0
	
	hooksecurefunc("FCFTab_UpdateAlpha", function()
		_G[chat.."Tab"]:SetAlpha(0)
		_G[chat.."Tab"].mouseOverAlpha = nnmouseoveralpha
		_G[chat.."Tab"].noMouseAlpha = nomouseoveralpha
	end)
end

local function SetupChat(self, event, addon)
	if addon ~= "AltUI" then return end
	self:UnregisterEvent("ADDON_LOADED")
					
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
	end
	
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	
	InterfaceOptionsSocialPanelWholeChatWindowClickable:Hide()
	InterfaceOptionsSocialPanelWholeChatWindowClickable:SetScript("OnShow", function(self) self:Hide() end) 
	InterfaceOptionsSocialPanelConversationMode:Hide()
end

local function SetupChatPosAndFont(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		
		chat:SetFont(aDB["fonts"].chat_font, aDB["chat"].font_size)
		chat:SetSize(aDB["chat"].chatframewidth, aDB["chat"].chatframeheight)
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetPoint(unpack(aDB["chat"].chatframe))
			FCF_SavePositionAndDimensions(chat)
		end
	end
end

Chat:RegisterEvent("ADDON_LOADED")
Chat:RegisterEvent("PLAYER_ENTERING_WORLD")
Chat["ADDON_LOADED"] = SetupChat
Chat["PLAYER_ENTERING_WORLD"] = SetupChatPosAndFont

local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

local function ClassColors(class)
	if not class then return end
	class = (replace(class, " ", "")):upper()
	local c = RAID_CLASS_COLORS[class]
	if c then
		return string.format("%02x%02x%02x", c.r*255, c.g*255, c.b*255)
	end
end

FCFTab_UpdateColors = function(chattabs, selected)
	local color = RAID_CLASS_COLORS[aDB.myclass]
	local fs = chattabs:GetFontString()
	fs:SetFont(aDB["fonts"].chat_tab_font, aDB["fonts"].chat_tab_font_size, aDB["fonts"].chat_tab_font_style)
	fs:SetShadowOffset(0, 0)
	if selected then
		fs:SetTextColor(color.r, color.g, color.b)
	else
		fs:SetTextColor(1, 1, 1)
	end
end

local function CHAT_MSG_SYSTEM(...)
	local login = select(3, find(arg1, "^|Hplayer:(.+)|h%[(.+)%]|h has come online."))
	local classColor = "999999"
	local foundColor = true
			
	if login then
		local found = false
		if GetNumFriends() > 0 then ShowFriends() end
		
		for friendIndex = 1, GetNumFriends() do
			local friendName, _, class = GetFriendInfo(friendIndex)
			if friendName == login then
				classColor = ClassColors(class)
				found = true
				break
			end
		end
		
		if not found then
			if IsInGuild() then GuildRoster() end
			for guildIndex = 1, GetNumGuildMembers(true) do
				local guildMemberName, _, _, _, _, _, _, _, _, _, class = GetGuildRosterInfo(guildIndex)
				if guildMemberName == login then
					classColor = ClassColors(class)
					break
				end
			end
		end
		
	end
	
	if login then
		local AddMessageOriginal = ChatFrame1.AddMessage
		local function AddMessageHook(frame, text, ...)
			text = replace(text, "^|Hplayer:(.+)|h%[(.+)%]|h", "|Hplayer:%1|h|cff"..classColor.."%2|r|h")
			ChatFrame1.AddMessage = AddMessageOriginal
			return AddMessageOriginal(frame, text, ...)
		end
		ChatFrame1.AddMessage = AddMessageHook
	end
end
Chat:RegisterEvent("CHAT_MSG_SYSTEM")
Chat["CHAT_MSG_SYSTEM"] = CHAT_MSG_SYSTEM

local function AddMessageHook(frame, text, ...)
	for k,v in pairs(replaceschan) do
		text = text:gsub('|h%['..k..'%]|h', '|h'..v..'|h')
	end
	text = replace(text, "has come online.", "is now |cff298F00online|r !")
	text = replace(text, "has gone offline.", "is now |cffff0000offline|r !")
	text = replace(text, "ist jetzt online.", "ist jetzt |cff298F00online|r !")
	text = replace(text, "ist jetzt offline.", "ist jetzt |cffff0000offline|r !")
	text = replace(text, "|Hplayer:(.+)|h%[(.+)%]|h has earned", "|Hplayer:%1|h%2|h has earned")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h whispers:", "From [|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h says:", "[|Hplayer:%1:%2|h%3|h]:")	
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h yells:", "[|Hplayer:%1:%2|h%3|h]:")
	if find(text, replace(ERR_AUCTION_SOLD_S,'%%s', '')) then
		local itemname = text:match(replace(ERR_AUCTION_SOLD_S, '%%s', '(.+)'))
		text = "|cffef4341"..BUTTON_LAG_AUCTIONHOUSE.."|r - |cffBCD8FF"..ITEM_SOLD_COLON.."|r "
		local _, solditem = GetItemInfo(itemname)
		if solditem then
			text = text..solditem
		else
			text = text..itemname
		end
	end 
	return AddMessageOriginal(frame, text, ...)
end

function aDB.ChannelsEdits()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local frame = _G["ChatFrame"..i]
			AddMessageOriginal = frame.AddMessage
			frame.AddMessage = AddMessageHook
		end
	end
end
aDB.ChannelsEdits()

_G.CHAT_FLAG_AFK = locale.afk
_G.CHAT_FLAG_DND = locale.dnd
_G.CHAT_FLAG_GM = locale.gm

local ScrollLines = 3 
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end

------------------------------------------------------------------------
--	Hyperlink (item, spell and more...)
------------------------------------------------------------------------
local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP", 0, 30)
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end

	if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end

function HyperlinkMouseover()
	local _G = getfenv(0)
	for i=1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local frame = _G["ChatFrame"..i]
			orig1[frame] = frame:GetScript("OnHyperlinkEnter")
			frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

			orig2[frame] = frame:GetScript("OnHyperlinkLeave")
			frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
		end
	end
end
HyperlinkMouseover()

------------------------------------------------------------------------
--	CopyURL module
------------------------------------------------------------------------
local SetItemRef_orig = SetItemRef
function ReURL_SetItemRef(link, text, button, chatFrame)
	if (strsub(link, 1, 3) == "url") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local url = strsub(link, 5);
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(url)
		ChatFrameEditBox:HighlightText()

	else
		SetItemRef_orig(link, text, button, chatFrame)
	end
end
SetItemRef = ReURL_SetItemRef

function ReURL_AddLinkSyntax(chatstring)
	if (type(chatstring) == "string") then
		local extraspace;
		if (not strfind(chatstring, "^ ")) then
			extraspace = true;
			chatstring = " "..chatstring;
		end
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", ReURL_Link("www.%1.%2"))
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", ReURL_Link("%1://%2"))
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", ReURL_Link("%1@%2%3%4"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4:%5"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4"))
		if (extraspace) then
			chatstring = strsub(chatstring, 2);
		end
	end
	return chatstring
end

REURL_COLOR = "16FF5D"
ReURL_Brackets = false
ReUR_CustomColor = true

function ReURL_Link(url)
	if (ReUR_CustomColor) then
		if (ReURL_Brackets) then
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (ReURL_Brackets) then
			url = " |Hurl:"..url.."|h["..url.."]|h "
		else
			url = " |Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end

for i=1, NUM_CHAT_WINDOWS do
	local frame = getglobal("ChatFrame"..i)
	local addmessage = frame.AddMessage
	frame.AddMessage = function(self, text, ...) addmessage(self, ReURL_AddLinkSyntax(text), ...) end
end

------------------------------------------------------------------------
--	Chat Filter
------------------------------------------------------------------------
if aDB["chat"].filter == true then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)
	DUEL_WINNER_KNOCKOUT = ""
	DUEL_WINNER_RETREAT = ""
	DRUNK_MESSAGE_ITEM_OTHER1 = ""
	DRUNK_MESSAGE_ITEM_OTHER2 = ""
	DRUNK_MESSAGE_ITEM_OTHER3 = ""
	DRUNK_MESSAGE_ITEM_OTHER4 = ""
	DRUNK_MESSAGE_OTHER1 = ""
	DRUNK_MESSAGE_OTHER2 = ""
	DRUNK_MESSAGE_OTHER3 = ""
	DRUNK_MESSAGE_OTHER4 = ""
	DRUNK_MESSAGE_ITEM_SELF1 = ""
	DRUNK_MESSAGE_ITEM_SELF2 = ""
	DRUNK_MESSAGE_ITEM_SELF3 = ""
	DRUNK_MESSAGE_ITEM_SELF4 = ""
	DRUNK_MESSAGE_SELF1 = ""
	DRUNK_MESSAGE_SELF2 = ""
	DRUNK_MESSAGE_SELF3 = ""
	DRUNK_MESSAGE_SELF4 = ""
	RAID_MULTI_LEAVE = ""
	RAID_MULTI_JOIN = ""
	ERR_PET_LEARN_ABILITY_S = ""
	ERR_PET_LEARN_SPELL_S = ""
	ERR_PET_SPELL_UNLEARNED_S = ""
end