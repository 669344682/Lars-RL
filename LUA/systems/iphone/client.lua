----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

t=getRealTime()
fuckFile = t.monthday.."_"..(t.month+1).."_"..(t.hour+1).."_"..t.minute..".log"
fuckFile = fileCreate(fuckFile)
function fuckDebug(str)
	local c = ""
	local r = fileRead(fuckFile, fileGetSize(fuckFile))
	if (r) then c = r end
	
	t=getRealTime()
	str = "["..t.monthday.."."..(t.month+1)..", "..(t.hour+1)..":"..t.minute..":"..t.second.." ("..getTickCount()..")]: "..str
	fileWrite(fuckFile, c..str.."\r\n")
	fileFlush(fuckFile)
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function()
	fileClose(fuckFile)
end)


local function getScaleFromResolution()
	local scale = 1
	local sX, sY = guiGetScreenSize()
	if (sY > 1000) then
		scale = 1
	elseif (sY > 900) then
		scale = 1.1
	elseif (sY > 700) then
		scale = 1.2
	else
		scale = 1.3
	end
	return scale
end
local scale = getScaleFromResolution()


local API_AUTH		= ""
local cursorOverCEF	= false
local iPhoneOpen	= false
local SETTINGS		= false
local sX, sY		= guiGetScreenSize()
local xs, ys		= sX/1920, sY/1080
local hW, hH		= 281.117/scale, 500/scale
local hX, hY		= (sX/2)-(hW/2), (sY/2)-(hH/2)

local iW, iH		= 323.32657/scale,658.41784/scale
local iX, iY		= (sX/2)-(iW/2), (sY/2)-(iH/2)

local localBrowser	= createBrowser(281.117, 500, true, false)
local wwwBrowser	= createBrowser(281.117, 500, false, false)
setBrowserProperty(wwwBrowser, 'mobile', 1)
local mp3Browser	= createBrowser(281.117, 500, false, true)
setBrowserProperty(mp3Browser, 'mobile', 1)
setBrowserVolume(mp3Browser, 0.8)
setElementData(mp3Browser, "mp3Browser", true)

addEventHandler("onClientBrowserWhitelistChange", root, function()
	outputChatBox("@onClientBrowserWhitelistChange type:"..tostring(getElementType(source)))
end)
addEventHandler("onClientBrowserNavigate", mp3Browser, function(url, blocked, mainFrame)
	if (string.find(url, 'clientNotification')) then
		local notify = urldecode(gettok(url, 2, string.byte('=')))
		local notifyText = urldecode(gettok(notify, 1, string.byte('|')))
		local notifyImg = urldecode(gettok(notify, 2, string.byte('|')))
		if (not iPhoneOpen) then
			infoShow("info", "[Musik] "..notifyText)
		elseif (iPhoneOpen and mp3BrowserOpen ~= true) then
			executeBrowserJavascript(localBrowser, "myApp.addNotification({title: 'Musik',message: '"..notifyText.."',hold: 4000,closeOnClick: true,closeIcon:true,audio:false,image:lastImage,media:'<img width=\"44\" height=\"44\" src=\""..notifyImg.."\">',onClose:(function() {AJAXcall({action:'musicext'});}),eventStr: \"AJAXcall({action:'musicext'});\"});")
		end
	end
end)

local mp3BrowserOpen	= false
local curBrowser	= localBrowser

local iPhoneHome	= guiCreateButton((iX+(iW/2))-26/scale, (iY+iH)-67/scale, 50/scale, 50/scale, "HOME", false)
guiSetVisible(iPhoneHome, false)
guiSetAlpha(iPhoneHome, 0)
local iPhonePower	= guiCreateButton((iX+iW)-10/scale, iY+137/scale, 25/scale, 50/scale, "POWER", false)
guiSetVisible(iPhonePower, false)
guiSetAlpha(iPhonePower, 0)
local iPhoneMute	= guiCreateButton(iX-10/scale, iY+80/scale, 25/scale, 50/scale, "MUTE", false)
guiSetVisible(iPhoneMute, false)
guiSetAlpha(iPhoneMute, 0)
local iPhoneVolUp	= guiCreateButton(iX-10/scale, iY+140/scale, 25/scale, 50/scale, "+", false)
guiSetVisible(iPhoneVolUp, false)
guiSetAlpha(iPhoneVolUp, 0)
local iPhoneVolDown	= guiCreateButton(iX-10/scale, iY+200/scale, 25/scale, 50/scale, "-", false)
guiSetVisible(iPhoneVolDown, false)
guiSetAlpha(iPhoneVolDown, 0)

