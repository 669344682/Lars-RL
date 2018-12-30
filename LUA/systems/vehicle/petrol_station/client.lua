----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

fuelStations		= {}
local nearstStation = nil
stationDistance		= 999999
curFuelTyp			= ""
gasPump				= false
canChangeFuelTyp	= true
fuelRunning			= false
local tankHasStopped= false
local curFuelPrices = {}
local liter			= "0.00"
local currentLiter	= 0
local maxLiter		= 0
tmpTankFuel			= 0
local price			= "0.00"
local font			= dxCreateFont("files/fonts/digital.ttf", 30, false)
local fontS			= dxCreateFont("files/fonts/digital.ttf", 21, false)
local fontX			= dxCreateFont("files/fonts/ds-digi.ttf", 13, false)
local shader		= dxCreateShader("files/shaders/overlay.fx")
local shader2		= dxCreateShader("files/shaders/overlay.fx")
local fuelStartTick	= 0

local function renderTankePrice()
	if (#fuelStations == 0 or nearstStation == nil or nearstStation == 0 or type(fuelStations[nearstStation]) ~= "table" or stationDistance > 250) then return end
	curFuelPrices = fuelStations[nearstStation].fuelPrice
	
	-- Schild
	
	if (shader) then
		local renderTarget = dxCreateRenderTarget(128, 256, true)
		if (renderTarget) then
			dxSetShaderValue(shader, "gOverlay", renderTarget)
			dxSetRenderTarget(renderTarget)
			
			-- Diesel --
			dxDrawText(string.sub((tostring(curFuelPrices["diesel"]-0.01)), 1, 1), 43, 90, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText(string.sub((tostring(curFuelPrices["diesel"]-0.01)), 3, 3), 65, 90, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			local xy = string.sub((tostring(curFuelPrices["diesel"]-0.01)), 4, 4)
			if (xy == nil or xy == "") then xy = 0 end
			dxDrawText(xy, 87, 90, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText("9", 110, 91, 10, 30, tocolor(255, 255, 0, 255), 1, fontS)
			
			-- Super --
			dxDrawText(string.sub((tostring(curFuelPrices["petrol"]-0.01)), 1, 1), 43, 145, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText(string.sub((tostring(curFuelPrices["petrol"]-0.01)), 3, 3), 65, 145, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			local xy = string.sub((tostring(curFuelPrices["petrol"]-0.01)), 4, 4)
			if (xy == nil or xy == "") then xy = 0 end
			dxDrawText(xy, 87, 145, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText("9", 110, 146, 10, 30, tocolor(255, 255, 0, 255), 1, fontS)
			
			-- Elektro --
			dxDrawText(string.sub((tostring(curFuelPrices["elektro"]-0.01)), 1, 1), 43, 200, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText(string.sub((tostring(curFuelPrices["elektro"]-0.01)), 3, 3), 65, 200, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			local xy = string.sub((tostring(curFuelPrices["elektro"]-0.01)), 4, 4)
			if (xy == nil or xy == "") then xy = 0 end
			dxDrawText(xy, 87, 200, 15, 45, tocolor(255, 255, 0, 255), 1, font)
			dxDrawText("9", 110, 201, 10, 30, tocolor(255, 255, 0, 255), 1, fontS)
			
			engineApplyShaderToWorldTexture(shader, "ws_xenon_3")
			dxSetRenderTarget()
		end
		destroyElement(renderTarget)
	end
	
	dxSetRenderTarget()
	
	if (fuelRunning == true) then
		local tmpLiter = liter + 0.018
		local tmpPrice = math.round((tmpLiter*curFuelPrices[curFuelTyp]), 2, "ceil")
		if (getPlayerMoney(localPlayer) < tmpPrice or currentLiter >= maxLiter) then
			fuelRunning = false
			tankHasStopped = true
			stopTanke()
		else
			liter = tmpLiter
			price = tmpPrice
			currentLiter = currentLiter + 0.018
			tmpTankFuel = (100*currentLiter) / maxLiter
		end
	end
	
	-- Zapfsäule
	if (shader2) then
		local renderTarget2 = dxCreateRenderTarget(256, 256, true)
		if (renderTarget2) then
			dxSetShaderValue(shader2, "gOverlay", renderTarget2)
			dxSetRenderTarget(renderTarget2)
			
			local prc, up = "0.00", "⁰"
			local f1, f2 = "PREIS / L", "LITER / L"
			if (curFuelTyp == "elektro") then
				prc, up = (curFuelPrices["elektro"]-0.01), "⁹"
				f1, f2 = "PREIS / A", "AMPERE / A"
			elseif (curFuelTyp == "petrol") then
				prc, up = (curFuelPrices["petrol"]-0.01), "⁹"
			elseif (curFuelTyp == "diesel") then
				prc, up = (curFuelPrices["diesel"]-0.01), "⁹"
			end
			
			dxDrawText(f1, 25, 2, 124, 22, tocolor(0, 0, 0, 255), 1, fontX, "center", "center")
			dxDrawText(f2, 25, 25, 124, 45, tocolor(0, 0, 0, 255), 1, fontX, "center", "center")
			dxDrawText("PREIS / $", 25, 48, 124, 68, tocolor(0, 0, 0, 255), 1, fontX, "center", "center")
			
			dxDrawText(string.sub(tostring(prc), 1, 4)..up, 135, 2, 240, 22, tocolor(255, 255, 255, 255), 1, fontX, "center", "center")
			dxDrawText(string.sub(tostring(liter), 1, 4), 135, 25, 240, 45, tocolor(255, 255, 255, 255), 1, fontX, "center", "center")
			dxDrawText(string.sub(tostring(price), 1, 4), 135, 48, 240, 68, tocolor(255, 255, 255, 255), 1, fontX, "center", "center")
			
			engineApplyShaderToWorldTexture(shader2, "petrolpumpbase_256")
			dxSetRenderTarget()
		end
		destroyElement(renderTarget2)
	end
	
	
	--[[if (curFuelTyp ~= "" and stationDistance < 50) then
		if (gasPump and isElement(gasPump)) then
			local veh = getPedOccupiedVehicle(localPlayer)
			if (veh) then
				local sy, sy, sz = getVehicleComponentPosition(veh, "wheel_rb_dummy", "world")
				if (not sz) then
					sy, sy, sz = getVehicleComponentPosition(veh, "wheel_rb_dummy", "world")
				end
				if (not sz) then
					sy, sy, sz = getVehicleComponentPosition(veh, "bump_rear_dummy", "world")
				end
				if (not sz) then
					sy, sy, sz = getVehicleComponentPosition(veh, "chassis", "world")
				end
				
				--local sx, sy, sz = getPedBonePosition(localPlayer, 25)
				local ex, ey, ez = getElementPosition(gasPump)
				dxDrawLine3D(sx, sy, sz+0.4, ex, ey, ez+1.25, tocolor(0, 0, 0), 3)
			end
		end
	else
		gasPump = false
	end]]
end
addEventHandler("onClientRender", root, renderTankePrice)

addEvent("updateFuelPrices", true)
addEventHandler("updateFuelPrices", root, function(stations)
	fuelStations = stations
	nearstStation, stationDistance = getNearstFuelStation()
end)
triggerServerEvent("requestFuelPrices", localPlayer)
setTimer(function()
	if (#fuelStations > 0) then
		nearstStation, stationDistance = getNearstFuelStation()
	end
end, 1000*5, 0)


local soundStarted = false
bindKey("space", "down", function()
	if (curFuelTyp ~= "" and isPedInVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 and stationDistance < 50 and tankHasStopped ~= true) then
		if (not getVehicleEngineState(getPedOccupiedVehicle(localPlayer))) then
			local prc = 999999999
			if (curFuelTyp == "elektro") then
				prc = curFuelPrices["elektro"]
			elseif (curFuelTyp == "petrol") then
				prc = curFuelPrices["petrol"]
			elseif (curFuelTyp == "diesel") then
				prc = curFuelPrices["diesel"]
			end
			
			if (getPlayerMoney(localPlayer) >= math.ceil(prc)) then
				if (not soundStarted) then
					if (curFuelTyp ~= "elektro") then
						triggerServerEvent("playTankSound", localPlayer, true)
						soundStarted	= true
					end
					maxLiter, _		= getVehicleFuelSizeUsage(getPedOccupiedVehicle(localPlayer))
					currentLiter	= (maxLiter/100)*tonumber(getElementData(getPedOccupiedVehicle(localPlayer), "fuel"))
					tmpTankFuel		= 0
					toggleControl("enter_exit", false)
					setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
				end
				fuelRunning			= true
				canChangeFuelTyp	= false
			else
				notificationShow("error", "Du hast nicht genügend Geld.")
			end
		else
			notificationShow("error", "Schalte zuerst deinen Motor ab.")
		end
	end
end)

local buyTimer = nil
function stopTanke()
	if (curFuelTyp ~= "" and isPedInVehicle(localPlayer) and stationDistance < 50) then
		fuelRunning = false
		killTimer(buyTimer)
		setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
		buyTimer = setTimer(function()
			if (fuelRunning == false) then
				triggerServerEvent("playTankSound", localPlayer, false)
				if (tonumber(price) > 0) then
					triggerServerEvent("fuelVehicle", localPlayer, curFuelTyp, liter)
				end
				soundStarted		= false
				curFuelTyp			= ""
				liter				= "0.00"
				price				= "0.00"
				canChangeFuelTyp	= true
				tankHasStopped		= false
				tmpTankFuel			= 0
				currentLiter		= 0
				maxLiter			= 0
				gasPump				= false
				toggleControl("enter_exit", true)
			end
		end, 3000, 1)
	end
end
bindKey("space", "up", function()
	if (tankHasStopped ~= true) then
		stopTanke()
	end
end)

local tankSounds = {}
addEvent("playTankSound3D", true)
addEventHandler("playTankSound3D", root, function(bool, pName, x, y, z)
	destroyElement(tankSounds[pName])
	
	if (bool) then
		tankSounds[pName] = playSound3D("files/sounds/refuel.mp3", x, y, z, true)
		setSoundVolume(tankSounds[pName], 0.5)
		setSoundMaxDistance(tankSounds[pName], 25)
	end
end)