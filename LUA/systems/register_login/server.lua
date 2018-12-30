----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


addEvent("onPlayerRegistered", true)
addEvent("onPlayerLoggedin", true)

local function connectHandler(nick, ip, communityusername, serial, version, versionstring)
	if (Server.ready) then
		if (isSerialValid(serial)) then
			if (string.lower(nick) ~= "none" and string.lower(nick) ~= "server") then
				if (not string.find(nick,"#%x%x%x%x%x%x")) then
					-- ok
				else
					cancelEvent(true, "Bitte entferne die Sonderzeichen und Farbcodes aus deinem Username!")
				end
			else
				cancelEvent(true, "Dieser Username ist nicht erlaubt! Bitte aendere ihn.")
			end
		else
			cancelEvent(true, "Dein MTA verwendet eine ungueltige Serial! Bitte neu installieren.")
		end
	else
		cancelEvent(true, "Der Server befindet sich momentan noch im Startprozess.\nVersuche es gleich wieder.")
	end
end
addEventHandler("onPlayerConnect", root, connectHandler)

local function joinHandler()
	setPlayerBlurLevel(source, 0)
	
	fadeCamera(source, true, 5)
	setCameraMatrix(source, unpack(settings.general.joinCameraMatrix))
	
	for i = 1, 250 do
		outputChatBox(" ", source)
	end
	
	setPlayerTeam(source, chatTeam)
end
addEventHandler("onPlayerJoin", root, joinHandler)

local function playerReady(version)
	local player = source
	if (version ~= "Custom") then
		
		local modified = --[[getElementData(player, "modifiedFiles") or]] ""
		if (modified == "") then
			local pName		= getPlayerName(player)
			local pSerial	= getPlayerSerial(player)
			
			if (MySQL:rowExists("ban", dbPrepareString("Name LIKE ? OR Serial=?", pName, pSerial))) then
				local row	= MySQL:fetchRow("ban", dbPrepareString("Name LIKE ? OR Serial=?", pName, pSerial))
				triggerClientEvent(player, "showBannedInfo", player, row['Bantime'], row['Banlength'], row['Admin'], row['Reason']) --#TODO#
				
			else
				
				if (MySQL:rowExists("players", dbPrepareString("Name LIKE ?", pName))) then
					local row = MySQL:fetchRow("players", dbPrepareString("Name LIKE ?", pName, pSerial)) --#TODO#
					
					setPlayerName(player, row['Name']) -- Wichtig für abfragen ; "Lars" != "LArs"
					
					--[[if (pSerial ~= row['Serial'] and tostring(row['SerialCheck']) == '1') then
						triggerClientEvent(player, "showSerialBlock", player) --#TODO#
						
					else]]
						triggerClientEvent(player, "showLoginWindow", player)
					--end
					
				elseif (MySQL:rowExists("players", "Serial LIKE '"..pSerial.."'")) then -- Bereits registrierter Spieler joint mit noch freiem Namen
					return kickPlayer(player, "Anticheat", "Doppelaccounts sind nicht gestattet.")
				else
					triggerClientEvent(player, "showRegisterWindow", player)
				end
				
			end
		else
			triggerClientEvent(player, "showModifiedWindow", player, modified) --#TODO#
		end
		setElementData(player, "failedPass", 0)
	else
		kickPlayer(player, "Nutze ein Offizielles unveraendertes MTA:SA von mtasa.com!")
	end
end
addEvent("onPlayerReady", true)
addEventHandler("onPlayerReady", root, playerReady)


