----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

furnitureNames = {}
local objects = { -- Niemals gleichen titel bei mehreren einträgen!
	{
		title = "Küche",
		objects = {
			{
				title	= "Einbauküche Braun 1",
				id		= 15036,
				price	= 1000,
			},
			{
				title	= "Einbauküche Braun 2",
				id		= 14720,
				price	= 1000,
			},
			{
				title	= "Einbauküche Braun 3",
				id		= 14384,
				price	= 1000,
			},
			
			{
				title	= "Weiße Küche: Hochschrank",
				id		= 2153,
				price	= 1000,
			},
			{
				title	= "Weiße Küche: Spüle",
				id		= 2154,
				price	= 1000,
			},
			{
				title	= "Weiße Küche: Schrank 1",
				id		= 2152,
				price	= 1000,
			},
			{
				title	= "Weiße Küche: Schrank 2",
				id		= 2151,
				price	= 1000,
			},
			{
				title	= "Weiße Küche: Kühlschrank",
				id		= 2155,
				price	= 1000,
			},
			
			{
				title	= "Weiße Küche 2: Hochschrank",
				id		= 2141,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Schrank 1",
				id		= 2133,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Schrank 2",
				id		= 2134,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Schrank 3",
				id		= 2339,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Eckschrank",
				id		= 2341,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Spüle",
				id		= 2132,
				price	= 1000,
			},
			{
				title	= "Weiße Küche 2: Kühlschrank",
				id		= 2131,
				price	= 1000,
			},
			
			{
				title	= "Rote Küche: Schrank",
				id		= 2129,
				price	= 1000,
			},
			{
				title	= "Rote Küche: Spüle",
				id		= 2130,
				price	= 1000,
			},
			{
				title	= "Rote Küche: Kühlschrank",
				id		= 2127,
				price	= 1000,
			},
			{
				title	= "Rote Küche: Eckschrank",
				id		= 2304,
				price	= 1000,
			},
			
			{
				title	= "Braune Küche: Schrank 1",
				id		= 2016,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Schrank 2",
				id		= 2014,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Schrank 3",
				id		= 2015,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Waschmaschine",
				id		= 2018,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Kühlschrank",
				id		= 2019,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Eckschrank",
				id		= 2022,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Spüle",
				id		= 2013,
				price	= 1000,
			},
			{
				title	= "Braune Küche: Herd",
				id		= 2017,
				price	= 1000,
			},
			
			{
				title	= "Braune Küche 2: Schrank 1",
				id		= 2148,
				price	= 1000,
			},
			{
				title	= "Braune Küche 2: Schrank 2",
				id		= 2142,
				price	= 1000,
			},
			{
				title	= "Braune Küche 2: Hochschrank",
				id		= 2145,
				price	= 1000,
			},
			{
				title	= "Braune Küche 2: Waschmaschine",
				id		= 2143,
				price	= 1000,
			},
			
			{
				title	= "Braune Küche 3: Schrank 1",
				id		= 2334,
				price	= 1000,
			},
			{
				title	= "Braune Küche 3: Schrank 2",
				id		= 2335,
				price	= 1000,
			},
			{
				title	= "Braune Küche 3: Hochschrank",
				id		= 2158,
				price	= 1000,
			},
			{
				title	= "Braune Küche 3: Eckschrank",
				id		= 2338,
				price	= 1000,
			},
			{
				title	= "Braune Küche 3: Spüle",
				id		= 2336,
				price	= 1000,
			},
			{
				title	= "Braune Küche 3: Waschmaschine",
				id		= 2337,
				price	= 1000,
			},
			
			{
				title	= "Buche Küche: Schrank 1",
				id		= 2139,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Hochschrank",
				id		= 2140,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Eckschrank",
				id		= 2305,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Schrank 2",
				id		= 2137,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Schrank 3",
				id		= 2138,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Herd",
				id		= 2135,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Spüle",
				id		= 2136,
				price	= 1000,
			},
			{
				title	= "Buche Küche: Waschmaschine",
				id		= 2303,
				price	= 1000,
			},
			
			{
				title	= "Grüne Küche: Schrank 1",
				id		= 2156,
				price	= 1000,
			},
			{
				title	= "Grüne Küche: Schrank 2",
				id		= 2157,
				price	= 1000,
			},
			{
				title	= "Grüne Küche: Schrank 3",
				id		= 2159,
				price	= 1000,
			},
			{
				title	= "Grüne Küche: Spüle",
				id		= 2160,
				price	= 1000,
			},
			
			{
				title	= "Küchenschrank Silber 1",
				id		= 936,
				price	= 1000,
			},
			{
				title	= "Küchenschrank Silber 2",
				id		= 937,
				price	= 1000,
			},
			{
				title	= "Küchentisch",
				id		= 941,
				price	= 1000,
			},
			
			{
				title	= "Kühlschrank Grau",
				id		= 2147,
				price	= 1000,
			},
			{
				title	= "Herd Grau 1",
				id		= 2144,
				price	= 1000,
			},
			{
				title	= "Herd Grau 2",
				id		= 2170,
				price	= 1000,
			},
			{
				title	= "Herd Grau 3",
				id		= 2417,
				price	= 1000,
			},
			{
				title	= "Herd Weiß",
				id		= 2128,
				price	= 1000,
			},
			{
				title	= "Waschmaschine Weiß",
				id		= 1209,
				price	= 1000,
			},
			
			
			{
				title	= "Tisch und 4 Stühle 1",
				id		= 1594,
				price	= 1000,
			},
			{
				title	= "Tisch und 4 Stühle 2",
				id		= 1968,
				price	= 1000,
			},
			{
				title	= "Tisch und 4 Stühle 3",
				id		= 643,
				price	= 1000,
			},
			{
				title	= "Tisch und 2 Stühle 1",
				id		= 1969,
				price	= 1000,
			},
			{
				title	= "Tisch und 3 Stühle 1",
				id		= 1825,
				price	= 1000,
			},
			{
				title	= "Tisch und 3 Stühle 2",
				id		= 1432,
				price	= 1000,
			},
			{
				title	= "Tisch und 2 Stühle 2",
				id		= 2799,
				price	= 1000,
			},
			{
				title	= "Tisch und 2 Stühle 3",
				id		= 2802,
				price	= 1000,
			},
			
			{
				title	= "Tisch Orange Klein",
				id		= 2763,
				price	= 1000,
			},
			{
				title	= "Tisch Orange Groß",
				id		= 2762,
				price	= 1000,
			},
			{
				title	= "Tisch Rot Grün",
				id		= 2764,
				price	= 1000,
			},
			{
				title	= "Tisch Buche Klein",
				id		= 2644,
				price	= 1000,
			},
			{
				title	= "Tisch Bunt",
				id		= 1770,
				price	= 1000,
			},
			{
				title	= "Tisch Braun 1",
				id		= 2117,
				price	= 1000,
			},
			{
				title	= "Tisch Braun 2",
				id		= 1737,
				price	= 1000,
			},
			{
				title	= "Tisch Marmor",
				id		= 2030,
				price	= 1000,
			},
			{
				title	= "Tisch Buche",
				id		= 2109,
				price	= 1000,
			},
			
			{
				title	= "Stuhl Rot Grün",
				id		= 2807,
				price	= 1000,
			},
			{
				title	= "Stuhl Rot",
				id		= 2121,
				price	= 1000,
			},
			{
				title	= "Stuhl Braun 1",
				id		= 1810,
				price	= 1000,
			},
			{
				title	= "Stuhl Braun 2",
				id		= 2636,
				price	= 1000,
			},
			{
				title	= "Stuhl Buche",
				id		= 2124,
				price	= 1000,
			},
			{
				title	= "Stuhl Weiß",
				id		= 2123,
				price	= 1000,
			},
			
			{
				title	= "Hocker Rot 1",
				id		= 2125,
				price	= 1000,
			},
			{
				title	= "Hocker Rot 2",
				id		= 2350,
				price	= 1000,
			},
			{
				title	= "Hocker Schwarz",
				id		= 2723,
				price	= 1000,
			},
		},
	},
	
	{
		title = "Schlafzimmer",
		objects = {
			{
				title	= "Doppelbett Zebra",
				id		= 14446,
				price	= 1000,
			},
			{
				title	= "Doppelbett Braun 1",
				id		= 1799,
				price	= 1000,
			},
			{
				title	= "Doppelbett Braun 2",
				id		= 1797,
				price	= 1000,
			},
			{
				title	= "Doppelbett Braun 3",
				id		= 2302,
				price	= 1000,
			},
			{
				title	= "Doppelbett Braun 4",
				id		= 1725,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 5",
				id		= 1802,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 6",
				id		= 14866,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 7",
				id		= 1803,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 8",
				id		= 1745,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 9",
				id		= 1794,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 10",
				id		= 1798,
				price	= 1000,
			},
			{
				title	= "Doppelbett Buche 11",
				id		= 2299,
				price	= 1000,
			},
			{
				title	= "Doppelbett Muster",
				id		= 1793,
				price	= 1000,
			},
			{
				title	= "Doppelbett Gestreift",
				id		= 1795,
				price	= 1000,
			},
			{
				title	= "Doppelbett Metall",
				id		= 1801,
				price	= 1000,
			},
			
			{
				title	= "Doppelbett m. Nachtschränken 1",
				id		= 2575,
				price	= 1000,
			},
			{
				title	= "Doppelbett m. Nachtschränken 2",
				id		= 2566,
				price	= 1000,
			},
			{
				title	= "Doppelbett m. Nachtschränken 3",
				id		= 2298,
				price	= 1000,
			},
			{
				title	= "Doppelbett m. Nachtschränken 4",
				id		= 2565,
				price	= 1000,
			},
			
			{
				title	= "Doppelbett mit Wandschrank 1",
				id		= 2300,
				price	= 1000,
			},
			{
				title	= "Doppelbett mit Wandschrank 2",
				id		= 2301,
				price	= 1000,
			},
			{
				title	= "Doppelbett mit Wandschrank 3",
				id		= 2563,
				price	= 1000,
			},
			{
				title	= "Doppelbett mit Wandschrank 4",
				id		= 2564,
				price	= 1000,
			},
			
			{
				title	= "Einzelbett Buche",
				id		= 1796,
				price	= 1000,
			},
			
			{
				title	= "Klappbett 1",
				id		= 1812,
				price	= 1000,
			},
			{
				title	= "Klappbett 2",
				id		= 1800,
				price	= 1000,
			},
			
			{
				title	= "Kleiderschrank Buche 1",
				id		= 14867,
				price	= 1000,
			},
			{
				title	= "Kleiderschrank Buche 2",
				id		= 2307,
				price	= 1000,
			},
			{
				title	= "Kleiderschrank Buche 2",
				id		= 2329,
				price	= 1000,
			},
			{
				title	= "Kleiderschrank Buche 3",
				id		= 2330,
				price	= 1000,
			},
			{
				title	= "Kleiderschrank Buche 4",
				id		= 2088,
				price	= 1000,
			},
			{
				title	= "Kleiderschrank Braun 4",
				id		= 2025,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 1",
				id		= 2323,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 2",
				id		= 1741,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 3",
				id		= 2094,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 4",
				id		= 1416,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 5",
				id		= 1417,
				price	= 1000,
			},
			{
				title	= "Kommode Buche 6",
				id		= 2306,
				price	= 1000,
			},
			
			{
				title	= "Nachttisch Buche 1",
				id		= 2095,
				price	= 1000,
			},
			{
				title	= "Nachttisch Buche 2",
				id		= 1740,
				price	= 1000,
			},
			{
				title	= "Nachttisch Buche 3",
				id		= 2328,
				price	= 1000,
			},
			{
				title	= "Nachttisch Weiß",
				id		= 2021,
				price	= 1000,
			},
			{
				title	= "Nachttisch Braun",
				id		= 1730,
				price	= 1000,
			},
			
			{
				title	= "Wandboard Buche 1",
				id		= 2570,
				price	= 1000,
			},
			{
				title	= "Wandboard Buche 2",
				id		= 2562,
				price	= 1000,
			},
			{
				title	= "Wandboard Braun",
				id		= 2568,
				price	= 1000,
			},
			
			
		},
	},
	
	{
		title = "Deko",
		objects = {
			{
				title	= "Teppich Rot",
				id		= 2631,
				price	= 1000,
			},
			{
				title	= "Teppich Grün 1",
				id		= 2632,
				price	= 1000,
			},
			{
				title	= "Teppich Rot-Orange",
				id		= 2818,
				price	= 1000,
			},
			{
				title	= "Teppich Grün 2",
				id		= 2817,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 1",
				id		= 2833,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 2",
				id		= 2836,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 3",
				id		= 2841,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 4",
				id		= 2835,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 5",
				id		= 2815,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 6",
				id		= 2834,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 7",
				id		= 2847,
				price	= 1000,
			},
			{
				title	= "Teppich Muster 8",
				id		= 2842,
				price	= 1000,
			},
			{
				title	= "Teppich Tiger",
				id		= 1828,
				price	= 1000,
			},
			
			
			{
				title	= "Stehlampe 1",
				id		= 2069,
				price	= 1000,
			},
			{
				title	= "Stehlampe 2",
				id		= 2071,
				price	= 1000,
			},
			{
				title	= "Stehlampe 3",
				id		= 2072,
				price	= 1000,
			},
			{
				title	= "Stehlampe 4",
				id		= 2108,
				price	= 1000,
			},
			{
				title	= "Stehlampe 5",
				id		= 2023,
				price	= 1000,
			},
			
			{
				title	= "Tischlampe 1",
				id		= 2106,
				price	= 1000,
			},
			{
				title	= "Tischlampe 2",
				id		= 2105,
				price	= 1000,
			},
			{
				title	= "Tischlampe 3",
				id		= 2196,
				price	= 1000,
			},
			
			{
				title	= "Wandlampe",
				id		= 1731,
				price	= 1000,
			},
			
			
			{
				title	= "Hirschkopf",
				id		= 1736,
				price	= 1000,
			},
			{
				title	= "Vase 1",
				id		= 14705,
				price	= 1000,
			},
			{
				title	= "Vase 2",
				id		= 2870,
				price	= 1000,
			},
			{
				title	= "Kerze",
				id		= 2868,
				price	= 1000,
			},
			{
				title	= "Kerzen",
				id		= 2869,
				price	= 1000,
			},
			
			{
				title	= "Bücher 1",
				id		= 2853,
				price	= 1000,
			},
			{
				title	= "Bücher 2",
				id		= 2813,
				price	= 1000,
			},
			
			
			{
				title	= "Bilderrahmen",
				id		= 2828,
				price	= 1000,
			},
			
			{
				title	= "Wandbild 1",
				id		= 2257,
				price	= 1000,
			},
			{
				title	= "Wandbild 2",
				id		= 2258,
				price	= 1000,
			},
			{
				title	= "Wandbild 3",
				id		= 2256,
				price	= 1000,
			},
			{
				title	= "Wandbild 4",
				id		= 2283,
				price	= 1000,
			},
			{
				title	= "Wandbild 5",
				id		= 2286,
				price	= 1000,
			},
			{
				title	= "Wandbild 6",
				id		= 2276,
				price	= 1000,
			},
			{
				title	= "Wandbild 7",
				id		= 2277,
				price	= 1000,
			},
			{
				title	= "Wandbild 8",
				id		= 2284,
				price	= 1000,
			},
			{
				title	= "Wandbild 9",
				id		= 2281,
				price	= 1000,
			},
			{
				title	= "Wandbild 10",
				id		= 2280,
				price	= 1000,
			},
			{
				title	= "Wandbild 11",
				id		= 2282,
				price	= 1000,
			},
			
			{
				title	= "Spielautomat „Bee Bee Gone!“",
				id		= 2778,
				price	= 1000,
			},
			{
				title	= "Spielautomat „Space Monkey“",
				id		= 2681,
				price	= 1000,
			},
			{
				title	= "Spielautomat „Duality“",
				id		= 2779,
				price	= 1000,
			},
			
		},
	},
	
	{
		title = "Wohnzimmer",
		objects = {
			{
				title	= "schwarze Couch (Polster)",
				id		= 1726,
				price	= 1000,
			},
			{
				title	= "Sessel schwarz (Polster)",
				id		= 1727,
				price	= 1000,
			},
			{
				title	= "braune Couch (lang)",
				id		= 1710,
				price	= 1000,
			},
			{
				title	= "braune Couch (eck)",
				id		= 1709,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 1",
				id		= 1766,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 2",
				id		= 1761,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 3",
				id		= 1760,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 4",
				id		= 1757,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 5",
				id		= 1764,
				price	= 1000,
			},
			{
				title	= "Couch (Muster) 6",
				id		= 1763,
				price	= 1000,
			},
			{
				title	= "braune Couch (kurz)",
				id		= 1712,
				price	= 1000,
			},
			{
				title	= "Couch (Leder braun)",
				id		= 2290,
				price	= 1000,
			},
			{
				title	= "Couch (Auto)",
				id		= 1768,
				price	= 1000,
			},
			{
				title	= "Couch (schwarz)",
				id		= 1703,
				price	= 1000,
			},
			{
				title	= "Couch (lila)",
				id		= 1706,
				price	= 1000,
			},
			{
				title	= "Couch (braun)",
				id		= 1702,
				price	= 1000,
			},
			{
				title	= "Sessel (braun)",
				id		= 1711,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 1",
				id		= 1735,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 2",
				id		= 1769,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 3",
				id		= 1755,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 4",
				id		= 1759,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 5",
				id		= 1758,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 6",
				id		= 1762,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 7",
				id		= 1767,
				price	= 1000,
			},
			{
				title	= "Sessel (Muster) 8",
				id		= 1765,
				price	= 1000,
			},
			{
				title	= "Sessel (Leder) 1",
				id		= 1754,
				price	= 1000,
			},
			{
				title	= "Sessel (Leder) 2",
				id		= 1724,
				price	= 1000,
			},
			{
				title	= "Sessel (Leder) 3",
				id		= 1705,
				price	= 1000,
			},
			{
				title	= "Sessel (mit Tisch) 1",
				id		= 2617,
				price	= 1000,
			},
			{
				title	= "Sessel (mit Tisch) 2",
				id		= 2571,
				price	= 1000,
			},
			{
				title	= "Sitzsack (braun)",
				id		= 2295,
				price	= 1000,
			},
			{
				title	= "Schaukelstuhl",
				id		= 2096,
				price	= 1000,
			},
			{
				title	= "Bürostuhl (Leder) 1",
				id		= 1714,
				price	= 1000,
			},
			{
				title	= "Bürostuhl (Leder) 2",
				id		= 1715,
				price	= 1000,
			},
			{
				title	= "Bürostuhl",
				id		= 2356,
				price	= 1000,
			},
			{
				title	= "Schrankwand (Mahagoni)",
				id		= 2204,
				price	= 1000,
			},
			{
				title	= "Schrank (mit Türen)",
				id		= 2200,
				price	= 1000,
			},
			{
				title	= "Schrank (Mahagoni)",
				id		= 2167,
				price	= 1000,
			},
			{
				title	= "Schrank (Kirschbaum) 1",
				id		= 2078,
				price	= 1000,
			},
			{
				title	= "Schrank (Kirschbaum) 2",
				id		= 2089,
				price	= 1000,
			},
			{
				title	= "Regal (rustikal)",
				id		= 2063,
				price	= 1000,
			},
			{
				title	= "Bücherregal (Eiche)",
				id		= 1742,
				price	= 1000,
			},
			{
				title	= "Schrank (Eiche) 1",
				id		= 1743,
				price	= 1000,
			},
			{
				title	= "Schrank (Eiche) 2",
				id		= 2087,
				price	= 1000,
			},
			{
				title	= "TV-Schrank (Eiche) 1",
				id		= 2296,
				price	= 1000,
			},
			{
				title	= "TV-Schrank (Eiche) 2",
				id		= 2297,
				price	= 1000,
			},
			{
				title	= "Tisch (Eiche) 1",
				id		= 2180,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 1",
				id		= 2315,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 2",
				id		= 2080,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 3",
				id		= 2119,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 4",
				id		= 2311,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 5",
				id		= 2126,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 6",
				id		= 2236,
				price	= 1000,
			},
			{
				title	= "Tisch (Kirschbaum) 7",
				id		= 1822,
				price	= 1000,
			},
			{
				title	= "Tisch (Marmor)",
				id		= 2118,
				price	= 1000,
			},
			{
				title	= "Tisch (Plastik)",
				id		= 1813,
				price	= 1000,
			},
			{
				title	= "Tisch (Edel)",
				id		= 2357,
				price	= 1000,
			},
			{
				title	= "Tisch (Eiche)",
				id		= 2319,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 1",
				id		= 2321,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 1",
				id		= 2083,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 2",
				id		= 2082,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 3",
				id		= 2084,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 4",
				id		= 1823,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 5",
				id		= 2111,
				price	= 1000,
			},
			{
				title	= "Tisch (Mahagoni) 6",
				id		= 2112,
				price	= 1000,
			},
			{
				title	= "Tisch (Eiche) 2",
				id		= 1821,
				price	= 1000,
			},
			{
				title	= "Tisch (Eiche) 3",
				id		= 1815,
				price	= 1000,
			},
			{
				title	= "Tisch (Eiche) 4",
				id		= 1819,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 2",
				id		= 2116,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 3",
				id		= 1821,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 4",
				id		= 1817,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 5",
				id		= 1814,
				price	= 1000,
			},
			{
				title	= "Tisch (Buche) 6",
				id		= 1818,
				price	= 1000,
			},
			{
				title	= "TV-Tisch (Buche) 1",
				id		= 2314,
				price	= 1000,
			},
			{
				title	= "TV-Tisch (Buche) 2",
				id		= 2346,
				price	= 1000,
			},
			{
				title	= "TV-Tisch (Buche) 3",
				id		= 2321,
				price	= 1000,
			},
			{
				title	= "TV-Tisch (Buche) 4",
				id		= 2313,
				price	= 1000,
			},
		},
	},
	
	{
		title = "Garten",
		objects = {
			{
				title	= "Basketball",
				id		= 1946,
				price	= 1000,
			},
			{
				title	= "Basketballkorb 1",
				id		= 3496,
				price	= 1000,
			},
			{
				title	= "Basketballkorb 2",
				id		= 947,
				price	= 1000,
			},
			{
				title	= "DIXI-Klo",
				id		= 2984,
				price	= 1000,
			},
			{
				title	= "BigSmoke Statue",
				id		= 14467,
				price	= 1000,
			},
			{
				title	= "Statue ohne Kopf",
				id		= 2744,
				price	= 1000,
			},
			{
				title	= "Statue (Heulsuse)",
				id		= 2745,
				price	= 1000,
			},
			{
				title	= "Metallzaun",
				id		= 970,
				price	= 1000,
			},
			{
				title	= "Blumenrahmen",
				id		= 1480,
				price	= 1000,
			},
			{
				title	= "Hundehütte",
				id		= 1451,
				price	= 1000,
			},
			{
				title	= "Fackel",
				id		= 3461,
				price	= 1000,
			},
			{
				title	= "Grill",
				id		= 1481,
				price	= 1000,
			},
			{
				title	= "Steinbank",
				id		= 1364,
				price	= 1000,
			},
			{
				title	= "Blumenschutz",
				id		= 3261,
				price	= 1000,
			},
			{
				title	= "Volleyballnetz",
				id		= 1639,
				price	= 1000,
			},
			{
				title	= "Picknick-Bank",
				id		= 1281,
				price	= 1000,
			},
			{
				title	= "Bank",
				id		= 1280,
				price	= 1000,
			},
			{
				title	= "Gartenlicht",
				id		= 1215,
				price	= 1000,
			},
			{
				title	= "Dekostein 1",
				id		= 748,
				price	= 1000,
			},
			{
				title	= "Dekostein 2",
				id		= 749,
				price	= 1000,
			},
			{
				title	= "Dekostein 3",
				id		= 750,
				price	= 1000,
			},
			{
				title	= "Dekostein 4",
				id		= 751,
				price	= 1000,
			},
			{
				title	= "Dekobaum",
				id		= 3439,
				price	= 1000,
			},
			{
				title	= "Liege 1",
				id		= 1647,
				price	= 1000,
			},
			{
				title	= "Liege 2",
				id		= 1646,
				price	= 1000,
			},
			{
				title	= "Liege 3",
				id		= 1645,
				price	= 1000,
			},
			{
				title	= "Liege 4",
				id		= 1255,
				price	= 1000,
			},
			{
				title	= "Zaun (rustikal)",
				id		= 1407,
				price	= 1000,
			},
			{
				title	= "Zaun (Holz) 1",
				id		= 1408,
				price	= 1000,
			},
			{
				title	= "Zaun (Metall)",
				id		= 1419,
				price	= 1000,
			},
			{
				title	= "Zaun (Holz) 2",
				id		= 1418,
				price	= 1000,
			},
			{
				title	= "Zaun (Holz) 3",
				id		= 1446,
				price	= 1000,
			},
		
		}
	}
}

