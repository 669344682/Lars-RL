----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local DATA = {
	current		= "mainMenu",
	last		= "",
	lastSel		= 1,
	currentMenu	= {},
	currentSel	= 1,
	startID		= 1,
	endID		= 10,
	maxEntries	= 10,
	currentCat	= "Kategorien",
	lastCat		= "",
	canMove		= true,
	music		= nil,
	lastMusic	= nil,
	curCamPos	= "",
	canMoveCam	= true,
	
	mainMenu	= {
		{
			title 	= "Performance",
			typ		= "mainCat",
		},
		{
			title	= "Spezial",
			typ		= "mainCat",
		},
		{
			title	= "Optisch",
			typ		= "mainCat",
		},
		{
			title	= "Lackierung",
			typ		= "mainCat",
			--[[
				Vehiclecolor
			]]
		}
	},
	
	upgradeTables	= {},
	colorPicker		= nil,
	colorPickerSel	= nil,
	colorPickerTyp	= "",
	
	editBox			= nil,
	editBoxSel		= nil,
	
	oriVehicleColor = {},
	oriLightColor	= {},
	
	buyedUpgrades	= {},
	buyedPerformance= {},
	buyedSpecial	= {},
	vehicle			= nil,
	vehData			= {},
	hornSound		= nil,
}
local FONTS = {
	chalet = dxCreateFont("files/fonts/chalet.ttf", 24, false, "antialiased"),
}

local function setDefaultColor()
	local veh = DATA.vehicle
	setVehicleColor(veh, DATA.oriVehicleColor[1], DATA.oriVehicleColor[2], DATA.oriVehicleColor[3], DATA.oriVehicleColor[4], DATA.oriVehicleColor[5], DATA.oriVehicleColor[6], DATA.oriVehicleColor[7], DATA.oriVehicleColor[8], DATA.oriVehicleColor[9])
	setVehicleHeadLightColor(veh, DATA.oriLightColor[1], DATA.oriLightColor[2], DATA.oriLightColor[3])
end

--look rot: 90 nach westen
--westen / rear : 90
--süden / links: 180
--noden / rechts: 0
--osten / front: 270

function getVehicleComponentWorldPosRot(veh, component)
	local vX, vY, vZ	= getElementPosition(veh)
	local vrX, vrY, vrZ = getElementRotation(veh)
	local wX, wY, wZ	= getVehicleComponentPosition(veh, component, "world")
	local _, _, wrZ 	= 0, 0, 0
	
	local direction = "front"
	wrZ				= vrZ+180
	if (string.find(component, "_lf") or string.find(component, "_lr") or string.find(component, "left")) then
		direction	= "left"
		wrZ			= vrZ+90
	elseif (string.find(component, "_lr") or string.find(component, "_rr") or string.find(component, "right")) then
		direction = "right"
		wrZ			= vrZ-90
	elseif (string.find(component, "rear") or string.find(component, "boot") or string.find(component, "boot") or string.find(component, "exhaust") or string.find(component, "nitro")) then
		direction = "rear"
		wrZ			= vrZ-180
	end
	
	return wX, wY, wZ, wrZ
end

-- default pos: {"bonnet_dummy", -5.5, -3.5, 2.5, false}
local moveTimer = nil
function moveToComponent(component, offX, offY, offZ, hide)
	offX = tonumber(offX)
	offY = tonumber(offY)
	offZ = tonumber(offZ)
	
	local cX, cY, cZ, lX, lY, lZ	= getCameraMatrix()
	local wX, wY, wZ, wrZ			= getVehicleComponentWorldPosRot(getPedOccupiedVehicle(localPlayer), component)
	local x, y, z					= 0, 0, 0
	if (not wX) then
		wX, wY, wZ, wrZ = getVehicleComponentWorldPosRot(getPedOccupiedVehicle(localPlayer), component)
	end
	if (offX < 0) then x = wX-(offX*-1) else x = wX+offX end
	if (offY < 0) then y = wY-(offY*-1) else y = wY+offY end
	if (offZ < 0) then z = wZ-(offZ*-1) else z = wZ+offZ end
	
	DATA.curCamPos = tostring(component..offX..offY..offZ)
	
	killTimer(moveTimer)
	moveTimer = setTimer(function()
		smoothMoveCamera(cX, cY, cZ, lX, lY, lZ, x, y, z, wX, wY, wZ, 1000)
	end, 250, 1)
	--[[DATA.canMove = false
	setTimer(function()
		DATA.canMove = true
	end, 1100, 1)]]
end

--addCommandHandler("mvtest", function(_, c, x, y, z)
--	moveToComponent(c, x, y, z, false)
--end)




