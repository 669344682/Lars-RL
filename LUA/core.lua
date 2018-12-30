----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

Server = {}
Server.ready = false


addEvent("onServerReady", true)
function Server:startBefore()
	local x = " "
	for i = 1, 10 do outputDebugString(x) x=x.." " end
	outputDebugString("Starting "..settings.general.serverNameShort)
	
    setGameType("Lars Reallife")
    setMapName("San Andreas")
    setRuleValue("forum", "http://"..settings.general.forumURL)
    setRuleValue("url", "http://"..settings.general.forumURL)
    setRuleValue("version", settings.general.version)
	
	local date = getRealTime()
	local stunde = date.hour
	if (stunde == 24) then stunde = 0 end
	local minute = date.minute
	setMinuteDuration(60*1000)
	setTime(stunde, minute)
    
	
	outputDebugString("--- MYSQL-CONNECTION ---")
	outputDebugString("Establish connection to the MySQL-Server...")
    if (MySQL:connect()) then
		outputDebugString("Database-Connection successfully established.")
		
        setTimer(function(...) Server:mainTimer(...) end, 60*1000, 0)
		
    else
		outputDebugString("Database Connection failed. Cancel script start...", 1)
		return cancelEvent(true, settings.general.serverNameShort.." stopped! Database Connection failed.") 
    end
	outputDebugString("/--- MYSQL-CONNECTION ---/")
	
	outputDebugString("--- STARTING SYSTEMS ---")
end
addEventHandler("onResourceStart", resourceRoot, function(...) Server:startBefore(...) end, true, "high+8888")

function Server:startAfter()
    outputDebugString("/--- STARTING SYSTEMS ---/")
	
	outputDebugString(settings.general.serverNameShort.." started successfully, and is ready to accept Connections!")
	
	self.ready = true
	triggerEvent("onServerReady", root)
end
addEventHandler("onResourceStart", resourceRoot, function(...) Server:startAfter(...) end, true, "low-9999")

function Server:stopBefore()
	local x = " "
	for i = 1, 5 do outputDebugString(x) x=x.." " end
	outputDebugString(settings.general.serverNameShort.." requesting stop.")
	self.ready = false
		
	outputDebugString("--- SAVING SYSTEMS ---")
	outputDebugString("Saving player data...")
	for _, player in pairs(getElementsByType("player")) do
		if (isLoggedin(player)) then
			datasave(player)
		end
		for k, v in pairs(getAllElementData(player)) do
			removeElementData(player, k)
		end
		--kickPlayer(player, "Server", "Serverrestart")
	end
	
	return true
end
addEventHandler("onResourceStop", resourceRoot, function() Server:stopBefore() end, true, "high+9999")

function Server:stopAfter()
	outputDebugString("/--- SAVING SYSTEMS ---/")
	outputDebugString("Closing MySQL Connection...")
	MySQL:disconnect()
	restoreAllWorldModels()
	
    outputDebugString(settings.general.serverNameShort.." stopped.")
	
	return true
end
addEventHandler("onResourceStop", resourceRoot, function() Server:stopAfter() end, true, "low-9999")

function Server:restart()
	outputDebugString(settings.general.serverNameShort.." requesting restart.")
	restartResource(getThisResource())
end
--addCommandHandler("srest", function(...) Server:restart(...) end)


function Server:mainTimer()
	local time		= getRealTime()
	local hour		= time.hour
	local minute	= time.minute
	local weekday	= time.weekday
	
	if (hour == 4 and minute == 0) then
		self:restart()
	elseif (hour == 3 and minute == 55) then
		outputChatBox("[INFO] Server wird in 5 Minuten neu gestartet.", root, 200, 100, 0)
	end
	
	
	-- JEDE MINUTE
	saveLogFiles() -- Logs speichern
end
