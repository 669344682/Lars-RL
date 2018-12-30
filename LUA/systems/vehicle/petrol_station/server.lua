----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


fuelStations = {
	-- San Fierro
	{ -- Doherty, SF
		markerPos	= {-2023.6999511719, 156.60000610352, 27.799999237061},
		shop			= 1,
	},
	{ -- Easter Basin, SF
		markerPos	= {-1673.5889892578,415.63830566406,6.1927061080933},
		shop			= 2,
	},
	{  -- Juniper Hollow, SF
		markerPos	= {-2414.9436035156,976.17211914063,44.296875},
		shop			= 3,
	},
	
	-- Los Santos
	{ -- Temple, LS
		markerPos	= {1007.3695068359,-939.51135253906,41.1796875},
		shop			= 15,
	},
	{ -- Idlewood, LS
		markerPos	= {1936.3382568359, -1772.1337890625, 12.3828125},
		shop			= 16,
	},
	
	-- Las Venturas
	{ -- Redsans West, LV
		markerPos	= {1596.7540283203,2198.6506347656,9.8203125},
		shop			= 8,
	},
	{ -- Spinybed, LV
		markerPos	= {2147.4040527344,2747.9719238281,9.8203125},
		shop			= 9,
	},
	{ -- ?, LV south
		markerPos	= {2114.6372070313,920.03350830078,9.8203125},
		shop			= 11,
	},
	{ -- ?, LV east
		markerPos	= {2639.4360351563,1106.1353759766,9.8203125},
		shop			= 12,
	},
	{-- The Emrand Isle, LV
		markerPos	= {2202.3811035156,2474.2165527344,9.8203125},
		shop			= 10,
	},
	
	
	-- Others
	{ -- Montommery - Red Country
		markerPos	= {1378.6822509766,458.18243408203,18.918092727661},
		shop			= 13,
	},
	{ -- Dillmore, Red Country
		markerPos	= {653.41369628906,-569.8828125,15.398251533508},
		shop			= 14,
	},
	{ -- Angle Pine, Whetstone
		markerPos	= {-2244.2653808594,-2561.2934570313,30.921875},
		shop			= 19,
	},
	{ -- Whetstone
		markerPos	= {-1606.1058349609,-2713.6232910156,47.539066314697},
		shop			= 18,
	},
	{ -- Flint Country
		markerPos	= {-93.489685058594,-1174.76953125,1.5},
		shop			= 17,
	},
	{ -- Tierra Robada
		markerPos	= {-1328.1037597656,2677.6127929688,49.0625},
		shop			= 6,
	},
	{ -- Tierra Robada, LV
		markerPos	= {-1466.3338623047,1864.6029052734,31.6328125},
		shop			= 4,
	},
	{ -- Fort Carson, Bone country
		markerPos	= {70.322196960449,1218.4035644531,17.812005996704},
		shop			= 7,
	},
	{ -- Bone Country
		markerPos	= {615.59405517578,1690.0888671875,5.9921875},
		shop			= 5,
	},
	
}

local function randomFuelPrices(trigger)
	for id, arr in pairs(fuelStations) do
		local rnd		= tonumber("1."..tostring(math.random(25, 75)))
		arr.fuelPrice	= {["diesel"] = math.round((rnd-((rnd/100)*15)), 2, "ceil"), ["petrol"] = rnd, ["elektro"] = math.round((rnd-((rnd/100)*45)), 2, "ceil")}
	end
	if (trigger) then
		triggerClientEvent(root, "updateFuelPrices", root, fuelStations)
	end
	outputDebugString("[Systems->Vehicle->PetrolStations]: Updated Fuel-Prices")
end

