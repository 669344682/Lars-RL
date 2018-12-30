--[[
FREIE IDS:
ID aus der liste nehmen, wenn übermoddet!

-- liberty




Schatten, Reifenspurfen etc.:
14528
14761
15043
15044
15045
15047
15049
15051
15056
15057
15060
15061
15062
10765
11099
11280
11384
11385
18071
18073
18076
18085
19898
13009
11663

-- Stromleitungen
18215
18448



-- Sonstige unused scheiße welche übermoddet werden kann
1772
2070
2077
2107
2113
2402
911
913
914
915
916
917
919
921
952
1207
1208
1547
1548
1554
1574
1581
1610
1611
1618
1665
1681
1683
1773
1774
1777
1779
1780
2711
2709
2713
2742
2750
2751
3027
3028
3045


-- wird zwar genutzt, aber könnte trzdem übermoddet werdn
920
960
961
977
]]

local x = 1
function loadMod(id, txd, dff, col, dontRemove)
	setTimer(function()
		local function load(_id, _txd, _dff, _col, _dontRemove)
			if (txd) then
				_txd = engineLoadTXD(_txd)
				engineImportTXD(_txd, _id)
			end
			if (_dff) then
				_dff = engineLoadDFF(_dff)
				engineRestoreModel(_id)
				engineReplaceModel(_dff, _id)
			end
			if (_col) then
				_col = engineLoadCOL(_col)
				engineRestoreCOL(_id)
				engineReplaceCOL(_col, _id)
			end
			
			if (_dontRemove ~= true) then
				for i = 0, 18 do
					removeWorldModel(_id, 99999, 0, 0, 0, i)
				end
			end
		end
		
		if (type(id) == "table") then
			for _, _id in pairs(id) do
				load(_id, txd, dff, col, dontRemove)
			end
		else
			load(id, txd, dff, col, dontRemove)
		end
	end, x*50, 1)
	
	x = x + 1
end

