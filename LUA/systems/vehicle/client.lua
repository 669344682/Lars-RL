----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function showVehicleInfos(vehData)
	if (windowOpen ~= false) then return end
	local tabElements = {}
	local curTab = 0
	local isAdmin = false
	local hPlus = 0
	if (getElementData(localPlayer, "Adminlvl") >= 1) then isAdmin = true hPlus = 100 end
	local window = dxWindow:new("Fahrzeugmenü", nil, nil, 350, 175+hPlus)
	
	local function changeTab(what)
	if (curTab == what) then return end
	for k,v in pairs(tabElements) do
		v:delete()
		tabElements[k] = nil
	end
	
	if (what == 1) then
		window:setTitle("Fahrzeugmenü")
		if (getElementData(localPlayer, "Adminlvl") >= 1) then isAdmin = true window:resize(350, 275) end
		
		tabElements['owner_txt'] = dxText:new(18, 15, 15, 10, "Besitzer:", window, "left", 1, nil, nil, false)
		tabElements['ctype_txt'] = dxText:new(18, 35, 15, 10, "Modell:", window, "left", 1, nil, nil, false)
	
		tabElements['slot_txt'] = dxText:new(18, 55, 15, 10, "Slot:", window, "left", 1, nil, nil, false)
		tabElements['tank_txt'] = dxText:new(18, 75, 15, 10, "Tankinhalt:", window, "left", 1, nil, nil, false)
		tabElements['km_txt'] = dxText:new(18, 95, 15, 10, "Kilometer:", window, "left", 1, nil, nil, false)
	
		tabElements['owner_val'] = dxText:new(105, 35, 15, 10, getVehicleNameFromModel(vehData["typ"]), window, "left", 1, nil, nil, false)
		tabElements['ctype_val'] = dxText:new(105, 15, 15, 10, vehData["owner"], window, "left", 1, nil, nil, false)
		tabElements['slot_val'] = dxText:new(105, 55, 15, 10, "#"..vehData["slot"], window, "left", 1, nil, nil, false)
		tabElements['tank_val'] = dxText:new(105, 75, 15, 10, math.floor(vehData["fuel"]).." Liter (Super)", window, "left", 1, nil, nil, false)
		tabElements['km_val'] = dxText:new(105, 95, 15, 10, setDotsInNumber(math.round(vehData["meters"]/1000)).." KM", window, "left", 1, nil, nil, false)
	

		tabElements['respawn'] = dxButton:new(230, 15, 100, 20, "Respawnen", window, (function()
			triggerServerEvent("respawnVehicle", localPlayer, vehData["ID"]) window:delete()
		end))
	
		tabElements['park'] = dxButton:new(230, 40, 100, 20, "Parken", window, 
		(function()
		if vehData["owner"] == getPlayerName(localPlayer) then 
				triggerServerEvent("parkVehicle", localPlayer, localPlayer, "park", vehData["slot"])
				window:delete()
			else 
				notificationShow("error", "Dieses Fahrzeug gehört dir nicht.")
			end
		end))
	
		tabElements['key'] = dxButton:new(230, 65, 100, 20, "Schlüssel", window,
		(function()
		if vehData["owner"] == getPlayerName(localPlayer) then 
				changeTab(3)
			else 
				notificationShow("error", "Dieses Fahrzeug gehört dir nicht.")
			end
		end))
	
		tabElements['tunings'] = dxButton:new(230, 90, 100, 20, "Tunings", window, (function() changeTab(2); end))
	
		-- Bottom (Admin)
		if (isAdmin) then
			tabElements['admin'] = dxText:new(0, 125, 350, 13, "Admin", window, "center", 1, nil, nil, false)
			tabElements['reason'] = dxEdit:new(5, 150, 340, 20, window)
			tabElements['admin_delete'] = dxButton:new(5, 190, 100, 30, "Löschen", window, (function() local reason = tabElements['reason']:getText(); triggerServerEvent("adminDeleteCar", localPlayer, vehData["ID"], reason) window:delete() end), nil, nil, 1)
			tabElements['admin_unspawn'] = dxButton:new(125, 190, 100, 30, "Unspawnen", window, (function() triggerServerEvent("adminUnspawnCar", localPlayer, vehData["ID"]) window:delete() end), nil, nil, 1)
			tabElements['admin_respawn'] = dxButton:new(245, 190, 100, 30, "Respawnen", window, (function() triggerServerEvent("adminRespawnCar", localPlayer, vehData["ID"]) window:delete() end), nil, nil, 1)
		end
	
		elseif (what == 2) then
			local tunings = {}
			window:setTitle("Tunings")
			window:resize(350, 230)
			
			tunings["special"]		= fromJSON(vehData["specialupgrades"])
			tunings["performance"]	= fromJSON(vehData["performanceupgrades"])
			
			local rand = 5
			local entries = {
				{"Motor",		tunings["performance"]["motor"]},
				{"Traktion",	tunings["performance"]["traktion"]},
				{"Nitro", 		tunings["performance"]["nitro"]},
				{"Gewichtsr.",	tunings["performance"]["weight"]},
				{"Reifentyp",	tunings["performance"]["offroad"]},
				{"Antriebstyp",	tunings["performance"]["antrieb"]},
				{"Lenkwinkel",	tunings["performance"]["lenkung"]},
			}
			for k, v in ipairs(entries) do
				tabElements[(k)..'1'] = dxText:new(18, 15*(k)+(3*(k-1)), 15, 10, v[1]..":", window, "left", 1, 'exo-bold-10', nil, false)
			
				if (v[2] == "street") then
					v[2] = "Street"
				elseif (v[2] == "pro") then
					v[2] = "Pro"
				elseif (v[2] == "extreme") then
					v[2] = "Extreme"
				elseif (v[2] == "heck") then
					v[2] = "Heck"
				elseif (v[2] == "front") then
					v[2] = "Front"
				elseif (v[2] == "allrad") then
					v[2] = "Allrad"
				elseif (v[2] == "dirt") then
					v[2] = "Dreck"
				elseif (v[2] == "sand") then
					v[2] = "Sand"
				elseif (v[2] == 1010) then
					v[2] = "Extreme"
				elseif (v[2] == 1009) then
					v[2] = "Pro"
				elseif (v[2] == 1008) then
					v[2] = "Street"
				elseif (v[1] == "Lenkwinkel" and tonumber(v[2]) ~= nil) then
					v[2] = v[2].."°"
				else
					v[2] = "✘"
				end
				tabElements[(k)..'2'] = dxText:new(120, 15*(k)+(3*(k-1)), 15, 10, v[2], window, "left", 1, nil, nil, false)
			end
		
			local entries = {"Navi", "Panzer.", "Benziners.", "Nebelw.", "Doppelr.", "Flügelt.", "Tieferl."}
			local entries = {
				{"Navi",		tunings["special"]["gps"]},
				{"Panzerung",	tunings["special"]["armor"]},
				{"Benziners.",	tunings["special"]["fuelsave"]},
				{"Nebelw.",		tunings["special"]["smoker"]},
				{"Doppelr.",	tunings["special"]["doublewheels"]},
				{"Flügelt.",	tunings["special"]["flugelDoors"]},
				{"Tieferl.",	tunings["special"]["tiefer"]},
			}
			for k, v in ipairs(entries) do
			tabElements[(k)..'3'] = dxText:new(200, 15*(k)+(3*(k-1)), 15, 10, v[1]..":", window, "left", 1, 'exo-bold-10', nil, false)
			
				if (v[1] == "Tieferl.") then
					if (tonumber(v[2]) ~= nil and tonumber(v[2]) > 0) then
						v[2] = "Stufe "..v[2]
					else
						v[2] = "✘"
					end
				elseif (tonumber(v[2]) == 1) then
					v[2] = "✔"
				else
					v[2] = "✘"
				end
				tabElements[(k)..'4'] = dxText:new(290, 15*(k)+(3*(k-1)), 15, 10, v[2], window, "left", 1, nil, nil, false)
			end
			
			tabElements['back'] = dxButton:new(230, 150, 100, 20, "Zurück", window, (function() changeTab(1); if not (isAdmin) then window:resize(350, 175) end; end))
			
		elseif (what == 3) then
			window:setTitle("Schlüssel")
			window:resize(350, 250)
			
			tabElements['key_txt'] = dxText:new(18, 50, 15, 10, "Vergebene Schlüssel:", window, "left", 1, nil, nil, false)
			tabElements['grid'] = dxGrid:new(18, 75, 180, 120, window, nil)
			tabElements['grid']:addColumn({{"Spieler", 0}})
			
			tabElements['edit'] = dxEdit:new(18, 10, 180, 20, window)
			
			tabElements['addPlayer'] = dxButton:new(230, 10, 100, 25, "Hinzufügen", window, (function()
				local target = tabElements['edit']:getText()
				triggerServerEvent("addVehKey", localPlayer, vehData["ID"], target)
			end))
			
			
			tabElements['removePlayer'] = dxButton:new(230, 80, 100, 25, "Entfernen", window, (function()
				local id, val = tabElements['grid']:getSelected()
				if (val and id) then
					triggerServerEvent("remVehKey", localPlayer, vehData["ID"], val[id])
				end
			end))
			
			local vk = fromJSON(vehData["vkeys"])
			for k, v in pairs(vk) do
				if (v == true) then
					tabElements['grid']:addItem({k})
				end
			end
			
			tabElements['back'] = dxButton:new(230, 160, 100, 20, "Zurück", window, (function() changeTab(1); if not (isAdmin) then window:resize(350, 175) end; end))
		end
		curTab = what
	end
	changeTab(1)
end
addEvent("showVehicleInfos", true)
addEventHandler("showVehicleInfos", root, showVehicleInfos)


addEventHandler("onClientKey", root, function(button, press) 
	local controls = getBoundKeys("handbrake")
	if (type(controls[button]) == "string") then
		local veh = getPedOccupiedVehicle(localPlayer)
		if (veh and getElementData(getPedOccupiedVehicle(localPlayer), "handbrake") == true) then
			cancelEvent()
		end
    end
end)

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh and getElementData(getPedOccupiedVehicle(localPlayer), "handbrake") == true) then
		setControlState("handbrake", true)
	end
end)



-- Tempomat
local maxSpeed = false
addEventHandler("onClientRender", root, function()
	if (tonumber(maxSpeed) ~= nil) then
		local veh = getPedOccupiedVehicle(localPlayer)
		if (veh and getPedOccupiedVehicleSeat(localPlayer) == 0) then
			local kmh = getElementSpeed(veh)
			if (kmh > maxSpeed) then
				setElementSpeed(veh, 0, maxSpeed)				
			end
		end
	end
end)
function setMaxSpeed(kmh)
	maxSpeed = kmh
end