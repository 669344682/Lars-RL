----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

Franchise = {}

function Franchise:constructor()
	local cCount = 0
	local sCount = 0
	
	-- Create Companys --
	for cID, company in pairs(Shops.companys) do
		if (company.franchise == true) then
			for sID, shop in pairs(company.shops) do
				shop.franchise = true
			end
		else
			for sID, shop in pairs(company.shops) do
				shop.franchise = false
			end
			company.franchise = false
		end
		
	end
	
	local sql = dbQuery("SELECT * FROM franchise_companys")
	if (sql) then
		local result, num_affected_rows = dbPoll(sql, -1)
		if (num_affected_rows > 0) then
			for i, row in pairs(result) do
				Shops.companys[tonumber(row["cID"])].franchise = {
					owner = row["owner"],
					price = tonumber(row["price"]),
					money = tonumber(row["money"]),
				}
				cCount = cCount + 1
			end
		end
	end
	dbFree(sql)
	
	
	-- Create Shops --
	local sql2 = dbQuery("SELECT * FROM franchise_shops")
	if (sql2) then
		local result2, num_affected_rows2 = dbPoll(sql2, -1)
		if (num_affected_rows2 > 0) then
			for i, row2 in pairs(result2) do
				
				Shops.companys[tonumber(row2["cID"])].shops[tonumber(row2["sID"])].franchise = {
					owner	= row2["owner"],
					price		= tonumber(row2["price"]),
					money	= tonumber(row2["money"]),
					position	= row2["position"],
					data		= fromJSON(row2["data"]),
				}
				
				sCount = sCount + 1
				
			end
		end
	end
	dbFree(sql2)
	
	setTimer(function() Franchise:save() end, settings.systems.saveTimersInterval, 0)
	
	outputDebugString("[Systems->Franchise:constructor()]: Created "..sCount.." Franchise-Shops from "..cCount.." Franchise-Companys.")
	return true
end
addEventHandler("onResourceStart", resourceRoot, function(...) Franchise:constructor(...) end, true, "low-11")