local entryCount	= 0
local panelWidth	= 350
local rowHeight		= 35
local bgX, bgY		= 32, 32
local function renderTuning()
	
	-- BACKGROUND
	dxDrawRectangle(bgX, bgY, panelWidth, 175+rowHeight, tocolor(0, 0, 0, 200))
	dxDrawImage(bgX, bgY, panelWidth, 175, "files/images/tuning/sl-performance.png")
	
	dxDrawRectangle(bgX, bgY+175, panelWidth, rowHeight, tocolor(0, 0, 0, 230)) -- CATEGORY
	dxDrawText(utf8.upper(DATA.currentCat), bgX+10, bgY+175, bgX+330, bgY+175+rowHeight, tocolor(255,255,255,255), 0.5, FONTS.chalet, "left", "center")
	dxDrawText(DATA.currentSel.." / "..#DATA.currentMenu, bgX+10, bgY+175, bgX+335, bgY+175+rowHeight, tocolor(255,255,255,255), 0.5, FONTS.chalet, "right", "center")
	
	--hideSpeedometer()
	--hideCustomRadar()
	
	-- Entries
	local updatePicker	= false
	local newPicker		= false
	local updateEdit	= false
	local newEdit		= false
	entryCount = 0
	local black = false
	local eY = (bgY+175+rowHeight)
	for i, arr in ipairs(DATA.currentMenu) do
		if (i >= DATA.startID and i <= DATA.endID) then
			local x,y,w,h = bgX, eY, panelWidth, rowHeight
			if (black == true) then
				dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
				black = false
			else
				dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 150))
				black = true
			end
			
			local tc = tocolor(255, 255, 255)
			if (DATA.currentSel == i) then
				tc = tocolor(0, 0, 0)
				dxDrawImage(x, y, w, h, "files/images/tuning/rowhover.png")
				
				if (type(arr.colortype) == "string" and DATA.colorPickerSel ~= i) then
					DATA.colorPickerSel = i
					DATA.colorPickerTyp = arr.colortype
					updatePicker = true
					newPicker = true
				elseif (type(arr.colortype) == "string" and DATA.colorPickerSel == i) then
					-- do nothing
				else
					DATA.colorPickerSel = nil
					DATA.colorPickerTyp = ""
					updatePicker = true
				end
				
				if (arr.upgradeID == "numberplate" and DATA.editBoxSel ~= i) then
					DATA.editBoxSel = i
					updateEdit = true
					newEdit = true
				elseif (arr.upgradeID == "numberplate" and DATA.editBoxSel == i) then
					-- do nothing
				else
					DATA.editBoxSel = nil
					updateEdit = true
				end
			end
			
			dxDrawText(arr.title, x+17, y, x+w-34, y+h, tc, 0.5, FONTS.chalet, "left", "center")
			
			if (type(arr.price) == "number" and tonumber(arr.price) ~= nil) then
				arr.isInstalled = false
				if (type(arr.upgradeID) == "number" or (DATA.lastCat == "Optisch" and arr.upgradeID == "remove")) then
					local slotID = false
					for k, v in pairs(tuningUpgrades) do
						if (v.title == DATA.currentCat) then
							slotID = v.slotID
						end
					end
					if (not slotID) then slotID = 8 end -- fur nitro
					if (tonumber(arr.upgradeID) ~= nil and (DATA.buyedUpgrades[slotID] == arr.upgradeID)) then
						arr.isInstalled = true
					elseif (arr.upgradeID == "remove") then
						if (tonumber(DATA.buyedUpgrades[slotID]) == nil or tonumber(DATA.buyedUpgrades[slotID]) == 0) then
							arr.isInstalled = true
						end
					end
				
				elseif (type(arr.upgradeID) == "string" and arr.upgradeID == "neon") then
					if (DATA.vehData["neon"] == arr.color) then
						arr.isInstalled = true
					elseif ((DATA.vehData["neon"] == "" or DATA.vehData["neon"] == nil) and arr.color == "remove") then
						arr.isInstalled = true
					end
					
				elseif (type(arr.upgradeID) == "string" and arr.upgradeID == "antrieb") then
					local oTyp = getOriginalHandling(getElementModel(DATA.vehicle))
					local typ = getVehicleHandling(DATA.vehicle)['driveType']
					if (oTyp == typ and arr.upgradeID == "remove") then
						arr.isInstalled = true
					end
					
				elseif ((type(arr.upgradeID) == "string" or type(arr.upgradeID) == "number") and DATA.lastCat == "Performance") then
					local cat = DATA.upgradeTables["Performance"][DATA.lastSel]
					if (type(DATA.buyedPerformance[cat.upgradeID]) == "string" and DATA.buyedPerformance[cat.upgradeID] == arr.upgradeID) then
						arr.isInstalled = true
					elseif ((DATA.buyedPerformance[cat.upgradeID] == 0 or DATA.buyedPerformance[cat.upgradeID] == nil or DATA.buyedPerformance[cat.upgradeID] == "" or DATA.buyedPerformance[cat.upgradeID] == false) and arr.upgradeID == "remove") then
						arr.isInstalled = true
					end
					
				elseif (type(arr.upgradeID) == "string" and (DATA.lastCat == "Spezial" or DATA.currentCat == "Spezial")) then
					if ((type(DATA.buyedSpecial[arr.upgradeID]) == "string" or (type(DATA.buyedSpecial[arr.upgradeID]) == "number" and tonumber(DATA.buyedSpecial[arr.upgradeID]) == 1)) or (arr.upgradeID=="hornsound" or arr.upgradeID=="tiefer" or arr.upgradeID=="rearwheelpos" or arr.upgradeID=="frontwheelpos" or arr.upgradeID=="customlights")) then
						if (arr.upgradeID == "hornsound") then
							if (DATA.buyedSpecial[arr.upgradeID] == arr.soundfile) then
								arr.isInstalled = true
							elseif ((DATA.buyedSpecial[arr.upgradeID] == "" or DATA.buyedSpecial[arr.upgradeID] == 0 or DATA.buyedSpecial[arr.upgradeID] == nil) and arr.soundfile == "remove") then
								arr.isInstalled = true
							end
						elseif (arr.upgradeID == "tiefer" or arr.upgradeID == "rearwheelpos" or arr.upgradeID == "frontwheelpos" or arr.upgradeID == "customlights") then
							if (DATA.buyedSpecial[arr.upgradeID] == arr.stufe) then
								arr.isInstalled = true
							elseif ((DATA.buyedSpecial[arr.upgradeID] == "" or DATA.buyedSpecial[arr.upgradeID] == 0 or DATA.buyedSpecial[arr.upgradeID] == nil) and arr.stufe == 0) then
								arr.isInstalled = true
							end
						elseif (arr.upgradeID == "numberplate") then
							arr.isInstalled = false
						else
							arr.isInstalled = true
						end
					elseif ((DATA.buyedSpecial[arr.upgradeID] == 0 or DATA.buyedSpecial[arr.upgradeID] == nil or DATA.buyedSpecial[arr.upgradeID] == "") and arr.upgradeID == "remove") then
						arr.isInstalled = true
					end
				end
				
				if (arr.isInstalled) then
					dxDrawImage(x+w-31-17, y+2.5, 31, 30, "files/images/tuning/installed.png")
				else
					local prc = setDotsInNumber(arr.price).." $"
					if (arr.upgradeID == "remove" or arr.color == "remove") then
						prc = "-"
					end
					dxDrawText(prc, x+17, y, x+w-17, y+h, tc, 0.5, FONTS.chalet, "right", "center")
				end
				
			else
				dxDrawText(">", x+17, y, x+w-17, y+h, tc, 0.5, FONTS.chalet, "right", "center")
			end
			
			entryCount = entryCount + 1
			eY = eY + rowHeight
		end
	end
	
	-- scrollbar
	if (#DATA.currentMenu > DATA.maxEntries) then
		local rowVisible = math.max(0.05, math.min(1.0, DATA.maxEntries / #DATA.currentMenu))
		local barHeight = (DATA.maxEntries * rowHeight) * rowVisible
		local barPos = math.min((DATA.endID-DATA.maxEntries) / #DATA.currentMenu, 1.0 - rowVisible) * (DATA.maxEntries * rowHeight)
		dxDrawRectangle(bgX + panelWidth - 2, (bgY+175+rowHeight) + barPos, 2, barHeight, tocolor(255, 255, 255, 255))
	end
	
	
	-- FOOTER
	dxDrawRectangle(bgX, (bgY+175+rowHeight)+(rowHeight*entryCount)+2, panelWidth, rowHeight, tocolor(0, 0, 0, 255))
	dxDrawImage(bgX+165, (bgY+175+rowHeight)+(rowHeight*entryCount)+5, 20, 28, "files/images/tuning/nav.png")
	
	-- COLORPICKER
	if (updatePicker) then
		if ((DATA.colorPickerSel == nil or newPicker == true) and DATA.colorPicker ~= nil) then
			destroyColorPicker()
			setDefaultColor()
			DATA.colorPicker = nil
			DATA.canMoveCam = true
		end
		if (DATA.colorPickerSel ~= nil and DATA.colorPicker == nil) then
			DATA.colorPicker = createColorPicker(DATA.vehicle, bgX+2, (bgY+175+rowHeight)+(rowHeight*entryCount)+2+rowHeight+4, panelWidth-4, (panelWidth-4)/2, DATA.colorPickerTyp)
			DATA.canMoveCam = false
		end
	end
	
	-- EDIT BOX
	if (updateEdit) then
		if ((DATA.editBoxSel == nil or newEdit == true) and DATA.editBox ~= nil) then
			destroyElement(DATA.editBox)
			DATA.editBox = nil
			DATA.canMoveCam = true
			guiSetInputMode("allow_binds")
		end
		if (DATA.editBoxSel ~= nil and DATA.editBox == nil) then
			DATA.editBox = guiCreateEdit(bgX+2, (bgY+175+rowHeight)+(rowHeight*entryCount)+2+rowHeight+4, panelWidth-4, rowHeight, "", false, nil)
			guiSetText(DATA.editBox, getVehiclePlateText(DATA.vehicle))
			guiEditSetMaxLength(DATA.editBox, 8)
			guiBringToFront(DATA.editBox)
			guiSetInputMode("no_binds")
			DATA.canMoveCam = false
		end
	end
	
	--helpbar
	dxDrawImage(sX-700-15, sY-49.3-10, 700, 49.3, "files/images/tuning/legende.png")
	
	--move cam
	if (getKeyState("mouse1") == false) then
		showCursor(true)
	end
end


function changeCont(_current, _last, _currentMenu, _currentSel, _currentCat)
	if (_current ~= nil) then
		DATA.current = _current
	end
	DATA.lastSel = nil
	if (_last ~= nil) then
		DATA.last = _last
		DATA.lastSel = DATA.currentSel
		if (_currentCat == "Kategorien") then
			DATA.lastSel = 1
		end
	end
	if (_currentMenu ~= nil) then
		DATA.currentMenu = _currentMenu
	end
	--if (_currentSel ~= nil) then
		--DATA.currentSel = _currentSel
	--end
	DATA.currentSel = 1
	DATA.startID = 1
	DATA.endID = DATA.maxEntries
	if (_currentCat ~= nil) then
		DATA.lastCat = DATA.currentCat
		if (_currentCat == "Kategorien") then
			DATA.lastCat = ""
		end
		DATA.currentCat = _currentCat
	end
end

local neonPreview = false
local variantPreview = false
local function removeTmpUpgrades()
	for i = 1000, 1200 do
		if (i ~= 1008 and i ~= 1009 and i ~= 1010) then
			local del = true
			for k, v in pairs(DATA.buyedUpgrades) do
				if (v == i) then
					del = false
					break
				end
			end
			
			if (del) then
				removeVehicleUpgrade(DATA.vehicle, i)
			end
		end
	end
	
	
	for k, v in pairs(DATA.buyedUpgrades) do
		addVehicleUpgrade(DATA.vehicle, v)
	end
	
	
	if (neonPreview) then
		triggerServerEvent("neonPreviewRemove", localPlayer)
		neonPreview = false
	end
	if (variantPreview) then
		triggerServerEvent("variantPreview", localPlayer)
		variantPreview = false
	end
	
	updateWheelPos(DATA.vehicle)
	loadVehicleLights(DATA.vehicle)
end
local function newHovererdItem()
	removeTmpUpgrades()
	
	
	if (DATA.currentCat ~= "Kategorien" and (type(DATA.upgradeTables[DATA.currentCat]) == "table" and type(DATA.upgradeTables[DATA.currentCat][DATA.currentSel]) == "table" and (type(DATA.upgradeTables[DATA.currentCat][DATA.currentSel].cameraComponent) == "table" or type(DATA.upgradeTables[DATA.currentCat][DATA.currentSel].cameraComponent) == "string"))) then
		local cc = DATA.upgradeTables[DATA.currentCat][DATA.currentSel].cameraComponent
		local component, offX, offY, offZ, open = nil, nil, nil, nil, nil
		if (type(cc) == "string" and cc == "default") then
			if (DATA.curCamPos ~= "standard") then
				moveToComponent("bonnet_dummy", -5.5, -5.5, 3, false)
				DATA.curCamPos = "standard"
			end
		else
			local component, offX, offY, offZ, open = unpack(DATA.upgradeTables[DATA.currentCat][DATA.currentSel].cameraComponent)
			if (DATA.curCamPos ~= tostring(component..offX..offY..offZ)) then
				moveToComponent(component, offX, offY, offZ, open)
			end
		end
		
	elseif (DATA.currentCat == "Kategorien") then
		if (DATA.curCamPos ~= "standard") then
			moveToComponent("bonnet_dummy", -5.5, -5.5, 3, false)
			DATA.curCamPos = "standard"
		end
	end
	
	if (DATA.currentCat == "Hupe") then
		destroyElement(DATA.hornSound)
		local tbl = DATA.upgradeTables["Spezial"][DATA.lastSel].upgrades[DATA.currentSel]
		if (tbl.soundfile ~= "remove") then
			DATA.hornSound = playSound("files/sounds/horns/"..tbl.soundfile, tbl.loop)
			if (DATA.hornSound) then
				setSoundVolume(DATA.hornSound, 0.8)
			end
		end
		
	elseif (DATA.currentCat == "Spurverbreiterung Front" or DATA.currentCat == "Spurverbreiterung Heck") then
		local tbl = DATA.upgradeTables["Spezial"][DATA.lastSel].upgrades[DATA.currentSel]
		local multi = tbl.stufe
		if (tbl.stufe == "remove") then multi = 0 end
		
		if (DATA.currentCat == "Spurverbreiterung Front") then
			resetVehicleComponentPosition(DATA.vehicle, "wheel_lf_dummy")
			resetVehicleComponentPosition(DATA.vehicle, "wheel_rf_dummy")
			
			local lx, ly, lz = getVehicleComponentPosition(DATA.vehicle, "wheel_lf_dummy")
			if (lx < 0) then lx = lx - (0.02*multi) else lx = lx + (0.02*multi) end
			setVehicleComponentPosition(DATA.vehicle, "wheel_lf_dummy", lx, ly, lz)
			
			local rx, ry, rz = getVehicleComponentPosition(DATA.vehicle, "wheel_rf_dummy")
			if (rx < 0) then rx = rx - (0.02*multi) else rx = rx + (0.02*multi) end
			setVehicleComponentPosition(DATA.vehicle, "wheel_rf_dummy", rx, ry, rz)
			
		else
			resetVehicleComponentPosition(DATA.vehicle, "wheel_lb_dummy")
			resetVehicleComponentPosition(DATA.vehicle, "wheel_rb_dummy")
			
			local lx, ly, lz = getVehicleComponentPosition(DATA.vehicle, "wheel_lb_dummy")
			if (lx < 0) then lx = lx - (0.02*multi) else lx = lx + (0.02*multi) end
			setVehicleComponentPosition(DATA.vehicle, "wheel_lb_dummy", lx, ly, lz)
			
			local rx, ry, rz = getVehicleComponentPosition(DATA.vehicle, "wheel_rb_dummy")
			if (rx < 0) then rx = rx - (0.02*multi) else rx = rx + (0.02*multi) end
			setVehicleComponentPosition(DATA.vehicle, "wheel_rb_dummy", rx, ry, rz)
			
		end		
		
	elseif (DATA.currentCat == "Scheinwerfer") then
		local tbl = DATA.upgradeTables["Spezial"][DATA.lastSel].upgrades[DATA.currentSel]
		local nr = tbl.stufe
		if (tbl.stufe == "remove") then nr = 0 end
		
		loadVehicleLights(DATA.vehicle, nr)
		
	elseif (DATA.currentCat == "Tieferlegung") then
		
		
	elseif (DATA.lastCat == "Optisch" or DATA.lastCat == "Performance") then
		local tbl = DATA.upgradeTables[DATA.lastCat][DATA.lastSel].upgrades[DATA.currentSel]
		if (type(tbl.upgradeID) == "number" and tonumber(tbl.upgradeID) ~= nil) then
			addVehicleUpgrade(DATA.vehicle, tbl.upgradeID)
			
		elseif (type(tbl.upgradeID) == "string" and tbl.upgradeID == "neon") then
			if (tbl.color ~= "remove") then
				neonPreview = triggerServerEvent("neonPreviewAdd", localPlayer, tbl.color)
			end
			
		elseif (type(tbl.upgradeID) == "string" and tbl.upgradeID == "variants") then
			variantPreview = triggerServerEvent("variantPreview", localPlayer, tbl.variant)
		end
	end
end
local function buyIt()
	if (getPlayerMoney(localPlayer) >= DATA.currentMenu[DATA.currentSel].price and DATA.currentMenu[DATA.currentSel].price > 0 or (DATA.currentMenu[DATA.currentSel].upgradeID == "variants")) then
		local catName = false
		if (DATA.currentCat == "Spezial" or DATA.currentCat == "Performance" or DATA.currentCat == "Optisch") then
			catName = DATA.currentCat
		elseif (DATA.lastCat == "Spezial" or DATA.lastCat == "Performance" or DATA.lastCat == "Optisch") then
			catName = DATA.lastCat
		end
				
		if (catName ~= false) then
			local slotID	= false
			local sCatName	= false
			local item		= false
			if (type(DATA.upgradeTables[catName][DATA.lastSel].upgrades) == "table") then
				item		= DATA.upgradeTables[catName][DATA.lastSel].upgrades[DATA.currentSel]
				sCatName	= DATA.upgradeTables[catName][DATA.lastSel].title
				slotID		= DATA.upgradeTables[catName][DATA.lastSel].slotID
			else
				item		= DATA.upgradeTables[catName][DATA.currentSel]
			end
			
			if (type(item.colortype) == "string" and item.colortype == "headlight") then
				local color = {getVehicleHeadLightColor(DATA.vehicle)}
				DATA.oriLightColor = color
				triggerServerEvent("buyVehicleUpgrade", localPlayer, catName, false, item.title, color)
				
			elseif (type(item.upgradeID) == "string" and item.upgradeID == "numberplate") then
				local txt = guiGetText(DATA.editBox)
				if (string.len(txt) > 0) then
					triggerServerEvent("buyVehicleUpgrade", localPlayer, catName, false, item.title, nil, txt)
					guiSetText(DATA.editBox, "")
				end
			else
				local itm = item.title
				if (type(item.upgradeID) == "number" and tonumber(item.upgradeID) ~= nil) then
					itm = item.upgradeID
					if (not slotID) then slotID = 8 DATA.buyedPerformance["nitro"]=item.upgradeID end -- fur nitro
					DATA.buyedUpgrades[slotID] = item.upgradeID
					
				elseif (type(item.upgradeID) == "string" and item.upgradeID == "neon") then
					if (item.color == "remove") then return end
					DATA.vehData["neon"] = item.color
					
				elseif (type(item.upgradeID) == "string" and item.upgradeID == "soundfile") then
					if (item.soundfile == "remove") then return end
					DATA.buyedSpecial[item.upgradeID] = item.soundfile
					
				elseif (type(item.upgradeID) == "string" and DATA.lastCat == "Performance") then
					local cat = DATA.upgradeTables["Performance"][DATA.lastSel]
					DATA.buyedPerformance[cat.upgradeID] = item.upgradeID
					
					if (cat.upgradeID == "antrieb") then
						local typ = getVehicleHandling(DATA.vehicle)['driveType']
						local fix = item.upgradeID
						if (fix == "allrad") then
							fix = "awd"
						elseif (fix == "front") then
							fix = "fwd"
						elseif (fix == "heck") then
							fix = "rwd"
						end
						if (typ == fix) then
							return notificationShow("error", "Dieses Tuningteil ist bereits eingebaut.")
						end
					end
					
				elseif (type(item.upgradeID) == "string" and (DATA.lastCat == "Spezial" or DATA.currentCat == "Spezial")) then
					local val = 1
					if (type(item.soundfile) == "string") then
						val = item.soundfile
					elseif (type(item.stufe) == "number") then
						val = item.stufe
					end
					DATA.buyedSpecial[item.upgradeID] = val
					
				end
				
				triggerServerEvent("buyVehicleUpgrade", localPlayer, catName, sCatName, itm, nil)
			end
		
		elseif (DATA.currentCat == "Lackierung") then
			local color = {getVehicleColor(DATA.vehicle, true)}
			DATA.oriVehicleColor = color
			triggerServerEvent("buyVehicleUpgrade", localPlayer, DATA.currentCat, false, DATA.upgradeTables[DATA.currentCat][DATA.currentSel].title, color)
			
		end
	else
		notificationShow("error", "Du hast nicht genügend Geld.")
	end
end

local function removeIt()
	local catName = false
	if (DATA.currentCat == "Spezial" or DATA.currentCat == "Performance" or DATA.currentCat == "Optisch") then
		catName = DATA.currentCat
	elseif (DATA.lastCat == "Spezial" or DATA.lastCat == "Performance" or DATA.lastCat == "Optisch") then
		catName = DATA.lastCat
	end
		
	if (catName ~= false) then
		local slotID	= false
		local sCatName	= false
		local item		= false
		if (type(DATA.upgradeTables[catName][DATA.lastSel].upgrades) == "table") then
			item		= DATA.upgradeTables[catName][DATA.lastSel].upgrades[DATA.currentSel]
			sCatName	= DATA.upgradeTables[catName][DATA.lastSel].title
			slotID		= DATA.upgradeTables[catName][DATA.lastSel].slotID
		else
			item		= DATA.upgradeTables[catName][DATA.currentSel]
		end
		
		if (item.isInstalled == true and type(item.colortype) ~= "string" and item.upgradeID ~= "remove" and item.canRemove ~= false) then
			local itm = item.title
			if (type(item.upgradeID) == "number" and tonumber(item.upgradeID) ~= nil) then
				itm = item.upgradeID
				if (not slotID) then slotID = 8 DATA.buyedPerformance["nitro"]=0 end -- fur nitro
				DATA.buyedUpgrades[slotID] = 0
				
			elseif (type(item.upgradeID) == "string" and item.upgradeID == "neon") then
				DATA.vehData["neon"] = ""
				
			elseif (type(item.upgradeID) == "string" and DATA.lastCat == "Performance") then
				local cat = DATA.upgradeTables["Performance"][DATA.lastSel]
				DATA.buyedPerformance[cat.upgradeID] = 0
				
			elseif (type(item.upgradeID) == "string" and (DATA.lastCat == "Spezial" or DATA.currentCat == "Spezial")) then
				DATA.buyedSpecial[item.upgradeID] = 0
			end
			triggerServerEvent("removeVehicleUpgrade", localPlayer, catName, sCatName, itm, nil)
		end
	end
end

local function selectIt()
	if (DATA.hornSound) then
		destroyElement(DATA.hornSound)
	end
	
	local tbl = false
	if (DATA.currentMenu[DATA.currentSel].typ == "mainCat") then
		local prods, tit, cur = {}, "", ""
		if (DATA.currentSel == 1) then
			prods, tit, cur = DATA.upgradeTables["Performance"], "Performance", "Performance"
		elseif (DATA.currentSel == 2) then
			prods, tit, cur = DATA.upgradeTables["Spezial"], "Spezial", "Spezial"
		elseif (DATA.currentSel == 3) then
			prods, tit, cur = DATA.upgradeTables["Optisch"], "Optisch", "Optisch"
		elseif (DATA.currentSel == 4) then
			prods, tit, cur = DATA.upgradeTables["Lackierung"], "Lackierung", "prod"	
		end
		changeCont(cur, "mainMenu", prods, 1, tit)
		
		
	elseif (DATA.current == "Performance") then
		tbl = DATA.upgradeTables["Performance"]
		changeCont("prod", "Performance", tbl[DATA.currentSel].upgrades, 1, tbl[DATA.currentSel].title)
		
	elseif (DATA.current == "Spezial") then
		tbl = DATA.upgradeTables["Spezial"]
		if (type(tbl[DATA.currentSel].price) == "number" and tonumber(tbl[DATA.currentSel].price) ~= nil) then
			buyIt()
		elseif (type(tbl[DATA.currentSel].upgrades) == "table") then
			changeCont("prod", "Spezial", tbl[DATA.currentSel].upgrades, 1, tbl[DATA.currentSel].title)
			
		end
			
		
	elseif (DATA.current == "Optisch") then
		tbl = DATA.upgradeTables["Optisch"]
		changeCont("prod", "Optisch", tbl[DATA.currentSel].upgrades, 1, tbl[DATA.currentSel].title)
	
	elseif (DATA.current == "fixit") then
		triggerServerEvent("tuningFix", localPlayer)
		DATA.current = "mainMenu"
		DATA.currentMenu = DATA.mainMenu
			
	elseif (DATA.current == "prod") then
		buyIt()
		
	end
	newHovererdItem()
	
	if (tbl) then
		if (type(tbl[DATA.lastSel].cameraComponent) == "table") then
			local component, offX, offY, offZ, open = unpack(tbl[DATA.lastSel].cameraComponent)
			if (open) then
				if (component == "bonnet_dummy") then
					setVehicleDoorOpenRatio(DATA.vehicle, 0, 1, 1000)
				end
			end
		end
	end
	
end

local function goBack()
	if (DATA.editBox ~= nil and string.len(guiGetText(DATA.editBox)) > 0) then return end
	if (DATA.hornSound) then
		destroyElement(DATA.hornSound)
	end
	
	for i = 0, 5 do
		if (getVehicleDoorOpenRatio(DATA.vehicle, i) == 1) then
			setVehicleDoorOpenRatio(DATA.vehicle, i, 0, 1000)
		end
	end
	
	if (DATA.last ~= "") then
		removeTmpUpgrades()
		if (DATA.current == "prod") then
			local prod, tit = {}, ""
			if (DATA.last == "Performance") then
				prod = DATA.upgradeTables["Performance"]
				tit = "Performance"
			elseif (DATA.last == "Optisch") then
				prod = DATA.upgradeTables["Optisch"]
				tit = "Optisch"
			elseif (DATA.last == "Spezial") then
				prod = DATA.upgradeTables["Spezial"]
				tit = "Spezial"
			else
				prod = DATA.mainMenu
				tit = "Kategorien"
			end
			changeCont(DATA.last, "mainMenu", prod, 1, tit)
			
		else
			changeCont(DATA.last, "", DATA.mainMenu, 1, "Kategorien")
		end
	else
		closeTuining()
	end
	newHovererdItem()
end

local function moveList(key, state)
	if (state == true and DATA.canMove == true) then
		if (key == "arrow_u") then
			DATA.currentSel = DATA.currentSel - 1
			if (DATA.currentSel < 1) then DATA.currentSel = #DATA.currentMenu DATA.startID = (#DATA.currentMenu-(DATA.maxEntries-1)) DATA.endID = #DATA.currentMenu if (DATA.startID < 1) then DATA.startID = 1 end if (DATA.endID < DATA.maxEntries) then DATA.endID = DATA.maxEntries end end
			
			if (DATA.startID > DATA.currentSel) then
				DATA.startID	= DATA.startID - 1
				DATA.endID		= DATA.endID - 1
			end
			newHovererdItem()
			
		elseif (key == "arrow_d") then
			DATA.currentSel = DATA.currentSel + 1
			if (DATA.currentSel > #DATA.currentMenu) then DATA.currentSel = 1 DATA.startID = 1 DATA.endID = DATA.maxEntries end
			
			if (DATA.currentSel > DATA.endID) then
				DATA.startID	= DATA.startID + 1
				DATA.endID		= DATA.endID + 1
			end
			newHovererdItem()
			
		elseif (key == "pgup") then
			DATA.currentSel = 1
			DATA.startID	= 1
			DATA.endID		= DATA.maxEntries
			newHovererdItem()
			
		elseif (key == "pgdn") then
			DATA.currentSel = #DATA.currentMenu
			DATA.startID	= #DATA.currentMenu - DATA.maxEntries + 1
			if (DATA.startID < 1) then DATA.startID = 1 end
			DATA.endID		= #DATA.currentMenu
			if (DATA.endID < DATA.maxEntries) then DATA.endID = DATA.maxEntries end
			newHovererdItem()
			
		elseif (key == "enter") then
			selectIt()
			
		elseif (key == "delete") then
			removeIt()
			
		elseif (key == "backspace") then
			goBack()
			
		end
	end
end

local function newMusic(reason)
	if (reason == "finished" and source == DATA.music) then
		local rnd = 1
		while true do
			rnd = math.random(1,5)
			if (rnd ~= DATA.lastMusic) then
				break
			end
		end
		--outputChatBox("new music| last:"..DATA.lastMusic.." new:"..rnd)
		DATA.music = playSound(settings.general.webserverURL.."/sounds/transfender-"..rnd..".ogg", false)
		setSoundVolume(DATA.music, 0.3)
		setSoundEffectEnabled(DATA.music, "reverb", true)
		setElementDimension(DATA.music, getElementDimension(localPlayer))
		DATA.lastMusic = rnd
		
	end
end

local function moveCam()
	if (DATA.canMoveCam == true and windowOpen == false) then
		showCursor(false)
		if (getCameraTarget(localPlayer) ~= localPlayer) then
			setTimer(function()
				if (getKeyState("mouse1")) then
					setCameraTarget(localPlayer)
				end
			end, 300, 1)
		end
	end
end

function closeTuining()
	removeEventHandler("onClientRender", root, renderTuning)
	removeEventHandler("onClientKey", root, moveList)
	removeEventHandler("onClientClick", root, moveCam)
	removeEventHandler("onClientSoundStopped", root, newMusic)
	DATA.currentMenu	= DATA.mainMenu
	DATA.upgradeTables	= {}
	DATA.buyedPerformance = {}
	DATA.buyedSpecial = {}
	DATA.buyedUpgrades = {}
	showCursor(false)
	fadeCamera(false, 1, 0, 0, 0)
	setTimer(function()
		removeVehicleUpgrade(DATA.vehicle, 1010)
		removeVehicleUpgrade(DATA.vehicle, 1009)
		removeVehicleUpgrade(DATA.vehicle, 1008)
		triggerServerEvent("closeVehicleUpgrade", localPlayer)
		destroyElement(DATA.music)
		setPedCanBeKnockedOffBike(localPlayer, true)
		smoothDestroy()
		setCameraTarget(localPlayer)
		setCameraShakeLevel(0)
		setCameraClip(true, true)
		showSpeedometer()
		showCustomRadar()
	end, 1000, 1)
end

function clone (t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

local function openTuning(data)
	local veh			= getPedOccupiedVehicle(localPlayer)
	if (not veh) then return end
	
	
	DATA.lastSel = 1
	DATA.currentSel	= 1
	DATA.startID = 1
	DATA.endID = 10
	
	DATA.vehicle = veh
	DATA.vehData = data
	DATA.buyedPerformance = fromJSON(data["performanceupgrades"])
	DATA.buyedSpecial = fromJSON(data["specialupgrades"])
	setPedCanBeKnockedOffBike(localPlayer, false)
	local vehicleType	= getVehicleType(veh)
	
		
	-- ADD COMPATIBLE TUNINGS
	DATA.upgradeTables = {}
	DATA.upgradeTables["Performance"] = {}
	local _performanceTuningUpgrades = clone(performanceTuningUpgrades)
	for k, v in ipairs(_performanceTuningUpgrades) do
		local bool = false
		if (v.compatible == "all") then
			bool = true
		else
			for kk,vv in pairs(v.compatible) do
				if (vv == vehicleType) then
					bool = true
					break
				end
			end
		end
		
		if (bool == true) then
			table.insert(DATA.upgradeTables["Performance"], v)
		end
	end
	
	
	DATA.upgradeTables["Spezial"] = {}
	local _specialTuningUpgrades = clone(specialTuningUpgrades)
	for k, v in ipairs(_specialTuningUpgrades) do
		local bool = false
		if (v.compatible == "all" or v.compatible[getElementModel(DATA.vehicle)]) then
			bool = true
		else
			for kk,vv in pairs(v.compatible) do
				if (vv == vehicleType) then
					bool = true
					break
				end
			end
		end
		
		if (bool == true) then
			table.insert(DATA.upgradeTables["Spezial"], v)
		end
	end
	
	
	
	local compatibleIDs = {}
	for name, id in pairs(getVehicleCompatibleUpgrades(DATA.vehicle)) do
		compatibleIDs[id] = true
	end
	DATA.upgradeTables["Optisch"] = {}
	local _tuningUpgrades = clone(tuningUpgrades)
	for k, v in ipairs(_tuningUpgrades) do
		if (v.slotID ~= false) then
			local upgrds = {}
			for kk, vv in ipairs(v.upgrades) do
				if (compatibleIDs[vv.upgradeID] == true) then
					table.insert(upgrds, vv)
				end
			end
			if (#upgrds > 0) then
				v.upgrades = upgrds
				table.insert(DATA.upgradeTables["Optisch"], v)
			end
			
		else
			
			local bool = false
			if (v.compatible == "all" or v.compatible[getElementModel(DATA.vehicle)]) then
				bool = true
			else
				for kk,vv in pairs(v.compatible) do
					if (vv == vehicleType) then
						bool = true
						break
					end
				end
			end
			
			if (bool == true) then
				table.insert(DATA.upgradeTables["Optisch"], v)
			end
		end
		
	end
	
	for k, v in ipairs(DATA.upgradeTables["Optisch"]) do
		if (v.slotID ~= false) then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "remove", price = 0})

		elseif (v.title == "Neon") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "neon", color="remove", price = 0})
		--[[elseif (v.title == "Varianten") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "variants", variant=nil, price = 0})]]
		end
	end
	for k, v in ipairs(DATA.upgradeTables["Performance"]) do
		table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "remove", price = 0})
	end
	for k, v in ipairs(DATA.upgradeTables["Spezial"]) do
		if (v.title == "Hupe") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "hornsound", price = 0, soundfile="remove"})
		elseif (v.title == "Tieferlegung") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "tiefer", price = 0, stufe=0})
		elseif (v.title == "Scheinwerfer") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "customlights", price = 0, stufe=0})
		elseif (v.title == "Spurverbreiterung Front") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "frontwheelpos", price = 0, stufe=0})
		elseif (v.title == "Spurverbreiterung Heck") then
			table.insert(v.upgrades, 1, {title = "Serienmäßig", upgradeID = "rearwheelpos", price = 0, stufe=0})
		end
	end
	
	
	DATA.upgradeTables["Lackierung"] = vehicleColors
	DATA.oriVehicleColor = {getVehicleColor(DATA.vehicle, true)}
	DATA.oriLightColor = {getVehicleHeadLightColor(DATA.vehicle)}
		
	DATA.buyedUpgrades = {}
	for k, v in pairs(getVehicleUpgrades(DATA.vehicle)) do
		DATA.buyedUpgrades[getSlotIdFromUpgradeID(v)] = v
	end
	local perf = fromJSON(data["performanceupgrades"])
	if (tonumber(perf["nitro"]) ~= nil and tonumber(perf["nitro"]) >= 1000) then
		DATA.buyedUpgrades[8] = perf["nitro"]
	end
	
	if (getElementHealth(DATA.vehicle) < 975 or (DATA.buyedSpecial["armor"] == 1 and getElementHealth(DATA.vehicle) < 1675)) then
		local prc	= 0
		if (getElementHealth(DATA.vehicle) < 1000 and not DATA.buyedSpecial["armor"]) then
			prc = math.floor((1000 - getElementHealth (DATA.vehicle) ) / 1.5)
		elseif (getElementHealth(DATA.vehicle) < 1700 and DATA.buyedSpecial["armor"] == 1) then
			prc = math.floor((1700 - getElementHealth (DATA.vehicle)) / 3)
		end
	
		DATA.currentMenu = {{title = "Fahrzeug Reparieren", price = prc}}
		DATA.current = "fixit"
	else
		DATA.currentMenu = DATA.mainMenu
		DATA.current = "mainMenu"
	end
	
	
	addEventHandler("onClientRender", root, renderTuning)
	addEventHandler("onClientKey", root, moveList)
	addEventHandler("onClientClick", root, moveCam)
	showCursor(true)
	
	
	DATA.music = playSound(settings.general.webserverURL.."/sounds/transfender-"..math.random(1,5)..".ogg", false)
	setSoundVolume(DATA.music, 0.3)
	setSoundEffectEnabled(DATA.music, "reverb", true)
	setElementDimension(DATA.music, getElementDimension(localPlayer))
	DATA.lastMusic = 1
	addEventHandler("onClientSoundStopped", root, newMusic)
	
	setCameraShakeLevel(2)
	setCameraClip(true, false) 
	
	setTimer(function()
		setCameraMatrix(1497.78, 1312.74, 4422.90, 1503.27, 1318.18, 4419.90)
		setTimer(function()
			moveToComponent("bonnet_dummy", -5.5, -5.5, 3, false)
			DATA.curCamPos = "standard"
		end, 250, 1)
	end, 750, 1)
