----------------------------------------------------------------------------------------
--	Reskin Blizzard standart frames
----------------------------------------------------------------------------------------
local function SkinButton(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")
	aDB.SetStyle(f)
	aDB.LolSkin(f)
end

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") then return end

		local skins = {
			"StaticPopup1",
			"StaticPopup2",
			"AutoCompleteBox",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"LFDDungeonReadyDialog",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"ColorPickerFrame",
			"ConsolidatedBuffsTooltip",
			"ReadyCheckFrame",
			"LFDRoleCheckPopup",
			"VoiceChatTalkers",
			"ChannelPulloutBackground",
		}
		-- skin reputation frame
		local function UpdateFactionSkins()
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(aDB["media"].texture)

					if not statusbar.reskinned then
						aDB.SetStyle(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end		
			end		
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)
		
		-- reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		for i = 1, getn(skins) do
			aDB.SetStyle(_G[skins[i]])
			aDB.CreatePanelShadow(_G[skins[i]])
			if _G[skins[i]] ~= _G["GhostFrameContentsFrame"] and _G[skins[i]] ~= _G["AutoCompleteBox"] then
			aDB.SetStyle(_G[skins[i]])
			end
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) aDB.SetStyle(self) self:ClearAllPoints() self:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) aDB.SetStyle(self) end)
			end
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
		local UIMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if UIMenuButtons then
				SkinButton(UIMenuButtons)
			end
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame"
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint('TOP', GameMenuFrame, 0, 7)
				else
					title:SetPoint('TOP', BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all other buttons
		local BlizzardButtons = {
			"VideoOptionsFrameOkay",
			"VideoOptionsFrameCancel",
			"VideoOptionsFrameDefaults",
			"VideoOptionsFrameApply",
			"AudioOptionsFrameOkay",
			"AudioOptionsFrameCancel",
			"AudioOptionsFrameDefaults",
			"InterfaceOptionsFrameDefaults",
			"InterfaceOptionsFrameOkay",
			"InterfaceOptionsFrameCancel",
			"ColorPickerOkayButton",
			"ColorPickerCancelButton",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
		}
		
		for i = 1, getn(BlizzardButtons) do
		local Buttons = _G[BlizzardButtons[i]]
			if Buttons then
				SkinButton(Buttons)
			end
		end
		-- if a button position is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint('RIGHT', _G["VideoOptionsFrameApply"], 'LEFT', -4, 0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint('RIGHT', _G["VideoOptionsFrameCancel"], 'LEFT', -4, 0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint('RIGHT', _G["AudioOptionsFrameCancel"], 'LEFT', -4, 0)		 	 
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint('RIGHT', _G["InterfaceOptionsFrameCancel"], 'LEFT', -4, 0)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint('BOTTOMRIGHT', ColorPickerFrame, 'BOTTOMRIGHT', -6, 6)
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:SetPoint('RIGHT', _G["ColorPickerCancelButton"], 'LEFT', -4, 0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint('RIGHT', _G["ReadyCheckFrame"], 'CENTER', -3, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint('LEFT', _G["ReadyCheckFrameYesButton"], 'RIGHT', 5, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint('TOP', 0, -12)
end)