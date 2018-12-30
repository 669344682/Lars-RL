----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 4

local function Ammunation()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(179, 295.9, -40.2, 1001.5, 0.0)
		setElementRotation(shop.ped, 0, 0, 0, "default", true)
		shop.buyMarker		= createMarker(295.9, -38.1, 1000.6, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 0, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		for _, arr in pairs(settings.systems.shops.ammunation.menues) do
			local x, y, z, rx, ry, rz = unpack(arr.position)
			arr.object = createObject(arr.objectID, x, y, z, rx, ry, rz)
			setElementInterior(arr.object, i)
			setElementDimension(arr.object, tonumber(ShopID..sID))
			setElementFrozen(arr.object, true)
		end
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player") then
					
					triggerClientEvent(elem, "ammunationHello", elem)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	
	return true
end
Ammunation()


addEvent("ammunationBuy", true)
addEventHandler("ammunationBuy", root, function(menueID, ammo)
	local Menues = settings.systems.shops.ammunation.menues
	if (Menues[menueID] ~= nil) then
		
		if (getPlayerMoney(source) >= Menues[menueID].price) then
			
			local OK = false
			local price = Menues[menueID].price
			if (ammo == true) then -- Munition
				
				if (Menues[menueID].munSize > 0) then
					giveWeapon(source, Menues[menueID].weaponID, Menues[menueID].munSize, false)
					OK = true
					price = Menues[menueID].munPrice
				end
				
			elseif (Menues[menueID].weaponID == 50) then -- Schutzweste
			
				if (getPedArmor(source) < 100) then
					setPedArmor(source, 100)
					OK = true
				else
					notificationShow(source, "error", "Du hast bereits eine Schutzweste.")
				end
				
				
			else -- Waffe
				
				local slot = getSlotFromWeapon(Menues[menueID].weaponID)
				if (getPedWeapon(source, slot) ~= Menues[menueID].weaponID or Menues[menueID].canBuyMulti == true) then
					giveWeapon(source, Menues[menueID].weaponID, Menues[menueID].munSize, false)
					OK = true
				else
					notificationShow(source, "error", "Du besitzt diese Waffe bereits.")
				end
			end
			
			
			if (OK) then
				takePlayerMoney(source, price, "Ammu-Nation")
				notificationShow(source, "success", "Vielen Dank für deinen Einkauf!")
				Franchise:addShopMoney(source, Menues[menueID].price)
			end
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)