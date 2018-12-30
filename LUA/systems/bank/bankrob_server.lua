----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local doorToVault1	= createObject(3924, 866.38, 1695.65, 10535.535, 0, 0, 0)
setElementInterior(doorToVault1, 20)
setElementDimension(doorToVault1, 66)
local doorToVault2	= createObject(3924, 871.43, 1698.1, 10535.52, 0, 0, 90)
setElementInterior(doorToVault2, 20)
setElementDimension(doorToVault2, 66)
local doorState = "closed"
function moveDoorsToVault(state)
	
	local x1 = false
	local x2 = false
	if (state == "open" and doorState == "closed") then
		x1 = -80 --opened
		x2 = -120 --opened
		doorState = "open"
	elseif (state == "closed" and doorState == "open") then
		x1 = 80
		x2 = 120
		doorState = "closed"
	end
	
	if (x1 ~= false) then
		moveObject(doorToVault1, 1250, 866.38, 1695.65, 10535.535, 0, 0, x1)
		moveObject(doorToVault2, 1250, 871.43, 1698.1, 10535.52, 0, 0, x2)
	end
end


Bank = {
	robRunning		= nil,
	bombPlaced		= nil,
	resTimer		= nil,
	
	vaults			= {
		{
			pos = {864.5, 1689.9, 10532.1}
		},
		{
			pos = {863.6, 1689.9, 10532.1}
		},
		{
			pos = {862.7, 1689.9, 10532.1}
		},
		{
			pos = {861.8, 1689.9, 10532.1}
		},
		{
			pos = {860.9, 1689.9, 10532.1}
		},
			
		-- Mittlere reihe
		{
			pos = {864.5, 1689.9, 10531.2}
		},
		{
			pos = {863.6, 1689.9, 10531.2}
		},
		{
			pos = {862.7, 1689.9, 10531.2}
		},
		{
			pos = {861.8, 1689.9, 10531.2}
		},
		{
			pos = {860.9, 1689.9, 10531.2}
		},
		
		-- Untere reihe
		{
			pos = {864.5, 1689.9, 10530.3}
		},
		{
			pos = {863.6, 1689.9, 10530.3}
		},
		{
			pos = {862.7, 1689.9, 10530.3}
		},
		{
			pos = {861.8, 1689.9, 10530.3}
		},
		{
			pos = {860.9, 1689.9, 10530.3}
		},
	},
	
	liftMarkerUp	= nil,
	liftMarkerDown	= nil,
	safeDoor		= nil,
	safeDoorCol		= nil,
	
	-- Methode 1
	ped				= nil,
	pedHandsUp		= nil,
	pedCrouched		= nil,
	wasShooted		= nil,
	lastShooted		= 0,
	targetTimers	= {},
	attackPlayers	= {},
	securityPed		= nil,
	
	-- Methode 2: Tunnel
	luftungMarker	= nil,
	
	tunnelGrid		= nil,
	tunnelColSphere = nil,
	tunnelPed		= nil,
	
	laddersPlaced	= nil,
	ladders			= {},
	ladderPlaceCol	= nil,
	ladderUseCol	= nil,
}

