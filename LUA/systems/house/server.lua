----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


House = {
	houses = {
		
	},
	
	houseIdOwner = {
		--[1] = "Spielername",
	},
	playerHouses = {
		--["Lars"] = {[1]=true}
	},
	playerRentings = {
		--["Lars"] = {[1]=true}
	},
}


function House:getHouses(playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	if (playerOrName) then
		
		if (type(self.playerHouses[playerOrName]) ~= "table") then
			self.playerHouses[playerOrName] = {}
		end
		
		return self.playerHouses[playerOrName]
		
	end
	return false
end
function House:isOwner(houseID, playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	if (playerOrName) then
		if (self.houseIdOwner[houseID] and self.houseIdOwner[houseID] == playerOrName) then
			
			return true
			
		end
	end
	return false
end

function House:hasHouse(playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	if (playerOrName) then
		
		if (#getHouses(playerOrName) > 0) then
			
			return true
			
		end
	end
	return false
end

function House:getRentigs(playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	if (playerOrName) then
		
		if (type(self.playerRentings[playerOrName]) ~= "table") then
			self.playerRentings[playerOrName] = {}
		end
		
		return self.playerRentings[playerOrName]
	end
	return false
end
function House:isRenter(houseID, playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	if (playerOrName) then
		
		local rentings = self:getRentigs(playerOrName)
		if (rentings and rentings[houseID] == true) then
			return true
		end
		
	end
	return false
end


function House:hasKey(houseID, playerOrName) -- Nur für in-out verwenden
	if (self:isOwner(houseID, playerOrName)) then
		return true
	elseif (self:isRenter(houseID, playerOrName)) then
		return true
	end
	return false
end



function House:spawn()
	local count = 0
	
	local sql = dbQuery("SELECT * FROM houses")
	if (sql) then
		local result, num_affected_rows = dbPoll(sql, -1)
		if (num_affected_rows > 0) then
			for i, row in pairs(result) do
				
				self:spawnHouse(row)
				
				count = count + 1
			end
		end
		
		outputDebugString("[Systems->House->Spawn()]: Created "..count.." houses.")
	end
	
	return true
end
addEventHandler("onResourceStart", resourceRoot, function(...) House:spawn(...) end, true, "low-10")

addEventHandler("onResourceStop", resourceRoot, function()
	House:save()
end, true, "high+500")

function House:saveHouse(id)
	local house = self.houses[id]
	if (house) then
		local fields = ""
		for k, v in pairs(house.data) do
			fields = fields.." "..k.."='"..v.."', "
		end
		fields = fields.."inventory='"..toJSON(Inventories["house"][house.pickupIn]).."'"
		--fields = string.sub(fields, 1, string.len(fields)-2) -- letztes ', ' entfernen
		dbExec("UPDATE houses SET "..fields.." WHERE ID='"..house.data["ID"].."'")
		setElementData(house.pickupOut, "data", house.data)
		setElementData(house.pickupIn, "data", house.data)
	end
end
function House:save()
	local q = dbExec("START TRANSACTION;")
	if (q) then
		
		for ID, v in pairs(self.houses) do
			self:saveHouse(ID)
		end
		
		dbExec("COMMIT;")
		
		outputDebugString("[Systems->House->save()]: Saved "..#self.houses.." Houses.")
		
	else
		outputDebugString("[Systems->House->save()]: Cant save House data!", 1)
	end
end

function House:spawnHouse(data)
	if (not self.houses[tonumber(data["ID"])] or self.houses[tonumber(data["ID"])] == nil) then
		local model = 1272
		if (data["owner"] == "none") then
			model = 1273
		end
		
		local x, y, z	= unpack(fromJSON(data["position"]))
		local pickupOut	= createPickup(x, y, z, 3, model, 1000, 0)
		setElementData(pickupOut, "data", data)
		
		local int, intx, inty, intz = getInteriorData(data["interior"])
		local pickupIn				= createPickup(intx, inty, intz, 3, 1277, 1000, 0)
		setElementData(pickupIn, "houseID", tonumber(data["ID"]))
		setElementData(pickupIn, "data", data)
		setElementInterior(pickupIn, int)
		setElementDimension(pickupIn, data["ID"])
		createInventory(pickupIn, fromJSON(data["inventory"]))
		
		local x1, y1, x2, y2, x3, y3, x4, y4 = unpack(fromJSON(data["radius"]))
		local colshape	= createColPolygon(x1, y1, x1, y1, x2, y2, x3, y3, x4, y4)
		setElementData(colshape, "houseID", tonumber(data["ID"]))
		
		self.houses[tonumber(data["ID"])]			= {}
		self.houses[tonumber(data["ID"])].data		= data
		self.houses[tonumber(data["ID"])].pickupOut	= pickupOut
		self.houses[tonumber(data["ID"])].pickupIn	= pickupIn
		self.houses[tonumber(data["ID"])].colshape	= colshape
		
		self.houseIdOwner[tonumber(data["ID"])]		= data["owner"]
		
		if (type(self.playerHouses[data["owner"]]) ~= "table") then
			self.playerHouses[data["owner"]] = {}
		end
		self.playerHouses[data["owner"]][tonumber(data["ID"])] = true
		
		for k, v in pairs(fromJSON(data["mieter"])) do
			if (type(self.playerRentings[k]) ~= "table") then
				self.playerRentings[k] = {}
			end
			self.playerRentings[k][tonumber(data["ID"])] = true
		end
		
		
		
		return true
	end
	return false
end




---/// FUNKTIONEN FÜR ADMINS ///---
function House:create(price, mintime, int, radius)
	--if (player:hasAdminLvl(2)) then --#TODO#
		if (price and mintime and int and radius) then
			
			local mintime	= tonumber(mintime)
			local price		= tonumber(price)
			local int		= tonumber(int)
			
			if (price >= 10000 and mintime >= 15 and int ~= nil) then
				local position	= toJSON({getElementPosition(source)})
				local query		= dbQuery("INSERT INTO houses (ID, position, owner, price, mintime, interior, kasse, miete, locked, radius, mieter, inventory) VALUES ('NULL', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", position, "none", price, mintime, int, 0, 0, 0, radius, "{}", "{}")
				
				if (query) then
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					if (tonumber(last_insert_id) ~= nil) then
						local row = MySQL:fetchRow("houses", dbPrepareString("ID=?", last_insert_id))
						self:spawnHouse(row)
						
						outputLog("house", "Haus #"..last_insert_id.." erstellt (price:"..price..", mintime:"..mintime..", int:"..int..").", getPlayerName(source))
						
					end
				end
			else
				outputChatBox("Verwende: /newhouse [Preis] [Mind. Spielzeit in Stunden] [Interior (/iraum [1-30])] #2", source, 255, 155, 0)
			end
			
		else
			outputChatBox("Verwende: /newhouse [Preis] [Mind. Spielzeit in Stunden] [Interior (/iraum [1-30])] #1", source, 255, 155, 0)
		end
	--end
end
--addCommandHandler("newhouse", function(...) House:create(...) end)
addEvent("addNewHouse", true)
addEventHandler("addNewHouse", root, function(...) House:create(...) end)

function House:delete(player, _, id)
	--if (player:hasAdminLvl(2)) then -- TODO
		local ID = false
		if (tonumber(id) ~= nil) then
			ID = id
		elseif (tonumber(getElementData(player, "hittedHouse")) ~= nil) then
			ID = getElementData(player, "hittedHouse")
		end
		
		local house = self.houses[ID]
		if (house and isElement(house.pickupOut)) then
			local owner = house.data["owner"]
			if (owner ~= "none") then
				-- #TODO#: message
				self.houseIdOwner[ID] = nil
				self.playerHouses[owner][ID] = nil
			end
			MySQL:delRow("houses", dbPrepareString("ID LIKE ?", ID))
			destroyElement(house.pickupOut)
			destroyElement(house.colshape)
			self.houses[ID] = nil
			outputChatBox("Haus gelöscht!", player, 0, 200, 0)
			
			outputLog("house", "Haus #"..ID.." gelöscht.", getPlayerName(player))
			
		else
			outputChatBox("Dieses Haus existiert nicht!", player, 255, 50, 0)
		end
		
	--end
end
addCommandHandler("delhouse", function(...) House:delete(...) end)




---/// FUNKTIONEN FÜR ALLE ///---
function House:In()
	local houseID		= getElementData(source, "hittedHouse")
	if (not houseID) then return end
	
	local house			= self.houses[houseID]
	local px, py, pz	= getElementPosition(source)
	local hx, hy, hz	= getElementPosition(house.pickupOut)
	if (getDistanceBetweenPoints3D(px, py, pz, hx, hy, hz) <= 5) then
		
		if ((getElementModel(house.pickupOut) == 1273 or getElementModel(house.pickupOut) == 1272) and tonumber(house.data["interior"]) > 0) then
			
			if (house.data["owner"] == "none" or tostring(house.data["locked"]) == "0" or self:hasKey(houseID, source)) then
				
				if (not isPedInVehicle(source)) then
					
					local int = house.data["interior"]
					setElementData(source, "curHouseInt", int)
					local int, intx, inty, intz = getInteriorData(int)
					local dim = houseID
					if (int == 0) then
						dim = 0
					end
					setElementDimension(source, dim)
					fadeElementInterior(source, int, intx, inty, intz, 0, dim)
					
					if (self:isOwner(houseID, source)) then
						infoShow(source, "info", "Mit der Taste \"H\" öffnest du das Hausmenü.")
						bindKey(source, "H", "down", function(player) 	
							triggerClientEvent(player, "showHouseGUI_in", player, house.pickupIn, true, false) 
						end)
					end
					
				else
					notificationShow(source, "error", '"Normale Leute" Parken ihre Fahrzeuge in der Garage oder auf der Straße...')
				end
			
			else
				notificationShow(source, "info", "Du hast keinen Schlüssel für dieses Haus.")
			end
		else
			--notificationShow(source, "info", "Du bist bei keinem Haus.")
		end
	else
		--notificationShow(source, "info", "Du bist bei keinem Haus.")
	end
end
addEvent("House:In", true)
addEventHandler("House:In", root, function(...) House:In(...) end)

function House:Out(player)
	local source = source
	if (player) then source = player end
	local dim = getElementDimension(source)
	local houseID = getElementData(source, "hittedHouse")
	local house = self.houses[houseID]
	if (not house) then house = self.houses[getElementDimension(source)] end
	
	if (house) then
		local int, intx, inty, intz = getInteriorData(house.data["interior"])
		local px, py, pz			= getElementPosition(source)
		if (getDistanceBetweenPoints3D(px, py, pz, intx, inty, intz) <= 1.5) then
			setElementData(source, "curHouseInt", 0)
			local sx, sy, sz = getElementPosition(house.pickupOut)
			fadeElementInterior(source, 0, sx, sy, sz)
			setElementDimension(source, 0)
			unbindKey(source, "H", "down", house_menu)
		end
	end
end
addEvent("House:Out", true)
addEventHandler("House:Out", root, function(...) House:Out(...) end)




---/// FUNKTIONEN FÜR MIETER ///---
function House:Rent()
	local houseID = getElementData(source, "hittedHouse")
	if (not houseID) then return end
	local house			= self.houses[houseID]
	--local x1, y1, z1	= getElementPosition(source)
	--local x2, y2, z2	= getElementPosition(house.pickupOut)
	local pName			= getPlayerName(source)
	--local distance		= getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
	local mieter		= fromJSON(house.data["mieter"])
	
	--if (distance < 5) then
		if (house.data["miete"] > 0 and house.data["owner"] ~= "none") then
			if (#mieter < settings.systems.house.maxRenter) then
				
				if (not self:isRenter(houseID, pName) and not self:isOwner(houseID, pName)) then
					
					if (getPlayerMoney(source) >= house.data["miete"]) then
						
						self.playerRentings[pName][houseID]	= true
						self.houses[houseID].data["kasse"]	= house.data["kasse"] + house.data["miete"]
						
						mieter[pName] = house.data["miete"]
						self.houses[houseID].data["mieter"] = toJSON(mieter)
						
						self:saveHouse(houseID)
						
						takePlayerMoney(source, house.data["miete"], "Miete")
						notificationShow(source, "success", "Du hast dich erfolgreich eingemietet.")
						
						outputLog("house", "In Haus #"..houseID.." eingemietet ("..house.data["miete"].."$).", pName)
						
					else
						notificationShow(source, "error", "Du hast nicht genügend Geld, die erste Miete muss in Bar bezahlt werden.")
					end
					
				else
					notificationShow(source, "error", "Du wohnst bereits in diesem Haus.")
				end
				
			else
				notificationShow(source, "error", "Das Haus ist leider schon voll.")
			end
		else
			notificationShow(source, "error", "Dieses Haus ist nicht zu vermieten.")
		end
	--end
end
addEvent("House:Rent", true)
addEventHandler("House:Rent", root, function(...) House:Rent(...) end)

function House:Unrent(houseID)
	local pName		= getPlayerName(source)
	local rentings	= self:getRentigs(pName)
	local houseID	= tonumber(houseID)
	
	if (rentings and rentings[houseID] == true) then
		
		
		self.playerRentings[pName][houseID]	= nil
		local mieter		= fromJSON(self.houses[houseID].data["mieter"])
		mieter[pName] = nil
		self.houses[houseID].data["mieter"] = toJSON(mieter)
		
		self:saveHouse(houseID)
		
		-- #TODO#: check spawn
		notificationShow(source, "success", "Du hast dich erfolgreich ausgemietet!")
		
		outputLog("house", "Aus Haus #"..houseID.." ausgemietet .", pName)
	end
end
addEvent("House:Unrent", true)
addEventHandler("House:Unrent", root, function(...) House:Unrent(...) end)



---/// FUNKTIONEN FÜR BESITZER ///---
function House:getZone(houseID)
	local x, y, z	= getElementPosition(self.houses[houseID].pickupOut)
	local zone		= getZoneName(x, y, z, true)
	
	if (zone == "San Fierro" or zone == "Whetstone") then
		return "SF"
	elseif (zone == "Los Santos" or zone == "Red County" or zone == "Flint County") then
		return "LS"
	elseif (zone == "Las Venturas" or zone == "Tierra Robada" or zone == "Bone County") then
		return "LV"
	end
	
	return false
end

function House:Buy()
	if (getElementData(source, "hittedHouse")) then
		local houseID		= getElementData(source, "hittedHouse")
		local house			= self.houses[houseID]
		local x1, y1, z1	= getElementPosition(source)
		local x2, y2, z2	= getElementPosition(house.pickupOut)
		local pName			= getPlayerName(source)
		local myHouses		= self:getHouses(pName)
		
		if (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 5) then
			if (house.data["owner"] == "none") then
				if ((getElementData(source, "Playingtime")/60) >= house.data["mintime"]) then
					
					local zones = {}
					for k, v in pairs(myHouses) do
						zones[self:getZone(k)] = true
					end
					
					if (not zones[self:getZone(houseID)]) then
						
						local price = tonumber(house.data["price"])
						if (getPlayerBankMoney(source) > price) then
							takePlayerBankMoney(source, price, "Hauskauf (#"..houseID..")")
							
							self.houseIdOwner[houseID]			= pName
							if (type(self.playerHouses[pName]) ~= "table") then
								self.playerHouses[pName] = {}
							end
							self.playerHouses[pName][houseID]	= true
							self.houses[houseID].data["owner"]	= pName
							self:saveHouse(houseID)
							
							setPickupType(self.houses[houseID].pickupOut, 3, 1272)
							
							notificationShow(source, "success", "Du hast das Haus erfolgreich gekauft.")
							
							outputLog("house", "Haus #"..houseID.." gekauft ("..price.."$).", pName)
							
						else
							notificationShow(source, "error", "Du hast nicht genügend Geld auf deinem Bankkonto.")
						end
						
					else
						notificationShow(source, "error", "Du kannst maximal nur ein Haus pro Gebiet (SF, LS und LV) haben.")
					end
					
				else
					notificationShow(source, "error", "Dir fehlen Spielstunden um dieses Haus zu kaufen.")
				end
			else
				notificationShow(source, "error", "Das Haus steht nicht zum Verkauf.")
			end
		else
			--notificationShow(source, "error", "Du bist bei keinem Haus!")
		end
	end
end
addEvent("House:Buy", true)
addEventHandler("House:Buy", root, function(...) House:Buy(...) end)

function House:Sell(houseID)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		
		self.houseIdOwner[houseID]			= "none"
		self.houses[houseID].data["owner"]	= "none"
		self.houses[houseID].data["locked"]	= "0"
		self.playerHouses[pName][houseID]	= nil
		
		setPickupType(self.houses[houseID].pickupOut, 3, 1273)
		
		local mieter = fromJSON(House.houses[houseID].data["mieter"])
		for k, v in pairs(mieter) do
			if (getPlayerFromName(k)) then
				self.playerRentings[getPlayerFromName(k)][houseID] = nil
				outputChatBox("Du wurdest aus dem Haus von "..pName.." gekündigt, da er sein Haus verkauft hat.", getPlayerFromName(k), 255, 155, 0)
			else
				-- TODO: offlinemsg
			end
		end
		mieter = {}
		House.houses[houseID].data["mieter"] = toJSON(mieter)
		
		-- TODO: check spawn
		
		notificationShow(source, "info", "Du hast dein Haus erfolgreich verkauft!")
		local hauswert = math.floor((tonumber(self.houses[houseID].data["price"]) / 100) * settings.systems.house.houseSellBack)
		givePlayerBankMoney(source, hauswert, "Hausverkauf (#"..houseID..")")
		datasave(source)
		
		self:saveHouse(houseID)
		
		outputLog("house", "Haus #"..houseID.." verkauft (Rückzahlung: "..hauswert.."$).", pName)
		
	else
		notificationShow(source, "error", "Dieses Haus gehört dir nicht!")
	end
end
addEvent("House:Sell", true)
addEventHandler("House:Sell", root, function(...) House:Sell(...) end)

local rentRequests = {}
addCommandHandler("acceptkey", function(player)
	local pName = getPlayerName(player)
	if (tonumber(rentRequests[pName]) ~= nil) then
		local houseID = rentRequests[pName]
		
		if (type(House.playerRentings[pName]) ~= "table") then
			House.playerRentings[pName] = {}
		end
		House.playerRentings[pName][houseID]	= true
		
		local mieter = fromJSON(House.houses[houseID].data["mieter"])
		mieter[pName] = 0
		House.houses[houseID].data["mieter"] = toJSON(mieter)
		
		House:saveHouse(houseID)
		
		notificationShow(player, "success", "Du hast den Schlüssel für das Haus angenommen.")
		
	end
end)
function House:AddFreeMieter(houseID, who)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		if (#fromJSON(self.houses[houseID].data["mieter"]) < settings.systems.house.maxRenter) then
			local target = getPlayerFromName(who)
			if (target) then
				
				local mieter = fromJSON(self.houses[houseID].data["mieter"])
				local tName = getPlayerName(target)
				if (tonumber(mieter[tName]) == nil) then
					
					rentRequests[tName] = houseID
					
					outputChatBox(pName.." bietet dir einen Schlüssel für sein Haus an. Tippe /acceptkey um anzunehmen.", target, 255, 155, 0)
					
					notificationShow(source, "success", "Der Spieler hat deine Anfrage erhalten.")
					
				else
					notificationShow(source, "error", "Dieser Spieler wohnt bereits in deinem Haus!")
				end
				
			else
				notificationShow(source, "error", "Der Spieler muss Online sein!")
			end
		else
			notificationShow(source, "error", "Dein Haus ist bereits voll, maximal "..settings.systems.house.maxRenter.." Mieter!")
		end
	end
end
addEvent("House:AddFreeMieter", true)
addEventHandler("House:AddFreeMieter", root, function(...) House:AddFreeMieter(...) end)


function House:KickMieter(houseID, who)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		local mieter = fromJSON(self.houses[houseID].data["mieter"])
		if (tonumber(mieter[who]) ~= nil) then
			
			mieter[who] = nil
			self.houses[houseID].data["mieter"] = toJSON(mieter)
			
			local target = getPlayerFromName(who)
			if (who) then
				self.playerRentings[getPlayerName(target)][houseID] = nil
				outputChatBox(pName.." hat dich aus seinem Haus geworfen.", target, 255, 155, 0)
			else
				-- TODO: offlinemsg, spawncheck & change
			end
			
			self:saveHouse(houseID)
			
			notificationShow(source, "success", "Dem Spieler wurde gekündigt.")
			
		else
			notificationShow(source, "error", "Dieser Spieler wohnt nicht in deinem Haus!")
		end
	else
		notificationShow(source, "error", "Dieses Haus gehört dir nicht!")
	end
end
addEvent("House:KickMieter", true)
addEventHandler("House:KickMieter", root, function(...) House:KickMieter(...) end)

function House:SetRent(houseID, price)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		if (tonumber(price) ~= nil and tonumber(price) <= settings.systems.house.maxRent) then
			price = math.abs(math.floor(tonumber(price)))
			
			self.houses[houseID].data["miete"] = price
			self:saveHouse(houseID)
			
			if (price == 0) then
				notificationShow(source, "success", "Dein Haus ist nun nicht mehr zu mieten!" )
			else
				notificationShow(source, "success", "Dein Haus ist nun für "..price.." $ zu mieten!", 7)
			end
		else
			notificationShow(source, "error", "Du hast einen ungültigen Wert angegeben.\n0 $ = Nicht zu Vermieten, max. "..settings.systems.house.maxRent.." $!", 7)
		end
	else
		notificationShow(source, "error", "Das Haus gehört dir nicht!")
	end
end
addEvent("House:SetRent", true)
addEventHandler("House:SetRent", root, function(...) House:SetRent(...) end)

function House:Lock(houseID)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		local fix1	= "auf"
		local fix2	= "0"
		if (tostring(self.houses[houseID].data["locked"]) == "0") then fix1 = "ab" fix2 = "1" end
		
		self.houses[houseID].data["locked"] = fix2
		self:saveHouse(houseID)
		
		notificationShow(source, "success", "Haustür "..fix1.."geschlossen!")
	else
		notificationShow(source, "error", "Das Haus gehört dir nicht!")
	end
end
addEvent("House:Lock", true)
addEventHandler("House:Lock", root, function(...) House:Lock(...) end)

function House:PayInOut(houseID, outOrIn, amount)
	local pName		= getPlayerName(source)
	local myHouses	= self:getHouses(pName)
	local houseID	= tonumber(houseID)
	
	if (myHouses[houseID] == true) then
		if (amount and tonumber(amount) ~= nil) then
			local amount = math.abs(math.floor(tonumber(amount)))
			if (amount > 0) then
				
				local houseMoney	= tonumber(self.houses[houseID].data["kasse"])
				local handMoney		= tonumber(getPlayerMoney(source))
				
				if (outOrIn == true) then -- OUT
					
					if (houseMoney >= amount) then
						self.houses[houseID].data["kasse"] = (houseMoney - amount)
						self:saveHouse(houseID)
						givePlayerMoney(source, amount, "Hauskasse Auszahlung")
						outputLog("house", "House #"..houseID..": "..amount.."$ ausgezahlt. Hauskasse: "..(houseMoney-amount).."$.", getPlayerName(source))
					else
						notificationShow(source, "error", "Du hast nicht genug Geld.")
					end
						
				else -- IN
					
					if (handMoney >= amount) then
						self.houses[houseID].data["kasse"] = (houseMoney + amount)
						self:saveHouse(houseID)
						takePlayerMoney(source, amount, "Hauskasse Einzahlung")
						outputLog("house", "House #"..houseID..": "..amount.."$ eingezahlt. Hauskasse: "..(houseMoney+amount).."$.", getPlayerName(source))
					else
						notificationShow(source, "error", "Du hast nicht genug Geld.")
					end
					
				end
				
			else
				notificationShow(source, "error", "Ungültige Summe!")
			end
		else
			notificationShow(source, "error", "Ungültige Summe!")
		end
		
	else
		notificationShow(source, "error", "Das Haus gehört dir nicht!")
	end
end
addEvent("housePayInOut", true)
addEventHandler("housePayInOut", root, function(...) House:PayInOut(...) end)



----- Pickup / Colshape
function House:pickUpHit(player)
	if (not isPedInVehicle(player)) then
		if (((getElementModel(source) == 1273 or getElementModel(source) == 1272) and type(getElementData(source, "data")) == "table") or (getElementModel(source) == 1277 and type(getElementData(source, "houseID")) == "number")) then
		
			if (not getElementData(player, "intchange")) then
				local data = getElementData(source, "data")
				triggerClientEvent(player, "showHouseGUI_out", player, data, self:isOwner(data["ID"], player), self:isRenter(data["ID"], player))
				setElementData(player, "hittedHouse", data["ID"])
			end
		end
	end
end
addEventHandler("onPickupHit", root, function(...) House:pickUpHit(...) end)

function House:colshapeHit(ele, dim)
	if (getElementType(ele) == "player" and type(getElementData(source, "houseID")) == "number") then
		local houseID = getElementData(source, "houseID")
		if (type(self.houses[houseID]) == "table") then
			setElementData(ele, "housePlot", houseID)
		end
	end
end
addEventHandler("onColShapeHit", root, function(...) House:colshapeHit(...) end)

function House:colshapeLeave(ele, dim)
	if (getElementType(ele) == "player" and type(getElementData(source, "houseID")) == "number") then
		setElementData(ele, "housePlot", nil)
	end
end
addEventHandler("onColShapeLeave", root, function(...) House:colshapeLeave(...) end)




function isPlayerInHouse(player)
	if (getElementDimension(player) > 0) then
		local house = House.houses[getElementDimension(player)]
		if (type(house) == "table" and isElement(house.pickupOut)) then
			local cInt = getElementData(player, "curHouseInt") or 0
			local int, intx, inty, intz = getInteriorData(cInt)
			if (getElementInterior(player) == int) then
				return true
			end
		end
	end
	return false
end
function getPlayerCurrentHousePlot(player, element) -- Checkt auf welchem Hausgrundstück sich der Player befindet. Rückgabe: Haus-ID oder false falls auf keinem Grundstück/ radius zu weit
	if (type(getElementData(player, "housePlot")) == "number") then
		local ID = tonumber(getElementData(player, "housePlot"))
		if (type(House.houses[ID]) == "table" and isElementWithinColShape(player, House.houses[ID].colshape)) then
			if ((not element) or (element and isElementWithinColShape(element, House.houses[ID].colshape))) then
				return ID
			end
		end
	end
	return false
end

function getElementsInHouseAndPlot(houseID)
	local objects = {}
	
	for k, v in ipairs(getElementsWithinColShape(House.houses[houseID].colshape, "object")) do
		if (getElementData(v, "furnitureObjectOwner")) then
			table.insert(objects, v)
		end
	end
	
	local house = House.houses[houseID]
	local int, intx, inty, intz = getInteriorData(house.data["interior"])
	local col = createColSphere(intx, inty, intz, 999)
	setElementInterior(col, int)
	setElementDimension(col, houseID)
	
	for k, v in ipairs(getElementsWithinColShape(col, "object")) do
		if (getElementDimension(v) == houseID and getElementInterior(v) == int) then
			if (getElementData(v, "furnitureObjectOwner")) then
				table.insert(objects, v)
			end
		end
	end
	
	destroyElement(col)
	
	triggerClientEvent(source, "receiveElementsInHouseAndPlot", source, objects)
end
addEvent("getElementsInHouseAndPlot", true)
addEventHandler("getElementsInHouseAndPlot", root, getElementsInHouseAndPlot)

--[[
addCommandHandler("obc", function(p)
	outputChatBox("count:"..#getElementsWithinColShape(House.houses[getPlayerCurrentHousePlot(p)].colshape, "object"), p)
end)
]]