-- Thanks to Jake!


dxWindow, dxButton, dxText, dxGrid, dxEdit, dxMemo, dxImage, dxCheckbox = {}, {}, {}, {}, {}, {}, {}, {};
dxWindow.__index, dxButton.__index, dxText.__index, dxGrid.__index, dxEdit.__index, dxMemo.__index, dxImage.__index, dxCheckbox.__index = dxWindow, dxButton, dxText, dxGrid, dxEdit, dxMemo, dxImage, dxCheckbox;

local bgBlueRGB = {getColorFromString("#104e8b")};
local bgBlueRGBDisabled = {getColorFromString("#5B7996")};
local bgBlueButtonHoverRGB = {getColorFromString("#325c8b")};
local function dxOutline(x, y, w, h)
	--[[dxDrawRectangle(x, y, w+2, 2, tocolor(16, 78, 139, 255), false);
	dxDrawRectangle(x, y+h+2, w+2, 2, tocolor(16, 78, 139, 255), false);
	dxDrawRectangle(x, y, 2, h+2, tocolor(16, 78, 139, 255), false);
	dxDrawRectangle(x+w, y, 2, h+2, tocolor(16, 78, 139, 255), false);]]
end

local FONTS = {
	["exo-8"]			= dxCreateFont("files/fonts/exo.ttf", 8),
	["exo-9"]			= dxCreateFont("files/fonts/exo.ttf", 9),
	["exo-10"]			= dxCreateFont("files/fonts/exo.ttf", 10),
	["exo-12"]			= dxCreateFont("files/fonts/exo.ttf", 12),
	["exo-bold-8"]		= dxCreateFont("files/fonts/exo-bold.ttf", 8),
	["exo-bold-9"]		= dxCreateFont("files/fonts/exo-bold.ttf", 9),
	["exo-bold-10"]		= dxCreateFont("files/fonts/exo-bold.ttf", 10),
	["exo-bold-12"]		= dxCreateFont("files/fonts/exo-bold.ttf", 12),
	
	
	["harabara-14"]	= dxCreateFont("files/fonts/harabara.ttf", 14),
}

local  GUIFONTS = {
	["exo-11"]			= guiCreateFont("files/fonts/exo.ttf", 11),
}

local lastGUI = nil
function dxWindow:new(title, x, y, width, height, color, font, tFont, anim, hcolor, closeable, closeCallback, extraRenderFunc, dontCloseOther)
	--if (windowOpen) then return false end
	--[[if (lastGUI and dontCloseOther ~= true) then
		removeEventHandler("onClientClick", root, lastGUI.m_closeFunc);
		removeEventHandler("onClientRender", root, lastGUI.m_renderFunc);
		removeEventHandler("onClientRestore", root, lastGUI.m_restore);
		lastGUI:removeAllItems();
		--if lastGUI.m_grid then 
		--	lastGUI.m_grid:delete();
		--end
		if lastGUI.m_renderTarget then
			destroyElement(lastGUI.m_renderTarget);
			lastGUI.m_renderTarget = false;
		end
		
		if lastGUI.m_closeCallback then 
			lastGUI.m_closeCallback();
		end
		
		lastGUI = nil;
	end]]
	
	
	local instance = {};
	
	-- Standards --
	if not x then x = sX/2 - width / 2; end
	if not y then y = sY/2 - height / 2; end
	if not color then color = {255, 255, 255, 255}; end
	if not font then font = FONTS['exo-10']; end
	if not tFont then tFont = FONTS['harabara-14']; end
	if not anim then anim = "Linear"; end
	if not hcolor then hcolor = tocolor(unpack(bgBlueRGB)); end
	if not closeable then closeable = true; end
	if (not extraRenderFunc) then extraRenderFunc = nil end
	
	if (font and FONTS[font]) then font = FONTS[font]; end
	if (tFont and FONTS[tFont]) then font = FONTS[tFont]; end
	
	--Variables--
	instance.m_Title = title;
	instance.m_X = 0;
	instance.m_Y = y;
	instance.m_width = width;
	instance.m_height = height;
	instance.m_color = color;
	instance.m_font = font;
	instance.m_Tfont = tFont;
	instance.m_tick = -1;
	instance.m_state = "default";
	instance.m_animX = x;
	instance.m_animY = y;
	instance.m_isVisible = true;
	instance.m_renderTarget = false;
	instance.m_leftX = -width;
	instance.m_tick = getTickCount();
	instance.m_endTick = instance.m_tick+500;
	instance.m_animation = anim;
	instance.m_mX = -width;
	instance.m_state = "open";
	instance.m_hColor = hcolor;
	instance.m_items = {};
	instance.m_isClosable = closable;
	instance.m_closeCallback = closeCallback;
	instance.m_reset = false;
	--instance.m_grid = false;
	instance.m_extraRenderFunc = extraRenderFunc;
	
	--Funktionen--
	instance.m_renderFunc = function() instance:draw() end;
	instance.m_closeFunc = function(btn,state) instance:closeClick(btn,state) end;
	instance.m_center = function() instance:center() end;
	instance.m_updateTitle = function(title) instance:updateTitle(title) end;
	instance.m_restore = function() instance:restore() end;
	
	--addEventHandler("onClientRender", root, self.m_renderFunc);
		
	showCursor(true);
	guiSetInputMode("no_binds");
	addEventHandler("onClientClick", root, instance.m_closeFunc);
	addEventHandler("onClientRestore", root, instance.m_restore);
	
	setmetatable(instance, self);
	
	instance:update();
	
	windowOpen = true;
	setElementData(localPlayer, "clicked", true)
	
	lastGUI = instance;
	
	return instance;
