if not IsAddOnLoaded("AltUI_Setting") or GUIConfig == nil then return end

for group, options in pairs(GUIConfig) do
	if aDB[group] then
		local count = 0
		for option, value in pairs(options) do
			if aDB[group][option] ~= nil then
				if aDB[group][option] == value then
					GUIConfig[group][option] = nil	
				else
					count = count + 1
					aDB[group][option] = value
				end
			end
		end
		if count == 0 then GUIConfig[group] = nil end
	else
		GUIConfig[group] = nil
	end
end

