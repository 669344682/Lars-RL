----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local tuningShops = Shops.companys[12].shops

local tuningDims = {}
for i = 60000, 60050 do
	tuningDims[i] = false
end



-- EVENTS --
addEvent("closeVehicleUpgrade", true)
addEventHandler("closeVehicleUpgrade", root, function()
	local veh	= getPedOccupiedVehicle(source)
	local shop	= getElementData(veh, "inTuning")
	setElementData(veh, "inTuning", false)
	
	triggerEvent("onShopLeave", source, getElementData(source, "currentCID"), getElementData(source, "currentSID"))
	setElementData(source, "currentCID", nil)
	setElementData(source, "currentSID", nil)
	
	for seat, pl in pairs(getVehicleOccupants(veh)) do
		toggleControl(pl, "enter_exit", true)
	end
	toggleAllControls(source, true, true, true, true)
	
	tuningDims[getElementDimension(source)] = false
	
	setElementDimension(source, 0)
	setElementDimension(veh, 0)
	setElementInterior(source, 0)
	setElementInterior(veh, 0)
	local x, y, z, rz = unpack(tuningShops[shop].spawnOut)
	setElementPosition(veh, x, y, z)
	setElementRotation(veh, 0, 0, rz)
	setElementFrozen(source, false)
	setElementFrozen(veh, false)
	showChat(source, true)
	fadeCamera(source, true, 1)
	
	-- "Anprobierte" sachen wieder entfernen --
	local vID = getVehID(veh)
	for i = 1000, 1193 do
		removeVehicleUpgrade(veh, i)
	end
	setTimer(function()
		for slot, id in pairs(fromJSON(Vehicles[vID].data["upgrades"])) do
			if (tonumber(id) ~= nil) then
				addVehicleUpgrade(veh, id)
			end
		end
	end, 500, 1)
	for k, v in pairs(fromJSON(Vehicles[vID].data["specialupgrades"])) do
		if (v ~= 0 and v ~= nil and v ~= false) then
			removeVehicleSpecialUpgrade(veh, k, v)
			addVehicleSpecialUpgrade(veh, k, v)
		end
	end
	for k, v in pairs(fromJSON(Vehicles[vID].data["performanceupgrades"])) do
		if (v ~= 0 and v ~= nil and v ~= false) then
			removeVehiclePerformanceUpgrade(veh, k, v)
			addVehiclePerformanceUpgrade(veh, k, v)
		end
	end
	local variants = fromJSON(Vehicles[vID].data["variants"])
	setVehicleVariant(veh, (variants[1] or nil), (variants[2] or variants[1]))
end)

