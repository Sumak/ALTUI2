----------------------------------------------------------------------------------------
--	sFilger(by Nils Ruesch)
----------------------------------------------------------------------------------------
local f_s = Filger_Settings;

local class = select(2, UnitClass("player"));
local classcolor = RAID_CLASS_COLORS[class];
local active, bars = {}, {};

local MyUnits = {
    player = true,
    vehicle = true,
    pet = true,
}

local time, Update;
local function OnUpdate(self, elapsed)
	time = self.filter == "CD" and self.expirationTime+self.duration-GetTime() or self.expirationTime-GetTime();
	if ( self:GetParent().Mode == "BAR" ) then
		self.statusbar:SetValue(time);
		if time <= 60 then
			self.time:SetFormattedText("%.1f",(time));
		else
			self.time:SetFormattedText("%d:%.2d",(time/60),(time%60));
		end
	end
	if ( time < 0 and self.filter == "CD" ) then
		local id = self:GetParent().Id;
		for index, value in ipairs(active[id]) do
			local spn = GetSpellInfo( value.data.spellID or value.data.slotID )
			if ( self.spellName == spn) then
				tremove(active[id], index);
				break;
			end
		end
		self:SetScript("OnUpdate", nil);
		Update(self:GetParent());
	end
end

function Update(self)
	local id = self.Id;
	if ( not bars[id] ) then
		bars[id] = {};
	end
	for index, value in ipairs(bars[id]) do
		value:Hide();
	end
	local bar;
	for index, value in ipairs(active[id]) do
		bar = bars[id][index];
		if ( not bar ) then
			bar = CreateFrame("Frame", "FilgerAnker"..id.."Frame"..index, self);
			bar:SetWidth(value.data.size);
			bar:SetHeight(value.data.size);
			bar:SetFrameStrata("LOW")

			if ( index == 1 ) then
				bar:SetPoint(unpack(self.setPoint));
			else
				if ( self.Direction == "UP" ) then
					bar:SetPoint("BOTTOM", bars[id][index-1], "TOP", 0, self.Interval);
				elseif ( self.Direction == "RIGHT" ) then
					bar:SetPoint("LEFT", bars[id][index-1], "RIGHT", self.Mode == "ICON" and self.Interval or value.data.barWidth+self.Interval, 0);
				elseif ( self.Direction == "LEFT" ) then
					bar:SetPoint("RIGHT", bars[id][index-1], "LEFT", self.Mode == "ICON" and -self.Interval or -(value.data.barWidth+self.Interval), 0);
				else
					bar:SetPoint("TOP", bars[id][index-1], "BOTTOM", 0, -self.Interval);
				end
			end
			if ( self.Mode == "ICON" ) then
				bar.icon = bar:CreateTexture("$parentIcon", "OVERLAY");
				bar.icon:SetPoint('TOPLEFT', 1, -1)
				bar.icon:SetPoint('BOTTOMRIGHT', -1, 1)
				bar.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				
				bar.cooldown = CreateFrame("Cooldown", nil, bar, "CooldownFrameTemplate");
				bar.cooldown:SetReverse();				
				bar.cooldown:ClearAllPoints();
				bar.cooldown:SetPoint('TOPLEFT', bar, 'TOPLEFT', 1, -1);
				bar.cooldown:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', -1, 1);
				
				bar.count = bar.cooldown:CreateFontString(nil, "OVERLAY");
				bar.count:SetFont(aDB["fonts"].filger_font, aDB["fonts"].filger_font_size, aDB["fonts"].filger_font_style);
				bar.count:SetPoint('TOPLEFT', 1, 1);
				bar.count:SetJustifyH('RIGHT');
				bar.count:SetTextColor(1, 1, 1);
				
				bar.overlay = CreateFrame("Frame", nil, bar)
				aDB.SetStyle(bar.overlay)
				aDB.CreatePanelShadow(bar.overlay)
				bar.overlay:SetFrameStrata('BACKGROUND')
				bar.overlay:SetAllPoints(bar.overlay:GetParent())
			else
				bar.icon = bar:CreateTexture(nil, "ARTWORK")
				bar.icon:SetPoint('TOPLEFT', 1, -1)
				bar.icon:SetPoint('BOTTOMRIGHT', -1, 1)
				bar.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				
				bar.count = bar:CreateFontString(nil, "ARTWORK");
				bar.count:SetFont(aDB["fonts"].filger_font, aDB["fonts"].filger_font_size, aDB["fonts"].filger_font_style);
				bar.count:SetPoint('BOTTOMRIGHT', 1, 2);
				bar.count:SetJustifyH('RIGHT');
				bar.count:SetTextColor(1, 1, 1);
				
				bar.overlay = CreateFrame("Frame",nil, bar)
				aDB.SetStyle(bar.overlay)
				aDB.CreatePanelShadow(bar.overlay)
				bar.overlay:SetFrameStrata('BACKGROUND')
				bar.overlay:SetAllPoints(bar.overlay:GetParent())
				
				bar.statusbar = CreateFrame("StatusBar", nil, bar);
				bar.statusbar:SetFrameStrata('LOW')
				bar.statusbar:SetWidth(value.data.barWidth-2);
				bar.statusbar:SetHeight(value.data.size-10);
				bar.statusbar:SetStatusBarTexture(aDB["media"].texture);
				bar.statusbar:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b, 1);
				bar.statusbar:SetPoint('BOTTOMLEFT', bar, 'BOTTOMRIGHT', 5, 2);
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(0);
				
				bar.statusbar.bg = CreateFrame("Frame", nil, bar.statusbar)
				aDB.SetStyle(bar.statusbar.bg)
				aDB.CreatePanelShadow(bar.statusbar.bg)
				bar.statusbar.bg:ClearAllPoints()
				bar.statusbar.bg:SetFrameStrata('BACKGROUND')
				bar.statusbar.bg:SetPoint('TOPLEFT', bar.statusbar, 'TOPLEFT', -1, 1)
				bar.statusbar.bg:SetPoint('BOTTOMRIGHT', bar.statusbar, 'BOTTOMRIGHT', 1, -1)
				
				bar.statusbar.background = bar.statusbar:CreateTexture(nil, "BACKGROUND");
				bar.statusbar.background:SetAllPoints();
				bar.statusbar.background:SetTexture(aDB["media"].texture);
				bar.statusbar.background:SetVertexColor(classcolor.r, classcolor.g, classcolor.b, 0.35);

				bar.time = bar.statusbar:CreateFontString(nil, "ARTWORK");
				bar.time:SetFont(aDB["fonts"].filger_font, aDB["fonts"].filger_font_size, aDB["fonts"].filger_font_style);
				bar.time:SetPoint('RIGHT', bar.statusbar, 'RIGHT', 0, 1);
				bar.time:SetJustifyH('RIGHT');
				
				bar.spellname = bar.statusbar:CreateFontString(nil, "ARTWORK");
				bar.spellname:SetFont(aDB["fonts"].filger_font, aDB["fonts"].filger_font_size, aDB["fonts"].filger_font_style);
				bar.spellname:SetPoint('LEFT', bar.statusbar, 2, 1);
				bar.spellname:SetPoint('RIGHT', bar.time, 'LEFT');
				bar.spellname:SetJustifyH('LEFT');
			end
			
			tinsert(bars[id], bar);
		end
		
		bar.spellName = GetSpellInfo( value.data.spellID or value.data.slotID );
		
		bar.icon:SetTexture(value.icon);
		bar.count:SetText(value.count > 1 and value.count or "");
		if ( self.Mode == "BAR" ) then
			bar.spellname:SetText(value.data.displayName or GetSpellInfo( value.data.spellID ));
		end
		if ( value.duration > 0 ) then
			if ( self.Mode == "ICON" ) then
				CooldownFrame_SetTimer(bar.cooldown, value.data.filter == "CD" and value.expirationTime or value.expirationTime-value.duration, value.duration, 1);
				if ( value.data.filter == "CD" ) then
					bar.expirationTime = value.expirationTime;
					bar.duration = value.duration;
					bar.filter = value.data.filter;
					bar:SetScript("OnUpdate", OnUpdate);
				end
			else
				bar.statusbar:SetMinMaxValues(0, value.duration);
				bar.expirationTime = value.expirationTime;
				bar.duration = value.duration;
				bar.filter = value.data.filter;
				bar:SetScript("OnUpdate", OnUpdate);
			end
		else
			if ( self.Mode == "ICON" ) then
				bar.cooldown:Hide();
			else
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(1);
				bar.time:SetText("");
				bar:SetScript("OnUpdate", nil);
			end
		end
		
		bar:Show();
	end