function webBrowserRender()
	if (iPhoneOpen) then
		
		local cX, cY, _, _, _	= getCursorPosition()
		cX, cY					= cX*sX, cY*sY
		if ((cX >= hX and cX <= (hX+hW)) and (cY >= hY and cY <= (hY+hH))) then
			cursorOverCEF = true
			if (mp3BrowserOpen) then
				injectBrowserMouseMove(mp3Browser, (cX-hX)*scale, (cY-hY)*scale)
			else
				injectBrowserMouseMove(curBrowser, (cX-hX)*scale, (cY-hY)*scale)
			end
		else
			cursorOverCEF = false
		end
		
				
		if (mp3BrowserOpen) then
			focusBrowser(mp3Browser)
		else
			focusBrowser(curBrowser)
		end
		dxDrawImage(iX, iY, iW, iH, "files/html/iphone/images/6s_"..SETTINGS['color']..".png", 0, 0, 0, tocolor(255,255,255,255), false)
		dxDrawImage(hX, hY, hW, hH, curBrowser, 0, 0, 0, tocolor(255,255,255,255), false)
		
		if (mp3BrowserOpen) then
			dxDrawImage(hX, hY, hW, hH, mp3Browser, 0, 0, 0, tocolor(255,255,255,255), false)
		end
		
	end
end

