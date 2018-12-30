----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 7

local function Sexshop()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(152, -104.8, -8.9, 1000.7, 180)
		setElementRotation(shop.ped, 0, 0, 180, "default", true)
		shop.buyMarker		= createMarker(-104.8, -11.1, 999.8, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 180, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player") then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					local pedData = {getPedSkin(shop.ped), x, y, z, rz}
					
					triggerClientEvent(elem, "sexShopHello", elem, pedData)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
Sexshop()



addEvent("sexShopBuy", true)
addEventHandler("sexShopBuy", root, function(menueID)
	local PizzaMenues = settings.systems.shops.sexshop.menues
	if (PizzaMenues[menueID] ~= nil) then
		
		if (getPlayerMoney(source) >= PizzaMenues[menueID].price) then
			
			giveWeapon(source, PizzaMenues[menueID].weaponID)
			takePlayerMoney(source, PizzaMenues[menueID].price, "Sex Shop")
			notificationShow(source, "success", "Vielen Dank für deinen Einkauf!")
			
			Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)