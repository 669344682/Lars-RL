----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local JobID					= 1
local pricePerTrainBox		= 100
local pricePerLkwBox		= 60

local trainPlaces = {
	{
		markerPosH	= {2255.3, -2266.1, 14.4},
		markerPosV	= {2252.7, -2263.2, 14.4},
		forkliftPos		= {2246.1, -2257.2, 14.6},
		currentPlayer	= false,
		lastDelivery	= 0,
		
		kistenTruck	= { -- +1.06
			{
				pos = {2228.3, -2240.1, 14.8},
			},
			{
				pos = {2229.4, -2239.3, 14.8},
			},
			{
				pos = {2229.4, -2241.2, 14.8},
			},
			{
				pos = {2230.5, -2240.4, 14.8},
			},
			{
				pos = {2230.5, -2242.3, 14.8},
			},
			{
				pos = {2231.6, -2241.5, 14.8},
			},
			{
				pos = {2231.6, -2243.4, 14.8},
			},
			{
				pos = {2232.7, -2242.6, 14.8},
			},
			{
				pos = {2232.7, -2244.5, 14.8},
			},
			{
				pos = {2233.8, -2243.7, 14.8},
			},
			{
				pos = {2233.8, -2245.6, 14.8},
			},
			{
				pos = {2234.9, -2244.8, 14.8},
			},
			{
				pos = {2234.9, -2246.7, 14.8},
			},
			{
				pos = {2236, -2245.9, 14.8},
			},
			{
				pos = {2236, -2247.8, 14.8},
			},
			{
				pos = {2237.1, -2247, 14.8},
			},


		},
		kistenTrainH	= {
			{
				pos = {2257.2, -2263.6, 14.0},
			},
			--[[{
				pos = {2258.0, -2264.3, 14.0},
			},
			
			{
				pos = {2256.4, -2264.4, 14.0},
			},
			{
				pos = {2257.1, -2265.2, 14.0},
			},
			
			
			{
				pos = {2254.0, -2268.2, 14.0},
			},
			{
				pos = {2253.3, -2267.4, 14.0},
			},
			
			{
				pos = {2254.9, -2267.3, 14.0},
			},
			{
				pos = {2254.1, -2266.6, 14.0},
			},]]
		},
		kistenTrainV	= {
			{
				pos = {2254.3, -2260.8, 13.9},
			},
			--[[{
				pos = {2255.0, -2261.6, 13.9},
			},
			
			{
				pos = {2253.5, -2261.6, 13.9},
			},
			{
				pos = {2254.2, -2262.4, 13.9},
			},
			
			
			{
				pos = {2251.1, -2265.4, 13.9},
			},
			{
				pos = {2250.4, -2264.6, 13.9},
			},
			
			{
				pos = {2251.9, -2264.6, 13.9},
			},
			{
				pos = {2251.2, -2263.8, 13.9},
			},]]
		},
	},
	
	{
		markerPosH	= {2249.6, -2272.7, 14.4},
		markerPosV	= {2246.6, -2269.5, 14.4},
		forkliftPos		= {2238.8, -2265.2, 14.6},
		currentPlayer	= false,
		lastDelivery	= 0,
		
		kistenTruck	= {
            {
				pos = {2221.1, -2246.7, 14.8},
			},
			{
				pos = {2222.2, -2245.9, 14.8},
			},
			{
				pos = {2222.2, -2247.8, 14.8},
			},
			{
				pos = {2223.3, -2247, 14.8},
			},
			{
				pos = {2223.3, -2248.9, 14.8},
			},
			{
				pos = {2224.4, -2248.1, 14.8},
			},
			{
				pos = {2224.4, -2250, 14.8},
			},
			{
				pos = {2225.5, -2249.2, 14.8},
			},
			{
				pos = {2225.5, -2251.1, 14.8},
			},
			{
				pos = {2226.6, -2250.3, 14.8},
			},
			{
				pos = {2226.6, -2252.2, 14.8},
			},
			{
				pos = {2227.7, -2251.4, 14.8},
			},
			{
				pos = {2227.7, -2253.3, 14.8},
			},
			{
				pos = {2228.8, -2252.5, 14.8},
			},
			{
				pos = {2228.8, -2254.4, 14.8},
			},
			{
				pos = {2229.9, -2253.6, 14.8},
			},


		},
		kistenTrainH	= {
			{
				pos = {2250.9, -2270.0, 14.0},
			},
			{
				pos = {2251.5, -2270.9, 14.0},
			},
			
			{
				pos = {2250.1, -2270.8, 14.0},
			},
			{
				pos = {2250.7, -2271.7, 14.0},
			},
			
			
			{
				pos = {2247.7, -2274.6, 14.0},
			},
			{
				pos = {2247.0, -2273.8, 14.0},
			},
			
			{
				pos = {2248.5, -2273.8, 14.0},
			},
			{
				pos = {2247.8, -2273.0, 14.0},
			},
		},
		kistenTrainV	= {
			{
				pos = {2247.8, -2267.2, 14.0},
			},
			{
				pos = {2248.6, -2267.9, 14.0},
			},
			
			{
				pos = {2247.1, -2268.0, 14.0},
			},
			{
				pos = {2247.8, -2268.8, 14.0},
			},
			
			
			{
				pos = {2245.0, -2271.6, 14.0},
			},
			{
				pos = {2244.2, -2270.9, 14.0},
			},
			
			{
				pos = {2245.7, -2270.8, 14.0},
			},
			{
				pos = {2245.0, -2270.1, 14.0},
			},
		},
	},
	
	{
		markerPosH	= {2241.3, -2281.3, 14.4},
		markerPosV	= {2238.5, -2278.5, 14.4},
		forkliftPos		= {2231.5, -2272.6, 14.6},
		currentPlayer	= false,
		lastDelivery	= 0,
		
		kistenTruck	= {
            {
				pos = {2213.7, -2254.1, 14.8},
			},
			{
				pos = {2214.9, -2253.3, 14.8},
			},
			{
				pos = {2214.8, -2255.2, 14.8},
			},
			{
				pos = {2216, -2254.4, 14.8},
			},
			{
				pos = {2215.9, -2255.9, 14.8},
			},
			{
				pos = {2217.1, -2255.5, 14.8},
			},
			{
				pos = {2217, -2257.4, 14.8},
			},
			{
				pos = {2218.2, -2256.6, 14.8},
			},
			{
				pos = {2218.1, -2258.5, 14.8},
			},
			{
				pos = {2219.3, -2257.7, 14.8},
			},
			{
				pos = {2219.2, -2259.6, 14.8},
			},
			{
				pos = {2220.4, -2258.8, 14.8},
			},
			{
				pos = {2220.3, -2260.7, 14.8},
			},
			{
				pos = {2221.5, -2259.9, 14.8},
			},
			{
				pos = {2221.4, -2261.8, 14.8},
			},
			{
				pos = {2222.6, -2261, 14.8},
			},

		},
		
		
		kistenTrainH	= {
			{
				pos = {2242.4, -2278.6, 14.0},
			},
			{
				pos = {2243.1, -2279.4, 14.0},
			},
			
			{
				pos = {2241.5, -2279.5, 14.0},
			},
			{
				pos = {2242.3, -2280.2, 14.0},
			},
			
			
			{
				pos = {2239.2, -2283.2, 14.0},
			},
			{
				pos = {2238.5, -2282.4, 14.0},
			},
			
			{
				pos = {2240.2, -2282.3, 14.0},
			},
			{
				pos = {2239.3, -2281.7, 14.0},
			},
		},
		kistenTrainV	= {
			{
				pos = {2239.7, -2276.0, 14.0},
			},
			{
				pos = {2240.5, -2276.7, 14.0},
			},
			
			{
				pos = {2238.9, -2276.8, 14.0},
			},
			{
				pos = {2239.7, -2277.5, 14.0},
			},
			
			
			{
				pos = {2236.7, -2280.5, 14.0},
			},
			{
				pos = {2236.0, -2279.7, 14.0},
			},
			
			{
				pos = {2237.5, -2279.7, 14.0},
			},
			{
				pos = {2236.8, -2278.9, 14.0},
			},
		},
	},
	
	{
		markerPosH	= {2234.7, -2287.6, 14.4},
		markerPosV	= {2231.9, -2284.9, 14.4},
		forkliftPos		= {2224.7, -2279.4, 14.6},
		currentPlayer	= false,
		lastDelivery	= 0,
		
		kistenTruck	= {
            {
				pos = {2206.5, -2261.6, 14.8},
			},
			{
				pos = {2207.7, -2260.9, 14.8},
			},
			{
				pos = {2207.6, -2262.7, 14.8},
			},
			{
				pos = {2208.8, -2262, 14.8},
			},
			{
				pos = {2208.7, -2263.8, 14.8},
			},
			{
				pos = {2209.9, -2263.1, 14.8},
			},
			{
				pos = {2209.8, -2264.9, 14.8},
			},
			{
				pos = {2211, -2264.2, 14.8},
			},
			{
				pos = {2210.9, -2266, 14.8},
			},
			{
				pos = {2212.1, -2265.3, 14.8},
			},
			{
				pos = {2212, -2267.1, 14.8},
			},
			{
				pos = {2213.2, -2266.4, 14.8},
			},
			{
				pos = {2213.1, -2268.2, 14.8},
			},
			{
				pos = {2214.3, -2267.5, 14.8},
			},
			{
				pos = {2214.2, -2269.3, 14.8},
			},
			{
				pos = {2215.4, -2268.6, 14.8},
			},
		},
		kistenTrainH	= {
			{
				pos = {2236.0, -2285.1, 13.9},
			},
			{
				pos = {2236.7, -2285.9, 13.9},
			},
			
			{
				pos = {2235.1, -2286.0, 13.9},
			},
			{
				pos = {2235.8, -2286.8, 13.9},
			},
			
			
			{
				pos = {2232.9, -2289.7, 13.9},
			},
			{
				pos = {2232.2, -2288.9, 13.9},
			},
			
			{
				pos = {2233.8, -2288.8, 13.9},
			},
			{
				pos = {2233.0, -2288.0, 13.9},
			},
		},
		kistenTrainV	= {
			{
				pos = {2233.4, -2282.3, 13.9},
			},
			{
				pos = {2234.1, -2283.1, 13.9},
			},
			
			{
				pos = {2232.5, -2283.3, 13.9},
			},
			{
				pos = {2233.2, -2284.1, 13.9},
			},
			
			
			{
				pos = {2230.2, -2287.0, 13.9},
			},
			{
				pos = {2229.5, -2286.3, 13.9},
			},
			
			{
				pos = {2231.1, -2286.1, 13.9},
			},
			{
				pos = {2230.4, -2285.4, 13.9},
			},
		},
	},
	
	
	
	{
		markerPosH	= {2226.6, -2296.1, 14.4},
		markerPosV	= {2223.7, -2293.2, 14.4},
		forkliftPos		= {2216.4, -2287.8, 14.6},
		currentPlayer	= false,
		lastDelivery	= 0,
		
		kistenTruck	= {
			{
				pos = {2198.4, -2269.1, 14.8},
			},
			{
				pos = {2199.4, -2268.0, 14.8},
			},
			
			{
				pos = {2199.4, -2270.2, 14.8},
			},
			{
				pos = {2200.4, -2269.0, 14.8},
			},
			
			{
				pos = {2200.3, -2271.0, 14.8},
			},
			{
				pos = {2201.3, -2270.0, 14.8},
			},
			
			{
				pos = {2201.2, -2272.1, 14.8},
			},
			{
				pos = {2202.2, -2271.0, 14.8},
			},
			
			{
				pos = {2202.0, -2273.0, 14.8},
			},
			{
				pos = {2203.0, -2271.9, 14.8},
			},
			
			{
				pos = {2202.9, -2273.9, 14.8},
			},
			{
				pos = {2203.9, -2272.9, 14.8},
			},
			
			{
				pos = {2203.9, -2274.9, 14.8},
			},
			{
				pos = {2204.9, -2273.9, 14.8},
			},
			
			{
				pos = {2204.8, -2275.8, 14.8},
			},
			{
				pos = {2205.8, -2274.8, 14.8},
			},
			
			{
				pos = {2205.8, -2276.8, 14.8},
			},
			{
				pos = {2206.8, -2275.8, 14.8},
			},
		},
		kistenTrainH	= {
			{
				pos = {2227.8, -2293.5, 14.0},
			},
			{
				pos = {2228.5, -2294.3, 14.0},
			},
			
			{
				pos = {2226.9, -2294.4, 14.0},
			},
			{
				pos = {2227.7, -2295.1, 14.0},
			},
			
			{
				pos = {2224.6, -2298.1, 14.0},
			},
			{
				pos = {2223.8, -2297.4, 14.0},
			},
			
			{
				pos = {2225.7, -2297.1, 14.0},
			},
			{
				pos = {2225.0, -2296.4, 14.0},
			},
		},
		kistenTrainV	= {
			{
				pos = {2225.0, -2290.5, 14.0},
			},
			{
				pos = {2225.8, -2291.2, 14.0},
			},
			
			{
				pos = {2224.2, -2291.4, 14.0},
			},
			{
				pos = {2224.9, -2292.3, 14.0},
			},
			
			{
				pos = {2221.9, -2295.3, 14.0},
			},
			{
				pos = {2221.1, -2294.5, 14.0},
			},
			
			{
				pos = {2222.7, -2294.5, 14.0},
			},
			{
				pos = {2221.9, -2293.7, 14.0},
			},
		},
	},
}