end

function dxWindow:restore()
	self:update();
end 

function dxWindow:delete()
	removeEventHandler("onClientClick", root, self.m_closeFunc);
	removeEventHandler("onClientRender", root, self.m_renderFunc);
	removeEventHandler("onClientRestore", root, self.m_restore);
	guiSetInputMode("allow_binds");
	showCursor(false);
	showChat(true);
	self:removeAllItems();
	--if self.m_grid then 
		--self.m_grid:delete();
	--end
	if self.m_renderTarget then
		setTimer(function() 
			destroyElement(self.m_renderTarget);
			self.m_renderTarget = false;
			self = nil;
		end, 1000, 1);
	end
	windowOpen = false;
	setElementData(localPlayer, "clicked", false)
end

function dxWindow:close(doNoCB)
	self.m_tick = getTickCount();
	self.m_endTick = self.m_tick + 500;
	self.m_state = "close";
	showCursor(false);
	if self.m_closeCallback and doNoCB ~= true then 
		self.m_closeCallback();
	end
	setTimer(function()
		self:delete();
	end, 500, 1);
end

function dxWindow:closeClick(btn, state)
	if not isCursorShowing() then return end;
	if btn == "left" and state == "down" then 
		local cx, cy = getCursorPosition();
		cx, cy = cx*sX, cy*sY;
		if ( cx >= self.m_mX + self.m_width-40 and cx <= self.m_mX + self.m_width-8 and cy >= self.m_Y +8 and cy <= self.m_Y + 40 ) then 
			self:close();
		end 
	end 
end

--[[function dxWindow:reset()
	self.m_reset = true;
	self.m_tick = getTickCount();
	self.m_endTick = self.m_tick + 500;
	self.m_state = "close";
	self.m_grid:delete();
	self:removeAllItems();
end]]

-- bloß kein table.remove nehmen => Items werden nicht korrekt entfernt!!
function dxWindow:removeAllItems()
	for i, val in pairs(self.m_items) do 
		if (val ~= nil) then
			val:delete();
			self.m_items[i] = nil
		end
	end
end

--[[function dxWindow:setGrid(grid)
	self.m_grid = grid;
end 

function dxWindow:removeGrid()
	self.m_grid = nil;
end]]

function dxWindow:addItem(item)
	table.insert(self.m_items, item);
	self:update();
end 

function dxWindow:removeItem(item)
	for i, val in pairs(self.m_items) do 
		if val == item then
			self.m_items[i] = nil
			break;
		end 
	end 
	--self:update();
end 

function dxWindow:setTitle(title)
	--assert(type(title) ~= "string", "Bad Argument @dxWindow:setTitle(): type(title) expected to be string");
	self.m_Title = title;
	self:update();
end

function dxWindow:setHeaderColor(r, g, b)
	assert(type(r) ~= "number", "Bad Argument @dxWindow:setHeaderColor(): type(r) expected to be number");
	self.m_hColor = tocolor(r, g, b, 255);
	self:update();
end 

function dxWindow:resize(width, height, updateXY)
	self.m_width = width;
	self.m_height = height;
	if (updateXY) then
		x = sX/2 - width / 2;
		y = sY/2 - height / 2;
		self.m_mX = x;
		self.m_Y = y;
	end
	self:update();
end

function dxWindow:setOffset(x, y)
	self.m_mX = x;
	self.m_Y = y;
	self:update();
end

function dxWindow:getOffset()
	return {self.m_mX, self.m_Y};
end 

function dxWindow:getSize()
	return {self.m_width, self.m_height};
end 