for k, v in pairs(objects) do
	for kk, vv in pairs(v.objects) do
		furnitureNames[vv.id] = vv.title
	end
end


--[[
local markerIn = createMarker(1081.2, -1696.8, 14.2, "arrow", 1, 230, 90, 25) --to:
local markerOut = createMarker(383.5, -1824.8, 58.4, "arrow", 1, 230, 90, 25) --to:
setElementInterior(markerOut, 80)
setElementDimension(markerOut, 111)

addEventHandler("onMarkerHit", markerIn, function(elem, dim)
	if (dim == true) then
		if (getElementType(elem) == "player") then
			
			fadeElementInterior(elem, 80, 383.6, -1826.3, 57.9, 190, 111)
			
		end
	end
end)
addEventHandler("onMarkerHit", markerOut, function(elem, dim)
	if (dim == true) then
		if (getElementType(elem) == "player") then
			
			fadeElementInterior(elem, 0, 1081.5, -1698.2, 13.55, 180, 0)
			
		end
	end
end)
]]

local ped = createPed(141, 387.2, -1826.1, 57.9, 180)
setElementInterior(ped, 80)
setElementDimension(ped, 111)
setElementFrozen(ped, true)
setElementData(ped, "invulnerable", true)
local bedroom = createMarker(395.3, -1850.4, 57.5, "corona", 1, 230, 90, 25)
setElementInterior(bedroom, 80)
setElementDimension(bedroom, 111)
local livingroom = createMarker(386.7, -1843.0, 57.5, "corona", 1, 230, 90, 25)
setElementInterior(livingroom, 80)
setElementDimension(livingroom, 111)
local kitchen = createMarker(394.9, -1830.2, 57.5, "corona", 1, 230, 90, 25)
setElementInterior(kitchen, 80)
setElementDimension(kitchen, 111)
local other = createMarker(390.2, -1828.5, 57.5, "corona", 1, 230, 90, 25)
setElementInterior(other, 80)
setElementDimension(other, 111)
local outdoor = createMarker(1134.38, -1690.9, 13.5, "corona", 1, 230, 90, 25)


addEventHandler("onMarkerHit", root, function(elem, dim)
	if (dim == true) then
		if (getElementType(elem) == "player") then
			
			local nr = false
			if (source == bedroom) then
				nr = 2
			elseif (source == livingroom) then
				nr = 4
			elseif (source == kitchen) then
				nr = 1
			elseif (source == other) then
				nr = 3
			elseif (source == outdoor) then
				nr = 5
			end
			
			if (nr) then
				triggerClientEvent(elem, "openSkykea", elem, objects[nr].objects, nr)
			end
			
		end
	end
end)

addEvent("skykeaBuy", true)
addEventHandler("skykeaBuy", root, function(cat, id)
	local arr = objects[cat].objects[id]
	if (type(arr) == "table") then
		
		if (getPlayerMoney(source) >= arr.price) then
			
			takePlayerMoney(source, arr.price, arr.title)
			addInventory(source, arr.id, 1)
			Franchise:addShopMoney(source, PizzaMenues[menueID].price)
			
		else
			notificationShow(source, "error", "Du hast nicht genügend Geld.")
		end
		
	end
end)