end
addEvent("tuningWindow", true)
addEventHandler("tuningWindow", root, openTuning)


-- wenn spieler of geht, auto löschen







local screenX, screenY = guiGetScreenSize()

cursorIsMoving, pickingColor, pickingLuminance = false, false, false

local pickerData = {}
local availableTextures = {
	["palette"] = dxCreateTexture("files/images/tuning/palette.png", "argb", true, "clamp"),
	["light"] = dxCreateTexture("files/images/tuning/light.png", "argb", true, "clamp"),
}
responsiveMultiplier = 1
local lightIconXOffset = 20 * responsiveMultiplier
local miniRectangle = 8 * responsiveMultiplier

function drawBorder(x, y, w, h, size, color, postGUI)
	size = size or 2
	
	dxDrawRectangle(x - size, y, size, h, color or tocolor(0, 0, 0, 200), postGUI)
	dxDrawRectangle(x + w, y, size, h, color or tocolor(0, 0, 0, 200), postGUI)
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(0, 0, 0, 200), postGUI)
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(0, 0, 0, 200), postGUI)
end
function drawBorderedRectangle(x, y, w, h, borderSize, borderColor, bgColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 200)
	bgColor = bgColor or borderColor
	
	dxDrawRectangle(x, y, w, h, bgColor, postGUI)
	drawBorder(x, y, w, h, borderSize, borderColor, postGUI)
