----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


---[ SETTINGS ]---
iPhonePlayerSettings = {}
function iPhoneRequestSettings()
	local pName = getPlayerName(source)
	
	iPhonePlayerSettings[pName] = {}
	
	
	-- Load settings
	local sql = dbQuery("SELECT * FROM iphone_settings WHERE Name=?", pName)
	local res = dbPoll(sql, -1)
	
	if (res and res[1]) then
		local row = res[1]
		for k, v in pairs(row) do
			iPhonePlayerSettings[pName][k] = v
		end
	end
	dbFree(sql)
	
	setElementData(source, "callState", false)
	setElementData(source, "callTarget", false)
	
	-- API-Token
	local apiToken = hash('sha256', pName..settings.general.apiSalz)
	
	triggerClientEvent(source, "iPhoneReceiveSettings", source, iPhonePlayerSettings[pName], apiToken)
end
addEvent("onPlayerLoggedin", true)
addEventHandler("onPlayerLoggedin", root, iPhoneRequestSettings)

local function iPhoneUpdateSettings(arr)
	if (source ~= client) then return end
	local pName = getPlayerName(source)
	
	iPhonePlayerSettings[pName] = arr
	outputConsole(pName)
	outputConsole(dumpvar(iPhonePlayerSettings[pName]))
end
addEvent("iPhoneUpdateSettings", true)
addEventHandler("iPhoneUpdateSettings", root, iPhoneUpdateSettings)

local function iPhoneSaveSettings()
	dbExec("START TRANSACTION;")
	outputChatBox("@iPhoneSaveSettings")
	for name, arr in pairs(iPhonePlayerSettings) do
		dbExec("UPDATE iphone_settings SET battery=?, credit=?, color=?, position=?, size=?, firstGuide=?, notes=? WHERE Name=?;", tostring(tonumber(arr['battery'])), arr['credit'], arr['color'], arr['position'], arr['size'], arr['firstGuide'], arr['notes'], arr['radiostations'], arr['likedSongs'], name)
	end
	dbExec("COMMIT;")
end
setTimer(iPhoneSaveSettings, 3*60000, 0)
addEventHandler("onResourceStop", getResourceRootElement(), iPhoneSaveSettings)


function openIphone(player, key, state)
	triggerClientEvent(player, "toggleIphone", player)
end


function getPlayerPrepaid(player)
	return iPhonePlayerSettings[getPlayerName(player)]['credit']
end
function takePlayerPrepaid(player, amount)
	local pName = getPlayerName(player)
	iPhonePlayerSettings[pName]['credit'] = iPhonePlayerSettings[pName]['credit'] - amount
	triggerClientEvent(source, "iPhoneReceiveSettings", source, iPhonePlayerSettings[pName], hash('sha256', pName..settings.server.apiSalz))
end




---[ APPS ]---
--- SMS
local function getSMS(player)
	if (player) then source=player client=player end
	if (source ~= client) then return end
	local pName = getPlayerName(source)
	local sql = dbQuery("SELECT * FROM iphone_sms WHERE sender=? OR receiver=? ORDER BY ID DESC", pName, pName)
	local res = dbPoll(sql, -1)
	
	local arr = {}
	if (res) then
		for i, row in ipairs(res) do
			arr[i] = {}
			for k, v in pairs(row) do
				arr[i][k] = v
			end
			--arr[i]['chat'] = fromJSON(arr[i]['chat'])
		end
	end
	dbFree(sql)
	
	triggerClientEvent(source, "sendDataIntoCEF", source, "receiveSMSData", base64Encode(toJSON(arr)))
end
addEvent("getSMS", true)
addEventHandler("getSMS", root, getSMS)

