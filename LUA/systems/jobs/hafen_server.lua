----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local JobID						= 3

local pricePerContainer		= 75

local LandContainerPlaces	= {
	{
		pos = {2800, -2385, 14.0},
	},
	{
		pos = {2800, -2385, 16.7},
	},
	{
		pos = {2800, -2389, 14.0},
	},
	{
		pos = {2800, -2389, 16.7},
	},
	{
		pos = {2800, -2393, 14.0},
	},
	{
		pos = {2800, -2393, 16.7},
	},
	{
		pos = {2800, -2397, 14.0},
	},
	{
		pos = {2800, -2397, 16.7},
	},
	{
		pos = {2800, -2401, 14.0},
	},
	{
		pos = {2800, -2401, 16.7},
	},
	{
		pos = {2800, -2405, 14.0},
	},
	{
		pos = {2800, -2405, 16.7},
	},
	{
		pos = {2800, -2409, 14.0},
	},
	{
		pos = {2800, -2409, 16.7},
	},
	{
		pos = {2800, -2413, 14.0},
	},
	{
		pos = {2800, -2413, 16.7},
	},
	{
		pos = {2800, -2417, 14.0},
	},
	{
		pos = {2800, -2417, 16.7},
	},
	{
		pos = {2800, -2421, 14.0},
	},
	{
		pos = {2800, -2421, 16.7},
	},
	{
		pos = {2800, -2425, 14.0},
	},
	{
		pos = {2800, -2425, 16.7},
	},
	{
		pos = {2800, -2429, 14.0},
	},
	{
		pos = {2800, -2429, 16.7},
	},
	{
		pos = {2800, -2433, 14.0},
	},
	{
		pos = {2800, -2433, 16.7},
	},
	{
		pos = {2800, -2437, 14.0},
	},
	{
		pos = {2800, -2437, 16.7},
	},
	{
		pos = {2800, -2441, 14.0},
	},
	{
		pos = {2800, -2441, 16.7},
	},
	{
		pos = {2800, -2445, 14.0},
	},
	{
		pos = {2800, -2445, 16.7},
	},
	{
		pos = {2800, -2449, 14.0},
	},
	{
		pos = {2800, -2449, 16.7},
	},
	{
		pos = {2800, -2453, 14.0},
	},
	{
		pos = {2800, -2453, 16.7},
	},
	{
		pos = {2800, -2457, 14.0},
	},
	{
		pos = {2800, -2457, 16.7},
	},
	{
		pos = {2800, -2461, 14.0},
	},
	{
		pos = {2800, -2461, 16.7},
	},
	{
		pos = {2800, -2465, 14.0},
	},
	{
		pos = {2800, -2465, 16.7},
	},
	{
		pos = {2800, -2469, 14.0},
	},
	{
		pos = {2800, -2469, 16.7},
	},
	{
		pos = {2800, -2473, 14.0},
	},
	{
		pos = {2800, -2473, 16.7},
	},
	{
		pos = {2800, -2477, 14.0},
	},
	{
		pos = {2800, -2477, 16.7},
	},
	{
		pos = {2800, -2481, 14.0},
	},
	{
		pos = {2800, -2481, 16.7},
	},
	{
		pos = {2800, -2485, 14.0},
	},
	{
		pos = {2800, -2485, 16.7},
	},
	{
		pos = {2800, -2489, 14.0},
	},
	{
		pos = {2800, -2489, 16.7},
	},
	{
		pos = {2800, -2493, 14.0},
	},
	{
		pos = {2800, -2493, 16.7},
	},
	{
		pos = {2800, -2497, 14.0},
	},
	{
		pos = {2800, -2497, 16.7},
	},
	{
		pos = {2800, -2501, 14.0},
	},
	{
		pos = {2800, -2501, 16.7},
	},
	{
		pos = {2800, -2505, 14.0},
	},
	{
		pos = {2800, -2505, 16.7},
	},
	{
		pos = {2800, -2509, 14.0},
	},
	{
		pos = {2800, -2509, 16.7},
	},
}