end
function drawRoundedRectangle(x, y, w, h, rounding, borderColor, bgColor, postGUI)
	borderColor = borderColor or tocolor(0, 0, 0, 200)
	bgColor = bgColor or borderColor
	rounding = rounding or 2
	
	dxDrawRectangle(x, y, w, h, bgColor, postGUI)
	dxDrawRectangle(x + rounding, y - 1, w - (rounding * 2), 1, borderColor, postGUI)
	dxDrawRectangle(x + rounding, y + h, w - (rounding * 2), 1, borderColor, postGUI)
	dxDrawRectangle(x - 1, y + rounding, 1, h - (rounding * 2), borderColor, postGUI)
	dxDrawRectangle(x + w, y + rounding, 1, h - (rounding * 2), borderColor, postGUI)
end

addEventHandler("onClientRender", root, function()
	if pickerData and pickerData["colortype"] ~= nil and pickerData["active"] then
		--> Vehicle color
		local selectedR, selectedG, selectedB = pickerData["color"][1], pickerData["color"][2], pickerData["color"][3]
		
		if pickerData["vehicle"] and isElement(pickerData["vehicle"]) then
			local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(pickerData["vehicle"], true)
			local r5, g5, b5 = getVehicleHeadLightColor(pickerData["vehicle"])
			
			if pickerData["colortype"] == "color1" then
				r1, g1, b1 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color2" then
				r2, g2, b2 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color3" then
				r3, g3, b3 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color4" then
				r4, g4, b4 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "headlight" then
				r5, g5, b5 = selectedR, selectedG, selectedB
			end
			
			setVehicleColor(pickerData["vehicle"], r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
			setVehicleHeadLightColor(pickerData["vehicle"], r5, g5, b5)
		end
		
		--> Luminance selector
		local arrowX = pickerData["posX"] + ((1 - pickerData["lightness"]) * (pickerData["width"] - lightIconXOffset))
		arrowX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"] - lightIconXOffset, arrowX))
		
		dxDrawRectangle(pickerData["posX"] - 2, pickerData["posY"] + pickerData["height"] - 2, pickerData["width"] + 4, (20 * responsiveMultiplier) + 4, tocolor(0, 0, 0, 255))
		
		for i = 0, (pickerData["width"] - lightIconXOffset) do
			local luminanceR, luminanceG, luminanceB = HSLToRGB(pickerData["hue"], pickerData["saturation"], ((pickerData["width"] - lightIconXOffset) - i) / (pickerData["width"] - lightIconXOffset))
			
			dxDrawRectangle(pickerData["posX"] + i, pickerData["posY"] + pickerData["height"], 1, (20 * responsiveMultiplier), tocolor(luminanceR * 255, luminanceG * 255, luminanceB * 255, 255))
		end
		
		dxDrawRectangle(arrowX, pickerData["posY"] + pickerData["height"], 2, (20 * responsiveMultiplier), tocolor(0, 0, 0, 200))
		dxDrawImage(pickerData["posX"] + pickerData["width"] - lightIconXOffset, pickerData["posY"] + pickerData["height"] + 1, (20 * responsiveMultiplier), (20 * responsiveMultiplier), availableTextures["light"])
		
		--> Color selector
		drawBorder(pickerData["posX"], pickerData["posY"], pickerData["width"], pickerData["height"], 2, tocolor(0, 0, 0, 255))
		dxDrawImage(pickerData["posX"], pickerData["posY"], pickerData["width"], pickerData["height"], availableTextures["palette"])
		drawBorderedRectangle((pickerData["posX"] + (pickerData["hue"] * pickerData["width"] - 1)) - (miniRectangle / 2), (pickerData["posY"] + ((1 - pickerData["saturation"]) * pickerData["height"] - 1)) - (miniRectangle / 2), miniRectangle, miniRectangle, 1, tocolor(0, 0, 0, 255), tocolor(pickerData["selectedColor"][1], pickerData["selectedColor"][2], pickerData["selectedColor"][3], 255))
		
		--> Manage cursor
		if isCursorShowing() and isMoving then
			local cursorX, cursorY = getCursorPosition()

			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
			
			if getKeyState("mouse1") and pickingColor then
				cursorX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"], cursorX))
				cursorY = math.max(pickerData["posY"], math.min(pickerData["posY"] + pickerData["height"], cursorY))
				setCursorPosition(cursorX, cursorY)
				
				pickerData["hue"], pickerData["saturation"] = (cursorX - pickerData["posX"]) / (pickerData["width"] - 1), ((pickerData["height"] - 1) - cursorY + pickerData["posY"]) / (pickerData["height"] - 1)
				
				local convertedR, convertedG, convertedB = HSLToRGB(pickerData["hue"], pickerData["saturation"], pickerData["lightness"])
				local oldR, oldG, oldB = HSLToRGB(pickerData["hue"], pickerData["saturation"], 0.5)
				
				pickerData["selectedColor"] = convertColor({oldR * 255, oldG * 255, oldB * 255})
				pickerData["color"] = convertColor({convertedR * 255, convertedG * 255, convertedB * 255, pickerData["color"][4]})
			elseif getKeyState("mouse1") and pickingLuminance then
				cursorX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"] - 25, cursorX))
				cursorY = math.max(pickerData["posY"] + pickerData["height"], math.min(pickerData["posY"] + pickerData["height"] + (20 * responsiveMultiplier), cursorY))
				setCursorPosition(cursorX, cursorY)
				
				pickerData["lightness"] = ((pickerData["width"] - 25) - cursorX + pickerData["posX"]) / (pickerData["width"] - 25)
				
				local convertedR, convertedG, convertedB = HSLToRGB(pickerData["hue"], pickerData["saturation"], pickerData["lightness"])
				
				pickerData["color"] = convertColor({convertedR * 255, convertedG * 255, convertedB * 255, pickerData["color"][4]})
			end
		end
	end
end)

addEventHandler("onClientClick", root, function(button, state, cursorX, cursorY)
	if pickerData and pickerData["colortype"] ~= nil and pickerData["active"] then
		if button == "left" and state == "down" then
			if cursorX >= pickerData["posX"] and cursorX <= pickerData["posX"] + pickerData["width"] and cursorY >= pickerData["posY"] and cursorY <= pickerData["posY"] + pickerData["height"] then
				isMoving, pickingColor, pickingLuminance = true, true, false
			elseif cursorX >= pickerData["posX"] and cursorX <= pickerData["posX"] + pickerData["width"] - 25 and cursorY >= pickerData["posY"] + pickerData["height"] and cursorY <= pickerData["posY"] + pickerData["height"] + (20 * responsiveMultiplier) then
				isMoving, pickingColor, pickingLuminance = true, false, true
			end
		else
			isMoving, pickingColor, pickingLuminance = false, false, false
		end
	end
end)

function setPaletteType(type)
	if type then
		pickerData["colortype"] = type
	end
end

function createColorPicker(vehicle, x, y, w, h, colortype)
	if vehicle and x and y and w and h and colortype then
		pickerData = {["active"] = true, ["posX"] = x, ["posY"] = y, ["width"] = w, ["height"] = h, ["colortype"] = colortype, ["vehicle"] = vehicle}
		updatePaletteColor(vehicle, colortype)
		return true
	end
end

function destroyColorPicker()
	pickerData["active"] = false
	pickerData = {}
	pickerData = nil
end

function updatePaletteColor(vehicle, colortype)
	if vehicle and colortype then
		local vehicleColor = {255, 255, 255}
		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(vehicle, true)
		local r5, g5, b5 = getVehicleHeadLightColor(vehicle)
		
		if pickerData["colortype"] == "color1" then
			vehicleColor = {r1, g1, b1}
		elseif pickerData["colortype"] == "color2" then
			vehicleColor = {r2, g2, b2}
		elseif pickerData["colortype"] == "color3" then
			vehicleColor = {r3, g3, b3}
		elseif pickerData["colortype"] == "color4" then
			vehicleColor = {r4, g4, b4}
		elseif pickerData["colortype"] == "headlight" then
			vehicleColor = {r5, g5, b5}
		end
		
		pickerData["color"] = convertColor({vehicleColor[1], vehicleColor[2], vehicleColor[3]})
		pickerData["hue"], pickerData["saturation"], pickerData["lightness"] = RGBToHSL(pickerData["color"][1] / 255, pickerData["color"][2] / 255, pickerData["color"][3] / 255)
		
		local currentR, currentG, currentB = HSLToRGB(pickerData["hue"], pickerData["saturation"], 0.5)
		pickerData["selectedColor"] = convertColor({currentR * 255, currentG * 255, currentB * 255})
	end
end

function convertColor(color)
	color[1] = fixColorValue(color[1])
	color[2] = fixColorValue(color[2])
	color[3] = fixColorValue(color[3])
	color[4] = fixColorValue(color[4])

	return color
end

function fixColorValue(value)
	if not value then
		return 255
	end
	
	value = math.floor(tonumber(value))
	
	if value < 0 then
		return 0
	elseif value > 255 then
		return 255
	else
		return value
	end
end

function HSLToRGB(hue, saturation, lightness)
	local lightnessValue2
	
	if lightness < 0.5 then
		lightnessValue2 = lightness * (saturation + 1)
	else
		lightnessValue2 = (lightness + saturation) - (lightness * saturation)
	end
	
	local lightnessValue1 = lightness * 2 - lightnessValue2
	local r = HUEToRGB(lightnessValue1, lightnessValue2, hue + 1 / 3)
	local g = HUEToRGB(lightnessValue1, lightnessValue2, hue)
	local b = HUEToRGB(lightnessValue1, lightnessValue2, hue - 1 / 3)
	
	return r, g, b
end

function HUEToRGB(lightness1, lightness2, hue)
	if hue < 0 then
		hue = hue + 1
	elseif hue > 1 then
		hue = hue - 1
	end

	if hue * 6 < 1 then
		return lightness1 + (lightness2 - lightness1) * hue * 6
	elseif hue * 2 < 1 then
		return lightness2
	elseif hue * 3 < 2 then
		return lightness1 + (lightness2 - lightness1) * (2 / 3 - hue) * 6
	else
		return lightness1
	end
end

function RGBToHSL(red, green, blue)
	local max = math.max(red, green, blue)
	local min = math.min(red, green, blue)
	local hue, saturation, lightness = 0, 0, (min + max) / 2

	if max == min then
		hue, saturation = 0, 0
	else
		local different = max - min

		if lightness < 0.5 then
			saturation = different / (max + min)
		else
			saturation = different / (2 - max - min)
		end

		if max == red then
			hue = (green - blue) / different
			
			if green < blue then
				hue = hue + 6
			end
		elseif max == green then
			hue = (blue - red) / different + 2
		else
			hue = (red - green) / different + 4
		end

		hue = hue / 6
	end

	return hue, saturation, lightness
end
















------------------------

local maxFixesPerWheel = 1
local function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
    if (source and getElementData(source, "doubleWheels") == true) then
		if (tonumber(tyre) ~= nil) then
			
			local fixes				= getElementData(source, "wheelFixes")
			if (type(fixes) ~= "table") then fixes = {0, 0, 0, 0} end
			
			
			local change = false
			if (fixes[(tyre+1)] < maxFixesPerWheel) then
				cancelEvent()
				fixes[(tyre+1)] = fixes[(tyre+1)] + 1
				change = true
			end
			
			if (change) then
				triggerServerEvent("updateWheelFixes", localPlayer, source, fixes)
			end
		end
	end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)