--neon kann man mehrmals kaufn
addEvent("buyVehicleUpgrade", true)
addEventHandler("buyVehicleUpgrade", root, function(typ, catName, itemNameOrID, color, text)
	col = "nil"
	if (color ~= nil) then
		col = ""
		for k,v in ipairs(color) do
			col = col..v..","
		end
	end	
	
	local veh		= getPedOccupiedVehicle(source)
	local vID		= getVehID(veh)
	local vehicle	= Vehicles[vID].vehicle
	
	local tbl		= false
	local cat		= false
	local sCat		= false
	if (typ == "Performance") then
		cat = performanceTuningUpgrades
	elseif (typ == "Spezial") then
		cat = specialTuningUpgrades
	elseif (typ == "Optisch") then
		cat	= tuningUpgrades
	elseif (typ == "Lackierung") then
		cat = vehicleColors
	end
	
	if (cat ~= false) then
		for k, v in ipairs(cat) do
			if (type(catName) ~= "string") then
				if (v.title == itemNameOrID) then
					tbl = v
					break
				end
				if (tbl ~= false) then break end
			else
				if (v.title == catName) then
					sCat = v
					for kk, vv in pairs(v.upgrades) do
						if (vv.title == itemNameOrID or vv.upgradeID == itemNameOrID) then
							tbl = vv
							break
						end
					end
					if (tbl ~= false) then break end
				end
			end
		end
	end
	
	
	if (tbl ~= false) then
		if (typ == "Optisch") then
			if (getPlayerMoney(source) >= tbl.price) then
				if (type(tbl.upgradeID) == "number" and tonumber(tbl.upgradeID) ~= nil) then
					local tunings	= fromJSON(Vehicles[vID].data["upgrades"])
					if (tunings[tostring(sCat.slotID)] ~= tbl.upgradeID) then
						
						tunings[tostring(sCat.slotID)] = tbl.upgradeID
						Vehicles[vID].data["upgrades"] = toJSON(tunings)
						
						addVehicleUpgrade(Vehicles[vID].vehicle, tbl.upgradeID)
						
						--notificationShow(source, "success", "Tuningteil gekauft!")
						takePlayerMoney(source, tbl.price, "Transfender")
						Franchise:addShopMoney(source, tbl.price)
						
					else
						notificationShow(source, "error", "Dieses Tuningteil ist bereits eingebaut.")
					end
					
				elseif (tbl.upgradeID == "neon") then
					local installed	= Vehicles[vID].data["neon"]
					
					if (installed ~= tbl.color) then
						
						Vehicles[vID].data["neon"] = tbl.color
										
						--notificationShow(source, "success", "Tuningteil gekauft!")
						takePlayerMoney(source, tbl.price, "Transfender")
						Franchise:addShopMoney(source, tbl.price)
						
					else
						notificationShow(source, "error", "Dieses Tuningteil ist bereits eingebaut.")
					end
					
				elseif (tbl.upgradeID == "variants") then
					local variants	= fromJSON(Vehicles[vID].data["variants"])
					if (type(variants[1]) == "number") then
						if (type(variants[2]) == "number") then
							variants[1] = variants[2]
							variants[2] = tbl.variant
						else
							variants[2] = tbl.variant
						end
					else
						variants[1] = tbl.variant
					end
					
					if (tbl.variant == nil) then
						variants = {}
					end
					
					Vehicles[vID].data["variants"] = toJSON(variants)
					setVehicleVariant(veh, (variants[1] or nil), (variants[2] or variants[1]))
					
					takePlayerMoney(source, tbl.price, "Transfender")
					Franchise:addShopMoney(source, tbl.price)
					
				end
			else
				notificationShow(source, "error", "Du hast nicht genügend Geld.")
			end
			
			
		elseif (typ == "Spezial") then
			
			local tunings	= fromJSON(Vehicles[vID].data["specialupgrades"])
			if (getPlayerMoney(source) >= tbl.price) then
				if (tbl.upgradeID == false and tbl.colortype == "headlight") then
					if (color ~= nil) then
						local r, g, b = unpack(color)
						setVehicleHeadLightColor(vehicle, r, g, b)
						
						Vehicles[vID].data["lcolor"]		= toJSON({r,g,b})
						
						--notificationShow(source, "success", "Lichtfarbe geändert!")
						playSoundFrontEnd (source, 46 )
						takePlayerMoney(source, tbl.price, "Transfender")
						Franchise:addShopMoney(source, tbl.price)
					end
				else
					if ((tunings[tostring(tbl.upgradeID)] == 0 or tunings[tostring(tbl.upgradeID)] == false or tunings[tostring(tbl.upgradeID)] == nil) or (tbl.upgradeID == "hornsound" and tunings[tostring(tbl.upgradeID)] ~= tbl.soundfile) or (tbl.upgradeID == "tiefer" and tunings[tostring(tbl.upgradeID)] ~= tbl.stufe) or (tbl.upgradeID == "numberplate" and tunings[tostring(tbl.upgradeID)] ~= text) or ((tbl.upgradeID == "rearwheelpos" or tbl.upgradeID == "rearwheelpos" or tbl.upgradeID == "customlights") and tunings[tostring(tbl.upgradeID)] ~= tbl.stufe)) then
						if (tbl.upgradeID == "hornsound") then
							tunings[tostring(tbl.upgradeID)] = tbl.soundfile
						elseif (tbl.upgradeID == "tiefer" or tbl.upgradeID == "rearwheelpos" or tbl.upgradeID == "frontwheelpos" or tbl.upgradeID == "customlights") then
							tunings[tostring(tbl.upgradeID)] = tbl.stufe
						elseif (tbl.upgradeID == "numberplate") then
							tunings[tostring(tbl.upgradeID)] = text
						else
							tunings[tostring(tbl.upgradeID)] = 1
						end
						Vehicles[vID].data["specialupgrades"] = toJSON(tunings)
						
						addVehicleSpecialUpgrade(vehicle, tbl.upgradeID, tunings[tostring(tbl.upgradeID)])
						
						--notificationShow(source, "success", "Tuningteil gekauft!")
						takePlayerMoney(source, tbl.price, "Transfender")
						Franchise:addShopMoney(source, tbl.price)
					else
						notificationShow(source, "error", "Dieses Tuningteil ist bereits eingebaut.")
					end
				end
			else
				notificationShow(source, "error", "Du hast nicht genügend Geld.")
			end
			
			
		elseif (typ == "Performance") then
			--local cat	= performanceTuningUpgrades[catID]
			--local tbl	= cat.upgrades[itemID]
			if (getPlayerMoney(source) >= tbl.price) then
				local tunings	= fromJSON(Vehicles[vID].data["performanceupgrades"])
				if ((tunings[tostring(sCat.upgradeID)] == nil or tunings[tostring(sCat.upgradeID)] == false or tunings[tostring(sCat.upgradeID)] == 0) or (tunings[tostring(sCat.upgradeID)] ~= tbl.upgradeID)) then
					
					tunings[tostring(sCat.upgradeID)] = tbl.upgradeID
					Vehicles[vID].data["performanceupgrades"] = toJSON(tunings)
					
					addVehiclePerformanceUpgrade(Vehicles[vID].vehicle, sCat.upgradeID, tbl.upgradeID)
					
					--notificationShow(source, "success", "Tuningteil gekauft!")
					playSoundFrontEnd (source, 46 )
					takePlayerMoney(source, tbl.price, "Transfender")
					Franchise:addShopMoney(source, tbl.price)
					
				else
					notificationShow(source, "error", "Dieses Tuningteil ist bereits eingebaut.")
				end
			else
				notificationShow(source, "error", "Du hast nicht genügend Geld.")
			end
			
		elseif (typ == "Lackierung") then
			--local tbl	= vehicleColors[itemID]
			if (getPlayerMoney(source) >= tbl.price) then
				local rgb = color
				setVehicleColor(vehicle, rgb[1], rgb[2], rgb[3], rgb[4], rgb[5], rgb[6], rgb[7], rgb[8], rgb[9], rgb[10], rgb[11], rgb[12])
				
				Vehicles[vID].data["color"]		= toJSON({rgb[1], rgb[2], rgb[3], rgb[4], rgb[5], rgb[6], rgb[7], rgb[8], rgb[9], rgb[10], rgb[11], rgb[12]})
				
				--notificationShow(source, "success", "Fahrzeug lackiert!")
				playSoundFrontEnd (source, 46)
				takePlayerMoney(source, tbl.price, "Transfender")
				Franchise:addShopMoney(source, tbl.price)
				
			else
				notificationShow(source, "error", "Du hast nicht genügend Geld.")
			end
			
			
		end
	end
end)

