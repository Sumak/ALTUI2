----------------------------------------------------------------------------------------
--	Auto Repair and sell gray crap
----------------------------------------------------------------------------------------
if aDB["general"].auto_sell_crap_repair == true then
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")
g:SetScript("OnEvent", function()    
	CanMerchantRepair()
			  local cost = GetRepairAllCost()
		if cost > 0 then
			local money = GetMoney()
			if IsInGuild() then
				local guildMoney = GetGuildBankWithdrawMoney()
				if guildMoney > GetGuildBankMoney() then
					guildMoney = GetGuildBankMoney()
				end
				if guildMoney > cost and CanGuildBankRepair() then
					RepairAllItems(1)
					print(format("|cfff07100Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
					return
				end
			end
			if money > cost then
					RepairAllItems()
					print(format("|cffead000Repair cost: %.1fg|r", cost * 0.0001))
			else
				print(locale.tweak1)
			end
		end
        local bag, slot 
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if link and (select(3, GetItemInfo(link))==0) then
                    UseContainerItem(bag, slot)
                end
            end
        end
end)
end

----------------------------------------------------------------------------------------
--	Hiding default error's(by Nightcracker)
----------------------------------------------------------------------------------------
if aDB["general"].hide_ugly_errors == true then
local f, o, ncErrorDB = CreateFrame("Frame"), "No error yet.", {
	["Inventory is full"] = true,
}
f:SetScript("OnEvent", function(self, event, error)
	if ncErrorDB[error] then
		UIErrorsFrame:AddMessage(error)
	else
	o = error
	end
end)
SLASH_NCERROR1 = "/error"
function SlashCmdList.NCERROR() print(o) end
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("UI_ERROR_MESSAGE")
end

----------------------------------------------------------------------------------------
--	Auto decline duel
----------------------------------------------------------------------------------------
if aDB["general"].auto_decline_duel == true then
    local dd = CreateFrame("Frame")
    dd:RegisterEvent("DUEL_REQUESTED")
    dd:SetScript("OnEvent", function(self, event, name)
		HideUIPanel(StaticPopup1)
		CancelDuel()
		print(format("|cffffff00"..locale.tweak2..name.."."))
    end)
end

----------------------------------------------------------------------------------------
--	Accept invites from guild or friends list
----------------------------------------------------------------------------------------
if aDB["general"].auto_accept_invite == true then
    local IsFriend = function(name)
        for i = 1, GetNumFriends() do if(GetFriendInfo(i) == name) then return true end end
        if(IsInGuild()) then for i = 1, GetNumGuildMembers() do if(GetGuildRosterInfo(i) == name) then return true end end end
    end

    local ai = CreateFrame("Frame")
    ai:RegisterEvent("PARTY_INVITE_REQUEST")
    ai:SetScript("OnEvent", function(frame, event, name)
        if(IsFriend(name)) then
			print(format("|cffffff00"..locale.tweak3..name.."."))
            AcceptGroup()
            for i = 1, 4 do
                local frame = _G["StaticPopup"..i]
                if(frame:IsVisible() and frame.which == "PARTY_INVITE") then
                    frame.inviteAccepted = 1
                    StaticPopup_Hide("PARTY_INVITE")
                    return
                end
            end
        else
            SendWho(name)
        end
    end)
end

----------------------------------------------------------------------------------------
--	Quest Tracker(by Tukz)
----------------------------------------------------------------------------------------
local wf = WatchFrame
local wfmove = true 
wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, -150)
wf:SetWidth(250)
wf:SetHeight(500)
wf:SetUserPlaced(true)
wf.SetPoint = function() end
local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		print(locale.tweak4)
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		print(locale.tweak5)
	end
end

SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK

--------------------------------------------------------------------------
-- Grab frame information when mouseing over a frame
-------------------------------------------------------------------------- 
SLASH_FRAME1 = "/nframe"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|CFFCC0000---------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
 
		if x then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if y then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
			ChatFrame1:AddMessage("|CFFCC0000---------------")
		end
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end

----------------------------------------------------------------------------------------
--	ALT+Click = buy a stuck
----------------------------------------------------------------------------------------
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick;

function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(this:GetID())));
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(this:GetID());
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(this:GetID(), floor(maxStack / quantity));
		end;
	end;
	savedMerchantItemButton_OnModifiedClick(self, ...);