local function registerPlayer(password, gebDatum, gender, email)
	if (source == client) then
		local pName			= getPlayerName(source)
		local ip			= getPlayerIP(source)
		local serial		= getPlayerSerial(source)
		local sex			= gender -- 0 = male, 1 = female
		local email			= email
		
		local salt			= generateSalt(password)
		local saltedPass	= sha256(password..salt)
		
		local time			= getRealTime()
		local year			= time.year + 1900
		local month			= time.month + 1
		local day			= time.monthday
		local hour			= time.hour
		local minute		= time.minute
		local timestamp		= time.timestamp
		local registerdatum = tostring(day.."."..month.."."..year..", "..hour..":"..minute)
		 
		if (sex == 1) then
			local rnd = math.random(1, #settings.general.noobSkinsFemale)
			skinID = settings.general.noobSkinsFemale[rnd]
		else
			local rnd = math.random(1, #settings.general.noobSkinsMale)
			skinID = settings.general.noobSkinsMale[rnd]
		end
		
		
		
		
		local result = dbExec("INSERT INTO players (uID, Name, IP, Serial, RegisterTime, RegisterTimestamp, LoginTime, LoginTimestamp, Email, Password, Salt, Sex) VALUES ('NULL', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", pName, ip, serial, registerdatum, timestamp, registerdatum, timestamp, email, saltedPass, salt, sex)
		if (not result) then
			notificationShow(source, "error", "Fehler bei der Registrierung! Versuche es erneut oder wende dich an einen Admin. (MySQL-Insert: players)")
			return
		end
		
		
		local genTelNr = (function()
			local telNR = math.random(10000,99999999)
			local check = MySQL:rowExists("userdata", dbPrepareString("WHERE TelNR=?", telNR))
			if (not check) then
				return telNR
			end
			return genTelNr()
		end)
		
		local JobLevelEarn = '{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0,"7":0,"8":0,"9":0,"10":0,"11":0,"12":0,"13":0,"14":0,"15":0,"16":0,"17":0,"18":0,"19":0,"20":0}'
		local result = dbExec("INSERT INTO userdata (Name, SpawnPos, Playingtime, Money, BankMoney, Kills, Deaths, Jailtime, Deathtime, Wanteds, Stvo, Adminlvl, LastFactionChange, Faction, Job, JobLevels, JobEarnings, SkinID, TelNR, SocialState, MaxCars, Inventory, Hunger) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", pName, toJSON(settings.general.defaultSpawn), 0, settings.general.startMoneyHand, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, JobLevelEarn, JobLevelEarn, skinID, genTelNr(), settings.general.noobSocialState, settings.general.noobMaxCars, '{"creditcard":1,"iphone":1}', 100)
		if (not result) then
			notificationShow(source, "error", "Fehler bei der Registrierung! Versuche es erneut oder wende dich an einen Admin. (MySQL-Insert: userdata)")
			deletePlayerAccount(pName)
			return
		end
		
		
		local result = dbExec("INSERT INTO iphone_settings (Name, battery, credit, color, position, size, firstGuide, notes, radiostations, likedSongs) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", pName, 100, 0, 'Silber', 0, 0, 1, '', '[]', '{}')
		if (not result) then
			notificationShow(source, "error", "Fehler bei der Registrierung! Versuche es erneut oder wende dich an einen Admin. (MySQL-Insert: iphone_settings)")
			deletePlayerAccount(pName)
			return
		end
		
		
		
		if (not setPlayerData(source)) then
			return notificationShow(source, "error", "Ein Fehler beim Login ist aufgetreten, versuche es erneut oder wende dich an einen Admin (Reg:setPlayerData).")
		end
		
		-- Spawn siehe introEnded()
		notificationShow(source, "success", "Du hast dich erfolgreich registriert.")
		triggerEvent("onPlayerRegistered", source)
	end
end
addEvent("registerPlayer", true )
addEventHandler("registerPlayer", root, registerPlayer)

local function introEnded(player)
	setElementData(player, "loggedin", true)
	triggerEvent("onPlayerLoggedin", player) -- lässt player spawnen, startet Playingtime etc...
end

local function startIntro()
	introEnded(source)
end
addEventHandler("onPlayerRegistered", root, startIntro)


local function loginPlayer(password)
	if (source == client) then
		local pName			= getPlayerName(source)
		local dbRow			= MySQL:fetchRow("players", dbPrepareString("Name LIKE ?", pName))
		local saltedPass	= tostring(sha256(password..dbRow['Salt']))
		
		if (string.lower(dbRow['Password']) == string.lower(saltedPass)) then
			triggerClientEvent(source, "loginCallback", source, true)
			
			if (not setPlayerData(source)) then
				return notificationShow(source, "error", "Ein Fehler beim Login ist aufgetreten, versuche es erneut oder wende dich an einen Admin (Log:setPlayerData).")
			end
			
			local time		= getRealTime()
			local year		= time.year + 1900
			local month		= time.month + 1
			local day		= time.monthday
			local hour		= time.hour
			local minute	= time.minute
			local timestamp = time.timestamp
			local llog		= tostring(day.."."..month.."."..year..", "..hour..":"..minute)
			local lastLogin = getElementData(source, "LoginTime")
			
			MySQL:setValue("players", "IP",				getPlayerIP(source),	dbPrepareString("Name LIKE ?", pName))
			MySQL:setValue("players", "LoginTime",		llog,					dbPrepareString("Name LIKE ?", pName))
			MySQL:setValue("players", "LoginTimestamp", timestamp,				dbPrepareString("Name LIKE ?", pName))
			
			notificationShow(source, "success", "Du hast dich erfolgreich eingeloggt.")
			infoShow(source, "info2", "Letzter Login: "..lastLogin)
			setElementData(source, "loggedin", true)
			triggerEvent("onPlayerLoggedin", source)
		else
			triggerClientEvent(source, "loginCallback", source, false)
			notificationShow(source, "error", "Du hast ein falsches Passwort eingegeben.")
		end
	end
end
addEvent("loginPlayer", true)
addEventHandler("loginPlayer", root, loginPlayer)

function setPlayerData(player)
	local pName = getPlayerName(player)
	
	-- Players --
	local row = MySQL:fetchRow("players", dbPrepareString("Name LIKE ?", pName))
	
	setElementData(player, "uID", 				tonumber(row["uID"]))
	setElementData(player, "LoginTime", 		row["LoginTime"])
	
	
	-- Userdata --
	local row = MySQL:fetchRow("userdata", dbPrepareString("Name LIKE ?", pName))
	
	setElementData(player, "SpawnPos",			row["SpawnPos"])
	setElementData(player, "Playingtime",		tonumber(row["Playingtime"]))
	setPlayerMoney(player,						tonumber(row["Money"]))
	setPlayerBankMoney(player,					tonumber(row["BankMoney"]))
	setElementData(player, "Kills",				tonumber(row["Kills"]))
	setElementData(player, "Deaths",			tonumber(row["Deaths"]))
	setElementData(player, "Jailtime",			tonumber(row["Jailtime"]))
	setElementData(player, "Deathtime",			tonumber(row["Deathtime"]))
	setPlayerWantedLevel(player,				tonumber(row["Wanteds"]))
	setElementData(player, "Stvo",				tonumber(row["Stvo"]))
	setElementData(player, "Adminlvl",			tonumber(row["Adminlvl"]))
	setElementData(player, "LastFactionChange",	row["LastFactionChange"])
	setElementData(player, "Faction",			row["Faction"])
	setElementData(player, "Job",				row["Job"])
	setElementData(player, "JobLevels",			row["JobLevels"])
	setElementData(player, "JobEarnings",			row["JobEarnings"])
	setElementData(player, "SkinID",			tonumber(row["SkinID"]))
	setElementData(player, "TelNR",				tonumber(row["TelNR"]))
	setElementData(player, "SocialState",		row["SocialState"])
	setElementData(player, "MaxCars",			tonumber(row["MaxCars"]))
	setElementData(player, "Hunger",			tonumber(row["Hunger"]))
	
	
	setElementData(player, "Rank",				tonumber(5)) -- TODO
	
	
	createInventory(player, fromJSON(row["Inventory"]))
	
	if (tonumber(row["Adminlvl"]) > 0) then
		setPlayerNametagText(player, settings.general.clanTag..pName)
	end
	
	
	return true
end