addEvent("removeVehicleUpgrade", true)
addEventHandler("removeVehicleUpgrade", root,  function(typ, catName, itemNameOrID)
		
	
	local veh		= getPedOccupiedVehicle(source)
	local vID		= getVehID(veh)
	local vehicle	= Vehicles[vID].vehicle
	
	local tbl		= false
	local cat		= false
	local sCat		= false
	if (typ == "Performance") then
		cat = performanceTuningUpgrades
	elseif (typ == "Spezial") then
		cat = specialTuningUpgrades
	elseif (typ == "Optisch") then
		cat	= tuningUpgrades
	end
	
	if (cat ~= false) then
		for k, v in ipairs(cat) do
			if (type(catName) ~= "string") then
				if (v.title == itemNameOrID) then
					tbl = v
					break
				end
				if (tbl ~= false) then break end
			else
				if (v.title == catName) then
					sCat = v
					for kk, vv in pairs(v.upgrades) do
						if (vv.title == itemNameOrID or vv.upgradeID == itemNameOrID) then
							tbl = vv
							break
						end
					end
					if (tbl ~= false) then break end
				end
			end
		end
	end
		
	if (tbl ~= false) then
		if (typ == "Optisch") then
			if (type(tbl.upgradeID) == "number" and tonumber(tbl.upgradeID) ~= nil) then
				local tunings	= fromJSON(Vehicles[vID].data["upgrades"])
				if (tunings[tostring(sCat.slotID)] == tbl.upgradeID) then
					
					tunings[tostring(sCat.slotID)] = 0
					Vehicles[vID].data["upgrades"] = toJSON(tunings)
					
					removeVehicleUpgrade(Vehicles[vID].vehicle, tbl.upgradeID)
					
					--notificationShow(source, "success", "Tuningteil entfernt!")
					givePlayerMoney(source, (tbl.price/2), "Transfender")
					Franchise:takeShopMoney(source, (tbl.price/2))
					
				else
					notificationShow(source, "error", "Dieses Tuningteil ist nicht eingebaut.")
				end
				
			elseif (tbl.upgradeID == "neon") then
				local installed	= Vehicles[vID].data["neon"]
				if (installed ~= "") then
					
					Vehicles[vID].data["neon"] = ""
									
					--notificationShow(source, "success", "Tuningteil entfernt!")
					givePlayerMoney(source, (tbl.price/2), "Transfender")
					Franchise:takeShopMoney(source, (tbl.price/2))
					
				else
					notificationShow(source, "error", "Dieses Tuningteil ist nicht eingebaut.")
				end
				
			elseif (tbl.upgradeID == "variants") then
				local variants	= {}
				Vehicles[vID].data["variants"] = toJSON(variants)
				notificationShow(source, "success", "Tuningteil entfernt!")
				setVehicleVariant(veh, nil, nil)
			end
			
		elseif (typ == "Spezial") then
			local tunings	= fromJSON(Vehicles[vID].data["specialupgrades"])
			if (tbl.upgradeID ~= false and tbl.colortype ~= "headlight") then
				if (tunings[tostring(tbl.upgradeID)] ~= 0 and tunings[tostring(tbl.upgradeID)] ~= nil and tunings[tostring(tbl.upgradeID)] ~= "" and tunings[tostring(tbl.upgradeID)] ~= false or ((tbl.upgradeID == "rearwheelpos" or tbl.upgradeID == "rearwheelpos") and tunings[tostring(tbl.upgradeID)] ~= tbl.stufe)) then
					if (tbl.upgradeID == "hornsound") then
						tunings[tostring(tbl.upgradeID)] = ""
					elseif (tbl.upgradeID == "tiefer" or tbl.upgradeID == "rearwheelpos" or tbl.upgradeID == "frontwheelpos") then
						tunings[tostring(tbl.upgradeID)] = 0
					else
						tunings[tostring(tbl.upgradeID)] = 0
					end
					Vehicles[vID].data["specialupgrades"] = toJSON(tunings)
					
					removeVehicleSpecialUpgrade(vehicle, tbl.upgradeID)
					
					--notificationShow(source, "success", "Tuningteil entfernt!")
					givePlayerMoney(source, (tbl.price/2), "Transfender")
					Franchise:takeShopMoney(source, (tbl.price/2))
				else
					notificationShow(source, "error", "Dieses Tuningteil ist nicht eingebaut.")
				end
			end
			
			
			
			
			
		elseif (typ == "Performance") then
			local tunings	= fromJSON(Vehicles[vID].data["performanceupgrades"])
			if (tunings[tostring(sCat.upgradeID)] ~= nil and tunings[tostring(sCat.upgradeID)] ~= false and tunings[tostring(sCat.upgradeID)] ~= 0 and tunings[tostring(sCat.upgradeID)] ~= "") then
			
				tunings[tostring(sCat.upgradeID)] = 0
				Vehicles[vID].data["performanceupgrades"] = toJSON(tunings)
				
				removeVehiclePerformanceUpgrade(Vehicles[vID].vehicle, sCat.upgradeID)
				
				--notificationShow(source, "success", "Tuningteil entfernt!")
				givePlayerMoney(source, (tbl.price/2), "Transfender")
				Franchise:takeShopMoney(source, (tbl.price/2))
				
			else
				notificationShow(source, "error", "Dieses Tuningteil ist nicht eingebaut.")
			end
			
		end
	end
end)

addEvent("tuningFix", true)
addEventHandler("tuningFix", root, function()
	local veh	= getPedOccupiedVehicle(source)
	local vID	= getVehID(veh)
	local json	= fromJSON(Vehicles[vID].data["specialupgrades"])
	local h		= 1000
	local price	= 0
	if (getElementHealth(veh) < 1000 and not json["armor"]) then
		price = math.floor((1000 - getElementHealth (veh) ) / 1.5)
		h = 1000
	elseif (getElementHealth(veh) < 1700 and json["armor"] == 1) then
		price = math.floor((1700 - getElementHealth (veh)) / 3)
		h = 1700
	end
	
	if (getPlayerMoney(source) >= price) then
		fixVehicle(veh)
		setElementHealth(veh, h)
		takePlayerMoney(source, price, "Transfender")
		Franchise:addShopMoney(source, tbl.price)
	else
		notificationShow(source, "error", "Du hast nicht genügend Geld.")
	end
end)


addEventHandler("onPlayerQuit", root, function()
	local veh	= getPedOccupiedVehicle(source)
	if (veh and getPedOccupiedVehicleSeat(source) == 0) then
		local shop	= getElementData(veh, "inTuning")
		if (shop ~= false) then
			for seat, pl in pairs(getVehicleOccupants(veh)) do
				if (seat > 0) then
					toggleControl(pl, "enter_exit", true)
					local x, y, z = unpack(tuningShops[shop].spawnOut)
					removePedFromVehicle(pl)
					setElementDimension(pl, 0)
					setElementPosition(pl, x, y, z)
				end
			end
			
			tuningDims[getElementDimension(source)] = false
			destroyElement(veh)
		end
	end
end)