function Franchise:save()
	local tmNow	= getRealTime()
	local tsToday = tostring(getTimestamp((tmNow.year+1900), (tmNow.month+1), tmNow.monthday, 0, 0, 0))
	
	for cID, company in ipairs(Shops.companys) do
		if (company.franchise ~= false) then
			
			MySQL:setValue("franchise_companys", "owner", tostring(company.franchise.owner), dbPrepareString("cID=?", cID))
			MySQL:setValue("franchise_companys", "money", tostring(company.franchise.money), dbPrepareString("cID=?", cID))
			
			for sID, shop in pairs(company.shops) do
				if (shop.franchise ~= false) then
					
					if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
						Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0} -- visits, sales, eranings
					end
					
					if (#Shops.companys[cID].shops[sID].franchise.data > 10) then -- Daten auf letzte 10 Tage begrenzen
						for k, v in orderedPairs(Shops.companys[cID].shops[sID].franchise.data) do
							Shops.companys[cID].shops[sID].franchise.data[k] = nil
							break;
						end
					end
			
					
					MySQL:setValue("franchise_shops", "owner", tostring(shop.franchise.owner), dbPrepareString("cID=? and sID=?", cID, sID))
					MySQL:setValue("franchise_shops", "money", tostring(shop.franchise.money), dbPrepareString("cID=? and sID=?", cID, sID))
					MySQL:setValue("franchise_shops", "data", toJSON(shop.franchise.data), dbPrepareString("cID=? and sID=?", cID, sID))
				end
			end
			
		end
	end
	
	
	outputDebugString("[Systems->Franchise:save()]: Saved Franchise data.")
	return true
end
addEventHandler("onResourceStop", resourceRoot, function(...) Franchise:save(...) end, true, "high+11")
--[[
	Spieler kauft Unternehmen, und verkauft Filialen an andere Spieler (Franchise-Nehmer) weiter.
	Pro Verkauf einer Ware erhält der Inhaber des Unternehmens einen prozentualen anteil.
	
	Der Inhaber einer Filiale muss sich um den Lagerbestand kümmern, und ggf. neue Waren bestellen.
		-> Bei einer Bestellung muss die Ware ggf. erst produziert werden und anschliessend geliefert werden.
		Beispiel: Bestellung über 20 Forellen, Ein Fischer bekommt den Auftrag 20 Forellen aus dem Meer zu holen, nachdem ein Fischer
		den Auftrag bearbeitet hat erhält ein Lieferant den Auftrag die Fische abzuholen und in die Filiale zu bringen.
	Der Inhaber der Filiale muss ausserdem Miete für seine Filiale zahlen.
]]


function Franchise:openGUI(player)
	if (player:getData("franchiseShopID") ~= 0 and player:getData("franchiseCompanyID") ~= 0) then
		
		local data = Shops.companys[(player:getData("franchiseCompanyID"))]
		triggerClientEvent(player, "openFranchiseShopGUI", player, data, tonumber(player:getData("franchiseCompanyID")), data.shops[(player:getData("franchiseShopID"))], tonumber(player:getData("franchiseShopID")))
		
	else
		if (player:getData("franchiseCompanyID") ~= 0) then
			
			local data = Shops.companys[(player:getData("franchiseCompanyID"))]
			triggerClientEvent(player, "openFranchiseUnternehmenGUI", player, data, (player:getData("franchiseCompanyID")))
			
		else
			notificationShow(player, "error", "Dir gehört kein Franchise-Unternehmen oder Franchise-Shop.")
		end
	end
end
--addCommandHandler("franchise", function(...) Franchise:openGUI(...) end)




function Franchise:hasCompany(playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	local has = false
	if (playerOrName) then
		
		for i, arr in pairs(Shops.companys) do
			if (type(arr.franchise) == "table" and arr.franchise["owner"] == playerOrName) then
				has = i
				break
			end
		end
		
	end
	return has
end

function Franchise:hasShop(playerOrName)
	if (type(playerOrName) ~= "string") then
		playerOrName = getPlayerName(playerOrName)
	end
	
	local cID = false
	local sID = false
	if (playerOrName) then
		
		for c, com in pairs(Shops.companys) do
			for s, shp in pairs(com.shops) do
				if (type(shp.franchise) == "table" and shp.franchise["owner"] == playerOrName) then
					cID = c
					sID = s
					break
				end
			end
		end
		
	end
	return cID, sID
end




-- Funktionen für Unternehmens-Inhaber
function Franchise:buyCompany(cID)
	if (not self:hasCompany(source) and not self:hasShop(source)) then
		if (Shops.companys[cID].owner == "none") then
			if (getPlayerBankMoney(source) >= Shops.companys[cID].franchise["price"]) then
				if ((getElementData(source, "Playingtime")/60) >= settings.systems.shops.companyMinTime) then
					
					local pName = getPlayerName(source)
					
					Shops.companys[cID].franchise["owner"] = pName
					
					MySQL:setValue("franchise_companys", pName, "none", "cID='"..cID.."'")
					
					notificationShow(source, "success", "Du hast die Filiale erfolgreich gekauft. Du kannst dein Unternehmen in der Franchise-App verwalten.")
					takePlayerBankMoney(source, Shops.companys[cID].franchise["price"], "Kauf des Unternehmens: "..Shops.companys[cID].name..".")
					
					outputLog("franchise", "Franchise-Unternehmen (#"..cID..") Gekauft.", getPlayerName(source))
					
				else
					notificationShow(source, "error", "Du brauchst mindestens "..settings.systems.shops.companyMinTime.." Stunden.")
				end
			else
				notificationShow(source, "error", "Du hast nicht genügend Geld auf deinem Konto. Das Unternehmen kostet "..Shops.companys[cID].price.." $.")
			end
		else
			notificationShow(source, "error", "Du kannst dieses Unternehmen nicht kaufen, es ist bereits im Besitz von "..Shops.companys[cID].franchise["owner"]..".")
		end
	else
		notificationShow(source, "error", "Du kannst nur einen Shop oder ein Unternehmen besitzen.")
	end
end
addEvent("Franchise_buyCompany", true)
addEventHandler("Franchise_buyCompany", root, function(...) Franchise:buyCompany(...) end)

function Franchise:sellCompany()
	local cID = self:hasCompany(source)
	
	if (cID ~= 0) then
		
		Shops.companys[cID].franchise["owner"] = "none"
		
		MySQL:setValue("franchise_companys", "owner", "none", "cID='"..cID.."'")
		
		notificationShow(source, "success", "Du hast dein Unternehmen verkauft! Der Verkaufpreis wurde Dir auf Dein Bankkonto überwiesen.")
		
		local wert = math.floor((tonumber(Shops.companys[cID].franchise["price"]) / 100) * settings.systems.shops.sellBack)
		givePlayerBankMoney(source, wert, "Verkauf Franchise-Unternehmen (#"..cID..")")
		
		outputLog("franchise", "Franchise-Unternehmen (#"..cID..") Verkauft.", getPlayerName(source))
		
	end
end
addEvent("Franchise_sellCompany", true)
addEventHandler("Franchise_sellCompany", root, function(...) Franchise:sellCompany(...) end)

-- Funktionen für Franchise-Nehmer
function Franchise:buyShop(cID, sID)
	if (Shops.companys[cID].shops[sID].franchise["owner"] == "none") then
		if (not self:hasCompany(source)) then
			if (not self:hasShop(source)) then
				if (getPlayerBankMoney(source) >= Shops.companys[cID].shops[sID].franchise["price"]) then
					if ((getElementData(source, "Playingtime")/60) >= settings.systems.shops.shopMinTime) then
						
						Shops.companys[cID].shops[sID].franchise["owner"] = source:getName()
						
						MySQL:setValue("franchise_shops", "owner", source:getName(), "cID='"..cID.."' AND sID='"..sID.."'")
						
						notificationShow(source, "success", "Du hast die Filiale erfolgreich gekauft. Du kannst deine Filiale in der Franchise-App verwalten.")
						takePlayerBankMoney(source, Shops.companys[cID].shops[sID].franchise["price"], "Kauf einer Filiale von "..Shops.companys[cID].name..".")
						
						outputLog("franchise", "Franchise-Shop (#"..cID.."-"..sID..") Gekauft.", getPlayerName(source))
						
					else
						notificationShow(source, "error", "Du brauchst mindestens "..settings.systems.shops.shopMinTime.." Stunden.")
					end
				else
					notificationShow(source, "error", "Du hast nicht genügend Geld auf deinem Konto. Du benötigst "..Shops.companys[cID].shops[sID].price.." $.")
				end
			else
				notificationShow(source, "error", "Du besitzt bereits eine Filiale.\nJeder Spieler kann nur eine Filiale (unabhängig von welchem Unternehmen sie stammt) besitzen.")
			end
		else
			notificationShow(source, "error", "Du besitzt bereits ein Unternehmen.")
		end
	else
		notificationShow(source, "error", "Diese Filiale steht nicht zum Verkauf.")
	end
end
addEvent("Franchise:buyShop", true)
addEventHandler("Franchise:buyShop", root, function(...) Franchise:buyShop(...) end)

function Franchise:sellShop()
	local cID, sID = self:hasShop(source)
	if (cID ~= false) then
		
		Shops.companys[cID].shops[sID].franchise["owner"]		= "none"
		
		MySQL:setValue("franchise_shops", "owner", "none", "cID='"..cID.."' AND sID='"..sID.."'")
		
		notificationShow(source, "success", "Du hast deine Filiale erfolgreich verkauft! Der Verkaufspreis wurde Dir auf dein Bankkonto überwiesen.")
		
		local wert = math.floor((tonumber(Shops.companys[cID].shops[sID].franchise["price"]) / 100) * settings.systems.shops.sellBack)
		givePlayerBankMoney(source, wert, "Verkauf Franchise-Shop (#"..cID.."-"..sID..")")
		
		outputLog("franchise", "Franchise-Shop (#"..cID.."-"..sID..") Verkauf.", getPlayerName(source))
		
	else
		notificationShow(source, "error", "Du besitzt keine Filiale.")
	end
end
addEvent("Franchise:sellShop", true)
addEventHandler("Franchise:sellShop", root, function(...) Franchise:sellShop(...) end)





---

function Franchise:addShopMoney(player, amount)
	local cID = tonumber(getElementData(source, "currentCID"))
	local sID = tonumber(getElementData(source, "currentSID"))
	
	--outputChatBox("Franchise:addShopMoney(): cID:"..tostring(cID).." sID:"..tostring(sID))
	if (cID ~= nil and sID ~= nil) then
		
		local cFranchise = Shops.companys[cID].franchise
		if (type(cFranchise) == "table") then
			
			local sFranchise = Shops.companys[cID].shops[sID].franchise
			if (type(sFranchise) == "table") then
				
				local amComp		= (amount/100) * settings.systems.shops.participation
				local amShop		= (amount/100) * (100 - settings.systems.shops.participation)
				
				cFranchise.money	= cFranchise.money + amComp
				sFranchise.money	= sFranchise.money + amShop
				
				
				local tmNow	= getRealTime()
				local tsToday = tostring(getTimestamp((tmNow.year+1900), (tmNow.month+1), tmNow.monthday, 0, 0, 0))
				if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
					Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0}
				end
				Shops.companys[cID].shops[sID].franchise.data[tsToday][2] = Shops.companys[cID].shops[sID].franchise.data[tsToday][2] + 1
				Shops.companys[cID].shops[sID].franchise.data[tsToday][3] = Shops.companys[cID].shops[sID].franchise.data[tsToday][3] + amShop
				
			end
			
		end
		
	end
end

function Franchise:takeShopMoney(player, amount)
	local cID = tonumber(getElementData(source, "currentCID"))
	local sID = tonumber(getElementData(source, "currentSID"))
	
	--outputChatBox("Franchise:addShopMoney(): cID:"..tostring(cID).." sID:"..tostring(sID))
	if (cID ~= nil and sID ~= nil) then
		
		local sFranchise = Shops.companys[cID].shops[sID].franchise
		if (type(sFranchise) == "table") then
				
				sFranchise.money	= sFranchise.money - amount
				
				local tmNow	= getRealTime()
				local tsToday = tostring(getTimestamp((tmNow.year+1900), (tmNow.month+1), tmNow.monthday, 0, 0, 0))
				if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
					Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0}
				end
				Shops.companys[cID].shops[sID].franchise.data[tsToday][3] = Shops.companys[cID].shops[sID].franchise.data[tsToday][3] - amount
				
		end
		
	end