local function newSMS(receiver)
	if (source ~= client) then return end
	local pName = getPlayerName(source)
	
	local _, c1, _ = dbPoll(dbQuery("SELECT * FROM iphone_sms WHERE sender=? AND receiver=?", pName, receiver), -1)
	local _, c2, _ = dbPoll(dbQuery("SELECT * FROM iphone_sms WHERE sender=? AND receiver=?", receiver, pName), -1)
	
	local res = false
	if (c1 <= 0 and c2 <= 0) then
		local sql = dbQuery("INSERT INTO iphone_sms (ID, sender, senderUnreaded, receiver, receiverUnreaded, chat) VALUES (NULL, ?, 0, ?, 0, '[]')", pName, receiver)
		local _, _, last_id = dbPoll(sql, -1)
		res = last_id
	end
	
	getSMS(source)
	triggerClientEvent(source, "sendDataIntoCEF", source, "newSmsCallback", res)
end
addEvent("newSMS", true)
addEventHandler("newSMS", root, newSMS)

local function answerSMS(ID, msg)
	if (source ~= client) then return end
	local pName = getPlayerName(source)
	
	if (getPlayerPrepaid(source) >= 0.15) then
		local sql = dbQuery("SELECT * FROM iphone_sms WHERE ID=?", ID)
		local res = dbPoll(sql, -1)
		
		local newMsg = {}
		if (res and res[1]) then
			local json = fromJSON(res[1]['chat'])
			
			local _from = 'sender'
			local _to	= 'receiver'
			if (string.lower(res[1]['receiver']) == string.lower(pName)) then
				_from	= 'receiver'
				_to		= 'sender'
			end
			
			newMsg = {
				from	= _from,
				time	= getRealTime().timestamp,
				text	= msg,
			}
			table.insert(json, newMsg)
			
			local count = #json
			outputChatBox("count:"..count)
			if (count >= 100) then
				table.remove(json, 1)
			end
			
			json = toJSON(json)
			
			dbExec("UPDATE iphone_sms SET chat=? WHERE ID=?", json, ID)
			
		end
		
		local partner = res[1]['sender']
		if (partner == pName) then
			partner = res[1]['receiver']
		end
		
		getSMS(source)
		local receiver = getPlayerFromName(partner)
		if (receiver) then
			getSMS(receiver)
			triggerClientEvent(receiver, "newSmsNotification", receiver, pName, ID, newMsg.text)
		end
		
		takePlayerPrepaid(source, 0.15)
		
	else
		notificationShow(source, "error", "Du hast nicht genügend Geld auf deinem Pepaid-Konto.")
	end
end
addEvent("answerSMS", true)
addEventHandler("answerSMS", root, answerSMS)








--PHONE
--[[
callState:
false = kein anruf
true = aktiver anruf
"incoming" = ankommender anruf
"outgoing" = ausgehender anruf
]]
local function answerCall(bool)
	if (source ~= client) then return end
	
	local state		= getElementData(source, "callState")
	outputChatBox("("..getPlayerName(source)..") callState:"..tostring(state))
	if (state == "incoming" or state == "outgoing" or state == true) then
		
		setElementData(source, "callState", bool)
		
		outputChatBox("("..getPlayerName(source)..") caller:"..tostring(getElementData(source, "callTarget")))
		
		local caller	= getPlayerFromName(getElementData(source, "callTarget"))
		if (caller) then
			setElementData(caller, "callState", bool)
			
			
			outputChatBox("("..getPlayerName(source)..") BOOL:"..tostring(bool))
			local fix = bool
			if (bool == false) then
				fix = "stopped"
			end
			outputChatBox("("..getPlayerName(source)..") targetTrigger:"..tostring(fix))
			triggerClientEvent(caller, "sendDataIntoCEF", caller, 'startCallCallback', tostring(fix))
			
		else
			--TODO
		end
	end
	
end
addEvent("answerCall", true)
addEventHandler("answerCall", root, answerCall)


