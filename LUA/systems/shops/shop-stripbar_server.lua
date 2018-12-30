----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

-- Stipperinnen Int 3 (nr 2, alhambra)
function createStrippers(int, dim, nr)
	if (int == 2) then
		local ped = createPed(87, 1214.7, -4.7, 1001.3, 315)
		setElementInterior(ped, 2)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_d", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		local ped = createPed(140, 1221.3, 8.3, 1001.3, 115)
		setElementInterior(ped, 2)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_g", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		local ped = createPed(237, 1208.2, -6.2, 1001.3, 45)
		setElementInterior(ped, 2)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "str_loop_a", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		
		local ped = createPed(59, 1202.0, -7.4, 1001.5, 275)
		setElementInterior(ped, 2)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "beach", "sitnwait_loop_w", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		
	elseif (int == 3 and nr == 1) then
		local ped = createPed(87, 1209.5, -37.0, 1001.5, 300)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_d", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		
		local ped = createPed(140, 1215.4, -33.5, 1001.4, 45)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_g", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		
	elseif (int == 3 and nr == 2) then
		local ped = createPed(87, -2671.6, 1410.4, 907.6, 270)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_d", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		local ped = createPed(140, -2677.4, 1405.6, 907.6, 270)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_g", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		local ped = createPed(139, -2677.4, 1413.8, 907.6, 270)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "strip_g", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)


		local ped = createPed(237, -2654.2, 1409.7, 907.4, 260)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "str_loop_a", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)


		local ped = createPed(237, -2670.6, 1427.7, 907.4, 75)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "strip", "str_loop_c", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		local ped = createPed(59, -2674.7, 1430.3, 906.9, 265)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "beach", "sitnwait_loop_w", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)

		local ped = createPed(121, -2672.8, 1425.6, 906.9, 308)
		setElementInterior(ped, 3)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "sunbathe", "parksit_m_idlea", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		
	elseif (int == 17) then
		if (dim == 108) then
			local ped = createPed(98, 488.0, -4.9, 1002.1, 170, true, false)
			setElementData(ped, "firstLastName", "Franz")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "strip", "str_loop_b", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			local ped = createPed(154, 487.35, -26.32, 1003.6, 88, true, false)
			setElementData(ped, "firstLastName", "Mithat")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "sex", "sex_1_cum_w", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			local ped = createPed(162, 486.45, -26.35, 1003.6, 268, true, false)
			setElementData(ped, "firstLastName", "Marc")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "sex", "sex_1_cum_p", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			local ped = createPed(107, 485.97, -23.7, 1003.1, 204, true, false)
			setElementData(ped, "firstLastName", "Adrian")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			
			local obj = createObject(323, 0, 0, 0)
			setElementInterior(obj, 17)
			setElementDimension(obj, dim)
			setTimer(function() setPedAnimation(ped, "paulnmac", "wank_loop", -1, true, false, false, false) attachElementToBone(obj, ped, 4, -0.08, 0.05, 0, 180, 0, 0) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			
			local ped = createPed(83, 502.96, -14.94, 1000.7, 65) --mann
			setElementData(ped, "firstLastName", "Filip Sniggers")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "bd_fire", "playa_kiss_03", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			local ped = createPed(271, 502.1, -14.5, 1000.7, 252)
			setElementData(ped, "firstLastName", "Inak Tivitor")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "bd_fire", "grlfrd_kiss_03", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
		end
		
		
		if (dim == 108) then
			local ped = createPed(252, 485.6, -16.3, 1000.7, 335, true, false)
			setElementData(ped, "firstLastName", "Daniel")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "dancing", "dnce_m_a", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
			local ped = createPed(68, 486.5, -16.35, 1000.7, 355, true, false)
			setElementData(ped, "firstLastName", "Lars")
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "sweet", "sweet_ass_slap", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
		else
			
			local ped = createPed(237, 485.6, -16.3, 1000.7, 335)
			setElementInterior(ped, 17)
			setElementDimension(ped, dim)
			setTimer(function() setPedAnimation(ped, "dancing", "dnce_m_a", -1, true, false, false, false) end, 10000, 0)
			setElementData(ped, "invulnerable", true)
			setElementFrozen(ped, true)
			
		end
		
		local ped = createPed(291, 485.9, -12.2, 1000.7, 215)
		setElementInterior(ped, 17)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "dancing", "dance_loop", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		local s = 190
		if (dim == 108) then s = 177 end
		local ped = createPed(s, 489.6, -11.1, 1000.7, 150)
		setElementInterior(ped, 17)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "dancing", "dnce_m_d", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
		local ped = createPed(46, 490.0, -16.4, 1000.7, 40)
		setElementInterior(ped, 17)
		setElementDimension(ped, dim)
		setTimer(function() setPedAnimation(ped, "dancing", "dnce_m_b", -1, true, false, false, false) end, 10000, 0)
		setElementData(ped, "invulnerable", true)
		setElementFrozen(ped, true)
		
	end
end

local ShopID = 10
local function StripBar()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		local i, x, y, z	= unpack(shop.markerOutPos)
		local ped			= {}
		local mark			= {}
		local name			= ""
		if (i == 1) then
			ped 	= {168, 681.5, -455.4, -25.6, 0}
			mark	= {681.6, -453.7, -26.7}
			name	= "Bar"
			
		elseif (i == 2) then
			ped 	= {40, 1214.6, -15.1, 1000.9, 0}
			mark	= {1214.6, -13.2, 1000}
			name	= "Stripclub"
			createStrippers(i, tonumber(ShopID..sID), 0)
			
		elseif (i == 3) then
			if (x == 1212.2) then
				ped 	= {40, 1206.2, -29.3, 1001, 270}
				mark	= {1207.4, -29.2, 999.8}
				name	= "Stripclub"
				createStrippers(i, tonumber(ShopID..sID), 1)
			else
				ped 	= {40, -2655.4, 1406.8, 906.3, 270}
				mark	= {-2653.8, 1406.8, 905.3}
				name	= "Stripclub"
				createStrippers(i, tonumber(ShopID..sID), 2)
			end
			
		elseif (i == 11) then
			ped 	= {217, 493.6, -77.5, 998.8, 0}
			mark	= {493.5, -75.8, 997.8}
			name	= "Bar"
			
		elseif (i == 17) then
			ped 	= {171, 501.6, -20.7, 1000.7, 90}
			mark	= {499.9, -20.7, 999.7}
			name	= "Disko"
			createStrippers(i, tonumber(ShopID..sID), 0)
			
		elseif (i == 18) then
			ped 	= {184, -223.4, 1403.8, 27.8, 90}
			mark	= {-225.0, 1403.8, 26.7}
			name	= "Bar"
		end
		
		local pID, pX, pY, pZ, pRz = unpack(ped)
		shop.ped			= createPed(pID, pX, pY, pZ, pRz)
		setElementRotation(shop.ped, 0, 0, pRz, "default", true)
		
		local mX, mY, mZ = unpack(mark)
		shop.buyMarker		= createMarker(mX, mY, mZ, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player" and getElementData(elem, "haspizza") ~= true) then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					
					triggerClientEvent(elem, "stripBarHello", elem, name)
					toggleGhostMode(elem, true)
				end
			end
		end)
		
	end
	return true
end
StripBar()


addEvent("stripBarBuy", true)
addEventHandler("stripBarBuy", root, function(menueID, name)
	local PizzaMenues = settings.systems.shops.stripbar.menues
	if (PizzaMenues[menueID] ~= nil) then
		
		if (getPlayerMoney(source) >= PizzaMenues[menueID].price) then
			
			takePlayerMoney(source, PizzaMenues[menueID].price, name)
			notificationShow(source, "success", "Prost!")
			
			if (menueID == 1) then
				addInventory(source, "beer", 1)
			elseif (menueID == 2) then
				addInventory(source, "wodka", 1)
			end
			
			Franchise:addShopMoney(source, PizzaMenues[menueID].price)
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)