end


local function franchiseMenu(player, key, state, cID, sID)
	local sData = Shops.companys[cID].shops[sID].franchise
	
	local visitors		= 0
	local earnings	= 0
	local entries 		= 0
	for k, v in pairs(sData.data) do
		visitors		= visitors + v[1]
		earnings	= earnings + v[3]
		entries		= entries + 1
	end
		
	visitors				= math.ceil(visitors/entries)
	earnings			= math.ceil(earnings/entries)
		
	triggerClientEvent(player, "showFranchiseGUI", player, Shops.companys[cID].name, sData["owner"], sData["price"], settings.systems.shops.shopMinTime, visitors, earnings, cID, sID) 
end

addEvent("onShopEnter", true)
addEventHandler("onShopEnter", root, function(cID, sID)
	if (Shops.companys[cID].franchise ~= false and Shops.companys[cID].shops[sID].franchise ~= false) then
		
		infoShow(source, "info", "Mit der Taste \"F\" öffnest du das Franchisemenü.")
		
		bindKey(source, "F", "down", franchiseMenu, cID, sID)
		
		
		if (tostring(getElementData(source, "lastVisitedShop")) ~= tostring(cID..sID)) then
			
			local tmNow	= getRealTime()
			local tsToday = tostring(getTimestamp((tmNow.year+1900), (tmNow.month+1), tmNow.monthday, 0, 0, 0))
			if (type(Shops.companys[cID].shops[sID].franchise.data[tsToday]) ~= "table") then
				Shops.companys[cID].shops[sID].franchise.data[tsToday] = {0, 0, 0}
			end
			Shops.companys[cID].shops[sID].franchise.data[tsToday][1] = Shops.companys[cID].shops[sID].franchise.data[tsToday][1] + 1
			
			setElementData(source, "lastVisitedShop", cID..sID)
		end
		
	end
end)

addEvent("onShopLeave", true)
addEventHandler("onShopLeave", root, function(cID, sID)
	if (Shops.companys[cID].franchise ~= false and Shops.companys[cID].shops[sID].franchise ~= false) then
		--outputChatBox("you leaved Company:"..cID..", Shop:"..sID, source)
		unbindKey(source, "F", "down", franchiseMenu)
	end
end)