local function startCall(with)
	if (source ~= client) then return end
	
	
	if (tonumber(with) ~= nil and tonumber(with) > 0) then
		with = tonumber(with)
		
		if (with == 110 or with == 112 or with == 911) then
			outputChatBox('TODO: Special Numbers')
			
		elseif (with == 43235377) then
			setPedHeadless(source, not isPedHeadless(source))
			
		else
			outputChatBox('TODO: Find player by phone number')
		end
		
	end
	
	if (getPlayerPrepaid(source) >= 2) then
		local target = getPlayerFromName(with)
		
		local ret = "notarget"
		if (target) then
			
			--local handyOnOff = getElementData(target, "handyState")
			--if (not handyOnOff) then
				
				local callState = getElementData(target, "callState")
				if (callState == false) then
					
					ret = "calling"
					
					setElementData(source, "callTarget", with)
					setElementData(source, "callState", "outgoing")
					
					setElementData(target, "callState", "incoming")
					setElementData(target, "callTarget", getPlayerName(source))
					
					triggerClientEvent(target, "sendDataIntoCEF", target, 'receiveCall', getPlayerName(source))
					
					takePlayerPrepaid(source, 2)
					
				else
					ret = "besetzt"
				end
				
			--else
			--	ret = "handyoff"
			--end
			
		end
		
	else
		ret = "nomoney"
	end
	
	triggerClientEvent(source, "sendDataIntoCEF", source, 'startCallCallback', ret)
end
addEvent("startCall", true)
addEventHandler("startCall", root, startCall)

local function stopCall()
	if (source ~= client) then return end
	
	local state		= getElementData(source, "callState")
	if (state == "outgoing" or state == true) then
		
		setElementData(source, "callState", false)
		
		local target	= getPlayerFromName(getElementData(source, "callTarget"))
		if (target) then
			setElementData(target, "callState", false)
			
			triggerClientEvent(target, "sendDataIntoCEF", target, 'startCallCallback', 'stopped')
			
		end
		
	end
end
addEvent("stopCall", true)
addEventHandler("stopCall", root, stopCall)






--VEHICLES
local function getAllVehicles()
	local pName = getPlayerName(source)
	local ret	= {}
	
	for k, v in pairs(PlayerVehicles[pName]) do
		local data = Vehicles[v].data
		if (data) then
			table.insert(ret, {
				["ID"]		= data["ID"],
				["slot"]	= data["slot"],
				["typ"]		= data["typ"],
				["name"]	= getVehicleNameFromModel(data["typ"]),
			})
		end
	end
	
	triggerClientEvent(source, "sendDataIntoCEF", source, "receiveVehicles", base64Encode(toJSON(ret)))
end
addEvent("getAllVehicles", true)
addEventHandler("getAllVehicles", root, getAllVehicles)


local locateBlips = {}
addCommandHandler("locdel", function(player)
	local pName = getPlayerName(player)
	if (locateBlips[pName]) then
		destroyElement(locateBlips[pName].blip)
	end
end)

setTimer(function()
	local time = getRealTime().timestamp
	for k, v in pairs(locateBlips) do
		local diff = time - v.time
		if (diff > (60000*15)) then
			destroyElement(v.blip)
			locateBlips[k] = nil
		end
	end
end, 60000, 0)

local function vhAction(action, slot)
	if (action == "respawn") then
		if (slot == 'all') then
			executeCommandHandler("towvehall", source)
		else
			executeCommandHandler("towveh", source, slot)
		end
		
		
	elseif (action == "locate") then
		local pName = getPlayerName(source)
		
		if (locateBlips[pName]) then
			destroyElement(locateBlips[pName].blip)
		end
		
		local vID		= PlayerVehicles[pName][slot]
		if (isElement(Vehicles[vID].vehicle)) then
			local x, y, z	= unpack(fromJSON(Vehicles[vID].data["position"]))
			
			locateBlips[pName] = {
				blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 99999, source),
				time = getRealTime().timestamp
			}
			
			notificationShow(source, "success", "Die Position wurde auf der Karte makiert. Mit /locdel kannst Du das Icon entfernen.")
			
		else
			notificationShow(source, "error", "Das Fahrzeug ist nicht gespawnt.")
		end
	end
end
addEvent("vhAction", true)
addEventHandler("vhAction", root, vhAction)