end

local function OnEvent(self, event, ...)
	local unit = ...;
	if ( ( unit == "target" or unit == "player" or unit == "pet" or unit == "focus" ) or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "SPELL_UPDATE_COOLDOWN" ) then
		local data, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, start, enabled, slotLink, spn;
		local id = self.Id;
		for i=1, #Filger_Spells[class][id], 1 do
			data = Filger_Spells[class][id][i];
			if ( data.filter == "BUFF" ) then
				spn = GetSpellInfo( data.spellID )
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff(data.unitId, spn);
			elseif ( data.filter == "DEBUFF" ) then
				spn = GetSpellInfo( data.spellID )
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitDebuff(data.unitId, spn);
			else
				if ( data.spellID ) then
					spn = GetSpellInfo( data.spellID )
					start, duration, enabled = GetSpellCooldown( spn );
					_,_,icon = GetSpellInfo( data.spellID );
				else
					slotLink = GetInventoryItemLink("player", data.slotID);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink);
						if ( not data.displayName ) then
							data.displayName = name;
						end
						start, duration, enabled = GetInventoryItemCooldown("player", data.slotID);
					end
				end
				count = 0;
				caster = "all";
			end
			if ( not active[id] ) then
				active[id] = {};
			end
			for index, value in ipairs(active[id]) do
				if ( data.spellID == value.data.spellID ) then
					tremove(active[id], index);
					break;
				end
			end
			if ( ( name and ( data.caster ~= 1 and ( caster == data.caster or data.caster == "all" ) or MyUnits[caster] )) or ( ( enabled or 0 ) > 0 and ( duration or 0 ) > 1.5 ) ) then
				table.insert(active[id], { data = data, icon = icon, count = count, duration = duration, expirationTime = expirationTime or start });
			end
		end
		Update(self);
	end
