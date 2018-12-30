----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

addEventHandler("onClientPedDamage", root, function()
	if (getElementData(source, "invulnerable") == true) then
		cancelEvent()
	end
end)