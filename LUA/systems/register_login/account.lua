----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


function isRegistered(name)
	if (MySQL:rowExists("players", dbPrepareString("Name LIKE ?", name))) then
		return true
	end
	return false
end

addEventHandler("onPlayerChangeNick", root, function(oldNick, newNick)
	playerInfo(player, "error", "Deinen Namen kannst Du nur im User-Panel ändern.")
	setPlayerName(player, oldNick)
	cancelEvent()
end)

function deletePlayerAccount(name)
	MySQL:delRow("players",			dbPrepareString("Name LIKE ?", name))
	MySQL:delRow("userdata",		dbPrepareString("Name LIKE ?", name))
	MySQL:delRow("vehicles",		dbPrepareString("Name LIKE ?", name))
	MySQL:delRow("logout",			dbPrepareString("Name LIKE ?", name))
	MySQL:delRow("iphone_settings",	dbPrepareString("Name LIKE ?", name))
	--#TODO#--
end

function generateSalt()
	local salt = ""
	for i = 1, 20 do
		local rnd = math.random(1,2)
		if (rnd == 1) then
			chr = math.random(0,9)
		else
			chr = string.char(math.random(65,90))
			if (math.random(1,2) == 1) then
				chr = string.lower(chr)
			end
		end
		salt = salt..chr
	end
	return salt
end

function isSerialValid(serial)
	local function isValidSerialChar(char)
		if char then
			local char = string.lower(char)
			if (isLetter(char)) then
				if char == "a" or char == "b" or char == "c" or char == "d" or char == "e" or char == "f" then
					return true
				else
					return false
				end
			else
				return true
			end
		else
			return false
		end
	end
	
	if serial then
		if (string.len(serial) ~= 32) then -- Ueberpruefe laenge
			return false
		end
		
		for i = 1, #serial do
			local sub = string.sub ( serial, i, i )
			if not (isNumber(sub) or isLetter(sub)) then -- Ueberpruefe ob Buchstabe oder Zahl.
				return false
			end
			if not (isValidSerialChar(sub)) then
				return false
			end
		end
		
		return true
	else
		return false
	end
	
end

function setPlayerBinds()
	local player = source
	if (not isKeyBound(player, "m", "down", cursorShow)) then
		bindKey(player, "m", "down", cursorShow)
	end
	if (not isKeyBound(player, "ralt", "both", cursorShow)) then
		bindKey(player, "ralt", "both", cursorShow)
	end
	if (not isKeyBound(player, "i", "down", openInventory)) then
		bindKey(player, "i", "down", openInventory)
	end
	if (not isKeyBound(player, "u", "down", openIphone)) then
		bindKey(player, "u", "down", openIphone)
	end
	if (not isKeyBound(player, "#", "down", "chatbox", "AdminChat") and isAdmin(player)) then
		bindKey(player, "#", "down", "chatbox", "AdminChat")
	end
end
addEvent("onPlayerLoggedin", true)
addEventHandler("onPlayerLoggedin", root, setPlayerBinds)


