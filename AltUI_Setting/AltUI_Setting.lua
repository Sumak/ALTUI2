------------------------------------------------------------------------
--	In-game configuration for AltUI (great idea by Tohveli)
------------------------------------------------------------------------
local ALLOWED_GROUPS = {
	["unitframe"] = 1,
	["general"] = 1,
	["chat"] = 1,
	["actionbar"] = 1,
	["bags"] = 1,
	["lootroll"] = 1,
	["minimap"] = 1,
	["nameplates"] = 1,
	["filger"] = 1,
	["cooldown_flash"] = 1,
	["addons_skin"] = 1
}

local function Local(o)
	if o == "UIConfiggeneral" then o = "Главные опции" end
	if o == "UIConfiggeneralhide_ugly_errors" then o = "Скрывать ошибки" end
	if o == "UIConfiggeneralshadow_border" then o = "Включить тёмную границу вокруг всего экрана" end
	if o == "UIConfiggeneralshadow_border_alpha" then o = "Прозрачность тёмной границы" end
	if o == "UIConfiggeneralUIScale" then o = "Установить значение UIScale:" end
	if o == "UIConfiggeneralauto_UI_Scale" then o = "Автоматически скалировать изображение" end
	if o == "UIConfiggeneralauto_decline_duel" then o = "Автоматическая отмена дуэлей" end
	if o == "UIConfiggeneralauto_accept_invite" then o = "Автоматически принимать приглашения в группу от друзей и согильдейцев" end
	if o == "UIConfiggeneralauto_sell_crap_repair" then o = "Автоматически продавать серый хлам и чиниться" end
	
	if o == "UIConfigchat" then o = "Чат" end
	if o == "UIConfigchatchat_bar" then o = "Включить чатбар(панель с каналами чата)" end
	if o == "UIConfigchatchatframewidth" then o = "Ширина чата" end
	if o == "UIConfigchatchatframeheight" then o = "Высота чата" end
	if o == "UIConfigchatfont_size" then o = "Размер шрифта в чате" end
	if o == "UIConfigchatfilter" then o = "Чат-фильтр (отключает анонс дуэлей и т.д.)" end
	
	if o == "UIConfigactionbar" then o = "Панели команд" end
	if o == "UIConfigactionbarhotkey" then o = "Отображать бинды на кнопках" end
	if o == "UIConfigactionbarmacro_text" then o = "Отображать текст макросов на кнопках" end
	if o == "UIConfigactionbarrightbars" then o = "Кол-во панелей справа (от 1 до 3)" end
	if o == "UIConfigactionbarshowgrid" then o = "Показывать пустые кнопки" end
	if o == "UIConfigactionbarbutton_size" then o = "Размер кнопок" end
	if o == "UIConfigactionbarspacing" then o = "Расстояние между кнопками" end
	if o == "UIConfigactionbarrightbars_mouseover" then o = "Показывать правые панели по наведению курсора" end
	
	if o == "UIConfigbags" then o = "Инвентарь" end
	if o == "UIConfigbagsbutton_size" then o = "Размер ячеек инвентаря" end
	if o == "UIConfigbagsbag_button_size" then o = "Размер ячеек сумок" end
	
	if o == "UIConfiglootroll" then o = "Розыгрыш добычи" end
	if o == "UIConfiglootrollroll_width" then o = "Ширина панели ролла" end
	if o == "UIConfiglootrollroll_height" then o = "Высота панели ролла" end
	if o == "UIConfiglootrollicon_size" then o = "Размер иконки лута" end
	if o == "UIConfiglootrollloot_frame_width" then o = "Ширина панели лута" end
	if o == "UIConfiglootrollslot_size" then o = "Размер слота лута" end
	
	if o == "UIConfignameplates" then o = "Полоски здоровья" end
	if o == "UIConfignameplatesenable" then o = "Включить полоски здоровья" end
	
	if o == "UIConfigminimap" then o = "Миникарту" end
	if o == "UIConfigminimapenable" then o = "Включить миникарту" end
	if o == "UIConfigminimapsize" then o = "Размер карты" end
	
	if o == "UIConfigunitframe" then o = "Рамки игроков" end
	if o == "UIConfigunitframesmooth_bar" then o = "Сделать полоски хп и маны плавными, когда наносится урон" end
	if o == "UIConfigunitframeown_statusbar_color" then o = "Включить свой цвет юнитфреймов, серый по умолчанию" end
	if o == "UIConfigunitframeaura_tracker" then o = "Включить отображение крауд-контроля на портретах персонажей" end
	if o == "UIConfigunitframeplugin_combo_points" then o = "Показывать панель комбо-поинтов для Разбойников и Ферал-Друидов" end
	if o == "UIConfigunitframecombat_feedback" then o = "Включить комбат текст на юнитфреймах" end
	if o == "UIConfigunitframedesaturated_debuffs" then o = "Включить не свои дебаффы серым цветом" end
	if o == "UIConfigunitframefocus_debuffs" then o = "Включить дебаффы на фокус-фрейме" end
	if o == "UIConfigunitframeenable_portraits" then o = "Отображать портреты" end
	if o == "UIConfigunitframerest_icon" then o = "Отображать иконку отдыха персонажа" end
	if o == "UIConfigunitframeplugin_totem_bar" then o = "Включить панель тотемов для Шаманов" end
	if o == "UIConfigunitframeplugin_rune_bar" then o = "Включить панель рун для Рыцарей смерти" end
	if o == "UIConfigunitframeshow_combo_points" then o = "Включить индикатор серии приемов" end
	if o == "UIConfigunitframeshowParty" then o = "Показывать фрейм группы" end
	if o == "UIConfigunitframeshowSolo" then o = "Показывать рейд фрейм (соло режим)" end
	if o == "UIConfigunitframeshow" then o = "Показывать рейд фрейм" end
	if o == "UIConfigunitframeinside_alpha" then o = "Прозрачность группы и рейда в зоне досягаемости" end
	if o == "UIConfigunitframeoutside_alpha" then o = "Прозрачность группы и рейда вне зоны досягаемости" end
	
	if o == "UIConfigfilger" then o = "Filger" end
	if o == "UIConfigfilgericon_size" then o = "Размер иконок заклинаний" end
	if o == "UIConfigfilgerspacing" then o = "Расстояние между иконками заклинаний" end
	if o == "UIConfigfilgerenable_config_mode" then o = "Включить тест-мод" end
	
	if o == "UIConfigcooldown_flash" then o = "CooldownFlash" end
	if o == "UIConfigcooldown_flashenable" then o = "Включить CooldownFlash" end
	if o == "UIConfigcooldown_flashicon_size" then o = "Размер иконки кулдауна" end
	if o == "UIConfigcooldown_flashfade_out_time" then o = "Время исчезновения иконки" end
	if o == "UIConfigcooldown_flashcooldown_font_size" then o = "Размер шрифта кулдаунов на панелях команд и Filger" end
	
	if o == "UIConfigaddons_skin" then o = "Стилизация аддонов" end
	if o == "UIConfigaddons_skinomen" then o = "Стилизовать Omen" end
	if o == "UIConfigaddons_skindbm" then o = "Стилизовать Deadly Boss Mods" end
	if o == "UIConfigaddons_skinskada" then o = "Стилизовать Skada" end
	if o == "UIConfigaddons_skinrecount" then o = "Стилизовать Recount" end
	
	aDB.option = o
