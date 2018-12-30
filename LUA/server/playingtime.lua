----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function playingTime(player, isTimr)
	--local source = source
	--if (player) then source = player end
	local source = player
	if (source and isElement(source) and isLoggedin(source)) then
		local pName = getPlayerName(source)
		
		local Playingtime = tonumber(getElementData(source, "Playingtime"))
				
		if (getElementData(source, "afk") == false) then
			setElementData(source, "Playingtime", Playingtime + 1)
			takePlayerHunger(source, 1, true)
		end	
		
		MySQL:setValue("userdata", "BankMoney",	getPlayerBankMoney(source), dbPrepareString("Name LIKE ?", pName))
		MySQL:setValue("userdata", "Money",		getPlayerMoney(source), 	dbPrepareString("Name LIKE ?", pName))
		
		local JailTime = tonumber(getElementData(source, "JailTime")) or 0
		if (JailTime > 0) then
			setElementData(source, "JailTime", JailTime - 1)
			if (JailTime <= 0) then
				--freePlayerFromJail(source)
			end
		end
		
		if (getPlayerPing(source) >= settings.general.maxHighPing) then
			setTimer(maxHighPing, 5000, 1, source)
		end
		
		
		setTimer(playingTime, 60000, 1, source, true)
		
		if (Playingtime % settings.general.playerSaveMinutes == 0) then
			datasave(source)
		end
	end
end

addEvent("onPlayerLoggedin", false)
addEventHandler("onPlayerLoggedin", root, function()
	playingTime(source, false)
end)

function maxHighPing(player)
	if (player and isElement(player)) then
		if (getPlayerPing(player) >= settings.general.maxHighPing) then
			logout(player, false)
			kickPlayer(player, "Dein Ping ist höher als "..settings.general.maxHighPing..".")
			--outputChatBox(getPlayerName(player).." wurde wegen High-Ping gekickt!", getRootElement(), 200, 0, 0)
		end
	end
end