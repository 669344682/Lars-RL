----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

Vehicle = {}
Vehicles = {}
PlayerVehicles = {}

local function checkPlayerTable(pName)
	if (type(PlayerVehicles[pName]) ~= "table") then
		PlayerVehicles[pName] = {}
	end
end

local badSpawnPos = {} --x,y,z,rz
function spawnVehicles()	
	for k, v in ipairs(Carhouses) do
		local x, y, z, rz = unpack(v.carSpawnPos)
		badSpawnPos[x..y..z..rz] = true
	end
	
	local spawned = 0
	local notSpawned = 0
	local towedVehicles = 0
	
	local sql = dbQuery("SELECT * FROM vehicles")
	if (sql) then
		local result, num_affected_rows = dbPoll(sql, -1)
		if (num_affected_rows > 0) then
			for i, row in pairs(result) do
				
				if (tostring(row["towed"]) == "0") then
					local owner = row["owner"]
					local lastLogin = tonumber(MySQL:getValue("players", "LoginTimestamp", "Name LIKE '"..owner.."'"))
					if (lastLogin == nil or ((getRealTime().timestamp - lastLogin) < (((60*60)*24)*7))) then
						
						spawnVeh(row)
						
						spawned = spawned + 1
						
					else
						Vehicles[row["ID"]] = {data = row}
						notSpawned = notSpawned + 1
					end
				else
					Vehicles[row["ID"]] = {data = row}
					towedVehicles = towedVehicles + 1
				end
				
				checkPlayerTable(tostring(row["owner"]))
				PlayerVehicles[tostring(row["owner"])][tonumber(row["slot"])] = tonumber(row["ID"])
				
			end
			outputDebugString("[Systems->Vehicle->spawnVehicles()]: Found "..num_affected_rows.." vehicles ("..spawned.." spawned, "..towedVehicles.." towed, "..notSpawned.." not spawned (inactivity).")
		else
			outputDebugString("[Systems->Vehicle->spawnVehicles()]: No vehicles found.")
		end
	end
	
	Vehicle.saveTimer = setTimer(function()
		saveVehicleData()
	end, settings.systems.saveTimersInterval, 0)
	
	return true
end
addEventHandler("onResourceStart", resourceRoot, spawnVehicles, true, "low-10")


function destructVehicles()
	if (isTimer(Vehicle.saveTimer)) then
		killTimer(Vehicle.saveTimer)
	end
	saveVehicleData(true)
	
	outputDebugString("[Systems->Vehicle->destructVehicles()]: Destructed.")
	
	return true
end
addEventHandler("onResourceStop", resourceRoot, destructVehicles, true, "high+500")


function saveVehicle(vv)
	if (type(vv) ~= "table" and getElementType(vv) == "vehicle") then
		local id = getVehID(vv)
		vv = Vehicles[id]
	end
	local fields = ""
	for k, v in pairs(vv.data) do
		if (k == "fuel" and isElement(vv.vehicle)) then v = tonumber(getElementData(vv.vehicle, "fuel")) end
		fields = fields.." "..k.."='"..v.."', "
	end
	fields = fields.."inventory='"..toJSON(Inventories["vehicle"][vv.vehicle]).."'"
	--fields = string.sub(fields, 1, string.len(fields)-2) -- letztes ', ' entfernen
	dbExec("UPDATE vehicles SET "..fields.." WHERE ID='"..vv.data["ID"].."'")
end
function saveVehicleData(stop)
	local q = dbExec("START TRANSACTION;")
	if (q) then
		
		local c = 0
		for vID, _v in pairs(Vehicles) do
			if (stop) then
				local x, y, z, rx, ry, rz = unpack(fromJSON(_v.data["position"]))
				if (badSpawnPos[x..y..z..rz] == true) then
					_v.data["towed"] = 1
					-- todo: offlinemsg an player
				end
			end
			saveVehicle(_v)
			c = c + 1
		end
		dbExec("COMMIT;")
		outputDebugString("[Systems->Vehicle->saveVehicleData()]: Saved "..c.." Vehicles.")
		
	else
		outputDebugString("[Systems->Vehicle->saveVehicleData()]: Cant save vehicle data!", 1)
	end
end

-----------------------------------------------------

