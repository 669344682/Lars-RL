----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


Jobs					= {}
Jobs.jobs			= {
	[1]				= {
		name			= "Gabelstapler",
		desc			= "Deine Aufgabe als Gabelstapler ist es, LKWs mit Kisten zu beladen.\r\nDie Gabeln des Gabelstaplers lassen sich mit den Tasten\r\nNUM 8 und NUM 2 steuern.\r\n\r\nVerdienst pro Fahrt: 60 $ (LKWs), 100 $ (Züge)",
		levels		= {
			{
				name		= "LKWs beladen",
				level		= 0,
			},
			{
				name		= "Züge beladen",
				level		= 30,
			},
		},
		icon			= 19,
		ped			= {305, 2176.24, -2258.74, 14.78, 229}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
		sFunc		= "ForkliftStart",
		eFunc		= "ForkliftEnd",
	},
	
	[2]				= {
		name			= "Lieferant",
		desc			= "Deine Aufgabe als Lieferfahrer ist es, Warentransporte\r\nverschiedener Größen durchzuführen.\r\n\r\nVerdienst pro Kleintransport: 200 $\r\nVerdienst pro Großtransport: 350 $\r\nVerdienst pro Gefahrguttransport: bis 500 $",
		levels		= {
			{
				name		= "Kleintransport",
				level		= 0,
			},
			{
				name		= "Großtransport",
				level		= 15,
			},
			{
				name		= "Gefahrguttransport",
				level		= 20,
			},
		},
		icon			= 19,
		ped			= {258, -18.783, -269.75, 5.43, 180}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
	
	[3]				= {
		name			= "Hafenarbeiter",
		desc			= "Deine Aufgabe als Hafenarbeiter ist es, Container mit dem\r\nFrachtkran auf Frachtschiffe zu verladen.\r\nDen Frachtkran steuerst Du mit den Pfeiltasten,\r\nsowie den Bild-Auf und -Ab Tasten.\r\n\r\nVerdienst pro Container: 75 $",
		sFunc		= "HafenStart",
		eFunc		= "HafenEnd",
		levels		= false,
		icon			= 19,
		ped			= {16, 2749.74, -2451.1, 13.65, 0}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
	
	[4]				= {
		name			= "Flughafen",
		desc			= "Deine Aufgabe als Flughafenarbeiter ist es, Flugzeuge zu be-r\nund entladen sowie Personen und Waren Transporte durchzuführen.\r\n\r\nVerdienst als Transporteur: 100 $ pro Auftrag.\r\nVerdienst pro Helikopterflug: bis zu 400 $ pro Flug.\r\nVerdienst pro Passagierflug: bis zu 750 $ pro Flug.\r\nVerdienst pro Transportflug: bis zu 1.000 $ pro Flug.",
		levels		= {
			{
				name		= "Transporteur",
				level		= 0,
			},
			{
				name		= "Helikopterflug",
				level		= 15,
			},
			{
				name		= "Passagierflug",
				level		= 20,
			},
			{
				name		= "Transportflug",
				level		= 30,
			},
		},
		icon			= 19,
		ped			= {255, 1957.05, -2185.84, 13.55, 270}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
	
	[5]				= {
		name			= "Transport",
		desc			= "Deine Aufgabe im Transportunternehmen ist es,\r\nPersonen mit dem Taxi, Bus oder Zug zu befördern.\r\n\r\nVerdienst als Taxifahrer: 25 $ pro KM.\r\nVerdienst als Busfahrer: bis zu 500 $ pro Fahrt.\r\nVerdienst pro Zugführer: bis zu 1.000 $ pro Fahrt.",
		levels		= {
			{
				name		= "Taxi",
				level		= 0,
			},
			{
				name		= "Bus",
				level		= 15,
			},
			{
				name		= "Zug",
				level		= 20,
			},
		},
		icon			= 19,
		ped			= {187, 1091.375, -1803.2, 13.7, 0}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
	
	[6]				= {
		name			= "Farmer",
		desc			= "Deine Aufgabe als Farmer ist es, bei der Erne zu helfen, das Feld\r\nzu düngen oder Getreide mit dem Mähdrescher zu ernten.\r\n\r\nVerdienst als Erntehelfer: 20 $ pro Pflanze.\r\nVerdienst als Felddünger: 35 $ pro Marker.\r\nVerdienst mit Erntemaschine: 50 $ pro Marker.",
		sFunc		= "FarmerStart",
		eFunc		= "FarmerEnd",
		levels		= {
			{
				name		= "Erntehelfer",
				level		= 0,
			},
			{
				name		= "Felddünger",
				level		= 20,
			},
			{
				name		= "Erntemaschine",
				level		= 50,
			},
		},
		icon			= 19,
		ped			= {161, -61.25, 79.705, 3.12, 244}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
	
	[7]				= {
		name			= "Straßenreinigung",
		desc			= "Deine Aufgabe als Staßenreiniger ist es, die Straßen zu reinigen\r\nund die Mülltonnen der Bewohner von Los Santos zu leeren.\r\n\r\nVerdienst bei Straßenreinigung: 30 $ pro aufgesammelten Müll.\r\nVerdienst bei Müllabfuhr: 30 - 60 $ pro Mülltonne",
		sFunc		= "TrashStart",
		eFunc		= "TrashEnd",
		levels		= {
			{
				name		= "Straßenreinigung",
				level		= 0,
			},
			{
				name		= "Müllabfuhr",
				level		= 40,
			},
		},
		icon			= 19,
		ped			= {260, 2092.05, -2078.1, 13.55, 265}, -- ID, x, y, z, rz
		anim			= {"gangs", "leanidle", -1, true, false, false},
	},
}



function Jobs:Init()
	local count = 0
	for jID, job in pairs(self.jobs) do
		
		local id, x, y, z, rz = unpack(job.ped)
		job.ped = createPed(id, x, y, z, rz)
		setTimer(function()
			setPedAnimation(job.ped, unpack(job.anim))
		end, 2500, 1)
		setElementData(job.ped, "jobPed", jID)
		setElementData(job.ped, "invulnerable", true)
		
		job.blip = createBlip(x, y, z, job.icon, 2, 255, 0, 0, 255, 0, 400, root)
		
		count = count + 1
		
	end
	
	outputDebugString("[Systems->Jobs->Init()]: Created "..count.." Jobs.")
	return true
end
addEventHandler("onResourceStart", resourceRoot, function(...) Jobs:Init(...) end, true, "low-500")



function Jobs:PedClick(player, id)
	triggerClientEvent(player, "JobGui", player, id, self.jobs[id].name, self.jobs[id].desc, self.jobs[id].levels, self:GetLevel(player, id))
end

function Jobs:GetJob(player)
	return tonumber(getElementData(player, "Job")) or 0
end

function Jobs:SetJob(player, jID)
	jID = tonumber(jID)
	if (not self.jobs[jID] and jID ~= 0) then return false end
	return setElementData(player, "Job", jID)
end

function Jobs:IsInJob(player)
	return tonumber(getElementData(player, "inJobID")) or nil
end

function Jobs:Accept(jID)
	if (not self.jobs[jID]) then return false end
	local job = self:GetJob(source)
	
	if (job == 0) then
		self:SetJob(source, jID)
		
		notificationShow(source, "success", "Du hast den Job angenommen.\r\nKlicke auf deinen Vorgesetzten um den Job zu beginnen.")
		
	else
		notificationShow(source, "error", "Du hast bereits einen Job bei '"..self.jobs[job].name.."'.\r\nKündige erst deinen aktuellen Job, bevor Du einen neuen annimmst.")
	end
end
addEvent("Jobs:Accept", true)
addEventHandler("Jobs:Accept", root, function(...) Jobs:Accept(...) end)


function Jobs:Cancel(jID)
	if (not self.jobs[jID]) then return false end
	local job = self:GetJob(source)
	
	if (job == jID) then
		self:SetJob(source, 0)
		
		notificationShow(source, "success", "Du hast den Job erfolgreich gekündigt.")
		
	else
		if (job == 0) then
			notificationShow(source, "error", "Du hast keinen Job.")
		else
			notificationShow(source, "error", "Du bist nicht hier, sondern bei '"..self.jobs[job].name.."' angestellt.")
		end
	end
end
addEvent("Jobs:Cancel", true)
addEventHandler("Jobs:Cancel", root, function(...) Jobs:Cancel(...) end)



function Jobs:Start(jID, level)
	if (not self.jobs[jID]) then return false end
	if (not level) then level = nil end
	--level = tonumber(level)
	local job = self:GetJob(source)
	
	if (job == jID) then
		local minLvl = 0
		if (self.jobs[jID].levels ~= false) then
			minLvl = self.jobs[jID].levels[level].level
		end
		
		if (not level or self:GetLevel(source, jID) >= minLvl) then
			
			local state = _G[self.jobs[jID].sFunc](source, level)
			
			if (state) then
				setElementData(source, "inJobID", jID)
				setElementData(source, "inJobLevel", level)
				
				infoShow(source, "info", "Tippe /stopjob um den Job zu beenden.")
				
			else
				notificationShow(source, "error", "Derzeit sind genügend Mitarbeiter beschäftigt, versuche es später noch einmal.")
			end
			
		else
			notificationShow(source, "error", "Dein Joblevel reicht nicht aus. Mindestens Level "..minLvl.." benötigt.")
		end
	else
		notificationShow(source, "error", "Du bist hier nicht angestellt.")
	end
end
addEvent("Jobs:Start", true)
addEventHandler("Jobs:Start", root, function(...) Jobs:Start(...) end)

function Jobs:End(player)
	local cJob = tonumber(getElementData(player, "inJobID"))
	
	if (cJob ~= nil) then
		_G[self.jobs[cJob].eFunc](player)
		setElementData(player, "inJobID", nil)
		setElementData(player, "inJobLevel", nil)
	end
end
addCommandHandler("stopjob", function(...) Jobs:End(...) end)


function Jobs:GetEarnings(player, jID)
	jID = tostring(jID)
	local earnings = fromJSON(getElementData(player, "JobEarnings"))
	return (earnings[jID] or 0)
end
function Jobs:AddEarnings(player, jID, amount)
	jID = tostring(jID)
	local earnings	= fromJSON(getElementData(player, "JobEarnings"))
	earnings[jID]		= (earnings[jID] or 0) + amount
	setElementData(player, "JobEarnings",  toJSON(earnings))
	
	infoShow(player, "plus", "+"..formNumberToMoneyString(amount).."  "..self.jobs[tonumber(jID)].name.." (Gesamt: "..formNumberToMoneyString(self:GetEarnings(player, jID))..")")
end

function Jobs:GetLevel(player, jID)
	jID = tostring(jID)
	local levels = fromJSON(getElementData(player, "JobLevels"))
	return (levels[jID] or 0)
end
function Jobs:AddLevel(player, jID, amount)
	jID = tostring(jID)
	local levels	= fromJSON(getElementData(player, "JobLevels"))
	levels[jID]		= (levels[jID] or 0) + amount
	setElementData(player, "JobLevels",  toJSON(levels))
	
	if ((levels[jID]%10) == 0) then
		infoShow(player, "info", "Joblevel "..levels[jID].." erreicht.")
	end
end



addEventHandler("onPlayerVehicleExit", root, function(veh, seat, jacker)
	if (Jobs:IsInJob(source)) then
		if (not getElementData(veh, "exitAllowed")) then
			Jobs:End(source)
		end
	end
end)
addEventHandler("onVehicleStartEnter", root, function(player, seat, driver, door)
	if (driver) then
		if (Jobs:IsInJob(driver)) then
			cancelEvent(true)
		end
		
	else
		local jOwner = getElementData(source, "jobOwner")
		if (jOwner and jOwner ~= getPlayerName(player)) then
			cancelEvent(true)
		end
	end
end)