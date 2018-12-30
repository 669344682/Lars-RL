----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 2

local function Pizza()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(155, 375.7, -116.9, 1001.5, 180.0)
		setElementRotation(shop.ped, 0, 0, 180, "default", true)
		shop.buyMarker		= createMarker(375.7, -119.2, 1000.6, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 180, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player" and getElementData(elem, "haspizza") ~= true) then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					local pedData = {getPedSkin(shop.ped), x, y, z, rz}
					
					triggerClientEvent(elem, "pizzaStackHello", elem, pedData)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
Pizza()


local tables = {
	[1] = {
		marker = {369.456, -122.438, 1001.49},
		sitpos = {367.950, -121.422, 1002.042},
		tblpos = {368.100, -122.050, 1001.400},
		matrix = {371.050, -121.027, 1002.858},
	},
	[2] = {
		marker = {369.456, -125.392, 1001.49},
		sitpos = {367.950, -124.615, 1002.042},
		tblpos = {368.100, -125.243, 1001.400},
		matrix = {371.480, -124.088, 1002.858},
	},
	[3] = {
		marker = {369.456, -128.461, 1001.49},
		sitpos = {367.950, -127.617, 1002.042},
		tblpos = {368.100, -128.245, 1001.400},
		matrix = {371.480, -126.886, 1002.858},
	},
	[4] = {
		marker = {369.456, -131.567, 1001.49},
		sitpos = {367.950, -130.714, 1002.042},
		tblpos = {368.100, -131.342, 1001.400},
		matrix = {371.894, -129.916, 1002.999},
	},
	
	[5] = {
		marker = {378.119, -122.315, 1001.49},
		sitpos = {379.468, -121.368, 1002.042},
		tblpos = {379.799, -122.050, 1001.400},
		matrix = {376.264, -120.902, 1003.234},
	},
	[6] = {
		marker = {378.119, -125.384, 1001.49},
		sitpos = {379.468, -124.529, 1002.042},
		tblpos = {379.799, -125.099, 1001.400},
		matrix = {376.326, -123.988, 1003.029},
	},
	[7] = {
		marker = {378.119, -128.415, 1001.49},
		sitpos = {379.468, -127.551, 1002.042},
		tblpos = {379.799, -128.199, 1001.400},
		matrix = {376.685, -127.184, 1002.643},
	},
	[8] = {
		marker = {378.119, -131.613, 1001.49},
		sitpos = {379.468, -130.700, 1002.042},
		tblpos = {379.799, -131.300, 1001.400},
		matrix = {376.324, -129.969, 1002.751},
	},
}
local pizzatablet	= {}
local pizzamarker	= {}
local usedplaces	= {}
local destroytimer	= {}


function destroyPizza(player)
	local source = source
	if (getElementType(player) == "player") then
		source = player
		removeElementData(source, "haspizza")
		setPedAnimation(source)
		toggleAllControls(source, true, true, true)
		detachElementFromBone(pizzatablet[source])
	end
	destroyElement(pizzatablet[source])
	destroyElement(pizzamarker[source])
	killTimer(destroytimer[source])
	usedplaces[getElementDimension(source)][getElementData(source, "pizzaplaceid")] = false
end

addEvent("pizzaStackBuy", true)
addEventHandler("pizzaStackBuy", root, function(menueID, here)
	local PizzaMenues = settings.systems.shops.pizzastack.menues
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
					setElementData(source, "pizzaplaceid", nr)
					destroytimer[source] = setTimer(destroyPizza, 1000*300, 1, source)
					
					takePlayerMoney(source, PizzaMenues[menueID].price, "Pizza Stack")
					Franchise:addShopMoney(source, PizzaMenues[menueID].price)
					setElementData(source, "haspizza", true)
					notificationShow(source, "success", "Guten Appetit!")
					
					setPedAnimation(source, "CARRY", "crry_prtial", 50)
					pizzatablet[source] = createObject(PizzaMenues[menueID].objectID, 0, 0, 0, 0, 0, 0)
					setElementInterior(pizzatablet[source], getElementInterior(source))
					setElementDimension(pizzatablet[source], getElementDimension(source))
					attachElementToBone(pizzatablet[source],source,11,0.1,0.14,0.1,715,839,485)
					
					toggleControl(source, "jump", false)
					toggleControl(source, "sprint", false)
					toggleControl(source, "next_weapon", false)
					toggleControl(source, "previous_weapon", false)
					toggleControl(source, "crouch", false)
					toggleControl(source, "fire", false)
					setPedWeaponSlot(source, 0)
					
					local x,y,z = unpack(tables[nr].marker)
					pizzamarker[source] = createMarker(x, y, z, "corona", 1, 255, 0, 0, 255, source)
					setElementInterior(pizzamarker[source], getElementInterior(source))
					setElementDimension(pizzamarker[source], getElementDimension(source))
					
					addEventHandler("onMarkerHit", pizzamarker[source], function(elem, dim)
						if (dim == true) then
							if (getElementType(elem) == "player" and isElementVisibleTo(source, elem)) then
								
								local x,y,z = unpack(tables[nr].sitpos)
								fadeElementInterior(elem, getElementInterior(elem), x, y, z, 180, getElementDimension(elem))
								destroyElement(source)
								setElementFrozen(elem, true)
								setTimer(function()
									toggleAllControls(elem, false, false, false)
									setElementFrozen(elem, false)
									detachElementFromBone(pizzatablet[elem])
									setPedAnimation(elem)
									local x,y,z = unpack(tables[nr].tblpos)
									setElementPosition(pizzatablet[elem], x, y, z)
									setElementRotation(pizzatablet[elem], 335, 23, 73)
									setPedAnimation(elem, "food", "ff_sit_eat1", -1, true, false, false, true)
									
									local pizza = createObject(2881, 0, 0, 0)
									setElementInterior(pizza, getElementInterior(elem))
									setElementDimension(pizza, getElementDimension(elem))
									attachElementToBone(pizza,elem,12,0,0,0,0,270,0)
									
									local mx,my,mz = unpack(tables[nr].matrix)
									setCameraMatrix(elem, mx, my, mz, x, y, z)
									
									--[[
									addCommandHandler("chx", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(pizza)
										setElementBoneRotationOffset(pizza,rx+5,ry,rz)
										outputChatBox(rx..","..ry..","..rz, p)
									end)
									addCommandHandler("chy", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(pizza)
										setElementBoneRotationOffset(pizza,rx,ry+5,rz)
										outputChatBox(rx..","..ry..","..rz, p)
									end)
									addCommandHandler("chz", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(pizza)
										setElementBoneRotationOffset(pizza,rx,ry,rz+5)
										outputChatBox(rx..","..ry..","..rz, p)
									end)
									addCommandHandler("chr", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(pizza)
										setElementBoneRotationOffset(pizza,0,0,0)
									end)
									]]
									
									setTimer(function()
										givePlayerHunger(elem, PizzaMenues[menueID].hunger)
										local x,y,z = unpack(tables[nr].marker)
										fadeElementInterior(elem, getElementInterior(elem), x, y, z, 270, getElementDimension(elem))
										
										setTimer(function()
											setElementData(elem, "haspizza", false)
											detachElementFromBone(pizza)
											destroyElement(pizza)
											destroyElement(pizzatablet[elem])
											pizzatablet[elem] = nil
											toggleAllControls(elem, true, true, true)
											setPedAnimation(elem)
											setElementFrozen(elem, false)
											setCameraTarget(elem, elem)
											usedplaces[getElementDimension(elem)][nr] = false
											removeElementData(elem, "pizzaplaceid")
											killTimer(destroytimer[source])
											
											removeEventHandler("onPlayerQuit", elem, destroyPizza)
											removeEventHandler("onPlayerWasted", elem, destroyPizza)
										end, 1000, 1)
										
									end, 10000, 1)
									
									fadeCamera(elem, true)
								end, 1000, 1)
							end
						end
					end)
					
					
					addEventHandler("onPlayerQuit", source, destroyPizza)
					addEventHandler("onPlayerWasted", source, destroyPizza)
					
				else
					notificationShow(source, "error", "Zur Zeit sind leider alle Plätze belegt.")
				end
			else
				takePlayerMoney(source, PizzaMenues[menueID].price, "Pizza Stack")
				addInventory(source, "food-"..PizzaMenues[menueID].objectID, 1)
				Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			end
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)