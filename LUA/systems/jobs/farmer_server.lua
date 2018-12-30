----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local JobID					= 6
local pricePerFlowerFoot	= 20
local pricePerDungMark	= 35
local pricePerHarvestMark= 50
local maxPlayerFoot		= 15
local maxPlayerDung		= 10
local maxPlayerHarvest	= 10

local curFoot					= {}
local curDung				= {}
local curHarvest				= {}

local FootFlowers = {
	{
		pos = {19.2, 62.9, 2.1},
	},
	{
		pos = {18, 59.3, 2.1},
	},
	{
		pos = {16, 54.6, 2.1},
	},
	{
		pos = {14.8, 50.5, 2.1},
	},
	{
		pos = {13.7, 46.5, 2.1},
	},
	{
		pos = {12.2, 42.1, 2.1},
	},
	{
		pos = {10, 36.5, 2.1},
	},
	{
		pos = {13, 33.2, 2.1},
	},
	{
		pos = {14.1, 37.4, 2.1},
	},
	{
		pos = {16.1, 42.7, 2.1},
	},
	{
		pos = {18.4, 49, 2.1},
	},
	{
		pos = {19.8, 53.7, 2.1},
	},
	{
		pos = {22.4, 60.3, 2.1},
	},
	{
		pos = {26.8, 61.9, 2.1},
	},
	{
		pos = {24.8, 57, 2.1},
	},
	{
		pos = {18, 37.5, 2.1},
	},
	{
		pos = {23.40039, 52.59961, 2.1},
	},
	{
		pos = {21.40039, 47.59961, 2.1},
	},
	{
		pos = {19.7002, 42.29981, 2.1},
	},
	{
		pos = {20.4, 34, 2.1},
	},
	{
		pos = {15.7002, 29.7002, 2.1},
	},
	{
		pos = {23, 41, 2.1},
	},
	{
		pos = {17.90039, 27.2002, 2.1},
	},
	{
		pos = {29.3, 59.7, 2.1},
	},
	{
		pos = {25.40039, 48.09961, 2.1},
	},
	{
		pos = {27.40039, 53.5, 2.1},
	},
	{
		pos = {28.5, 47.9, 2.1},
	},
	{
		pos = {33, 59.59961, 2.1},
	},
	{
		pos = {30.90039, 54.59961, 2.1},
	},
	{
		pos = {21.3, 28.1, 2.1},
	},
	{
		pos = {26.3, 40.8, 2.1},
	},
	{
		pos = {23.40039, 33.09961, 2.1},
	},
	{
		pos = {19.79981, 22.5, 2.1},
	},
	{
		pos = {25.9, 30.3, 2.1},
	},
	{
		pos = {21.40039, 17.40039, 2.1},
	},
	{
		pos = {23.29981, 22.90039, 2.1},
	},
	{
		pos = {29.1, 38.5, 2.1},
	},
	{
		pos = {31.8, 46.5, 2.1},
	},
	{
		pos = {24.3, 14, 2.1},
	},
	{
		pos = {35.29981, 56.2002, 2.1},
	},
	{
		pos = {26.4, 19.6, 2.1},
	},
	{
		pos = {36.7, 48.1, 2.1},
	},
	{
		pos = {28.40039, 25.7002, 2.1},
	},
	{
		pos = {31.09961, 32.90039, 2.1},
	},
	{
		pos = {33.4, 40.1, 2.1},
	},
	{
		pos = {38.7, 55.3, 1.8},
	},
	{
		pos = {26.7, 10.2, 2.1},
	},
	{
		pos = {29.9, 19.3, 2.1},
	},
	{
		pos = {32.5, 26.7, 2.1},
	},
	{
		pos = {34.7, 33.5, 2.1},
	},
	{
		pos = {37.2, 40.3, 2.1},
	},
	{
		pos = {41, 51.4, 1.5},
	},
	{
		pos = {29.2, 8.1, 2.1},
	},
	{
		pos = {31.9, 14.4, 2.1},
	},
	{
		pos = {33.7, 20.2, 2.1},
	},
	{
		pos = {41, 40.1, 1.6},
	},
	{
		pos = {36.29981, 26.7002, 2.1},
	},
	{
		pos = {38.09961, 32, 2},
	},
	{
		pos = {44.2, 48.3, 1.2},
	},
	{
		pos = {34.3, 11.7, 2.1},
	},
	{
		pos = {31.90039, 5.2002, 2.1},
	},
	{
		pos = {45.4, 43.4, 1.1},
	},
	{
		pos = {36.6, 18.2, 2.1},
	},
	{
		pos = {39.4, 26.6, 1.9},
	},
	{
		pos = {42.5, 34.5, 1.5},
	},
	{
		pos = {50.4, 45.2, 0.5},
	},
	{
		pos = {47.79981, 48.59961, 0.8},
	},
	{
		pos = {45, 30.3, 1.3},
	},
	{
		pos = {48.29981, 39.29981, 0.8},
	},
	{
		pos = {41.8, 21.7, 1.7},
	},
	{
		pos = {37.2, -2, 2.1},
	},
	{
		pos = {38.5, 13.09961, 2.1},
	},
	{
		pos = {34.5, 2.2002, 2.1},
	},
	{
		pos = {42, 11.1, 1.8},
	},
	{
		pos = {39.2002, 3.40039, 2.1},
	},
	{
		pos = {45.3, 20, 1.3},
	},
	{
		pos = {52.7, 29.5, 0.4},
	},
	{
		pos = {48.2002, 27.7002, 0.9},
	},
	{
		pos = {52.79981, 40.2002, 0.3},
	},
	{
		pos = {56.09961, 39.09961, -0.1},
	},
	{
		pos = {48.4, 18.2, 1},
	},
	{
		pos = {41.5, 0.3, 1.9},
	},
	{
		pos = {44.79981, 9.2998, 1.5},
	},
	{
		pos = {49.5, 12, 1},
	},
	{
		pos = {43.09961, -5.7998, 1.9},
	},
	{
		pos = {46.29981, 1.90039, 1.5},
	},
	{
		pos = {53, 20, 0.6},
	},
	{
		pos = {56, 28.1, 0.1},
	},
	{
		pos = {59.6, 39.1, -0.4},
	},
	{
		pos = {57, 22.8, 0.2},
	},
	{
		pos = {62.79981, 37.5, -0.4},
	},
	{
		pos = {59.7002, 29.40039, -0.1},
	},
	{
		pos = {51.6, 8.1, 0.9},
	},
	{
		pos = {54.79981, 16.2002, 0.5},
	},
	{
		pos = {45.4, -8.3, 1.8},
	},
	{
		pos = {49.59961, 0.59961, 1.2},
	},
	{
		pos = {47.6, -12.9, 1.5},
	},
	{
		pos = {57.5, 13.5, 0.4},
	},
	{
		pos = {50.40039, -6.09961, 1.3},
	},
	{
		pos = {54.79981, 5.59961, 0.8},
	},
	{
		pos = {65.7, 36.1, -0.4},
	},
	{
		pos = {59.79981, 18.90039, 0.1},
	},
	{
		pos = {62.29981, 26.5, -0.3},
	},
	{
		pos = {68.7, 33, -0.4},
	},
	{
		pos = {65.1, 23.6, -0.4},
	},
	{
		pos = {62.4, 15.7, 0},
	},
	{
		pos = {58.9, 7.7, 0.4},
	},
	{
		pos = {54, -7.3, 1.1},
	},
	{
		pos = {56.79981, -0.09961, 0.7},
	},
	{
		pos = {55.9, -13, 1},
	},
	{
		pos = {50.59961, -16.90039, 1.2},
	},
	{
		pos = {53.79981, -18.5, 0.9},
	},
	{
		pos = {58.7, -6.2, 0.7},
	},
	{
		pos = {64.8, 11.6, -0.1},
	},
	{
		pos = {61.5, 2.40039, 0.3},
	},
	{
		pos = {68.5, 21.3, -0.4},
	},
	{
		pos = {74.7, 27.6, -0.4},
	},
	{
		pos = {71.90039, 30.7002, -0.4},
	},
	{
		pos = {67.4, 7.6, -0.2},
	},
	{
		pos = {71.40039, 18.40039, -0.4},
	},
	{
		pos = {62.4, -5, 0.4},
	},
	{
		pos = {59.5, -13.3, 0.8},
	},
	{
		pos = {60.2, -20.5, 0.5},
	},
	{
		pos = {56.09961, -22.2998, 0.6},
	},
	{
		pos = {57.5, -27.7998, 0.4},
	},
	{
		pos = {63, -13.3, 0.5},
	},
	{
		pos = {74.9, 19, -0.4},
	},
	{
		pos = {66.29981, -3.7002, 0.1},
	},
	{
		pos = {69.79981, 4.90039, -0.3},
	},
	{
		pos = {72.5, 12.2002, -0.4},
	},
	{
		pos = {79.8, 20.6, -0.4},
	},
	{
		pos = {77.90039, 27.2002, -0.4},
	},
	{
		pos = {73.9, 6.2, -0.4},
	},
	{
		pos = {75.79981, 12.29981, -0.4},
	},
	{
		pos = {68, -9, 0.1},
	},
	{
		pos = {71, -1.2998, -0.3},
	},
	{
		pos = {65.2, -16.5, 0.3},
	},
	{
		pos = {62.7, -24.1, 0.2},
	},
	{
		pos = {63.4, -33.7, -0.2},
	},
	{
		pos = {60.09961, -31.90039, 0.1},
	},
	{
		pos = {71.7, -10.6, -0.1},
	},
	{
		pos = {66.59961, -25.40039, -0.1},
	},
	{
		pos = {69.59961, -18, 0},
	},
	{
		pos = {74.4, -4.1, -0.4},
	},
	{
		pos = {77.2, 4.8, -0.4},
	},
	{
		pos = {72, -20, -0.2},
	},
	{
		pos = {66.09961, -37.70019, -0.4},
	},
	{
		pos = {68.7, -29.7, -0.4},
	},
	{
		pos = {74.2, -14.5, -0.2},
	},
	{
		pos = {72, -30, -0.4},
	},
	{
		pos = {77.09961, -5.7998, -0.4},
	},
	{
		pos = {75.29981, -21.20019, -0.4},
	},
	{
		pos = {71.2, -42.5, -0.4},
	},
	{
		pos = {69.09961, -38.5, -0.4},
	},
}