local ShipContainerPlaces	= {
	-- Reihe 1, Links
	{
		pos = {2825.5, -2384, 12.4},
	},
	{
		pos = {2825.5, -2388, 12.4},
	},
	{
		pos = {2825.5, -2392, 12.4},
	},
	{
		pos = {2825.5, -2396, 12.4},
	},
	{
		pos = {2825.5, -2400, 12.4},
	},
	{
		pos = {2825.5, -2404, 12.4},
	},
	{
		pos = {2825.5, -2408, 12.4},
	},
	{
		pos = {2825.5, -2412, 12.4},
	},
	{
		pos = {2825.5, -2416, 12.4},
	},
	{
		pos = {2825.5, -2420, 12.4},
	},
	{
		pos = {2825.5, -2424, 12.4},
	},
	{
		pos = {2825.5, -2428, 12.4},
	},
	{
		pos = {2825.5, -2432, 12.4},
	},
	{
		pos = {2825.5, -2436, 12.4},
	},
	
	
	-- Reihe 1, Rechts
	{
		pos = {2825.5, -2458, 12.4},
	},
	{
		pos = {2825.5, -2462, 12.4},
	},
	{
		pos = {2825.5, -2466, 12.4},
	},
	{
		pos = {2825.5, -2470, 12.4},
	},
	{
		pos = {2825.5, -2474, 12.4},
	},
	{
		pos = {2825.5, -2478, 12.4},
	},
	{
		pos = {2825.5, -2482, 12.4},
	},
	{
		pos = {2825.5, -2486, 12.4},
	},
	{
		pos = {2825.5, -2490, 12.4},
	},
	{
		pos = {2825.5, -2494, 12.4},
	},
	{
		pos = {2825.5, -2498, 12.4},
	},
	
	
	-- Reihe 2, Links #1
	{
		pos = {2835.5, -2384, 12.4},
	},
	{
		pos = {2835.5, -2388, 12.4},
	},
	{
		pos = {2835.5, -2392, 12.4},
	},
	{
		pos = {2835.5, -2396, 12.4},
	},
	{
		pos = {2835.5, -2400, 12.4},
	},
	
	
	-- Reihe 2, Links #2
	{
		pos = {2835.5, -2418, 12.4},
	},
	{
		pos = {2835.5, -2422, 12.4},
	},
	{
		pos = {2835.5, -2426, 12.4},
	},
	{
		pos = {2835.5, -2430, 12.4},
	},
	{
		pos = {2835.5, -2434, 12.4},
	},
	
	-- Reihe 2, Rechts #1
	{
		pos = {2835.5, -2458, 12.4},
	},
	{
		pos = {2835.5, -2462, 12.4},
	},
	{
		pos = {2835.5, -2466, 12.4},
	},
	{
		pos = {2835.5, -2470, 12.4},
	},
	{
		pos = {2835.5, -2474, 12.4},
	},
	{
		pos = {2835.5, -2478, 12.4},
	},
	
}

local ContainerIDs			= {3565,3570,3571,3572}



local CurrentHafen		= {}




