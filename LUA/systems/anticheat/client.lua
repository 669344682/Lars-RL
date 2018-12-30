----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

--[[allowWeaponUsage = true
addEventHandler("onClientPlayerNetworkStatus", root, function(status, ticks)
	if (status == 0) then
		allowWeaponUsage = false
		setPedWeaponSlot(localPlayer, 0)
		if (not isElementFrozen(localPlayer)) then
			setElementFrozen(localPlayer, true)
		end
	elseif (status == 1) then
		allowWeaponUsage = true
		if (isElementFrozen(localPlayer)) then
			setElementFrozen(localPlayer, false)
		end
	end
end)

function stopShit()
	if (allowWeaponUsage == false) then
		setPedWeaponSlot(localPlayer, 0)
		setPedAnimation(localPlayer)
		cancelEvent()
	end
end
addEventHandler("onClientPlayerWeaponFire", root, stopShit)
addEventHandler("onClientPlayerWeaponSwitch", root, stopShit)
addEventHandler("onClientPlayerTarget", root, stopShit)]]