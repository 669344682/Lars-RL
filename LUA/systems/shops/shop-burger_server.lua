----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 1

local function BurgerShot()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(205, 377.634, -65.592, 1001.5, 180.0)
		setElementRotation(shop.ped, 0, 0, 180, "default", true)
		shop.buyMarker		= createMarker(377.634, -67.7, 1000.6, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 180, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player" and getElementData(elem, "hasburger") ~= true) then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					local pedData = {getPedSkin(shop.ped), x, y, z, rz}
					
					triggerClientEvent(elem, "burgerShotHello", elem, pedData)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
BurgerShot()



local tables = {
	[1] = {
		marker = {372.400, -73.494, 1001.507},
		sitpos = {373.364, -73.359, 1002.022},
		tblpos = {373.549, -72.800, 1001.400},
		matrix = {371.345, -74.066, 1002.604},
	},
	
	[2] = {
		marker = {376.999, -73.344, 1001.507},
		sitpos = {376.401, -73.355, 1002.022},
		tblpos = {376.650, -72.800, 1001.400},
		matrix = {378.200, -73.965, 1002.628},
	},
	
	[3] = {
		marker = {365.856, -68.805, 1001.507},
		sitpos = {365.273, -68.753, 1002.023},
		tblpos = {365.450, -68.199, 1001.400},
		matrix = {367.001, -69.732, 1003.176},
	},
	
	[4] = {
		marker = {361.970, -71.964, 1001.507},
		sitpos = {361.408, -71.992, 1002.023},
		tblpos = {361.700, -71.300, 1001.400},
		matrix = {363.255, -72.786, 1002.404},
	},
	
	[5] = {
		marker = {361.982, -68.822, 1001.507},
		sitpos = {361.354, -68.750, 1002.023},
		tblpos = {361.700, -68.250, 1001.400},
		matrix = {363.483, -69.257, 1002.965},
	},
}
local burgertablet	= {}
local burgermarker	= {}
local usedplaces	= {}
local destroytimer	= {}


function destroyBurger(player)
	local source = source
	if (getElementType(player) == "player") then
		source = player
		removeElementData(source, "hasburger")
		setPedAnimation(source)
		toggleAllControls(source, true, true, true)
		detachElementFromBone(burgertablet[source])
	end
	destroyElement(burgertablet[source])
	destroyElement(burgermarker[source])
	killTimer(destroytimer[source])
	usedplaces[getElementDimension(source)][getElementData(source, "burgerplaceid")] = false
end

addEvent("burgerShotBuy", true)
addEventHandler("burgerShotBuy", root, function(menueID, here)
	local PizzaMenues = settings.systems.shops.burgershot.menues
	if (PizzaMenues[menueID] ~= nil) then
		
		if (getPlayerMoney(source) >= PizzaMenues[menueID].price) then
			
			if (here) then
				local dim = getElementDimension(source)
				
				local nr = false
				for _ = 1, 25 do
					local _nr = math.random(1,#tables)
					if (type(usedplaces[dim]) ~= "table") then
						usedplaces[dim] = {}
					end
					if (usedplaces[dim][_nr] ~= true) then
						nr = _nr
						break
					end
				end
				
				if (nr ~= false) then
					usedplaces[dim][nr] = true
					setElementData(source, "burgerplaceid", nr)
					destroytimer[source] = setTimer(destroyBurger, 1000*300, 1, source)
					
					takePlayerMoney(source, PizzaMenues[menueID].price, "Burger Shot")
					Franchise:addShopMoney(source, PizzaMenues[menueID].price)
					setElementData(source, "hasburger", true)
					notificationShow(source, "success", "Guten Appetit!")
					
					setPedAnimation(source, "CARRY", "crry_prtial", 50)
					burgertablet[source] = createObject(PizzaMenues[menueID].objectID, 0, 0, 0, 0, 0, 0)
					setElementInterior(burgertablet[source], getElementInterior(source))
					setElementDimension(burgertablet[source], getElementDimension(source))
					attachElementToBone(burgertablet[source],source,11,0.1,0.14,0.1,715,839,485)
					
					toggleControl(source, "jump", false)
					toggleControl(source, "sprint", false)
					toggleControl(source, "next_weapon", false)
					toggleControl(source, "previous_weapon", false)
					toggleControl(source, "crouch", false)
					toggleControl(source, "fire", false)
					setPedWeaponSlot(source, 0)
					
					local x,y,z = unpack(tables[nr].marker)
					burgermarker[source] = createMarker(x, y, z, "corona", 1, 255, 0, 0, 255, source)
					setElementInterior(burgermarker[source], getElementInterior(source))
					setElementDimension(burgermarker[source], getElementDimension(source))
					
					addEventHandler("onMarkerHit", burgermarker[source], function(elem, dim)
						if (dim == true) then
							if (getElementType(elem) == "player" and isElementVisibleTo(source, elem)) then
								
								local x,y,z = unpack(tables[nr].sitpos)
								fadeElementInterior(elem, getElementInterior(elem), x, y, z, 0, getElementDimension(elem))
								destroyElement(source)
								setElementFrozen(elem, true)
								setTimer(function()
									toggleAllControls(elem, false, false, false)
									setElementFrozen(elem, false)
									detachElementFromBone(burgertablet[elem])
									setPedAnimation(elem)
									local x,y,z = unpack(tables[nr].tblpos)
									setElementPosition(burgertablet[elem], x, y, z)
									setElementRotation(burgertablet[elem], 335, 23, 73)
									setPedAnimation(elem, "food", "ff_sit_eat1", -1, true, false, false, true)
									
									local burger = createObject(2703, 0, 0, 0)
									setElementInterior(burger, getElementInterior(elem))
									setElementDimension(burger, getElementDimension(elem))
									attachElementToBone(burger,elem,12,0,0.06,0.1,270,0,90)
									local mx,my,mz = unpack(tables[nr].matrix)
									setCameraMatrix(elem, mx, my, mz, x, y, z)
																		
									setTimer(function()
										givePlayerHunger(elem, PizzaMenues[menueID].hunger)
										local x,y,z = unpack(tables[nr].marker)
										fadeElementInterior(elem, getElementInterior(elem), x, y, z, 180, getElementDimension(elem))
										
										setTimer(function()
											setElementData(elem, "hasburger", false)
											detachElementFromBone(burger)
											destroyElement(burger)
											destroyElement(burgertablet[elem])
											burgertablet[elem] = nil
											toggleAllControls(elem, true, true, true)
											setPedAnimation(elem)
											setElementFrozen(elem, false)
											setCameraTarget(elem, elem)
											usedplaces[getElementDimension(elem)][nr] = false
											removeElementData(elem, "burgerplaceid")
											killTimer(destroytimer[source])
											
											removeEventHandler("onPlayerQuit", elem, destroyBurger)
											removeEventHandler("onPlayerWasted", elem, destroyBurger)
										end, 1000, 1)
										
									end, 10000, 1)
									
									fadeCamera(elem, true)
								end, 1000, 1)
							end
						end
					end)
					
					
					addEventHandler("onPlayerQuit", source, destroyBurger)
					addEventHandler("onPlayerWasted", source, destroyBurger)
					
				else
					notificationShow(source, "error", "Zur Zeit sind leider alle Plätze belegt.")
				end
			else
				takePlayerMoney(source, PizzaMenues[menueID].price, "Burger Shot")
				addInventory(source, "food-"..PizzaMenues[menueID].objectID, 1)
				Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			end
			
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)