end

local NewButton = function(text,parent)
	local result = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	local label = result:CreateFontString(nil, "OVERLAY")
	label:SetFont(aDB["fonts"].simple_font, 12, aDB["fonts"].simple_font_style)
	label:SetTextColor(1, 1, 1)
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)
	result:SetNormalTexture("")
	result:SetHighlightTexture("")
	result:SetPushedTexture("")

	return result
end

local function SetValue(group, option, value)
	if not GUIConfig then
		GUIConfig = {}
	end
	if not GUIConfig[group] then
		GUIConfig[group] = {}
	end
	GUIConfig[group][option] = value
end

local VISIBLE_GROUP = nil
local lastbutton = nil
local function ShowGroup(group, button)
	if (lastbutton) then
		lastbutton:SetText(lastbutton:GetText().sub(lastbutton:GetText(), 11, -3))
	end
	if (VISIBLE_GROUP) then
		_G["UIConfig"..VISIBLE_GROUP]:Hide()
	end
	if _G["UIConfig"..group] then
		local o = "UIConfig"..group
		Local(o)
		local height = _G["UIConfig"..group]:GetHeight()
		_G["UIConfig"..group]:Show()
		local scrollamntmax = 305
		local scrollamntmin = scrollamntmax - 10
		local max = height > scrollamntmax and height-scrollamntmin or 1
		
		if max == 1 then
			_G["UIConfigGroupSlider"]:SetValue(1)
			_G["UIConfigGroupSlider"]:Hide()
		else
			_G["UIConfigGroupSlider"]:SetMinMaxValues(0, max)
			_G["UIConfigGroupSlider"]:Show()
			_G["UIConfigGroupSlider"]:SetValue(1)
		end
		_G["UIConfigGroup"]:SetScrollChild(_G["UIConfig"..group])
		
		local x
		if UIConfigGroupSlider:IsShown() then 
			_G["UIConfigGroup"]:EnableMouseWheel(true)
			_G["UIConfigGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if UIConfigGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["UIConfigGroupSlider"]:GetValue()
						_G["UIConfigGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["UIConfigGroupSlider"]:GetValue()			
						_G["UIConfigGroupSlider"]:SetValue(x - 30)	
					end
				end
			end)
		else
			_G["UIConfigGroup"]:EnableMouseWheel(false)
		end
		
		VISIBLE_GROUP = group
		lastbutton = button
	end
end

function CreateUIConfig()
	if UIConfig then
		ShowGroup("general")
		UIConfig:Show()
		return
	end
	
	local UIConfig = CreateFrame("Frame", "UIConfig", UIParent)
	UIConfig:SetPoint('CENTER', UIParent, 100, 0)
	UIConfig:SetWidth(470)
	UIConfig:SetHeight(350)
	UIConfig:SetFrameLevel(93)
	aDB.SetStyle(UIConfig)
	aDB.CreatePanelShadow(UIConfig)
	tinsert(UISpecialFrames, 'UIConfig')
	
	local TitleBox = CreateFrame("Frame", "UIConfig", UIConfig)
	TitleBox:SetWidth(621)
	TitleBox:SetHeight(23)
	TitleBox:SetPoint('TOP', -76, 24)
	aDB.SetStyle(TitleBox)
	aDB.CreatePanelShadow(TitleBox)
	
	local TitleBoxText = TitleBox:CreateFontString(nil, "OVERLAY")
	TitleBoxText:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size * 2, aDB["fonts"].panel_font_style)
	TitleBoxText:SetPoint('CENTER', 0, 2)
	TitleBoxText:SetText('|cff0099CCAltUI|r')
	
	local groups = CreateFrame("ScrollFrame", "UIConfigCategoryGroup", UIConfig)
	groups:SetPoint('TOPRIGHT', UIConfig, 'TOPLEFT', -1, 0)
	groups:SetWidth(150)
	groups:SetHeight(350)
	aDB.SetStyle(groups)
	aDB.CreatePanelShadow(groups)
	
	local child = CreateFrame("Frame", nil, groups)
	child:SetPoint('TOP')
	local offset = 5
	for group in pairs(ALLOWED_GROUPS) do
		local o = "UIConfig"..group
		Local(o)
		local button = NewButton(aDB.option, child)
		button:SetHeight(15)
		button:SetWidth(150)
		button:SetPoint('TOP', 10, -(offset))
		button:SetScript("OnClick", function(self) ShowGroup(group, button) self:SetText("|cff00ff00"..aDB.option.."|r") end)
		offset = offset + 20
	end
	child:SetWidth(100)
	child:SetHeight(offset)

	local group = CreateFrame("ScrollFrame", "UIConfigGroup", UIConfig)
	group:SetPoint('TOPLEFT', 0, -5)
	group:SetWidth(400)
	group:SetHeight(310)
	groups:SetScrollChild(child)
	
	local slider = CreateFrame("Slider", "UIConfigGroupSlider", group)
	slider:SetPoint('TOPRIGHT', 0, -10)
	slider:SetWidth(15)
	slider:SetHeight(300)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation('VERTICAL')
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) group:SetVerticalScroll(value) end)
	slider:Hide()
	aDB.SetStyle(slider)
	
	for group in pairs(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame", "UIConfig"..group, UIConfigGroup)
		frame:SetPoint('TOPLEFT')
		frame:SetWidth(200)
	
		local offset = 5
		for option,value in pairs(aDB[group]) do
			
			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "UIConfig"..group..option, frame, "InterfaceOptionsCheckButtonTemplate")
				local o = "UIConfig"..group..option
				Local(o)
				_G["UIConfig"..group..option.."Text"]:SetText(aDB.option)
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint('TOPLEFT', 10, -(offset + 10))
				button:SetSize(20, 20)
				button:SetNormalTexture("")
				button:SetPushedTexture("")
				button:SetHighlightTexture("")
				aDB.SetStyle(button)
				offset = offset + 25
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				local o = "UIConfig"..group..option
				Local(o)
				label:SetText(aDB.option)
				label:SetWidth(400)
				label:SetHeight(20)
				label:SetJustifyH('LEFT')
				label:SetPoint('TOPLEFT', 10, -(offset))
				
				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(200)
				editbox:SetHeight(15)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3, 0, 0, 0)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint('TOPLEFT', 10, -(offset + 20))
				editbox:SetText(value)
				aDB.SetStyle(editbox)
				
				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetWidth(editbox:GetHeight() + 5)
				okbutton:SetHeight(editbox:GetHeight() + 5)
				okbutton:SetPoint('LEFT', editbox, 'RIGHT', 2, 0)
				aDB.SetStyle(okbutton)
				
				local oktext = okbutton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				oktext:SetText("ОK")
				oktext:SetPoint('CENTER')
				okbutton:Hide()
 
				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
				
				offset = offset + 40
			end
		end
		frame:SetHeight(offset)
		frame:Hide()
	end

	local Reset = CreateFrame("Button", "Resetbutton", UIConfig, "SecureActionButtonTemplate")
	Reset:SetWidth(UIConfig:GetWidth() / 2)
	Reset:SetHeight(20)
	Reset:SetPoint('BOTTOMLEFT', 0, -21)
	Reset:SetScript("OnClick", function(self) GUIConfig = {} ReloadUI() end)
	aDB.SetStyle(Reset)
	aDB.CreatePanelShadow(Reset)
	aDB.LolSkin(Reset)
	
	local ResetText = Reset:CreateFontString(Reset)
	ResetText:SetPoint('CENTER', 0, 1)
	ResetText:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
	ResetText:SetText("Сбросить настройки")
	
	local Load = CreateFrame("Button", "Applybutton", UIConfig, "SecureActionButtonTemplate")
	Load:SetWidth(UIConfig:GetWidth() / 2.01)
	Load:SetHeight(20)
	Load:SetPoint('TOPLEFT', Reset, 'TOPRIGHT', 1, 0)
	Load:SetScript("OnClick", function(self) ReloadUI() end)
	aDB.SetStyle(Load)
	aDB.CreatePanelShadow(Load)
	aDB.LolSkin(Load)
	
	local LoadText = Load:CreateFontString(Load)
	LoadText:SetPoint('CENTER', 0, 1)
	LoadText:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
	LoadText:SetText("Принять настройки")
	
	local close = CreateFrame("Button", "Closebutton", UIConfig, "SecureActionButtonTemplate")
	close:SetWidth(150)
	close:SetHeight(20)
	close:SetPoint('TOPRIGHT', Reset, 'TOPLEFT', -1, 0)
	close:SetScript("OnClick", function(self) PlaySound("igMainMenuOption") UIConfig:Hide() end)
	aDB.SetStyle(close)
	aDB.CreatePanelShadow(close)
	aDB.LolSkin(close)
	
	local closeText = close:CreateFontString(close)
	closeText:SetPoint('CENTER', 0, 1)
	closeText:SetFont(aDB["fonts"].panel_font, aDB["fonts"].panel_font_size, aDB["fonts"].panel_font_style)
	closeText:SetText("Закрыть")
	
	ShowGroup("general")
end

do
	SLASH_CONFIG1 = "/altcfg"
	function SlashCmdList.CONFIG(msg, editbox)
		if not UIConfig or not UIConfig:IsShown() then
			PlaySound("igMainMenuOption")
			CreateUIConfig()
			HideUIPanel(GameMenuFrame)
		else
			PlaySound("igMainMenuOption")
			UIConfig:Hide()
		end
	end
end