local firstStart = true
function BankReset()
	moveDoorsToVault("closed")
	
	Bank.robRunning = false
	Bank.bombPlaced = false
	destroyElement(Bank.resTimer)
	
	for i, arr in ipairs(Bank.vaults) do
		--outputChatBox("create vault #"..i)
		destroyElement(arr.object)
		local x, y, z = unpack(arr.pos)
		arr.object = createObject(2332, x, y, z, 0, 0, 180)
		setElementInterior(arr.object, 20)
		setElementDimension(arr.object, 66)
		setElementData(arr.object, "isVault", i)
		setElementData(arr.object, "state", "closed")
		
		arr.money = math.random(settings.systems.bank.vaultMoneyMin, settings.systems.bank.vaultMoneyMax)
		arr.state = "closed"
	end
	
	destroyElement(Bank.liftMarkerUp)
	Bank.liftMarkerUp = createMarker(862.6, 1701.9, 10534.6, "cylinder", 1, 255, 0, 0, 255, root)
	setElementInterior(Bank.liftMarkerUp, 20)
	setElementDimension(Bank.liftMarkerUp, 66)
	
	destroyElement(Bank.liftMarkerDown)
	Bank.liftMarkerDown = createMarker(1403.1, -1053.5, 57.7, "cylinder", 1, 255, 0, 0, 255, root)
	setElementVisibleTo(Bank.liftMarkerDown, root, false)
	
	destroyElement(Bank.safeDoor)
	Bank.safeDoor = createObject(3898, 864.08, 1697.8, 10531.5, 0, 0, 180)
	setElementInterior(Bank.safeDoor, 20)
	setElementDimension(Bank.safeDoor, 66)
	
	destroyElement(Bank.safeDoorCol)
	Bank.safeDoorCol = createColSphere(862.4, 1698.4, 10530.99, 1.8)
	setElementInterior(Bank.safeDoorCol, 20)
	setElementDimension(Bank.safeDoorCol, 66)
	
	
	-- 1
	destroyElement(Bank.ped)
	Bank.ped = createPed(141, 856.0, 1697.85, 10535.4, 180)
	setElementInterior(Bank.ped, 20)
	setElementDimension(Bank.ped, 66)
	setElementData(Bank.ped, "bankPed", true)
	setElementData(Bank.ped, "angst", 0)
	setElementFrozen(Bank.ped, true)
	
	destroyElement(Bank.securityPed)
	Bank.securityPed = createPed(253, 859.6, 1686.37, 10535.4, 0)
	setElementInterior(Bank.securityPed, 20)
	setElementDimension(Bank.securityPed, 66)
	
	Bank.pedHandsUp		= false
	Bank.pedCrouched	= false
	Bank.wasShooted		= false
	Bank.lastShooted	= 0
	Bank.targetTimers	= {}
	Bank.attackPlayers	= {}
	
	-- 2
	destroyElement(Bank.luftungMarker)
	Bank.luftungMarker = createMarker(862.8, 1702.8, 10530.6, "corona", 1, 255, 0, 0, 255, root)
	setElementVisibleTo(Bank.luftungMarker, root, false)
	setElementInterior(Bank.luftungMarker, 20)
	setElementDimension(Bank.luftungMarker, 66)


	destroyElement(Bank.tunnelGrid)
	Bank.tunnelGrid = createObject(2945, 1407.5, -1303.3, 10.3, 0, 90, 0)
	setElementData(Bank.tunnelGrid, "unbreakable", true)
	setObjectScale(Bank.tunnelGrid, 0.687)
	setElementFrozen(Bank.tunnelGrid, true)
	
	destroyElement(Bank.tunnelColSphere)
	Bank.tunnelColSphere = createColSphere(1407.39, -1303.76, 9.02, 4)
	
	destroyElement(Bank.tunnelPed)
	Bank.tunnelPed = createPed(0, 1407.7, -1303.5, 9.8)
	setElementAlpha(Bank.tunnelPed, 0)
	setElementHealth(Bank.tunnelPed, 200)
	setElementFrozen(Bank.tunnelPed, true)
	setElementData(Bank.tunnelPed, "tunnelPed", true)
	setElementData(Bank.tunnelPed, "firstLastName", false)
	
	Bank.laddersPlaced	= false
	for i, ladder in ipairs(Bank.ladders) do
		destroyElement(ladder)
	end
	Bank.ladders = {}
	destroyElement(Bank.ladderPlaceCol)
	Bank.ladderPlaceCol = createColSphere(1407.75, -1089.5, 9.96, 2.75)
	destroyElement(Bank.ladderUseCol)
	
	if (not firstStart) then
		triggerClientEvent(root, "bankAlarm", root, false)
	end
	firstStart = false
end
addEventHandler("onResourceStart", resourceRoot, BankReset, true, "low-479")
addCommandHandler("resetbank", BankReset)


addEventHandler("onMarkerHit", root, function(elem, dim)
	if (getElementType(elem) == "player" and dim == true) then
		if (source == Bank.luftungMarker) then
			if (isElementVisibleTo(source, elem)) then
				setElementVisibleTo(source, elem, false)
				fadeElementInterior(elem, 0, 1407.75, -1089.5, 9.96, 0, 0)
				setTimer(function() triggerClientEvent(elem, "gta5BankTimeFix", elem, false) end, 900, 1)
			end
			
		elseif (source == Bank.liftMarkerUp) then
			setElementVisibleTo(Bank.liftMarkerDown, elem, true)
			fadeElementInterior(elem, 0, 1403.05, -1052.15, 58.4, 0)
			setTimer(function() triggerClientEvent(elem, "gta5BankTimeFix", elem, false) end, 900, 1)
			
		elseif (source == Bank.liftMarkerDown) then
			if (isElementVisibleTo(source, elem)) then
				setElementVisibleTo(source, elem, false)
				fadeElementInterior(elem, 20, 863.7, 1701.3, 10535.4, 90, 66)
				setTimer(function() triggerClientEvent(elem, "gta5BankTimeFix", elem, true) end, 900, 1)
			end
		end
	end
end)