local LKWplaces = {
	{
		trailerPos		= {2152.0, -2287.8, 14.1, 224},
		markerPos		= {2149.2, -2285.1, 14.8},
		forkliftPos		= {2145.9, -2281.95, 14.9, 45},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2158.1, -2279.0, 14.1, 224},
		markerPos		= {2154.8, -2275.9, 13.5},
		forkliftPos		= {2153.3, -2273.4, 13.4, 45},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2165.1, -2271.4, 14.1, 224},
		markerPos		= {2161.9, -2268.1, 13.5},
		forkliftPos		= {2159.4, -2266.6, 13.4, 45},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2172.5, -2264.4, 14.1, 224},
		markerPos		= {2169.1, -2261.1, 13.5},
		forkliftPos		= {2167.2, -2259.0, 13.4, 45},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2173.6, -2240.5, 14.0, 314},
		markerPos		= {2170.5, -2243.5, 13.5},
		forkliftPos		= {2168.9, -2245.1, 13.4, 133},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2170.9, -2237.8, 14.0, 314},
		markerPos		= {2167.7, -2240.8, 13.5},
		forkliftPos		= {2166.3, -2242.3, 13.4, 133},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	{
		trailerPos		= {2168.1, -2235.0, 14.0, 314},
		markerPos		= {2164.9, -2238.0, 13.5},
		forkliftPos		= {2163.3, -2239.4, 13.4, 133},
		currentPlayer	= false,
		lastDelivery	= 0,
	},
	
}

