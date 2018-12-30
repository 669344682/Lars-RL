----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

houseInteriors = {
	[1] = {1, 223.27027893066, 1287.4304199219, 1081.9130859375},
	[2] = {8, 2365.224609375, -1135.1401367188, 1050.875},
	[3] = {11, 2282.9448242188, -1139.9676513672, 1050.8984375},
	[4] = {6, 2196.373046875, -1204.3984375, 1049.0234375},
	[5] = {10, 2270.2353515625, -1210.4715576172, 1047.5625},
	[6] = {6, 2309.1716308594, -1212.6801757813, 1049.0234375},
	[7] = {8, 2807.619873, -1171.899902, 1025.0234375},
	[8] = {2, 2237.5483398438, -1081.1091308594, 1049.0234375},
	[9] = {9, 2318.0712890625, -1026.2338867188, 1050.2109375},
	[10] = {4, 260.99948120117, 1284.8186035156, 1080.2578125},
	[11] = {5, 140.2495880127, 1366.5075683594, 1083.859375},
	[12] = {9, 82.978126525879, 1322.5451660156, 1083.8662109375},
	[13] = {15, -284.0530090332, 1471.0965576172, 1084.375},
	[14] = {4, -260.75534057617, 1456.6932373047, 1084.3671875},
	[15] = {8, -42.373157501221, 1405.9846191406, 1084.4296875},
	[16] = {2, 2454.717041, -1700.871582, 1013.515197},
	[17] = {5, 318.564971, 1118.209960, 1083.84},
	[18] = {12, 2324.419921, -1145.568359, 1050.0234375},
	[19] = {5, 1298.8719482422, -796.77032470703, 1083.6569824219},
	
	[20] = {1, 2527.654052, -1679.388305, 1015.515197},--kacke
	[21] = {5, 2350.339843, -1181.649902, 1028.0},--kacke
	[22] = {6, 346.870025, 309.259033, 999.148437},
}

function getInteriorData(int)
	return unpack(houseInteriors[tonumber(int)])
end



if (not localPlayer) then
	function iraum(player, _, i)
		--if (player:hasAdminLvl(2)) then
			if (i) then
				local int, intx, inty, intz = getInteriorData(i)
				setElementInterior(player, int)
				setElementPosition(player, intx, inty, intz)
			else
				setElementInterior(player, 0, 0, 0, 5)
			end
		--end
	end
	addCommandHandler("iraum", iraum)


	-- Fixes
	setElementInterior(createObject(3064, 2338.1162, -1181.923, 1033.187, 0, 0, 90), 5)
	setElementInterior(createObject(2950, 2330.3926, -1179.16, 1030.547), 5)
	setElementInterior(createObject(3063, 2340.281, -1182.293, 1026.968, 0, 0, 90), 5)

	local t = {
		{974, 2527.8, -1684.6, 1016.2, 0, 0, 90},
		{974, 2533.2, -1684.3, 1016, 0, 0, 90},
		{974, 2530.2, -1683.6, 1014.4, 90, 0, 0},
		{974, 2525.7, -1681.1, 1017, 0, 0, 0},
		{974, 2530.8, -1683.1, 1018.1, 90, 0, 0},
		{974, 2530.6, -1686, 1017, 0, 0, 0},
		{3093, 2523.6, -1680.1, 1015.9, 0, 0, 0},
		{970, 2531.5, -1681, 1016.3, 0, 90, 0},
		{970, 2532.6, -1681, 1016.2, 0, 90, 0},
	}
	for k, v in pairs(t) do
		local o = createObject(unpack(v))
		setElementInterior(o, 1)
		setElementAlpha(o, 0)
	end
	
end
----------------------------------------

