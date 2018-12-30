----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local weatherIDs = {
	["sunny"]			= { 0, 1, 10, 11, 13, 14, 17, 18 },
	["clouds"]			= { 2, 3, 4, 5, 6, 20 },
	["fog"]				= { 9 },
	["thunderstorm"]	= { 8, 16 },
	["sandstorm"]		= { 19 },
	["rainy"]			= { 4, 7, 20 },
	["dull"]			= { 12, 15 },
	["snow"]			= { 12 },
}

-- http://openweathermap.org/weather-conditions
local weatherDetails = {
	--["weather description"]			= { "weatherIDs",	RAINLEVEL, "Readable Name" }
	
	-- Group 2xx: Thunderstorm --
	["light thunderstorm"]				= { "thunderstorm", 0.00, "leichtes Gewitter"},
	["thunderstorm"]					= { "thunderstorm", 0.00, "Gewitter"},
	["heavy thunderstorm"]				= { "thunderstorm", 0.00, "starkes Gewitter" },
	["ragged thunderstorm"]				= { "thunderstorm", 0.00, "starkes Gewitter" },
	
	["thunderstorm with light drizzle"] = { "thunderstorm", 0.20, "Gewitter mit leichtem Sprühregen" },
	["thunderstorm with drizzle"]		= { "thunderstorm", 0.25, "Gewitter mit Sprühregen" },
	["thunderstorm with heavy drizzle"] = { "thunderstorm", 0.30, "Gewitter mit starkem Sprühregen" },
	
	["thunderstorm with light rain"]	= { "thunderstorm", 0.35, "Gewitter mit leichtem Regen" },
	["thunderstorm with rain"]			= { "thunderstorm", 0.50, "Gewitter mit Regen" },
	["thunderstorm with heavy rain"]	= { "thunderstorm", 0.80, "Gewitter mit starkem Regen" },
	
	-- Group 3xx: Drizzle --
	["drizzle"]							= { "rainy",		0.17, "leichtes Nieseln" },
	["light intensity drizzle"]			= { "rainy",		0.20, "leichter Sprühregen" },
	["light intensity drizzle rain"]	= { "rainy",		0.20, "leichter Sprühregen" },
	
	["shower drizzle"]					= { "rainy",		0.25, "mäßiger Sprühregen"},
	["shower rain and drizzle"]			= { "rainy",		0.25, "mäßiger Sprühregen"},
	["drizzle rain"]					= { "rainy",		0.25, "mäßiger Sprühregen"},
	
	["heavy intensity drizzle"]			= { "rainy",		0.30, "starker Sprühregen" },
	["heavy intensity drizzle rain"]	= { "rainy",		0.30, "starker Sprühregen"},
	["heavy shower rain and drizzle"]	= { "rainy",		0.30, "starker Sprühregen"},
	
	
	-- Group 5xx: Rain --
	["light intensity shower rain"]		= { "rainy",		0.35, "leichte Schauer" },
	["light rain"]						= { "rainy",		0.35, "leichter Regen" },
	["shower rain"]						= { "rainy",		0.50, "einige Schauer" },
	["freezing rain"]					= { "rainy",		0.50, "mäßiger Regen" },
	["moderate rain"]					= { "rainy",		0.50, "mäßiger Regen" },
	["heavy intensity shower rain"]		= { "rainy",		0.80, "starke Schauer" },
	["heavy intensity rain"]			= { "rainy",		0.80, "starker Regen" },
	["very heavy rain"]					= { "rainy",		0.90, "sehr starker Regen"},
	["extreme rain"]					= { "rainy",		1.00, "sehr starker Regen"},
	["hail"]							= { "rainy",		1.25, "Hagel, Regnerisch" },
	
	-- Group 6xx: Snow --
	["light snow"]						= { "snow",			0.00, "leichter Schneefall" },
	["light shower snow"]				= { "snow",			0.00, "leichter Schneefall" },
	["snow"]							= { "snow",			0.00, "mäßiger Schneefall" },
	["shower snow"]						= { "snow",			0.00, "Schneefall" },
	["heavy snow"]						= { "snow",			0.00, "staker Schneefall" },
	["heavy shower snow"]				= { "snow",			0.00, "starker Schneefall" },
	["light rain and snow"]				= { "snow",			0.50, "leichter Schneeregen" },
	["sleet"]							= { "snow",			0.50, "Schneeregen" },
	["shower sleet"]					= { "snow",			0.50, "Schneeregen" },
	["rain and snow"]					= { "snow",			0.50, "Schneeregen" },
	
	-- Group 7xx: Atmosphere --
	["mist"]							= { "fog",			0.00, "Nebelig" },
	["smoke"]							= { "fog",			0.00, "Nebelig" },
	["haze"]							= { "fog",			0.00, "Nebelig" },
	["sand, dust whirls"]				= { "sandstorm",	0.00, "Sandsturm"},
	["fog"]								= { "fog",			0.00, "Nebelig" },
	["sand"]							= { "sandstorm",	0.00, "leichter Sandsturm" },
	["dust"]							= { "fog",			0.00, "Nebelig" },
	["volcanic ash"]					= { "fog",			0.00, "Nebelig" },
	["squalls"]							= { "clouds",		0.00, "Windböen" },
	["tornado"]							= { "clouds",		0.00, "Tornado" },
	
	-- Group 800: Clear --
	["clear sky"]						= { "sunny",		0.00, "Sonnig, klarer Himmel" },
	
	-- Group 80x: Clouds --
	["few clouds"]						= { "sunny",		0.00, "Sonnig, leicht bewölkt" },
	["scattered clouds"]				= { "sunny",		0.00, "Sonnig, vereinzelt bewölkt" },
	["broken clouds"]					= { "sunny",		0.00, "Sonnig, einige Wolken" },
	["overcast clouds"]					= { "dull",			0.00, "Bedeckter Himmel" },
	
	-- Group 90x: Extreme --
	["tropical storm"]					= { "clouds",		0.00, "Tornado" },
	["hurricane"]						= { "clouds",		0.00, "Hurricane" },
	["cold"]							= { "sunny",		0.00, "Sonnig" },
	["hot"]								= { "sunny",		0.00, "Sonnig" },
	["windy"]							= { "clouds",		0.00, "Windig" },
	
	-- Group 9xx: Additional --
	["calm"]							= { "clouds",		0.00, "Windig" },
	["light breeze"]					= { "sunny",		0.00, "Sonning" },
	["gentle breeze"]					= { "sunny",		0.00, "Sonning" },
	["moderate breeze"]					= { "sunny",		0.00, "Sonning" },
	["fresh breeze"]					= { "sunny",		0.00, "Sonning" },
	["strong breeze"]					= { "sunny",		0.00, "Sonning" },
	["high wind, near gale"]			= { "clouds",		0.00, "Sehr windig" },
	["gale"]							= { "clouds",		0.00, "Stürmisch" },
	["serve gale"]						= { "clouds",		0.00, "sehr Stürmisch" },
	["storm"]							= { "clouds",		0.00, "Sturm" },
	["violent storm"]					= { "clouds",		0.00, "starker Sturm" },
}