--HOUSE
local function getHouseData()
	local houses	= {}
	local rentings	= {}
	
	for id, bool in pairs((House:getHouses(source) or {})) do
		if (bool) then
			local data		= House.houses[id].data
			local x, y, z	= unpack(fromJSON(data["position"]))
			local position	= getZoneName(x, y, z, true)..", "..getZoneName(x, y, z)
			
			table.insert(houses, {
				["ID"]			= data["ID"],
				["position"] 	= position,
				["owner"]		= owner,
			})
		end
	end
	
	for id, bool in pairs((House:getRentigs(source) or {})) do
		if (bool) then
			local data		= House.houses[id].data
			local x, y, z	= unpack(fromJSON(data["position"]))
			local position	= getZoneName(x, y, z, true)..", "..getZoneName(x, y, z)
			
			table.insert(rentings, {
				["ID"]			= data["ID"],
				["position"] 	= position,
				["owner"]		= owner,
			})
		end
	end
	
	local tbl = {["houses"] = houses, ["rentings"] = rentings}
	triggerClientEvent(source, "sendDataIntoCEF", source, "receiveHouseData", base64Encode(toJSON(tbl)))
	
end
addEvent("getHouseData", true)
addEventHandler("getHouseData", root, getHouseData)

local function locateHouse(ID)
	local pName = getPlayerName(source)
	
	if (locateBlips[pName]) then
		destroyElement(locateBlips[pName].blip)
	end
	
	
	local data		= House.houses[ID].data
	local x, y, z	= unpack(fromJSON(data["position"]))
	
	locateBlips[pName] = {
		blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 99999, source),
		time = getRealTime().timestamp
	}
	
	notificationShow(source, "success", "Die Position wurde auf der Karte makiert. Mit /locdel kannst Du das Icon entfernen.")
end
addEvent("locateHouse", true)
addEventHandler("locateHouse", root, locateHouse)




--BANKING
local function loadPrepaid(sum)
	if (sum > 0) then
		local bMoney = getPlayerBankMoney(source)
		if (bMoney >= sum) then
			takePlayerBankMoney(source, sum, "Prepaid-Guthaben")
			
			local pName = getPlayerName(source)
			iPhonePlayerSettings[pName]['credit'] = iPhonePlayerSettings[pName]['credit'] + sum
			
			outputLog("iphone", "Prepaid-Aufladung: "..sum.."$", getPlayerName(source))
			
			triggerClientEvent(source, "iPhoneReceiveSettings", source, iPhonePlayerSettings[pName], hash('sha256', pName..settings.server.apiSalz))
			
		else
			notificationShow(source, "error", "Du hast nicht genug Geld.")
		end
	end
end
addEvent("loadPrepaid", true)
addEventHandler("loadPrepaid", root, loadPrepaid)




-- FRANCHISE
local function getFranchise()
	local cID, sID	= Franchise:hasShop(source)
	
	local tmNow		= getRealTime()
	local tsToday		= tostring(getTimestamp((tmNow.year+1900), (tmNow.month+1), tmNow.monthday, 0, 0, 0))
	
	if (sID ~= false) then
		
		if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
			Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0}
		end
		
		local today	= Shops.companys[cID].shops[sID].franchise.data[tsToday]
		local tbl = {
			["isCompany"]		= false,
			["name"]				= Shops.companys[cID].name.." #"..sID,
			["kasse"]				= Shops.companys[cID].shops[sID].franchise["money"],
			
			["customersToday"]	= today[1],
			["salesToday"]		= today[2],
			["incomeToday"]		= today[3],
			
			["data"]					= Shops.companys[cID].shops[sID].franchise.data,
		}
				
		triggerClientEvent(source, "sendDataIntoCEF", source, "receiveFranchiseData", base64Encode(toJSON(tbl)))
		
		
	else
		cID = Franchise:hasCompany(source)
		if (cID ~= false) then
			
			local customersToday	= 0
			local salesToday			= 0
			local incomeToday		= 0
			local shpTbl				= {}
			
			for sID, shop in ipairs(Shops.companys[cID].shops) do
				if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
					Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0}
				end
				
				local x, y, z = unpack(shop.markerInPos)
				shpTbl[sID] = {
					sID			= sID,
					location		= getZoneName(x, y, z)..", "..getZoneName(x, y, z, true),
					franchise	= Shops.companys[cID].shops[sID].franchise,
				}
				
				customersToday = customersToday + Shops.companys[cID].shops[sID].franchise.data[tsToday][1]
				salesToday = salesToday + Shops.companys[cID].shops[sID].franchise.data[tsToday][2]
				incomeToday = incomeToday + Shops.companys[cID].shops[sID].franchise.data[tsToday][3]
			end
			
			local tbl = {
				["isCompany"]		= true,
				["name"]				= Shops.companys[cID].name,
				["kasse"]				= Shops.companys[cID].franchise["money"],
				
				["customersToday"]	= customersToday,
				["salesToday"]		= salesToday,
				["incomeToday"]		= incomeToday,
				
				["shops"]				= shpTbl,
			}
			
			local j = toJSON(tbl)
			outputConsole(j)
			triggerClientEvent(source, "sendDataIntoCEF", source, "receiveFranchiseData", base64Encode(j))
			
			
		end
	end