local LKWboxes = {
	{
		pos = {2136.8, -2290.1001, 14.4, 315},
	},
	{
		pos = {2136, -2289.2, 14.4, 315},
	},
	{
		pos = {2135.1001, -2288.2, 14.4, 315},
	},
	{
		pos = {2134.1001, -2287.3, 14.4, 315},
	},
	{
		pos = {2133.2, -2286.3999, 14.4, 315},
	},
	{
		pos = {2132.3, -2285.5, 14.4, 315},
	},
	{
		pos = {2131.3999, -2284.6001, 14.4, 315},
	},
	{
		pos = {2130.5, -2283.7, 14.4, 315},
	},
	{
		pos = {2129.6001, -2282.8999, 14.4, 315},
	},
	{
		pos = {2128.7, -2282, 14.4, 315},
	},
	{
		pos = {2127.8999, -2281.2, 14.4, 315},
	},
	{
		pos = {2127, -2280.3999, 14.4, 315},
	},
	{
		pos = {2126.2, -2279.5, 14.4, 315},
	},
	{
		pos = {2137.8, -2289.1001, 14.4, 315},
	},
	{
		pos = {2137, -2288.2, 14.4, 315},
	},
	{
		pos = {2136, -2287.3, 14.4, 315},
	},
	{
		pos = {2135, -2286.3999, 14.4, 315},
	},
	{
		pos = {2134, -2285.5, 14.4, 315},
	},
	{
		pos = {2133.2, -2284.6001, 14.4, 315},
	},
	{
		pos = {2132.3, -2283.8, 14.4, 315},
	},
	{
		pos = {2131.5, -2282.8999, 14.4, 315},
	},
	{
		pos = {2130.5, -2282, 14.4, 315},
	},
	{
		pos = {2129.6001, -2281.1001, 14.4, 315},
	},
	{
		pos = {2128.8, -2280.3, 14.4, 315},
	},
	{
		pos = {2128, -2279.5, 14.4, 315},
	},
	{
		pos = {2127.1001, -2278.6001, 14.4, 315},
	},
	{
		pos = {2138.6001, -2288.1001, 14.4, 315},
	},
	{
		pos = {2137.8, -2287.2, 14.4, 315},
	},
	{
		pos = {2137, -2286.3, 14.4, 315},
	},
	{
		pos = {2135.8999, -2285.3999, 14.4, 315},
	},
	{
		pos = {2135, -2284.6001, 14.4, 315},
	},
	{
		pos = {2134.1001, -2283.6001, 14.4, 315},
	},
	{
		pos = {2133.2, -2282.8, 14.4, 315},
	},
	{
		pos = {2132.3999, -2282, 14.4, 315},
	},
	{
		pos = {2131.3999, -2281.1001, 14.4, 315},
	},
	{
		pos = {2130.5, -2280.2, 14.4, 315},
	},
	{
		pos = {2129.6001, -2279.3999, 14.4, 315},
	},
	{
		pos = {2128.8, -2278.6001, 14.4, 315},
	},
	{
		pos = {2128, -2277.7, 14.4, 315},
	},
	{
		pos = {2125.3, -2278.6001, 14.4, 315},
	},
	{
		pos = {2126.2, -2277.6001, 14.4, 315},
	},
	{
		pos = {2127.1001, -2276.7, 14.4, 315},
	},
	{
		pos = {2124.3999, -2277.8, 14.4, 315},
	},
	{
		pos = {2125.3, -2276.8, 14.4, 315},
	},
	{
		pos = {2126.2, -2275.8999, 14.4, 315},
	},
	{
		pos = {2123.5, -2276.8, 14.4, 315},
	},
	{
		pos = {2122.5, -2275.8, 14.4, 315},
	},
	{
		pos = {2121.6001, -2274.8999, 14.4, 315},
	},
	{
		pos = {2120.7, -2273.8999, 14.4, 315},
	},
	{
		pos = {2124.6001, -2275.7, 14.4, 315},
	},
	{
		pos = {2125.3999, -2274.8999, 14.4, 315},
	},
	{
		pos = {2123.6001, -2274.8999, 14.4, 315},
	},
	{
		pos = {2124.3, -2274, 14.4, 315},
	},
	{
		pos = {2122.7, -2273.8999, 14.4, 315},
	},
	{
		pos = {2123.6001, -2273, 14.4, 315},
	},
	{
		pos = {2121.6001, -2272.8999, 14.4, 315},
	},
	{
		pos = {2122.7, -2272, 14.4, 315},
	},
	{
		pos = {2133.8, -2256.8999, 12.9, 315},
	},
	{
		pos = {2134.7, -2255.8999, 12.9, 315},
	},
	{
		pos = {2135.8, -2255.1001, 12.9, 315},
	},
	{
		pos = {2136.7, -2254.3, 12.9, 315},
	},
	{
		pos = {2137.5, -2253.3999, 12.9, 315},
	},
	{
		pos = {2138.3999, -2252.5, 12.9, 315},
	},
	{
		pos = {2139.3, -2251.7, 12.9, 315},
	},
	{
		pos = {2140.2, -2250.8, 12.9, 315},
	},
	{
		pos = {2141.2, -2249.8999, 12.9, 315},
	},
	{
		pos = {2142.1001, -2249.1001, 12.9, 315},
	},
	{
		pos = {2143, -2250, 12.9, 315},
	},
	{
		pos = {2143.8, -2250.8999, 12.9, 315},
	},
	{
		pos = {2134.7, -2257.8, 12.9, 315},
	},
	{
		pos = {2135.6001, -2258.6001, 12.9, 315},
	},
	{
		pos = {2135.7, -2256.8999, 12.9, 315},
	},
	{
		pos = {2136.6001, -2257.8, 12.9, 315},
	},
	{
		pos = {2136.8, -2256.1001, 12.9, 315},
	},
	{
		pos = {2137.7, -2257, 12.9, 315},
	},
	{
		pos = {2137.6001, -2255.2, 12.9, 315},
	},
	{
		pos = {2138.7, -2256.2, 12.9, 315},
	},
	{
		pos = {2138.7, -2254.3999, 12.9, 315},
	},
	{
		pos = {2139.5, -2255.3, 12.9, 315},
	},
	{
		pos = {2139.3, -2253.3999, 12.9, 315},
	},
	{
		pos = {2140.3999, -2254.3999, 12.9, 315},
	},
	{
		pos = {2140.2, -2252.6001, 12.9, 315},
	},
	{
		pos = {2141.1001, -2253.5, 12.9, 315},
	},
	{
		pos = {2141, -2251.7, 12.9, 315},
	},
	{
		pos = {2141.8999, -2252.6001, 12.9, 315},
	},
	{
		pos = {2142.1001, -2251, 12.9, 315},
	},
	{
		pos = {2143, -2251.8, 12.9, 315},
	},
	{
		pos = {2144.3, -2246.7, 12.9, 315},
	},
	{
		pos = {2145.3, -2247.6001, 12.9, 315},
	},
	{
		pos = {2146.2, -2248.5, 12.9, 315},
	},
	{
		pos = {2145.3, -2245.8, 12.9, 315},
	},
	{
		pos = {2146.1001, -2244.7, 12.9, 315},
	},
	{
		pos = {2147.1001, -2243.8999, 12.9, 315},
	},
	{
		pos = {2148, -2243.1001, 12.9, 315},
	},
	{
		pos = {2148.8, -2242.1001, 12.9, 315},
	},
	{
		pos = {2146.3, -2246.8, 12.9, 315},
	},
	{
		pos = {2147.2, -2247.7, 12.9, 315},
	},
	{
		pos = {2147.2, -2245.8999, 12.9, 315},
	},
	{
		pos = {2148.1001, -2246.8, 12.9, 315},
	},
	{
		pos = {2148, -2245, 12.9, 315},
	},
	{
		pos = {2148.8999, -2245.8, 12.9, 315},
	},
	{
		pos = {2148.8999, -2244.1001, 12.9, 315},
	},
	{
		pos = {2149.8, -2244.8999, 12.9, 315},
	},
	{
		pos = {2149.7, -2241.2, 12.9, 315},
	},
	{
		pos = {2150.5, -2240.3, 12.9, 315},
	},
	{
		pos = {2151.3999, -2239.3999, 12.9, 315},
	},
	{
		pos = {2152.3, -2238.5, 12.9, 315},
	},
	{
		pos = {2153.2, -2237.6001, 12.9, 315},
	},
	{
		pos = {2149.7, -2243.1001, 12.9, 315},
	},
	{
		pos = {2150.7, -2244.1001, 12.9, 315},
	},
	{
		pos = {2150.5, -2242.2, 12.9, 315},
	},
	{
		pos = {2151.5, -2243.1001, 12.9, 315},
	},
	{
		pos = {2151.3, -2241.3, 12.9, 315},
	},
	{
		pos = {2152.3, -2242.2, 12.9, 315},
	},
	{
		pos = {2152.3999, -2240.5, 12.9, 315},
	},
	{
		pos = {2153.2, -2241.3, 12.9, 315},
	},
	{
		pos = {2153.3, -2239.5, 12.9, 315},
	},
	{
		pos = {2154.2, -2240.3999, 12.9, 315},
	},
	{
		pos = {2154.2, -2238.6001, 12.9, 315},
	},
	{
		pos = {2155.1001, -2239.5, 12.9, 315},
	},
	{
		pos = {2154.2, -2236.6001, 12.9, 315},
	},
	{
		pos = {2155.2, -2235.8, 12.9, 315},
	},
	{
		pos = {2156.1001, -2234.8999, 12.9, 315},
	},
	{
		pos = {2157, -2234.1001, 12.9, 315},
	},
	{
		pos = {2155.2, -2237.7, 12.9, 315},
	},
	{
		pos = {2156.1001, -2238.5, 12.9, 315},
	},
	{
		pos = {2156, -2236.7, 12.9, 315},
	},
	{
		pos = {2157, -2237.6001, 12.9, 315},
	},
	{
		pos = {2157.1001, -2235.8, 12.9, 315},
	},
	{
		pos = {2158, -2236.7, 12.9, 315},
	},
	{
		pos = {2157.8999, -2235, 12.9, 315},
	},
	{
		pos = {2158.8, -2235.8999, 12.9, 315},
	},
	{
		pos = {2136.5, -2259.5, 12.9, 315},
	},
	{
		pos = {2137.5, -2258.7, 12.9, 315},
	},
	{
		pos = {2138.5, -2257.8, 12.9, 315},
	},
	{
		pos = {2139.6001, -2257, 12.9, 315},
	},
	{
		pos = {2140.3999, -2256.1001, 12.9, 315},
	},
	{
		pos = {2141.3, -2255.3, 12.9, 315},
	},
	{
		pos = {2142.2, -2254.3999, 12.9, 315},
	},
	{
		pos = {2143, -2253.6001, 12.9, 315},
	},
	{
		pos = {2144.1001, -2252.7, 12.9, 315},
	},
	{
		pos = {2144.8999, -2251.7, 12.9, 315},
	},
	{
		pos = {2147.1001, -2249.3999, 12.9, 315},
	},
	{
		pos = {2148.1001, -2248.5, 12.9, 315},
	},
	{
		pos = {2148.8999, -2247.6001, 12.9, 315},
	},
	{
		pos = {2149.7, -2246.7, 12.9, 315},
	},
	{
		pos = {2150.7, -2245.8999, 12.9, 315},
	},
	{
		pos = {2151.6001, -2245, 12.9, 315},
	},
	{
		pos = {2152.3999, -2244, 12.9, 315},
	},
	{
		pos = {2153.3, -2243.1001, 12.9, 315},
	},
	{
		pos = {2154.1001, -2242.2, 12.9, 315},
	},
	{
		pos = {2155.1001, -2241.3, 12.9, 315},
	},
	{
		pos = {2156, -2240.3999, 12.9, 315},
	},
	{
		pos = {2157.1001, -2239.5, 12.9, 315},
	},
	{
		pos = {2158, -2238.6001, 12.9, 315},
	},
	{
		pos = {2158.8, -2237.7, 12.9, 315},
	},
	{
		pos = {2159.6001, -2236.8, 12.9, 315},
	},
	{
		pos = {2137.5, -2260.3999, 12.9, 315},
	},
	{
		pos = {2138.5, -2259.5, 12.9, 315},
	},
	{
		pos = {2139.3999, -2258.7, 12.9, 315},
	},
	{
		pos = {2140.5, -2257.8, 12.9, 315},
	},
	{
		pos = {2141.3999, -2257, 12.9, 315},
	},
	{
		pos = {2142.3, -2256.1001, 12.9, 315},
	},
	{
		pos = {2143, -2255.2, 12.9, 315},
	},
	{
		pos = {2143.8999, -2254.3, 12.9, 315},
	},
	{
		pos = {2144.8999, -2253.5, 12.9, 315},
	},
	{
		pos = {2145.8, -2252.7, 12.9, 315},
	},
	{
		pos = {2147.8999, -2250.3, 12.9, 315},
	},
	{
		pos = {2149, -2249.3, 12.9, 315},
	},
	{
		pos = {2149.8999, -2248.5, 12.9, 315},
	},
	{
		pos = {2150.7, -2247.7, 12.9, 315},
	},
	{
		pos = {2151.6001, -2246.8999, 12.9, 315},
	},
	{
		pos = {2152.6001, -2245.8999, 12.9, 315},
	},
	{
		pos = {2153.5, -2244.8, 12.9, 315},
	},
	{
		pos = {2154.3, -2244, 12.9, 315},
	},
	{
		pos = {2155.1001, -2243.1001, 12.9, 315},
	},
	{
		pos = {2156, -2242.2, 12.9, 315},
	},
	{
		pos = {2156.8999, -2241.3, 12.9, 315},
	},
	{
		pos = {2157.8999, -2240.3999, 12.9, 315},
	},
	{
		pos = {2158.8, -2239.5, 12.9, 315},
	},
	{
		pos = {2159.7, -2238.6001, 12.9, 315},
	},
	{
		pos = {2160.6001, -2237.8, 12.9, 315},
	},
}



