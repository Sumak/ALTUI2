aDB = { }
aDB["general"] = {
	["auto_UI_Scale"] = true,															
	["UIScale"] = 0.75,																	
	["hide_ugly_errors"] = true,														
	["auto_decline_duel"] = false,														
	["auto_accept_invite"] = true,														
	["auto_sell_crap_repair"] = true,	
	["shadow_border"] = true,
	["shadow_border_alpha"] = 0.55,
	
	--[[Correct UI Scale value for resoluitons(by Alza):
		y-resolution | scale
		768          | 1
		800          | 0.96
		900          | 0.8533333333333333
		1024         | 0.75
		1050         | 0.7314285714285714
		1080         | 0.7111111111111111
		1200         | 0.64
	]]
}
aDB["unitframe"] = {
	["smooth_bar"] = true,	
	["aura_tracker"] = true,
	["own_statusbar_color"] = false,
	["combat_feedback"] = true,
	["desaturated_debuffs"] = false,
	["focus_debuffs"] = false,
	["enable_portraits"] = true,														
	["rest_icon"] = false,																
	["plugin_totem_bar"] = true,														
	["plugin_rune_bar"] = true,		
	["plugin_combo_points"] = true,
	["show_combo_points"] = true,	
	["showParty"] = false,																
	["inside_alpha"] = 1.0,																
	["outside_alpha"] = 0.5,															
	["showSolo"] = false,																
	["show"] = true,																	
	
	["player"] = {'BOTTOMLEFT', 'Bar1Holder', 'TOPLEFT', -50, 130},										
	["target"] = {'BOTTOMRIGHT', 'Bar1Holder', 'TOPRIGHT', 80, 122},										
	["targettarget"] = {'TOP', 'oUF_AltTarget', 'BOTTOM', 0, -17},						
	["pet"] = {'TOP', 'oUF_AltPlayer', 'BOTTOM', 0, -25},								
	["focus"] = {'TOP', 'oUF_AltTargettarget', 'BOTTOM', 0, 6},							
	["party"] = {'TOPLEFT', UIParent, 2, -420},											
	["raid"] = {'TOPLEFT', UIParent, 2, -90},											
}
aDB["actionbar"] = {
	["hotkey"] = true,	
	["macro_text"] = false,
	["showgrid"] = true,                  												
	["button_size"] = 27,																
	["spacing"] = 3,	
	["rightbars"] = 2,  	
	["rightbars_mouseover"] = true,		                   						
	
	["bar1"] = {'BOTTOM', UIParent, 'BOTTOM', -50, 11},									
	["bar2"] = {'BOTTOM', 'Bar1Holder', 'TOP', 0, 1},
	["bar45"] = {'RIGHT', UIParent, 'RIGHT', -2, -100},									
	["stance"] = {'BOTTOMLEFT', 'Bar1Holder', 'BOTTOMRIGHT', 2, 0},													
	["vehicle"] = {'BOTTOMRIGHT', 'Bar1Holder', 'BOTTOMLEFT', -3, 1},					
	["totem_bar"] = {'BOTTOMLEFT', 'Bar1Holder', 'BOTTOMRIGHT', 8, -5},				
}	
aDB["pos"] = {
	["map"] = {'CENTER', UIParent, 'CENTER', 0, 230},
	["cooldown_icon"] = {'CENTER', UIParent, 'CENTER', 0, 190},
	["loot"] = {'TOPLEFT', UIParent, 'TOPLEFT', 350, -350},
	["minimap"] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -2, -2},
	["tooltip"] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -2, 130},
	["ticket"] = {'TOP', UIParent, 'TOP', 0, -2},
	["bgscore"] = {'BOTTOM', UIParent, 'TOPLEFT', 50, 0},
	["capture"] = {'TOPLEFT', UIParent, 'TOPLEFT', 0, -45},
}	
aDB["minimap"] = {
	["enable"] = true,
	["size"] = 135,
}
aDB["chat"] = {
	["chatframe"] = {'BOTTOMLEFT', UIParent, 1, 30},
	["filter"] = true,				
	["chat_bar"] = true,
	["chatframewidth"] = 270,												
	["chatframeheight"] = 120,															
	["font_size"] = 12,														
}
aDB["lootroll"] = {
	["roll_width"] = 250,
	["roll_height"] = 27,
	["icon_size"] = 27, 
	["loot_frame_width"] = 150,
	["slot_size"] = 27,
}
aDB["bags"] = {
	["button_size"] = 27,
	["bag_button_size"] = 27,
	["inventory"] = {'BOTTOMRIGHT', -60, 50},
	["bank"] = {'LEFT', 25, 0},
}
aDB["nameplates"] = {
	["enable"] = true,																	
}
aDB["cooldown_flash"] = {
	["enable"] = true, 																	
	["icon_size"] = 90,																	
	["fade_out_time"] = .70,															
	["cooldown_font_size"] = 10,														
}
aDB["filger"] = {
	["icon_size"] = 30,																	
	["spacing"] = 1,																	
	["enable_config_mode"] = false,
}
aDB["addons_skin"] = {
	["omen"] = true,
	["dbm"] = true,
	["skada"] = true,
	["recount"] = true,
}