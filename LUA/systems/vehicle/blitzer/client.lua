----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local screen1		= dxCreateScreenSource(sX, sY)
local screen2		= dxCreateScreenSource(sX, sY)
local screenTaken	= false
local runs			= 0
local function takeImage()
	if (not screenTaken) then
		if (runs == 1) then
			dxUpdateScreenSource(screen2)
			setCameraTarget(localPlayer)
			screenTaken = true
			runs = 0
		else
			runs = runs + 1
		end
		dxDrawImage(0, 0, sX, sY, screen1)
	end
	
	dxDrawRectangle((sX-410)/2, 10, 410, 235, tocolor(0, 0, 0, 140))
	dxDrawImage((sX-400)/2, 15, 400, 225, screen2)
end



local function radarEffect(x, y, z, driver)
	setTimer(function()
		local effect = createEffect("camflash", x, y, z)
		setEffectDensity(effect, 2)
		setEffectSpeed(effect, 0.6)
	end, 50, 1)
	
	if (driver) then
		dxUpdateScreenSource(screen1)
		addEventHandler("onClientRender", root, takeImage)
		local pX, pY, pZ = getElementPosition(localPlayer)
		setCameraMatrix(x, y, z+1.5, pX, pY, pZ+0.2, 0, 4)
		setTimer(function()
			removeEventHandler("onClientRender", root, takeImage)
			screenTaken = false
		end, 3500, 1)
	end
end
addEvent("radarEffect", true)
addEventHandler("radarEffect", root, radarEffect)