function dxWindow:update()
	if isElement(self.m_renderTarget) then 
		destroyElement(self.m_renderTarget);
		removeEventHandler("onClientRender", root, self.m_renderFunc);
	end 
	self.m_renderTarget = dxCreateRenderTarget(self.m_width+2, self.m_height+48, true);
	if ( isElement(self.m_renderTarget) ) then 
		dxSetRenderTarget(self.m_renderTarget, true);
		dxSetBlendMode("modulate_add");
		--Titel--
		dxDrawRectangle(1, 1, self.m_width, 35, self.m_hColor);
		dxDrawText(self.m_Title, 2+self.m_width/2-dxGetTextWidth(self.m_Title, 1, self.m_Tfont)/2, 18-dxGetFontHeight(1,self.m_Tfont)/2, self.m_width, self.m_height, tocolor(0, 0, 0, 255), 1, self.m_Tfont, "left", "top", false, false, false, false, true);
		dxDrawText(self.m_Title, 1+self.m_width/2-dxGetTextWidth(self.m_Title, 1, self.m_Tfont)/2, 17-dxGetFontHeight(1,self.m_Tfont)/2, self.m_width, self.m_height, tocolor(unpack(self.m_color)), 1, self.m_Tfont, "left", "top", false, false, false, false, true);
		--Body--
		--dxDrawRectangle(1, 36, self.m_width, self.m_height, tocolor(25, 25, 25, 230));
		dxDrawImage (1, 36, self.m_width, self.m_height, "files/images/gui_background.png", 0, 0, 0, tocolor(255, 255, 255, 230), false);
		--Close Button--
		dxDrawRectangle(self.m_width - 35, 1, 32, 32, tocolor(unpack(bgBlueRGB)));
		dxDrawText("X", self.m_width - 35 + 16 - dxGetTextWidth("X", 1, self.m_font)/2, 2+16-dxGetFontHeight(1,self.m_font)/2, self.m_width, self.m_height, tocolor(255, 255, 255, 255), 1, self.m_font, "left", "top", false, false, false);
		dxOutline(0, 0, self.m_width, self.m_height+34);
		--Buttons--	
		dxSetRenderTarget();
		dxSetBlendMode("blend");
	end
	addEventHandler("onClientRender", root, self.m_renderFunc);
end

