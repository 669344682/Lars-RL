----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function Clothing(shopType, oldPos)
	
	local currentSkin = nil
	local Skins = {}
	local i = 1
	for ID, data in pairs(settings.systems.shops.clothing.skins) do
		if (data.shop == "all" or data.shop == shopType) then
			
			if (currentSkin == nil) then currentSkin = i end
			Skins[i] = data
			
			i = i + 1
		end
	end
	
	local oldSkin = getElementModel(localPlayer)
	setElementModel(localPlayer, Skins[currentSkin].skinID)
	
	local oldDim = getElementDimension(localPlayer)
	local dim = math.random(10000,65535)
	setPedAnimation(localPlayer)
	setElementDimension(localPlayer, dim)
	
	local px,py,pz = getElementPosition(localPlayer)
	local _, _, rz = getElementRotation(localPlayer)
	local fx,fy,fz = px, py, pz
	
	if (rz >= 175 and rz <= 185) then
		fx,fy,fz = fx+.5, fy-2.5, fz+1
	elseif (rz >= 85 and rz <= 95) then
		fx,fy,fz = fx-2.5, fy-.5, fz+1
	end
	setCameraMatrix(fx, fy, fz, px, py, pz, 0, 70)
	toggleAllControls(false, true, true, true)
	
	local rotTimer = setTimer(function()
		local _,_,rrz = getElementRotation(localPlayer)
		setElementRotation(localPlayer, 0, 0, rrz+1.2, "default", true)
	end, 50, 0)
	
	local closed = false
	
	changeMenu = function(nr)
		if (closed) then return end
		currentSkin = nr
		setElementModel(localPlayer, Skins[currentSkin].skinID)
	end
	local buyCloseFix = function(buy)
		if (closed) then return end
		
		closed = true
		destroyProductSelect()
		fadeCamera(false, 1, 0, 0, 0)
		setTimer(function()
			killTimer(rotTimer)
			setElementDimension(localPlayer, oldDim)
			setCameraTarget(localPlayer, localPlayer)
			toggleAllControls(true, true, true, true)
			setElementModel(localPlayer, oldSkin)
			
			local fix = false
			if (buy == true) then fix = Skins[currentSkin].skinID end
			triggerServerEvent("clothingBuy", localPlayer, fix, oldPos)
		end, 1000, 1)
	end
	buyMenu = function(nr)
		if (closed) then return end
		currentSkin = nr
		
		buyCloseFix(true)
	end
	closeIt = function()
		if (closed) then return end
		buyCloseFix(false)
	end
	
	local title = ""
	if (shopType == "zip") then
		title = "Z.I.P"
		logo = "files/images/productlist/zip.png"
	elseif (shopType == "binco") then
		title = "Binco"
		logo = "files/images/productlist/binco.png"
	elseif (shopType == "suburban") then
		title = "Sub Urban"
		logo = "files/images/productlist/suburban.png"
	elseif (shopType == "victim") then
		title = "Victim"
		logo = "files/images/productlist/victim.png"
	elseif (shopType == "prolaps") then
		title = "ProLaps"
		logo = "files/images/productlist/prolaps.png"
	elseif (shopType == "didiersachs") then
		title = "Didier Sachs"
		logo = "files/images/productlist/didiersachs.png"
	end
	
	displayProductSelect(title, Skins, changeMenu, buyMenu, closeIt, logo)
end
addEvent("clothingHello", true)
addEventHandler("clothingHello", root, Clothing)