local function ControlCrane(player, key, state)
	local pName = getPlayerName(player)
	
	
	if (CurrentHafen[pName]) then
	--outputChatBox("ControlCrane: "..key.." - "..state)
		
		
		if (CurrentHafen[pName].curMoving and isElement(CurrentHafen[pName].curMoving)) then
			if (isTimer(CurrentHafen[pName].curMovingTimer)) then
				killTimer(CurrentHafen[pName].curMovingTimer)
				stopObject(CurrentHafen[pName].curMoving)
				CurrentHafen[pName].curMoving = false
			end
		end
		
		if (CurrentHafen[pName].cameraInterval and isTimer(CurrentHafen[pName].cameraInterval)) then
			killTimer(CurrentHafen[pName].cameraInterval)
		end
		
		
		if (state == "down") then
			
	
			if (key == "w" or key == "arrow_u") then
				local x, y, z = getElementPosition(CurrentHafen[pName].Hook)
				
				CurrentHafen[pName].curMoving = CurrentHafen[pName].Hook
				CurrentHafen[pName].curMovingTimer = setTimer(function()
					local nX, nY, nZ, nrX, nrY, nrZ = getElementAttachedOffsets(CurrentHafen[pName].Hook)
					if (nY < 26) then
						setElementAttachedOffsets(CurrentHafen[pName].Hook, nX, nY+0.3, nZ, nrX, nrY, nrZ)
					else
						CurrentHafen[pName].curMoving = false
						killTimer(CurrentHafen[pName].curMovingTimer)
					end
				end, 50, 0)
				
				
			elseif (key == "s" or key == "arrow_d") then
				
				local x, y, z = getElementPosition(CurrentHafen[pName].Hook)
				
				CurrentHafen[pName].curMoving = CurrentHafen[pName].Hook
				CurrentHafen[pName].curMovingTimer = setTimer(function()
					local nX, nY, nZ, nrX, nrY, nrZ = getElementAttachedOffsets(CurrentHafen[pName].Hook)
					if (nY > -12.5) then
						setElementAttachedOffsets(CurrentHafen[pName].Hook, nX, nY-0.3, nZ, nrX, nrY, nrZ)
					else
						CurrentHafen[pName].curMoving = false
						killTimer(CurrentHafen[pName].curMovingTimer)
					end
				end, 50, 0)
				
				
				
			elseif (key == "num_add") then
				
				local x, y, z = getElementPosition(CurrentHafen[pName].Hook)
				
				CurrentHafen[pName].curMoving = CurrentHafen[pName].Hook
				CurrentHafen[pName].curMovingTimer = setTimer(function()
					local nX, nY, nZ, nrX, nrY, nrZ = getElementAttachedOffsets(CurrentHafen[pName].Hook)
					if (nZ < 5) then
						setElementAttachedOffsets(CurrentHafen[pName].Hook, nX, nY, nZ+0.3, nrX, nrY, nrZ)
					else
						CurrentHafen[pName].curMoving = false
						killTimer(CurrentHafen[pName].curMovingTimer)
					end
				end, 50, 0)
				
				
			elseif (key == "num_sub") then
				
				local x, y, z = getElementPosition(CurrentHafen[pName].Hook)
				
				CurrentHafen[pName].curMoving = CurrentHafen[pName].Hook
				CurrentHafen[pName].curMovingTimer = setTimer(function()
					local nX, nY, nZ, nrX, nrY, nrZ = getElementAttachedOffsets(CurrentHafen[pName].Hook)
					if (nZ > -15) then
						setElementAttachedOffsets(CurrentHafen[pName].Hook, nX, nY, nZ-0.3, nrX, nrY, nrZ)
					else
						CurrentHafen[pName].curMoving = false
						killTimer(CurrentHafen[pName].curMovingTimer)
					end
				end, 50, 0)
				
				
				
			elseif (key == "a" or key == "arrow_l") then
				
				local x, y, z = getElementPosition(CurrentHafen[pName].Crane)
				local diff = ((y - (-2370)) * - 1)
				if (diff > 0) then
					local time = (diff*500)
					moveObject(CurrentHafen[pName].Crane, time, x, -2370, z)
					
					CurrentHafen[pName].curMoving = CurrentHafen[pName].Crane
					CurrentHafen[pName].curMovingTimer = setTimer(function() CurrentHafen[pName].curMoving = false end, time, 1)
				end
				
			elseif (key == "d" or key == "arrow_r") then
				
				local x, y, z = getElementPosition(CurrentHafen[pName].Crane)
				local diff = (y - (-2538))
				if (diff > 0) then
					local time = (diff*500)
					moveObject(CurrentHafen[pName].Crane, time, x, -2538, z)
					
					CurrentHafen[pName].curMoving = CurrentHafen[pName].Crane
					CurrentHafen[pName].curMovingTimer = setTimer(function() CurrentHafen[pName].curMoving = false end, time, 1)
				end
				
				
			elseif (key == "space") then
				
				if (not CurrentHafen[pName].HookAttached) then
					
					local eles = getElementsWithinColShape(CurrentHafen[pName].HookCol, "object")
					for _, ele in ipairs(eles) do
						local cont = getElementData(ele, "container")
						if (type(cont) == "string" and cont == pName) then
							CurrentHafen[pName].HookAttached = ele
							attachElements(ele, CurrentHafen[pName].Hook, 0, 1.3, -8.3)
							break
						end
					end
					
				else
					
					local eles = getElementsWithinColShape(CurrentHafen[pName].HookCol, "marker")
					for _, ele in ipairs(eles) do
						local cont = getElementData(ele, "container")
						if (type(cont) == "string" and cont == pName) then
							detachElements(CurrentHafen[pName].HookAttached, CurrentHafen[pName].Hook)
							local x, y, z	= getElementPosition(ele)
							setElementPosition(CurrentHafen[pName].HookAttached, x, y, z-2)
							CurrentHafen[pName].HookAttached = false
							
							destroyElement(ele)
							
							Jobs:AddEarnings(player, JobID, pricePerContainer)
							Jobs:AddLevel(player, JobID, 1)
							
							break
						end
					end
					
				end
			end
			
			CurrentHafen[pName].cameraInterval = setTimer(function()
				local cBx, cBy, cBz	= getElementPosition(CurrentHafen[pName].Cabin)
				local hKx, hKy, hKz	= getElementPosition(CurrentHafen[pName].Hook)
				setCameraMatrix(player, cBx, cBy, cBz, hKx, hKy, hKz)
			end, 50, 0)
			
			
		end
		
	end