addEvent("variantPreview", true)
addEventHandler("variantPreview", root, function(variant)
	local veh = getPedOccupiedVehicle(source)
	if (veh) then
		if (not variant) then variant = nil end
		setVehicleVariant(veh, variant, variant)
	end
end)

--- SPAWN TUNING SHOPS ---
for i, arr in pairs(tuningShops) do
	if (arr.garageID ~= false) then
		setGarageOpen(arr.garageID, true)
	end
	
	local x, y, z	= unpack(arr.pos)
	arr.marker		= createMarker(x, y, z, "cylinder", 4, 255, 0, 0)
	arr.blip		= createBlip(x, y, z, 27, 2, 255, 0, 0, 255, 0, 200, root)
	
	addEventHandler("onMarkerHit", arr.marker, function(player, dim)
		if (player and dim == true and getElementType(player) == "player" and getPedOccupiedVehicleSeat(player) == 0) then
			
			local veh = getPedOccupiedVehicle(player)
			if (veh) then
				
				local vID	= getVehID(veh)
				if (vID and Vehicles[vID].data["owner"] == getPlayerName(player)) then
					setElementFrozen(veh, true)
					showChat(player, false)
					if (getVehicleEngineState(veh) == true) then
						toggleVehicleEngine(player)
					end
					setVehicleOverrideLights(veh, 2)
					toggleNeon(veh, false)
					setElementData(veh, "inTuning", i)
					
					setElementData(player, "currentCID", 12)
					setElementData(player, "currentSID", i)
					triggerEvent("onShopEnter", player, 12, i)
					
					toggleAllControls(player, false, true, true, true)
					
					fadeCamera(player, false, 1, 0, 0, 0)
					setTimer(function()
						setTimer(function()
							fadeCamera(player, true, 1)
						end, 750, 1)
						
						local dim = false
						for k, v in pairs(tuningDims) do
							if (v ~= true) then
								dim = k
								break
							end
						end
						
						tuningDims[dim] = true
						
						if (dim ~= false) then
							for seat, pl in pairs(getVehicleOccupants(veh)) do
								toggleControl(pl, "enter_exit", false)
								setElementDimension(pl, dim)
							end
							
							setElementDimension(player, dim)
							setElementDimension(Vehicles[vID].vehicle, dim)
							--setElementInterior(player, 29)
							--setElementInterior(Vehicles[vID].vehicle, 29)
							toggleNeon(veh, true)
							
							triggerClientEvent(player, "tuningWindow", player, Vehicles[vID].data)
							
							setElementPosition(Vehicles[vID].vehicle, 1504.35, 1318.2, 4419.55)
							setElementRotation(Vehicles[vID].vehicle, 0, 0, 91)
						end
					end, 1000, 1)
					
				else
					notificationShow(player, "error", "Dieses Fahrzeug gehört dir nicht.")
				end
				
			end
			
		end
	end)
end





--[[
	// SPECIAL UPGRADES //
]]--
function addVehicleSpecialUpgrade(veh, cat, id)
	local vID = getVehID(veh)
	if (vID ~= nil) then
		
		if (cat == "gps") then
			Vehicles[vID].hasGPS = true --TODO
			return true
			
		elseif (cat == "armor") then
			Vehicles[vID].panzerung = true
			return setElementHealth(veh, 1700)
			
		elseif (cat == "fuelsave") then
			Vehicles[vID].saveFuel = true
			return true
			
		elseif (cat == "smoker") then
			Vehicles[vID].smokeThrower = true
			setElementData(veh, "smokeThrower", true)
			return true
			
		elseif (cat == "doublewheels") then
			Vehicles[vID].doubleWheels = true
			setElementData(veh, "doubleWheels", true)
			return true
			
		elseif (cat == "tiefer") then
			local handling = getOriginalHandling(getElementModel(veh))
			local sp = math.round(tonumber(handling["suspensionLowerLimit"]), 2)+(0.05*id)
			if (sp == 0) then sp = 0.01 end
			return setVehicleHandling(veh, "suspensionLowerLimit", sp)
			
		elseif (cat == "rearwheelpos" or cat == "frontwheelpos" or cat == "customlights") then
			return setElementData(veh, cat, id)
			
		elseif (cat == "flugelDoors") then
			return setElementData(veh, "flugelDoors", 1)
			
		elseif (cat == "numberplate") then
			return setVehiclePlateText(veh, id)
			
		else
			return false
		end
		
	end
	return false
end

function removeVehicleSpecialUpgrade(veh, cat)
	local vID = getVehID(veh)
	
	if (vID ~= nil) then
		
		if (cat == "gps") then
			Vehicles[vID].hasGPS = false
			return true
			
		elseif (cat == "armor") then
			local h = getElementHealth(veh)
			if (h > 1000) then h = 1000 end
			Vehicles[vID].panzerung = false
			return setElementHealth(veh, h)
			
		elseif (cat == "fuelsave") then
			Vehicles[vID].saveFuel = false
			return true
			
		elseif (cat == "smoker") then
			Vehicles[vID].smokeThrower = false
			setElementData(veh, "smokeThrower", false)
			return true
			
		elseif (cat == "doublewheels") then
			Vehicles[vID].doubleWheels = false
			setElementData(veh, "doubleWheels", false)
			setElementData(veh, "wheelFixes", {0, 0, 0, 0})
			return true
			
		elseif (cat == "tiefer") then
			return setVehicleHandling(veh, "suspensionLowerLimit", nil, false)
			
		elseif (cat == "rearwheelpos" or cat == "frontwheelpos" or cat == "customlights") then
			return setElementData(veh, cat, nil)
			
		elseif (cat == "flugelDoors") then
			return setElementData(veh, "flugelDoors", 0)
			
		elseif (cat == "numberplate") then
			return setVehiclePlateText(veh, "")
			
		else
			return false
		end
		
	end
	return false
end


-- Functions
function updateWheelFixes(veh, fixes)
	local vID = getVehID(veh)
	if (isElement(veh) and vID ~= 0) then
		setElementData(veh, "wheelFixes", fixes)
	end