function placeC4(player)
	if (isElementWithinColShape(player, Bank.safeDoorCol)) then
		if (Bank.bombPlaced == false) then
			Bank.bombPlaced = true
			setPedAnimation(player, "bomber", "bom_plant", 2000, false, false, false, false)
			toggleAllControls(player, false, false, false)
			setTimer(function()
				
				local bomb = createObject(1252, 861.6, 1697.8, 10531)
				setElementInterior(bomb, 20)
				setElementDimension(bomb, 66)
				setElementFrozen(bomb, true)
				
				toggleAllControls(player, true, true, true)
				notificationShow(player, "info", "Der Sprengstoff explodiert in 30 Sekunden.")
				setTimer(function()
					triggerClientEvent(root, "bankAlarm", root, true)
					
					moveDoorsToVault("open")
					setPedAnimation(Bank.ped, "ped", "duck_cower", -1, false, false, false, true)
					setPedAnimation(Bank.securityPed, "ped", "duck_cower", -1, false, false, false, true)
					
					createExplosion(861.6, 1697.8, 10531, 10, player)
					createExplosion(864.4, 1699.4, 10531, 10, player)
					setTimer(function()
						destroyElement(bomb)
						setElementRotation(Bank.safeDoor, 0, 0, 35)
					end, 250, 1)
				end, 1000*30, 1)
			end, 1750, 1)
			
		end
	end
end
addCommandHandler("c4", placeC4)



-- Methode 1:
local function onPlayerTarget(elem)
    if (elem == Bank.ped and not isPedDead(Bank.ped)) then
		if (true) then --faction
			if (Bank.robRunning == false) then
				local slot = getSlotFromWeapon(getPedWeapon(source))
				if (slot >= 1 and slot <= 8) then
					if (getElementData(source, "bankAim")) then
						
						Bank.attackPlayers[source] = true
						
						if (not Bank.pedHandsUp and not Bank.wasShooted) then
							setPedAnimation(Bank.ped, "shop", "shp_rob_react", -1, false, false, false, true)
							setPedAnimation(Bank.securityPed, "ped", "duck_cower", -1, false, false, false, true)
							Bank.pedHandsUp = true
							setElementData(Bank.ped, "angst", tonumber(getElementData(Bank.ped, "angst"))+10)
						end
						
						if (not Bank.targetTimers[source]) then			
							Bank.targetTimers[source] = setTimer(function(player)
								local target = getPlayerTarget(player)
								if (target == Bank.ped) then
									setElementData(Bank.ped, "angst", tonumber(getElementData(Bank.ped, "angst"))+3)
								else
									killTimer(Bank.targetTimers[player])
									Bank.targetTimers[player] = nil
								end
							end, 1000, 0, source)
						end
						
					end
				end
			end
		end
    end
end
addEventHandler("onPlayerTarget", root, onPlayerTarget)

addEvent("playerShootInBank", true)
addEventHandler("playerShootInBank", root, function()
	if (true) then -- faction
		if (not isPedDead(Bank.ped)) then
			if (Bank.robRunning == false) then
				
				Bank.attackPlayers[source] = true
				
				if (not Bank.pedCrouched) then
					setPedAnimation(Bank.ped, "ped", "duck_cower", -1, false, false, false, true)
					setPedAnimation(Bank.securityPed, "ped", "duck_cower", -1, false, false, false, true)
					Bank.pedCrouched = true
				end
				
				local r = getRealTime().timestamp - (Bank.lastShooted or 0)
				if (r >= 1) then
					
					if (Bank.wasShooted) then
						setElementData(Bank.ped, "angst", tonumber(getElementData(Bank.ped, "angst"))+7)
					else
						Bank.wasShooted = true
						setElementData(Bank.ped, "angst", tonumber(getElementData(Bank.ped, "angst"))+15)
					end
					Bank.lastShooted = getRealTime().timestamp
					
				end
				
			end
		end
	end
end)

setTimer(function()
	if (tonumber(getElementData(Bank.ped, "angst")) >= 100 and Bank.robRunning == false) then
		Bank.robRunning = true
		if (not isTimer(Bank.resTimer)) then Bank.resTimer = setTimer(BankReset, ((1000*60)*60)*2, 1) end
		setPedAnimation(Bank.ped, "bomber", "bom_plant_2idle", -1, false, false, false, true)
		
		setTimer(function()
			setPedAnimation(Bank.ped, "bomber", "bom_plant_2idle", -1, false, false, false, true)
			moveDoorsToVault("open")
			setPedAnimation(Bank.ped, "ped", "duck_cower", -1, false, false, false, true)
			triggerClientEvent(root, "bankAlarm", root, true)
		end, 500, 1)
	end
end, 1000, 0)