--addCommandHandler("iphone", function()
function toggleIphone()
	if (SETTINGS ~= false) then
		windowOpen = not iPhoneOpen
		iPhoneOpen = not iPhoneOpen
		fuckDebug("IPHONE_OPEN="..tostring(iPhoneOpen))
		executeBrowserJavascript(localBrowser, "IPHONE_OPEN = "..tostring(iPhoneOpen)..";")
		guiSetInputEnabled(iPhoneOpen)
		showCursor(iPhoneOpen)
		guiSetVisible(iPhoneHome, iPhoneOpen)
		guiSetVisible(iPhonePower, iPhoneOpen)
		guiSetVisible(iPhoneMute, iPhoneOpen)
		guiSetVisible(iPhoneVolUp, iPhoneOpen)
		guiSetVisible(iPhoneVolDown, iPhoneOpen)
	end
end
addEvent("toggleIphone", true)
addEventHandler("toggleIphone", root, toggleIphone)



-- BUTTONS
addEventHandler("onClientGUIClick", iPhoneHome, function(btn, state)
	if (btn == "left" and state == "up") then
		if (curBrowser == wwwBrowser) then
			loadBrowserURL(wwwBrowser, "https://google.com/ncr")
			curBrowser = localBrowser
		end
		if (mp3BrowserOpen) then
			mp3BrowserOpen = false
		end
		executeBrowserJavascript(localBrowser, 'pressHome();')
	end
end)
addEventHandler("onClientGUIClick", iPhonePower, function(btn, state)
	if (btn == "left" and state == "up") then
		---executeCommandHandler("iphone")
		toggleIphone()
	end
end)
addEventHandler("onClientGUIClick", iPhoneMute, function(btn, state)
	if (btn == "left" and state == "up") then
		--executeBrowserJavascript(localBrowser, 'TODO();')
		outputChatBox("MUTE")
	end
end)
addEventHandler("onClientGUIClick", iPhoneVolUp, function(btn, state)
	if (btn == "left" and state == "up") then
		executeBrowserJavascript(localBrowser, "setVolume('+');")
		setBrowserVolume(mp3Browser, getBrowserVolume(mp3Browser)+0.1)
		outputChatBox(getBrowserVolume(mp3Browser))
	end
end)
addEventHandler("onClientGUIClick", iPhoneVolDown, function(btn, state)
	if (btn == "left" and state == "up") then
		executeBrowserJavascript(localBrowser, "setVolume('-');")
		setBrowserVolume(mp3Browser, getBrowserVolume(mp3Browser)-0.1)
		outputChatBox(getBrowserVolume(mp3Browser))
	end
end)

-- CLICK HANDLER
addEventHandler("onClientClick", root, function(button, state)
	if (cursorOverCEF == true) then
		local browser = curBrowser
		if (mp3BrowserOpen) then
			browser = mp3Browser
		end
		if (state == "down") then
			injectBrowserMouseDown(browser, button)
		else
			injectBrowserMouseUp(browser, button)
		end
	end
end)
addEventHandler("onClientKey", root, function(button)
	if (cursorOverCEF == true) then
		local browser = curBrowser
		if (mp3BrowserOpen) then
			browser = mp3Browser
		end
		if (button == "mouse_wheel_down") then
			injectBrowserMouseWheel(browser, -40, 0)
		elseif (button == "mouse_wheel_up") then
			injectBrowserMouseWheel(browser, 40, 0)
		else
			--executeBrowserJavascript(browser, 'pressKey();')
		end
	end
end)




-- SETTINGS
local function saveSettings()
	fuckDebug("@saveSettings()")
	triggerServerEvent("iPhoneUpdateSettings", localPlayer, SETTINGS)
end
addEventHandler("onClientResourceStop", root, function(stoppedRes)
	if (stoppedRes == getThisResource()) then
		--saveSettings()-- to late
	end
end)

local initialized = false
local function iPhoneReceiveSettings(data, apiToken)
	SETTINGS = data
	API_AUTH = apiToken
	
	if (not initialized) then
		loadBrowserURL(localBrowser, "http://mta/"..getResourceName(getThisResource()).."/files/html/iphone/iphone.html")
		local u = settings.general.webserverURL.."/iphone/music/index.php?apiUser="..urlencode(getPlayerName(localPlayer)).."&apiAuth="..urlencode(API_AUTH).."&defRadios="..urlencode(toJSON(settings.systems.vehicle.radioStations))
		outputConsole("mp: "..u)
		loadBrowserURL(mp3Browser, u)
		addEventHandler("onClientRender", root, webBrowserRender)
		addEventHandler("onClientBrowserDocumentReady", localBrowser, function()
			executeBrowserJavascript(localBrowser, "MY_NAME='"..getPlayerName(localPlayer).."';")
			executeBrowserJavascript(localBrowser, "API_AUTH='"..API_AUTH.."';")
			executeBrowserJavascript(localBrowser, "SETTINGS=$.parseJSON(atob('"..base64Encode(toJSON(data)).."'));");
			executeBrowserJavascript(localBrowser, "DEFAULT_RADIOS=$.parseJSON('"..toJSON(settings.systems.vehicle.radioStations).."');");
			executeBrowserJavascript(localBrowser, "WEBSERVER_URL='"..settings.general.webserverURL.."';")
		end)
		initialized = true
				
	else
		executeBrowserJavascript(localBrowser, "MY_NAME='"..getPlayerName(localPlayer).."';")
		executeBrowserJavascript(localBrowser, "SETTINGS=$.parseJSON(atob('"..base64Encode(toJSON(data)).."'));");
	end
end
addEvent("iPhoneReceiveSettings", true)
addEventHandler("iPhoneReceiveSettings", root, iPhoneReceiveSettings)


-- CEF <-> LUA
local function sendDataIntoCEF(retFunc, data)
	fuckDebug("@sendDataIntoCEF: "..retFunc.." | "..tostring(data))
	local fix = data
	if (type(data) == 'string') then
		fix = "'"..data.."'"
	elseif (type(data) == 'number' or type(data) == 'boolean') then
		fix = tostring(data)
	end
	return executeBrowserJavascript(localBrowser, retFunc.."("..fix..");")
end
addEvent("sendDataIntoCEF", true)
addEventHandler("sendDataIntoCEF", root, sendDataIntoCEF)


setTimer(function()
	local arr = {}
	for k, v in pairs(getElementsByType("player")) do
		table.insert(arr, getPlayerName(v))
	end
	local json = toJSON(arr)
	
	local x, y, z	= getElementPosition(localPlayer)
	local cellular	= 5
	if (getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0) then
		if (z >= 380) then
			cellular = 1
		elseif (z >= 300) then
			cellular = 2
		elseif (z >= 200) then
			cellular = 3
		elseif (z >= 100) then
			cellular = 4
		else
			cellular = 5
		end
	else
		cellular = 3
	end
	
	local loading = 'false';
	if (isPedInVehicle(localPlayer)) then -- TODO: or is in house
		loading = 'true';
	end
	
	executeBrowserJavascript(localBrowser, "allOnlinePlayers = $.parseJSON('"..json.."'); CELLULAR="..cellular.."; setLoading("..loading..");")
end, 3000, 0)


local ringring = false
-- Dont use ajax, it crashes the client
--setBrowserAjaxHandler(localBrowser, "ajax", function(get, post)
addEvent("ajaxFix", true)
addEventHandler("ajaxFix", root, function(json)
	post = fromJSON(json)
	fuckDebug("@LUA-AJAX: "..post['action'])
	
	
	-- SMS
	if (post['action'] == "loadSMS") then
		triggerServerEvent("getSMS", localPlayer)
		
	elseif (post['action'] == "newSMS") then
		triggerServerEvent("newSMS", localPlayer, post['name'])
		
	elseif (post['action'] == "answerSMS") then
		triggerServerEvent("answerSMS", localPlayer, post['id'], post['msg'])
		
		
	-- SUPPORT
	elseif (post['action'] == "loadSupport") then
		
	elseif (post['action'] == "newSupport") then
		
		
	-- SETTINGS
	elseif (post['action'] == "changeSettings") then
		SETTINGS = fromJSON(base64Decode(post['data']))
		saveSettings()
		
		
	-- MUSIC
	elseif (post['action'] == "searchMusic") then
		local t = {method = "POST", formFields = {s = urlencode(post['search']), limit = urlencode(post['limit']), offset = urlencode(post['offset']), apiUser = getPlayerName(localPlayer), apiAuth = API_AUTH}}
		local u = settings.general.webserverURL.."/api/163.php"
		
		outputConsole("\r\n\r\n")
		outputConsole("fetchRemote("..u..", "..dumpvar(t)..")");
		fetchRemote(u, t, function(data, responseInfo, s, limit, offset)
			outputConsole(dumpvar(responseInfo))
			outputConsole("\r\n\r\n")
			if (responseInfo.success == true and data ~= "") then
				local new = {
					s		= s,
					offset	= offset,
					limit	= limit,
					result	= base64Encode(data)
				}
				json = toJSON(new)
				
				sendDataIntoCEF("searchMusicCallback", base64Encode(json))
			end
		end, {post['search'],post['limit'],post['offset']})
		
	elseif (post['action'] == "getCharts") then
		local t = {method = "POST", formFields = {charts = 1, apiUser = getPlayerName(localPlayer), apiAuth = API_AUTH}}
		local u = settings.general.webserverURL.."/api/163.php"
		
		outputConsole("\r\n\r\n")
		outputConsole("fetchRemote("..u..", "..dumpvar(t)..")");
		fetchRemote(u, t, function(data, responseInfo)
			outputConsole(dumpvar(responseInfo))
			outputConsole("\r\n\r\n")
			if (responseInfo.success == true and data ~= "") then
				sendDataIntoCEF("chartsCallback", base64Encode(data))
			end
		end)
		
	elseif (post['action'] == "getPlaylist") then
		local t = {method = "POST", formFields = {playlist = urlencode(post['playlist']), apiUser = getPlayerName(localPlayer), apiAuth = API_AUTH}}
		local u = settings.general.webserverURL.."/api/163.php"
		
		outputConsole("\r\n\r\n")
		outputConsole("fetchRemote("..u..", "..dumpvar(t)..")");
		fetchRemote(u, t, function(data, responseInfo)
			outputConsole(dumpvar(responseInfo))
			outputConsole("\r\n\r\n")
			if (responseInfo.success == true and data ~= "") then
				sendDataIntoCEF("playlistCallback", base64Encode(data))
			end
		end)
		
		
	elseif (post['action'] == "ytToMp3") then
		local t = {method = "POST", formFields = {srv = post['srv'], id = post['id'], apiUser = getPlayerName(localPlayer), apiAuth = API_AUTH}}
		local u = settings.general.webserverURL.."/api/ytdl.php"
		
		outputConsole("\r\n\r\n")
		outputConsole("fetchRemote("..u..", "..dumpvar(t)..")");
		
		fetchRemote(u, t, function(data, responseInfo)
			outputConsole(dumpvar(responseInfo))
			outputConsole("\r\n\r\n")
			if (responseInfo.success == true and data ~= "") then
				sendDataIntoCEF("ytMp3Callback", base64Encode(data))
			end
		end)
		
		
	-- PHONE
	elseif (post['action'] == "startCall") then
		triggerServerEvent("startCall", localPlayer, post['target'])
	
	elseif (post['action'] == "answerCall") then
		local bool = false
		if (tonumber(post['bool']) == 1) then bool = true end
		triggerServerEvent("answerCall", localPlayer, bool)
		
	elseif (post['action'] == "toggleRingtone") then
		if (isElement(ringring)) then
			destroyElement(ringring)
		end
		
		if (tonumber(post['bool']) == 1) then
			ringring = playSound("files/html/iphone/sounds/ringtone.ogg", true)
		end
		
	
	-- WEATHER
	elseif (post['action'] == "getWeather") then
		sendDataIntoCEF("weatherCallback", base64Encode(toJSON(getElementData(root, "weatherData"))))
		
	
	-- VEHICLES
	elseif (post['action'] == "getAllVehicles") then
		triggerServerEvent("getAllVehicles", localPlayer)
		
	elseif (post['action'] == "respawnVehicle") then
		triggerServerEvent("vhAction", localPlayer, "respawn", post['slot'])
		
	elseif (post['action'] == "locateVehicle") then
		triggerServerEvent("vhAction", localPlayer, "locate", post['slot'])
		
	
	--BANK
	elseif (post['action'] == "getBankData") then
		local transactions = {}
		local time = getRealTime()
		local json = fromJSON(fileGetContents(statementPath))
		if (type(json) == "table") then
			for i, arr in ipairs(json) do
				
				local sum = setDotsInNumber(arr['val'])
				if (tonumber(arr['val']) < 0) then
					sum = setDotsInNumber((tonumber(arr['val'])*-1))
				end
				
				local tm = getRealTime(arr['time'])
				local dmy = time.monthday.."."..(time.month+1).."."..(time.year+1900)..", "..string.format("%02d:%02d", tm.hour, tm.minute).." Uhr"
				
				table.insert(transactions, {
					["date"] 			= dmy,
					["reason"]			= arr["reason"],
					["sum"]				= arr['val'],
					["sum_readable"]	= sum,
				})
			end
				
		end
		
		local tbl = {
			["money"]			= getPlayerBankMoney(),
			["money_formated"]	= setDotsInNumber(getPlayerBankMoney()),
			["transactions"]	= transactions,
		}
		
		sendDataIntoCEF("bankDataCallback", base64Encode(toJSON(tbl)))
		
	elseif (post['action'] == "transferMoney") then
		triggerServerEvent("bankTransfer", localPlayer, tonumber(post['sum']), post['receiver'], post['reason'], true)
	
	elseif (post['action'] == "loadPrepaid") then
		triggerServerEvent("loadPrepaid", localPlayer, tonumber(post['sum']))
		
	
	-- HOUSE
	elseif (post['action'] == "getHouseData") then
		triggerServerEvent("getHouseData", localPlayer)
		
	elseif (post['action'] == "houseAction") then
		if (post['act'] == 'lock') then
			triggerServerEvent("House:Lock", localPlayer, post['id'])
		elseif (post['act'] == 'locate') then
			triggerServerEvent("locateHouse", localPlayer, post['id'])
		end
		
	
	-- FRANCHISE
	elseif (post['action'] == "getFranchise") then
		triggerServerEvent("getFranchise", localPlayer)
		
	elseif (post['action'] == "inOutFranchise") then
		triggerServerEvent("inOutFranchise", localPlayer, post['act'], post['amount'])
		
	
	-- OTHER
	elseif (post['action'] == "browser") then
		curBrowser = wwwBrowser
		outputChatBox("url:"..post['url'])
		outputChatBox("urldecoded:"..urldecode(post['url']))
		loadBrowserURL(wwwBrowser, urldecode(post['url']))
		
	elseif (post['action'] == "musicext") then
		mp3BrowserOpen = true
		toggleBrowserDevTools(mp3Browser, true)
		
	elseif (post['action'] == "toggleYT") then
		--guiSetVisible(ytBrowser, not guiGetVisible(ytBrowser))
		
	elseif (post['action'] == "toggleDev") then
		toggleBrowserDevTools(localBrowser, true)
		
	elseif (post['action'] == "showNotification") then
		outputConsole("\r\n\r\n\r\n")
		if (string.len(post['image']) > 10) then
			post['image'] = 'HAS IMAGE!'
		end
		post['image'] = 'HAS IMAGE!'
		outputConsole(dumpvar(post))
		outputConsole("\r\n\r\n\r\n")
		
		infoShow("info", post['message'])
	end
end)


--- MUSIC-APP ---
curSound = nil

local function updateLiveMetas(title)
	title = utf8.escape(title)
	title = string.gsub(title, '"', "'")
	title = string.gsub(title, "\r", " ")
	title = string.gsub(title, "\n", " ")
	
	outputDebugString('@updateLiveMetas: title:'..title)
	
	executeBrowserJavascript(localBrowser, 'LIVE_META="'..title..'";')
end
local function soundDownloadCallback(length)
	outputDebugString('@soundDownloadCallback: 0')
	if (length > 0) then
		outputDebugString('@soundDownloadCallback: length:'..length)
		removeEventHandler("onClientSoundFinishedDownload", source, soundDownloadCallback)
		executeBrowserJavascript(localBrowser, 'CAN_CHANGE_POS=true;')
	end
end

addEvent("musicPlayPause", true)
addEventHandler("musicPlayPause", root, function(act)
	outputDebugString('@musicPlayPause: '..act)
	if (act == 'pause') then
		if (curSound) then
			setSoundPaused(curSound, true)
		end
		
	elseif (act == 'play') then
		if (curSound) then
			setSoundPaused(curSound, false)
		end
	elseif (act == 'stop') then
		if (curSound) then
			stopSound(curSound)
			curSound = nil
		end
		
	end
end)

local chkTimer = nil
addEvent("musicStartPlay", true)
addEventHandler("musicStartPlay", root, function(uri, volume)
	outputDebugString('@musicStartPlay: 0')
	if (curSound) then
		outputDebugString('@musicStartPlay: curSound? -> stop old')
		stopSound(curSound)
		curSound = nil
	end
	if (isTimer(chkTimer)) then
		outputDebugString('@musicStartPlay: chkTimer? -> stop old')
		killTimer(chkTimer)
	end
	addEventHandler("onClientSoundStarted", root, soundStartCB)
	curSound = playSound(uri, false, false)
	setElementData(curSound, "iphonesound", true)
	setSoundVolume(curSound, volume/100)
end)
addEvent("musicChangeVolume", true)
addEventHandler("musicChangeVolume", root, function(volume)
	if (curSound) then
		setSoundVolume(curSound, volume/100)
	end
end)
addEvent("musicChangePos", true)
addEventHandler("musicChangePos", root, function(sec)
	if (curSound) then
		setSoundPosition(curSound, sec)
	end
end)

function soundStartCB()
	outputDebugString('@soundStartCB: 0')
	curSound = source
	local runs = 0
	
	chkTimer = setTimer(function()
		outputDebugString('@chkTimer: 0')
		if (runs >= 120) then
			outputDebugString('@chkTimer: runs >= 120 -> kill')
			if (isTimer(chkTimer)) then
				killTimer(chkTimer)
			end
		end
		
		if (curSound) then
			outputDebugString('@chkTimer: curSound?')
			local secs = getSoundLength(curSound)
			if (secs > 0) then
				outputDebugString('@chkTimer: curSound -> secs: '..secs)
				executeBrowserJavascript(localBrowser, 'musicStartCB('..secs..');')
				if (isTimer(chkTimer)) then
					killTimer(chkTimer)
				end
			end
		end
		
		runs = runs + 1
	end, 500, 0)
	
	removeEventHandler("onClientSoundStarted", root, soundStartCB)
	addEventHandler("onClientSoundChangedMeta", source, updateLiveMetas)
	addEventHandler("onClientSoundFinishedDownload", source, soundDownloadCallback)
end




--SMS
function newSmsNotification(from, ID, text)
	if (iPhoneOpen) then
		executeBrowserJavascript(localBrowser, "newSmsNotification('"..from.."', '"..base64Encode(text).."', "..ID..");")
	else
		infoShow("info", "Neue SMS von "..from)
	end
end
addEvent("newSmsNotification", true)
addEventHandler("newSmsNotification", root, newSmsNotification)