local DungMarker = {
	{
		pos = {-34.8, -99.6, 2},
	},
	{
		pos = {-29, -59.5, 1.5},
	},
	{
		pos = {-9.3, -10.7, 2},
	},
	{
		pos = {-12.5, -98.9, 2},
	},
	{
		pos = {-8.6, -56.8, 1.1},
	},
	{
		pos = {-1.6, -83, 2},
	},
	{
		pos = {16.7, -76.2, 1.1},
	},
	{
		pos = {25.9, -106.9, -0.5},
	},
	{
		pos = {34.5, -75.8, -0.1},
	},
	{
		pos = {42.9, -101.8, -0.5},
	},
	{
		pos = {-22.5, -80.4, 2},
	},
	{
		pos = {10.5, -54.7, 2},
	},
	{
		pos = {6.9, -98.1, 0.9},
	},
	{
		pos = {29.5, -56.2, 1.3},
	},
	{
		pos = {14.5, -31.9, 2},
	},
	{
		pos = {-8.9, -112.8, 1.2},
	},
	{
		pos = {9.6, -116.7, -0.5},
	},
	{
		pos = {25.6, -90.7, 0},
	},
	{
		pos = {-20, -33.4, 2},
	},
	{
		pos = {-2.8, -34.8, 2},
	},
}

