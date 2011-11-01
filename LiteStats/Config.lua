LPSTAT_FONT = {
	font = aDB["fonts"].datatext_font,
	color = {1,1,1}, 
	size = aDB["fonts"].datatext_font_size,
	alpha = 1,
	outline = 1,
	shadow = {alpha=0, x=0, y=0}, 
}
LTIPICONSIZE = 12	
HIDE_IN_COMBAT = false	

local ctab = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local function class(string)
	local color = ctab[select(2,UnitClass'player')]
	return format("|cff%02x%02x%02x%s|r",color.r*255,color.g*255,color.b*255,string or '')
end

LPSTAT_CONFIG = {
	Memory = {
		enabled = true,
		fmt_mb = "%.1f"..class"mb",
		fmt_kb = "%.0f"..class"kb",
		max_addons = nil,
		anchor_frame = "LDTX", anchor_to = "left", anchor_from = "left",
		x_off = 20, y_off = 2, tip_anchor = "ANCHOR_TOP", tip_x = 0, tip_y = 0
	},
	Latency = {
		enabled = true,
		fmt = "[color]%d|r"..class"ms", 
	 	anchor_frame = "LDTX", anchor_to = "left", anchor_from = "center",
		x_off = -20, y_off = 2,
	},
	FPS = {
		enabled = true,
		fmt = "%d"..class"fps", 
		anchor_frame = "LDTX", anchor_to = "right", anchor_from = "right",
		x_off = -20, y_off = 2,
	},
	Talents = {
		enabled = false,
		fmt = class"Talents: ".."[spec %d/%d/%d] [unspent]",
		iconsize = 20,
		nospam = true, 
		name_subs = { 
			["Protection"] = "Protection",
			["Restoration"] = "Restoration",
			["Feral Combat"] = "Feral",
			["Retribution"] = "Retribution",
			["Discipline"] = "Discipline",
			["Enhancement"] = "Enhancement",
			["Elemental"] = "Elemental",
			["Demonology"] = "Demonology",
			["Destruction"] = "Destruction",
			["Assassination"] = "Assassination",
			["Marksmanship"] = "Marksmanship",
			["Beast Mastery"] = "Beast Mastery",
		},
		anchor_frame = "Latency", anchor_to = "left", anchor_from = "right",
		x_off = 10, y_off = 0, tip_anchor = "ANCHOR_BOTTOMLEFT", tip_x = 0, tip_y = 0
	},
	Friends = {
		enabled = true,
		fmt = class"F: ".."%d/%d",
		maxfriends = nil,
		anchor_frame = "RDTX", anchor_to = "right", anchor_from = "right",
		x_off = -20, y_off = 2, tip_anchor = "ANCHOR_BOTTOMLEFT", tip_x = 0, tip_y = 0
	},
	Guild = {
		enabled = true,
		fmt = class"G: ".."%d/%d",
		maxguild = nil,
		threshold = 1,
		sorting = "class", 
		anchor_frame = "RDTX", anchor_to = "right", anchor_from = "center",
		x_off = 20, y_off = 2, tip_anchor = "ANCHOR_BOTTOMLEFT", tip_x = 0, tip_y = 0
	},
	Durability = {
		enabled = true,
		fmt = class"Dur: [color]%d|r%%",
		man = true, 
		gfunds = true, 
		ignore_inventory = true, 
		gear_icons = true, 
		anchor_frame = "RDTX", anchor_to = "left", anchor_from = "left",
		x_off = 20, y_off = 2, tip_anchor = "ANCHOR_BOTTOMLEFT", tip_x = 0, tip_y = 0
	},
	Stats = {
		enabled = false,
		spec1fmt = "SP:[healing]   Haste:[spellhaste]%", 
		spec2fmt = "SP:[spellpower]   Haste:[spellhaste]%", 
		anchor_frame = "", anchor_to = "left", anchor_from = "bottomleft",
		x_off = 14, y_off = 12,
	},
	Experience = {
		enabled = false,
		xp_normal_fmt = "[cur%]%"..class"Exp", 
		xp_rested_fmt = "[cur%]%"..class"Exp ".."[rest%]%"..class"R", 	
		played_fmt = class"Online: ".."|r".."[playedsession]", 
		short = true, thousand = "k", million = "m", 		
		faction_fmt = "[repname]: [repcolor][currep]/[maxrep]|r",
		faction_subs = {
		--	["An Very Long Rep Name"] = "Shortened",
			["The Wyrmrest Accord"] = "Wyrmrest",
			["Knights of the Ebon Blade"] = "Ebon Blade",
			["Hydraxian Waterlords"] = "Hyd-Waterlods",
		},
		anchor_frame = "Guild", anchor_to = "right", anchor_from = "left",
		x_off = -10, y_off = 0, tip_anchor = "ANCHOR_TOPRIGHT", tip_x = 0, tip_y = 5
	},

}
	
LPSTAT_PROFILES = {
	MAGE = { 
		Stats = { 
			spec1fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" Haste: ".."[spellhaste]%",
			spec2fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SHit: ".."[spellhit]%",
		}
	},
	PRIEST = { 
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" MP5: ".."[manaregen]",
			spec2fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SHit: ".."[spellhit]%",
		}
	},
	WARLOCK = { 
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SHit: ".."[spellhit]%",
			spec2fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SHit: ".."[spellhit]%",
		}
	},
	HUNTER = {
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class" AP: ".."[ap]"..class" Hit: ".."[rangedhit]%",
			spec2fmt = class"Res: ".."[resilience]"..class" AP: ".."[ap]"..class" Hit: ".."[rangedhit]%",
		}
	},
	ROGUE = {
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class"AP: ".."[ap]"..class" MCrit: ".."[meleecrit]%",
			spec2fmt = class"AP: ".."[ap]"..class" ArP: ".."[armorpen]%"..class" Mhit: ".."[meleehit]%",
		}
	},
	WARRIOR = {
		Stats = { 
			spec1fmt = class"AP: ".."[ap]"..class" Res: ".."[resilience]"..class" MCrit: ".."[meleecrit]%",
			spec2fmt = class"Def: ".."[defense]"..class" Arm: ".."[armor]%"..class" AVD: ".."[avoidance]%",
		}
	},
	DEATHKNIGHT = {
		Stats = { 
			spec1fmt = class"AP: ".."[ap]"..class" Res: ".."[resilience]"..class" MCrit: ".."[meleecrit]%",
			spec2fmt = class"EXP: ".."[expertise]%"..class" Mhit: ".."[meleehit]%"..class" Def: ".."[defense]",
		}
	},
	DRUID = {
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SpellH: ".."[spellhaste]%",
			spec2fmt = class"AP: ".."[ap]"..class" Mhit: ".."[meleehit]%"..class" Dod: ".."[dodge]%",
		}
	},
	SHAMAN = {
		Stats = {
			spec1fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" MP5: ".."[manaregen]",
			spec2fmt = class"Res: ".."[resilience]"..class" Mhit: ".."[meleehit]%"..class" Mcrit: ".."[meleecrit]%",
		}
	},
	PALADIN ={
		Stats = {
			spec1fmt = class"AP: ".."[ap]"..class" Res: ".."[resilience]"..class" MCrit: ".."[meleecrit]%",
			spec2fmt = class"Res: ".."[resilience]"..class" SP: ".."[spellpower]"..class" SCrit: ".."[spellcrit]%",
		}
	},
}