end

if ( Filger_Spells and Filger_Spells["ALL"] ) then
	if ( not Filger_Spells[class] ) then
		Filger_Spells[class] = {}
	end

	local matched
	for i=1, #Filger_Spells["ALL"], 1 do
		matched = false
		for j=1, #Filger_Spells[class], 1 do
			if Filger_Spells[class][j].Name == Filger_Spells["ALL"][i].Name then
				matched = true
				for k=1, #Filger_Spells["ALL"][i], 1 do
					table.insert(Filger_Spells[class][j], Filger_Spells["ALL"][i][k])
				end
				break
			end
		end
		if matched ~= true then
			table.insert(Filger_Spells[class], Filger_Spells["ALL"][i])
		end
	end
	--[[for i=1, #Filger_Spells["ALL"], 1 do
		table.insert(Filger_Spells[class], Filger_Spells["ALL"][i])
	end]]
end

if ( Filger_Spells and Filger_Spells[class] ) then
	for index in pairs(Filger_Spells) do
		if ( index ~= class ) then
			Filger_Spells[index] = nil;
		end
	end
	local data, frame;
	for i=1, #Filger_Spells[class], 1 do
		data = Filger_Spells[class][i];
		
		frame = CreateFrame("Frame", "FilgerAnker"..i, UIParent);
		frame.Id = i;
		frame.Name = data.Name;
		frame.Direction = data.Direction or "DOWN";
		frame.Interval = data.Interval or 3;
		frame.Mode = data.Mode or "ICON";
		frame.setPoint = data.setPoint or "CENTER";
		frame:SetWidth(Filger_Spells[class][i][1] and Filger_Spells[class][i][1].size or 100);
		frame:SetHeight(Filger_Spells[class][i][1] and Filger_Spells[class][i][1].size or 20);
		frame:SetPoint(unpack(data.setPoint));

		if ( f_s.configmode ) then
			for j=1, #Filger_Spells[class][i], 1 do
				data = Filger_Spells[class][i][j];
				if ( not active[i] ) then
					active[i] = {};
				end
				if ( data.spellID ) then
					_,_,spellIcon = GetSpellInfo(data.spellID)
				else
					slotLink = GetInventoryItemLink("player", data.slotID);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, spellIcon = GetItemInfo(slotLink);
					end
				end
				table.insert(active[i], { data = data, icon = spellIcon, count = 9, duration = 0, expirationTime = 0 });
			end
			Update(frame);
		else
			for j=1, #Filger_Spells[class][i], 1 do
				data = Filger_Spells[class][i][j];
				if ( data.filter == "CD" ) then
					frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
					break;
				end
			end
			frame:RegisterEvent("UNIT_AURA");
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			frame:SetScript("OnEvent", OnEvent);
		end
	end
end