local hornSounds = {}
local function playCustomHorn(veh, sound)
	if (veh and sound) then
		if (not hornSounds[veh]) then
			hornSounds[veh] = playSound3D("files/sounds/horns/"..sound, 0, 0, 0)
			if (hornSounds[veh]) then
				setSoundVolume(hornSounds[veh], 0.65)
				setSoundMaxDistance(hornSounds[veh], 50)
				attachElements(hornSounds[veh], veh)
				setTimer(function()
					hornSounds[veh] = false
				end, getSoundLength(hornSounds[veh])+50, 1)
			end
		end
	end
end
addEvent("playCustomHorn", true)
addEventHandler("playCustomHorn", root, playCustomHorn)







--------------------------------------------------
local oldDoorRatios = {}
local doorStatus = {}
local doorTimers = {}
local vehiclesWithScissorDoor = {}
local doorAnimTime = 250

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, vehicle in pairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(vehicle) then
			if getElementData(vehicle, "flugelDoors") then
				vehiclesWithScissorDoor[vehicle] = true
			end
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	removeVehicleFromTable(source)
end)
addEventHandler("onClientElementStreamOut", root, function()
	removeVehicleFromTable(source)
end)
addEventHandler("onClientVehicleExplode", root, function()
	removeVehicleFromTable(source)
end)