setTimer(function()
	-- removt waffen an wand hinter theke
	loadMod({--[[18033,--]] 18034, 18041, 18044, 18045, 18104, 18105, 18109}, "files/textures/ammunation_wallfix.txd")
	
	-- Bushaltestellen
	loadMod(1257, "files/textures/bustopm.txd", nil, nil, true)
	
	-- Skykea
	loadMod(6063, "files/textures/skykea.txd", nil, nil, true)
	
	-- Supermarkt Texturen
	loadMod({2538, 1983}, "files/textures/supermarket_1.txd", nil, nil, true)
	loadMod({2538, 1983}, "files/textures/supermarket_2.txd", nil, nil, true)
	loadMod(2871, "files/textures/supermarket_3.txd", nil, nil, true)
	loadMod(2430, "files/textures/burg_1.txd", nil, nil, true)
	loadMod(12961, "files/textures/cemetery.txd", nil, nil, true)

	-- Tunnel
	loadMod(4551, nil, "files/textures/bank_tunnel.dff", "files/textures/bank_tunnel.col")
	loadMod(3893, "files/textures/samp/Tube50mTSection1.txd", "files/textures/samp/Tube50mTSection1.dff", "files/textures/samp/Tube50mTSection1.col")
	
	-- Zigarette / Automat
	loadMod(3044, "files/textures/cigarette.txd", "files/textures/cigarette.dff", nil, false)
	loadMod(18214, "files/textures/CigaretteMachine.txd", "files/textures/CigaretteMachine.dff", "files/textures/CigaretteMachine.col", false)
	
	-- ## Straße buggt dadurch neben Kirche
	loadMod(5414, "files/textures/jeffers5a_lae.txd", nil, "files/textures/laeJeffers02.col", true) -- Coutt and Schutz
	-- ## Straße buggt dadurch neben Kirche
	
	loadMod(6337, "files/textures/sunset02_law2.txd", nil, nil, true) -- Boden bei grotti
	
	loadMod(7245, nil, nil, "files/textures/vegasNbank1ug.col", true) -- Stadtpark Garage fix
	
	-- Schwimmbad + Brücke
	loadMod(5390, "files/textures/glenpark7_lae.txd", nil, nil, true) 
	loadMod(3891, "files/textures/RopeBridge.txd", "files/textures/RopeBridgePart1.dff", "files/textures/RopeBridgePart1.col") 
	loadMod(3892, "files/textures/RopeBridge.txd", "files/textures/RopeBridgePart2.dff", "files/textures/RopeBridgePart2.col") 
	
	-- Mall
	loadMod(6130, "files/textures/mallb_laW02.txd", "files/textures/mallb_laW02.dff", "files/textures/mallb_laW02.col", true)
	loadMod(2957, "files/textures/lsmall_shop01.txd", "files/textures/lsmall_shop01.dff", "files/textures/lsmall_shop01.col", true)
	loadMod(3946, "files/textures/libertyhi.txd", "files/textures/snowover01.dff", nil, true)
	
	
	-- SAMP MODS
	loadMod(3964, "files/textures/samp/all_walls.txd", "files/textures/samp/gym_floor5.dff", "files/textures/samp/gym_floor5.col")
	loadMod(3529, "files/textures/vgsncircon.txd", nil, nil, true)
	
	loadMod(1339, "files/textures/samp/all_walls.txd", "files/textures/samp/wall003.dff", "files/textures/samp/wall003.col")
	loadMod(3899, "files/textures/samp/all_walls.txd", "files/textures/samp/wall002.dff", "files/textures/samp/wall002.col")
	loadMod(3900, "files/textures/samp/all_walls.txd", "files/textures/samp/wall001.dff", "files/textures/samp/wall001.col")
	loadMod(3895, "files/textures/samp/all_walls.txd", "files/textures/samp/wall006.dff", "files/textures/samp/wall006.col")
	loadMod(3901, "files/textures/samp/all_walls.txd", "files/textures/samp/wall009.dff", "files/textures/samp/wall009.col")
	loadMod(1777, "files/textures/samp/all_walls.txd", "files/textures/samp/wall010.dff", "files/textures/samp/wall010.col")
	loadMod(3911, "files/textures/samp/all_walls.txd", "files/textures/samp/wall012.dff", "files/textures/samp/wall012.col")
	loadMod(3921, "files/textures/samp/all_walls.txd", "files/textures/samp/wall023.dff", "files/textures/samp/wall023.col")
	loadMod(2757, "files/textures/samp/all_walls.txd", "files/textures/samp/wall025.dff", "files/textures/samp/wall025.col")--CHANGE!
	loadMod(3965, "files/textures/samp/wall025ori.txd", "files/textures/samp/wall025.dff", "files/textures/samp/wall025.col")--CHANGE!
	loadMod(1773, "files/textures/samp/all_walls.txd", "files/textures/samp/wall033.dff", "files/textures/samp/wall033.col")
	loadMod(3906, "files/textures/samp/all_walls.txd", "files/textures/samp/wall035.dff", "files/textures/samp/wall035.col")
	loadMod(1733, "files/textures/samp/all_walls.txd", "files/textures/samp/wall039.dff", "files/textures/samp/wall039.col")
	loadMod(3902, "files/textures/samp/all_walls.txd", "files/textures/samp/wall041.dff", "files/textures/samp/wall041.col")
	loadMod(2761, "files/textures/samp/all_walls.txd", "files/textures/samp/wall068.dff", "files/textures/samp/wall068.col")--CHANGE!
	loadMod(2759, "files/textures/samp/all_walls.txd", "files/textures/samp/wall075.dff", "files/textures/samp/wall075.col")--CHANGE!
	loadMod(1965, "files/textures/samp/all_walls.txd", "files/textures/samp/wall087.dff", "files/textures/samp/wall087.col")
	loadMod(3962, "files/textures/samp/all_walls.txd", "files/textures/samp/wall103.dff", "files/textures/samp/wall103.col")
	loadMod(3966, "files/textures/samp/all_walls.txd", "files/textures/samp/grass.dff", "files/textures/samp/grass.col")
	loadMod(9560, "files/textures/samp/cs_ebridge.txd", "files/textures/samp/Plane62_5x15Conc1.dff", "files/textures/samp/Plane62_5x15Conc1.col")
	loadMod(9562, "files/textures/samp/beach_sfs.txd", "files/textures/samp/Plane62_5x15Grass1.dff", "files/textures/samp/Plane62_5x15Grass1.col")
	
	loadMod(3890, "files/textures/samp/SpeedCamera1.txd", "files/textures/samp/SpeedCamera1.dff", "files/textures/samp/SpeedCamera1.col")
	
	
	
	
	
	
	
	-- GTA 5 BANK
	loadMod(3963, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/bank.dff", "files/textures/gta5/bank/bank.col")
	loadMod(3961, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankb_counter1.dff", "files/textures/gta5/bank/hei_obankb_counter1.col")
	loadMod(3948, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbbalistrade1.dff", "files/textures/gta5/bank/hei_obankbbalistrade1.col")
	loadMod(3945, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbbalistrade2.dff", "files/textures/gta5/bank/hei_obankbbalistrade2.col")
	loadMod(3944, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbbanister03.dff", "files/textures/gta5/bank/hei_obankbbanister03.col")
	loadMod(3943, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbbanister1.dff", "files/textures/gta5/bank/hei_obankbbanister1.col")
	loadMod(3942, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbfurniture.dff", "files/textures/gta5/bank/hei_obankbfurniture.col")
	loadMod(3923, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankborntelamp2.dff", "files/textures/gta5/bank/hei_obankborntelamp2.col")
	loadMod(3922, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankborntelamp3.dff", "files/textures/gta5/bank/hei_obankborntelamp3.col")
	loadMod(3919, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankborntelamp4.dff", "files/textures/gta5/bank/hei_obankborntelamp4.col")
	loadMod(3918, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbsafeframe.dff", "files/textures/gta5/bank/hei_obankbsafeframe.col")
	loadMod(3917, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbstairs2.dff", "files/textures/gta5/bank/hei_obankbstairs2.col")
	loadMod(3916, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankb_arch.dff", "files/textures/gta5/bank/hei_obankb_arch.col")
	loadMod(3915, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankb_atm1.dff", "files/textures/gta5/bank/hei_obankb_atm1.col")
	loadMod(3914, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankb_cornice1.dff", "files/textures/gta5/bank/hei_obankb_cornice1.col")
	loadMod(3907, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbsecurity.dff", "files/textures/gta5/bank/hei_obankbsecurity.col")
	loadMod(3910, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbsafebars.dff", "files/textures/gta5/bank/hei_obankbsafebars.col")
	loadMod(3905, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/hei_obankbankarches.dff", "files/textures/gta5/bank/hei_obankbankarches.col")
	loadMod(3903, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/prop_atm_02.dff", "files/textures/gta5/bank/prop_atm_02.col")
	loadMod(3898, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/v_ilev_bk_vaultdoor.dff", "files/textures/gta5/bank/v_ilev_bk_vaultdoor.col")
	loadMod(3897, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/prop_v_5_bclock.dff", "files/textures/gta5/bank/prop_v_5_bclock.col")
	loadMod(3894, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/prop_ld_balastrude.dff", "files/textures/gta5/bank/prop_ld_balastrude.col")
	
	
	--loadMod(3920, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/apa_prop_hei_bankdoor_new.dff", "files/textures/gta5/bank/apa_prop_hei_bankdoor_new.col") -- Im auge behalten, evtl. für crashes verantwortlich
	
	
	loadMod(3924, "files/textures/gta5/bank/bank.txd", "files/textures/gta5/bank/v_ilev_bk_gate2.dff", "files/textures/gta5/bank/v_ilev_bk_gate2.col")
	
	
	-- Tankstelle
	loadMod({11417,9192,9193,9899,7390,7391}, "files/textures/tankstelle.txd")
	loadMod(1676, "files/textures/wshxrefpump.txd")
	
	
	
	-- Gabelstapler
	loadMod(5131, nil, "files/textures/imrancomp1_las2.dff", "files/textures/imrancomp1_las2.col", true)
	loadMod(5129, nil, "files/textures/imracompint_las2.dff", "files/textures/imracompint_las2.col", true)
	loadMod(5127, nil, "files/textures/imcomp1trk.dff", "files/textures/imcomp1trk.col", true)
	
	x=1
	-- alles mit "CHANGE!" braucht andere IDs!
end, 2500, 1)