-- Level 1
function spawnLkwBoxes()
	for i, kiste in ipairs(LKWboxes) do
		if (kiste.boxU and isElement(kiste.boxU)) then destroyElement(kiste.boxU) end
		if (kiste.boxO and isElement(kiste.boxO)) then destroyElement(kiste.boxO) end
		
		local kx, ky, kz, krz = unpack(kiste.pos)
		LKWboxes[i].boxU = createObject(1558, kx, ky, kz, 0, 0, krz)
		LKWboxes[i].boxO = createObject(1558, kx, ky, kz+1.06, 0, 0, krz)
	end
end
spawnLkwBoxes()
setTimer(function()
	spawnLkwBoxes()
end, 9.5*60000, 0)
--addCommandHandler("box", spawnLkwBoxes)


for k, v in ipairs(LKWplaces) do
	
	local mhx, mhy, mhz = unpack(v.markerPos)
	v.marker = createMarker(mhx, mhy, mhz, "corona", 1, 255, 0, 0)
	setElementVisibleTo(v.marker, root, false)	
	
	v.col = createColSphere(mhx, mhy, mhz, 2.5)
	setElementData(v.col, "forkLkwID", k)
	
	local tx, ty, tz, trz = unpack(v.trailerPos)
	v.trailer = createVehicle(435, tx, ty, tz, 0, 0, trz)
	setVehicleDamageProof(v.trailer, true)
	setElementFrozen(v.trailer, true)
	setElementData(v.trailer, "forkLkwID", k)
	