addEventHandler("onClientElementStreamIn", root, function()
	if isVehicle(source) then
		if getElementData(source, "flugelDoors") then
			vehiclesWithScissorDoor[source] = true
		end
	end
end)

addEventHandler("onClientElementDataChange", root, function(data)
	if isVehicle(source) then
		if data == "flugelDoors" then
			if isElementStreamedIn(source) then
				vehiclesWithScissorDoor[source] = getElementData(source, "flugelDoors")
				
				if not vehiclesWithScissorDoor[source] then
					removeVehicleFromTable(source)
				end
			end
		end
	end
end)

addEventHandler("onClientPreRender", root, function()
	for vehicle in pairs(vehiclesWithScissorDoor) do
		if isElement(vehicle) then
			if not doorTimers[vehicle] then
				doorTimers[vehicle] = {}
			end
			
			local doorRatios = {}
			
			for i = 1, 4 do
				local i = i + 1
				local doorRatio = getVehicleDoorOpenRatio(vehicle, i)
 
				if doorRatio and oldDoorRatios[vehicle] and oldDoorRatios[vehicle][i] then
					local oldDoorRatio = oldDoorRatios[vehicle][i]
 
					if not doorStatus[vehicle] then
						doorStatus[vehicle] = {}
					end
					
					local doorPreviousState = doorStatus[vehicle][i]
					
					if not doorPreviousState then
						doorPreviousState = "closed"
					end
					
					if doorPreviousState == "closed" and doorRatio > oldDoorRatio then
						doorStatus[vehicle][i] = "opening"
						doorTimers[vehicle][i] = setTimer(function(vehicle,i)
							doorStatus[vehicle][i] = "open"
							doorTimers[vehicle][i] = nil
						end, doorAnimTime, 1, vehicle, i)
					elseif doorPreviousState == "open" and doorRatio < oldDoorRatio then
						doorStatus[vehicle][i] = "closing"
						doorTimers[vehicle][i] = setTimer(function(vehicle, i)
							doorStatus[vehicle][i] = "closed"
							doorTimers[vehicle][i] = nil
						end, doorAnimTime, 1, vehicle, i)
					end
				elseif not oldDoorRatios[vehicle] then
					oldDoorRatios[vehicle] = {}
				end
				
				if doorRatio then
					oldDoorRatios[vehicle][i] = doorRatio
				end
			end
		else
			vehiclesWithScissorDoor[vehicle] = nil
			oldDoorRatios[vehicle] = nil
			doorStatus[vehicle] = nil
			doorTimers[vehicle] = nil
		end
	end
	
	for vehicle, doors in pairs(doorStatus) do
		if vehiclesWithScissorDoor[vehicle] then
			local doorX, doorY, doorZ = -72, -25, 0
			
			for door, status in pairs(doors) do
				local ratio = 0
				
				if status == "open" then
					ratio = 1
				end
				
				local doorTimer = doorTimers[vehicle][door]
				
				if doorTimer and isTimer(doorTimer) then
					local timeLeft = getTimerDetails(doorTimer)
					
					ratio = timeLeft / doorAnimTime
					
					if status == "opening" then
						ratio = 1 - ratio
					end
				end
				
				local dummyName = (door == 2 and "door_lf_dummy") or (door == 3 and "door_rf_dummy")
				
				if dummyName then
					local doorX, doorY, doorZ = doorX * ratio, doorY * ratio, doorZ * ratio
					
					if string.find(dummyName, "rf") then
						doorY, doorZ = doorY * -1, doorZ * -1
					end
					
					setVehicleComponentRotation(vehicle, dummyName, doorX, doorY, doorZ)
				end
			end
		end
	end
end)