end
addEvent("updateWheelFixes", true)
addEventHandler("updateWheelFixes", root, updateWheelFixes)

function activateSmokeThrower(player)
	local veh = getPedOccupiedVehicle(player)
	local vID = getVehID(veh)
	
	if (isElement(veh) and tonumber(vID) > 0) then
		
		if (Vehicles[vID].smokeThrower) then
			
			if (getVehicleEngineState(veh)) then
				
				local lastSmoke = getElementData(veh, "lastSmoke") or 0
				local timestamp	= getRealTime().timestamp
				local dis		= timestamp - lastSmoke
				
				if (dis >= (60*15)) then
					
					local smoke1 = createObject(2780, 0, 0, 0)
					local smoke2 = createObject(2780, 0, 0, 0)
					setElementCollisionsEnabled(smoke1, false)
					setElementCollisionsEnabled(smoke2, false)
					setElementAlpha(smoke1, 0)
					setElementAlpha(smoke2, 0)
					
					local hand = getVehicleHandling(veh)
					local rDis = hand["suspensionLowerLimit"]
					local zDis = vehicleCentreOfMass[getElementModel(veh)]
					
					attachElements(smoke1, veh, 0.5, -1.8, -(zDis+rDis))
					attachElements(smoke2, veh, -0.5, -1.8, -(zDis+rDis))
					
					setTimer(function()
						destroyElement(smoke1)
						destroyElement(smoke2)
					end, 1000*10, 1)
					
					setElementData(veh, "lastSmoke", timestamp)
					
				else
					local min = math.ceil( ( (60*15) - dis ) / 60 )
					notificationShow(player, "error", "Der Nebelwerfer ist erst wieder in "..min.." Minuten verfügbar.")
				end
				
			else
				notificationShow(player, "error", "Der Motor muss eingeschaltet sein.")
			end
		else
			notificationShow(player, "error", "In diesem Fahrzeug ist kein Nebelwerfer eingebaut.")
		end
	end
end
addCommandHandler("smoke", activateSmokeThrower)

local noSpam = {}
local function customHorn(player)
	if (player and isPedInVehicle(player)) then
		if (noSpam[player] ~= true) then
			local veh		= getPedOccupiedVehicle(player)
			local vID		= getVehID(veh)
			if (vID) then
				local json = fromJSON(Vehicles[vID].data["specialupgrades"])
				if (json["hornsound"] ~= "" and json["hornsound"] ~= 0 and json["hornsound"] ~= nil) then
					local x, y, z		= getElementPosition(player)
					local chatSphere	= createColSphere(x, y, z, 50)
					for _, nearbyPlayer in ipairs(getElementsWithinColShape(chatSphere, "player")) do
						triggerClientEvent(nearbyPlayer, "playCustomHorn", nearbyPlayer, veh, json["hornsound"])
					end
					destroyElement(chatSphere)
					
					local lng = 3000
					for k, v in pairs(specialTuningUpgrades) do
						if (v.title == "Hupe") then
							for kk, vv in pairs(v.upgrades) do
								if (vv.soundfile == json["hornsound"]) then
									lng = vv.length
									break
								end
							end
							break
						end
					end
					
					noSpam[player] = true
					setTimer(function()
						noSpam[player] = false
					end, lng, 1)
					
				end
			end
		end
	end
end
addEventHandler("onPlayerVehicleEnter", root, function(veh, seat)
	local vID = getVehID(veh)
	if (vID and seat == 0) then
		local json = fromJSON(Vehicles[vID].data["specialupgrades"])
		if (json["hornsound"] ~= "" and json["hornsound"] ~= 0 and json["hornsound"] ~= nil) then
			toggleControl(source, "horn", false)
			bindKey(source, "horn", "down", customHorn)
		else
			toggleControl(source, "horn", true)
		end
	end
end)
addEventHandler("onPlayerVehicleExit", root, function(veh, seat)
	toggleControl(source, "horn", true)
	unbindKey(source, "horn", "down", customHorn)
end)



--[[
	// PERFORMANCE UPGRADES //
]]--
-- http://projectcerbera.com/gta/sa/tutorials/handling
function setVehicleHandlingFlags(vehicle, byte, value)
	if vehicle then
		local handlingFlags = string.format("%X", getVehicleHandling(vehicle)["handlingFlags"])
		local reversedFlags = string.reverse(handlingFlags) .. string.rep("0", 8 - string.len(handlingFlags))
		local currentByte, flags = 1, ""
		
		for values in string.gmatch(reversedFlags, ".") do
			if type(byte) == "table" then
				for _, v in ipairs(byte) do
					if currentByte == v then
						values = string.format("%X", tonumber(value))
					end
				end
			else
				if currentByte == byte then
					values = string.format("%X", tonumber(value))
				end
			end
			
			flags = flags .. values
			currentByte = currentByte + 1
		end
		
		setVehicleHandling(vehicle, "handlingFlags", tonumber("0x" .. string.reverse(flags)))
	end
end
function setVehicleModelFlags(vehicle, byte, value)
	if vehicle then
		local modelFlags = string.format("%X", getVehicleHandling(vehicle)["modelFlags"])
		local reversedFlags = string.reverse(modelFlags) .. string.rep("0", 8 - string.len(modelFlags))
		local currentByte, flags = 1, ""
		
		for values in string.gmatch(reversedFlags, ".") do
			if type(byte) == "table" then
				for _, v in ipairs(byte) do
					if currentByte == v then
						values = string.format("%X", tonumber(value))
					end
				end
			else
				if currentByte == byte then
					values = string.format("%X", tonumber(value))
				end
			end
			
			flags = flags .. values
			currentByte = currentByte + 1
		end
		
		setVehicleHandling(vehicle, "modelFlags", tonumber("0x" .. string.reverse(flags)))
	end
end