function dxWindow:draw()
	if isElement(self.m_renderTarget) then
		if self.m_tick ~= -1 then
			local now = getTickCount();
			local elaps = getTickCount() - self.m_tick;
			local duration = self.m_endTick - self.m_tick;
			local progress = elaps / duration;
			if self.m_state == "open" then 
				local mX = interpolateBetween(self.m_leftX, 0, 0, self.m_animX, 0, 0, progress, "InQuad");
				self.m_mX = mX;
				
				for index, key in pairs(self.m_items) do 
					if key.m_type == "grid" then
						self.m_items[index].m_clickX = mX + key.m_x
					end
				end
				
				--if self.m_grid then 
				--	self.m_grid.m_clickX = mX+self.m_grid.m_x
				--end 
			end 
			if self.m_state == "close" then 
				local mX = interpolateBetween(self.m_animX, 0, 0, self.m_leftX, 0, 0, progress, "OutQuad");
				self.m_mX = mX;
				if mX <= self.m_leftX then 
					self:delete();
				end 
			end
			if now >= self.m_endTick then
				self.m_tick = -1;
			end 
		end
		dxSetBlendMode("add");
		dxDrawImage(self.m_mX, self.m_Y, math.floor(self.m_width), math.floor(self.m_height), self.m_renderTarget);
		dxSetBlendMode("blend");
		
		if (self.m_extraRenderFunc) then
			self.m_extraRenderFunc(self.m_mX+1, self.m_Y+31);
		end
		
		if #self.m_items > 0 then 
			for index, key in pairs(self.m_items) do 
				
				if key.m_type == "grid" then
					local data = key;
					local colWidth;
					local endX = {}
					endX[0]=0
					local colCount = #data.m_Items.columns;
					dxDrawRectangle(self.m_mX+data.m_x,self.m_Y+data.m_y+34, data.m_w, data.m_h, tocolor(0, 0, 0, 155));
					if colCount > 0 then
						colWidth = data.m_w / colCount - 5;
						for i = 1, colCount do
							if (type(data.m_Items.columns[i][2]) == "number" and tonumber(data.m_Items.columns[i][2]) > 0) then
								colWidth = ((data.m_w/100)*data.m_Items.columns[i][2]) - 5
							end
							
							dxDrawText(data.m_Items.columns[i][1], self.m_mX+data.m_x+5+endX[(i-1)], self.m_Y+data.m_y+3+34, colWidth, 20, tocolor(255, 255, 255, 255), data.m_fsize, data.m_font, "left", "top");
							
							endX[i] = endX[(i-1)] + colWidth
						end
						dxDrawRectangle(self.m_mX+data.m_x+1, self.m_Y+data.m_y+3+34+18, data.m_w-2, 1, tocolor(255, 255, 255, 255));
					end
					local c = 1;
					if #data.m_Items.rows > 0 then
						if #data.m_Items.rows > data.m_maxItems then 
							local height = math.floor(data.m_h / #data.m_Items.rows)+9;
							local maxScroll = #data.m_Items.rows - data.m_maxItems;
							maxScroll = (data.m_h - height) / maxScroll
							dxDrawRectangle(self.m_mX+data.m_x+data.m_w, self.m_Y+data.m_y+(maxScroll*data.m_scroll)+34+3, 3, 10, tocolor(unpack(bgBlueRGB)), false);
						end 
						for i = 1+data.m_scroll, (data.m_maxItems) + data.m_scroll do
							if data.m_Items.rows[i] then
								if data.m_selected == i then
									dxDrawRectangle(self.m_mX+data.m_x, self.m_Y+data.m_y+(17.5*(c-1))+34+20+3, data.m_w, 20, data.m_hcolor);
								end
								for k = 1, colCount do
									if data.m_Items.rows[i][k] then
										
										local txt = data.m_Items.rows[i][k]
										--[[local tw = dxGetTextWidth(txt, 1, data.m_font)
										if (tw >= colWidth) then
											txt = string.sub(txt, 0, (string.len(txt)-7)).."..."
										end]]
										
										dxDrawText(txt, self.m_mX+data.m_x+5+endX[(k-1)], self.m_Y+data.m_y+5.5+34+(17.5*(c-1))+20, colWidth, 20, tocolor(255, 255, 255, 255), data.m_fsize, data.m_font, "left", "top", false, true);
									end
								end
								c = c + 1;
							end
						end
					end
				end
				
				
				
				
				if key.m_type == "button" then
					key:hover();
					dxDrawRectangle(self.m_mX+key.m_x, self.m_Y+key.m_y+34, key.m_w, key.m_h, key.m_buttoncolor);
					dxDrawText(key.m_text, self.m_mX+key.m_x+key.m_w/2-dxGetTextWidth(key.m_text, 1, key.m_font)/2, self.m_Y+key.m_y+34+key.m_h/2-dxGetFontHeight(1, key.m_font)/2, key.m_w, key.m_h, key.m_tcolor, key.m_fsize, key.m_font, "left", "top" ,false, false, false);
				end
				if key.m_type == "text" then 
					dxDrawText(key.m_text, self.m_mX+key.m_x, self.m_Y+key.m_y+34, self.m_mX+key.m_x+key.m_w, self.m_Y+key.m_y+34+key.m_h, key.m_tcolor, key.m_fsize, key.m_font, key.m_halign, "top" ,false, true, false, key.m_colorcoded);
				end
				if key.m_type == "edit" then
					dxDrawRectangle(key.x+self.m_mX, key.y+self.m_Y+34, key.w, key.h, tocolor(255, 255, 255, 255), false);
					key:updateText()
					
					local fColor	= tocolor(33, 33, 33, 255)
					local selStart	= tonumber(guiGetProperty(key.edit, "SelectionStart"))
					local selLength = tonumber(guiGetProperty(key.edit, "SelectionLength"))
					local hexCodes	= false
					local txt		= key.text 
					if (selLength > 0) then
						hexCodes			= true
						local selTxtStart 	= string.sub(key.text, 0, selStart)
						local selTxt 		= string.sub(key.text, selStart, (selStart+selLength))
						local selTxtWdth	= dxGetTextWidth(selTxt, 1, key.font)
						local height		= key.h/1.5
						local startY		= (key.h-height)/2
						
						dxDrawRectangle(key.x+self.m_mX+dxGetTextWidth(selTxtStart, 1, key.font)+5+1, key.y+self.m_Y+34+startY, selTxtWdth, height, tocolor(93, 123, 247, 255));
						
						if (string.len(key.text) == selLength) then
							fColor			= tocolor(255, 255, 255, 255)
						else
							local sss = selStart
							local cf = 0
							if (sss < 0) then sss = 0 else cf=1 end
							local fix = ""
							if ((selStart+selLength) < string.len(txt)) then
								fix = "#212121"..string.sub(key.text, (selStart+selLength)+1, string.len(txt))
							end
							txt = string.sub(key.text, 0, sss).."#FFFFFF"..string.sub(key.text, selStart+cf, (selStart+selLength))..fix
						end
					end
					
					dxDrawText(txt, key.x+self.m_mX+5+2.5, key.y+self.m_Y+34+key.h/2-7.5, key.w, key.h, fColor, 1, key.font, "left", "top", false, false, true, hexCodes);
					
				end
				if key.m_type == "memo" then 
					key:updateText();
					dxDrawRectangle(key.x+self.m_mX, key.y+self.m_Y+34, key.w, key.h, tocolor(255, 255, 255, 255), false);
					dxDrawText(key.text, key.x+self.m_mX+5, key.y+self.m_Y+50, key.w-10, key.h-10, tocolor(33, 33, 33, 255), 1, key.font, "left", "top", false, true, false, false);
					
					
					--[[if key.showLine then 
						local th = dxGetTextWidth("aa",1,key.font)
						dxDrawRectangle(key.x+self.m_mX+dxGetTextWidth(key.text,1,key.font)+5, key.y+self.m_Y+50, 1, th, tocolor(33, 33, 33, 255), false);
					end]]
				end
				if key.m_type == "checkbox" then 
					dxDrawImage(key.x+self.m_mX, key.y+self.m_Y+34, key.w, key.h, key.path);
				end
				if key.m_type == "image" then 
					dxDrawImage(key.m_x+self.m_mX, key.m_y+self.m_Y+34, key.m_w, key.m_h, key.m_file)
				end
			end
		end
	else
		self:update();
	end
end

-- DX Button --
function dxButton:new(x, y, w, h, text, parent, clickEvent, tcolor, font, fsize)
	
	if not x then x = 0 end;
	if not y then y = 0 end;
	if not w then w = 128 end;
	if not h then h = 32 end;
	if not tcolor then tcolor = tocolor(255, 255, 255, 255); end
	if not font then font = FONTS['exo-10'] end
	if not fsize then fsize = 1; end
	if not clickEvent then clickEvent = false end
	parent = parent;
	
	local instance = {};
	
	instance.m_x = x;
	instance.m_y = y;
	instance.m_w = w;
	instance.m_h = h;
	instance.m_text = text;
	instance.m_tcolor = tcolor;
	instance.m_font = font;
	instance.m_fsize = fsize;
	instance.m_bgcolor = tocolor(unpack(bgBlueRGB));
	instance.m_bghovercolor = tocolor(unpack(bgBlueButtonHoverRGB));
	instance.m_buttoncolor = instance.m_bgcolor;
	if clickEvent then 
		instance.m_clickEvent = clickEvent;
	end 
	instance.m_parent = parent;
	instance.m_type = "button";
	instance.m_deactivated = false;
	
	parent:addItem(instance);
	
	instance.clickFunc = function(btn,state) instance:click(btn,state) end;
	
	addEventHandler("onClientClick", root, instance.clickFunc);
	showCursor(true);
	
	setmetatable(instance, self);
	return instance;
end

function dxButton:getOffset()
	return {self.m_x, self.m_y};
end 

function dxButton:setOffset(x, y)
	self.m_x = x;
	self.m_y = y;
	self.m_parent:update();
end

function dxButton:setSize(w, h)
	self.m_w = w;
	self.m_h = h;
end

function dxButton:hover()
	if isCursorShowing() and not self.m_deactivated then 
		local cx, cy = getCursorPosition();
		cx, cy = cx*sX, cy*sY;
		local offset = self.m_parent:getOffset();
		if ( cx >= offset[1] + self.m_x and cx <= offset[1] + self.m_x+self.m_w and cy >= offset[2]+34+self.m_y and cy <= offset[2]+34+32+self.m_y) then 
			self.m_buttoncolor = self.m_bghovercolor;
		else 
			self.m_buttoncolor = self.m_bgcolor;
		end 
	end 
end

function dxButton:deactivate()
	if self.m_deactivated == false then 
		self.m_deactivated = true;
		self.m_buttoncolor = tocolor(unpack(bgBlueRGBDisabled));
	else 
		self.m_deactivated = false;
		self.m_buttoncolor = self.m_bgcolor;
	end 
end 

function dxButton:click(btn,state)
	if not isCursorShowing() then return end;
	if btn == "left" and state == "down" then 	
		local cx, cy = getCursorPosition();
		cx, cy = cx*sX, cy*sY;
		local offset = self.m_parent:getOffset();
		if(cx >= offset[1]+self.m_x and cx <= offset[1]+self.m_w+self.m_x and cy >= offset[2]+34+self.m_y and cy <= offset[2]+self.m_h+self.m_y+34) then
			if (self.m_clickEvent and self.m_deactivated ~= true) then 
				self.m_clickEvent();
			end
		end 
	end 
end

function dxButton:delete()
	removeEventHandler("onClientClick", root, self.clickFunc);
	if (self.m_parent) then
		self.m_parent:removeItem(self);
	end
	self = nil;
end 



function dxText:new(x, y, w, h, text, parent, center, fsize, font, fcolor, colorcoded)
	
	if not parent then return; end
	if not x then x = 0 end
	if not y then y = 0 end
	local offset = parent:getSize();
	if not w then w = offset[1]; end
	if not h then h = offset[2]; end
	if not text then text = "" end
	if not fsize then fsize = 1 end
	if not font then font = FONTS['exo-10'] end 
	if not fcolor then fcolor = tocolor(255, 255, 255, 255) end
	if not center then center = "left" end
	if not colorcoded then colorcoded = true end
	
	if (font and FONTS[font]) then font = FONTS[font]; end
	
	local instance = {};
	
	instance.m_x = x;
	instance.m_y = y;
	instance.m_w = w;
	instance.m_h = h;
	instance.m_text = text;
	instance.m_fsize = fsize;
	instance.m_font = font;
	instance.m_fcolor = fcolor;
	instance.m_parent = parent;
	instance.m_type = "text";
	instance.m_colorcoded = colorcoded;
	instance.m_halign = center;
	
	parent:addItem(instance);
	
	setmetatable(instance, self);
	return instance;
end

function dxText:setText(text)
	self.m_text = text;
	self.m_parent:update();
end 

function dxText:delete()
	if (self.m_parent) then
		self.m_parent:removeItem(self);
	end
	self = nil;
end

function dxGrid:new(x, y, w, h, parent, event, doubleevent)
	
	local instance = {};
	if not parent then return end
	if not x then x = 5; end
	if not y then y = 5; end 
	if not w then w = 200; end
	if not h then h = 200; end 
	
	instance.m_w = w;
	instance.m_h = h;
	instance.m_parent = parent;
	instance.m_Items = {
		columns = {},
		rows = {}
	};
	instance.m_hcolor = tocolor(unpack(bgBlueRGB));
	instance.m_fsize = 1;
	instance.m_font = "default-bold";
	instance.m_fcolor = tocolor(255, 255, 255, 255);
	instance.m_type = "grid";
	instance.m_x = x;
	instance.m_y = y;
	instance.m_scroll = 0;
	instance.m_selected = -1;
	instance.m_clickY = instance.m_y + parent.m_Y + 34;
	instance.m_clickX = instance.m_x + parent.m_mX;
	instance.m_event = false;
	instance.m_maxItems = math.floor(h / 20);
	if event then instance.m_event = event; end
	if doubleevent then instance.m_doubleevent = doubleevent; end
	
	instance.m_scrollFunc = function(key, state) instance:scrolling(key, state) end;
	instance.m_clickFunc = function(b, s, x, y) instance:click(b, s, x, y, false) end;
	instance.m_doubleClickFunc = function(b, x, y) instance:click(b, "down", x, y, true) end;
	showCursor(true);
	addEventHandler("onClientKey", root, instance.m_scrollFunc);
	addEventHandler("onClientClick", root, instance.m_clickFunc);
	addEventHandler("onClientDoubleClick", root, instance.m_doubleClickFunc);
	
	--parent:setGrid(instance);
	parent:addItem(instance);
	
	setmetatable(instance, self);
	return instance;
end

function dxGrid:delete()
	removeEventHandler("onClientClick", root, self.m_clickFunc);
	removeEventHandler("onClientDoubleClick", root, self.m_doubleClickFunc);
	removeEventHandler("onClientKey", root, self.m_scrollFunc);
	if (self.m_parent) then
		self.m_parent:removeItem(self);
		--self.m_parent:removeGrid();
	end
	self = nil;
end 

function dxGrid:scrolling(key, state)
	if (state ~= true) then return end
	local cx, cy = getCursorPosition();
	cx, cy = cx*sX, cy*sY;
	if ( cx >= self.m_clickX and cx <= self.m_clickX+self.m_w and cy >= self.m_clickY and cy <= self.m_clickY+self.m_h ) then 
		if key == "mouse_wheel_down" and self.m_scroll+self.m_maxItems < #self.m_Items.rows then
			self.m_scroll = self.m_scroll + 1;
		elseif key == "mouse_wheel_up" and self.m_scroll > 0 then 
			self.m_scroll = self.m_scroll - 1;
		end
	end 
end

function dxGrid:click(btn,state,cx,cy,double)
	if btn == "left" and state == "down" then
		if cx >= self.m_clickX and cx <= self.m_clickX+self.m_w and cy >= self.m_clickY and cy <= self.m_clickY+self.m_h then 
			local o = 0;
			for i = 1+self.m_scroll, self.m_maxItems+self.m_scroll do
				if self.m_Items.rows[i] then 
					if ( cx >= self.m_clickX and cx <= self.m_clickX+self.m_w and cy >= self.m_clickY+2.5+(17.5*(o))+20 and cy <= self.m_clickY+2.5+(17.5*(o))+40) then 
						self:setSelected(i);
						if (double) then
							if self.m_doubleevent then
								self.m_doubleevent() 
							end
						else
							if self.m_event then
								self.m_event() 
							end
						end
					end
				end
				o = o + 1;
			end
		end 
	end 
end

function dxGrid:updateOffset(x)
	self.m_clickX = x;
end 

function dxGrid:getOffset()
	return{self.m_Items, self.m_x+self.m_parent.m_mX, self.m_y+self.m_parent.m_Y+34, self.m_w, self.m_h};
end

function dxGrid:setOffset(x, y)
	self.m_x = x;
	self.m_y = y;
	self.m_parent:update();
end

function dxGrid:addColumn(colName)
	if not type(colName) == "table" then return end
	for i = 1, #colName do 
		table.insert(self.m_Items.columns, colName[i]);
	end 
end 

function dxGrid:addItem(itemTable)
	if not type(itemTable) == "table" then return end
	table.insert(self.m_Items.rows, itemTable);
	return #self.m_Items.rows; 
end 

function dxGrid:removeItem(id)
	if self.m_Items.rows[id] then 
		table.remove(self.m_Items.rows, id);
		return 
	end 
end

function dxGrid:removeAllItems()
	self.m_Items.rows = {};
end

function dxGrid:getAllItems()
	return self.m_Items.rows;
end  

function dxGrid:setSelected(index)
	self.m_selected = index;
end

function dxGrid:getSelected()
	return self.m_selected, self.m_Items.rows[self.m_selected];
end 



function dxEdit:new(x, y, w, h, parent, onKeyUp)
	
	local instance = {};
	--Variablen--
	instance.x = x;
	instance.y = y;
	instance.w = w;
	instance.h = (h >= 27) and h or 27;
	instance.m_type = "edit";
	instance.text = "";
	instance.font = FONTS["exo-10"]
	instance.gfont = GUIFONTS["exo-11"]
	instance.timer = false;
	instance.parent = parent;
	instance.edit = guiCreateEdit(x+parent.m_animX, y+parent.m_Y+34, w, instance.h, "", false)
	guiSetAlpha(instance.edit, 0)
	guiBringToFront(instance.edit)
	guiSetFont(instance.edit, instance.gfont)
	
	
	if onKeyUp then instance.m_event = onKeyUp; end

	instance.changeFunc = function(key, state) if (instance.m_event) then instance.m_event(guiGetText(instance.edit)); end end;
	addEventHandler("onClientGUIChanged", instance.edit, instance.changeFunc);
	
	
	--Funktionen--
	instance.clickFunc = function(btn,state,aX,aY) instance:click(btn,state,aX,aY) end;
	instance.updateFunc = function() instance:updateEdit() end;
	addEventHandler("onClientClick", root, instance.clickFunc);
	
	parent:addItem(instance);
	setmetatable(instance, self);
	return instance;
end

function dxEdit:delete()
	destroyElement(self.edit)
	removeEventHandler("onClientClick", root, self.clickFunc);
	removeEventHandler("onClientGUIChanged", root, self.changeFunc);
	
	if (self.parent) then
		self.parent:removeItem(self);
	end
	self = nil;
end

function dxEdit:updateText()
	self.text = guiGetText(self.edit)
	local tw = dxGetTextWidth(self.text, 1, self.font)
	if (tw >= (self.w-27)) then
		guiEditSetMaxLength(self.edit, string.len(self.text))
	else
		
		guiEditSetMaxLength(self.edit, 999)
	end
	self.text = guiGetText(self.edit)
end

function dxEdit:click(btn,state,cx,cy)
	if btn == "left" and state == "down" then
		local offset = self.parent:getOffset();
		offset[2] = offset[2]+34;
		if cx >= self.x+offset[1] and cx <= self.x+offset[1]+self.w and cy >= self.y+offset[2] and cy <= self.y+offset[2]+self.h  then 
			if (isElement(self.edit)) then
				guiBringToFront(self.edit)
			end
		end 
	end
end

function dxEdit:getText(t)
	return self.text;
end

function dxEdit:setText(t)
	self.text=t;
	guiSetText(self.edit, self.text)
	guiEditSetCaretIndex(self.edit, string.len(t));
end


function dxCheckbox:new(x, y, parent, selectCallback, disabled)
	
	local instance = {};
	--Variablen--
	instance.x = x;
	instance.y = y;
	instance.h = 16;
	instance.w = 16;
	instance.path = "files/images/dxgui/checkbox.png";
	instance.disabled = disabled or false;
	instance.active = false;
	instance.parent = parent;
	instance.m_type = "checkbox";
	instance.m_selectCallback = selectCallback;
	--Funktionen--
	instance.clickFunc = function(btn,state,cx,cy) instance:click(btn,state,cx,cy) end;
	--Events--
	addEventHandler("onClientClick", root, instance.clickFunc);
	--
	parent:addItem(instance);
	setmetatable(instance, self);
	return instance;
end

function dxCheckbox:delete()
	removeEventHandler("onClientClick", root, self.clickFunc);
	if (self.m_parent) then
		self.m_parent:removeItem(self);
	end
	self = nil;
end 

function dxCheckbox:click(b,s,cx,cy)
	if b == "left" and s == "down" then
		local offset = self.parent:getOffset();
		offset[2] = offset[2] + 34;
		--self.active = false;
		if cx >= offset[1] + self.x and cx <= offset[1] + self.w + self.x and cy >= offset[2] + self.y and cy <= offset[2] + self.y + self.h then 
			if (self.disabled ~= true) then
				if self.active then 
					self.path = "files/images/dxgui/checkbox.png";
				else 
					self.path = "files/images/dxgui/checkboxactive.png";
				end 
				self.active = not self.active;
				if (self.m_selectCallback) then
					self.m_selectCallback(self.active);
				end
			end
		end 
	end 
end

function dxCheckbox:isSelected()
	return self.active;
end

function dxCheckbox:setSelected(bool)
	if (bool == true) then
		self.active = true
		self.path = "files/images/dxgui/checkboxactive.png";
	else
		self.active = false
		self.path = "files/images/dxgui/checkbox.png";
	end	
end





function dxMemo:new(x, y, w, h, parent)
	
	local instance = {};
	instance.x = x;
	instance.y = y;
	instance.w = w;
	instance.h = h;
	instance.active = false;
	instance.text = "";
	instance.m_type = "memo";
	instance.font = FONTS["exo-10"]
	instance.gfont = GUIFONTS["exo-11"]
	instance.parent = parent;
	instance.showLine = false;
	instance.m_timer = false;
	instance.memo = guiCreateMemo(x+parent.m_mX, y+parent.m_Y+34, w, h, "", false)
	--guiSetAlpha(instance.memo, 200)
	guiBringToFront(instance.memo)
	guiSetFont(instance.memo, instance.gfont)
	
	instance.clickFunc = function(btn,state,cx,cy) instance:click(btn,state,cx,cy) end;
	--instance.charFunc = function(key) instance:character(key) end;
	--instance.keyFunc = function(btn,state) instance:key(btn,state) end;
	--instance.timerFunc = function() instance:timer() end;
	
	addEventHandler("onClientClick", root, instance.clickFunc);
	--addEventHandler("onClientCharacter", root, instance.charFunc);
	--addEventHandler("onClientKey", root, instance.keyFunc);
	
	parent:addItem(instance);
	setmetatable(instance, self);
	return instance;
end

function dxMemo:updateText()
	self.text = guiGetText(self.memo)
	guiBringToFront(self.memo)
	
	
	--[[local tw = dxGetTextWidth(self.text, 1, self.font)
	if (tw >= (self.w-27)) then
		guiEditSetMaxLength(self.edit, string.len(self.text))
	else
		
		guiEditSetMaxLength(self.edit, 999)
	end
	self.text = guiGetText(self.edit)]]
end

function dxMemo:delete()
	destroyElement(self.memo);
	removeEventHandler("onClientClick", root, self.clickFunc);
	--removeEventHandler("onClientCharacter", root, self.charFunc);
	--removeEventHandler("onClientKey", root, self.keyFunc);
	if isTimer(self.m_timer) then 
		killTimer(self.m_timer);
	end
	if (self.m_parent) then
		self.m_parent:removeItem(self);
	end
	self = nil;
end 

function dxMemo:click(b,s,x,y)
	if b == "left" and s == "down" then
		local offset = self.parent:getOffset();
		offset[2] = offset[2] + 34;
		if ( x >= offset[1] + self.x and x <= offset[1] + self.x + self.w and y >= offset[2] + self.y and y <= offset[2] + self.y + self.h ) then 
			--[[self.active = not self.active;
			if not self.active and isTimer(self.m_timer) then
				guiSetInputMode("allow_binds");
				killTimer(self.m_timer);
			else 
				self.showLine = true;
				guiSetInputMode("no_binds");
				self.m_timer = setTimer(self.timerFunc, 500, 0);
			end]]
			guiBringToFront(self.memo);
		end 
	end 
end

function dxMemo:getText()
	return self.text;
end
function dxMemo:setText(t)
	self.text = t;
	guiMemoSetCaretIndex(self.memo, string.len(t));
end

-- DX Button --
function dxImage:new(x, y, w, h, file, parent, color, clickFunc)
	
	if not x then x = 0 end;
	if not y then y = 0 end;
	if not w then w = 128 end;
	if not h then h = 32 end;
	if not color then color = {255, 255, 255, 255} end
	if not clickFunc then clickFunc = false; end
	parent = parent;
	
	local instance = {};
	
	instance.m_x = x;
	instance.m_y = y;
	instance.m_w = w;
	instance.m_h = h;
	instance.m_file = file;
	instance.m_color = color;
	instance.m_parent = parent;
	instance.m_type = "image";
	instance.m_deactivated = false;
	instance.m_clickEvent = clickFunc;
	
	instance.clickFunc = function(btn,state,cx,cy) instance:click(btn,state,cx,cy) end;
	
	addEventHandler("onClientClick", root, instance.clickFunc);
	
	
	parent:addItem(instance);
	
	showCursor(true);
	
	setmetatable(instance, self);
	return instance;
end

function dxImage:delete()
	if (self.m_parent) then
		self.m_parent:removeItem(self);
	end
	self = nil;
end 

function dxImage:getOffset()
	return {self.m_x, self.m_y};
end 

function dxImage:setOffset(x, y)
	self.m_x = x;
	self.m_y = y;
	self.m_parent:update();
end

function dxImage:setSize(w, h)
	self.m_w = w;
	self.m_h = h;
end

function dxImage:setImage(f)
	self.m_file = f
end
function dxImage:getImage()
	return self.m_file;
end

function dxImage:click(btn,state)
	if not isCursorShowing() then return end;
	if btn == "left" and state == "down" then 	
		local cx, cy = getCursorPosition();
		cx, cy = cx*sX, cy*sY;
		local offset = self.m_parent:getOffset();
		if(cx >= offset[1]+self.m_x and cx <= offset[1]+self.m_w+self.m_x and cy >= offset[2]+34+self.m_y and cy <= offset[2]+self.m_h+self.m_y+34) then
			if self.m_clickEvent then 
				self.m_clickEvent();
			end
		end 
	end 
end