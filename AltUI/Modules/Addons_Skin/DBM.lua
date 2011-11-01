----------------------------------------------------------------------------------------
--	DBM skin (by Affli)
----------------------------------------------------------------------------------------
if not aDB["addons_skin"].dbm == true then return end

local forcebosshealthclasscolor = false		
local croprwicons = true					
local rwiconsize = 12						
local backdrop = {
	bgFile = aDB["media"].texture,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("DBM-Core") then
		local function SkinBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName().."Bar"]
						local spark = _G[frame:GetName().."BarSpark"]
						local texture = _G[frame:GetName().."BarTexture"]
						local icon1 = _G[frame:GetName().."BarIcon1"]
						local icon2 = _G[frame:GetName().."BarIcon2"]
						local name = _G[frame:GetName().."BarName"]
						local timer = _G[frame:GetName().."BarTimer"]

						if (icon1.overlay) then
							icon1.overlay = _G[icon1.overlay:GetName()]
						else
							icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
							icon1.overlay:SetWidth(20)
							icon1.overlay:SetHeight(20)
							icon1.overlay:SetFrameStrata("BACKGROUND")
							icon1.overlay:SetPoint('BOTTOMRIGHT', tbar, 'BOTTOMLEFT', -2, -1)
							aDB.SetStyle(icon1.overlay)
							aDB.CreatePanelShadow(icon1.overlay)
						end

						if (icon2.overlay) then
							icon2.overlay = _G[icon2.overlay:GetName()]
						else
							icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
							icon2.overlay:SetWidth(20)
							icon2.overlay:SetHeight(20)
							icon2.overlay:SetFrameStrata('BACKGROUND')
							icon2.overlay:SetPoint('BOTTOMLEFT', tbar, 'BOTTOMRIGHT', 2, -1)
							aDB.SetStyle(icon2.overlay)
							aDB.CreatePanelShadow(icon2.overlay)
						end

						if bar.color then
							tbar:SetStatusBarColor(0.1, 0.1, 0.1)
							aDB.SetStyle(tbar)
							aDB.CreatePanelShadow(tbar)
							tbar:SetBackdropColor(0.1, 0.1, 0.1, 0.15)
						else
							tbar:SetStatusBarColor(0.1, 0.1, 0.1)
							aDB.SetStyle(tbar)
							aDB.CreatePanelShadow(tbar)
							tbar:SetBackdropColor(0.1, 0.1, 0.1, 0.15)
						end
						
						if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
						if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end

						frame:SetScale(1)
						if not frame.styled then
							frame:SetHeight(20)
							frame.styled = true
						end

						if not spark.killed then
							spark:SetAlpha(0)
							spark:SetTexture(nil)
							spark.killed = true
						end
			
						if not icon1.styled then
							icon1:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon1:ClearAllPoints()
							icon1:SetPoint('TOPLEFT', icon1.overlay, 1, -1)
							icon1:SetPoint('BOTTOMRIGHT', icon1.overlay, -1, 1)
							icon1.styled = true
						end
						
						if not icon2.styled then
							icon2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon2:ClearAllPoints()
							icon2:SetPoint('TOPLEFT', icon2.overlay, 1, -1)
							icon2:SetPoint('BOTTOMRIGHT', icon2.overlay, -1, 1)
							icon2.styled = true
						end
						
						if not texture.styled then
							texture:SetTexture(aDB["media"].texture)
							texture.styled = true
						end
						
						if not tbar.styled then
							tbar:SetPoint('TOPLEFT', frame, 'TOPLEFT', 1, -1)
							tbar:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -1, 1)
							tbar.styled = true
						end

						if not name.styled then
							name:ClearAllPoints()
							name:SetPoint('LEFT', frame, 'LEFT', 4, 2)
							name:SetWidth(100)
							name:SetHeight(7)
							name:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
							name:SetShadowOffset(0, 0, 0, 0)
							name:SetJustifyH('LEFT')
							name.SetFont = dummy
							name.styled = true
						end
						
						if not timer.styled then	
							timer:ClearAllPoints()
							timer:SetPoint('RIGHT', frame, 'RIGHT', -4, 2)
							timer:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
							timer:SetShadowOffset(0, 0, 0, 0)
							timer:SetJustifyH('RIGHT')
							timer.SetFont = dummy
							timer.styled = true
						end
						
						
						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						texture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
				end
			end
		end

		local SkinBossTitle = function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header = {anchor:GetRegions()}
				if header[1]:IsObjectType("FontString") then
					header[1]:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
					header[1]:SetShadowOffset(0, 0, 0, 0)
					header[1]:SetTextColor(1, 1, 1, 1)
					anchor.styled = true	
				end
				header = nil
			end
			anchor = nil
		end
		
		local SkinBoss = function()
			local count = 1
			while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
				local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
				local background = _G[bar:GetName().."BarBorder"]
				local progress = _G[bar:GetName().."Bar"]
				local name = _G[bar:GetName().."BarName"]
				local timer = _G[bar:GetName().."BarTimer"]
				local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]

				if (count == 1) then
					local _, anch, _ , _, _ = bar:GetPoint()
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint('BOTTOM', anch, 'TOP', 0, 3)
					else
						bar:SetPoint('TOP', anch, 'BOTTOM', 0, -3)
					end
				else
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint('BOTTOMLEFT', prev, 'TOPLEFT', 0, 3)
					else
						bar:SetPoint('TOPLEFT', prev, 'BOTTOMLEFT', 0, -3)
					end
				end

				if not bar.styled then
					bar:SetScale(1)
					bar:SetHeight(20)
					background:SetNormalTexture(nil)
					bar.styled = true
				end	
				
				if not progress.styled then
					progress:SetStatusBarTexture(aDB["media"].texture)
					aDB.SetStyle(progress)
					aDB.CreatePanelShadow(progress)
					progress:SetBackdropColor(r, g, b, 1)
					if forcebosshealthclasscolor then
						local tslu = 0
						progress:SetStatusBarColor(r, g, b, 1)
						progress:HookScript("OnUpdate", function(self, elapsed)
							tslu = tslu+ elapsed
							if tslu > 0.025 then
								self:SetStatusBarColor(r,g,b,1)
								tslu = 0
							end
						end)
					end
					progress.styled = true
				end
				progress:ClearAllPoints()
				progress:SetPoint('TOPLEFT', bar, 'TOPLEFT', 1, -1)
				progress:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', -1, 1)

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint('LEFT', bar, 'LEFT', 4, 2)
					name:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
					name:SetShadowOffset(0, 0, 0, 0)
					name:SetJustifyH('LEFT')
					name.styled = true
				end
				
				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint('RIGHT', bar, 'RIGHT', -4, 2)
					timer:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
					timer:SetShadowOffset(0, 0, 0, 0)
					timer:SetJustifyH('RIGHT')
					timer.styled = true
				end
				count = count + 1
			end
		end
		
		hooksecurefunc(DBT, "CreateBar", SkinBars)
		hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
		hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
		hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
		
		DBM.RangeCheck:Show()
		DBM.RangeCheck:Hide()

		
		if croprwicons then
			local replace = string.gsub
			local old = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString=replace(textString,"(:12:12)",":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59")
				end
				return old(noticeFrame, textString, colorInfo)
			end
		end
	end
end)

local UploadDBM = function()
if IsAddOnLoaded("DBM-Core") then
	DBM_SavedOptions.Enabled=true
	DBM_SavedOptions.WarningIconLeft=false
	DBM_SavedOptions.WarningIconRight=false
	DBT_SavedOptions["DBM"].Scale=1
	DBT_SavedOptions["DBM"].HugeScale=1
	DBT_SavedOptions["DBM"].BarXOffset=0
	DBT_SavedOptions["DBM"].BarYOffset=5
	DBT_SavedOptions["DBM"].IconLeft=true
	DBT_SavedOptions["DBM"].ExpandUpwards=true
	DBT_SavedOptions["DBM"].Texture= aDB["media"].texture
	DBT_SavedOptions["DBM"].IconRight=false
end	
end
local loadOptions = CreateFrame("Frame")
loadOptions:RegisterEvent("PLAYER_LOGIN")
loadOptions:SetScript("OnEvent", UploadDBM)