local HarvestMarker = {
	{
		pos = {-136.3, 52.7, 2},
	},
	{
		pos = {-185.5, -75.7, 2},
	},
	{
		pos = {-225.2, 91.5, 1.2},
	},
	{
		pos = {-263.70001, -50.9, 2},
	},
	{
		pos = {-226.89999, -66.5, 2},
	},
	{
		pos = {-256.79999, 3.1, 1.2},
	},
	{
		pos = {-245.60001, 42.6, 1.1},
	},
	{
		pos = {-183.89999, 65.4, 2},
	},
	{
		pos = {-153.8, 7.2, 2},
	},
	{
		pos = {-167.10001, -33.2, 2},
	},
	{
		pos = {-213, 59.5, 2},
	},
	{
		pos = {-165.60001, 38.9, 1.5},
	},
	{
		pos = {-198.2, 25.4, 2},
	},
	{
		pos = {-224.60001, 14, 2},
	},
	{
		pos = {-182.8, -0.9, 2},
	},
	{
		pos = {-211.8, -17.1, 2},
	},
	{
		pos = {-237.5, -30.3, 2},
	},
	{
		pos = {-198.89999, -42.7, 2},
	},
}


-- Level 1
local function spawnFlowers()
	for i, flow in ipairs(FootFlowers) do
		
		local x, y, z		= unpack(flow.pos)
		if (not flow.obj or not isElement(flow.obj)) then
			FootFlowers[i].obj = createObject(682, x, y, z)
			setElementDoubleSided(FootFlowers[i].obj, true)
			setElementData(FootFlowers[i].obj, "footFlower", true)
			setElementData(FootFlowers[i].obj, "footFlowerID", i)
		end
	end
