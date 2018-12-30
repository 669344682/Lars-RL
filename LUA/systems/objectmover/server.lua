----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


function spawnFurnitureObjects()
	local count = 0
	local sql = dbQuery("SELECT * FROM furniture")
	if (sql) then
		local result, num_affected_rows = dbPoll(sql, -1)
		if (num_affected_rows > 0) then
			for i, row in pairs(result) do
				
				local ID = tonumber(row["ID"])
				local x,y,z,rx,ry,rz,dim,int = unpack(fromJSON(row["position"]))
				local objectID = tonumber(row["objectID"])
				local interior = tonumber(row["interior"])
				local dimension = tonumber(row["dimension"])
				local houseID = tonumber(row["houseID"])
				
				local placedObject = createObject(objectID, 0, 0, 0, rx, ry, rz)
				setElementPosition(placedObject, x, y, z) -- unbedingt so lassen, sonst erkennt colshape das obj nicht
				setElementDimension(placedObject, dim)
				setElementInterior(placedObject, int)
				--setObjectBreakable(placedObject, false)
				setElementFrozen(placedObject, true)
				setElementData(placedObject, "furnitureObject", true)
				setElementData(placedObject, "furnitureObjectOwner", houseID)
				setElementData(placedObject, "furnitureObjectSaved", true)
				setElementData(placedObject, "furnitureObjectID", ID)
				
				count = count + 1
				
			end
		end
	end
	
	outputDebugString("[Systems->Objectmover->spawnFurnitureObjects()]: Spawned "..count.." furniture objects.")
	return true
end
addEventHandler("onResourceStart", resourceRoot, spawnFurnitureObjects, true, "low-100")

function startObjectPlacer(object)
	
	if (tonumber(object) == nil) then
		
		if (getElementData(object, "furnitureObject")) then
			local owner = getElementData(object, "furnitureObjectOwner")
			if (owner == getPlayerName(source) or House:isOwner(owner, source) or owner == false) then
				
				if (getElementData(object, "furnitureObjectSaved") == true) then
					MySQL:delRow("furniture", dbPrepareString("ID=?", getElementData(object, "furnitureObjectID")))
				end
				
				local x, y, z = getElementPosition(object)
				local _, _, rz = getElementRotation(object)
				
				triggerClientEvent(source, "objectPlaceStart", source, getElementModel(object), isPlayerInHouse(source), "furniture", {x,y,z,rz})
				destroyElement(object)
				
			else
				notificationShow(source, "error", "Dieses Objekt gehört dir nicht.")
			end
		end
		
	else
		triggerClientEvent(source, "objectPlaceStart", source, object, isPlayerInHouse(source), "furniture", nil)
	end
	
end
addEvent("startObjectPlacer", true)
addEventHandler("startObjectPlacer", root, startObjectPlacer)

--[[addCommandHandler("ptest", function(player, cmd, id)
	triggerEvent("startObjectPlacer", player, id)
end)]]

local function placeObject(objectID, x, y, z, rx, ry, rz)
	
	local placedObject = createObject(objectID, 0, 0, 0, rx, ry, rz)
	setElementDimension(placedObject, getElementDimension(source))
	setElementInterior(placedObject, getElementInterior(source))
	setElementData(placedObject, "furnitureObject", true)
	setElementData(placedObject, "furnitureObjectOwner", source:getName())
	setElementPosition(placedObject, x, y, z) -- unbedingt so lassen, sonst erkennt colshape das obj nicht
	
	
	-- Checken ob Spieler auf Grundstück oder in Haus => permanent Speichern
	local inHouse	= false
	local onPlot	= false
	local saveID	= false
	local plot		= getPlayerCurrentHousePlot(source, placedObject)
	local isAllowed	= true
	if (isPlayerInHouse(source)) then
		local houseID = getElementDimension(source)
		if (getElementData(source, "curHouseInt") > 0 and House:isOwner(houseID, source)) then
			inHouse = houseID
			saveID	= houseID
		else
			isAllowed = false
		end
		
	elseif (plot ~= false) then
		if (House:isOwner(plot, source)) then
			onPlot	= plot
			saveID	= plot
		else
			isAllowed = false
		end
	end
	
	
	if (isAllowed) then
		
		-- check max object count
		local canSave	= true
		local errMsg	= ""
		if (onPlot) then
			local count = #getElementsWithinColShape(House.houses[plot].colshape, "object")
			if (count > 100) then
				canSave = false
				errMsg	= "Du kannst nicht mehr als 100 Objekte auf deinem Grundstück platzieren."
			end
		elseif (inHouse) then
			local col = createColSphere(x, y, z, 1000)
			setElementDimension(col, getElementDimension(source))
			setElementInterior(col, getElementInterior(source))
			local count = 0
			for k, v in pairs(getElementsWithinColShape(col, "object")) do
				if (getElementData(v, "furnitureObject")) then
					count = count + 1
				end
			end
			destroyElement(col)
			if (count > 200) then
				canSave = false
				errMsg	= "Du kannst nicht mehr als 200 Objekte in deinem Haus platzieren."
			end
		end
		
		-- Save object
		if (canSave) then
			local saved = false
			if ((inHouse ~= false or onPlot ~= false) and type(saveID) == "number" and saveID > 0) then
				setElementData(placedObject, "furnitureObjectOwner", saveID)
				setElementData(placedObject, "furnitureObjectSaved", true)
				
				local position	= toJSON({x,y,z,rx,ry,rz,getElementDimension(placedObject),getElementInterior(placedObject)})
				local query		= dbQuery("INSERT INTO furniture (ID, position, objectID, houseID, placer) VALUES ('NULL', ?, ?, ?, ?)", position, objectID, saveID, getPlayerName(source))
				if (query) then
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					setElementData(placedObject, "furnitureObjectID", last_insert_id)
					saved = true
				else
					destroyElement(placedObject)
				end
			end
			
			local fix = "Das Objekt wurde dauerhaft gespeichert."
			if (saved == false) then
				fix = "Das Objekt wird nicht dauerhaft gespeichert, da Du es nicht auf deinem Besitz platziert hast."
			end
			notificationShow(source, "success", fix)
			
			takeInventory(source, tonumber(objectID), 1)
			
		else
			notificationShow(source, "error", errMsg)
			destroyElement(placedObject)
		end
		
	else
		notificationShow(source, "error", "Hier kannst Du keine Objekte platzieren.")
		destroyElement(placedObject)
	end
end
addEvent("placeObject", true)
addEventHandler("placeObject", root, placeObject)


addEvent("checkIfPlayerOnHousePlot", true)
addEventHandler("checkIfPlayerOnHousePlot", root, function()
	local check = getPlayerCurrentHousePlot(source)
	
	local radius = false
	if (check ~= false) then
		radius = fromJSON(House.houses[check].data["radius"])
	end
	triggerClientEvent(source, "receiveCheckIfPlayerOnHousePlot", source, radius)
end)

function pickupObject(player, object)
	local owner = getElementData(object, "furnitureObjectOwner")
	if (owner and (owner == getPlayerName(player) or House:isOwner(owner, source))) then
		
		if (getElementData(object, "furnitureObjectSaved") == true) then
			MySQL:delRow("furniture", dbPrepareString("ID=?", getElementData(object, "furnitureObjectID")))
		end
		
		addInventory(player, tostring(getElementModel(object)), 1)
		
		destroyElement(object)
		
		notificationShow(player, "success", "Objekt ins Inventar gelegt.")
		
	else
		notificationShow(player, "error", "Dieses Objekt gehört dir nicht.")
	end
end
addEvent("pickupObject", true)
addEventHandler("pickupObject", root, pickupObject)