furnitureToRemove = {[15036]=true,[14720]=true,[14384]=true,[2153]=true,[2154]=true,[2152]=true,[2151]=true,[2155]=true,[2141]=true,[2133]=true,[2134]=true,[2341]=true,[2129]=true,[2130]=true,[2127]=true,[2304]=true,[2016]=true,[2014]=true,[2015]=true,[2018]=true,[2019]=true,[2022]=true,[2013]=true,[2017]=true,[2148]=true,[2142]=true,[2145]=true,[2143]=true,[2334]=true,[2335]=true,[2158]=true,[2338]=true,[2139]=true,[2140]=true,[2305]=true,[2137]=true,[2138]=true,[2135]=true,[2136]=true,[2303]=true,[936]=true,[937]=true,[941]=true,[2147]=true,[2144]=true,[2170]=true,[2417]=true,[2128]=true,[1209]=true,[1594]=true,[1968]=true,[643]=true,[1969]=true,[1825]=true,[1432]=true,[2799]=true,[2802]=true,[2763]=true,[2762]=true,[2764]=true,[2644]=true,[1770]=true,[2117]=true,[1737]=true,[2030]=true,[2109]=true,[2807]=true,[2121]=true,[1810]=true,[2636]=true,[2124]=true,[2123]=true,[2125]=true,[2350]=true,[2723]=true,[14446]=true,[1799]=true,[1797]=true,[2302]=true,[1725]=true,[1802]=true,[14866]=true,[1803]=true,[1745]=true,[1794]=true,[1798]=true,[2299]=true,[1793]=true,[1795]=true,[1801]=true,[2575]=true,[2566]=true,[2298]=true,[2565]=true,[2300]=true,[2301]=true,[2563]=true,[2564]=true,[1796]=true,[1812]=true,[1800]=true,[14867]=true,[2307]=true,[2329]=true,[2330]=true,[2088]=true,[2025]=true,[2323]=true,[1741]=true,[2094]=true,[1416]=true,[1417]=true,[2306]=true,[2095]=true,[1740]=true,[2328]=true,[2021]=true,[1730]=true,[2570]=true,[2562]=true,[2568]=true,[2631]=true,[2632]=true,[2818]=true,[2817]=true,[2833]=true,[2836]=true,[2841]=true,[2835]=true,[2815]=true,[2834]=true,[2847]=true,[2842]=true,[1828]=true,[2069]=true,[2071]=true,[2072]=true,[2108]=true,[2023]=true,[2106]=true,[2105]=true,[2196]=true,[1731]=true,[1736]=true,[14705]=true,[2870]=true,[2868]=true,[2869]=true,[2853]=true,[2813]=true,[2828]=true,[2257]=true,[2258]=true,[2256]=true,[2283]=true,[2286]=true,[2276]=true,[2277]=true,[2284]=true,[2281]=true,[2280]=true,[2282]=true,[2778]=true,[2681]=true,[2779]=true,[1726]=true,[1727]=true,[1710]=true,[1709]=true,[1766]=true,[1761]=true,[1760]=true,[1757]=true,[1764]=true,[1763]=true,[1712]=true,[2290]=true,[1768]=true,[1703]=true,[1706]=true,[1702]=true,[1711]=true,[1735]=true,[1769]=true,[1755]=true,[1759]=true,[1758]=true,[1762]=true,[1767]=true,[1765]=true,[1754]=true,[1724]=true,[1705]=true,[2617]=true,[2571]=true,[2295]=true,[2096]=true,[1714]=true,[1715]=true,[2356]=true,[2204]=true,[2200]=true,[2167]=true,[2078]=true,[2089]=true,[2063]=true,[1742]=true,[1743]=true,[2087]=true,[2296]=true,[2297]=true,[2180]=true,[2315]=true,[2080]=true,[2119]=true,[2311]=true,[2126]=true,[2236]=true,[1822]=true,[2118]=true,[1813]=true,[2357]=true,[2319]=true,[2321]=true,[2083]=true,[2082]=true,[2084]=true,[1823]=true,[2111]=true,[2112]=true,[1821]=true,[1815]=true,[1819]=true,[2116]=true,[1821]=true,[1817]=true,[1814]=true,[1818]=true,[2314]=true,[2346]=true,[2321]=true,[2313]=true,[1946]=true,[3496]=true,[947]=true,[2984]=true,[14467]=true,[2744]=true,[2745]=true,[970]=true,[1480]=true,[1451]=true,[3461]=true,[1481]=true,[1364]=true,[3261]=true,[1639]=true,[1281]=true,[1280]=true,[1215]=true,[748]=true,[749]=true,[750]=true,[751]=true,[3439]=true,[1647]=true,[1646]=true,[1645]=true,[1255]=true,[1407]=true,[1408]=true,[1419]=true,[1418]=true,[1446]=true,[14720]=true,[2100]=true,[2869]=true,[2302]=true,[2084]=true,[2828]=true,[2868]=true,[1703]=true,[2225]=true,[2227]=true,[2811]=true,[2030]=true,[2125]=true,[2087]=true,[2103]=true,[2298]=true,[2302]=true,[2331]=true,[2333]=true,[2339]=true,[2132]=true,[2812]=true,[2822]=true,[2829]=true,[2830]=true,[2831]=true,[2832]=true,[2862]=true,[2863]=true,[2864]=true,[2865]=true,[2107]=true,[2077]=true,[2070]=true,[2289]=true,[2288]=true,[2287]=true,[2286]=true,[2285]=true,[2284]=true,[2283]=true,[2282]=true,[2281]=true,[2279]=true,[2278]=true,[2277]=true,[2276]=true,[2275]=true,[2274]=true,[2273]=true,[2272]=true,[2271]=true,[2270]=true,[2269]=true,[2268]=true,[2267]=true,[2266]=true,[2265]=true,[2264]=true,[2263]=true,[2262]=true,[2261]=true,[2260]=true,[2259]=true,[2258]=true,[2257]=true,[2256]=true,[2255]=true,[2254]=true,[15037]=true,[2099]=true,[2244]=true,[1717]=true,[15040]=true,[2115]=true,[2131]=true,[2816]=true,[2852]=true,[2853]=true,[2854]=true,[2855]=true,[2857]=true,[2858]=true,[2859]=true,[2860]=true,[2861]=true,[2866]=true,[2867]=true,[2249]=true,[2090]=true,[2241]=true,[2247]=true,[2240]=true,[2252]=true,[2235]=true,[1816]=true,[2248]=true,[2064]=true,[2060]=true,[2046]=true,[2091]=true,[14860]=true,[2156]=true,[2157]=true,[2159]=true,[2160]=true,[2242]=true,[1739]=true,[2224]=true,[2229]=true,[2104]=true,[2243]=true,[2291]=true,[2203]=true,[2079]=true,[2194]=true,[2165]=true,[1739]=true,[14741]=true,[14745]=true,[1748]=true,[1785]=true,[2670]=true,[2671]=true,[2672]=true,[2673]=true,[2674]=true,[2675]=true,[2676]=true,[2677]=true,[1750]=true,[1728]=true,[1720]=true,[2821]=true,[2823]=true,[2837]=true,[2838]=true,[2839]=true,[2840]=true,[2856]=true,[2843]=true,[2844]=true,[2845]=true,[2846]=true,[2336]=true,[2337]=true,[2086]=true,[948]=true,[2118]=true,[14401]=true,[2290]=true,[2293]=true,[2291]=true,[2292]=true,[1788]=true,[2028]=true,[14392]=true,[2332]=true,[2124]=true,[2029]=true,[1708]=true,[2230]=true,[2225]=true,[2305]=true,[1713]=true,[1827]=true,[2331]=true,[1759]=true,[1763]=true,[2236]=true,[2318]=true,[1719]=true,[2315]=true,[2103]=true,[2346]=true,[2095]=true,[2090]=true,[2330]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,[2280]=true,}

