Filger_Settings = {
	configmode = aDB["filger"].enable_config_mode,
}

buff_anchor = CreateFrame("Frame", "buff_anchor", UIParent)
buff_anchor:SetSize(64, 64)
buff_anchor:SetPoint('CENTER', UIParent, 'CENTER', -303, -165)
tinsert(UIMovableFrames, buff_anchor)

proc_anchor = CreateFrame("Frame", "proc_anchor", UIParent)
proc_anchor:SetSize(64, 64)
proc_anchor:SetPoint('CENTER', UIParent, 'CENTER', -303, -124)
tinsert(UIMovableFrames, proc_anchor)

debuff_anchor = CreateFrame("Frame", "debuff_anchor", UIParent)
debuff_anchor:SetSize(64, 64)
debuff_anchor:SetPoint('CENTER', UIParent, 'CENTER', 311, -165)
tinsert(UIMovableFrames, debuff_anchor)

buff_t_anchor = CreateFrame("Frame", "buff_t_anchor", UIParent)
buff_t_anchor:SetSize(64, 64)
buff_t_anchor:SetPoint('CENTER', UIParent, 'CENTER', 311, -124)
tinsert(UIMovableFrames, buff_t_anchor)

Filger_Spells = {
	["DRUID"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Savage roar
			{ spellID = 52610, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Survival Instincts
			{ spellID = 61336, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Barkskin
			{ spellID = 22812, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Eclipse (Lunar)
			{ spellID = 48518, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Eclipse (Solar)
			{ spellID = 48517, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Living Seed
			{ spellID = 48496, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Siphoned Power
			{ spellID = 71636, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },

		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Moonfire
			{ spellID = 48463, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Insect Swarm
			{ spellID = 48468, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Faerie Fire
			{ spellID = 770, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots
			{ spellID = 26989, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Earth and Moon
			{ spellID = 48511, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Cyclone
			{ spellID = 33786, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rake
			{ spellID = 59886, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rip
			{ spellID = 49800, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Lacerate
			{ spellID = 48568, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Pounce Bleed
			{ spellID = 49804, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mangle (Cat)
			{ spellID = 48566, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Mangle (Bear)
			{ spellID = 48564, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "T/BUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_t_anchor},
			
			-- Lifebloom
			{ spellID = 33763, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Rejuvenation
			{ spellID = 774, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Regrowth
			{ spellID = 8936, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Wild Growth
			{ spellID = 48438, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Abolish Poison
			{ spellID = 2893, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
	},	},
	["MAGE"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			
			-- Mana Shield
			{ spellID = 43020, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Ice Barrier
			{ spellID = 11426, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frost Ward
			{ spellID = 43012, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fire Ward
			{ spellID = 43010, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Ice Block
			{ spellID = 45438, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Invisibility
			{ spellID = 66, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },  
			-- Siphoned Power (Phylactery)
			{ spellID = 71636, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Surging Power
			{ spellID = 71643, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Arcane Power
			{ spellID = 12042, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },

		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Fingers of Frost
			{ spellID = 44544, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fireball!
			{ spellID = 57761, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hot Streak
			{ spellID = 44448, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting
			{ spellID = 12536, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Missile Barrage
			{ spellID = 54490, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Impact
			{ spellID = 12358, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Arcane Blast
			{ spellID = 36032, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "DEBUFF" },
			-- Improved Scorch
			{ spellID = 22959, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Frostbite
			{ spellID = 11071, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Winterchill
			{ spellID = 12579, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Polymorph(Sheep)
			{ spellID = 12826, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Slow
			{ spellID = 31589, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Ignite
			{ spellID = 12848, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Living Bomb
			{ spellID = 55360, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frostfire bolt
			{ spellID = 47610, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Dragon's breath
			{ spellID = 42950, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frostbolt (movement slowed by 40%)
			{ spellID = 42842, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- CoC (Cone of Cold)
			{ spellID = 42931, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
		
	},	
	["ROGUE"] = {	
		{	
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},
			
			-- Slice and Dice
			{ spellID = 5171, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Blade Flurry
			{ spellID = 13877, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Adrenaline Rush
			{ spellID = 13750, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tricks of the Trade
			{ spellID = 57934, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Cloak of Shadows
			{ spellID = 31224, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Sprint
			{ spellID = 2983, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Evasion
			{ spellID = 5277, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Overkill
			{ spellID = 58426, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Turn the Tables
			{ spellID = 51627, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hunger For Blood
			{ spellID = 51662, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},
			
			-- Rupture
			{ spellID = 48672, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Garrote
			{ spellID = 48676, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Kidney shot
			{ spellID = 408, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Gouge
			{ spellID = 1776, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Blind
			{ spellID = 2094, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Dismantle
			{ spellID = 51722, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Deadly Poison
			{ spellID = 57973, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Wound Poison
			{ spellID = 57978, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Crippling Poison
			{ spellID = 3408, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mind-numbing Poison
			{ spellID = 5761, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	["WARRIOR"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Blood Reserve
			{ spellID = 64568, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Last Stand
			{ spellID = 12975, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shield Wall
			{ spellID = 871, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Bladestorm
			{ spellID = 46924, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Bloodthirst
			{ spellID = 23881, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Sudden Death
			{ spellID = 52437, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Sword and Board
			{ spellID = 50227, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Strength of the Taunka
			{ spellID = 71561, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Speed of the Vrykul
			{ spellID = 71560, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Aim of the Iron Dwarves
			{ spellID = 71559, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Slam!
			{ spellID = 46916, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Hamstring
			{ spellID = 1715, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rend
			{ spellID = 47465, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunder Armor
			{ spellID = 7386, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Expose Armor
			{ spellID = 48669, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Thunder Clap
			{ spellID = 6343, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demoralizing Shout
			{ spellID = 1160, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Piercing Howl
			{ spellID = 12323, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	
	},

	["PRIEST"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Power Word: Shield
			{ spellID = 48066, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Renew
			{ spellID = 48068, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fade
			{ spellID = 586, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fear Ward
			{ spellID = 6346, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
            -- Dispersion
            { spellID = 47585, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Prayer of Mending
			{ spellID = 41637, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Guardian spirit
			{ spellID = 47788, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Pain suspension
			{ spellID = 33206, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power Infusion
			{ spellID = 10060, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Surge of Light
			{ spellID = 33151, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Serendipity
			{ spellID = 63734, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Energized
            { spellID = 67696, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
            -- Shadow Weaving
            { spellID = 15258, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
            -- Improved Spirit Tap
            { spellID = 59000, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DE_BUFF",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},
			
			-- Shackle Undead
			{ spellID = 10955, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Shadow Word: Pain
			{ spellID = 589, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Devouring Plague
			{ spellID = 2944, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Vampiric Touch
            { spellID = 34914, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
		{
			Name = "BUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_t_anchor},

			-- Power Word: Shield
			{ spellID = 48066, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Renew
			{ spellID = 48068, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Fear Ward
			{ spellID = 6346, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Prayer of Mending
			{ spellID = 41637, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Pain suspension
			{ spellID = 33206, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Power Infusion
			{ spellID = 10060, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
		},
	},
	
	["WARLOCK"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Life Tap
			{ spellID = 63321, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Phylactery of the Nameless Lich
			{ spellID = 71636, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Surge of Power
			{ spellID = 71644, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Devious Minds
			{ spellID = 70840, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},

		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Molten Core
			{ spellID = 47383, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Decimation
			{ spellID = 63158, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backdraft
			{ spellID = 54277, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backlash
			{ spellID = 34939, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nether Protection
			{ spellID = 30302, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nightfall
			{ spellID = 18095, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shadow Trance
			{ spellID = 17941, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},

		{
			Name = "DE_BUFF",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},
			
			-- Corruption
			{ spellID = 172, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Immolate
			{ spellID = 348, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Agony
			{ spellID = 980, size = aDB["filger"].icon_size,  unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Doom
			{ spellID = 47867, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unstable Affliction
			{ spellID = 47843, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Haunt
			{ spellID = 59164, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },	
			-- Seed of Corruption
			{ spellID = 27243, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Fear
			{ spellID = 6215, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Howl of Terror
			{ spellID = 5484, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Death Coil
			{ spellID = 6789, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Banish
			{ spellID = 710, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Enslave Demon
			{ spellID = 1098, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demon Charge
			{ spellID = 54785, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},

		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_t_anchor},

			-- Curse of the Elements
			{ spellID = 47865, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Ebon Plaguebringer
			{ spellID = 51161, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Tongues
			{ spellID = 11719, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Weakness
			{ spellID = 50511, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Weakness
			{ spellID = 702, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Tongues
			{ spellID = 1714, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	
	["DEATHKNIGHT"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},
			-- Blood Tap
			{ spellID = 45529, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Horn of Winter
			{ spellID = 57623, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Icebound Fortitude
			{ spellID = 48792, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Antimagic Shell
			{ spellID = 48707, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Lichborne
			{ spellID = 49039, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Vampiric Blood
			{ spellID = 55233, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unbreakable Armor
			{ spellID = 51271, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Anti-Magic Zone
			{ spellID = 51052, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Bone Shield
			{ spellID = 49222, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
		},

		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Unholy Force
			{ spellID = 67383, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Desolation
			{ spellID = 66817, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Strength
			{ spellID = 53365, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Pyrite Infusion
			{ spellID = 65014, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Might
			{ spellID = 67117, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dancing Rune Weapon
			{ spellID = 49028, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Killing machine 
			{ spellID = 51124, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Freezing fog 
			{ spellID = 59052, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DE_BUFF",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},
			
			-- Blood Plague
			{ spellID = 59879, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Fever
			{ spellID = 59921, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unholy Blight
			{ spellID = 49194, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Strangulate
			{ spellID = 47476, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Hungering Cold
			{ spellID = 49203, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Summon Gargoyle
			{ spellID = 49206, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Gnaw 
			{ spellID = 47481, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Chains of Ice
			{ spellID = 45524, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	
	["SHAMAN"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Maelstorm Weapon
			{ spellID = 51532, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shamanistic rage
			{ spellID = 30823, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Bloodlust
			{ spellID = 2825, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Lightning Shield
			{ spellID = 49281, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Water Shield
			{ spellID = 57960, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Earth Shield
			{ spellID = 49284, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Heroism
			{ spellID = 32182, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Tidal Force
			{ spellID = 55198, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Ancestral Healing
			{ spellID = 16237, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Riptide
			{ spellID = 61295, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Clearcasting
			{ spellID = 12536, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tidal Waves
			{ spellID = 51566, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Storm Strike
			{ spellID = 17364, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Earth Shock
			{ spellID = 49231, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Shock
			{ spellID = 49236, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Flame Shock
			{ spellID = 49233, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
		{
			Name = "TBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_t_anchor},

			-- Riptide
			{ spellID = 61295, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Ancestral Healing
			{ spellID = 16176, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Tidal Force
			{ spellID = 55198, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Lightning Shield
			{ spellID = 49281, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Water Shield
			{ spellID = 57960, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Earth Shield
			{ spellID = 49284, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
		},
	},
	["HUNTER"] = {
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Hunter's Mark
			{ spellID = 1130, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Serpent Sting
			{ spellID = 49001, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Scorpid Sting
			{ spellID = 3043, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Black Arrow
			{ spellID = 63672, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Explosive Shot
			{ spellID = 60053, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Freezing Arrow 
			{ spellID = 60210, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Scatter Shot
			{ spellID = 19503, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Wyvern Sting
			{ spellID = 49012, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Wing Clip
			{ spellID = 2974, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Freezing Trap 
			{ spellID = 3355, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Piercing shots
			{ spellID = 63468, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Aimed shot
			{ spellID = 49050, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Concussive shot
			{ spellID = 5116, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Scatter shot
			{ spellID = 19503, size = aDB["filger"].icon_size, unitId = "target", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Lock and Load
			{ spellID = 56453, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Quick Shots
			{ spellID = 6150, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Master Tactician
			{ spellID = 34837, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Master Tactician
			{ spellID = 53224, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Expose Weakness
			{ spellID = 34503, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Exploit Weakness 2t10 proc
			{ spellID = 70728, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Stinger 4t10 proc
			{ spellID = 71007, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power of the Taunka
			{ spellID = 71486, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Aim of the Iron Dwarves
			{ spellID = 71491, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Agility of the Vrykul
			{ spellID = 71485, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Icy Rage
			{ spellID = 71401, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rapid Fire
			{ spellID = 3045, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Berserking
			{ spellID = 26297, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Blood Fury
			{ spellID = 20572, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Call of the Wild
			{ spellID = 53434, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frostforged Champion
			{ spellID = 72412, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
	},
	
	["PALADIN"] = {
		{
			Name = "BUFF_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_anchor},

			-- Innervate
			{ spellID = 29166, size = aDB["filger"].icon_size, unitId = "player", caster = "all", filter = "BUFF" },
			-- Divine Shield
			{ spellID = 642, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hand of Freedom
			{ spellID = 1044, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hand of Sacrifice
			{ spellID = 6940, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hand of Protection
			{ spellID = 10278, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Beacon of Light
			{ spellID = 53563, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Illumination
			{ spellID = 31842, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Holy Shield
			{ spellID = 53601, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Protection
			{ spellID = 498, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Avenging Wrath
			{ spellID = 31884, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "PROC_ICON",
			Direction = "RIGHT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', proc_anchor},

			-- Judgements of the Pure
			{ spellID = 54155, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Infusion of Light
			{ spellID = 54149, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Plea
			{ spellID = 54428, size = aDB["filger"].icon_size, unitId = "player", caster = "player", filter = "BUFF" },
		},
		
		{
			Name = "DEBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', debuff_anchor},

			-- Hammer of Justice
			{ spellID = 10308, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Judgement of Light
			{ spellID = 20271, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Judgement of Justice
			{ spellID = 53407, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Judgement of Wisdom
			{ spellID = 20186, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Heart of the Crusader
			{ spellID = 54499, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Blood Corruption
			{ spellID = 53742, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Repetance
			{ spellID = 20066, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		
		{
			Name = "TBUFF_ICON",
			Direction = "LEFT",
			Interval = aDB["filger"].spacing,
			Mode = "ICON",
			setPoint = {'CENTER', buff_t_anchor},

			-- Hand of Freedom
			{ spellID = 1044, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Hand of Sacrifice
			{ spellID = 6940, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Hand of Protection
			{ spellID = 10278, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Beacon of Light
			{ spellID = 53563, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
			-- Holy Shield
			{ spellID = 53601, size = aDB["filger"].icon_size, unitId = "target", caster = "player", filter = "BUFF" },
		},
	},
}