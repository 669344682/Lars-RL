----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

addEventHandler("onClientColShapeHit", root, function(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "object" and getElementModel(elem) == 1558) then
			local o = getElementData(source, "curPlayer")
			if (o and o == getPlayerName(localPlayer)) then
				triggerServerEvent("onForkBoxDeliver", localPlayer, source, elem)
			end
		end
	end
end)
