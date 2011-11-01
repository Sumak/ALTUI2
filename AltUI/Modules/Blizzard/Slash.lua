SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = "/кд"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/гм"
SLASH_TICKET2 = "/gm"

SlashCmdList["READYCHECKSLASHRC"] = function() DoReadyCheck() end
SLASH_READYCHECKSLASHRC1 = "/rc"
SLASH_READYCHECKSLASHRC2 = "/кс"

SlashCmdList["CLFIX"] = function() CombatLogClearEntries() end
SLASH_CLFIX1 = "/clfix"

SlashCmdList.DISABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then DisableAddOn(addon) ReloadUI() else print(locale_addon) end end
SLASH_DISABLE_ADDON1 = "/disable"

SlashCmdList.ENABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then EnableAddOn(addon) LoadAddOn(addon) ReloadUI() else print(locale_addon) end end
SLASH_ENABLE_ADDON1 = "/enable"

--	Spec Switching
SlashCmdList["SPEC"] = function() 
local spec = GetActiveTalentGroup()
if spec == 1 then SetActiveTalentGroup(2) elseif spec == 2 then SetActiveTalentGroup(1) end
end
SLASH_SPEC1 = "/ss"

-- Help commands
SLASH_ALTHELP1 = "/alth"
SlashCmdList.ALTHELP = function() 
print(locale.help_string1)
print(locale.help_string2)
print(locale.help_string3)
print(locale.help_string4)
print(locale.help_string5)
print(locale.help_string6)
print(locale.help_string7)
print(locale.help_string8)
print(locale.help_string9)
print(locale.help_string10)
print(locale.help_string11)
print(locale.help_string12)
print(locale.help_string13)
print(locale.help_string14)
end