----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


settings = {
	
	general = {
		serverName					= "Lars Reallife",
		serverNameShort				= "Lars-RL",
		forumURL					= "www.Lars-RL.tld",
		tsIP						= "ts.Lars-RL.tld",
		version						= "1.0",
		DEBUG						= true,
		webserverURL				= "REPLACE READ INSTALL.TXT", -- (Sub-)Domain in die client/browser_whitelist eintragen!!
		
		maxServerFPS				= 65,
		maxHighPing					= 1000,
		
		teamRankNames = {
			[1]						= "Clan-Member",
			[2]						= "Ticketsupporter",
			[3]						= "Support",
			[4]						= "Moderation",
			[5]						= "Administration",
			[6]						= "Entwicklung",
			[7]						= "stellv. Projektleitung",
			[8]						= "Projektleitung"
		},
		clanTag						= "[Lars]",
		
		defaultSpawn				= {1481, -1738.8, 13.5, 0, 0, 0}, --|x|y|z|rz|int|dim|
		startMoneyHand				= 1000,
		noobSocialState				= 'Neuling',
		noobMaxCars					= 3,
		
		noobSkinsMale = {
			[1]						= 78,
			[2]						= 79,
			[3]						= 134,
			[4]						= 135,
			[4]						= 136,
			[5]						= 137
		},
		noobSkinsFemale = {
			[1]						= 77
		},
		
		joinCameraMatrix			= {1175, -2036.9000244141, 76.5, 1122.4000244141, -2037, 70.599998474121},
		deathTime					= 60,
		
		-- Min/Max Geldverlust bei tod ( getPlayerMoney() / math.random(Min, Max) )
		deathLostMoneyMin			= 10,
		deathLostMoneyMax			= 25,
		
		playerSaveMinutes			= 5,
	},
	
	
	
	
	
	factions = { -- Faction Settings
		
		factionNames = {
			[0]						= "Zivilist",
			[1]						= "LSPD",
			[2]						= "US Army",
			[3]						= "SEK",
			[4]						= "Mafia",
			[5]						= "Yakuza"
		},
		
		jail = {
			perWantedGestellt		= 5,
			perWanted				= 7,
			perWantedOffline		= 10,
			cautionPerWanted		= 2500
		},
	},
	
	
	
	
	
	
	
	
	
	
	
	systems = {
		saveTimersInterval		= ((60*1000)*10),
		
		bank = {
			vaultMoneyMin		= 666, 
			vaultMoneyMax		= 2000, -- Min&Max Money pro safe (anzhal safes: 21)
		},
		
		house = {
			maxRenter			= 999, -- Max. mieter pro haus
			houseSellBack		= 75, -- Wieviel Prozent vom kaufpreis soll besitzer beim verkauf zurück bekommen
			maxRent				= 500, -- Max. mietpreis
		},
		
		vehicle = {
			respawnPrice		= 50,
			maxCars				= 5,
			maxExplosions		= 3, -- Nach X Explosionen totalschaden => Werkstatt
			noEngine = {
				[509] 			= true,
				[481] 			= true,
				[510] 			= true,
				[462] 			= true
			},
			radioStations = {
				{name = "I ❤ Radio", url="http://stream01.iloveradio.de/iloveradio1.mp3", image = "iloveradio.png"}, 
				{name = "I ❤ 2 Dance", url="http://stream01.iloveradio.de/iloveradio2.mp3", image = "iloveradiodance.png"}, 
				{name = "I ❤ The Battle", url="http://stream01.iloveradio.de/iloveradio3.mp3", image = "iloveradiothebattle.png"}, 
				{name = "I ❤ Mashup", url="http://stream01.iloveradio.de/iloveradio5.mp3", image = "iloveradiomashup.png"}, 
				{name = "I ❤ Bravo Charts", url="http://stream01.iloveradio.de/iloveradio9.mp3", image = "iloveradiobravocharts.png"}, 
				{name = "I ❤ Bravo TubeStars", url="http://stream01.iloveradio.de/iloveradio4.mp3", image = "iloveradiotubestars.png"}, 
				{name = "I ❤ Bravo Party", url="http://stream01.iloveradio.de/iloveradio6.mp3", image = "iloveradiobravoparty.png"}, 
				{name = "You FM", url="https://dg-hr-https-fra-dtag-cdn.sslcast.addradio.de/hr/youfm/live/mp3/128/stream.mp3", image = "youfm.png"}, 
				{name = "1Live", url="https://dg-wdr-https-fra-dtag-cdn.sslcast.addradio.de/wdr/1live/live/mp3/128/stream.mp3", image = "einslive.png"}, 
				{name = "1Live Diggi", url="https://dg-wdr-https-fra-dtag-cdn.sslcast.addradio.de/wdr/1live/diggi/mp3/128/stream.mp3", image = "einslivediggi.png"}, 
				{name = "Bayern 3", url="https://dg-br-https-dus-dtag-cdn.sslcast.addradio.de/br/br3/live/mp3/128/stream.mp3", image = "bayern3.png"}, 
				{name = "Antenne Bayern", url="https://mp3channels.webradio.antenne.de/antenne", image = "antennebayern.png"}, 
				{name = "Radio 7", url="https://stream.radio7.de/stream1/livestream.mp3", image = "radio7.jpg"}, 
				{name = "BigFM", url="https://streams.bigfm.de/bigfm-deutschland-128-mp3", image = "bigfm.png"}, 
				{name = "Top100Station", url="http://stream.top100station.com:8000/top100station.mp3", image = "top100station.png"}, 
				{name = "FFH Top 40", url="https://mp3.ffh.de/ffhchannels/hqtop40.mp3", image = "ffhtop40.jpg"}, 
				{name = "Blackbeats.FM", url="https://de-hz-fal-stream03.rautemusik.fm/blackbeats", image = "blackbeatsfm.jpg"}, 
				{name = "Technobase.FM", url="http://mp3.stream.tb-group.fm/tb.mp3", image = "technobasefm.png"}, 
				{name = "Housetime.FM", url="http://mp3.stream.tb-group.fm/ht.mp3", image = "housetimefm.png"}, 
				{name = "Hardbase.FM", url="http://mp3.stream.tb-group.fm/hb.mp3", image = "hardbasefm.jpg"}, 
				{name = "Hot 108 Jamz", url="http://jbmedia-edge1.cdnstream.com/hot108", image = "hot108jamz.png"}, 
				{name = "Breakz.us", url="https://de-hz-fal-stream03.rautemusik.fm/breakz", image = "breakzfm.png"},
			}
		},
		
		shops = {
			participation	= 10, -- Wie viel prozent eines Verkaufs gehen an die Franchise Company
			sellBack		= 75, -- Wie viel prozent man bei Verkauf wieder bekommen soll
			shopMinTime		= 50, -- Mindestzeit für shops
			companyMinTime	= 100, -- Mindestzeit für Unternehmen
			
			pizzastack = {
				boneEat	= {"food", "eat_pizza", 1250, 2881, 12,0,0,0,0,270,0}, -- für inventar
				menues = {
					[1] = {
						title		= "Salat",
						objectID	= 2355,
						price		= 3,
						hunger		= 15,
					},
					[2] = {
						title		= "Weichei Portion",
						objectID	= 2218,
						price		= 5,
						hunger		= 35,
					},
					[3] = {
						title		= "Double D-Luxe",
						objectID	= 2219,
						price		= 7,
						hunger		= 65,
					},
					[4] = {
						title		= "Volle Lutsche",
						objectID	= 2220,
						price		= 10,
						hunger		= 100,
					},
				},
			},
			donut = {
				boneEat	= {"vending", "vend_drink2_p", 1500, 1666, 11, 0, 0.05, 0.1, 0, 90, 0}, -- für inventar
				menues = {
					[1] = {
						title		= "Donut, Muffin, Kaffee",
						objectID	= 2221,
						price		= 3,
						hunger		= 30,
					},
					[2] = {
						title		= "5 Donuts, Kaffee",
						objectID	= 2223,
						price		= 5,
						hunger		= 60,
					},
					[3] = {
						title		= "9 Donuts, Kaffee",
						objectID	= 2222,
						price		= 7,
						hunger		= 90,
					},
				},
			},
			cluckinbell = {
				boneEat	= {"food", "eat_pizza", 1000, 2769, 12,0.03,0.03,0.1,0,0,270}, -- für inventar
				menues = {
					[1] = {
						title		= "Salad Meal",
						objectID	= 2353,
						price		= 4,
						hunger		= 15,
					},
					[2] = {
						title		= "Cluckin’ Little Meal",
						objectID	= 2215,
						price		= 6,
						hunger		= 35,
					},
					[3] = {
						title		= "Cluckin’ Big Meal",
						objectID	= 2216,
						price		= 6,
						hunger		= 65,
					},
					[4] = {
						title		= "Cluckin’ Huge Meal",
						objectID	= 2217,
						price		= 10,
						hunger		= 100,
					},
				},
			},
			sexshop = {
				menues = {
					[1] = {
						title		= "Langer Dildo, Lila",
						objectID	= 321,
						price		= 10,
						weaponID	= 10,
					},
					[2] = {
						title		= "Langer Dildo, Weiß",
						objectID	= 323,
						price		= 10,
						weaponID	= 12,
					},
					[3] = {
						title		= "Vibrator",
						objectID	= 322,
						price		= 15,
						weaponID	= 11,
					},
				},
			},
			burgershot = {
				boneEat	= {"food", "eat_burger", 1250, 2703, 12,0,0.06,0.1,270,0,90}, -- für inventar
				menues = {
					[1] = {
						title		= "Salad Meal",
						objectID	= 2354,
						price		= 3,
						hunger		= 15,
					},
					[2] = {
						title		= "Moo Kids Meal",
						objectID	= 2213,
						price		= 6,
						hunger		= 35,
					},
					[3] = {
						title		= "Beef Tower",
						objectID	= 2214,
						price		= 8,
						hunger		= 65,
					},
					[4] = {
						title		= "Double Barreled Special",
						objectID	= 2212,
						price		= 12,
						hunger		= 100,
					},
				},
			},
			--[[
				shop = all, zip, binco, suburban, victim, prolaps, didiersachs
				https://wiki.multitheftauto.com/wiki/All_Skins_Page
			]]
			clothing = {
				skins = {
					[1] = {
						title		= "Mann (Jeansjacke)",
						price		= 225,
						skinID		= 7,
						shop		= "victim",
					},
					[2] = {
						title		= "Mann mit Hut",
						price		= 150,
						skinID		= 2,
						shop		= "binco",
					},
					[3] = {
						title		= "Frau (Anzug)",
						price		= 600,
						skinID		= 9,
						shop		= "didiersachs",
					},
					[4] = {
						title		= "Frau (Chic)",
						price		= 555,
						skinID		= 12,
						shop		= "zip",
					},
					[5] = {
						title		= "Frau (Ghetto)",
						price		= 150,
						skinID		= 13,
						shop		= "binco",
					},
					[6] = {
						title		= "Mann (Anzug)",
						price		= 1500,
						skinID		= 17,
						shop		= "didiersachs",
					},
					[7] = {
						title		= "Mann (Strand)",
						price		= 200,
						skinID		= 18,
						shop		= "prolaps",
					},
					[8] = {
						title		= "Mann (Normal)",
						price		= 350,
						skinID		= 20,
						shop		= "all",
					},
					[9] = {
						title		= "Mann (Ghetto)",
						price		= 250,
						skinID		= 21,
						shop		= "binco",
					},
					[10] = {
						title		= "Mann (Sport)",
						price		= 350,
						skinID		= 22,
						shop		= "suburban",
					},
					[11] = {
						title		= "Mann (Normal)",
						price		= 350,
						skinID		= 23,
						shop		= "suburban",
					},
					[12] = {
						title		= "Mann (Chic)",
						price		= 850,
						skinID		= 25,
						shop		= "victim",
					},
					[13] = {
						title		= "Camper",
						price		= 150,
						skinID		= 26,
						shop		= "all",
					},
					[14] = {
						title		= "Dealer (Tank Top)",
						price		= 250,
						skinID		= 28,
						shop		= "binco",
					},
					[15] = {
						title		= "Der Lars",
						price		= 350,
						skinID		= 29,
						shop		= "all",
					},
					[16] = {
						title		= "Mexikaner (Ghetto)",
						price		= 250,
						skinID		= 30,
						shop		= "binco",
					},
					[17] = {
						title		= "Cowgirl (Alt)",
						price		= 300,
						skinID		= 31,
						shop		= "binco",
					},
					[18] = {
						title		= "Cowboy",
						price		= 300,
						skinID		= 34,
						shop		= "binco",
					},
					[19] = {
						title		= "Frau (Chic)",
						price		= 850,
						skinID		= 40,
						shop		= "zip",
					},
					[20] = {
						title		= "Frau (Normal)",
						price		= 450,
						skinID		= 41,
						shop		= "victim",
					},
					[21] = {
						title		= "Trucker",
						price		= 400,
						skinID		= 44,
						shop		= "victim",
					},
					[22] = {
						title		= "Mann (Strand)",
						price		= 250,
						skinID		= 45,
						shop		= "prolaps",
					},
					[23] = {
						title		= "Mann (Chic)",
						price		= 950,
						skinID		= 46,
						shop		= "didiersachs",
					},
					[24] = {
						title		= "Mexikaner (Ghetto)",
						price		= 250,
						skinID		= 47,
						shop		= "binco",
					},
					[25] = {
						title		= "Frau (Chic)",
						price		= 950,
						skinID		= 55,
						shop		= "zip",
					},
					[26] = {
						title		= "Frau (Normal)",
						price		= 450,
						skinID		= 56,
						shop		= "victim",
					},
					[27] = {
						title		= "Alter Mann (Anzug)",
						price		= 1000,
						skinID		= 57,
						shop		= "didiersachs",
					},
					[28] = {
						title		= "Mann (Normal)",
						price		= 750,
						skinID		= 59,
						shop		= "all",
					},
					[29] = {
						title		= "Mann (Normal)",
						price		= 350,
						skinID		= 60,
						shop		= "victim",
					},
					[30] = {
						title		= "Frau (Nutte)",
						price		= 350,
						skinID		= 63,
						shop		= "binco",
					},
					[31] = {
						title		= "Frau (Nutte)",
						price		= 350,
						skinID		= 64,
						shop		= "binco",
					},
					[32] = {
						title		= "Trucker",
						price		= 350,
						skinID		= 67,
						shop		= "victim",
					},
					[33] = {
						title		= "Hippie",
						price		= 350,
						skinID		= 73,
						shop		= "binco",
					},
					[34] = {
						title		= "Frau (Chic)",
						price		= 750,
						skinID		= 76,
						shop		= "didiersachs",
					},
					[35] = {
						title		= "Elvis (schwarz)",
						price		= 550,
						skinID		= 82,
						shop		= "victim",
					},
					[36] = {
						title		= "Elvis (weiß)",
						price		= 550,
						skinID		= 83,
						shop		= "victim",
					},
					[37] = {
						title		= "Elvis (blau)",
						price		= 550,
						skinID		= 84,
						shop		= "victim",
					},
					[38] = {
						title		= "Frau (Nutte)",
						price		= 350,
						skinID		= 85,
						shop		= "binco",
					},
					[39] = {
						title		= "Frau (sportlich)",
						price		= 450,
						skinID		= 90,
						shop		= "suburban",
					},
					[40] = {
						title		= "Frau (Chic)",
						price		= 850,
						skinID		= 91,
						shop		= "zip",
					},
					[41] = {
						title		= "Frau (Normal)",
						price		= 750,
						skinID		= 93,
						shop		= "zip",
					},
					[42] = {
						title		= "Der Franz",
						price		= 690,
						skinID		= 98,
						shop		= "all",
					},
					[43] = {
						title		= "Mann (Normal)",
						price		= 450,
						skinID		= 101,
						shop		= "binco",
					},
					[44] = {
						title		= "Trucker",
						price		= 350,
						skinID		= 128,
						shop		= "victim",
					},
					[45] = {
						title		= "Trucker",
						price		= 350,
						skinID		= 133,
						shop		= "victim",
					},
					[46] = {
						title		= "Frau (Strand)",
						price		= 450,
						skinID		= 138,
						shop		= "prolaps",
					},
					[47] = {
						title		= "Frau (Strand)",
						price		= 450,
						skinID		= 139,
						shop		= "prolaps",
					},
					[48] = {
						title		= "Frau (Strand)",
						price		= 450,
						skinID		= 140,
						shop		= "prolaps",
					},
					[49] = {
						title		= "Mann (festlich)",
						price		= 350,
						skinID		= 142,
						shop		= "victim",
					},
					[50] = {
						title		= "Mann (Anzug)",
						price		= 1000,
						skinID		= 147,
						shop		= "didiersachs",
					},
					[51] = {
						title		= "Frau (Anzug)",
						price		= 750,
						skinID		= 148,
						shop		= "didiersachs",
					},
					[52] = {
						title		= "Frau (Anzug)",
						price		= 750,
						skinID		= 150,
						shop		= "didiersachs",
					},
					[53] = {
						title		= "Frau (Land)",
						price		= 150,
						skinID		= 157,
						shop		= "binco",
					},
					[54] = {
						title		= "Mann (Land)",
						price		= 150,
						skinID		= 158,
						shop		= "binco",
					},
					[55] = {
						title		= "Mann (Land)",
						price		= 150,
						skinID		= 159,
						shop		= "binco",
					},
					[56] = {
						title		= "Mann (Land)",
						price		= 50,
						skinID		= 162,
						shop		= "binco",	
					},
					[57] = {
						title		= "Mann (Normal)",
						price		= 450,
						skinID		= 170,
						shop		= "victim",
					},
					[58] = {
						title		= "Mann (Chic)",
						price		= 750,
						skinID		= 171,
						shop		= "didiersachs",
					},
					[59] = {
						title		= "Frau (Chic)",
						price		= 750,
						skinID		= 172,
						shop		= "didiersachs",
					},
					[60] = {
						title		= "Mann (Chic)",
						price		= 750,
						skinID		= 185,
						shop		= "didiersachs",
					},
					[61] = {
						title		= "Mann (Anzug)",
						price		= 1000,
						skinID		= 187,
						shop		= "didiersachs",
					},
					[62] = {
						title		= "Mann (Normal)",
						price		= 750,
						skinID		= 188,
						shop		= "victim",
					},
					[63] = {
						title		= "Frau (Normal)",
						price		= 450,
						skinID		= 192,
						shop		= "victim",
					},
					[64] = {
						title		= "Frau (Normal)",
						price		= 350,
						skinID		= 193,
						shop		= "binco",
					},
					[65] = {
						title		= "Mann (Chic)",
						price		= 750,
						skinID		= 194,
						shop		= "didiersachs",
					},
					[66] = {
						title		= "Frau (Gettho)",
						price		= 350,
						skinID		= 195,
						shop		= "binco",
					},
					[67] = {
						title		= "Cowgirl",
						price		= 350,
						skinID		= 198,
						shop		= "victim",
					},
					[68] = {
						title		= "Frau (Normal)",
						price		= 650,
						skinID		= 211,
						shop		= "zip",
					},
					[69] = {
						title		= "Frau (Chic)",
						price		= 750,
						skinID		= 215,
						shop		= "zip",
				    },
					[70] = {
						title		= "Frau (Normal)",
						price		= 650,
						skinID		= 216,
						shop		= "zip",
					},
					[71] = {
						title		= "Mann (Normal)",
						price		= 450,
						skinID		= 217,
						shop		= "victim",
					},
					[72] = {
						title		= "Frau (Chic)",
						price		= 750,
						skinID		= 219,
						shop		= "zip",
					},
					[73] = {
						title		= "Alter Mann (festlich)",
						price		= 350,
						skinID		= 220,
						shop		= "victim",
					},
					[74] = {
						title		= "Mann (Chic)",
						price		= 750,
						skinID		= 223,
						shop		= "didiersachs",
					},
					[75] = {
						title		= "Frau (asiatisch)",
						price		= 750,
						skinID		= 224,
						shop		= "didiersachs",
					},
					[76] = {
						title		= "Frau (Normal)",
						price		= 500,
						skinID		= 226,
						shop		= "victim",
					},
					[77] = {
						title		= "Mann (Anzug)",
						price		= 950,
						skinID		= 227,
						shop		= "didiersachs",
					},
					[78] = {
						title		= "Mann (Anzug)",
						price		= 950,
						skinID		= 228,
						shop		= "didiersachs",
					},
					[79] = {
						title		= "Frau (Chic)",
						price		= 750,
						skinID		= 233,
						shop		= "zip",
					},
					[80] = {
						title		= "Mann (Chic)",
						price		= 750,
						skinID		= 240,
						shop		= "zip",
					},
					[81] = {
						title		= "Mann (Afro)",
						price		= 450,
						skinID		= 241,
						shop		= "binco",
					},
					[82] = {
						title		= "Zuhälter",
						price		= 750,
						skinID		= 249,
						shop		= "zip",
					},
					[83] = {
						title		= "Mann (Normal)",
						price		= 750,
						skinID		= 250,
						shop		= "victim",
					},
					[84] = {
						title		= "Frau (Strand)",
						price		= 450,
						skinID		= 251,
						shop		= "prolaps",
					},
					[85] = {
						title		= "Mann (Boxershorts)",
						price		= 150,
						skinID		= 252,
						shop		= "all",
					},
					[86] = {
						title		= "Mann (Normal)",
						price		= 500,
						skinID		= 171,
						shop		= "victim",
					},
					[87] = {
						title		= "Mann (Normal)",
						price		= 500,
						skinID		= 172,
						shop		= "victim",
					},
				},
			},
			ammunation = {
				menues = {
					--[[
						munPrice: Preis pro Magazin
						munSize: Kugeln pro Magazin
					]]
					[1] = {
						title		= "Schlagring",--
						objectID	= 331,
						weaponID	= 1,
						price		= 150,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.339, -38.299, 1002.500, 0, 310, 90},
						matrix		= {298.747, -38.176, 1002.765}
					},
					[2] = {
						title		= "Schlagstock",--
						objectID	= 334,
						weaponID	= 3,
						price		= 200,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.270, -39.000, 1002.500, 0, 20, 90},
						matrix		= {298.829, -38.922, 1002.765}
					},
					[3] = {
						title		= "Messer",--
						objectID	= 335,
						weaponID	= 4,
						price		= 250,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {297.900, -41.799, 1002.200, 0, 30, 0},
						matrix		= {297.907, -39.543, 1002.671}
					},
					[4] = {
						title		= "Baseballschläger",--
						objectID	= 336,
						weaponID	= 5,
						price		= 225,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {298.700, -41.799, 1002.099, 0, 345, 0},
						matrix		= {298.713, -39.362, 1002.671}
					},
					[5] = {
						title		= "Katana",--
						objectID	= 339,
						weaponID	= 8,
						price		= 350,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {299.399, -41.799, 1002.099, 0, 330, 2},
						matrix		= {299.507, -39.589, 1002.629}
					},
					[6] = {
						title		= "Molotov Cocktail",--
						objectID	= 344,
						weaponID	= 18,
						price		= 125,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= true,
						position	= {300.200, -38.599, 1002.300, 0, 0, 0},
						matrix		= {299.005, -38.493, 1002.425}
					},
					[7] = {
						title		= "Pistole",--
						objectID	= 346,
						weaponID	= 22,
						price		= 400,
						munPrice	= 20,
						munSize		= 17,
						canBuyMulti	= false,
						position	= {296.100, -41.799, 1002.200, 0, 0, 0},
						matrix		= {296.208, -40.449, 1002.392}
					},
					[8] = {
						title		= "Schallg. Pistole",--
						objectID	= 347,
						weaponID	= 23,
						price		= 450,
						munPrice	= 20,
						munSize		= 17,
						canBuyMulti	= false,
						position	= {296.200, -41.799, 1002.700, 0, 345, 0},
						matrix		= {296.314, -40.828, 1002.835}
					},
					[9] = {
						title		= "Desert Eagle",--
						objectID	= 348,
						weaponID	= 24,
						price		= 1200,
						munPrice	= 200,
						munSize		= 7,
						canBuyMulti	= false,
						position	= {296.899, -41.799, 1002.000, 0, 0, 0},
						matrix		= {297.037, -40.719, 1002.180}
					},
					[10] = {
						title		= "Uzi",--
						objectID	= 352,
						weaponID	= 28,
						price		= 400,
						munPrice	= 60,
						munSize		= 50,
						canBuyMulti	= false,
						position	= {295.200, -41.799, 1002.599, 0, 0, 0},
						matrix		= {295.178, -40.514, 1002.545}
					},
					[11] = {
						title		= "MP5",--
						objectID	= 353,
						weaponID	= 29,
						price		= 500,
						munPrice	= 100,
						munSize		= 30,
						canBuyMulti	= false,
						position	= {293.993, -41.799, 1002.550},
						matrix		= {293.831, -40.435, 1002.779}
					},
					[12] = {
						title		= "TEC-9",--
						objectID	= 372,
						weaponID	= 32,
						price		= 400,
						munPrice	= 60,
						munSize		= 50,
						canBuyMulti	= false,
						position	= {293.299, -41.799, 1002.200, 0, 0, 0},
						matrix		= {293.579, -40.395, 1002.475},
					},
					[13] = {
						title		= "Abges. Schrotflinte",--
						objectID	= 350,
						weaponID	= 26,
						price		= 350,
						munPrice	= 5,
						munSize		= 2,
						canBuyMulti	= false,
						position	= {297.100, -41.799, 1002.700, 0, 0, 0},
						matrix		= {297.037, -40.719, 1002.180}
					},
					[14] = {
						title		= "Schrotflinte",--
						objectID	= 349,
						weaponID	= 25,
						price		= 450,
						munPrice	= 50,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {294.450, -34.000, 1001.200, 0, 270, 0},
						matrix		= {293.040, -35.247, 1002.424}
					},
					[15] = {
						title		= "SPAS-12 Kampfflinte",--
						objectID	= 351,
						weaponID	= 27,
						price		= 1500,
						munPrice	= 100,
						munSize		= 7,
						canBuyMulti	= false,
						position	= {294.299, -41.799, 1002.000, 0, 0, 2},
						matrix		= {294.653, -40.175, 1002.225}
					},
					[16] = {
						title		= "Gewehr",--+
						objectID	= 357,
						weaponID	= 33,
						price		= 500,
						munPrice	= 5,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {289.700, -35.600, 1001.200, 0, 280, 4},
						matrix		= {288.327, -36.568, 1002.609}
					},
					[17] = {
						title		= "AK-47",--
						objectID	= 355,
						weaponID	= 30,
						price		= 1200,
						munPrice	= 150,
						munSize		= 30,
						canBuyMulti	= false,
						position	= {290.200, -34.100, 1001.300, 0, 270, 360},
						matrix		= {292.056, -35.437, 1002.425}
					},
					[18] = {
						title		= "M4",--
						objectID	= 356,
						weaponID	= 31,
						price		= 1500,
						munPrice	= 200,
						munSize		= 50,
						canBuyMulti	= false,
						position	= {295.000, -34.700, 1001.100, 0, 270, 0},
						matrix		= {296.563, -33.842, 1002.494}
					},
					
					
					
					
					[19] = {
						title		= "Fallschirm",--
						objectID	= 371,
						weaponID	= 46,
						price		= 100,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.300, -39.500, 1002.300, 0, 0, 270},
						matrix		= {298.825, -39.367, 1002.397}
					},
					[20] = {
						title		= "Schutzweste",--+
						objectID	= 1242,
						weaponID	= 50,
						price		= 150,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.200, -40.300, 1002.800, 335, 300, 0},
						matrix		= {298.321, -40.213, 1002.780}
					},
					[21] = {
						title		= "Nachtsichtgerät",--
						objectID	= 368,
						weaponID	= 44,
						price		= 275,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.200, -41.099, 1002.800, 270, 0, 0},
						matrix		= {299.184, -41.097, 1002.876}
					},
					[22] = {
						title		= "Infrarotsichtgerät",--
						objectID	= 369,
						weaponID	= 45,
						price		= 275,
						munPrice	= 0,
						munSize		= 1,
						canBuyMulti	= false,
						position	= {300.100, -40.799, 1002.400, 270, 0, 0},
						matrix		= {299.284, -40.730, 1002.535}
					},
					
					
				},
			},
			supermarket = {
				menues = {
					[1] = {
						title		= "Blumen",
						image		= "flowers.png",
						price		= 5,
						onlyOnce	= true,
						text		= "Ein rosa Blumenstrauß.",
					},
					[2] = {
						title		= "Bier",
						image		= "beer.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Gebraut nach dem Deutschem\nReinheitsgebot.",
					},
					[3] = {
						title		= "Sprunk",
						image		= "sprunk.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Das beste Erfrischungsgetränk.",
					},
					[4] = {
						title		= "Kaffee",
						image		= "coffee.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Eine heiße Tasse Kaffee.",
					},
					[5] = {
						title		= "Schokoriegel",
						image		= "schoko.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Für den kleinen Hunger \nzwischendurch.",
					},					
					[6] = {
						title		= "Wodka",
						image		= "wodka.png",
						price		= 10,
						onlyOnce	= false,
						text		= "Feinster Wodka aus\nRussland importiert.",
					},
					[7] = {
						title		= "Packung Zigaretten",
						image		= "cigarettes.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Eine Packung enthält 20 Zigaretten.",
					},
					[8] = {
						title		= "Kamera",
						image		= "camera.png",
						price		= 75,
						onlyOnce	= true,
						text		= "Ein Kamerafilm á 36 Aufnahmen ist\nbereits enthalten.",
					},
					[9] = {
						title		= "Kamerafilm",
						image		= "camerafilm.png",
						price		= 15,
						onlyOnce	= false,
						text		= "Mit einem Film kannst Du 36\nAufnahmen machen.",
					},
					[10] = {
						title		= "Verbandskasten",
						image		= "firstaid.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Mit dem Verbandskasten kannst Du\ndich heilen, wenn Du verletzt bist.",
					},
					[11] = {
						title		= "Würfel",
						image		= "dice.png",
						price		= 10,
						onlyOnce	= true,
						text		= "Nutzbar mit /dice",
					},
					[12] = {
						title		= "50 $ Prepaid-Guthaben",
						image		= "prepaidcredit.png",
						price		= 50,
						onlyOnce	= false,
						text		= "Prepaid-Guthaben für dein Handy.\nNicht nutzbar für Vertragskunden.",
					},
					[13] = {
						title		= "Rubbellos",
						image		= "scratchcard.png",
						price		= 10,
						onlyOnce	= true,
						text		= "Maximalgewinn: 100 $",
					},
				},
			},
			
			tankstelle = {
				menues = {
					[1] = {
						title		= "Packung Zigaretten",
						image		= "cigarettes.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Eine Packung enthält 20 Zigaretten.",
					},
					[2] = {
						title		= "Zeitung",
						image		= "news.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Immer auf dem aktuellen Stand.",
					},
					[3] = {
						title		= "Schokoriegel",
						image		= "schoko.png",
						price		= 5,
						onlyOnce	= true,
						text		= "Für den kleinen Hunger \nzwischendurch.",
					},
					[4] = {
						title		= "Dosenbier",
						image		= "beer.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Gebraut nach dem Deutschem\nReinheitsgebot.",
					},
					[5] = {
						title		= "Sprunk",
						image		= "sprunk.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Das beste Erfrischungsgetränk.",
					},
					[6] = {
						title		= "Kaffee",
						image		= "coffee.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Eine heiße Tasse Kaffee.",
					},		
					[7] = {
						title		= "Verbandskasten",
						image		= "firstaid.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Mit dem Verbandskasten kannst Du\ndich heilen, wenn Du verletzt bist.",
					},
					[8] = {
						title		= "Repait-Kit",
						image		= "toolbox.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Schneller als jeder\nMechaniker!",
					},
					[9] = {
						title		= "Motoröl",
						image		= "kanister.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Zum nachkippen bei\nBedarf.",
					},
					[10] = {
						title		= "Benzinkanister",
						image		= "kanister.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Falls der Sprit mal unterwegs\nausgehen sollte.",
					},
					[11] = {
						title		= "Dieselkanister",
						image		= "kanister.png",
						price		= 50,
						onlyOnce	= true,
						text		= "Falls der Sprit mal unterwegs\nausgehen sollte.",
					},
					[12] = {
						title		= "Rubbellos",
						image		= "scratchcard.png",
						price		= 10,
						onlyOnce	= true,
						text		= "Maximalgewinn: 100 $",
					},
				},
			},
			
			stripbar = {
				menues = {
					[1] = {
						title		= "Bier",
						image		= "beer.png",
						price		= 5,
						onlyOnce	= false,
						text		= "Gebraut nach dem Deutschem\nReinheitsgebot.",
					},
					[2] = {
						title		= "Wodka",
						image		= "wodka.png",
						price		= 10,
						onlyOnce	= false,
						text		= "Feinster Wodka aus\nRussland importiert.",
					},
				},
			},
		},
		
		animations = {
			[1] = {
				name		= "Sprechen",
				block		= "ped",
				anim		= "IDLE_chat",
				loop		= true,
				update		= true,
				int			= true,
			},
			[2] = {
				name		= "Lachen",
				block		= "rapping",
				anim		= "Laugh_01",
				loop		= true,
				update		= false,
				int			= true,
			},
			[3] = {
				name		= "Winken",
				block		= "ON_LOOKERS",
				anim		= "wave_loop",
				loop		= true,
				update		= true,
				int			= true,
			},
			[4] = {
				name		= "Grüßen",
				block		= "kissing",
				anim		= "gfwave2",
				loop		= true,
				update		= true,
				int			= true,
			},			
			[5] = {
				name		= "Verabschieden",
				block		= "kissing",
				anim		= "gfwave2",
				loop		= true,
				update		= true,
				int			= true,
			},			
			[6] = {
				name		= "Hinsetzen",
				block		= "beach",
				anim		= "ParkSit_M_loop",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[7] = {
				name		= "Hinsetzen chillen",
				block		= "beach",
				anim		= "SitnWait_loop_W",
				loop		= true,
				update		= false,
				int			= true,				
			},	
			[8] = {
				name		= "Hinlegen",
				block		= "beach",
				anim		= "bather",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[9] = {
				name		= "Müde/erschöpft",
				block		= "fat",
				anim		= "idle_tired",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[10] = {
				name		= "Arme verschränken",
				block		= "cop_ambient",
				anim		= "Coplook_loop",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[11] = {
				name		= "Strecken",
				block		= "playidles",
				anim		= "stretch",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[12] = {
				name		= "Waschen",
				block		= "bd_fire",
				anim		= "wash_up",
				loop		= true,
				update		= false,
				int			= true,				
			},			
			[13] = {
				name		= "Handstand",
				block		= "",
				anim		= "",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[14] = {
				name		= "Umsehen",
				block		= "bd_fire",
				anim		= "bd_panic_loop ",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[15] = {
				name		= "Denken",
				block		= "cop_ambient",
				anim		= "Coplook_think",
				loop		= true,
				update		= false,
				int			= true,				
			},			
			[16] = {
				name		= "Kratzen Kopf",
				block		= "misc",
				anim		= "plyr_shkhead",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[17] = {
				name		= "Kratzen Genitalbreich",
				block		= "misc",
				anim		= "Scratchballs_01",
				loop		= true,
				update		= false,
				int			= true,				
			},				
			[18] = {
				name		= "Ducken",
				block		= "ped",
				anim		= "cower",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[19] = {
				name		= "Wütend",
				block		= "riot",
				anim		= "riot_angry_b",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[20] = {
				name		= "Verärgert",
				block		= "riot",
				anim		= "riot_angry",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[21] = {
				name		= "Treten",
				block		= "police",
				anim		= "door_kick",
				loop		= true,
				update		= false,
				int			= true,				
			},			
			[22] = {
				name		= "Jubeln",
				block		= "riot",
				anim		= "riot_chant",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[23] = {
				name		= "Herkommen",
				block		= "police",
				anim		= "coptraf_come",
				loop		= false,
				update		= false,
				int			= true,		
			},
			[24] = {
				name		= "Weiter gehen",
				block		= "police",
				anim		= "coptraf_away",
				loop		= true,
				update		= false,
				int			= true,		
			},			
			[25] = {
				name		= "Anhalten",
				block		= "police",
				anim		= "coptraf_stop",
				loop		= false,
				update		= false,
				int			= true,		
			},
			[26] = {
				name		= "Lotsen",
				block		= "police",
				anim		= "coptraf_away",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[27] = {
				name		= "Etwas zeigen",
				block		= "on_lookers",
				anim		= "point_loop",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[28] = {
				name		= "Nach oben zeigen",
				block		= "on_lookers",
				anim		= "pointup_loop",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[29] = {
				name		= "Nach oben sehen",
				block		= "on_lookers",
				anim		= "lkup_loop",
				loop		= true,
				update		= false,
				int			= true,		
			},
			[30] = {
				name		= "Gewinnen",
				block		= "otb",
				anim		= "wtchrace_win",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[31] = {
				name		= "Verlieren",
				block		= "otb",
				anim		= "wtchrace_lose",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[32] = {
				name		= "Warten",
				block		= "ped",
				anim		= "woman_idlestance",
				loop		= true,
				update		= false,
				int			= true,		
			},					
			[33] = {
				name		= "Hände hoch",
				block		= "shop",
				anim		= "SHP_HandsUp_Scr",
				loop		= false,
				update		= true,
				int			= true,				
			},
		
			[34] = {
				name		= "Tai Chi",
				block		= "park",
				anim		= "Tai_Chi_Loop",
				loop		= true,
				update		= true,
				int			= true,				
			},
			[35] = {
				name		= "Rauchen",
				block		= "bd_fire",
				anim		= "m_smklean_loop",
				loop		= true,
				update		= false,
				int			= true,
			},			
			[36] = {
				name		= "Rappen",
				block		= "rapping",
				anim		= "rap_c_loop",
				loop		= true,
				update		= true,
				int			= true,		
			},
			[37] = {
				name		= "Tanzen orientalisch",
				block		= "DANCING",
				anim		= "dnce_M_a",
				loop		= true,
				update		= false,
				int			= false,		
			},
			[38] = {
				name		= "Tanzen chillig",
				block		= "DANCING",
				anim		= "dnce_M_b",
				loop		= true,
				update		= false,
				int			= false,		
			},
			[39] = {
				name		= "Tanzen rhythmisch",
				block		= "DANCING",
				anim		= "dnce_M_d",
				loop		= true,
				update		= false,
				int			= false,
			},
			[40] = {
				name		= "Tanzen wild",
				block		= "DANCING",
				anim		= "dnce_M_e",
				loop		= true,
				update		= false,
				int			= false,
			},
			[41] = {
				name		= "Tanzen HipHop",
				block		= "DANCING",
				anim		= "dance_loop",
				loop		= true,
				update		= false,
				int			= false,
			},
			[42] = {
				name		= "Tanzen sexy",
				block		= "STRIP",
				anim		= "STR_Loop_A",
				loop		= true,
				update		= false,
				int			= false,
			},
			[43] = {
				name		= "Tanzen nuttig",
				block		= "STRIP",
				anim		= "STR_Loop_B",
				loop		= true,
				update		= false,
				int			= false,
			},
			[44] = {
				name		= "Tanzen strip 1",
				block		= "STRIP",
				anim		= "STR_Loop_C",
				loop		= true,
				update		= false,
				int			= false,
			},
			[45] = {
				name		= "Tanzen strip 2",
				block		= "STRIP",
				anim		= "strip_d",
				loop		= true,
				update		= false,
				int			= false,
			},				
			[46] = {
				name		= "Bombe platzieren",
				block		= "bomber",
				anim		= "BOM_Plant_Loop",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[47] = {
				name		= "Geld abheben",
				block		= "ped",
				anim		= "atm",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[48] = {
				name		= "Übergabe",
				block		= "dealer",
				anim		= "dealer_deal",
				loop		= true,
				update		= true,
				int			= true,
			},
			[49] = {
				name		= "Bezahlen",
				block		= "dealer",
				anim		= "shop_pay",
				loop		= true,
				update		= true,
				int			= true,				
			},
			[50] = {
				name		= "Kaugummi",
				block		= "ped",
				anim		= "gum_eat",
				loop		= false,
				update		= true,
				int			= true,				
			},			
			[51] = {
				name		= "Waffe beidhändig",
				block		= "ped",
				anim		= "ARRESTgun",
				loop		= false,
				update		= false,
				int			= true,				
			},
			[52] = {
				name		= "Fuck you",
				block		= "ped",
				anim		= "fucku",
				loop		= true,
				update		= true,
				int			= true,
			},
			[53] = {
				name		= "Robman",
				block		= "shop",
				anim		= "ROB_Loop_Threat",
				loop		= true,
				update		= false,
				int			= true,
			},
			[54] = {
				name		= "Küssen Mann",
				block		= "bd_fire",
				anim		= "playa_kiss_03",
				loop		= false,
				update		= false,
				int			= true,
			},
			[55] = {
				name		= "Küssen Frau",
				block		= "bd_fire",
				anim		= "grlfrd_kiss_03",
				loop		= false,
				update		= false,
				int			= true,
			},
			[56] = {
				name		= "Verabschieden verliebt",
				block		= "kissing",
				anim		= "bd_gf_wave",
				loop		= false,
				update		= false,
				int			= true,
			},
			[57] = {
				name		= "Bitch Slap",
				block		= "misc",
				anim		= "bitchslap",
				loop		= true,
				update		= false,
				int			= true,
			},
			[58] = {
				name		= "Ass Slap",
				block		= "sweet",
				anim		= "sweet_ass_slap",
				loop		= true,
				update		= false,
				int			= true,
			},
			[59] = {
				name		= "Sex oben",
				block		= "sex",
				anim		= "sex_1_cum_p",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[60] = {
				name		= "Sex unten",
				block		= "sex",
				anim		= "sex_1_cum_w",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[61] = {
				name		= "Pinkeln",
				block		= "PAULNMAC",
				anim		= "Piss_in",
				loop		= true,
				update		= false,
				int			= false,				
			},
			[62] = {
				name		= "Sterben",
				block		= "knife",
				anim		= "kill_knife_ped_die",
				loop		= false,
				update		= true,
				int			= true,
			},			
			[63] = {
				name		= "Betrunken",
				block		= "ped",
				anim		= "WALK_drunk",
				loop		= true,
				update		= true,
				int			= true,
			},
			[64] = {
				name		= "Kotzen",
				block		= "food",
				anim		= "EAT_Vomit_P",
				loop		= true,
				update		= false,
				int			= true,
			},
			[65] = {
				name		= "Masturbieren",
				block		= "PAULNMAC",
				anim		= "wank_loop",
				loop		= true,
				update		= false,
				int			= true,				
			},
			[66] = {
				name		= "Crack",
				block		= "crack",
				anim		= "crckdeth2",
				loop		= true,
				update		= true,
				int			= true,				
			},			
		},
		
	},
}