end






-- Level 2
function ResetForkTrain(id)
	for i, kiste in ipairs(trainPlaces[id].kistenTruck) do
		if (kiste.boxU and isElement(kiste.boxU)) then destroyElement(kiste.boxU) end
		if (kiste.boxO and isElement(kiste.boxO)) then destroyElement(kiste.boxO) end
		
		local kx, ky, kz = unpack(kiste.pos)
		
		trainPlaces[id].kistenTruck[i].boxU = createObject(1558, kx, ky, kz, 0, 0, 314)
		setElementData(trainPlaces[id].kistenTruck[i].boxU, "forkTrainID", id)
		
		trainPlaces[id].kistenTruck[i].boxO = createObject(1558, kx, ky, kz+1.06, 0, 0, 314)
		setElementData(trainPlaces[id].kistenTruck[i].boxO, "forkTrainID", id)
	end
	
	for i, kiste in ipairs(trainPlaces[id].kistenTrainH) do
		setElementAlpha(kiste.boxU, 0)
		setElementAlpha(kiste.boxO, 0)
	end
	
	for i, kiste in ipairs(trainPlaces[id].kistenTrainV) do
		setElementAlpha(kiste.boxU, 0)
		setElementAlpha(kiste.boxO, 0)
	end
end

for k, v in ipairs(trainPlaces) do
	
	local mhx, mhy, mhz = unpack(v.markerPosH)
	v.markerH = createMarker(mhx, mhy, mhz, "corona", 1, 255, 0, 0)
	setElementVisibleTo(v.markerH, root, false)	
	
	v.colH = createColSphere(mhx, mhy, mhz, 1.5)
	setElementData(v.colH, "forkTrainID", k)
	
	
	local mvx, mvy, mvz = unpack(v.markerPosV)
	v.markerV = createMarker(mvx, mvy, mvz, "corona", 1, 255, 0, 0)
	setElementVisibleTo(v.markerV, root, false)
	
	v.colV = createColSphere(mvx, mvy, mvz, 1.5)
	setElementData(v.colV, "forkTrainID", k)
	
	
	for i, kiste in ipairs(v.kistenTrainH) do
		local kx, ky, kz = unpack(kiste.pos)
		
		trainPlaces[k].kistenTrainH[i].boxU = createObject(1558, kx, ky, kz, 0, 0, 314)
		setElementFrozen(kiste.boxU, true)
		
		trainPlaces[k].kistenTrainH[i].boxO = createObject(1558, kx, ky, kz+1.06, 0, 0, 314)
		setElementFrozen(kiste.boxO, true)
	end
	
	for i, kiste in ipairs(v.kistenTrainV) do
		local kx, ky, kz = unpack(kiste.pos)
		
		trainPlaces[k].kistenTrainV[i].boxU = createObject(1558, kx, ky, kz, 0, 0, 314)
		setElementFrozen(kiste.boxU, true)
		
		trainPlaces[k].kistenTrainV[i].boxO = createObject(1558, kx, ky, kz+1.06, 0, 0, 314)
		setElementFrozen(kiste.boxO, true)
	end
	
	ResetForkTrain(k)
