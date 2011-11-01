local fontName = 'Interface\\AddOns\\AltUI\\media\\combatfont.ttf'
local fontHeight = 70
local fontFlags = aDB["media"].fontstyle

local function FS_SetFont()
	DAMAGE_TEXT_FONT = fontName
	COMBAT_TEXT_HEIGHT = fontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontHeight +2
	COMBAT_TEXT_CRIT_MINHEIGHT = fontHeight -2
	local fName, fHeight, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontName, fontHeight, fontFlags)
end
FS_SetFont()