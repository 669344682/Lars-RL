----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local hook = nil
local function renderLine()
	if (hook) then
		if (tonumber(getElementData(localPlayer, "inJobID")) == 3) then
			
			local hX, hY, hZ = getElementPosition(hook)
			
			dxDrawLine3D(hX-0.7, hY+2.8, hZ-6.3, hX-0.8, hY+2.8, hZ+50, tocolor(0, 0, 0), 10) --ol
			dxDrawLine3D(hX+0.7, hY+2.8, hZ-6.3, hX+0.8, hY+2.8, hZ+50, tocolor(0, 0, 0), 10) --ul
			
			dxDrawLine3D(hX-0.7, hY-0.2, hZ-6.3, hX-0.8, hY-0.2, hZ+50, tocolor(0, 0, 0), 10) --or
			dxDrawLine3D(hX+0.7, hY-0.2, hZ-6.3, hX+0.8, hY-0.2, hZ+50, tocolor(0, 0, 0), 10) --ur
			
		end
	end
end

addEvent("hafenStartClient", true)
addEventHandler("hafenStartClient", root, function(hk)
	
	hook = hk
	addEventHandler("onClientRender", root, renderLine)
	
end)

addEvent("hafenStopClient", true)
addEventHandler("hafenStopClient", root, function()
	
	hook = nil
	removeEventHandler("onClientRender", root, renderLine)
	
end)