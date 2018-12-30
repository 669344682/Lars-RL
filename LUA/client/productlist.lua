----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

-- displayProductSelect(TITEL, PRODUCTTABLE, CB-FUNC ONSELECT, CB-FUNC BUY, CB-FUNC CLOSE, image)
-- destroyProductSelect()
-- freezeProductList(time in ms)
local tmpData = {
	open			= false,
	startID			= 1,
	endID			= 10,
	maxEntries		= 10,
	currentSelected = 1,
	products		= {},
	title			= "",
	image			= "",
	currentRender	= function()end,
	callbackSelect	= function()end,
	callbackBuy		= function()end,
	callbackClose	= function()end,
	
	--hasBuyed		= false,
	freezed			= false,
}
local FONT = dxCreateFont("files/fonts/chalet.ttf", 24, false, "antialiased")

--local larsX, larsY	= 1440, 900
local entryCount	= 0
local panelWidth	= 350
local rowHeight		= 35
local bgX, bgY		= 32, 32
local endY			= 0
local function renderShopList()
	--[[
	local sX		= sX -- make it local, dont override
	local innerRand	= (15/larsX*sX)
	local outerRand	= (25/larsX*sX)
	local width		= (260/larsX*sX)
	local lsX		= (sX - width) - outerRand
	local rsX		= lsX + width
	
	-- 4:3 fix --
	local dif = sX / sY -- 1,333333333333333
	if (dif >= 1.3 and dif < 1.4) then
		sX = ((sX / 1.333333333333333) * 1.777777777777778)
	end
	-- 4:3 fix --
	]]
	
	
	
	
	-- BACKGROUND
	dxDrawRectangle(bgX, bgY, panelWidth, 175+rowHeight, tocolor(0, 0, 0, 200))
	dxDrawImage(bgX, bgY, panelWidth, 175, tmpData.image)
	
	dxDrawRectangle(bgX, bgY+175, panelWidth, rowHeight, tocolor(0, 0, 0, 230)) -- CATEGORY
	dxDrawText(utf8.upper(tmpData.title), bgX+10, bgY+175, bgX+330, bgY+175+rowHeight, tocolor(255,255,255,255), 0.5, FONT, "left", "center")
	dxDrawText(tmpData.currentSelected.." / "..#tmpData.products, bgX+10, bgY+175, bgX+335, bgY+175+rowHeight, tocolor(255,255,255,255), 0.5, FONT, "right", "center")
	
	-- Entries
	local entryCount = 0
	local black = false
	local eY = (bgY+175+rowHeight)
	
	for i = tmpData.startID, tmpData.endID, 1 do
		local product = (tmpData.products[i] or false)
		if (product ~= false) then
			local x,y,w,h = bgX, eY, panelWidth, rowHeight
			if (black == true) then
				dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
				black = false
			else
				dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 150))
				black = true
			end
			
			local tc = tocolor(255, 255, 255)
			if (tmpData.currentSelected == i) then
				tc = tocolor(0, 0, 0)
				dxDrawImage(x, y, w, h, "files/images/tuning/rowhover.png")
			end
			
			dxDrawText(product.title, x+17, y, x+w-34, y+h, tc, 0.5, FONT, "left", "center")
			
			local prc = setDotsInNumber(product.price).." $"
			dxDrawText(prc, x+17, y, x+w-17, y+h, tc, 0.5, FONT, "right", "center")
			
			entryCount = entryCount + 1
			eY = eY + rowHeight
			
		end
	end
	
	-- scrollbar
	if (#tmpData.products > tmpData.maxEntries) then
		local rowVisible = math.max(0.05, math.min(1.0, tmpData.maxEntries / #tmpData.products))
		local barHeight = (tmpData.maxEntries * rowHeight) * rowVisible
		local barPos = math.min((tmpData.endID-tmpData.maxEntries) / #tmpData.products, 1.0 - rowVisible) * (tmpData.maxEntries * rowHeight)
		dxDrawRectangle(bgX + panelWidth - 2, (bgY+175+rowHeight) + barPos, 2, barHeight, tocolor(255, 255, 255, 255))
	end
	
	-- FOOTER
	dxDrawRectangle(bgX, (bgY+175+rowHeight)+(rowHeight*entryCount)+2, panelWidth, rowHeight, tocolor(0, 0, 0, 255))
	dxDrawImage(bgX+165, (bgY+175+rowHeight)+(rowHeight*entryCount)+5, 20, 28, "files/images/tuning/nav.png")
	
	endY = (bgY+175+rowHeight)+(rowHeight*entryCount)+2+rowHeight
end

local function BUY()
	if (tmpData.freezed == false) then
		--freezeProductList(1500)
		--tmpData.hasBuyed = true
		--setTimer(function() tmpData.hasBuyed = false end, 1500, 1)
		tmpData.callbackBuy(tmpData.currentSelected)
	end
end
destroyProductSelect = function()end
local function CLOSE()
	if (tmpData.freezed == false) then
		smoothDestroy()
		tmpData.callbackClose()
		destroyProductSelect()
	end
end

local function moveList(key, state)
	if (state == true and tmpData.freezed == false) then
		--tmpData.hasBuyed = false
		local old = tmpData.currentSelected
		if (key == "s" or key == "num_2" or key == "arrow_d" or key == "mouse_wheel_down") then
			
			tmpData.currentSelected = tmpData.currentSelected + 1
			if (tmpData.currentSelected > #tmpData.products) then
				tmpData.currentSelected = 1
				tmpData.startID = 1
				tmpData.endID = tmpData.maxEntries
			end
			
			if (tmpData.currentSelected > tmpData.endID) then
				tmpData.startID	= tmpData.startID + 1
				tmpData.endID		= tmpData.endID + 1
			end
			tmpData.callbackSelect(tmpData.currentSelected)
			
			
		elseif (key == "w" or key == "num_8" or key == "arrow_u" or key == "mouse_wheel_up") then
			
			tmpData.currentSelected = tmpData.currentSelected - 1
			if (tmpData.currentSelected < 1) then
				tmpData.currentSelected = #tmpData.products
				tmpData.startID = (#tmpData.products-(tmpData.maxEntries-1))
				tmpData.endID = #tmpData.products
				if (tmpData.startID < 1) then
					tmpData.startID = 1
				end
				if (tmpData.endID < tmpData.maxEntries) then
					tmpData.endID = tmpData.maxEntries
				end
			end
			if (tmpData.startID > tmpData.currentSelected) then
				tmpData.startID = tmpData.currentSelected
				tmpData.endID = tmpData.startID + tmpData.maxEntries - 1
			end
			tmpData.callbackSelect(tmpData.currentSelected)
			
		elseif (key == "pgup") then
			tmpData.currentSelected	= 1
			tmpData.startID		= 1
			tmpData.endID		= tmpData.maxEntries
			
		elseif (key == "pgdn") then
			tmpData.currentSelected = #tmpData.products
			tmpData.startID	= #tmpData.products - tmpData.maxEntries + 1
			if (tmpData.startID < 1) then
				tmpData.startID = 1
			end
			tmpData.endID		= #tmpData.products
			if (tmpData.endID < tmpData.maxEntries) then
				tmpData.endID = tmpData.maxEntries
			end
			
			
		elseif (key == "enter") then
			BUY()
			
		elseif (key == "backspace") then
			CLOSE()
		end
	end
end




function displayProductSelect(title, products, CBselect, CBbuy, CBclose, img)
	if (tmpData.open == true) then return end
	tmpData.open = true
	tmpData.currentRender = function()
		renderShopList()
	end
	addEventHandler("onClientRender", root, tmpData.currentRender)
	addEventHandler("onClientKey", root, moveList)
	
	tmpData.products = products
	tmpData.title = title
	tmpData.callbackSelect = CBselect
	tmpData.callbackBuy = CBbuy
	tmpData.callbackClose = CBclose
	tmpData.image = img
	
	tmpData.callbackSelect(1)
	
	windowOpen = true
	showChat(false)
end

function destroyProductSelect()
	removeEventHandler("onClientRender", root, tmpData.currentRender)
	removeEventHandler("onClientKey", root, moveList)
		
	tmpData.currentSelected = 1
	tmpData.startID = 1
	tmpData.endID = 10
	tmpData.maxEntries = 10
	tmpData.products = {}
	tmpData.title = ""
	tmpData.image = ""
	tmpData.callbackSelect = function()end
	tmpData.callbackBuy = function()end
	tmpData.callbackClose = function()end
	tmpData.open = false
	--tmpData.hasBuyed = false
	tmpData.freezed = false
	
	windowOpen = false
	showChat(true)
end

function freezeProductList(time)
	tmpData.freezed = true
	setTimer(function()
		tmpData.freezed = false
	end, time, 1)
end

function setMaxProductListEntries(num)
	tmpData.endID = num
	tmpData.maxEntries = num
end

function productListOffsets()
	return bgX, bgY, bgX+panelWidth, endY, panelWidth, endY-bgY
end