addEventHandler("onClientVehicleDamage", root, function()
	local leftDoor = getVehicleDoorState(source, 2)
	local rightDoor = getVehicleDoorState(source, 3)
	
	if leftDoor == 1 then
		setVehicleDoorOpenRatio(source, 2, 0, 500)
	end
	
	if rightDoor == 1 then
		setVehicleDoorOpenRatio(source, 3, 0, 500)
	end
end)
function removeVehicleFromTable(vehicle)
	if isVehicle(vehicle) then
		oldDoorRatios[vehicle] = nil
		doorStatus[vehicle] = nil
		doorTimers[vehicle] = nil
		vehiclesWithScissorDoor[vehicle] = nil
	end
end
function isVehicle(vehicle)
	if vehicle and isElement(vehicle) and getElementType(vehicle) == "vehicle" then
		return true
	end
end














---------------------------------------------------------

local shaders = {}
function loadVehicleLights(veh, preview)
	for k, v in pairs(shaders) do
		engineRemoveShaderFromWorldTexture(v, "vehiclelights128", veh)
		engineRemoveShaderFromWorldTexture(v, "vehiclelightson128", veh)
	end

	
	local image = getElementData(veh, "customlights")
	if (preview ~= nil and preview ~= false and tonumber(preview) > 0) then image = preview end
	if (not image or tonumber(image) == nil or tonumber(image) < 1) then return end
	if (not shaders[image]) then
		local texture	= dxCreateTexture("files/images/tuning/lights/"..image..".png", "dxt3")
		local shader	= dxCreateShader("files/shaders/lights.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		shaders[image] = shader
	end
	engineApplyShaderToWorldTexture(shaders[image], "vehiclelights128", veh)
	engineApplyShaderToWorldTexture(shaders[image], "vehiclelightson128", veh)
end

function updateWheelPos(veh)
	if (veh and isElement(veh)) then
		local front	= getElementData(veh, "frontwheelpos")
		local rear	= getElementData(veh, "rearwheelpos")
		
		resetVehicleComponentPosition(veh, "wheel_lf_dummy")
		resetVehicleComponentPosition(veh, "wheel_rf_dummy")
		resetVehicleComponentPosition(veh, "wheel_lb_dummy")
		resetVehicleComponentPosition(veh, "wheel_rb_dummy")
		
		if (front and tonumber(front) ~= nil and tonumber(front) > 0) then
			local lx, ly, lz = getVehicleComponentPosition(veh, "wheel_lf_dummy")
			if (lx < 0) then lx = lx - (0.02*front) else lx = lx + (0.02*front) end
			setVehicleComponentPosition(veh, "wheel_lf_dummy", lx, ly, lz)
			
			local rx, ry, rz = getVehicleComponentPosition(veh, "wheel_rf_dummy")
			if (rx < 0) then rx = rx - (0.02*front) else rx = rx + (0.02*front) end
			setVehicleComponentPosition(veh, "wheel_rf_dummy", rx, ry, rz)
		end
		if (rear and tonumber(rear) ~= nil and tonumber(rear) > 0) then
			local lx, ly, lz = getVehicleComponentPosition(veh, "wheel_lb_dummy")
			if (lx < 0) then lx = lx - (0.02*rear) else lx = lx + (0.02*rear) end
			setVehicleComponentPosition(veh, "wheel_lb_dummy", lx, ly, lz)
			
			local rx, ry, rz = getVehicleComponentPosition(veh, "wheel_rb_dummy")
			if (rx < 0) then rx = rx - (0.02*rear) else rx = rx + (0.02*rear) end
			setVehicleComponentPosition(veh, "wheel_rb_dummy", rx, ry, rz)
		end
	end
end
addEventHandler("onClientElementStreamIn", root, function()
	if (getElementType(source) == "vehicle") then
		updateWheelPos(source)
		loadVehicleLights(source)
	end
end)
addEventHandler("onClientElementDataChange", root, function(dataName)
	if (getElementType(source) == "vehicle") then
		if (dataName == "customlights") then
			loadVehicleLights(source)
		elseif (dataName == "frontwheelpos" or dataName == "rearwheelpos") then
			--updateWheelPos(source)
		end
	end
end)
























--[[
curID = 0
testVeh = false
startTick = false
secondTick = false
nullAufHundert = false
maxSpeed = 0
fullToZero = 0
timer = nil
runs = 0
addEventHandler("onClientPreRender", root, function()
	if (startTick ~= false) then
		local speed = getElementSpeed(testVeh)
		
		if (nullAufHundert == false) then
			if (speed >= 100) then
				nullAufHundert = getTickCount() - startTick
			end
		end
		
		if (speed > maxSpeed) then
			maxSpeed = speed
		else
			runs = runs + 1
			if (runs > 225 and curID ~= 0) then
				fdsfldf()
			end
		end
		
	elseif (secondTick ~= false) then
		local speed = getElementSpeed(testVeh)
		if (speed < 1) then
			fullToZero = getTickCount() - secondTick
			outputChatBox("fullToZero: "..tostring(fullToZero).." ms")
			testVeh = false
			startTick = false
			secondTick = false
			nullAufHundert = false
			maxSpeed = 0
			fullToZero = 0
			
			setControlState("handbrake", false)
		end
	end
end)
--2759 ori
--2616


local testPed = createPed(1, 1470, 1159, 11)
setElementStreamable(testPed, false)
local mark = createMarker(0, 0, 0, "corona", 40)

function fdsfldf()
	killTimer(timer)
	setPedControlState(testPed, "accelerate", false)
			outputChatBox('['..curID..'] = {maxSpeed = '..tostring(maxSpeed)..', nullHundert = '..tostring(nullAufHundert)..'},')
			detachElements(mark, testVeh)
			destroyElement(testVeh)
			startTick = false
			nullAufHundert = false
			maxSpeed = 0
			testVeh = false
			runs = 0
			testVehicle((curID+1))
end

function testVehicle(id)
	testVeh = createVehicle(id, 1476.96484375,1280.3649902344,15.5, 0, 0, 360)
	setElementStreamable(testVeh, false)
	attachElements(mark, testVeh)
	setCameraTarget(testVeh)
	if (not testVeh) then return testVehicle((id+1)) end
	if (getVehicleType(id) ~= "Plane") then destroyElement(testVeh) return testVehicle((id+1)) end
	
	curID = id
	warpPedIntoVehicle(testPed, testVeh)
	setTimer(function()
		setPedControlState(testPed, "accelerate", true)
		startTick = getTickCount()
		
	--	timer = setTimer(function()
		--	fdsfldf()
	--	end, 16000, 1)
	end, 4000, 1)
end

addCommandHandler("astest", function(_, id)
	testVehicle(tonumber(id))
end)


local function cPruf()
	testVeh = getPedOccupiedVehicle(localPlayer)
	setControlState("accelerate", true)
	startTick = getTickCount()
	
	setTimer(function()
		killTimer(timer)
		setControlState("accelerate", false)	
		outputChatBox("0-100: "..tostring(nullAufHundert).." ms ; maxSpeed: "..tostring(maxSpeed).." Km/H")
		startTick = false
		nullAufHundert = false
		maxSpeed = 0
		
		secondTick = getTickCount()
		setControlState("handbrake", true)
	end, 13000, 1)
end
addEvent("cPruf", true)
addEventHandler("cPruf", root, cPruf)
]]