----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 8

local function DonutShop()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(168, 380.86, -188.92, 1000.6, 90)
		setElementRotation(shop.ped, 0, 0, 90, "default", true)
		shop.buyMarker		= createMarker(378.547, -189.042, 999.7, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 90, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player" and getElementData(elem, "hasdonut") ~= true) then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					local pedData = {getPedSkin(shop.ped), x, y, z, rz}
					
					triggerClientEvent(elem, "donutShopHello", elem, pedData)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
DonutShop()


local tables = {
	[1] = {
		marker = {375.090, -189.118, 1000.640},
		sitpos = {376.100, -189.738, 1001.137},
		tblpos = {376.200, -189.350, 1000.650},
		matrix = {374.541, -190.098, 1002.170},
	},
	
	[2] = {
		marker = {375.089, -186.645, 1000.640},
		sitpos = {376.100, -187.272, 1001.137},
		tblpos = {376.200, -186.910, 1000.650},
		matrix = {373.969, -187.498, 1001.899},
	},
	
	[3] = {
		marker = {375.089, -184.250, 1000.640},
		sitpos = {376.100, -184.819, 1001.137},
		tblpos = {376.200, -184.470, 1000.650},
		matrix = {374.134, -184.964, 1001.840},
	},
	
	[4] = {
		marker = {375.089, -181.089, 1000.640},
		sitpos = {376.100, -182.358, 1001.137},
		tblpos = {376.200, -181.999, 1000.650},
		matrix = {374.127, -182.568, 1002.142},
	},
}
local donuttablet	= {}
local donutmarker	= {}
local usedplaces	= {}
local destroytimer	= {}


function destroyDonut(player)
	local source = source
	if (getElementType(player) == "player") then
		source = player
		removeElementData(source, "hasdonut")
		setPedAnimation(source)
		toggleAllControls(source, true, true, true)
		detachElementFromBone(donuttablet[source])
	end
	destroyElement(donuttablet[source])
	destroyElement(donutmarker[source])
	killTimer(destroytimer[source])
	usedplaces[getElementDimension(source)][getElementData(source, "donutplaceid")] = false
end

addEvent("donutShopBuy", true)
addEventHandler("donutShopBuy", root, function(menueID, here)
	local PizzaMenues = settings.systems.shops.donut.menues
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
					setElementData(source, "donutplaceid", nr)
					destroytimer[source] = setTimer(destroyDonut, 1000*300, 1, source)
					
					-- #TODO#: Hunger --
					takePlayerMoney(source, PizzaMenues[menueID].price, "Rusty Brown's Ring Donuts")
					Franchise:addShopMoney(source, PizzaMenues[menueID].price)
					setElementData(source, "hasdonut", true)
					notificationShow(source, "success", "Guten Appetit!")
					
					setPedAnimation(source, "CARRY", "crry_prtial", 50)
					donuttablet[source] = createObject(PizzaMenues[menueID].objectID, 0, 0, 0, 0, 0, 0)
					setElementInterior(donuttablet[source], getElementInterior(source))
					setElementDimension(donuttablet[source], getElementDimension(source))
					attachElementToBone(donuttablet[source],source,11,-0.1,0.14,0,760,1159,825)
					
					toggleControl(source, "jump", false)
					toggleControl(source, "sprint", false)
					toggleControl(source, "next_weapon", false)
					toggleControl(source, "previous_weapon", false)
					toggleControl(source, "crouch", false)
					toggleControl(source, "fire", false)
					setPedWeaponSlot(source, 0)
					
					local x,y,z = unpack(tables[nr].marker)
					donutmarker[source] = createMarker(x, y, z, "corona", 1, 255, 0, 0, 255, source)
					setElementInterior(donutmarker[source], getElementInterior(source))
					setElementDimension(donutmarker[source], getElementDimension(source))
					
					addEventHandler("onMarkerHit", donutmarker[source], function(elem, dim)
						if (dim == true) then
							if (getElementType(elem) == "player" and isElementVisibleTo(source, elem)) then
								
								local x,y,z = unpack(tables[nr].sitpos)
								fadeElementInterior(elem, getElementInterior(elem), x, y, z, 0, getElementDimension(elem))
								destroyElement(source)
								setElementFrozen(elem, true)
								setTimer(function()
									toggleAllControls(elem, false, false, false)
									setElementFrozen(elem, false)
									detachElementFromBone(donuttablet[elem])
									setPedAnimation(elem)
									local x,y,z = unpack(tables[nr].tblpos)
									setElementPosition(donuttablet[elem], x, y, z)
									setElementRotation(donuttablet[elem], 0, 0, 90)
									setPedAnimation(elem, "food", "ff_sit_eat1", -1, true, false, false, true)
									
									local donut = createObject(2647, 0, 0, 0)
									setElementInterior(donut, getElementInterior(elem))
									setElementDimension(donut, getElementDimension(elem))
									attachElementToBone(donut,elem,12,0.01,0.04,0.09,265,280,0)
									setObjectScale(donut, 0.6)
									local mx,my,mz = unpack(tables[nr].matrix)
									setCameraMatrix(elem, mx, my, mz, x, y, z)
									
									setTimer(function()
										givePlayerHunger(elem, PizzaMenues[menueID].hunger)
										local x,y,z = unpack(tables[nr].marker)
										fadeElementInterior(elem, getElementInterior(elem), x, y, z, 90, getElementDimension(elem))
										
										setTimer(function()
											setElementData(elem, "hasdonut", false)
											detachElementFromBone(donut)
											destroyElement(donut)
											destroyElement(donuttablet[elem])
											donuttablet[elem] = nil
											toggleAllControls(elem, true, true, true)
											setPedAnimation(elem)
											setElementFrozen(elem, false)
											setCameraTarget(elem, elem)
											usedplaces[getElementDimension(elem)][nr] = false
											removeElementData(elem, "donutplaceid")
											killTimer(destroytimer[source])
											
											removeEventHandler("onPlayerQuit", elem, destroyDonut)
											removeEventHandler("onPlayerWasted", elem, destroyDonut)
										end, 1000, 1)
										
									end, 10000, 1)
									
									fadeCamera(elem, true)
								end, 1000, 1)
							end
						end
					end)
					
					
					addEventHandler("onPlayerQuit", source, destroyDonut)
					addEventHandler("onPlayerWasted", source, destroyDonut)
					
				else
					notificationShow(source, "error", "Zur Zeit sind leider alle Plätze belegt.")
				end
			else
				takePlayerMoney(source, PizzaMenues[menueID].price, "Rusty Brown's Ring Donuts")
				addInventory(source, "food-"..PizzaMenues[menueID].objectID, 1)
				Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			end
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)