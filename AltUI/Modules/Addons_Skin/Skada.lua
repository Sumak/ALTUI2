if not aDB["addons_skin"].skada == true then return end

if (aDB == nil or Skada == nil) then return; end
aDB.skins = aDB.skins or {}
aDB.skins.Skada = aDB.skins.Skada or {}
local Skada = Skada

local function StripOptions(options)
    options.baroptions.args.bartexture = options.windowoptions.args.height
    options.baroptions.args.bartexture.order = 12
    options.baroptions.args.bartexture.max = 1
    options.baroptions.args.barspacing = nil
    options.titleoptions.args.texture = nil
    options.titleoptions.args.bordertexture = nil
    options.titleoptions.args.thickness = nil
    options.titleoptions.args.margin = nil
    options.titleoptions.args.color = nil
    options.windowoptions = nil
    if not aDB.skins.Skada.nofont or aDB.skins.Skada.nofont ~= true then
        options.baroptions.args.barfont = nil
        options.titleoptions.args.font = nil
    end
end

do
	-- Hook the bar mod
	local barmod = Skada.displays["bar"]
	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
        win.db.enablebackground = true
        win.db.background.borderthickness = 1
		barmod:ApplySettings_(win)
        if win.db.enabletitle then
            win.bargroup.button:SetBackdrop({
                bgFile = aDB["media"].texture,
                tile = false,
                tileSize = 0
            })
        end
        win.bargroup:SetTexture(aDB["media"].texture)
        win.bargroup:SetSpacing(1)
        if not aDB.skins.Skada.nofont or aDB.skins.Skada.nofont ~= true then
            win.bargroup:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
            local titlefont = CreateFont("TitleFont"..win.db.name)
	        titlefont:SetFont(aDB["fonts"].simple_pixel_font, aDB["fonts"].simple_pixel_font_size, aDB["fonts"].simple_pixel_font_style)
	        win.bargroup.button:SetNormalFontObject(titlefont)
        end
        local color = win.db.title.color
	    win.bargroup.button:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
		if win.bargroup.bgframe then
            aDB.SetStyle(win.bargroup.bgframe)
			aDB.CreatePanelShadow(win.bargroup.bgframe)
			if win.db.reversegrowth then
				win.bargroup.bgframe:SetPoint("BOTTOM", win.bargroup.button, "BOTTOM", 0, win.db.enabletitle and 2 or 1)
			else
				win.bargroup.bgframe:SetPoint("TOP", win.bargroup.button, "TOP", 0, (win.db.enabletitle and 2 or 1))
			end
		end
        self:AdjustBackgroundHeight(win)
        win.bargroup:SetMaxBars(win.db.barmax)
        win.bargroup:SortBars()
	end
	
	barmod.AdjustBackgroundHeight = function(self,win)
	    local numbars = 0
	    if win.bargroup:GetBars() ~= nil then
		    if win.db.background.height == 0 then
                for name, bar in pairs(win.bargroup:GetBars()) do if bar:IsShown() then numbars = numbars + 1 end end
            else
                numbars = win.db.barmax
            end
            if win.db.enabletitle then numbars = numbars + 1 end
            if numbars < 1 then numbars = 1 end
		    local height = numbars * (win.db.barheight + (1) + (3))
            --if win.db.enabletitle then height = height + 1 end
		    if win.bargroup.bgframe:GetHeight() ~= height then
			    win.bargroup.bgframe:SetHeight(height)
		    end
	    end
    end
    
    barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
    barmod.AddDisplayOptions = function(self, win, options)
        self:AddDisplayOptions_(win, options)
        StripOptions(options)
	end
	-- Update pre-existing displays
	for k, window in ipairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end
    for k, options in pairs(Skada.options.args.windows.args) do
        if options.type == "group" then
            StripOptions(options.args)
        end
    end
end