end;

--------------------------------------------------------------------------
-- Move Vehicle Frame(mouseover)(by Tukz)
-------------------------------------------------------------------------- 
hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) 
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
		VehicleSeatIndicator:ClearAllPoints()
			VehicleSeatIndicator:SetPoint('RIGHT', UIParent, 20, 200)
			VehicleSeatIndicator:SetPoint('RIGHT', UIParent, 20, 200)
			tinsert(UIMovableFrames, VehicleSeatIndicator)
    end
end)

local function VehicleNumSeatIndicator()
	if VehicleSeatIndicatorButton1 then
		numSeat = 1
	elseif VehicleSeatIndicatorButton2 then
		numSeat = 2
	elseif VehicleSeatIndicatorButton3 then
		numseat = 3
	elseif VehicleSeatIndicatorButton4 then
		numSeat = 4
	elseif VehicleSeatIndicatorButton5 then
		numSeat = 5
	elseif VehicleSeatIndicatorButton6 then
		numSeat = 6
	end
end

local function vehmousebutton(alpha)
	for i=1, numSeat do
	local pb = _G["VehicleSeatIndicatorButton"..i]
		pb:SetAlpha(alpha)
	end
end

local function vehmouse()
	if VehicleSeatIndicator:IsShown() then
		VehicleSeatIndicator:SetAlpha(0)
		VehicleSeatIndicator:EnableMouse(true)
		
		VehicleNumSeatIndicator()
		
		VehicleSeatIndicator:HookScript("OnEnter", function() VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
		VehicleSeatIndicator:HookScript("OnLeave", function() VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)

		for i=1, numSeat do
			local pb = _G["VehicleSeatIndicatorButton"..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", function(self) VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
			pb:HookScript("OnLeave", function(self) VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)
		end
	end
end
hooksecurefunc("VehicleSeatIndicator_Update", vehmouse)

----------------------------------------------------------------------------------------
--	Moving TicketStatus Frame
----------------------------------------------------------------------------------------
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint(unpack(aDB["pos"].ticket))
TicketStatusFrame.SetPoint = function() end

----------------------------------------------------------------------------------------
--	Move Battlefield score frame
---------------------------------------------------------------------------------------- 
if (WorldStateAlwaysUpFrame) then
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint(unpack(aDB["pos"].bgscore))
	WorldStateAlwaysUpFrame:SetScale(0.9)
	WorldStateAlwaysUpFrame.SetPoint = function() end
end 

----------------------------------------------------------------------------------------
--	Move CaptureBar
----------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
local function OnEvent()
    if(NUM_EXTENDED_UI_FRAMES>0) then
            for i = 1, NUM_EXTENDED_UI_FRAMES do
                _G["WorldStateCaptureBar" .. i]:ClearAllPoints()
                _G["WorldStateCaptureBar" .. i]:SetPoint(unpack(aDB["pos"].capture))
            end
    end
end

local f = CreateFrame"Frame"
f:RegisterEvent"PLAYER_LOGIN"
f:RegisterEvent"UPDATE_WORLD_STATES"
f:RegisterEvent"UPDATE_BATTLEFIELD_STATUS"
f:SetScript("OnEvent", OnEvent)

----------------------------------------------------------------------------------------
--	Disband raid and group(by Monolit)
----------------------------------------------------------------------------------------
SlashCmdList["GROUPDISBAND"] = function()
	local pName = UnitName("player")
	SendChatMessage(locale.tweak6, "RAID" or "PARTY")
	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
SLASH_GROUPDISBAND1 = "/rd"
SLASH_GROUPDISBAND2 = "/кв"