local function createFuelStations()
	for id, arr in pairs(fuelStations) do
		local x, y, z	= unpack(arr.markerPos)
		arr.blip		= createBlip(x, y, z, 42, 2, 255, 0, 0, 255, 0, 200, root)
		arr.col			= createColSphere(x, y, z, 18)
		
		addEventHandler("onColShapeHit", arr.col, function(elem, dim)
			if (elem and dim) then
				if (getElementType(elem) == "player") then
					
					local veh = getPedOccupiedVehicle(elem)
					if (veh and getPedOccupiedVehicleSeat(elem) == 0 and getVehicleType(veh) ~= "Plane" and getVehicleType(veh) ~= "Helicopter" and getVehicleType(veh) ~= "Boat" and getVehicleType(veh) ~= "Train" and getVehicleType(veh) ~= "Trailer") then
						infoShow(elem, "info", "Wähle die Spritart mit der Maus an der Zapfsäule.")
					end
					
				end
			end
		end)
	end
	outputDebugString("[Systems->Vehicle->PetrolStations]: Created "..(#fuelStations).." Fuel-Stations.")
	
	randomFuelPrices(false)
	setTimer(function() randomFuelPrices(true) end, ((1000*60)*60), 0)
end
addEventHandler("onResourceStart", resourceRoot, createFuelStations, true, "low-5")




function fuelVehicle(typ, liter)
	local veh		= getPedOccupiedVehicle(source)
	local tanke, _	= getNearstFuelStation(source)
	
	
	if (tonumber(tanke) ~= nil) then
		if (veh) then
			if (getPedOccupiedVehicleSeat(source) == 0) then
				
				local maxLiter, _	= getVehicleFuelSizeUsage(veh)
				local price			= round(liter*fuelStations[tanke].fuelPrice[typ])
				local percent		= (100*liter) / maxLiter
				
				local fuel = tonumber(getElementData(veh, "fuel")) or 0
				fuel = math.ceil(fuel + percent)
				if (fuel > 100) then fuel = 100 end
				setElementData(veh, "fuel", fuel)
				local vID = getVehID(veh)
				if (vID) then
					Vehicles[vID].data["fuel"] = fuel
				end
				takePlayerMoney(source, price, "Tankstelle")
				
				
				if (fuelStations[tanke].shop ~= false) then
					setElementData(source, "currentCID", 9)
					setElementData(source, "currentSID", fuelStations[tanke].shop)
					Franchise:addShopMoney(source, price)
					setElementData(source, "currentCID", nil)
					setElementData(source, "currentSID", nil)
				end
				
			end
		end
	end
end
addEvent("fuelVehicle", true)
addEventHandler("fuelVehicle", root, fuelVehicle)


addEvent("requestFuelPrices", true)
addEventHandler("requestFuelPrices", root, function()
	triggerClientEvent(client, "updateFuelPrices", client, fuelStations)
end)

addEvent("playTankSound", true)
addEventHandler("playTankSound", root, function(bool)
	local x, y, z	= getElementPosition(source)
	local col		= createColSphere(x,y,z,30)
	local pName		= getPlayerName(source)
	for k, v in pairs(getElementsWithinColShape(col, "player")) do
		triggerClientEvent(v, "playTankSound3D", v, bool, pName, x, y, z)
	end
	destroyElement(col)
end)


local fuelPumps = {
	{-2026.6000000,155.8000000,29.6000000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (1)
	{-2026.6000000,157.7000000,29.6000000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (2)
	{-1465.0000000,1860.6000000,33.4000000,0.0000000,0.0000000,4.0000000}, --object(washgaspump) (3)
	{-1601.3000000,-2707.5000000,49.5000000,0.0000000,0.0000000,324.0000000}, --object(washgaspump) (4)
	{60.4000000,1218.1000000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (5)
	{43.9003900,1220.2002000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (6)
	{43.9003900,1217.7998000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (7)
	{49.4000000,1217.9000000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (8)
	{60.2998100,1220.5000000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (9)
	{49.4000000,1220.4000000,19.7000000,0.0000000,0.0000000,272.0000000}, --object(washgaspump) (10)
	{54.8000000,1220.5000000,19.7000000,0.0000000,0.0000000,270.0000000}, --object(washgaspump) (11)
	{54.8000000,1218.0000000,19.7000000,0.0000000,0.0000000,270.0000000}, --object(washgaspump) (12)
	{1000.7000000,-937.2999900,42.9000000,0.0000000,0.0000000,7.0000000}, --object(washgaspump) (13)
	{1006.9004000,-936.5000000,42.9000000,0.0000000,0.0000000,6.9980000}, --object(washgaspump) (14)
	{-1604.7000000,-2711.8000000,49.5000000,0.0000000,0.0000000,323.9980000}, --object(washgaspump) (15)
	{-1329.8000000,2669.3999000,51.0000000,0.0000000,0.0000000,351.0000000}, --object(washgaspump) (16)
	{-1611.3000000,-2720.5000000,49.5000000,0.0000000,0.0000000,323.9980000}, --object(washgaspump) (17)
	{-1607.9000000,-2716.2000000,49.5000000,0.0000000,0.0000000,323.9980000}, --object(washgaspump) (18)
	{-1329.2000000,2674.7000000,51.0000000,0.0000000,0.0000000,350.9970000}, --object(washgaspump) (19)
	{-1328.4000000,2680.2000000,51.0000000,0.0000000,0.0000000,350.9970000}, --object(washgaspump) (20)
	{-2246.7998000,-2559.7998000,32.6100000,0.0000000,0.0000000,62.9960000}, --object(washgaspump) (21)
	{-1327.6000000,2685.6001000,51.0000000,0.0000000,0.0000000,350.9970000}, --object(washgaspump) (22)
	{-2241.5000000,-2562.2002000,32.6100000,0.0000000,0.0000000,62.9960000}, --object(washgaspump) (23)
	{-2410.7000000,970.2000100,46.0000000,0.0000000,0.0000000,270.0000000}, --object(washgaspump) (24)
	{-2410.6001000,982.7999900,46.0000000,0.0000000,0.0000000,269.9950000}, --object(washgaspump) (25)
	{-2410.7000000,976.5999800,46.0000000,0.0000000,0.0000000,270.0000000}, --object(washgaspump) (26)
	{-1465.4000000,1868.3000000,33.4000000,0.0000000,0.0000000,3.9990000}, --object(washgaspump) (27)
	{685.0999800,1606.6000000,11.0000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (28)
	{603.5000000,1707.4004000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (29)
	{607.0000000,1702.4004000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (30)
	{1601.3000000,2204.5000000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (31)
	{1596.2000000,2204.5000000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (32)
	{1590.9000000,2204.5000000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (33)
	{610.2998000,1697.2998000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (34)
	{1591.1000000,2193.6001000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (35)
	{1596.2998000,2193.6006000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (36)
	{1601.4004000,2193.6006000,11.6000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (37)
	{613.7002000,1692.5000000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (38)
	{617.0996100,1687.5996000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (39)
	{620.7002000,1682.7998000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (40)
	{1384.3000000,458.6000100,20.8800000,0.0000000,0.0000000,336.0000000}, --object(washgaspump) (41)
	{1379.9004000,460.5996100,20.8800000,0.0000000,0.0000000,335.9950000}, --object(washgaspump) (42)
	{624.0996100,1677.7998000,7.6900000,0.0000000,0.0000000,34.9970000}, --object(washgaspump) (43)
	{2634.8999000,1100.9000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (44)
	{2639.7998000,1111.7998000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (45)
	{2634.7998000,1111.7998000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (46)
	{2645.0000000,1111.7998000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (47)
	{2120.2000000,925.5999800,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (48)
	{2645.0000000,1100.9004000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (49)
	{2114.8000000,925.5000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (50)
	{2640.0000000,1100.9004000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (51)
	{2110.0000000,925.5000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (52)
	{2114.6001000,914.7000100,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (53)
	{2109.7000000,914.7000100,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (54)
	{2120.1001000,914.7000100,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (55)
	{2196.9004000,2474.7002000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (56)
	{2196.9004000,2479.9004000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (57)
	{2197.0000000,2469.9004000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (58)
	{2147.7000000,2753.3999000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (59)
	{2142.3999000,2753.3999000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (60)
	{2152.9004000,2753.4004000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (61)
	{2142.1001000,2742.5000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (62)
	{2152.5000000,2742.5000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (63)
	{2147.6006000,2742.5000000,11.5000000,0.0000000,0.0000000,0.0000000}, --object(washgaspump) (64)
	{2207.7002000,2469.9004000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (65)
	{2207.7002000,2479.9004000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (66)
	{2207.7002000,2475.0000000,11.4900000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (67)
	{655.7000100,-558.7000100,17.1000000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (68)
	{-1477.8000000,1867.3000000,33.4000000,0.0000000,0.0000000,3.9990000}, --object(washgaspump) (69)
	{655.7000100,-571.2000100,17.1000000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (70)
	{-1477.5000000,1859.6000000,33.4000000,0.0000000,0.0000000,3.9990000}, --object(washgaspump) (71)
	{1941.7000000,-1767.4000000,14.1500000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (72)
	{1941.7000000,-1778.4000000,14.1500000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (73)
	{1941.7000000,-1771.3000000,14.1500000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (74)
	{1941.7000000,-1774.4000000,14.1500000,0.0000000,0.0000000,90.0000000}, --object(washgaspump) (75)
}
for i, v in ipairs(fuelPumps) do
	local x, y, z, rx, ry, rz	= unpack(v)
	local pump					= createObject(1676, x, y, z, rx, ry, rz)
	
	
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, 0.5, 0.5, -0.8, 0, 90, 90) --l
	setElementData(tp, "fuelTyp", "petrol")
	setElementData(tp, "parent", pump)
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, 0, 0.5, -0.8, 0, 90, 90) --m
	setElementData(tp, "fuelTyp", "diesel")
	setElementData(tp, "parent", pump)
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, -0.5, 0.5, -0.8, 0, 90, 90) --r
	setElementData(tp, "fuelTyp", "elektro")
	setElementData(tp, "parent", pump)
	
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, -0.5, -0.5, -0.8, 0, 90, 270) --l
	setElementData(tp, "fuelTyp", "petrol")
	setElementData(tp, "parent", pump)
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, 0, -0.5, -0.8, 0, 90, 270) --m
	setElementData(tp, "fuelTyp", "diesel")
	setElementData(tp, "parent", pump)
	local tp = createObject(1656, 0, 0, 0)
	setElementAlpha(tp, 0)
	attachElements(tp, pump, 0.5, -0.5, -0.8, 0, 90, 270) --r
	setElementData(tp, "fuelTyp", "elektro")
	setElementData(tp, "parent", pump)
end