end




_G["HafenStart"] = function(player, level)
	local state = false
		
	if (1==1) then
		
		local pName = getPlayerName(player)
		
		
		CurrentHafen[pName]					= {}
		CurrentHafen[pName].Dimension	= math.random(1000,9999)
		CurrentHafen[pName].Elements		= {}
		
		CurrentHafen[pName].Crane	= createObject(1378, 2808.6, -2443.9, 37, 0, 0, 270)
		CurrentHafen[pName].Cabin	= createObject(1376, 2808.6, -2443.9, 37, 0, 0, 270)
		CurrentHafen[pName].Hook	= createObject(1386, 2808.6, -2443.9, 37, 0, 0, 90)
		setElementData(player, "hafenHook", CurrentHafen[pName].Hook)
		
		CurrentHafen[pName].HookCol = createColCuboid(2808.6, -2443.9, 37, 2, 4, 2.5)-- createColSphere(2808.6, -2443.9, 37, 1.5)
		
		attachElements(CurrentHafen[pName].Cabin, CurrentHafen[pName].Crane, 0, -27, -4.515)
		attachElements(CurrentHafen[pName].Hook, CurrentHafen[pName].Crane, 1.3, 28, -4, 0, 0, 90)
		attachElements(CurrentHafen[pName].HookCol, CurrentHafen[pName].Hook, -1, -0.7, -8.2)
		
		-- an der reihenfolge hier nichts ändern, erst objekte erstellen, attachen und dann dimension setzten, sonst gehen attach offsets auf 0
		setElementDimension(CurrentHafen[pName].Crane, CurrentHafen[pName].Dimension)
		setElementDimension(CurrentHafen[pName].Cabin, CurrentHafen[pName].Dimension)
		setElementDimension(CurrentHafen[pName].Hook, CurrentHafen[pName].Dimension)
		setElementDimension(CurrentHafen[pName].HookCol, CurrentHafen[pName].Dimension)
		
		
		for i, con in ipairs(LandContainerPlaces) do
			local x, y, z	= unpack(con.pos)
			local obj		= createObject(ContainerIDs[math.random(#ContainerIDs)], x, y, z)
			setElementDimension(obj, CurrentHafen[pName].Dimension)
			setElementDoubleSided(obj, true)
			setElementData(obj, "container", pName)
			table.insert(CurrentHafen[pName].Elements, obj)
		end
		
		for i, con in ipairs(ShipContainerPlaces) do
			
			local x, y, z		= unpack(con.pos)
			if (not con.obj or not isElement(con.obj)) then
				local marker = createMarker(x, y, z+2, "arrow", 1, 255, 155, 0)
				setElementDimension(marker, CurrentHafen[pName].Dimension)
				setElementData(marker, "container", pName)
				table.insert(CurrentHafen[pName].Elements, marker)
			end
			
		end
		
		
		
		addEventHandler("onColShapeHit", CurrentHafen[pName].HookCol, function(ele, dim)
			local pName = getElementData(ele, "container")
			if (dim and type(pName) == "string") then
				local player = getPlayerFromName(pName)
				if (player) then
					ControlCrane(player, "", "") -- stop moving
					outputChatBox("Ouch! Something hit me: "..getElementType(ele))
				end
			end
		end)
		
		
		
		
		fadeElementInterior(player, 0, 2788, -2443, 14, 0, CurrentHafen[pName].Dimension, true)
		setElementFrozen(player, true)
		
		setTimer(function()
			local cBx, cBy, cBz	= getElementPosition(CurrentHafen[pName].Cabin)
			local hKx, hKy, hKz	= getElementPosition(CurrentHafen[pName].Hook)
			setCameraMatrix(player, cBx, cBy, cBz, hKx, hKy, hKz)
			
			infoShow(player, "info", "Staple die Container auf dem Schiff.")
			infoShow(player, "info", "Pro Container erhältst Du "..pricePerContainer.." $.")
			infoShow(player, "info", "↑/w/↓/s: Vor- u. Rückwärts, ←/a/→/d: Seitwärts, +/-: Hoch u. Runter, Leertaste: Container aufnehmen u. absetzen, Backspace: Beenden")
			
			bindKey(player, "w", "both", ControlCrane)
			bindKey(player, "arrow_u", "both", ControlCrane)
			
			bindKey(player, "s", "both", ControlCrane)
			bindKey(player, "arrow_d", "both", ControlCrane)
			
			bindKey(player, "a", "both", ControlCrane)
			bindKey(player, "arrow_l", "both", ControlCrane)
			
			bindKey(player, "d", "both", ControlCrane)
			bindKey(player, "arrow_r", "both", ControlCrane)
			
			bindKey(player, "num_add", "both", ControlCrane)
			bindKey(player, "arrow_r", "both", ControlCrane)
			
			bindKey(player, "num_sub", "both", ControlCrane)
			bindKey(player, "arrow_r", "both", ControlCrane)
			
			bindKey(player, "space", "down", ControlCrane)
			
			bindKey(player, "backspace", "down", _G["HafenEnd"])
			
			triggerClientEvent(player, "hafenStartClient", player, CurrentHafen[pName].Hook)
			
		end, 1000, 1)
		
		
		
		
		state = true
		
	end
	
	return state
end

_G["HafenEnd"] = function(player)
	local pName = getPlayerName(player)
	
	if (CurrentHafen[pName]) then
		
		unbindKey(player, "w", "both", ControlCrane)
		unbindKey(player, "arrow_u", "both", ControlCrane)
		
		unbindKey(player, "s", "both", ControlCrane)
		unbindKey(player, "arrow_d", "both", ControlCrane)
		
		unbindKey(player, "a", "both", ControlCrane)
		unbindKey(player, "arrow_l", "both", ControlCrane)
		
		unbindKey(player, "d", "both", ControlCrane)
		unbindKey(player, "arrow_r", "both", ControlCrane)
		
		unbindKey(player, "num_add", "both", ControlCrane)
		unbindKey(player, "arrow_r", "both", ControlCrane)
		
		unbindKey(player, "num_sub", "both", ControlCrane)
		unbindKey(player, "arrow_r", "both", ControlCrane)
		
		unbindKey(player, "space", "down", ControlCrane)
		
		unbindKey(player, "backspace", "down", _G["HafenEnd"])
		
		ControlCrane(player, "", "")
		
		fadeElementInterior(player, 0, 2748.10, -2448.2, 13.7, 215, 0, true)
		
		setTimer(function()
			ControlCrane(player, "", "")
			
			triggerClientEvent(player, "hafenStopClient", player)
			
			destroyElement(CurrentHafen[pName].HookCol)
			destroyElement(CurrentHafen[pName].Hook)
			removeElementData(player, "hafenHook")
			destroyElement(CurrentHafen[pName].Cabin)
			destroyElement(CurrentHafen[pName].Crane)
			
			for k, v in pairs(CurrentHafen[pName].Elements) do
				if (v and isElement(v)) then
					destroyElement(v)
				end
			end
		end, 750, 1)
		
		setTimer(function()
			setCameraTarget(player, player)
			setElementFrozen(player, false)
		end, 1000, 1)
		
	end
	
end



addCommandHandler("hafen", function(p)
	_G["HafenStart"](p,1)
end)
addCommandHandler("hafenend", function(p)
	_G["HafenEnd"](p)
end)