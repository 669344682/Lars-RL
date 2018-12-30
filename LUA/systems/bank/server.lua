----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

-- LS Bank
createBlip(1382.12, -1088.75, 28.7, 52, 2, 255, 0, 0, 255, 0, 200, root)

local outMarker2	= createMarker(845.9, 1682.8, 10535.8, "arrow", 1)
setElementInterior(outMarker2, 20)
setElementDimension(outMarker2, 66)
local function bankGoOut2(elem, dim)
	if (getElementType(elem) == "player" and dim) then
		setTimer(function() triggerClientEvent(elem, "gta5BankTimeFix", elem, false) end, 900, 1)
		fadeElementInterior(elem, 0, 1380.5, -1088.7, 27.4, 90, 0)
	end
end
addEventHandler("onMarkerHit", outMarker2, bankGoOut2)

local inMarker2 = createMarker(1382.12, -1088.75, 28.3, "arrow", 1)
local function bankGoIn2(elem, dim)
	if (getElementType(elem) == "player" and dim) then
		setTimer(function() triggerClientEvent(elem, "gta5BankTimeFix", elem, true) end, 900, 1)
		fadeElementInterior(elem, 20, 847.4, 1684.4, 10535.4, 320, 66)
	end
end
addEventHandler("onMarkerHit", inMarker2, bankGoIn2)



function bankPayInOut(outOrIn, amount)
	if (amount and isNumber(amount)) then
		if not string.find(amount, "-") and not string.find(amount, "+") then
			local amount = math.abs(math.floor(tonumber(amount)))
			if (amount > 0) then
				
				local bankMoney = tonumber(getPlayerBankMoney(source))
				local handMoney	= tonumber(getPlayerMoney(source))
				local x, y, z	= getElementPosition(source)
				local locName	= getZoneName(x, y, z)..", "..getZoneName(x, y, z, true)
				if (outOrIn == true) then -- OUT
					
					if (bankMoney ~= nil and bankMoney >= amount) then
						
						takePlayerBankMoney(source, amount, "Bankautomat "..locName, "-"..amount, true)
						givePlayerMoney(source, amount, "Bankautomat Auszahlung")
						outputLog("bank", amount.."$ abgehoben. Neuer Kontostand: "..(bankMoney-amount).."$. Location: "..locName, getPlayerName(source))
						
					else
						notificationShow(source, "error", "Du hast nicht genug Geld.")
					end
					
				else -- IN
					
					if (handMoney ~= nil and bankMoney ~= nil and handMoney >= amount) then
						
						givePlayerBankMoney(source, amount, "Bankautomat "..locName, "+"..amount, true)
						takePlayerMoney(source, amount, "Bankautomat Einzahlung")
						outputLog("bank", amount.."$ eingezahlt. Neuer Kontostand: "..(bankMoney+amount).."$. Location: "..locName, getPlayerName(source))
						
					else
						notificationShow(source, "error", "Du hast nicht genug Geld.")
					end
				
				end
			end
		end
	end
end
addEvent("bankPayInOut", true)
addEventHandler("bankPayInOut", root, bankPayInOut)


function bankTransfer(amount, receiver, text, isOnline)
	if (amount and receiver and text) then
		if (amount and isNumber(amount)) then
			if (not string.find(amount, "-") and not string.find(amount, "+")) then
				local amount = math.abs(math.floor(tonumber(amount)))
				if (amount > 0) then
					
					local ok		= false
					local bankMoney = tonumber(getPlayerBankMoney(source))
					local pName		= getPlayerName(source)
					
					if (bankMoney ~= nil and bankMoney >= amount) then
						
						local target = getPlayerFromName(receiver)
						if (target and isLoggedin(target)) then
							
							--notificationShow(target, "success", pName.." hat dir "..amount.."$ Überwiesen.")
							givePlayerBankMoney(target, amount, "Überweisung von "..pName..", Zweck: "..text, "+"..amount, true)
							ok = true
							
						else
							local target = MySQL:getValue("userdata", "Name", dbPrepareString("Name LIKE ?", receiver))
							if (target and target ~= "") then
								
								local newmoney = tonumber(MySQL:getValue("userdata", "BankMoney", dbPrepareString("Name LIKE ?", receiver)) + amount)
								MySQL:setValue("userdata", "BankMoney", newmoney, dbPrepareString("Name LIKE ?", receiver))
								
								--#TODO#: Offlinemsg
								
								ok = true
								
							else
								notificationShow(source, "error", "Den Spieler "..receiver.." wurde nicht gefunden.")
							end
							
						end
						
						if (ok) then
							--notificationShow(source, "success", "Du hast "..amount.."$ an "..receiver.." Überwiesen.")
							local x, y, z = getElementPosition(source)
							local locName = getZoneName(x, y, z)..", "..getZoneName(x, y, z, true)
							if (isOnline) then
								locName = "Online-Banking"
							end
							takePlayerBankMoney(source, amount, "Überweisung an "..receiver..", "..locName, "-"..amount, true)
							
							outputLog("bank", amount.."$ an "..receiver.." überwiesen. Neuer Kontostand: "..(bankMoney-amount).."$. Location: "..locName, pName)
							outputLog("bank", "Überweisung von "..pName..", "..amount.." $", receiver)
							
						end
						
					else
						notificationShow(source, "error", "Du hast nicht genug Geld.")
					end
				end
			end
		end
	end
end
addEvent("bankTransfer", true)
addEventHandler("bankTransfer", root, bankTransfer)