----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local badWeapons = { [9]=true, [27]=true, [28]=true, [32]=true, [37]=true, [42]=true, [39]=true, [38]=true, [40]=true }
local weaponsWithoutAmmo = { [41]=true, [44]=true, [45]=true, [46]=true, [40]=true }

local function anticheatBan(player, reason, time)
	outputChatBox("anticheatBan("..getPlayerName(player)..", "..reason..", "..time..")", root, 255, 0, 0)
end

local function anticheatServer(player)
	if (not player) then player = source end
	if (not isElement(player)) then return end
	if (not settings.general.debug) then
		if (isLoggedin(player)) then
			if (getElementHealth(player) > 101 or getPedArmor(player) > 101) then
				setPedArmor(player, 0)
				setElementHealth(player, 1)
				outputChatBox("Das Cheaten lassen wir lieber sein ;)", player, 255, 0, 0)
			end
			
			local mtaMoney = _getPlayerMoney(player)
			local money = tonumber(getElementData(player, "Money"))
			if (mtaMoney ~= money) then
				setPlayerMoney(player, money)
				anticheatBan(player, "Moneycheat ("..mtaMoney.." / "..money..")", 0)
			end
			
			if (not isAdmin(player)) then
				-- Jetpackcheat
				if (doesPedHaveJetPack(player)) then
					anticheatBan(player, "Jetpackcheat", 0)
				end
			end
			
			-- Weapon-Anticheat
			for i = 0, 12 do
				local weapon = getPedWeapon(player, i)
				local ammo = tonumber(getPedTotalAmmo(player, i))
				if (weapon and weapon ~= 0) then
					if ((badWeapons[weapon]) or (ammo > 9999 and weaponid > 15 and not weaponsWithoutAmmo[weapon])) then
						anticheatBan(player, "Weaponcheat, Waffe: "..getWeaponNameFromID(weapon)..", Ammo: "..ammo, 0)
						break;
					end
				end
			end
			
			-- General MTA Anticheat
			local ac = getPlayerACInfo(player)
			if (tonumber(ac.d3d9Size) ~= 0) then
				kickPlayer(player, "Anticheat", "Bitte entferne die d3d9.dll Datei aus deinem GTA:SA / MTA:SA Verzeichnis.")
			end
			
		end
		
		setTimer(anticheatServer, 1000, 1, player)
	end
end
addEvent("onPlayerLoggedin", true)
addEventHandler("onPlayerLoggedin", root, anticheatServer)

 
local function handleOnPlayerModInfo(filename, modList)
	allowedModels = { "exmaple.txd", "example.dff" }
	
	local s = nil
	for _, mod in ipairs(modList) do
		if (not allowedModels[mod.name]) then
			s = s..(mod.name).."|"
		end
    end
	
	setElementData(source, "modifiedFiles", s)
end
addEventHandler("onPlayerModInfo", root, handleOnPlayerModInfo)


-- Security: Don't allow Clientside Elementdata change.
addEventHandler("onElementDataChange", root, function(str, data)
	if (client ~= nil and getElementType(client) == "player") then
		if (str ~= "clicked" and str ~= "ElementClicked" and str ~= nil and str ~= "") then
			outputLog("anticheat", "Tryed to changed Elementdata '"..str.."' of '"..getPlayerName(source).."' from '"..tostring(data).."' to '"..tostring(getElementData(source, str)).."'. (Kicked)", getPlayerName(client))
			setElementData(source, str, data)
			kickPlayer(client, "Anticheat", "Versuch's doch einfach nochmal ;)")
		end
	end
end)