end
spawnFlowers()
setTimer(function()
	spawnFlowers()
end, 5*60000, 0)
--addCommandHandler("flow", spawnFlowers)


local function onFootFlowerHit(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "object") then
			if (getElementData(elem, "footFlower")) then
				local pName = getElementData(source, "owner")
				if (pName) then
					local player = getPlayerFromName(pName)
					if (player) then
						
						local id				= getElementData(elem, "footFlowerID")
						if (FootFlowers[id].obj and isElement(FootFlowers[id].obj)) then
							local fX, fY, fZ	= getElementPosition(FootFlowers[id].obj)
							local pX, pY, pZ = getElementPosition(player)
							local rot = findRotation(pX, pY, fX, fY)
							setElementRotation(player, 0, 0, rot)
							
							setElementFrozen(player, true)
							setPedAnimation(player, "BOMBER", "bom_plant", 2500, false, false, false, true)
							toggleAllControls(player, false)
							
							setTimer(function()
								vanishElement(FootFlowers[id].obj)
								FootFlowers[id].obj = nil
							end, 150, 1)
							
							setTimer(function()
								setPedAnimation(player)
								setElementFrozen(player, false)
								toggleAllControls(player, true)
								toggleControl(player, "sprint", false)
								
								Jobs:AddEarnings(player, JobID, pricePerFlowerFoot)
								Jobs:AddLevel(player, JobID, 1)
								
							end, 2500, 1)
							
						end
					end
				end
			end
		end
	end
end


-- Level 2
for i, dung in ipairs(DungMarker) do
	local x, y, z		= unpack(dung.pos)
	if (not dung.marker or not isElement(dung.marker)) then
		DungMarker[i].marker = createMarker(x, y, z, "cylinder", 4, 0, 255, 0, 255)
		setElementVisibleTo(DungMarker[i].marker, root, false)
	end
end

