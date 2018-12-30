local x, y, width, height
local NosBottleWidth, NosBottleHeight = 110 / 2, 250 / 2
local nosX = screenX - 300 - NosBottleWidth - 10
local nosY = screenY - 30
local distToBottom = 48.5 / 200 * NosBottleHeight
local distToTop = 37 / 200 * NosBottleHeight
local fixDist = 17 / 200 * NosBottleHeight
local nosAmountToDraw = 0

local function nosRender ()
	if drawNos and getPedOccupiedVehicle (localPlayer) and getVehicleUpgradeOnSlot (getPedOccupiedVehicle (localPlayer), 8) then
		local x = nosX
		local y = nosY
		width, height = NosBottleWidth, NosBottleHeight
		height = height - distToBottom - distToTop
		height = height / 100 * nosAmountToDraw
		dxDrawImageSection (x+13, y + fixDist - distToTop, width-27, -height, 1, distToTop, width, height, "files/images/vehicle/nos.png")
	else
		drawNos = false
		destroyElement (nosBottle)
		nosBottle = nil
		removeEventHandler ("onClientRender", root, nosRender)
	end
end

local function refreshNosValues ()
	local veh = getPedOccupiedVehicle (localPlayer)
	if getPedOccupiedVehicleSeat (localPlayer) == 0 then
		if getElementData(veh, "nitrocount") and getVehicleNitroLevel(veh) > 0 then
			nosAmountToDraw = math.floor((tonumber(getVehicleNitroLevel(veh)))*100)
			if usedNos then
				nosAmountToDraw = nosAmountToDraw - usedNos
			end
			if not drawNos then
				drawNos = true
				addEventHandler ("onClientRender", root, nosRender)
				local x = nosX
				local y = nosY - NosBottleHeight
				width, height = NosBottleWidth, NosBottleHeight
				nosBottle = guiCreateStaticImage (x, y, width, height, "files/images/vehicle/bottle.png", false)
			end
			return nil
		end
	end
	drawNos = false
	if nosBottle then
		destroyElement (nosBottle)
		nosBottle = nil
		removeEventHandler ("onClientRender", root, nosRender)
	end
end

local streamedInPlayers = {}
function setVehicleNitroActivatedAll(veh, state, noTrigger)
	if (not noTrigger) then
		triggerServerEvent("activateNitro", localPlayer, veh, state, streamedInPlayers)
	end
	return setVehicleNitroActivated(veh, state)
end
addEvent("activateNitroClient", true)
addEventHandler("activateNitroClient", root, function(veh, state)
	setVehicleNitroActivatedAll(veh, state, true)
end)

addEventHandler("onClientElementStreamIn", root, function()
	if (source and getElementType(source) == "player" and source ~= localPlayer) then
		streamedInPlayers[source] = true
	end
end)
addEventHandler("onClientElementStreamOut", root, function()
	if (source and getElementType(source) == "player") then
		streamedInPlayers[source] = false
	end
end)

local overrideLevel	= false
local pushTimer		= false
bindKey("lshift", "down", function(key, state)
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		if (state == "down") then
			if (not isVehicleNitroActivated(veh)) then
				if (isVehicleNitroRecharging(veh) == false or (isVehicleNitroRecharging(veh) and overrideLevel ~= false)) then
					if ((tonumber(getVehicleNitroCount(veh)) or 0) > 0) then
						
						setVehicleNitroActivatedAll(veh, true)
						overrideLevel = false
						pushTimer = setTimer(function()
							local fuel = getVehicleNitroLevel(veh) * 100
							if (not getKeyState("lshift") or fuel < 1 or not isPedInVehicle(localPlayer)) then
								overrideLevel = getVehicleNitroLevel(veh)
								if (fuel < 1) then
									setVehicleNitroCount(veh, (getVehicleNitroCount(veh)-1))
									overrideLevel = false
								end
								killTimer(pushTimer)
								setVehicleNitroActivatedAll(veh, false)
							end
						end, 100, 0)
						
					end
				end
			end
		end
	end
end)

local function useNitro()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) and not isCursorShowing() then
		if (isVehicleNitroRecharging(veh) and overrideLevel ~= false) then
			if ((tonumber(getVehicleNitroCount(veh)) or 0) > 0) then
				overrideLevel = false
				setVehicleNitroCount(veh, (getVehicleNitroCount(veh)-1))
				setVehicleNitroActivatedAll(veh, true)
			end
		end
	end
end
bindKey("mouse1", "down", useNitro)
bindKey("lctrl", "down", useNitro)
bindKey("lalt", "down", useNitro)


function syncNitroWithServer(veh)
	local count = getVehicleNitroCount(veh)
	local level = false
	if (tonumber(overrideLevel) ~= nil) then
		level = overrideLevel
	end
	triggerServerEvent("syncNitro", localPlayer, veh, count, level)
end

addEventHandler("onClientPlayerVehicleExit", root, function(veh, seat)
	if (source == localPlayer and seat == 0) then
		syncNitroWithServer(veh)
		overrideLevel = false
	end
end)
addEventHandler("onClientPlayerVehicleEnter", root, function(veh, seat)
	if (source == localPlayer and seat == 0) then
		local count = getElementData(veh, "nitrocount")
		if (count and tonumber(count) ~= nil) then
			setVehicleNitroCount(veh, count)
		end
		local level = getElementData(veh, "nitrolevel")
		if (level and tonumber(level) ~= nil) then
			overrideLevel = level
		end
	end
end)




addEventHandler("onClientRender", root, function()
	if (tonumber(overrideLevel) ~= nil) then
		local veh = getPedOccupiedVehicle(localPlayer)
		if (veh) then
			setVehicleNitroLevel(veh, overrideLevel)
		end
	end
	
	
	-- Nitro-Anzeige
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
	refreshNosValues ()
		--dxDrawRectangle(100, 200, 150, 100, tocolor(0, 0, 0, 200))
		
		local status = "READY"
		if (isVehicleNitroRecharging(veh)) then
			if (not overrideLevel) then
				status = "CHARGING ("..math.floor((tonumber(getVehicleNitroLevel(veh) or 0))*100).."%)"
			end
		elseif (isVehicleNitroActivated(veh)) then
			status = "IN USE"
		end
		--dxDrawText("Status: "..status, 105, 205, 200, 200, tocolor(255,255,255))
		
		--dxDrawText("Füllstand: "..math.floor((tonumber(getVehicleNitroLevel(veh)) or 0)*100).."%", 105, 225, 200, 200, tocolor(255,255,255))
		--dxDrawText("Füllungen: "..tostring(getVehicleNitroCount(veh)), 105, 245, 200, 200, tocolor(255,255,255))
	end
end)