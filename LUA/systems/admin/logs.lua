----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local toSave = {}

--[[
outputLog('kill', 'Gekillt von fs626', 'Lars')
outputLog('mysql', 'Fehler bla bla bla')
]]

function outputLog(lName, lContent, pName)
	if (not pName) then pName = "none" end
	
	local time = getRealTime()
	local logArr = {
		log				= lName,	
		time			= time.timestamp,
		time_readable	= string.format("%02d.%02d.%04d, %02d:%02d:%02d", time.monthday, (time.month+1), (time.year+1900), time.hour, time.minute, time.second),
		player			= pName,
		text			= lContent,
	}
	table.insert(toSave, logArr)
end


-- Logs alle 60 sekunden in die DB Schreiben
function saveLogFiles()
	
	if (#toSave > 0) then
		
		local q = dbExec("START TRANSACTION;")
		if (q) then
			
			local _toSave = toSave
			toSave = {}
			
			for i, arr in ipairs(_toSave) do
				dbExec("INSERT INTO logs (ID, time, time_readable, log, player, text) VALUES (NULL, ?, ?, ?, ?, ?);", arr.time, arr.time_readable, arr.log, arr.player, arr.text)
			end
			dbExec("COMMIT;")
			
			outputDebugString("[Systems->Admin->saveLogFiles()]: Saved "..#_toSave.." logs.")
			
		else
			outputDebugString("[Systems->Admin->saveLogFiles()]: Can't save logs to Database!", 1)
		end
	end
	
end

-- Log-Files closen
addEventHandler("onResourceStop", resourceRoot, function()
	saveLogFiles()
end)