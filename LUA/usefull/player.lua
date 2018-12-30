----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

function isLoggedin(player)
	if (not player) then player = localPlayer end
	return getElementData(player, "loggedin")
end

function isAdmin(player)
	local lvl = tonumber(getElementData(player, "Adminlvl"))
	if (lvl > 0) then
		return true
	end
end



if (not localPlayer) then
	function notificationShow(player, typ, msg, time)
		triggerClientEvent(player, "notificationShow", player, typ, msg, time)
	end
end

if (not localPlayer) then
	function infoShow(player, typ, msg, args)
		triggerClientEvent(player, "infoShow", player, typ, msg, args)
	end
end



-- MONEY
_getPlayerMoney = getPlayerMoney
function getPlayerMoney(player)
	if (not player) then player = localPlayer end
	return tonumber(getElementData(player, "Money"))
end

if (not localPlayer) then
	local _setPlayerMoney = setPlayerMoney
	function setPlayerMoney(player, amount)
		setElementData(player, "Money", tonumber(amount))
		return _setPlayerMoney(player, amount)
	end
	
	function takePlayerMoney(player, amount, reason)
		local new = tonumber(getPlayerMoney(player) - amount)
		
		if (reason ~= "" and reason ~= false and reason ~= nil) then
			infoShow(player, "minus", "-"..formNumberToMoneyString(amount).."  "..reason)
			outputLog("handmoney", "takePlayerMoney('"..amount.."$', '"..reason.."')", getPlayerName(player))
		end
		
		return setPlayerMoney(player, new)
	end
	
	function givePlayerMoney(player, amount, reason)
		local new = tonumber(getPlayerMoney(player) + amount)
		
		if (reason ~= "" and reason ~= false and reason ~= nil) then
			infoShow(player, "plus", "+"..formNumberToMoneyString(amount).."  "..reason)
			outputLog("handmoney", "givePlayerMoney('"..amount.."$', '"..reason.."')", getPlayerName(player))
		end
		
		return setPlayerMoney(player, new)
	end
end



-- BANKMONEY
function getPlayerBankMoney(player)
	if (not player) then player = localPlayer end
	return tonumber(getElementData(player, "BankMoney"))
end

if (not localPlayer) then
	function setPlayerBankMoney(player, amount)
		return setElementData(player, "BankMoney", tonumber(amount))
	end
	
	function takePlayerBankMoney(player, amount, reason, alreadyLogged)
		local new = tonumber(getPlayerBankMoney(player) - amount)
		triggerClientEvent(player, "bankStatement", player, (amount*-1), reason)
		
		infoShow(player, "minus", "-"..formNumberToMoneyString(amount).."  "..reason)
		
		if (not alreadyLogged) then
			outputLog("bank", "takePlayerBankMoney('"..amount.."$', '"..reason.."')", getPlayerName(player))
		end
		
		return setPlayerBankMoney(player, new)
	end
	
	function givePlayerBankMoney(player, amount, reason, alreadyLogged)
		local new = tonumber(getPlayerBankMoney(player) + amount)
		triggerClientEvent(player, "bankStatement", player, amount, reason)
		
		infoShow(player, "plus", "+"..formNumberToMoneyString(amount).."  "..reason)
		
		if (not alreadyLogged) then
			outputLog("bank", "givePlayerBankMoney('"..amount.."$', '"..reason.."')", getPlayerName(player))
		end
		
		return setPlayerBankMoney(player, new)
	end
end


-- HUNGER
function getPlayerHunger(player)
	if (not player) then player = localPlayer end
	return tonumber(getElementData(player, "Hunger"))
end

if (not localPlayer) then
	function setPlayerHunger(player, amount)
		if (tonumber(amount) > 100) then amount = 100 end
		if (tonumber(amount) < 0) then amount = 0 end
		
		return setElementData(player, "Hunger", tonumber(amount))
	end
	
	function takePlayerHunger(player, amount, playtime)
		local new = tonumber(getPlayerHunger(player) - amount)
		
		if (playtime == true) then
			local hloss = false
			if (new < 1) then
				hloss = 3
				
			elseif (new < 10) then
				hloss = 2
				
			elseif (new < 25) then
				if (new == 24) then
					notificationShow(player, "error", "Iss etwas, Du fängst an zu verhungern.")
				end
				hloss = 1
			end
						
			if (hloss ~= false) then
				local health	= getElementHealth(player)
				local new		= health - hloss
				if (new < 0) then new = 0 end
				setElementHealth(player, new)
			end
		end
		
		return setPlayerHunger(player, new, playtime)
	end
	
	-- je weniger hunger desto langsamer füllt sich as leben auf ab 50% kann leben aufgefüllt werden
	-- unter 25 hunger langsam leben abziehen, abzug erhöhen je weinger hunger
	-- < 25 = -0.25%
	-- < 10 = -0.5%
	-- < 0 = -0.75%
	
	function givePlayerHunger(player, amount)
		local old		= getPlayerHunger(player)
		local new		= old + tonumber(amount)
		
		-- Fill health
		if (new >= 50) then
			local health	= getElementHealth(player)
			local time		= 10
			if (new >= 90) then
				time = 30
			elseif (new >= 70) then
				time = 20
			end
			
			setTimer(function(p)
				if (not isElement(p)) then
					return killTimer(sourceTimer)
				end
				local health	= math.ceil(getElementHealth(p) + 2)
				if (health > 100) then health = 100 end
				setElementHealth(p, health)
			end, time*1000, math.ceil((amount/3)), player)
		end
		
		return setPlayerHunger(player, new)
	end
end



-- Wanteds
if (not localPlayer) then
	function addPlayerWanteds(player, amount)
		local old		= getPlayerWantedLevel(player)
		local new		= old + tonumber(amount)
		if (new > 6) then new = 6 end
		
		return setPlayerWantedLevel(player, new)
	end
end