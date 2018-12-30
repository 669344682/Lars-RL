----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function onPlayerDeath(ammo, attacker, weapon, bodypart, int, dim)
	local pName		= getPlayerName(source)
	local x, y, z	= getElementPosition(source)
	
	--[[
	if (attacker) then
		if (getPlayerWantedLevel(source) > 0) then
			if (isStateFaction(attacker)) then
				local wanteds = tonumber(getPlayerWantedLevel(source))
				local jailTime = tonumber(wanteds * settings.factions.jail.perWanted)
				setElementData(source, "jailTime", jailTime)
				outputChatBox("Du wurdest von "..getPlayerName(attacker).." erledigt, und wirst nun für "..jailTime.." min. eingesperrt.", source, 0, 125, 0)
			end
		end
		outputLog("kill", "wurde getötet. Pos: "..x..", "..y..", "..z.." ("..getZoneName(x, y, z)..", "..getZoneName(x, y, z, true).."). Attacker: "..getPlayerName(attacker).." Waffe: "..getWeaponNameFromID(getPedWeapon(attacker) or 0), pName)
	else
		outputLog("death", "ist gestorben. Pos: "..x..", "..y..", "..z.." ("..getZoneName(x, y, z)..", "..getZoneName(x, y, z, true)..")", pName)
	end]]
	
	
	-- Drop
	local lostMoney = tonumber(math.ceil(getPlayerMoney(source) / 100))
	
	local pickup = createPickup(x, y, z, 3, 1274)
	setElementData(pickup, "value", lostMoney)
	takePlayerMoney(source, lostMoney, "verloren")
	
	setElementDimension (pickup, getElementDimension(source))
	setElementInterior (pickup, getElementInterior(source))
	
	_G[pName.."_moneyLostPickupTimer"] = setTimer(function()
		if (isElement(pickup)) then
			destroyElement(pickup)
		end
	end, 10*60000, 1)
	
	addEventHandler("onPickupHit", pickup, function(hitElement)
		if (getElementType(hitElement) == "player") and (not isPedInVehicle(hitElement)) then
			local val = tonumber(getElementData(source, "value")) or math.random(50, 175)
			
			if (isElement(source)) then
				destroyElement(source)
			end
			
			givePlayerMoney(hitElement, math.ceil(val), "gefunden")
			
			if (isTimer(_G[pName.."_moneyLostPickupTimer"])) then
				killTimer(_G[pName.."_moneyLostPickupTimer"])
			end
		end
	end)
	
	--
	
	--setElementData(source, "deathTime", settings.general.deathTime)
end
addEventHandler("onPlayerWasted", root, onPlayerDeath)