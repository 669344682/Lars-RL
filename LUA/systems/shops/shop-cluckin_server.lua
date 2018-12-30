----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local ShopID = 5

local function CluckinBell()
	for sID, shop in pairs(Shops.companys[ShopID].shops) do
		
		shop.ped			= createPed(167, 369.35, -4.15, 1001.9, 180)
		setElementRotation(shop.ped, 0, 0, 180, "default", true)
		shop.buyMarker		= createMarker(369.35, -6.2, 1001.0, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		local i, x, y, z	= unpack(Shops.companys[ShopID].defaultMarkerOutPos)
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(ShopID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) setElementRotation(shop.ped, 0, 0, 180, "default", true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(ShopID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player" and getElementData(elem, "haschicken") ~= true) then
					
					local x,y,z = getElementPosition(shop.ped)
					local _,_,rz = getElementRotation(shop.ped)
					local pedData = {getPedSkin(shop.ped), x, y, z, rz}
					
					triggerClientEvent(elem, "cluckinBellHello", elem, pedData)
					toggleGhostMode(elem, true)
					
				end
			end
		end)
		
	end
	return true
end
CluckinBell()


local tables = {
	[1] = {
		marker = {369.508, -9.119, 1001.851},
		sitpos = {368.914, -10.460, 1002.385},
		tblpos = {369.250, -10.350, 1001.799},
		matrix = {368.333, -8.633, 1003.050},
	},
	[2] = {
		marker = {372.155, -9.119, 1001.851},
		sitpos = {371.493, -10.460, 1002.385},
		tblpos = {371.990, -10.350, 1001.799},
		matrix = {370.913, -8.386, 1003.435},
	},
	[3] = {
		marker = {374.910, -9.119, 1001.851},
		sitpos = {374.166, -10.460, 1002.385},
		tblpos = {374.650, -10.350, 1001.799},
		matrix = {373.713, -8.541, 1003.381},
	},
	[4] = {
		marker = {377.553, -9.119, 1001.851},
		sitpos = {376.868, -10.460, 1002.385},
		tblpos = {377.400, -10.350, 1001.799},
		matrix = {376.202, -8.280, 1003.140},
	},
	[5] = {
		marker = {380.288, -9.119, 1001.851},
		sitpos = {379.595, -10.460, 1002.385},
		tblpos = {380.100, -10.350, 1001.799},
		matrix = {379.077, -8.331, 1003.089},
	},
	
	[6] = {
		marker = {380.199, -8.235, 1001.851},
		sitpos = {379.547, -6.819, 1002.385},
		tblpos = {380.000, -6.599, 1001.799},
		matrix = {379.125, -9.088, 1003.383},
	},
}
local chickentablet	= {}
local chickenmarker	= {}
local usedplaces	= {}
local destroytimer	= {}


function destroyChicken(player)
	local source = source
	if (getElementType(player) == "player") then
		source = player
		removeElementData(source, "haschicken")
		setPedAnimation(source)
		toggleAllControls(source, true, true, true)
		detachElementFromBone(chickentablet[source])
	end
	destroyElement(chickentablet[source])
	destroyElement(chickenmarker[source])
	killTimer(destroytimer[source])
	usedplaces[getElementDimension(source)][getElementData(source, "chickenplaceid")] = false
end

addEvent("cluckinBellBuy", true)
addEventHandler("cluckinBellBuy", root, function(menueID, here)
	local PizzaMenues = settings.systems.shops.cluckinbell.menues
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
					setElementData(source, "chickenplaceid", nr)
					destroytimer[source] = setTimer(destroyChicken, 1000*300, 1, source)
					
					takePlayerMoney(source, PizzaMenues[menueID].price, "Cluckin’ Bell")
					Franchise:addShopMoney(source, PizzaMenues[menueID].price)
					setElementData(source, "haschicken", true)
					notificationShow(source, "success", "Guten Appetit!")
					
					setPedAnimation(source, "CARRY", "crry_prtial", 50)
					chickentablet[source] = createObject(PizzaMenues[menueID].objectID, 0, 0, 0, 0, 0, 0)
					setElementInterior(chickentablet[source], getElementInterior(source))
					setElementDimension(chickentablet[source], getElementDimension(source))
					attachElementToBone(chickentablet[source],source,11,0.1,0.14,0.1,715,839,485)
					
					toggleControl(source, "jump", false)
					toggleControl(source, "sprint", false)
					toggleControl(source, "next_weapon", false)
					toggleControl(source, "previous_weapon", false)
					toggleControl(source, "crouch", false)
					toggleControl(source, "fire", false)
					setPedWeaponSlot(source, 0)
					
					local x,y,z = unpack(tables[nr].marker)
					chickenmarker[source] = createMarker(x, y, z, "corona", 1, 255, 0, 0, 255, source)
					setElementInterior(chickenmarker[source], getElementInterior(source))
					setElementDimension(chickenmarker[source], getElementDimension(source))
					
					addEventHandler("onMarkerHit", chickenmarker[source], function(elem, dim)
						if (dim == true) then
							if (getElementType(elem) == "player" and isElementVisibleTo(source, elem)) then
								
								local x,y,z = unpack(tables[nr].sitpos)
								fadeElementInterior(elem, getElementInterior(elem), x, y, z, 270, getElementDimension(elem))
								destroyElement(source)
								setElementFrozen(elem, true)
								setTimer(function()
									toggleAllControls(elem, false, false, false)
									setElementFrozen(elem, false)
									detachElementFromBone(chickentablet[elem])
									setPedAnimation(elem)
									local x,y,z = unpack(tables[nr].tblpos)
									setElementPosition(chickentablet[elem], x, y, z)
									setElementRotation(chickentablet[elem], 335, 23, 162)
									setPedAnimation(elem, "food", "ff_sit_eat1", -1, true, false, false, true)
									
									local chicken = createObject(2769, 0, 0, 0)
									setElementInterior(chicken, getElementInterior(elem))
									setElementDimension(chicken, getElementDimension(elem))
									attachElementToBone(chicken,elem,12,0.03,0.06,0.1,0,0,0)
									local mx,my,mz = unpack(tables[nr].matrix)
									setCameraMatrix(elem, mx, my, mz, x, y, z)
									
									
									--[[addCommandHandler("chx", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(chicken)
										setElementBonePositionOffset(chicken,x+0.01,y,z)
										outputChatBox(x..","..y..","..z, p)
									end)
									addCommandHandler("chy", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(chicken)
										setElementBonePositionOffset(chicken,x,y+0.01,z)
										outputChatBox(x..","..y..","..z, p)
									end)
									addCommandHandler("chz", function(p)
										local _,_,x,y,z,rx,ry,rz = getElementBoneAttachmentDetails(chicken)
										setElementBonePositionOffset(chicken,x,y,z+0.01)
										outputChatBox(x..","..y..","..z, p)
									end)
									addCommandHandler("chr", function(p)
										setElementBonePositionOffset(chicken,0.02,0.06)
									end)]]
									
									
									setTimer(function()
										givePlayerHunger(elem, PizzaMenues[menueID].hunger)
										local x,y,z = unpack(tables[nr].marker)
										fadeElementInterior(elem, getElementInterior(elem), x, y, z, 0, getElementDimension(elem))
										
										setTimer(function()
											setElementData(elem, "haschicken", false)
											detachElementFromBone(chicken)
											destroyElement(chicken)
											destroyElement(chickentablet[elem])
											chickentablet[elem] = nil
											toggleAllControls(elem, true, true, true)
											setPedAnimation(elem)
											setElementFrozen(elem, false)
											setCameraTarget(elem, elem)
											usedplaces[getElementDimension(elem)][nr] = false
											removeElementData(elem, "chickenplaceid")
											killTimer(destroytimer[source])
											
											removeEventHandler("onPlayerQuit", elem, destroyChicken)
											removeEventHandler("onPlayerWasted", elem, destroyChicken)
										end, 1000, 1)
										
									end, 10000, 1)
									
									fadeCamera(elem, true)
								end, 1000, 1)
							end
						end
					end)
					
					
					addEventHandler("onPlayerQuit", source, destroyChicken)
					addEventHandler("onPlayerWasted", source, destroyChicken)
					
				else
					notificationShow(source, "error", "Zur Zeit sind leider alle Plätze belegt.")
				end
			else
				takePlayerMoney(source, PizzaMenues[menueID].price, "Cluckin’ Bell")
				addInventory(source, "food-"..PizzaMenues[menueID].objectID, 1)
				Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			end
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)