local lastLoc			= ""
local lastWname 		= ""
local lastWeatherData	= nil
local tunnelFluted		= false
function setTheWeather(json)
	if (lastWeatherData ~= json) then
		
		local wIDname, rain, weatherName	= unpack(weatherDetails[(json["desc"])])
		local wID							= weatherIDs[tostring(wIDname)]
		local wID							= wID[math.random(#wID)]
		
		if (rain > 0 and tunnelFluted == false) then
			createBankWaters()
			tunnelFluted = true
		elseif (rain == 0 and tunnelFluted == true) then
			removeBankWaters()
			tunnelFluted = false
		end
		
		local waveHeight					= 0.03 * json["wind_speed"]
		setWeather(wID)
		setRainLevel(rain)
		setWaveHeight(waveHeight)
		
		-- Wolken
		if (wIDname == "fog" or wIDname == "dull" or string.find(string.lower(weatherName), "bewölkt") ~= nil or string.find(string.lower(weatherName), "wolken") ~= nil) then
			setCloudsEnabled(true)
		else
			setCloudsEnabled(false)
		end
		
		-- Hitzewellen
		resetHeatHaze()
		if (json["temp"] >= 28) then
			setHeatHaze(json["temp"], 5, 100, 1000)
		end
		
		-- Nebel
		resetFogDistance()
		if (wIDname == "fog") then
			if (json["visibility"] < 4500) then
				setFogDistance(450)
			elseif (json["visibility"] < 3000) then
				setFogDistance(350)
			elseif (json["visibility"] < 2500) then
				setFogDistance(250)
			elseif (json["visibility"] < 2000) then
				setFogDistance(150)
			elseif (json["visibility"] < 1500) then
				setFogDistance(0)
			elseif (json["visibility"] < 1000) then
				setFogDistance(-200)
			elseif (json["visibility"] < 500) then
				setFogDistance(-400)
			end
		end
		
		-- Schnee
		if (wIDname == "snow") then
			-- TODO
		end
		
		
		-- Sonne
		--[[
			TODO
			
			
			Sonnenaufgang in MTA:
			
			Sonne zu sehen ab 5:05
			Höchster punkt um: 13:30
			Untergang um: 19:04
			Sonnenstunden in MTA: 14h
		]]
		
		
		
		-- Wind
		local windPerKmh		= 0.045
		local rotationName		= ""
		local rotationNameShort = ""
		local wx, wy			= 0, 0
		if (tonumber(json["wind_deg"]) == nil) then json["wind_deg"] = 0 end
		if (json["wind_deg"] >= 348.75 or (json["wind_deg"] >= 0 and json["wind_deg"] <= 11.25)) then -- N
			wx, wy = 0, (json["wind_speed"]*windPerKmh)
			rotationName = "Norden"
			rotationNameShort = "N"
		elseif (json["wind_deg"] >= 11.25 and json["wind_deg"] <= 78.75) then -- NNE / NE / ENE
			wx, wy = ((json["wind_speed"] / 2)*windPerKmh), (json["wind_speed"]*windPerKmh)
			rotationName = "Nord-Osten"
			rotationNameShort = "NO"
		elseif (json["wind_deg"] >= 78.75 and json["wind_deg"] <= 101.25) then -- E
			wx, wy = (json["wind_speed"]*windPerKmh), 0
			rotationName = "Osten"
			rotationNameShort = "O"
		elseif (json["wind_deg"] >= 101.25 and json["wind_deg"] <= 168.75) then -- ESE / SE / SSE
			wx, wy = (json["wind_speed"]*windPerKmh), (((json["wind_speed"]*windPerKmh) / 2) * -1)
			rotationName = "Süd-Osten"
			rotationNameShort = "SO"
		elseif (json["wind_deg"] >= 168.75 and json["wind_deg"] <= 191.25) then -- S
			wx, wy = 0, ((json["wind_speed"]*windPerKmh) * -1)
			rotationName = "Süden"
			rotationNameShort = "S"
		elseif (json["wind_deg"] >= 191.25 and json["wind_deg"] <= 258.75) then -- SSW / SW / WSW
			wx, wy = (((json["wind_speed"]*windPerKmh) / 2) * -1), ((json["wind_speed"]*windPerKmh) * -1)
			rotationName = "Süd-Westen"
			rotationNameShort = "SW"
		elseif (json["wind_deg"] >= 258.75 and json["wind_deg"] <= 281.25) then -- W
			wx, wy = (json["wind_speed"]*windPerKmh), 0
			rotationName = "Westen"
			rotationNameShort = "W"
		elseif (json["wind_deg"] >= 281.25 and json["wind_deg"] <= 348.75) then -- NNW / NW / WNW
			wx, wy = ((json["wind_speed"]*windPerKmh) * -1), ((json["wind_speed"]*windPerKmh) / 2)
			rotationName = "Nord-Westen"
			rotationNameShort = "NW"
		end
		setWindVelocity(wx, wy, 0)
		
		
		if (weatherName ~= lastWname) then
			outputChatBox("Wetter in "..lastLoc..": "..weatherName.." mit "..json['wind_speed'].." Km/h Richtung "..rotationName.." , einer Wellenhöhe von bis zu "..waveHeight.."m und "..json["temp"].."°C.", root, 255, 155, 0)
		end
		
		
		lastWname		= weatherName
		lastWeatherData = json
		
		local dataTbl = {
			["location"]		= lastLoc,
			["weatherName"]		= weatherName,
			["waveHeight"]		= waveHeight,
			["windRotation"]	= rotationName,
			["windRotationS"]	= rotationNameShort,
		}
		tableMerge(dataTbl, lastWeatherData)

		setElementData(root, "weatherData", dataTbl)
	end
end

function updateWeather(loc)
	lastLoc = loc
	local u = settings.general.webserverURL.."/api/weather.php?loc="..urlencode(loc).."&apiAuth="..hash('sha256', loc..settings.general.apiSalz)
	fetchRemote(u, function(data)
		if (data ~= "") then
			local json = fromJSON(data)
			if (json) then
				setTheWeather(json)
			end
		end
	end)
	
	setTimer(updateWeather, 30*60000, 1, loc)
end
updateWeather('Hagen,DE')

addCommandHandler("setw", function(p,c,loc)
	updateWeather(loc)
end)

-- Tunnelüberflutung
local BankWaters = {}
local BankFixWaters = {}
local function createBankWater(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
	
	local water = createWater(x1, y1, -1, x2, y2, -1, x3, y3, -1, x4, y4, -1)
	local nr = (#BankWaters+1)
	BankWaters[nr] = water
	
	setTimer(function(nr, zPos)
		for i = 1, 4 do
			local x, y, z = getWaterVertexPosition(BankWaters[nr], i)
			local nZ = z+0.1
			if (nZ < zPos[i]) then
				setWaterVertexPosition(BankWaters[nr], i, x, y, nZ)
			end
		end
	end, 750, 250, nr, {z1,z2,z3,z4})
	
	
	
	return water
end

function removeBankWaters()
	setTimer(function()
		for k, v in ipairs(BankFixWaters) do
			destroyElement(v)
		end
	end, (60*2.5)*1000, 1)
	
	setTimer(function()
		for k, v in ipairs(BankWaters) do
			for i = 1, 4 do
				local x, y, z = getWaterVertexPosition(v, i)
				setWaterVertexPosition(v, i, x, y, z-0.2)
			end
		end
	end, 7500, 50)
	
end

function createBankWaters()
	createBankWater(1320.6, -1704, 9.0, 1450.5, -1704, 9.0, 1320.6, -0945.6, 010, 1450.5, -0945.6, 010)
	createBankWater(1320.6, -1900, 9.3, 1474.0, -1900, 8.1, 1320.6, -1690.0, 9.3, 1474.0, -1690.0, 8.1)
	createBankWater(1320.6, -1900, 9.0, 1990.0, -1900, 5.0, 1320.6, -1722.0, 9.0, 1990.6, -1722.0, 5.0)
	createBankWater(1613.0, -1723.0, 7.3, 1624.0, -1723.0, 7.3, 1613.0, -1685.5, 6.0, 1624.0, -1685.5, 6.0)
	createBankWater(1989.0, -1870, 5.0, 2550.0, -1870, 5.0, 1989.0, -1820.0, 5.0, 2550.0, -1820.0, 5.0)
	createBankWater(2535.0, -1650, 5.5, 2700.0, -1650, 5.5, 2535.0, -1454.0, 022, 2700.0, -1454.0, 022)
	createBankWater(2535.0, -2075, 4.0, 2700.0, -2075, 4.0, 2535.0, -1650.0, 5.5, 2700.0, -1650.0, 5.5)
	createBankWater(2535.0, -2239, 0.0, 2700.0, -2239, 0.0, 2535.0, -2075, 4.0, 2700.0, -2075, 4.0)
	createBankWater(1950.0, -2248.0, 6, 2530.0, -2248.0, 6, 1950.0, -1885.0, 8.8, 2530.0, -1885.0, 8.8)
	createBankWater(1950.0, -1885.0, 8.8, 2015.0, -1885.0, 8.8, 1950.0, -1868, 4.8, 2015.0, -1868, 4.8)
	
	setTimer(function()
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2343.2, -2238.3, 6, 0, 0, 135.25) -- Poolwater fix zum meer hin
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2293.8, -2289.2, 5.2, 0, 0, 135) -- Poolwater fix zum meer hin
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2383.4, -2279.4, 5.2, 0, 0, 135) -- Poolwater fix zum meer hin
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2373.3, -2269.2, 5.6, 0, 0, 135) -- Poolwater fix zum meer hin
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2364.6, -2257.6, 6, 0, 0, 135) -- Poolwater fix zum meer hin
		BankFixWaters[(#BankFixWaters+1)] = createObject(10444, 2355.7, -2246.1, 6, 0, 0, 135) -- Poolwater fix zum meer hin
		local o = createObject(7916, 2398.3, -2298.3, 3.8, 0, 5.55, 44) -- Wasserfall bei Poolfix
		setObjectScale(o, 0.5)
		BankFixWaters[(#BankFixWaters+1)] = o

		BankFixWaters[(#BankFixWaters+1)] = createObject(7916, 2598.9, -1455.6, 24.5) -- Wasserfall am Staudamm
		BankFixWaters[(#BankFixWaters+1)] = createObject(7916, 2599.6, -1456.5, 24.3, 0, 0, 351) -- Wasserfall am Staudamm
	end, (60*2.5)*1000, 1)
	
end