function addVehiclePerformanceUpgrade(veh, cat, id)
	local vID = getVehID(veh)
	if (vID ~= nil) then
		
		local multi = 0
		if (id == "street") then
			multi = 1
		elseif (id == "pro") then
			multi = 2
		elseif (id == "extreme") then
			multi = 3
		end
		
		if (cat == "motor") then
			setVehicleHandling(veh, "maxVelocity", nil, false) --reset
			setVehicleHandling(veh, "engineAcceleration", nil, false) --reset
			setVehicleHandling(veh, "engineInertia", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			setVehicleHandling(veh, "maxVelocity", handling["maxVelocity"]+30/3*multi)
			setVehicleHandling(veh, "engineAcceleration", handling["engineAcceleration"]/handling["maxVelocity"]*(handling["maxVelocity"]+100/3*multi))
			setVehicleHandling(veh, "engineInertia", handling["engineInertia"]/handling["maxVelocity"]*(handling["maxVelocity"]+30/3*multi))
			
		elseif (cat == "turbo") then -- geht net
			--setVehicleHandling(veh, "engineInertia", nil, false)
			--local handling = getOriginalHandling(getElementModel(veh))
			--return setVehicleHandling(veh, "engineInertia", handling["engineInertia"]-(10*multi))
			
		elseif (cat == "nitro") then
			return addVehicleUpgrade(veh, id)
			
		elseif (cat == "bremse") then -- geht net
			--[[setVehicleHandling(veh, "brakeDeceleration", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			setVehicleHandling(veh, "brakeDeceleration", handling["brakeDeceleration"]+(0.06*multi))
			
			setVehicleHandling(veh, "brakeBias", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			return setVehicleHandling(veh, "brakeBias", handling["brakeBias"]+(0.15*multi))]]
			-- Bekommt man net richtig hin, entweder wird geschwindigkeit zu schnell, lenkkreis zu groß oder das ding kippt um.
			
		elseif (cat == "traktion") then
			if (id == "street") then
				multi = 1
			elseif (id == "pro") then
				multi = 2
			elseif (id == "extreme") then
				multi = 3
			end
			setVehicleHandling(veh, "tractionMultiplier", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			setVehicleHandling(veh, "tractionMultiplier", handling["tractionMultiplier"]+(0.01*multi))
			
			setVehicleHandling(veh, "tractionLoss", nil, false) --reset
			handling = getOriginalHandling(getElementModel(veh))
			return setVehicleHandling(veh, "tractionLoss", handling["tractionLoss"]+(0.01*multi))
			
		elseif (cat == "weight") then
			setVehicleHandling(veh, "mass", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			return setVehicleHandling(veh, "mass", handling["mass"]-(133.33*multi))
			
		elseif (cat == "offroad") then
			local val = 0
			if (id == "dirt") then
				val = 1
			elseif (id == "sand") then
				val = 2
			end
			return setVehicleHandlingFlags(veh, 6, val)
			
		elseif (cat == "antrieb") then
			setVehicleHandling(veh, "driveType", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			local val = handling["driveType"]
			if (id == "front") then
				val = "fwd"
			elseif (id == "heck") then
				val = "rwd"
			elseif (id == "allrad") then
				val = "awd"
			end
			return setVehicleHandling(veh, "driveType", val)
			
		elseif (cat == "lenkung") then
			setVehicleHandling(veh, "steeringLock", nil, false) --reset
			local handling = getOriginalHandling(getElementModel(veh))
			return setVehicleHandling(veh, "steeringLock", handling["steeringLock"]+id)
			
		else
			return false
		end
		
	end
	return false
end

function removeVehiclePerformanceUpgrade(veh, cat)
	local vID = getVehID(veh)
	
	if (vID ~= nil) then
		
		
		if (cat == "motor") then
			return setVehicleHandling(veh, "maxVelocity", nil, false) --reset
			
		elseif (cat == "turbo") then
			return setVehicleHandling(veh, "engineInertia", nil, false) --reset
			
		elseif (cat == "nitro") then
			removeVehicleUpgrade(veh, 1008)
			removeVehicleUpgrade(veh, 1009)
			removeVehicleUpgrade(veh, 1010)
			return true
			
		elseif (cat == "bremse") then
			setVehicleHandling(veh, "brakeDeceleration", nil, false) --reset
			return setVehicleHandling(veh, "brakeBias", nil, false) --reset
			
		elseif (cat == "antriebsboost") then
			return setVehicleHandlingFlags(veh, 1, 0)
			
		elseif (cat == "traktion") then
			setVehicleHandling(veh, "tractionMultiplier", nil, false) --reset
			return setVehicleHandling(veh, "tractionLoss", nil, false) --reset
			
		elseif (cat == "weight") then
			return setVehicleHandling(veh, "mass", nil, false) --reset
			
		elseif (cat == "offroad") then
			return setVehicleHandlingFlags(veh, 6, 0)
			
		elseif (cat == "antrieb") then
			return setVehicleHandling(veh, "driveType", nil, false) --reset
			
		elseif (cat == "lenkung") then
			return setVehicleHandling(veh, "steeringLock", nil, false) --reset
			
		else
			return false
		end
	end
	return false
end









-- CREATE TUNING DIMS
local intObjects = {
	{14776,1508.0000000,1320.2002000,4424.2998000,0.0000000,0.0000000,271.5000000}, --object(int3int_carupg_int) (1)
	{14826,1509.4000000,1307.7000000,4418.3799000,0.0000000,0.0000000,272.0000000}, --object(int_kbsgarage2) (1)
	{1097,1492.2000000,1310.4000000,4420.3999000,0.0000000,0.0000000,0.0000000}, --object(wheel_gn4) (1)
	{1097,1492.2000000,1311.6000000,4420.3999000,0.0000000,0.0000000,0.0000000}, --object(wheel_gn4) (2)
	{1084,1492.1000000,1312.8000000,4420.2002000,0.0000000,0.0000000,0.0000000}, --object(wheel_lr5) (1)
	{1082,1492.2000000,1311.0000000,4421.6001000,0.0000000,0.0000000,0.0000000}, --object(wheel_gn1) (1)
	{1081,1492.1000000,1312.4000000,4421.3999000,0.0000000,0.0000000,0.0000000}, --object(wheel_sr4) (1)
	{6959,1499.9004000,1320.9004000,4417.8301000,0.0000000,0.0000000,2.0000000}, --object(vegasnbball1) (3)
	{17969,1517.5000000,1312.4000000,4420.6001000,0.0000000,0.0000000,0.0000000}, --object(hub_graffitti) (1)
	{17969,1511.0000000,1328.3000000,4421.0000000,0.0000000,0.0000000,1.0000000}, --object(hub_graffitti) (2)
	{1525,1517.4000000,1320.4000000,4420.2998000,0.0000000,0.0000000,0.0000000}, --object(tag_kilo) (1)
	{1528,1510.4000000,1334.2000000,4421.5000000,0.0000000,0.0000000,0.0000000}, --object(tag_seville) (1)
	{1527,1510.4000000,1334.6000000,4420.7998000,0.0000000,0.0000000,0.0000000}, --object(tag_rollin) (1)
	{1490,1511.7998000,1302.0000000,4420.8999000,0.0000000,0.0000000,272.0000000}, --object(tag_01) (1)
	{1531,1514.7000000,1302.1000000,4419.7998000,0.0000000,0.0000000,272.0000000}, --object(tag_azteca) (1)
	{1528,1514.2000000,1302.0000000,4419.7002000,0.0000000,0.0000000,271.7500000}, --object(tag_seville) (2)
	{1525,1514.9000000,1302.1000000,4419.2998000,0.0000000,0.0000000,270.7500000}, --object(tag_kilo) (2)
	{1530,1498.1000000,1333.2000000,4420.0000000,0.0000000,0.0000000,92.0000000}, --object(tag_vagos) (1)
	{955,1511.5000000,1322.9000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(cj_ext_sprunk) (1)
	{956,1512.8000000,1322.9000000,4418.2002000,0.0000000,0.0000000,0.5000000}, --object(cj_ext_candy) (1)
	{952,1509.4004000,1335.5996000,4419.1001000,0.0000000,0.0000000,0.0000000}, --object(generator_big_d) (1)
	{921,1511.3000000,1323.2000000,4421.6001000,0.0000000,0.0000000,0.0000000}, --object(cj_ind_light) (1)
	{917,1500.1000000,1332.8000000,4418.0000000,0.0000000,0.0000000,0.0000000}, --object(fruitcrate1) (1)
	{917,1500.3000000,1332.2000000,4418.0000000,0.0000000,0.0000000,32.0000000}, --object(fruitcrate1) (2)
	{3302,1493.7002000,1332.0000000,4417.8501000,0.0000000,0.0000000,0.0000000}, --object(cxrf_corpanel) (1)
	{3302,1495.1000000,1332.6000000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(cxrf_corpanel) (2)
	{1462,1502.2002000,1332.9004000,4417.7998000,0.0000000,0.0000000,0.0000000}, --object(dyn_woodpile) (1)
	{1442,1503.5000000,1332.9000000,4418.3999000,0.0000000,0.0000000,0.0000000}, --object(dyn_firebin0) (1)
	{1441,1493.8000000,1301.7000000,4418.5000000,0.0000000,0.0000000,0.0000000}, --object(dyn_box_pile_4) (1)
	{1440,1494.4000000,1304.5000000,4418.2998000,0.0000000,0.0000000,0.0000000}, --object(dyn_box_pile_3) (1)
	{1438,1496.0000000,1302.8000000,4417.7998000,0.0000000,0.0000000,0.0000000}, --object(dyn_box_pile_2) (1)
	{1370,1505.0996000,1309.7998000,4418.2998000,0.0000000,0.0000000,0.0000000}, --object(cj_flame_drum) (1)
	{1370,1504.4000000,1310.4000000,4418.2998000,0.0000000,0.0000000,0.0000000}, --object(cj_flame_drum) (2)
	{1369,1509.7000000,1326.1000000,4418.3999000,0.0000000,0.0000000,287.0000000}, --object(cj_wheelchair1) (1)
	{1349,1496.9000000,1332.7000000,4418.3999000,0.0000000,0.0000000,0.0000000}, --object(cj_shtrolly) (1)
	{1327,1510.3000000,1331.7000000,4418.6001000,0.0000000,0.0000000,5.2500000}, --object(junk_tyre) (1)
	{1327,1510.6000000,1329.8000000,4418.6001000,0.0000000,0.0000000,6.0000000}, --object(junk_tyre) (2)
	{2670,1499.7002000,1331.2998000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(proc_rubbish_1) (1)
	{2673,1508.0000000,1330.4000000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(proc_rubbish_5) (1)
	{3594,1502.8000000,1308.0000000,4418.3999000,0.0000000,0.0000000,276.0000000}, --object(la_fuckcar1) (1)
	{1428,1499.3000000,1333.0000000,4419.3999000,0.0000000,0.0000000,0.0000000}, --object(dyn_ladder) (1)
	{1217,1515.7000000,1311.8000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (2)
	{1225,1495.5000000,1305.5000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(barrel4) (1)
	{1217,1495.3000000,1307.0000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (3)
	{2921,1510.7000000,1323.6000000,4421.8999000,0.0000000,0.0000000,0.0000000}, --object(kmb_cam) (1)
	{1650,1505.5000000,1329.7000000,4418.1001000,0.0000000,0.0000000,0.0000000}, --object(petrolcanm) (1)
	{1650,1505.2998000,1329.9004000,4418.1001000,0.0000000,0.0000000,0.0000000}, --object(petrolcanm) (2)
	{2057,1500.5000000,1309.3000000,4418.0000000,0.0000000,0.0000000,0.0000000}, --object(flame_tins) (1)
	{2690,1503.5000000,1330.3000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(cj_fire_ext) (1)
	{1712,1498.2998000,1332.4004000,4417.7998000,0.0000000,0.0000000,0.0000000}, --object(kb_couch05) (1)
	{1172,1505.8000000,1309.5000000,4418.2998000,0.0000000,0.0000000,353.9960000}, --object(fbmp_c_l) (1)
	{1169,1511.3000000,1310.1000000,4418.3999000,0.0000000,0.0000000,0.0000000}, --object(fbmp_a_s) (1)
	{1081,1493.1000000,1311.7000000,4418.2998000,0.0000000,0.0000000,0.0000000}, --object(wheel_sr4) (2)
	{1217,1515.7000000,1312.6000000,4418.2002000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (5)
	{1217,1496.9000000,1307.4000000,4422.1001000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (6)
	{1217,1497.7000000,1308.0000000,4422.1001000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (7)
	{1217,1496.2998000,1308.2002000,4422.1001000,0.0000000,0.0000000,0.0000000}, --object(barrel2) (8)
	{3497,1514.4000000,1302.3000000,4422.3999000,0.0000000,0.0000000,0.0000000}, --object(vgsxrefbballnet2) (1)
	{3111,1493.5000000,1332.2000000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(st_arch_plan) (1)
	{3017,1505.0000000,1330.9000000,4419.2002000,0.0000000,0.0000000,0.0000000}, --object(arch_plans) (1)
	{3017,1504.7002000,1330.5000000,4419.2002000,0.0000000,0.0000000,0.0000000}, --object(arch_plans) (2)
	{3017,1505.4000000,1331.2000000,4419.2002000,0.0000000,0.0000000,0.0000000}, --object(arch_plans) (3)
	{2919,1494.7000000,1303.1000000,4422.2998000,0.0000000,0.0000000,0.0000000}, --object(kmb_holdall) (1)
	{2255,1493.4000000,1337.5000000,4420.1001000,0.0000000,0.0000000,0.0000000}, --object(frame_clip_2) (1)
	{2238,1506.0000000,1330.5000000,4419.5000000,0.0000000,0.0000000,0.0000000}, --object(cj_lava_lamp) (1)
	{2115,1508.7000000,1327.6000000,4417.7998000,0.0000000,0.0000000,0.0000000}, --object(low_dinning_1) (1)
	{1650,1508.5000000,1327.6000000,4418.1001000,0.0000000,0.0000000,0.0000000}, --object(petrolcanm) (3)
	{1650,1509.2000000,1327.5000000,4418.1001000,0.0000000,0.0000000,0.0000000}, --object(petrolcanm) (4)
	{1768,1499.1000000,1308.3000000,4421.7002000,0.0000000,0.0000000,0.0000000}, --object(low_couch_3) (1)
	{1737,1499.5000000,1306.9000000,4421.7002000,0.0000000,0.0000000,0.0000000}, --object(med_dinning_5) (1)
	{10281,1503.3000000,1337.4000000,4423.5000000,0.0000000,0.0000000,0.0000000}, --object(michsign_sfe) (1)
	{2692,1508.7000000,1332.2000000,4418.5000000,0.0000000,0.0000000,0.0000000}, --object(cj_banner10) (1)
	{1229,1514.6000000,1323.3000000,4419.3999000,0.0000000,0.0000000,0.0000000}, --object(bussign1) (1)
	{1233,1514.6000000,1323.1000000,4419.3999000,0.0000000,0.0000000,0.0000000}, --object(noparkingsign1) (1)
	{1260,1490.0000000,1318.8000000,4430.2998000,0.0000000,0.0000000,0.0000000}, --object(billbd3) (1)
	{1260,1489.4000000,1328.3000000,4430.2998000,0.0000000,0.0000000,0.0000000}, --object(billbd3) (2)
	{1443,1491.9000000,1329.8000000,4418.3999000,0.0000000,0.0000000,0.0000000}, --object(dyn_street_sign_1) (1)
	{2714,1505.9000000,1333.4000000,4420.7998000,0.0000000,0.0000000,0.0000000}, --object(cj_open_sign_2) (1)
	{3096,1492.0000000,1317.9000000,4424.7002000,0.0000000,0.0000000,272.0000000}, --object(bb_pickup) (1)
	{1486,1500.1000000,1331.9000000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(dyn_beer_1) (1)
	{2670,1503.2000000,1329.9000000,4417.8999000,0.0000000,0.0000000,0.0000000}, --object(proc_rubbish_1) (2)
	{1337,1518.3681600,1279.4364000,1724.3962400,0.0000000,0.0000000,0.0000000}, --object(binnt07_la) (2)
	--{3945,1509.2031300,1318.3017600,4427.9492200,0.0000000,0.0000000,0.0000000}, --object(alpha_fence) (1)
	{974,1507.1000000,1318.1000000,4418.5000000,90.0000000,0.0000000,0.0000000}, --object(tall_fence) (1)
	{974,1500.4000000,1318.2000000,4418.5000000,90.0000000,0.0000000,0.0000000}, --object(tall_fence) (2)
}
for k, v in pairs(intObjects) do
	for kk, vv in pairs(tuningDims) do
		local obj = createObject(unpack(v))
		setElementInterior(obj, 0)
		setElementDimension(obj, kk)
		if (v[1] == 974) then
			setElementAlpha(obj, 0)
		end
	end
end
















--[[
addCommandHandler("mflag", function(p, _, a1, a2)
	local v = getPedOccupiedVehicle(p)
	if (v) then
		setVehicleModelFlags(v, a1, a2)
		outputChatBox("[model]: "..a1.." to "..a2)
		local handlingFlags = string.format("%X", getVehicleHandling(v)["modelFlags"])
		outputChatBox(handlingFlags)
	end
end)
addCommandHandler("hflag", function(p, _, a1, a2)
	local v = getPedOccupiedVehicle(p)
	if (v) then
		setVehicleHandlingFlags(v, a1, a2)
		outputChatBox("[handling]: "..a1.." to "..a2)
		local handlingFlags = string.format("%X", getVehicleHandling(v)["handlingFlags"])
		outputChatBox(handlingFlags)
	end
end)

addCommandHandler("setperf", function(p, _, k, v)
	removeVehiclePerformanceUpgrade(getPedOccupiedVehicle(p), k)
	addVehiclePerformanceUpgrade(getPedOccupiedVehicle(p), k, v)
	outputChatBox("setperf: "..k.." to "..v)
end)

addCommandHandler("pruf", function(p)
	local veh = getPedOccupiedVehicle(p)
	setElementPosition(veh, 1476.96484375,1280.3649902344,15.5)
	setElementRotation(veh, 0, 0, 360)
	setTimer(function()
		triggerClientEvent(p, "cPruf", p)
	end, 1500, 1)
	
end)]]