local function removeFurnitureShit()
	for model, _ in pairs(furnitureToRemove) do
		for i, arr in ipairs(houseInteriors) do
			local int, intx, inty, intz = getInteriorData(i)
			removeWorldModel(model, 400, intx, inty, intz, int)
		end
	end
end
removeFurnitureShit()

if (localPlayer) then
	local lastInt = 0
	addEventHandler("onClientRender", root, function()
		local int = getElementInterior(localPlayer)
		if (int ~= lastInt) then
			setTimer(function()
				removeFurnitureShit()
			end, 750, 1)
			lastInt = int
		end
	end)
end

























--[[
dontRemove = {[1502]=true, [14719]=true, [14526]=true, [15055]=true, [1567]=true, [1506]=true, [15032]=true, [1535]=true, [1491]=true, [15040]=true, [15054]=true, [1501]=true, [1498]=true, [15050]=true, [15064]=true, [15029]=true, [15030]=true, [15033]=true, [15034]=true, [15053]=true, [11501]=true, [11502]=true, [11503]=true, [15031]=true, [15041]=true, [15042]=true, [15046]=true, [15048]=true, [15055]=true, [15058]=true, [15059]=true, [16150]=true, [15025]=true, [15026]=true, [15032]=true, [11150]=true, [15040]=true, [15050]=true, [15063]=true, [14713]=true, [14763]=true, [14761]=true, [14764]=true, [14715]=true, [14716]=true, [14717]=true, [14718]=true, [14735]=true, [14736]=true, [14746]=true, [14748]=true, [14750]=true, [14758]=true, [14759]=true, [14760]=true, [14771]=true, [14749]=true, [14719]=true, [14745]=true, [14740]=true, [14747]=true, [14751]=true, [14752]=true, [14753]=true, [14762]=true, [14757]=true, [14744]=true, [14743]=true, [14801]=true, [14803]=true, [14859]=true, [14865]=true, [14889]=true, [14815]=true, [14821]=true, [14888]=true, [14819]=true, [14852]=true, [14892]=true, [14891]=true, [14874]=true, [14877]=true, [14475]=true, [15048]=true, [15059]=true, [14388]=true, [1389]=true, [14390]=true, [14484]=true, [14485]=true, [14483]=true, [14436]=true, [14435]=true, [14439]=true, [14438]=true, [14434]=true, [14433]=true, [14432]=true, [14437]=true, [14442]=true, [14448]=true, [14444]=true, [14445]=true, [14447]=true, [14449]=true, [14443]=true, [14441]=true, [14440]=true, [14403]=true, [14383]=true, [14388]=true, [14389]=true, [14387]=true, [14488]=true, [14401]=true, [2629]=true, [2630]=true, [1985]=true, [14392]=true, [947]=true, [2627]=true, [2631]=true, [1536]=true, [14890]=true,[13360] = true,[14638] = true,[14819] = true,[14822] = true,[14823] = true,[14824] = true,[16637] = true,[14528] = true,[14525] = true,[14522] = true,[14523] = true,[14527] = true,[14512] = true,[14510] = true,[14514] = true,[14515] = true,[14530] = true,[14538] = true, [14763] = true,[14496] = true,[14492] = true,[14495] = true,[17698] = true,[17926] = true,[17566] = true,[14494] = true,[14634] = true,[14631] = true,[14615] = true,[14541] = true,[18073] = true,[18071] = true,[15045] = true,[11663] = true,[14754] = true,[15048] = true,[3425] = true,[14474] = true,[14478] = true,[14479] = true,[14471] = true,[14476] = true,[14473] = true,[14470] = true}
for i = 1491, 1508 do
	dontRemove[i] = true
end
for i = 2944, 2952 do
	dontRemove[i] = true
end
for i = 14754, 14756 do
	dontRemove[i] = true
end
for i = 14700, 14703 do
	dontRemove[i] = true
end
for i = 14706, 14714 do
	dontRemove[i] = true
end
for i = 2514, 2528 do
	dontRemove[i] = true
end
for i = 1498, 1508 do
	dontRemove[i] = true
end
for i = 14722, 14727 do
	dontRemove[i] = true
end
for i = 2738, 2742 do
	dontRemove[i] = true
end
for i = 14417, 14431 do
	dontRemove[i] = true
end
for i = 14390, 14399 do
	dontRemove[i] = true
end


function clearHouses()
	outputDebugString("[Systems->House->clearHouses()]: Removing Interior Furniture...")
	for model = 1000, 20000 do
		if (not dontRemove[model]) then
			for i, arr in ipairs(houseInteriors) do
			
				local int, intx, inty, intz = getInteriorData(i)
				removeWorldModel(model, 400, intx, inty, intz, int)
				
			end
		end
	end
	outputDebugString("[Systems->House->clearHouses()]: Removed Interior Furniture.")
	return true
end
--addEventHandler("onResourceStart", resourceRoot, clearHouses, true, "low-750")
--addCommandHandler("hcl", clearHouses)
]]