addEventHandler("onPedWasted", root, function(totalAmmo, killer, killerWeapon, bodypart, stealth)
	if (source == Bank.ped) then
		if (Bank.robRunning == false) then
			Bank.robRunning = true
			if (not isTimer(Bank.resTimer)) then Bank.resTimer = setTimer(BankReset, ((1000*60)*60)*2, 1) end
			triggerClientEvent(root, "bankAlarm", root, true)
		end
	end
end)




-- Methode 2
addEventHandler("onColShapeHit", root, function(elem, dim)
	if (getElementType(elem) == "player" and dim == true) then
		if (source == Bank.ladderPlaceCol) then
			if (Bank.laddersPlaced == false and Bank.robRunning == false) then
				notificationShow(elem, "info", "Tippe /ladder um eine Leiter zu platzieren.")
			end
		elseif (source == Bank.ladderUseCol) then
			if (Bank.laddersPlaced == true) then
				notificationShow(elem, "info", "Tippe /useladder um die Leiter hochzuklettern.")
			end
		elseif (source == Bank.tunnelColSphere) then
			if (isElement(Bank.tunnelGrid) and Bank.robRunning == false) then
				notificationShow(elem, "info", "Entferne das Gitter mit einer Kettensäge, um den Bankraub zu starten.")
			end
		elseif (source == Bank.safeDoorCol and Bank.bombPlaced == false) then
			notificationShow(elem, "info", "Tippe /c4 um eine Sprengladung zu platzieren.")
		end
	end
end)


function placeLadders(player)
	if (not Bank.laddersPlaced and not Bank.robRunning) then
		if (isElementWithinColShape(player, Bank.ladderPlaceCol)) then
			Bank.ladders[1]			= createObject(1437, 1408, -1088.9, 9, 5, 0, 0)
			Bank.ladders[2]			= createObject(1437, 1408, -1088.4, 14.5, 5, 0, 0)
			Bank.ladders[3]			= createObject(1437, 1408, -1088, 18.4, 5, 0, 0)
			
			Bank.laddersPlaced		= true
			Bank.ladderUseCol		= createColSphere(1408.05, -1089.214, 9.968, 1.2)
		end
	end
end
addCommandHandler("ladder", placeLadders)

function useLadders(player)
	if (Bank.ladderUseCol and isElementWithinColShape(player, Bank.ladderUseCol)) then
		Bank.robRunning = true
		if (not isTimer(Bank.resTimer)) then Bank.resTimer = setTimer(BankReset, ((1000*60)*60)*2, 1) end
		toggleAllControls(player, false, false, false)
		setElementFrozen(player, true)
		setElementRotation(player, 0, 0, 0)
		setPedAnimation(player, "ped", "climb_pull", -1, true, true, false, true)
		
		local binObj = createObject(3808, 1408.05, -1089.214, 9.968)
		setElementAlpha(binObj, 0)
		attachElements(player, binObj, 0, 0, 0)
		moveObject(binObj, 5000, 1408, -1088.5, 18.5)
		
		setTimer(function()
			fadeCamera(player, false, 1, 0, 0, 0)
		end, 2750, 1)
		
		setTimer(function()
			fadeCamera(player, true, 1, 0, 0, 0)
			
			setElementVisibleTo(Bank.luftungMarker, player, true)
			
			detachElements(player, binObj)
			destroyElement(binObj)
			setPedAnimation(player)
			toggleAllControls(player, true, true, true)
			setElementFrozen(player, false)
			
			setElementPosition(player, 865.1, 1701.6, 10530.8)
			setElementInterior(player, 20)
			setElementDimension(player, 66)
			
			triggerClientEvent(player, "gta5BankTimeFix", player, true)
			
		end, 5000, 1)
	end
end
addCommandHandler("useladder", useLadders)

function openVault(player, id)
	local arr = Bank.vaults[id]
	if (arr.state == "closed") then
		setElementModel(arr.object, 1829)
		arr.state = "open"
	elseif (arr.state == "open") then
		givePlayerMoney(player, arr.money, "Tresor")
		arr.state = "used"
		setElementModel(arr.object, 2332)
	elseif (arr.state == "used") then
		--notificationShow(player, "info", "Der Tresor wurde bereits geleert.")
	end
	setElementData(arr.object, "state", arr.state)
end


addEventHandler("onPedWasted", root, function(totalAmmo, killer, killerWeapon, bodypart, stealth)
	if (source == Bank.tunnelPed) then
		if (true) then
			if (killerWeapon == 9) then
				if (Bank.robRunning == false) then
					destroyElement(Bank.tunnelPed)
					destroyElement(Bank.tunnelGrid)
					notificationShow(killer, "info", "Begib dich den Tunnel entlang bis unter das Bankgebäude.")
				end
				
			end
		end
	end
end)


--#TODO#:offlinejail
