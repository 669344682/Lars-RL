----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

function getNearstFuelStation(player)
	if (not player) then player = localPlayer end
	local pX, pY, pZ	= getElementPosition(player)
	local nearstDist	= 9999
	local tID			= nil

	for i, arr in pairs(fuelStations) do
		local tX, tY, tZ = unpack(arr.markerPos)
		local dist = getDistanceBetweenPoints2D(pX, pY, tX, tY)
		if (dist < nearstDist) then
			nearstDist = dist
			tID = i
		end
	end
	
	return tID, nearstDist
end




function getVehicleFuelSizeUsage(vehOrID)
	if (tonumber(vehOrID) == nil) then vehOrID = getElementModel(vehOrID) end
	
	local size, usage = 50, 0.037 -- tankinhalt, verbrauch pro sekunde fahrend in % von 100
	if (Bikes[vehOrID]) then
		size, usage = 0, 0
	elseif (MotorBikes[vehOrID]) then
		size, usage = 20, 0.05556--30m
	elseif (SmallCar[vehOrID]) then
		size, usage = 40, 0.037--45m
	elseif (MiddleCar[vehOrID]) then
		size, usage = 60, 0.02778--60
	elseif (BigCar[vehOrID]) then
		size, usage = 80, 0.0222--75
	elseif (Transporter[vehOrID]) then
		size, usage = 100, 0.0185--90
	elseif (LKW[vehOrID]) then
		size, usage = 350, 0.013889--120
	elseif (Trailers[vehOrID]) then
		size, usage = 0, 0
	elseif (Trains[vehOrID]) then
		size, usage = 250, 0.02778--60
	elseif (MonsterTruck[vehOrID]) then
		size, usage = 250, 0.01195--140
	elseif (SmallBoat[vehOrID]) then
		size, usage = 30, 0.05556--30
	elseif (MiddleBoat[vehOrID]) then
		size, usage = 50, 0.037--45
	elseif (BigBoat[vehOrID]) then
		size, usage = 75, 0.0333--50
	elseif (Helicopter[vehOrID]) then
		size, usage = 175, 0.02778--60
	elseif (SmallPlane[vehOrID]) then
		size, usage = 150, 0.037--45
	elseif (BigPlane[vehOrID]) then
		size, usage = 1500, 0.0093--180
	end
	return size, usage
end