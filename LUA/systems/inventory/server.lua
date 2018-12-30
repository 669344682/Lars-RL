----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

--category:other,food,moneybag,object
-- move	= kann in andere inv verschoben werdn
-- delete = darf man wegwerfen?
-- drop = Bei wegwerfen pickup erstellen? Wenn ja => Object ID
-- consume = Kann verbraucht werden => true, oder wiederverwendbar? => false
-- boneEat	= {"ANIM_BLOCK", "ANIM", ANIM_TIME, OBJECT_ID, BONE_ID, X, Y, Z, RX, RY, RZ},
local InventoryItems = {
	-- OTHER
	["iphone"]		= {
		title	= "SkyPhone",
		category= "other",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["dice"]			= {
		title	= "Würfel",
		category= "other",
		image	= "/files/images/supermarket/dice.png",
		move	= true,
		delete	= true,
		drop	= 1851,
		consume = false,
	},
	["cigarettes"]		= {
		title	= "Zigaretten",
		category= "other",
		image	= "/files/images/supermarket/cigarettes.png",
		move	= true,
		delete	= true,
		drop	= 3044,
		consume = true,
	},
	["firstaid"]		= {
		title	= "Verbandskasten",
		category= "other",
		image	= "/files/images/supermarket/firstaid.png",
		move	= true,
		delete	= true,
		drop	= 1240,
		consume = true,
	},
	["news"]			= {
		title	= "Zeitung",
		category= "other",
		image	= "/files/images/supermarket/news.png",
		move	= true,
		delete	= true,
		drop	= 2852,
		consume = false,
	},
	["toolbox"]			= {
		title	= "Repait-Kit",
		category= "other",
		image	= "/files/images/supermarket/toolbox.png",
		move	= true,
		delete	= true,
		drop	= 3016,
		consume = true,
	},
	--[[["motoroil"]		= {
		title	= "Motoröl",
		category= "other",
		image	= "/files/images/supermarket/kanister.png",
		move	= true,
		delete	= true,
		drop	= 1650,
		consume = true,
	},]]
	["super"]			= {
		title	= "Benzinkanister",
		category= "other",
		image	= "/files/images/supermarket/kanister.png",
		move	= true,
		delete	= true,
		drop	= 1650,
		consume = true,
	},
	["diesel"]			= {
		title	= "Dieselkanister",
		category= "other",
		image	= "/files/images/supermarket/kanister.png",
		move	= true,
		delete	= true,
		drop	= 1650,
		consume = true,
	},
	
	
	
	-- MONEYBAG
	["perso"]			= {
		title	= "Personalausweiß",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["creditcard"]		= {
		title	= "EC-Karte",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["carlicense"]		= {
		title	= "Autoführerschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["bikelicense"]		= {
		title	= "Motorradführerschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["trucklicense"]		= {
		title	= "LKW-Führerschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["flightlicense"]		= {
		title	= "Flugschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["boatlicense"]		= {
		title	= "Bootschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	["weaponlicense"]	= {
		title	= "Waffenschein",
		category= "moneybag",
		image	= "/files/images/supermarket/prepaidcredit.png",
		move	= false,
		delete	= false,
		drop	= false,
		consume = false,
	},
	
	
	-- FOOD
	["beer"]			= {
		title	= "Bier",
		category= "food",
		image	= "/files/images/supermarket/beer.png",
		hunger	= 7,
		boneEat	= {"vending", "vend_drink2_p", 1500, 1543, 11, -0.25, 0.05, 0.1, 0, 90, 0},
		move	= true,
		delete	= true,
		drop	= 1543,
		consume = true,
	},
	["sprunk"]			= {
		title	= "Sprunk",
		category= "food",
		image	= "/files/images/supermarket/sprunk.png",
		hunger	= 5,
		boneEat	= {"vending", "vend_drink2_p", 1500, 1546, 11, 0, 0.05, 0.1, 0, 90, 0},
		move	= true,
		delete	= true,
		drop	= 1546,
		consume = true,
	},
	["coffee"]			= {
		title	= "Kaffee",
		category= "food",
		image	= "/files/images/supermarket/coffee.png",
		hunger	= 7,
		boneEat	= {"vending", "vend_drink2_p", 1500, 1666, 11, 0, 0.05, 0.1, 0, 90, 0},
		move	= true,
		delete	= true,
		drop	= 1666,
		consume = true,
	},
	["wodka"]			= {
		title	= "Wodka",
		category= "food",
		image	= "/files/images/supermarket/wodka.png",
		hunger	= 3,
		boneEat	= {"vending", "vend_drink2_p", 1500, 1668, 11, -0.09, 0.05, 0.1, 0, 90, 0},
		move	= true,
		delete	= true,
		drop	= 1668,
		consume = true,
	},
	["schoko"]			= {
		title	= "Schokoriegel",
		category= "food",
		image	= "/files/images/supermarket/schoko.png",
		hunger	= 10,
		move	= true,
		delete	= true,
		drop	= 2861,
		consume = true,
	},
}

-- Essensshops
for i, shop in pairs(settings.systems.shops) do
	if (type(shop) == "table" and type(shop.menues) == "table") then
		for k, v in pairs(shop.menues) do
			if (type(v.hunger) == "number") then
				InventoryItems["food-"..v.objectID] = {
					title	= v.title,
					category= "food",
					image	= "/files/images/inventory/food.png",
					hunger	= v.hunger,
					boneEat	= shop.boneEat,
					move	= true,
					delete	= true,
					drop	= v.objectID,
					consume	= true,
				}
			end
		end
	end
end

-- add weapons - Nur für Waffenbox, im player inventar ausblenden.
-- #TODO#
for i = 0, 46 do
	InventoryItems[i] = {
		title	= getWeaponNameFromID(i),
		category= "weapon",
		drop	= i,
	}
end




Inventories = {
	["player"]		= {},
	["vehicle"]		= {},
	["house"]		= {},
}

--player,vehicle,house
--Inventories nicht hier, sondern im jeweiligen system erstellen (createInventory()) erstellen sowie saven!

function getInventoryTypFromElement(element)
	local ret = false
	if (getElementType(element) == "player") then
		ret = "player"
		
	elseif (getElementType(element) == "vehicle") then
		ret = "vehicle"
		
	elseif (getElementType(element) == "pickup" and type(getElementData(element, "houseID")) == "number") then
		ret = "house"
		
	end
	
	return ret
end

function createInventory(element, data)
	local typ = getInventoryTypFromElement(element)
	if (typ) then
		if (type(Inventories[typ][element]) ~= "table") then
			Inventories[typ][element] = data
		end
	end
	
	return false
end

-- object kann sein:
-- string aus table InventoryItems
-- weapon-id (1-46)
-- object-id (600-20000)
function addInventory(element, object, count)
	count = tonumber(count)
	if (not count) then count = 1 end
	if ((InventoryItems[tostring(object)] or tonumber(object) ~= nil) and type(count) == "number" and tonumber(count) > 0) then
		local typ = getInventoryTypFromElement(element)
		if (typ) then
			if (type(Inventories[typ][element]) == "table") then
				local old = 0
				if (type(Inventories[typ][element][tostring(object)]) == "number") then old = tonumber(Inventories[typ][element][tostring(object)]) end
				
				Inventories[typ][element][tostring(object)] = old + count
				
				return true
				
			end
		end
		
	end
	return false
end

function takeInventory(element, object, count)
	count = tonumber(count)
	if (not count) then count = 1 end
	if ((InventoryItems[tostring(object)] or tonumber(object) ~= nil) and type(count) == "number" and tonumber(count) > 0) then
		local typ = getInventoryTypFromElement(element)
		if (typ) then
			if (type(Inventories[typ][element]) == "table") then
				local old = 0
				if (type(Inventories[typ][element][tostring(object)]) == "number") then old = tonumber(Inventories[typ][element][tostring(object)]) end
								
				if (old > 0) then
					local new = old - count
					if (new < 0) then new = 0 end
					Inventories[typ][element][tostring(object)] = new
					
					return true
					
				end
				
			end
		end
		
	end
	return false
end

function getInventoryCount(element, object)
	local count = 0
	local typ = getInventoryTypFromElement(element)
	if (typ) then
		
		if (type(Inventories[typ][element][tostring(object)]) == "number") then
			count = tonumber(Inventories[typ][element][tostring(object)])
		end
		
	end
	return count
end


local dropPickups = {}
local function pickPickup(player, key, state, pickup)
	if (pickup and isElement(pickup)) then
		if (dropPickups[pickup]) then
			local x1, y1, z1 = getElementPosition(player)
			local x2, y2, z2 = getElementPosition(pickup)
			if (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < 5) then
				
				addInventory(player, dropPickups[pickup].item, dropPickups[pickup].amount)
				dropPickups[pickup] = nil
				destroyElement(pickup)
				
			end
		end
	end
	unbindKey(player, "e", "down", pickPickup)
end

local function onHitDropPickup(player)
	if (player and source) then
		infoShow(player, "info", "Drücke „E“ um das Item aufzuheben.")
		unbindKey(player, "e", "down", pickPickup)
		bindKey(player, "e", "down", pickPickup, source)
	end
end
setTimer(function()
	local tNow = getRealTime().timestamp
	for k, v in pairs(dropPickups) do
		local r = tNow - v.time
		if (r >= ((60*1000)*15)) then
			destroyElement(k)
			dropPickups[k] = nil
		end
	end
end, 60*1000, 0)

function dropInventoryWorld(element, object, count, x,y,z)
	if (not count) then count = 1 end
	if ((InventoryItems[tostring(object)] or tonumber(object) ~= nil) and (type(count) == "number" and tonumber(count) > 0)) then
		local typ = getInventoryTypFromElement(element)
		if (typ) then
			if (type(Inventories[typ][element]) == "table") then
				local old = getInventoryCount(element, object)
				if (old > 0) then
					takeInventory(element, object, count)
					
					if ((tonumber(object) ~= nil) or (tonumber(InventoryItems[object].drop) ~= nil and tonumber(InventoryItems[object].drop) > 0)) then
						if (not x) then
							x, y, z = getElementPosition(element)
							x, y	= x+1, y+1
						end
						local id = 1220
						if (tonumber(object) == nil) then
							id = InventoryItems[object].drop
						end
						
						local pickup = createPickup(x, y, z, 3, id, 0, 0)
						setElementDimension(pickup, getElementDimension(element))
						setElementInterior(pickup, getElementInterior(element))
						addEventHandler("onPickupHit", pickup, onHitDropPickup)
						dropPickups[pickup] = {time=getRealTime().timestamp, item=object, amount=count}
					end
					
					return true
					
				end
			end
			
		end
	end
	return false
end

local function useInventoryItem(element, object)
	if (InventoryItems[object] or tonumber(object) ~= nil) then
		local item = InventoryItems[object]
		if (type(Inventories["player"][element]) == "table") then
			local old = getInventoryCount(element, object)
			if (old > 0) then
				
				local ok	= nil
				local close = false
				if (tonumber(object) == nil) then
					if (item.category == "other") then
						if (object == "motoroil" or object == "super" or object == "diesel") then
							ok = "Das solltest Du besser nicht trinken."
							
						elseif (object == "news") then
							ok = "#TODO# Read Newspaper"
						elseif (object == "iphone") then
							ok = "#TODO# Open iPhone"
						elseif (object == "dice") then
							useDice(element)
							
						elseif (object == "cigarettes") then
							ok = smokeCigarette(element)
							
						elseif (object == "firstaid") then
							setPedAnimation(element,"ped", "gum_eat", 100, false, false, false)
							setTimer(function()
								local h = getElementHealth(element) + 50
								if (h > 100) then h = 100 end
								setElementHealth(element, h)
							end, 2500, 1)
							ok = true
						end
						
					elseif (item.category == "food") then
						local block, anim, animtime, objectID, bone, x, y, z, rx, ry, rz = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
						if (type(item.boneEat) == "table") then
							block, anim, animtime, objectID, bone, x, y, z, rx, ry, rz = unpack(item.boneEat)
						end
						ok = eatSomething(element, item.hunger, block, anim, animtime, objectID, bone, x, y, z, rx, ry, rz)
						
						
					elseif (item.category == "moneybag") then
						if (object == "perso") then
							ok = "#TODO# Show perso"
						end
					end
					
				elseif (tonumber(object) >= 600) then
					ok = triggerEvent("startObjectPlacer", element, object)
					close = true
				end
				
				
				if (ok == true) then
					if (item and item.consume) then
						takeInventory(element, object, 1)
					end
				elseif (ok ~= nil and ok ~= false) then
					notificationShow(element, "error", ok)
				end
				
				
				if (close) then
					triggerClientEvent(source, "closeInventory", source)
				end
				
				
					
			end
			
		end
	end
	return false
end

addEvent("dropInvItem", true)
addEventHandler("dropInvItem", root, function(target, item, x, y, z, kofferraum)
	if (type(Inventories["player"][source]) == "table") then
		local old = getInventoryCount(source, item)
		if (old > 0) then
			
			if (target == "world") then
				if (tonumber(item) ~= nil and tonumber(item) > 600) then
					dropInventoryWorld(source, item, 1, x, y, z)
					
				else
					if (InventoryItems[item].delete == true and tonumber(InventoryItems[item].drop) ~= nil) then
						dropInventoryWorld(source, item, 1, x, y, z)
						
					else
						notificationShow(source, "error", "Dieses Item kannst Du nicht wegwerfen.")
					end
				end
				
			elseif (getElementType(target) == "vehicle") then
				if (hasPlayerVehKey(source, target)) then
					
					if (kofferraum == true) then
						if (InventoryItems[item].move) then
							if (addInventory(target, item, 1)) then
								takeInventory(source, item, 1)
								notificationShow(source, "success", "Item erfolgreich in den Kofferraum gelegt.")
							end
						else
							notificationShow(source, "error", "Du kannst dieses Item nicht in ein anderes Inventar ablegen.")
						end
					
					else
						
						local ok = false
						if (item == "toolbox") then
							local h		= getElementHealth(target)
							local json	= fromJSON(Vehicles[getVehID(target)].data["specialupgrades"])
							if (json["armor"] == 1) then
								h = h + 500
								if (h > 1700) then h = 1700 end
							else
								h = h + 250
								if (h > 1000) then h = 1000 end
							end
							--fixVehicle(target)
							setElementHealth(target, h)
							notificationShow(source, "success", "Fahrzeug repariert.")
							ok = true
							
						elseif (item == "motoroil") then
							notificationShow(source, "error", "#TODO# use "..item.." with vehicle.")
							
						elseif (item == "super" or item == "diesel") then
							local fuel = tonumber(getElementData(target, "fuel")) or 0
							fuel = math.ceil(fuel + 25)
							if (fuel > 100) then fuel = 100 end
							setElementData(target, "fuel", fuel)
							Vehicles[getVehID(target)].data["fuel"] = fuel
							notificationShow(source, "success", "Fahrzeug aufgetankt.")
							ok = true
							
						end
						
						if (ok) then
							takeInventory(source, item, 1)
						end
						
					end
					
				else
					notificationShow(source, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
				end
				
				
			elseif (getElementType(target) == "player") then
				if (target == source) then
					useInventoryItem(source, item)
					
				else
					--[[if (InventoryItems[item].move) then
						outputChatBox("MOVE ITM "..item.." to "..getPlayerName(target))
					else
						notificationShow(source, "error", "Du kannst dieses Item nicht in ein anderes Inventar ablegen.")
					end]] -- ist jz in client
				end
				
			end
			
			triggerClientEvent(source, "refreshInventory", source, Inventories["player"][source])
			
		end
	end
end)


addEvent("moveItemToVh", true)
addEventHandler("moveItemToVh", root, function(item, count, target)
	if (type(Inventories["player"][source]) == "table") then
		local typ = getInventoryTypFromElement(target)
		local old = getInventoryCount(source, item)
		if (old >= count) then
			if (type(Inventories[typ][target]) == "table") then
				if (takeInventory(source, item, count)) then
					addInventory(target, item, count)
				end
			end
		end
		triggerClientEvent(source, "refreshVhInventory", source, Inventories["player"][source], Inventories[typ][target])
	end
end)
addEvent("moveItemToMy", true)
addEventHandler("moveItemToMy", root, function(item, count, from)
	local typ = getInventoryTypFromElement(from)
	if (type(Inventories[typ][from]) == "table") then
		local old = getInventoryCount(from, item)
		if (old >= count) then
			if (type(Inventories["player"][source]) == "table") then
				if (takeInventory(from, item, count)) then
					addInventory(source, item, count)
				end
			end
		end
		triggerClientEvent(source, "refreshVhInventory", source, Inventories["player"][source], Inventories[typ][from])
	end
end)


local handelsAnfragen = {}
setTimer(function()
	local now = getRealTime().timestamp
	for k, v in pairs(handelsAnfragen) do
		if ((now-v.time) > (60*5)) then
			table.remove(handelsAnfragen, k)
		end
	end
end, 1*60000, 0)

addEvent("answerHandel", true)
addEventHandler("answerHandel", root, function(bool)
	local pName = getPlayerName(source)
	if (handelsAnfragen[pName]) then
		local tbl		= handelsAnfragen[pName]
		local target	= getPlayerFromName(tbl.from)
		if (getPlayerFromName(tbl.from)) then
			if (bool == true) then
				
				if (getPlayerMoney(source) >= tbl.price) then
					
					local itemsOK = true
					for k, v in pairs(tbl.items) do
						local old = getInventoryCount(target, v[3])
						if (old < tonumber(v[2])) then
							itemsOK = v[1]
						end
					end
					
					if (itemsOK == true) then
						
						for k, v in pairs(tbl.items) do
							takeInventory(target, v[3], v[2])
							addInventory(source, v[3], v[2])
						end
						
						infoShow(source, "success", "Du hast die Handelsanfrage von "..tbl.from.." angenommen.")
						infoShow(target, "success", pName.." hat deine Handelsanfrage angenommen.")
						
						takePlayerMoney(source, tbl.price, "Handel mit "..tbl.from)
						givePlayerMoney(target, tbl.price, "Handel mit "..pName)
						
					else
						notificationShow(source, "error", "Der Spieler hat nicht mehr alle Items im Inventar.")
						notificationShow(target, "error", "Die Handelsanfrage wurde abgebrochen, da Du die Items nicht mehr im Inventar hast.")
					end
					
				else
					notificationShow(source, "error", "Du hast nicht genug Geld.")
				end
				
			else
				notificationShow(target, "info", "Der Spieler hat dein Angebot abgelehnt.")
			end
			
		else
			notificationShow(source, "error", "Der Spieler ist offline.")
		end
	end
	
	handelsAnfragen[pName] = nil
end)

addCommandHandler("showhandel", function(player)
	local pName = getPlayerName(player)
	if (handelsAnfragen[pName]) then
		triggerClientEvent(player, "handeReceiveGui", player, handelsAnfragen[pName])
		handelsAnfragen[pName].time = getRealTime().timestamp+(60*60)
	end
end)

addEvent("handelStart", true)
addEventHandler("handelStart", root, function(player, items, price)
	if (player and isElement(player) and items) then
		if (not handelsAnfragen[getPlayerName(player)]) then
			if (tonumber(price) >= 0) then
				if (type(Inventories["player"][source]) == "table") then
					
					local itemsOK = true
					for k, v in pairs(items) do
						local old = getInventoryCount(source, v[3])
						if (old < tonumber(v[2])) then
							itemsOK = v[1]
						end
					end
					
					if (itemsOK == true) then
						handelsAnfragen[getPlayerName(player)] = {from = getPlayerName(source), time = getRealTime().timestamp, items = items, price = price}
						infoShow(player, "success", "Du hast eine Handelsanfrage von "..getPlayerName(source).." erhalte, klicke hier um sie anzusehen.")
					else
						notificationShow(source, "error", "Du hast nicht genug von "..itemsOK..".")
					end
					
				end
			else
				notificationShow(source, "error", "Du mss eine gültige Summe angeben.")
			end
		else
			notificationShow(source, "error", "Der Spieler hat bereits eine offene Handelsanfrage, versuche es später erneut.")
		end
	else
		notificationShow(source, "error", "Der Spieler ist nicht online.")
	end
end)


function openInventory(player, handelWith)
	triggerClientEvent(player, "openInventar", player, Inventories["player"][player], InventoryItems, furnitureNames)
	
	if (handelWith and isElement(handelWith) and getElementType(handelWith) == "player" and handelWith ~= player) then
		triggerClientEvent(player, "openHandelSender", player, handelWith)
	end
end
function openVhInventory(player, element)
	local typ = getInventoryTypFromElement(element)
	if (typ == "vehicle" and (not getVehID(element) or not hasPlayerVehKey(player, element))) then
		return notificationShow(player, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
	end
	if (typ == "house" and not House:isOwner(getElementData(element, "data")["ID"], player)) then
		return notificationShow(player, "error", "Dieses Haus gehört dir nicht.")
	end
	triggerClientEvent(player, "VehicleHouseInventory", player,
	Inventories["player"][player],
	Inventories[typ][element],
	InventoryItems,
	furnitureNames, element)
end
addEvent("openVhInventory", true)
addEventHandler("openVhInventory", root, openVhInventory)