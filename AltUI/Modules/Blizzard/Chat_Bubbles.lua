----------------------------------------------------------------------------------------
--	ChatBubbles skin(by Elv)
----------------------------------------------------------------------------------------
local chatbubblehook = CreateFrame("Frame", nil, UIParent)
local noscalemult = 1 * aDB["general"].UIScale
local tslu = 0
local numkids = 0
local bubbles = {}

local function skinbubble(frame)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
		end
	end
	
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false, tileSize = 0, edgeSize = noscalemult,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	frame:SetBackdropColor(unpack(aDB["media"].backdrop_color))
	frame:SetBackdropBorderColor(unpack(aDB["media"].border_color))
	frame:SetClampedToScreen(false)
	
	tinsert(bubbles, frame)
end

local function ischatbubble(frame)
	if frame:GetName() then return end
	local bg = frame:GetRegions()
	if bg then return bg:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]] end
end

chatbubblehook:SetScript("OnUpdate", function(chatbubblehook, elapsed)
	tslu = tslu + elapsed

	if tslu > 0.05 then
		tslu = 0

		local newnumkids = WorldFrame:GetNumChildren()
		if newnumkids ~= numkids then
			for i = numkids + 1, newnumkids do
				local frame = select(i, WorldFrame:GetChildren())

				if ischatbubble(frame) then
					skinbubble(frame)
				end
			end
			numkids = newnumkids
		end
		
		for i, frame in next, bubbles do
			frame:SetBackdropBorderColor(unpack(aDB["media"].border_color))
		end
	end
end)