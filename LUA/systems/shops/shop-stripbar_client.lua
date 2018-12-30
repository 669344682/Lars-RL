----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local isOpen = false
local function StripBar(name)
	if (isOpen) then return end
	isOpen = true
	local PizzaMenues = settings.systems.shops.stripbar.menues
	
	setPedAnimation(localPlayer)
	toggleAllControls(false, true, true)
	
	closeIt = function()
		isOpen = false
		destroyProductSelect()
		setElementFrozen(localPlayer, false)
		toggleAllControls(true, true, true, true)
		triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, false)
	end
	buyMenu = function(nr)
		destroyProductSelect()
		closeIt()
		triggerServerEvent("stripBarBuy", localPlayer, nr, name)
	end
	
	displayProductSelect(name, PizzaMenues, function()end, buyMenu, closeIt, "files/images/productlist/strip.png")
end
addEvent("stripBarHello", true)
addEventHandler("stripBarHello", root, StripBar)


addEventHandler("onClientResourceStart", resourceRoot, function()
	-- gayclub sound innen
	local sound = playSound3D(settings.general.webserverURL.."/sounds/gayclub-1.opus", 487, -14, 1001, true)
	setElementInterior(sound, 17)
	setElementDimension(sound, 108)
	setSoundMaxDistance(sound, 50)
	setSoundVolume(sound, 0.7)
	setSoundEffectEnabled(sound,"i3dl2reverb",true)
	
	-- gayclub sound aussen
	local sound = playSound3D(settings.general.webserverURL.."/sounds/gayclub-1.opus", -2550.7, 193.8, 6.9, true)
	setSoundMaxDistance(sound, 15)
	setSoundVolume(sound, 0.5)
	setSoundEffectEnabled(sound,"i3dl2reverb",true)
end)
