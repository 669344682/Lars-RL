----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local CompanyID = 6

local function Clothing()
	for sID, shop in pairs(Shops.companys[CompanyID].shops) do
		
		local ped = 93
		local pX, pY, pZ = 0, 0, 0
		local mX, mY, mZ = 0, 0, 0
		local i, x, y, z = 0, 0, 0, 0
		local kX, kY, kZ, krZ = 0, 0, 0, 0
		local oX, oY, oZ, orZ = 0, 0, 0, 0
		if (shop.typ == "zip") then
			pX, pY, pZ, prz = 161.4, -81.2, 1001.8, 180
			mX, mY, mZ		= 181.4, -89.7, 1001.2
			i, x, y, z		= unpack(Shops.companys[CompanyID].defaultMarkerOutPos)
			kX, kY, kZ, krZ = 181.6, -87.7, 1002, 91
			oX, oY, oZ, orZ = kX, kY, kZ, krZ
		elseif (shop.typ == "binco") then
			pX, pY, pZ, prz = 207.5, -98.7, 1005.3, 180
			mX, mY, mZ		= 218.2, -98.5, 1004.4
			i, x, y, z		= unpack(Shops.companys[CompanyID].shops[sID].markerOutPos)
			kX, kY, kZ, krZ = 217.1, -98.4, 1005.3, 91
			oX, oY, oZ, orZ = kX, kY, kZ, krZ
		elseif (shop.typ == "suburban") then
			pX, pY, pZ, prz	= 203.9, -41.7, 1001.8, 180
			mX, mY, mZ		= 214.3, -42.8, 1001.2
			i, x, y, z		= unpack(Shops.companys[CompanyID].shops[sID].markerOutPos)
			kX, kY, kZ, krZ = 214.7, -44.4, 1002, 91
			oX, oY, oZ, orZ = 212.4, -41.6, 1002, 91
		elseif (shop.typ == "victim") then
			pX, pY, pZ, prz	= 204.9, -9.1, 1001.2, 270
			mX, mY, mZ		= 206.0, -3.5, 1000.3
			i, x, y, z		= unpack(Shops.companys[CompanyID].shops[sID].markerOutPos)
			kX, kY, kZ, krZ = 208.8, -1.4, 1001.2, 180
			oX, oY, oZ, orZ = 206.2, -4.9, 1001.2, 180
		elseif (shop.typ == "prolaps") then
			pX, pY, pZ, prz	= 207.1, -127.9, 1003.5, 180
			mX, mY, mZ		= 202.0, -131.2, 1002.6
			i, x, y, z		= unpack(Shops.companys[CompanyID].shops[sID].markerOutPos)
			kX, kY, kZ, krZ = 201.1, -128.0, 1003.5, 180
			oX, oY, oZ, orZ = 204.6, -131.6, 1003.5, 180
		elseif (shop.typ == "didiersachs") then
			pX, pY, pZ, prz	= 203.9, -157.9, 1000.5, 180
			mX, mY, mZ		= 216.8, -155.5, 999.6
			i, x, y, z		= unpack(Shops.companys[CompanyID].shops[sID].markerOutPos)
			kX, kY, kZ, krZ = 215.2, -155.6, 1000.5, 90
			oX, oY, oZ, orZ = kX, kY, kZ, krZ
		end
		
		shop.ped			= createPed(ped, pX, pY, pZ, prz)
		shop.buyMarker		= createMarker(mX, mY, mZ, "cylinder", 1.0, 255, 0, 0, 255, root)
		
		setElementInterior(shop.ped, i)
		setElementDimension(shop.ped, tonumber(CompanyID..sID))
		setTimer(function() setElementFrozen(shop.ped, true) end, 500, 1)
		setElementData(shop.ped, "invulnerable", true)
		
		setElementInterior(shop.buyMarker, i)
		setElementDimension(shop.buyMarker, tonumber(CompanyID..sID))
		
		
		addEventHandler("onMarkerHit", shop.buyMarker, function(elem, dim)
			if (dim == true) then
				if (getElementType(elem) == "player") then
					
					local oldPos = {getElementDimension(elem), getElementInterior(elem), oX, oY, oZ}
					fadeElementInterior(elem, getElementInterior(elem), kX, kY, kZ, krZ, math.random(1000,99999), true)
					setTimer(function()
						triggerClientEvent(elem, "clothingHello", elem, shop.typ, oldPos)
					end, 1000, 1)
					
				end
			end
		end)
		
	end
	return true
end
Clothing()



addEvent("clothingBuy", true)
addEventHandler("clothingBuy", root, function(sid, oldPos)
	local skinData = false
	if (nr ~= false) then
		for ID, data in pairs(settings.systems.shops.clothing.skins) do
			if (data.skinID == sid) then
				skinData = data
				break
			end
		end
	end
	if (skinData ~= false) then
		
		if (getPlayerMoney(source) >= skinData.price) then
			
			setElementData(source, "SkinID", skinData.skinID)
			takePlayerMoney(source, skinData.price, "Kleidungsgeschäft")
			notificationShow(source, "success", "Vielen Dank für deinen Einkauf!")
			
			Franchise:addShopMoney(source, skinData.price)
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
	end
	
	setElementFrozen(source, false)
	local dim, i, x, y, z = unpack(oldPos)
	fadeElementInterior(source, i, x, y, z, 0, dim)
	
	setElementModel(source, getElementData(source, "SkinID"))
end)