end




local function DeliverBox(col, box)
	if (getElementType(box) == "object" and getElementModel(box) == 1558) then
		local mtID	= getElementData(col, "forkTrainID")
		local otID	= getElementData(box, "forkTrainID")
		local mlID	= getElementData(col, "forkLkwID")
		
		if (mtID and otID) then
			if (mtID == otID) then
				if (getPlayerName(source) == trainPlaces[mtID].currentPlayer) then
					local wcol = ""
					local t = false
					local marker = false
					if (col == trainPlaces[mtID].colH) then
						t = trainPlaces[mtID].kistenTrainH
						wcol = "hinten"
						marker = trainPlaces[mtID].markerH
					elseif (col == trainPlaces[mtID].colV) then
						t = trainPlaces[mtID].kistenTrainV
						wcol = "vorne"
						marker = trainPlaces[mtID].markerV
					end
					
					
					if (marker and isElementVisibleTo(marker, source)) then
						if (not getElementData(box, "hitted")) then
							setElementData(box, "hitted", true)
							
							if (t) then
								local now = getRealTime().timestamp
								if ((now-trainPlaces[mtID].lastDelivery) >= 2) then
									for k, v in ipairs(t) do
										if (getElementAlpha(v.boxU) < 1) then
											setElementAlpha(v.boxU, 255)
											break
										elseif (getElementAlpha(v.boxO) < 1) then
											setElementAlpha(v.boxO, 255)
											break
										end
									end
									
									local visible = 0
									for k, v in ipairs(t) do
										if (getElementAlpha(v.boxU) >= 250) then
											visible = visible + 1
										end
										if (getElementAlpha(v.boxO) >= 250) then
											visible = visible + 1
										end
									end
									
									if (visible >= #t) then -- zug voll
										if (wcol == "hinten") then
											setElementVisibleTo(trainPlaces[mtID].markerH, source, false)
											setElementVisibleTo(trainPlaces[mtID].markerV, source, true)
											--outputChatBox("hinten voll -> vorne")
											
										elseif (wcol == "vorne") then --beide voll -> job beenden
											setElementVisibleTo(trainPlaces[mtID].markerV, source, false)
											--outputChatBox("ende im gelände")
											Jobs:End(source)
										end
									end
									
									Jobs:AddEarnings(source, JobID, pricePerTrainBox)
									Jobs:AddLevel(source, JobID, 1)
									
									trainPlaces[mtID].lastDelivery = now
								end
							end
							--outputChatBox("allok")
							destroyElement(box)
						
						end
						
					end
					
				end
			end
			
			
		elseif (mlID) then
			if (getPlayerName(source) == LKWplaces[mlID].currentPlayer) then
				if (not getElementData(box, "hitted")) then
					local now = getRealTime().timestamp
					if ((now-LKWplaces[mlID].lastDelivery) >= 2) then
						setElementData(box, "hitted", true)
						
						Jobs:AddEarnings(source, JobID, pricePerLkwBox)
						Jobs:AddLevel(source, JobID, 1)
						
						LKWplaces[mlID].lastDelivery = now
					end
					
					destroyElement(box)
					
				end
				
			end
		end
		
	end
end
addEvent("onForkBoxDeliver", true)
addEventHandler("onForkBoxDeliver", root, DeliverBox)








_G["ForkliftStart"] = function(player, level)
	local state = false
		
	if (level == 1) then
		
		for k, v in pairs(LKWplaces) do
			
			if (v.currentPlayer == false) then
				
				local pName = getPlayerName(player)
				
				LKWplaces[k].currentPlayer = pName
				setElementData(v.col, "curPlayer", pName)
				
				setElementVisibleTo(v.marker, player, true)
				
				local fx, fy, fz, frz = unpack(v.forkliftPos)
				v.forklift = createVehicle(530, fx, fy, fz, 0, 0, frz)
				setVehicleDamageProof(v.forklift, true)
				setElementData(v.forklift, "jobOwner", pName)
				
				fadeElementInterior(player, 0, fx, fy, fz, 0, 0, true)
				setTimer(function()
					warpPedIntoVehicle(player, v.forklift)
					infoShow(player, "info", "Du erhälst pro Fahrt "..pricePerLkwBox.." $, mehrere Kisten pro Fahrt erhöhen den Verdienst nicht.")
				end, 750, 1)
				
				
				state = true
				
				break
			end
			
		end
		
	elseif (level == 2) then
		
		for k, v in pairs(trainPlaces) do
			
			if (v.currentPlayer == false) then
				
				local pName = getPlayerName(player)
				
				trainPlaces[k].currentPlayer = pName
				
				setElementData(v.colH, "curPlayer", pName)
				setElementData(v.colV, "curPlayer", pName)
				
				setElementVisibleTo(v.markerH, player, true)
				
				local fx, fy, fz = unpack(v.forkliftPos)
				v.forklift = createVehicle(530, fx, fy, fz)
				setVehicleDamageProof(v.forklift, true)
				setElementData(v.forklift, "jobOwner", pName)
				
				fadeElementInterior(player, 0, fx, fy, fz, 0, 0, true)
				setTimer(function()
					warpPedIntoVehicle(player, v.forklift)
					infoShow(player, "info", "Du erhälst pro Fahrt "..pricePerTrainBox.." $, mehrere Kisten pro Fahrt erhöhen den Verdienst nicht.")
				end, 750, 1)
				
				state = true
				
				break
			end
			
		end
	
	end
	
	return state
end

_G["ForkliftEnd"] = function(player)
	local pName = getPlayerName(player)
	
	for k, v in pairs(LKWplaces) do
		
		if (v.currentPlayer == pName) then
			
			LKWplaces[k].currentPlayer = false
			
			setElementData(v.col, "curPlayer", false)
			
			setElementVisibleTo(v.marker, player, false)
			
			destroyElement(v.forklift)
			
			fadeElementInterior(player, 0, 2183.65, -2260.95, 13.41, 215, 0, true)
			
			break
		end
		
	end
	
	for k, v in pairs(trainPlaces) do
		
		if (v.currentPlayer == pName) then
			
			trainPlaces[k].currentPlayer = false
			
			setElementData(v.colH, "curPlayer", false)
			setElementData(v.colV, "curPlayer", false)
			
			setElementVisibleTo(v.markerH, player, false)
			setElementVisibleTo(v.markerV, player, false)
			
			destroyElement(v.forklift)
			ResetForkTrain(k)
			
			fadeElementInterior(player, 0, 2183.65, -2260.95, 13.41, 215, 0, true)
			
			break
		end
		
	end
end