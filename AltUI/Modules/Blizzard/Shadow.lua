----------------------------------------------------------------------------------------
--	ncShadow(by Nightcracker/Ferous)
----------------------------------------------------------------------------------------
if not aDB["general"].shadow_border == true then return end

local f = CreateFrame("Frame", "ShadowBackground")
f:SetPoint('TOPLEFT')
f:SetPoint('BOTTOMRIGHT')
f:SetFrameLevel(0)
f:SetFrameStrata('BACKGROUND')
f.tex = f:CreateTexture()
f.tex:SetTexture([[Interface\Addons\AltUI\media\shadow.tga]])
f.tex:SetAllPoints(f)
f.tex:SetAlpha(aDB["general"].shadow_border_alpha)