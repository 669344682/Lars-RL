----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 3

local function Supermarket()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(15, -27.9, -91.6, 1003.5, 0.0)
		setElementRotation(shop.ped, 0, 0, 0, "default", true)
		shop.buyMarker		= createMarker(-27.9, -89.7, 1002.6, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 0, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player") then
					
					triggerClientEvent(elem, "supermarketHello", elem)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
Supermarket()




addEvent("supermarketBuy", true)
addEventHandler("supermarketBuy", root, function(menueID, count)
	local PizzaMenues = settings.systems.shops.supermarket.menues
	if (PizzaMenues[menueID] ~= nil) then
		
		if (getPlayerMoney(source) >= PizzaMenues[menueID].price) then
			if (PizzaMenues[menueID].onlyOnce==true) then count = 1 end
			
			local myWeapons = {}
			for i = 1, 100 do myWeapons[i] = false end
			for i = 0, 12 do
				local weapon = getPedWeapon(source, i)
				if (weapon ~= 0) then
					myWeapons[weapon] = true
				end
			end
			
			local name = PizzaMenues[menueID].title
			if (name == "Verbandskasten") then
				local c =  (tonumber(getInventoryCount(source, "firstaid")) or 0)
				if (c < 1) then
					addInventory(source, "firstaid", 1)
				else
					return notificationShow(source, "error", "Du hast bereits einen Verbandskasten.")
				end
				
			elseif (name == "Blumen") then
				if (myWeapons[14] == false) then
					giveWeapon(source, 14, 1, true)
				else
					return notificationShow(source, "error", "Du hast bereits einen Blumenstrauß.")
				end
				
			elseif (name == "Bier") then
				addInventory(source, "beer", count)
				
			elseif (name == "Sprunk") then
				addInventory(source, "sprunk", count)
				
			elseif (name == "Kaffee") then
				addInventory(source, "coffee", count)
				
			elseif (name == "Schokoriegel") then
				addInventory(source, "schoko", count)				
				
			elseif (name == "Packung Zigaretten") then
				addInventory(source, "cigarettes", count)
			
			elseif (name == "Würfel") then
				local c =  (tonumber(getInventoryCount(source, "dice")) or 0)
				if (c < 1) then
					addInventory(source, "dice", 1)
				else
					return notificationShow(source, "error", "Du hast bereits einen Würfel.")
				end
				
			elseif (name == "50 $ Prepaid-Guthaben") then
				-- #TODO#
				
			elseif (name == "100 $ Prepaid-Guthaben") then
				-- #TODO#
				
			elseif (name == "Kamera") then
				if (myWeapons[43] == false) then
					giveWeapon(source, 43, 36, true)
				else
					return notificationShow(source, "error", "Du hast bereits eine Kamera.")
				end
				
			elseif (name == "Kamerafilm") then
				if (myWeapons[43] == true) then
					giveWeapon(source, 43, (36*count), true)
				else
					return notificationShow(source, "error", "Du hast keine Kamera.")
				end
				
			elseif (name == "Wodka") then
				addInventory(source, "wodka", count)
				
			elseif (name == "Rubbellos") then
				local rnd		= math.random(1, 100)
				local faktor	= 0
				if (rnd >= 99) then
					faktor = 10
				elseif (rnd >= 95) then
					faktor = 5
				elseif (rnd >= 85) then
					faktor = 2
				elseif (rnd >= 65) then
					faktor = 1.5
				else
					faktor = 0
				end
				
				takePlayerMoney(source, PizzaMenues[menueID].price, "24/7 Supermarkt")
				Franchise:addShopMoney(source, PizzaMenues[menueID].price)
				if (faktor > 0) then
					givePlayerMoney(source, (PizzaMenues[menueID].price*faktor), "Rubbellos Gewinn")
					notificationShow(source, "success", "Du hast "..(PizzaMenues[menueID].price*faktor).." $ gewonnen!")
				else
					notificationShow(source, "success", "Leider nur eine Niete.")
				end
				
				return true
				
			else
				return false
			end
			
			takePlayerMoney(source, (PizzaMenues[menueID].price*count), "24/7 Supermarkt")
			notificationShow(source, "success", "Vielen Dank für deinen Einkauf!")
			
			Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)