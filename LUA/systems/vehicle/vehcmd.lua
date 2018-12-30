----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

addEvent("lockVehicle", true)
addEvent("respawnVehicle", true)
addEvent("parkVehicle", true)
addEvent("addVehKey", true)
addEvent("remVehKey", true)
addEvent("adminDeleteCar", true)
addEvent("adminRespawnCar", true)
addEvent("adminUnspawnCar", true)

local function lockVehicle(player, cmd, slot)
	local slot = (tonumber(slot) or 0)
	local vehTbl = getVehDataFromSlot(player, slot)
	if (vehTbl ~= nil) then
		local veh = vehTbl.vehicle
		if (isElement(veh)) then
			local vID = vehTbl.data["ID"]
			
			local fix = "ab"
			if (isVehicleLocked(veh)) then fix = "auf" end
			notificationShow(player, "success", "Fahrzeug "..fix.."geschlossen.")
			
			lockVeh(veh)
		else
			notificationShow(player, "error", "Du musst dein Fahrzeug zuerst respawnen.")
		end
	else
		notificationShow(player, "error", "Du hast kein Fahrzeug mit dieser Nummer.")
	end
end
addCommandHandler("lock", lockVehicle)

addEventHandler("lockVehicle", root, function(veh)
	if (type(veh) == "number") then veh = getVehicleFromID(veh) end
	if (hasPlayerVehKey(source, veh)) then
		local fix = "ab"
		if (isVehicleLocked(veh)) then fix = "auf" end
		notificationShow(source, "success", "Fahrzeug "..fix.."geschlossen.")
		lockVeh(veh)
		
	else
		notificationShow(source, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
	end
end)

local function vehicleRespawn(player, cmd, slot)
	if (slot) then
		
		if (slot == "all") then
			return executeCommandHandler("towvehall", player)
		end
		
		if (tonumber(slot) == nil and tostring(slot) ~= slot and getElementType(slot) == "vehicle") then
			if (hasPlayerVehKey(source, slot)) then
				local id = getVehID(slot)
				if (id ~= 0) then
					vehTbl = Vehicles[id]
				end
			else
				return notificationShow(player, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
			end
		else
			slot	= tonumber(slot) or 0
			vehTbl	= getVehDataFromSlot(player, slot)
		end
		
		if (vehTbl ~= nil) then
			if (vehTbl.data["towed"] == 0) then
				
				local ok = true
				
				local veh = vehTbl.vehicle
				if (isElement(veh)) then
					local occupants = (getVehicleOccupants(veh) or {})
					for seat, occupant in pairs(occupants) do
						if (occupant and getElementType(occupant) == "player") then
							ok = false
						end
					end
				end
				
				if (ok) then
					respawnVeh(vehTbl.data["ID"])
					takePlayerMoney(player, settings.systems.vehicle.respawnPrice, "Fahrzeug-Respawn")
					notificationShow(player, "success", "Fahrzeug respawnt.")
				else
					notificationShow(player, "error", "Das Fahrzeug ist nicht leer.")
				end
				
			else
				if (vehTbl.data["explosions"] >= settings.systems.vehicle.maxExplosions) then
					if (vehTbl.vehicle) then
						notificationShow(player, "error", "Das Fahrzeug hatte einen Totalschaden, daher kannst Du es nicht respawnen. Wende dich an einen Mechaniker.")
					else
						notificationShow(player, "error", "Das Fahrzeug hatte einen Totalschaden. Da du es nicht abschleppen lassen hast, wurde es abgeschleppt.")
					end
					
				else
					notificationShow(player, "error", "Das Fahrzeug wurde abgeschleppt.")
				end
			end
		else
			notificationShow(player, "error", "Du hast kein Fahrzeug mit dieser Nummer.")
		end
	else
		notificationShow(player, "error", "Gebrauch: /respawn [Slot]")
	end
end
addCommandHandler("respawn", vehicleRespawn)
addCommandHandler("towveh", vehicleRespawn)


addCommandHandler("towvehall", function(player)
	local pName = getPlayerName(player)
	if (getPlayerMoney(player) >= (settings.systems.vehicle.respawnPrice*#PlayerVehicles[pName])) then
	
		local respawned = 0
		for i = 1, 100 do
			local id = PlayerVehicles[pName][i]
			if (id and tonumber(id) ~= nil) then
				
				local vehData = Vehicles[id].data
				if (vehData["towed"] == 0) then
					if (vehData["explosions"] < settings.systems.vehicle.maxExplosions) then
						
						respawnVeh(id)
						
						respawned = respawned + 1
						
					end
				end
				
			end
		end
		
		notificationShow(player, "success", "Du hast deine Fahrzeuge respawnt.")
		takePlayerMoney(player, settings.systems.vehicle.respawnPrice*respawned, "Fahrzeug-Respawn")
	else
		notificationShow(player, "error", "Du hast nicht genügend Geld dabei.")
	end
end)

addEventHandler("respawnVehicle", root, function(veh)
	if (type(veh) == "number") then veh = getVehicleFromID(veh) end
	vehicleRespawn(source, "", veh)
end)


local function parkVehicle(player)
	if (isPedInVehicle(player)) then
		local pName = getPlayerName(player)
		local veh = getPedOccupiedVehicle(player)
		local seat = getPedOccupiedVehicleSeat(player)
		local vID = getVehID(veh)
		if (seat == 0) then
			if (vID ~= 0 and isPlayerVehOwner(player, veh)) then
				if (checkIfFreeParkPlace(veh)) then
					
					local x, y, z = getElementPosition(veh)
					local rx, ry, rz = getElementRotation(veh)
					
					Vehicles[vID].data["position"] = toJSON({x, y, z, rx, ry, rz})
					
					notificationShow(player, "success", "Fahrzeug geparkt.")
					
				else
					notificationShow(player, "error", "Dieser Parkplatz ist bereits besetzt.")
				end
			else
				notificationShow(player, "error", "Dieses Fahrzeug gehört dir nicht.")
			end
		else
			notificationShow(player, "error", "Du bist nicht der Fahrer des Fahrzeugs.")
		end
	else
		notificationShow(player, "error", "Du sitzt in keinem Fahrzeug.")
	end
end
addCommandHandler("park", parkVehicle)
addEventHandler("parkVehicle", root, parkVehicle)

function toggleBreak(player)
	if (isPedInVehicle(player)) then
		local veh = getPedOccupiedVehicle(player)
		local seat = getPedOccupiedVehicleSeat(player)
		local occupants = (getVehicleOccupants(veh) or {})
		if (seat == 0) then
			if getElementData (veh, "handbrake") == true then
				setControlState (player, "handbrake", false)
				setElementData (veh, "handbrake", false)
				setElementFrozen(veh, false)
				for i, occupant in pairs(occupants) do
					triggerClientEvent(occupants[i], "playSound", root, "handbrake_down", false)
				end
			elseif getElementData (veh, "handbrake") == false and not getControlState (player, "handbrake") then
				setControlState (player, "handbrake", true)
				setElementData (veh, "handbrake", true)
				for i, occupant in pairs(occupants) do
					triggerClientEvent(occupants[i], "playSound", root, "handbrake_up", false)
				end
			end
		else
			notificationShow(player, "error", "Du bist nicht der Fahrer des Fahrzeugs.")
		end
	else
		notificationShow(player, "error", "Du sitzt in keinem Fahrzeug.")
	end
end
addCommandHandler("break", toggleBreak)
addCommandHandler("brake", toggleBreak)


addEventHandler("addVehKey", root, function(veh, target)
	if (type(veh) == "number") then veh = getVehicleFromID(veh) end
	if (isPlayerVehOwner(source, veh)) then
		target = getPlayerFromName(target)
		if (target) then
			if ((getPlayerName(target) ~= getPlayerName(source)) and hasPlayerVehKey(target, veh) ~= true) then
				givePlayerVehKey(target, veh)
				notificationShow(source, "success", "Du hast "..getPlayerName(target).." einen Schlüssel gegeben.")
			else
				notificationShow(source, "error", "Der Spieler hat bereits einen Schlüssel.")
			end
		else
			notificationShow(source, "error", "Der angegebene Spieler ist nicht Online.")
		end
	end
end)

addEventHandler("remVehKey", root, function(veh, target)
	if (type(veh) == "number") then veh = getVehicleFromID(veh) end
	if (isPlayerVehOwner(source, veh)) then
		local json = fromJSON(Vehicles[getVehID(veh)].data["vkeys"])
		if (json[target] == true) then
			json[target] = nil
			Vehicles[getVehID(veh)].data["vkeys"] = toJSON(json)
			setElementData(veh, "vkeys", Vehicles[getVehID(veh)].data["vkeys"])
			notificationShow(source, "success", "Du hast "..target.." den Schlüssel abgenommen.")
		else
			notificationShow(source, "error", "Der Spieler hat keinen Schlüssel.")
		end
	end
end)

-- Admin Functions --
addEventHandler("adminDeleteCar", root, function(id, reason)
	--if (source:hasAdminLvl(3)) then
		local vTbl = Vehicles[id]
		destroyElement(vTbl.vehicle)
		MySQL:delRow("vehicles", "ID='"..id.."'")
		local player = getPlayerFromName(vTbl.data["owner"])
		if (player) then
			if not(reason) or (reason == "") then reason = "--" end
			outputChatBox("Dein Fahrzeug in Slot #"..vTbl.data["slot"].." ("..getVehicleNameFromModel(vTbl.data["typ"])..") wurde von "..getPlayerName(source).." gelöscht (Grund: "..reason..").", player, 255, 100, 0)
			notificationShow(source, "success", "Fahrzeug gelöscht.")
		else
			--#TODO#: offlinemsg
		end
		Vehicles[id] = nil
	--else
	--	source:info("error", "Du bist nicht berechtigt.")
	--end
end)

addEventHandler("adminRespawnCar", root, function(id)
	--if (source:hasAdminLvl(2)) then
		respawnVeh(id)
		notificationShow(source, "success", "Fahrzeug respawnt.")
	--else
	--	source:info("error", "Du bist nicht berechtigt.")
	--end
end)

addEventHandler("adminUnspawnCar", root, function(id)
	local vTbl = Vehicles[id]
	destroyElement(vTbl.vehicle)
	notificationShow(source, "success", "Fahrzeug ungespawnt.")
end)