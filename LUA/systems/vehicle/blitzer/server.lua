----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------



local blitzer = { -- Format: {Blitzer-X, Blitzer-Y, Blitzer-Z, Blitzer-RotZ, Colshape-X, Colshape-Y, Colshape-Z, Colshape-Radius, Max speed}
	{
		pos = {1540.7, -1739.9, 11.7, 260, 1513.2, -1735.7, 13.4, 4.5, 80},
	},
	{
		pos = {831.5, -1778.3, 11.7, 285, 802, -1784.2, 13, 5, 80},
	},
	{
		pos = {829.05, -1775.5, 11.7, 107, 854, -1769.7, 13, 5, 80},
	},
	{
		pos = {458.8, -1313.2, 13, 319, 437, -1333.5, 14.95, 5, 80},
	},
	{
		pos = {1373, -920.7, 32, 190, 1371.786, -897.75, 36.4, 5, 80},
	},
	
	{
		pos = {2918.1, -1391.6, 9, 22, 2925.8, -1410.8, 10.88, 5.5, 120},
	},
	{
		pos = {2910.7, -1392.1, 9, 205, 2902, -1372.97, 10.88, 5.5, 120},
	},
	
	{
		pos = {1072.8, -1416.4, 12, 245, 1043.7, -1405.7, 13.3, 5.5, 80},
	},
}
--innerorts:80
--landstraße:120


for i, arr in ipairs(blitzer) do
	local oX, oY, oZ, orZ, cX, cY, cZ, cS, maxSpeed = unpack(arr.pos)
	arr.object = createObject(3890, oX, oY, oZ, 0, 0, orZ)
	
	local bin = createObject(1668, 0, 0, 0)
	attachElements(bin, arr.object, 0.8, -0.7, 6)
	local eX, eY, eZ = getElementPosition(bin)
	detachElements(bin, arr.object)
	destroyElement(bin)
	
	arr.colsphere = createColSphere(cX, cY, cZ, cS)
	addEventHandler("onColShapeHit", arr.colsphere, function(ele, dim)
		if (dim and getElementType(ele) == "player") then
			
			local veh = getPedOccupiedVehicle(ele)
			if (veh and getPedOccupiedVehicleSeat(ele) == 0) then
				if (getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Monster Truck") then
					
					local speed = getElementSpeed(veh)
					if ((speed-3) > maxSpeed) then
						local effectCol = createColSphere(cX, cY, cZ, 100)
						triggerClientEvent(ele, "radarEffect", ele, eX, eY, eZ, true)
						for k, v in pairs(getElementsByType("player")) do
							if (v ~= ele) then
								triggerClientEvent(v, "radarEffect", v, eX, eY, eZ)
							end
						end
						destroyElement(effectCol)
						
						local over		= math.ceil(speed) - maxSpeed
						local points	= math.ceil(over / 40)
						local price		= math.ceil(over * 5)
						
						local hasLicense = false
						if (getVehicleType(veh) == "Automobile" and getInventoryCount(ele, "carlicense") > 0) then
							hasLicense = "carlicense"
						elseif ((getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad") and getInventoryCount(ele, "bikelicense") > 0) then
							hasLicense = "bikelicense"
						elseif ((getVehicleType(veh) == "Monster Truck" or getRealVehicleType(veh) == "truck") and getInventoryCount(ele, "trucklicense") > 0) then
							hasLicense = "trucklicense"
						end
						
						local fix = ""
						if (hasLicense ~= false) then
							
							local new = tonumber(getElementData(ele, "Stvo"))+points
							setElementData(ele, "Stvo", new)
							if (new >= 15) then
								infoShow(ele, "info", "Du hast "..new.." StVo-Punkte, dein Führerschein wurde dir entzogen. Du musst die Führerscheinprüfung nun bei der Fahrschule wiederholen.")
								
								setElementData(ele, "Stvo", 0)
								takeInventory(ele, hasLicense)
							end
							
							fix = "StVo-Punkte: "..points
							
						else
							fix = "\rDa Du keinen Führerschein hast, erhälst Du einen Wanted."
							addPlayerWanteds(ele, 1)
						end
						infoShow(ele, "info", "Du wurdest mit "..math.ceil(speed).." km/h bei erlaubten "..maxSpeed.." km/h geblitzt.\nGeldbuße: "..price.." $\n"..fix)
						takePlayerBankMoney(ele, price, "Bußgeld Radarkontrolle "..math.ceil(speed).."/"..maxSpeed.." km/h")
						
					end
					
				end
			end
			
		end
	end)
end