end
addEvent("getFranchise", true)
addEventHandler("getFranchise", root, getFranchise)

local function inOutFranchise(what, amount)
	local cID, sID = Franchise:hasShop(source)
	if (sID ~= false) then
		
		amount = tonumber(amount)
		if (amount and amount > 0) then
			
			local kasse = Shops.companys[cID].shops[sID].franchise.money
			
			if (what == "out") then
				if (kasse >= amount) then
					kasse = kasse - amount
					givePlayerBankMoney(source, amount, "Franchise Auszahlung (#"..cID.."-"..sID..")")
					outputLog("franchise", "Franchise (#"..cID.."-"..sID..") Auszahlung: "..amount.."$", getPlayerName(source))
					
				else
					notificationShow(source, "error", "Es ist nicht genügend Geld in deiner Kasse.")
				end
				
			else
				if (getPlayerBankMoney(source) >= amount) then
					kasse = kasse + amount
					takePlayerBankMoney(source, amount, "Franchise Einzahlung (#"..cID.."-"..sID..")")
					outputLog("franchise", "Franchise (#"..cID.."-"..sID..") Einzahlung: "..amount.."$", getPlayerName(source))
				else
					notificationShow(source, "error", "So viel Geld hast Du nicht auf deinem Konto.")
				end
			end
			
			Shops.companys[cID].shops[sID].franchise.money = kasse
			
		else
			notificationShow(source, "error", "Gib eine gültige Summe an.")
		end
		
		
	else
		
		cID = Franchise:hasCompany(source)
		if (cID ~= false) then
			
			amount = tonumber(amount)
			if (amount and amount > 0) then
				
				local kasse = Shops.companys[cID].franchise.money
				
				if (what == "out") then
					if (kasse >= amount) then
						kasse = kasse - amount
						givePlayerBankMoney(source, amount, "Franchise Auszahlung (#"..cID..")")
						outputLog("franchise", "Franchise (#"..cID..") Auszahlung: "..amount.."$", getPlayerName(source))
						
					else
						notificationShow(source, "error", "Es ist nicht genügend Geld in deiner Kasse.")
					end
					
				else
					if (getPlayerBankMoney(source) >= amount) then
						kasse = kasse + amount
						takePlayerBankMoney(source, amount, "Franchise Einzahlung (#"..cID..")")
						outputLog("franchise", "Franchise (#"..cID..") Einzahlung: "..amount.."$", getPlayerName(source))
					else
						notificationShow(source, "error", "So viel Geld hast Du nicht auf deinem Konto.")
					end
				end
				
				Shops.companys[cID].franchise.money = kasse
				
			else
				notificationShow(source, "error", "Gib eine gültige Summe an.")
			end
			
		end
		
	end
end
addEvent("inOutFranchise", true)
addEventHandler("inOutFranchise", root, inOutFranchise)








--[[
addEvent("iPhoneProxyServer", true)
addEventHandler("iPhoneProxyServer", root, function(uri, where, fType)
	fetchRemote(uri, {method="GET"}, function(data, responseInfo, player)
		if (responseInfo.success == true and data ~= "") then
			triggerClientEvent(player, "iPhoneProxyClientCB", player, "playlistCallback", base64Encode(data), where, fType)
		end
	end, {source})
end)]]