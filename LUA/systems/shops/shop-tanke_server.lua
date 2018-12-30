----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local ShopID = 9

local function tankeShop()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(15, -23.57197, -57.69551, 1003.54688, 0.0)
		setElementRotation(shop.ped, 0, 0, 0, "default", true)
		shop.buyMarker		= createMarker(-23.32878, -55.35968, 1002.6, "cylinder", 1.0, 255, 0, 0, 255, root)
		
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
					
					triggerClientEvent(elem, "tankeShopHello", elem)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
tankeShop()




addEvent("tankeShopBuy", true)
addEventHandler("tankeShopBuy", root, function(menueID, count)
	local PizzaMenues = settings.systems.shops.tankstelle.menues
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
			
	
			
			takePlayerMoney(source, (PizzaMenues[menueID].price*count), "24/7 Supermarkt")
			notificationShow(source, "success", "Vielen Dank für deinen Einkauf!")
			
			Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)