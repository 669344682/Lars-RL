----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

statementPath = ":"..getResourceName(getThisResource()).."/userfiles/bank.json"

local function renderIt(oX, oY)
	dxDrawRectangle(oX+10, oY+10, 155.5, 30, tocolor(45, 45, 45))
	dxDrawText("Ein- / Auszahlen", oX+10, oY+10, oX+10+155.5, oY+10+30, tocolor(255, 255, 255), 1.2, "defualt-bold", "center", "center")
	dxDrawLine(oX+10, oY+39, oX+10+155.5, oY+39, tocolor(getColorFromString("#104e8b")), 2)
	
	dxDrawRectangle(oX+170.5, oY+10, 155.5, 30, tocolor(45, 45, 45))
	dxDrawText("Überweisung", oX+170.5, oY+10, oX+10+170.5+155.5, oY+10+30, tocolor(255, 255, 255), 1.2, "defualt-bold", "center", "center")
	
	dxDrawRectangle(oX+332.5, oY+10, 155.5, 30, tocolor(45, 45, 45))
	dxDrawText("Kontoauszug", oX+332.5, oY+10, oX+10+332.5+155.5, oY+10+30, tocolor(255, 255, 255), 1.2, "defualt-bold", "center", "center")
end

function bankWindow()
		
	local tabBg, btnInOut, btnTransfer, btnStatement = nil, nil, nil, nil
	local tabElements = {}
	local curTab = 0
	
	local window		= dxWindow:new("Bank of Lars-RL", nil, nil, 500, 445, nil, nil, nil, nil, nil, nil, nil, nil)
	
	local function inOut(bool)
		local sum = tonumber(tabElements['ed1']:getText())
		if (sum ~= nil and sum > 0) then
			triggerServerEvent("bankPayInOut", localPlayer, bool, tonumber(sum))
		else
			notificationShow("error", "Bitte gib eine gültige Summe ein.")
		end
	end
	
	local function transfer()
		local sum = tonumber(tabElements['ed2']:getText())
		if (sum ~= nil and sum > 0) then
			local recv = tabElements['ed1']:getText()
			if (string.len(recv) >= 3) then
				local reason = tabElements['ed3']:getText()
				if (string.len(reason) >= 3) then
					triggerServerEvent("bankTransfer", localPlayer, tonumber(sum), recv, reason)
				else
					notificationShow("error", "Du musst einen Verwendungszweck angeben.")
				end
			else
				notificationShow("error", "Du musst einen Empfänger angeben.")
			end
		else
			notificationShow("error", "Bitte gib eine gültige Summe ein.")
		end
	end
	
	local function changeTab(what)
		if (curTab == what) then return end
		for k,v in pairs(tabElements) do
			v:delete()
			tabElements[k] = nil
		end
		btnInOut:setImage("/files/images/dxgui/tab.png")
		btnTransfer:setImage("/files/images/dxgui/tab.png")
		btnStatement:setImage("/files/images/dxgui/tab.png")
		
		if (what == 1) then
			btnInOut:setImage("/files/images/dxgui/tab-hover.png")
			tabElements['img']	= dxImage:new(10, 43, 475, 200, "/files/images/atm/banner.png", window)
			tabElements['img2']	= dxImage:new(8, 40, 183, 73, "/files/images/atm/banklogo.png", window)
			tabElements['txt1']	= dxText:new(125, 263, 250, 15, "Summe:", window, "left", 1, 'exo-bold-10', nil, false)
			tabElements['ed1']	= dxEdit:new(125, 283, 250, 40, window)
			tabElements['btn1']	= dxButton:new(125, 331, 120, 40, "Auszahlen", window, function() inOut(true) end, nil, nil, 1)
			tabElements['btn2']	= dxButton:new(255, 331, 120, 40, "Einzahlen", window, function() inOut(false) end, nil, nil, 1)
			
		elseif (what == 2) then
			btnTransfer:setImage("/files/images/dxgui/tab-hover.png")
			tabElements['img']	= dxImage:new(10, 43, 475, 200, "/files/images/atm/auszug.png", window)
			tabElements['img2']	= dxImage:new(8, 40, 183, 73, "/files/images/atm/banklogo.png", window)
			
			tabElements['tx1']	= dxText:new(20, 249, 225, 15, "Empfänger:", window, "left", 1, 'exo-bold-10', nil, false)
			tabElements['ed1']	= dxEdit:new(20, 269, 225, 40, window)
			
			tabElements['tx2']	= dxText:new(255, 249, 225, 15, "Summe:", window, "left", 1, 'exo-bold-10', nil, false)
			tabElements['ed2']	= dxEdit:new(255, 269, 225, 40, window)
			
			tabElements['tx3']	= dxText:new(20, 314, 337.5, 15, "Verwendungszweck:", window, "left", 1, 'exo-bold-10', nil, false)
			tabElements['ed3']	= dxEdit:new(20, 334, 337.5, 40, window)
			tabElements['btn']	= dxButton:new(367.5, 334, 112.5, 40, "Überweisen", window, function() transfer() end, nil, nil, 1)
			
		elseif (what == 3) then
			btnStatement:setImage("/files/images/dxgui/tab-hover.png")
			
			tabElements['dxg']	= dxGrid:new(10, 43, 477, 315, window, nil)
			tabElements['dxg']:addColumn({{"Datum",16}, {"Verwendungszweck",67.5}, {"Betrag",16.5}})
			
			local time = getRealTime()
			local json = fromJSON(fileGetContents(statementPath))
			if (type(json) == "table") then
				for i, arr in ipairs(json) do
					local sum = setDotsInNumber(arr['val']).." +"
					if (tonumber(arr['val']) < 0) then
						sum = setDotsInNumber((tonumber(arr['val'])*-1)).." -"
					end
					
					
					local dmy = time.monthday.."."..(time.month+1).."."..(time.year+1900)
					if (arr['date'] == dmy) then
						local tm = getRealTime(arr['time'])
						arr['date'] = string.format("%02d:%02d:%02d", tm.hour, tm.minute, tm.second)
					end
					tabElements['dxg']:addItem({arr['date'], arr['reason'], sum})
				end
				
			end
			
			tabElements['btm1']	= dxText:new(15, 366, 50, 15, "Kontostand in USD am "..time.monthday.."."..(time.month+1)..", "..time.hour..":"..time.minute.." Uhr", window, "left", 1, 'exo-bold-10', nil, false)
			
			
			local money = setDotsInNumber(getPlayerBankMoney()).." +"
			if (getPlayerBankMoney() < 0) then
				money = setDotsInNumber((getPlayerBankMoney()*-1)).." -"
			end
			tabElements['btm2']	= dxText:new(395, 366, 86, 15, money, window, "right", 1, 'exo-bold-10', nil, false)
		end
		curTab = what
	end
	
	btnInOut			= dxImage:new(10, 9, 156.666667, 30, "/files/images/dxgui/tab-hover.png", window, nil, function() changeTab(1); end)
	local txtInOut		= dxText:new(10, 14.5, 156.666667, 15, "Ein- / Auszahlen", window, "center", 1, 'exo-bold-10', nil, false)
	btnTransfer			= dxImage:new(171.666667, 9, 156.666667, 30, "/files/images/dxgui/tab.png", window, nil, function() changeTab(2); end)
	local txtTransfer	= dxText:new(171.666667, 14.5, 156.666667, 15, "Überweisung", window, "center", 1, 'exo-bold-10', nil, false)
	btnStatement		= dxImage:new(333.333334, 9, 156.666667, 30, "/files/images/dxgui/tab.png", window, nil, function() changeTab(3); end)
	local txtStatement	= dxText:new(333.333334, 14.5, 156.666667, 15, "Kontoauszug", window, "center", 1, 'exo-bold-10', nil, false)
	
	local tabBg			= dxImage:new(10, 37, 480, 350, "/files/images/dxgui/tabbg.png", window, {255, 255, 255, 180})
	
	
	changeTab(1)
end
addCommandHandler("bank", bankWindow)
addEvent("showBank", true)
addEventHandler("showBank", root, bankWindow)




addEvent("bankStatement", true)
addEventHandler("bankStatement", root, function(sum, reas)
	local data = false
	if (fileExists(statementPath)) then
		local json = fromJSON(fileGetContents(statementPath))
		if (type(json) == "table") then
			data = json
		end
	else
		data = {}
	end
	
	
	local time	= getRealTime()
	local dmy = string.format("%02d.%02d.%02d", time.monthday, (time.month+1), (time.year-100))
	table.insert(data, 1, {["time"]=time.timestamp,["date"]=dmy,["reason"]=reas,["val"]=sum})
	
	if (#data > 100) then
		table.remove(data, #data)
	end
	
	local json = toJSON(data)
	filePutContents(statementPath, json)
end)

-- GTA 5 Interior bei Nacht nicht beleuchtet, selbst Bollardlights gehen im Interior nicht
addEvent("gta5BankTimeFix", true)
addEventHandler("gta5BankTimeFix", root, function(bool)
	if (bool) then
		setTime(8, 0)
	else
		setTime(getRealTime().hour, getRealTime().minute)
	end
end)