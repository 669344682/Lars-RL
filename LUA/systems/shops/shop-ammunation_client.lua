----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function Ammunation()
	
	local Menues = settings.systems.shops.ammunation.menues
	
	setPedAnimation(localPlayer)
	setElementFrozen(localPlayer, true)
	setElementRotation(localPlayer, 0, 0, 180)
	toggleAllControls(false, true, true)
	
	
	local currentProduct = 1
	
	local x, y, z = unpack(Menues[1].matrix)
	local lx, ly, lz = unpack(Menues[1].position)
	setCameraMatrix(x,y,z,lx,ly,lz)
	
	local myWeapons = {}
	updateCurWeapons = function()
		for i = 1, 100 do myWeapons[i] = false end
		for i = 0, 12 do
			local weapon = getPedWeapon(localPlayer, i)
			if (weapon ~= 0) then
				myWeapons[weapon] = true
			end
		end
	end
	
	
	local displaySelect = function()end
	local canCloseBuy = true
	changeMenu = function(nr)
		currentProduct = nr
		local x1, y1, z1, lx1, ly1, lz1, fov = getCameraMatrix()
		
		local x2, y2, z2 = unpack(Menues[currentProduct].matrix)
		local lx2, ly2, lz2 = unpack(Menues[currentProduct].position)
		
		local tm = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)*300
		if (tm < 350) then tm = 350 end
		if (tm > 1250) then tm = 1250 end
		
		smoothMoveCamera(x1, y1, z1, lx1, ly1, lz1, x2, y2, z2, lx2, ly2, lz2, tm)
		freezeProductList(tm+100)
		
		canCloseBuy = false
		setTimer(function()
			canCloseBuy = true
		end, tm+100, 1)
		
		updateCurWeapons()
	end
	buyMenu = function(nr)
		if (canCloseBuy==false) then return end
		currentProduct = nr
		
		local hasMun = false
		if (Menues[currentProduct].munSize > 1) then hasMun = true end
		
		if (myWeapons[(Menues[currentProduct].weaponID)] ~= true or Menues[currentProduct].canBuyMulti == true) then
			triggerServerEvent("ammunationBuy", localPlayer, currentProduct, false)
		else
			notificationShow("error", "Du besitzt diese Waffe bereits.")
		end
		
		
		if (hasMun == true) then
			destroyProductSelect()
			
			local buyFix = function(nr)
				triggerServerEvent("ammunationBuy", localPlayer, currentProduct, true)
			end
			displayProductSelect("Ammu-Nation", {[1] = {title = "Magazin ("..Menues[currentProduct].munSize.." Schuss)", price = Menues[currentProduct].munPrice}}, function()end, buyFix, function() destroyProductSelect() setTimer(function() displaySelect() end, 50, 1) end, "files/images/productlist/ammunation.png")
		end
		setTimer(function() updateCurWeapons() end, 100, 1)
	end
	closeIt = function()
		if (canCloseBuy==false) then return end
		setElementFrozen(localPlayer, false)
		setCameraTarget(localPlayer, localPlayer)
		toggleAllControls(true, true, true, true)
		triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, false)
	end
	
	displaySelect = function()
		displayProductSelect("Ammu-Nation", Menues, changeMenu, buyMenu, closeIt, "files/images/productlist/ammunation.png")
	end
	displaySelect()
end
addEvent("ammunationHello", true)
addEventHandler("ammunationHello", root, Ammunation)