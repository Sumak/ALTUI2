-- Constants
aDB.dummy = function() return end
aDB.myname, _ = UnitName("player")
aDB.client = GetLocale() 
aDB.version = GetAddOnMetadata("AltUI", "Version")
aDB.incombat = UnitAffectingCombat("player")
aDB.patch = GetBuildInfo()
aDB.level = UnitLevel("player")
_, aDB.myclass = UnitClass("player")
resolution = GetCurrentResolution()
getscreenresolution = select(resolution, GetScreenResolutions())