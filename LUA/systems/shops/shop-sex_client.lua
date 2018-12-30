----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function SexShop(pedData)
	
	local Menues = settings.systems.shops.sexshop.menues
	
	local oldDim = getElementDimension(localPlayer)
	local dim = math.random(10000,65535)
	
	local skin, x, y, z, rz = unpack(pedData)
	local ped = createPed(skin, x, y, z, rz)
	setElementDimension(ped, dim)
	setElementInterior(ped, getElementInterior(localPlayer))
	
	
	setPedAnimation(localPlayer)
	setElementFrozen(localPlayer, true)
	setElementDimension(localPlayer, dim)
	setElementRotation(localPlayer, 0, 0, 0)
	local px,py,pz = getElementPosition(localPlayer)
	setCameraMatrix(px-1.3, py-1.3, pz+1, x, y, z, 0, 70)
	toggleAllControls(false, true, true)
	
	
	local currentProduct = 1
	local erx, ery, erz = 90, 0, 330
	local product = createObject(Menues[currentProduct].objectID, -105.5, -9.9, 1000.9, erx, ery, erz)
	setElementDimension(product, dim)
	setElementInterior(product, getElementInterior(localPlayer))
	
	
	changeMenu = function(nr)
		currentProduct = nr
		setElementModel(product, Menues[currentProduct].objectID)
	end
	buyMenu = function(nr)
		triggerServerEvent("sexShopBuy", localPlayer, currentProduct)
	end
	closeIt = function()
		setElementFrozen(localPlayer, false)
		setElementDimension(localPlayer, oldDim)
		setCameraTarget(localPlayer, localPlayer)
		destroyElement(product)
		destroyElement(ped)
		toggleAllControls(true, true, true, true)
		triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, true)
	end
	
	displayProductSelect("Sex Shop", Menues, changeMenu, buyMenu, closeIt, "files/images/productlist/xxx.png")
end
addEvent("sexShopHello", true)
addEventHandler("sexShopHello", root, SexShop)