-- Allgemeine Funktionen --
function spawnVeh(data)
	--[[
		In 'data' muss die ganze Spalte des Vehicle aus der MySQL Datenbank übergeben werden. (MySQL:fetchRow)
	]]--
	
	if (not Vehicles[data["ID"]] or Vehicles[data["ID"]] == nil) then
		
		local x, y, z, rx, ry, rz = unpack(fromJSON(data["position"]))
		local veh = createVehicle(data["typ"], x, y, z, rx, ry, rz, data["owner"])
		
		Vehicles[data["ID"]] = {}
		Vehicles[data["ID"]].vehicle = veh
		Vehicles[data["ID"]].data = data
		
		
		setElementData(veh, "playerCar", true)
		setElementData(veh, "slot", tonumber(data["slot"]))
		setElementData(veh, "owner", data["owner"])
		setElementData(veh, "fuel", tonumber(data["fuel"]))
		setElementData(veh, "meters", tonumber(data["meters"]))
		setElementData(veh, "vkeys", data["vkeys"])
		
		setElementFrozen(veh, true)
		setVehicleLocked(veh, true)
		setVehicleEngineState(veh, false)
		toggleVehicleRespawn(veh, false)
		setVehicleOverrideLights(veh, 1)
		
		createInventory(veh, fromJSON(data["inventory"]))
		
		-- SET COLORS ---
		if (tonumber(data['paintjob']) ~= nil) then
			setVehiclePaintjob(veh, data["paintjob"])
		else
			setElementData(veh, "cPaintjob", data["paintjob"])
		end
		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = unpack(fromJSON(data["color"]))
		setVehicleColor(veh, r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
		local r, g, b = unpack(fromJSON(data["lcolor"]))
		setVehicleHeadLightColor(veh, r, g, b)
		--
		
		-- ADD TUNINGS --
		for slot, id in pairs(fromJSON(data["upgrades"])) do
			if (tonumber(id) ~= nil and id > 999) then
				addVehicleUpgrade(veh, id)
			end
		end
		for k, v in pairs(fromJSON(data["specialupgrades"])) do
			if (v ~= 0 and v ~= nil and v ~= false) then
				addVehicleSpecialUpgrade(veh, k, v)
			end
		end
		for k, v in pairs(fromJSON(data["performanceupgrades"])) do
			if (v ~= 0 and v ~= nil and v ~= false) then
				addVehiclePerformanceUpgrade(veh, k, v)
			end
		end
		local variants = fromJSON(data["variants"])
		setVehicleVariant(veh, (variants[1] or nil), (variants[2] or variants[1]))
		--
		
		-- Gebrauchtwagen
		if (string.find(data["owner"], "carshop-")) then
			local id = tonumber(gettok(data["owner"], 2, string.byte('-')))
			local cars = Carhouses[id].cars
			local place = nil
			for i = 1, 100 do
				local rnd = math.random(1, #cars)
				if (cars[rnd].id == nil) then
					place = rnd
				end
			end
			local x, y, z, rz = unpack(cars[place].pos)
			setElementPosition(veh, x, y, z)
			setElementRotation(veh, 0, 0, rz)
			
			Carhouses[id].cars[place].vehicle = veh
			Carhouses[id].cars[place].id = tonumber(data["typ"])
			Carhouses[id].cars[place].price = math.ceil((calculateVehWorth(veh) * 100) / 80)
			Carhouses[id].cars[place].data = data
			setVehiclePlateText(veh, string.gsub(Carhouses[id].name, " ", ""))
			setElementData(veh, "owner", Carhouses[id].name)
			setElementData(veh, "carshopCar", true)
			setElementData(veh, "cID", id)
			setElementData(veh, "aID", place)
			setVehicleDamageProof(veh, true)
			setVehicleDoorsUndamageable(veh, true)
		end
		
		checkPlayerTable(tostring(data["owner"]))
		PlayerVehicles[tostring(data["owner"])][tonumber(data["slot"])] = tonumber(data["ID"])
		
		return veh
	end
end

function getPlayerFirstFreeSlot(player)
	local pName = getPlayerName(player)
	local slot = nil
	checkPlayerTable(pName)
	for i = 1, 100 do
		if (not PlayerVehicles[pName][i]) then
			slot = i
			break
		end
	end
	
	return tonumber(slot)
end

function getPlayerVehs(player)
	local pName = getPlayerName(player)
	checkPlayerTable(pName)
	return #PlayerVehicles[getPlayerName(player)]
end

function checkIfFreeParkPlace(veh)
	local x, y, z = getElementPosition(veh)
	local nearstDist = 99
	
	for vID, v in pairs(Vehicles) do
		if (v.vehicle ~= veh) then
			local vx, vy, vz, rx, ry, rz = unpack(fromJSON(v.data["position"]))
			local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
			if (dist < nearstDist) then
				nearstDist = dist
			end
		end
	end
	
	if (nearstDist > 3) then
		return true
	end
	return false
end


--[[
color	= {r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4}
lcolor	= {r, g, b}
]]
function createNewVehicle(player, id, x, y, z, rz, color, lcolor)
	pos		= toJSON({x, y, z, 0, 0, rz}) --|x|y|z|rx|ry|rz|
	if (not color) then color = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} end
	color	= toJSON(color)
	if (not lcolor) then lcolor = {255, 255, 255} end
	lcolor	= toJSON(lcolor)
	
	local query = dbQuery("INSERT INTO vehicles (ID, typ, owner, slot, position, color, lcolor, paintjob, plate, towed, fuel, explosions) VALUES ('NULL', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", id, getPlayerName(player), getPlayerFirstFreeSlot(player), pos, color, lcolor, 3, "", 0, 100, 0)
	if (query) then
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
		if (tonumber(last_insert_id) ~= nil) then
			local row = MySQL:fetchRow("vehicles", dbPrepareString("ID=?", last_insert_id))
			return spawnVeh(row)
		end
	end
	return false
end

-- Funktionen
function getVehicleFromID(id)
	return Vehicles[id].vehicle or nil
end
function getVehID(veh)
	local ID = nil
	for vID, _v in pairs(Vehicles) do
		if (veh == _v.vehicle) then
			ID = vID
			break
		end
	end
	
	return ID
end
function getVehFromSlot(player, slot)
	local veh = false
	for vID, _v in pairs(Vehicles) do
		if (_v.data["owner"] == getPlayerName(player) and tonumber(_v.data["slot"]) == tonumber(slot)) then
			veh = _v.vehicle
			break
		end
	end
	
	return veh
end

function getVehDataFromSlot(player, slot)
	local data = nil
	for vID, _v in pairs(Vehicles) do
		if (_v.data["owner"] == getPlayerName(player) and tonumber(_v.data["slot"]) == tonumber(slot)) then
			data = _v
			break
		end
	end
	
	return data
end
function getVehData(veh)
	local vID = getVehID(veh)
	if (vID ~= nil) then
		return Vehicles[vID].data
	end
	return nil
end


function isPlayerVehOwner(player, veh)
	if (player) then
		local ID = getVehID(veh)
		if (player and tostring(getPlayerName(player)) == tostring(Vehicles[ID].data["owner"])) then
			return true
		end
	end
	return false
end


function hasPlayerVehKey(player, veh)
	if (player and veh) then
		local ID = getVehID(veh)
		if (ID) then
			local json = fromJSON(Vehicles[ID].data["vkeys"])
			if (isPlayerVehOwner(player, veh) or json[getPlayerName(player)] == true) then
				return true
			end
		end
	end
	return false
end
function givePlayerVehKey(player, veh)
	if (player and veh) then
		local ID = getVehID(veh)
		if (ID) then
			local json = fromJSON(Vehicles[ID].data["vkeys"])
			json[getPlayerName(player)] = true
			Vehicles[ID].data["vkeys"] = toJSON(json)
			setElementData(veh, "vkeys", Vehicles[ID].data["vkeys"])
			return true
		end
	end
	return false
end
function takePlayerVehKey(player, veh)
	if (player and veh) then
		local ID = getVehID(veh)
		if (ID) then
			local json = fromJSON(Vehicles[ID].data["vkeys"])
			json[getPlayerName(player)] = nil
			Vehicles[ID].data["vkeys"] = toJSON(json)
			setElementData(veh, "vkeys", Vehicles[ID].data["vkeys"])
			return true
		end
	end
	return false
end



function deleteVeh(vehORid)
	local ID = nil
	if (tonumber(vehORid) ~= nil) then
		ID = vehORid
	else
		ID = getVehID(vehORid)
	end
	
	local vData = Vehicles[ID].data
	if (Vehicles[ID].vehicle) then
		destroyElement(Vehicles[ID].vehicle)
	end
	PlayerVehicles[(data["owner"])][(data["slot"])] = nil
	Vehicles[ID] = nil
	
	return MySQL:delRow("vehicles", "ID='"..ID.."'")
end

function lockVeh(vehORid)
	local ID = nil
	if (tonumber(vehORid) ~= nil) then
		ID = vehORid
	else
		ID = getVehID(vehORid)
	end
	local theVehicle = Vehicles[ID].vehicle
	
	if (theVehicle) then
		local state = isVehicleLocked(theVehicle)
		if (state == true) then
			--if getElementData (theVehicle, "handbrake") == false then
			--	setElementFrozen(theVehicle, false)
			--end	
			setVehicleOverrideLights(theVehicle, 2)
			if (not isTimer(_G["blinkBlink"..ID])) then
				_G["blinkBlink"..ID] = setTimer(function()
					setVehicleOverrideLights(theVehicle, 1)
				end, 500, 1)
			else
				killTimer(_G["blinkBlink"..ID])
			end
		else
			setVehicleOverrideLights(theVehicle, 2)
			if (not isTimer(_G["vehicleLocker"..ID])) then
				_G["vehicleLocker"..ID] = setTimer( function()
					setVehicleOverrideLights(theVehicle, 1)
					setTimer(function()
						setVehicleOverrideLights(theVehicle, 2)
						setTimer(function()
							setVehicleOverrideLights(theVehicle, 0)
						end, 250, 1)
					end, 250, 1)
				end, 250, 1)
			else
				killTimer(_G["vehicleLocker"..ID])
			end
		end
		
		local x, y, z = getElementPosition(theVehicle)
		triggerClientEvent(root, "playSound3D", root, "carlock", x, y, z, false)
		
		return setVehicleLocked(theVehicle, (not state))
	end
	return false
end

function respawnVeh(vehORid)
	local ID = nil
	if (tonumber(vehORid) ~= nil) then
		ID = vehORid
	else
		ID = getVehID(vehORid)
	end
	local theVehicle = Vehicles[ID].vehicle
	
	
	if (isElement(theVehicle)) then
		destroyElement(theVehicle)
	end
	
	local vehicleData = Vehicles[ID].data
	Vehicles[ID] = nil
	
	local veh = spawnVeh(vehicleData)
	return veh
end





-- Eventhandler Funcs
-- #TODO# : Verbuggt
local vehiclesToRemove = {}
setTimer(function()
	local now = getRealTime().timestamp
	for k, v in pairs(vehiclesToRemove) do
		if (k and isElement(k)) then
			if (tonumber(v) ~= nil) then
				
				local r = now - v
				if (r > (60*15)) then
					destroyElement(v)
					vehiclesToRemove[k] = nil
				end
				
			end
		else
			vehiclesToRemove[k] = nil
		end
	end
end, 60000, 0)

function onVehExplode()
	setVehicleEngineState(source, false)
	setElementData(source, "engine", false)
	setVehicleOverrideLights(source, 1)
	toggleNeon(source, false)
	setVehicleDamageProof(source, true)
	
	if (not getElementData(source, "isExploded")) then
		local ID = getVehID(source)
		if (ID ~= nil) then
			local owner = getPlayerFromName(tostring(Vehicles[ID].data["owner"]))
			if (owner) then
				local vx, vy, vz = getElementPosition(source)
				local px, py, pz = getElementPosition(owner)
				if (getDistanceBetweenPoints3D(vx, vy, vz, px, py, pz) <= 10) then
					
					Vehicles[ID].data["explosions"] = Vehicles[ID].data["explosions"] + 1
					
					if (Vehicles[ID].data["explosions"] >= settings.systems.vehicle.maxExplosions) then
						infoShow(owner, "info", "Dein Fahrzeug in Slot "..Vehicles[ID].data["slot"].." hat einen Totalschaden und muss abgeschleppt werden. Wende dich dafür an einen Mechaniker.\nLass dein Fahrzeug nicht auf der Straße liegen - Du könntest einen Strafzettel erhalten.", 8)
						vehiclesToRemove[source] = getRealTime().timestamp
						Vehicles[ID].data["towed"] = 1
						
					else
						infoShow(owner, "info", "Dein Fahrzeug in Slot "..Vehicles[ID].data["slot"].." wurde beschädigt. Wenn Du dich bei 3 Explosionen deines Fahrzeugs in der Nähe befindest, hat dein Fahrzeug einen Totalschaden und muss abgeschleppt und ggf. repariert werden.\nLass dein Fahrzeug nicht auf der Straße liegen - Du könntest einen Strafzettel erhalten.", 12)
					end
					
					setElementFrozen(source, false)
					
				end
				
				toggleVehicleRespawn(source, false)
			end
		end
	end
	
	
	setElementData(source, "isExploded", true)
end
addEventHandler("onVehicleExplode", root, onVehExplode)
addEvent("onVehiclePreExplode", true)
addEventHandler("onVehiclePreExplode", root, onVehExplode)


addEventHandler("onVehicleDamage", root, function(loss)
	if (getElementHealth(source) < 250) then
		cancelEvent()
		setElementHealth(source, 249)
		
		if (not getElementData(source, "isExploded")) then
			triggerEvent("onVehiclePreExplode", source)
		end
	end
end)









function moveVehicleAway(veh)
	if (veh and getElementType(veh) == "vehicle") then 
		setElementPosition(veh, 99999, 99999, 99999)
		setElementInterior(veh, 99999)
		setElementDimension(veh, 99999)	
	end
end

function exitPlayerFromVehicle(player)
	local veh = getPedOccupiedVehicle(player)
	if (isElement(veh)) then
		if (getPedOccupiedVehicleSeat(player) == 0) then
			setElementVelocity(veh, 0, 0, 0)
		end
		setControlState(player, "enter_exit", false)
		setTimer(removePedFromVehicle, 750, 1, player)
		setTimer(setControlState, 150, 1, player, "enter_exit", false)
		setTimer(setControlState, 200, 1, player, "enter_exit", true)
		setTimer(setControlState, 700, 1, player, "enter_exit", false)
	end
end
addEvent("exitPlayerFromVehicle", true)
addEventHandler("exitPlayerFromVehicle", root, function()
	exitPlayerFromVehicle(client)
end)