local function onDunkMarkHit(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "player") then
			if (isElementVisibleTo(source, elem)) then
				local v = getPedOccupiedVehicle(elem)
				if (v and getElementModel(v) == 531) then
					local pName = getPlayerName(elem)
					if (curDung[pName]) then
						
						Jobs:AddEarnings(elem, JobID, pricePerDungMark)
						Jobs:AddLevel(elem, JobID, 1)
						
						setElementVisibleTo(source, elem, false)
						setElementVisibleTo(DungMarker[math.random(1,#DungMarker)].marker, elem, true)
						
					end
				end
			end
		end
	end
end
addEventHandler("onMarkerHit", root, onDunkMarkHit)


-- Level 3
for i, harv in ipairs(HarvestMarker) do
	local x, y, z		= unpack(harv.pos)
	if (not harv.marker or not isElement(harv.marker)) then
		HarvestMarker[i].marker = createMarker(x, y, z, "cylinder", 6, 0, 255, 0, 255)
		setElementVisibleTo(HarvestMarker[i].marker, root, false)
	end
end

local function onHarvestMarkHit(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "player") then
			if (isElementVisibleTo(source, elem)) then
				local v = getPedOccupiedVehicle(elem)
				if (v and getElementModel(v) == 532) then
					local pName = getPlayerName(elem)
					if (curHarvest[pName]) then
						
						Jobs:AddEarnings(elem, JobID, pricePerHarvestMark)
						Jobs:AddLevel(elem, JobID, 1)
						
						setElementVisibleTo(source, elem, false)
						setElementVisibleTo(HarvestMarker[math.random(1,#HarvestMarker)].marker, elem, true)
						
					end
				end
			end
		end
	end
end
addEventHandler("onMarkerHit", root, onHarvestMarkHit)



_G["FarmerStart"] = function(player, level)
	local state = false
		
	if (level == 1) then
		
		if (#curFoot < maxPlayerFoot) then
			
			local pName = getPlayerName(player)
			
			curFoot[pName] = {}
			curFoot[pName].col = createColSphere(0, 0, 0, 1.25)
			setElementData(curFoot[pName].col, "owner", pName)
			attachElements(curFoot[pName].col, player, 0, 0, -.5)
			
			addEventHandler("onColShapeHit", curFoot[pName].col, onFootFlowerHit)
			
			fadeElementInterior(player, 0, -2.5, 35.1, 3.2, 275, 0, true)
			setTimer(function()
				infoShow(player, "info", "Ernte die Pflanzen auf dem Feld. Pro Pflanze erhälst Du "..pricePerFlowerFoot.." $.")
			end, 1000, 1)
			
			toggleControl(player, "sprint", false)
			
			state = true
			
		end
		
	elseif (level == 2) then
		
		if (#curDung < maxPlayerDung) then
			
			local pName = getPlayerName(player)
			
			curDung[pName] = {}
			curDung[pName].tractor = createVehicle(531, -1.5, 18.2, 3.2, 0, 0, 220)
			setElementData(curDung[pName].tractor, "jobOwner", pName)
			
			curDung[pName].trailer = createVehicle(611, 0, 0, 0)
			--attachTrailerToVehicle(curDung[pName].tractor, curDung[pName].trailer)
			attachElements(curDung[pName].trailer, curDung[pName].tractor, 0, -3.5, -.3)
			
			setElementVisibleTo(DungMarker[1].marker, player, true)
			
			fadeElementInterior(player, 0,  -1.5, 18.2, 3.2, 0, 0, true)
			setTimer(function()
				warpPedIntoVehicle(player, curDung[pName].tractor)
				infoShow(player, "info", "Dünge das Feld. Pro Marker erhälst Du "..pricePerDungMark.." $.")
			end, 1000, 1)
			
			state = true
		end
	elseif (level == 3) then
		
		if (#curHarvest < maxPlayerHarvest) then
			
			local pName = getPlayerName(player)
			
			curHarvest[pName] = {}
			curHarvest[pName].tractor = createVehicle(532, -113.4, 71.9, 4.8, 0, 0, 85)
			setElementData(curHarvest[pName].tractor, "jobOwner", pName)
			
			setElementVisibleTo(HarvestMarker[1].marker, player, true)
			
			fadeElementInterior(player, 0, -113.4, 71.9, 4.8, 0, 0, true)
			setTimer(function()
				warpPedIntoVehicle(player, curHarvest[pName].tractor)
				infoShow(player, "info", "Ernte die Pflanzen auf dem Feld. Pro Pflanze erhälst Du "..pricePerHarvestMark.." $.")
			end, 1000, 1)
			
			state = true
			
		end
		
	end
	
	return state
end


_G["FarmerEnd"] = function(player)
	local pName = getPlayerName(player)
	
	if (curFoot[pName]) then
		removeEventHandler("onColShapeHit", curFoot[pName].col, onFootFlowerHit)
		destroyElement(curFoot[pName].col)
		fadeElementInterior(player, 0, -55.1, 79.4, 3.2, 275, 0, true)
		curFoot[pName] = nil
		
		toggleControl(player, "sprint", true)
	end
	
	if (curDung[pName]) then
		destroyElement(curDung[pName].tractor)
		destroyElement(curDung[pName].trailer)
		fadeElementInterior(player, 0, -55.1, 79.4, 3.2, 275, 0, true)
		curDung[pName] = nil
		
		for k, v in ipairs(DungMarker) do
			setElementVisibleTo(v.marker, player, false)
		end
		
	end
	
	if (curHarvest[pName]) then
		destroyElement(curHarvest[pName].tractor)
		fadeElementInterior(player, 0, -55.1, 79.4, 3.2, 275, 0, true)
		curHarvest[pName] = nil
		
		for k, v in ipairs(HarvestMarker) do
			setElementVisibleTo(v.marker, player, false)
		end
		
	end
	
end