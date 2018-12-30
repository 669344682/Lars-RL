----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

for _, index in pairs(getElementsByType("player")) do
	setPlayerNametagShowing(index, false)
end
setPlayerNametagShowing(localPlayer, false)

addEventHandler("onClientPlayerJoin", root, function()
	setPlayerNametagShowing(source, false)
end)


local nametag		= {}
nametag.data		= {}
nametag.peds		= {}

nametag.range		= 40
nametag.nameFont	= dxCreateFont("files/fonts/harabara.ttf", 25)
nametag.nameFont2	= dxCreateFont("files/fonts/harabara.ttf", 20)


function nametag:streamInOut()
	if (getElementType(source) == "player" and isLoggedin(source) and not isPedDead(source)) then
		if (eventName == "onClientElementStreamIn") then
			self.data[source] = true
		else
			self.data[source] = false
		end
		
	elseif (getElementType(source) == "ped" and getElementData(source, "firstLastName")) then
		if (eventName == "onClientElementStreamIn") then
			self.peds[source] = getElementData(source, "firstLastName")
		else
			self.peds[source] = nil
		end
	end
end
addEventHandler("onClientElementStreamIn", root, function(...) nametag:streamInOut(...) end)
addEventHandler("onClientElementStreamOut", root, function(...) nametag:streamInOut(...) end)

function nametag:refresh()
	for player, data in pairs(self.data) do
		if (type(data) == "table" or data == true) then
			if (isElement(player) and not isPedDead(player)) then
			
				self.data[player] = {}
				self.data[player].imgs = {}
				
				if (getElementData(player, "writing") == true) then
					self.data[player]["writing"] = true
				end
				
				if (getElementData (player, "afk") == true) then
					self.data[player]["afk"] = true
				end
				
				self.data[player]["SocialState"] = getElementData(player, "SocialState")
				self.data[player]["NametagText"] = getPlayerNametagText(player)
				
				if (tonumber(getElementData(player, "Adminlvl")) >= 1) then
					self.data[player].imgs["team"] = true
				end
				
				--[[if (getElementData(player, "faction") == "1") then
					self.data[player].imgs["state"] = true
				end
				if (tonumber(getElementData(player, "playingtime")) < 300) then
					self.data[player].imgs["noob"] = true
				end
				if (getElementData(player, "afk")) then
					self.data[player].imgs["afk"] = true
				end--]]
				if (getPedArmor(player) >= 1) then
					self.data[player].imgs["armour"] = true
				end
				--[[if (getElementData(player, "gasmaske")) then
					self.data[player].imgs["gasmaske"] = true
				end
				if (getElementData(player, "married")) then
					self.data[player].imgs["married"] = true
				end--]]
				
			end
		end
	end
end
setTimer(function(...) nametag:refresh(...) end, 250, 0)

function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end

local renderTarget = dxCreateRenderTarget(sx, sy, true)
function nametag:display()
	if (not isLoggedin()) then return end
	
	dxSetRenderTarget(renderTarget, true)
	
	for key, index in pairs(self.data) do
		if (type(index) == "table" and isElement(key) and isLoggedin(key) and key ~= localPlayer) then
			local x, y, z = getElementPosition(key)
			if (x and y and z) then
				
				local cX, cY, cZ = getElementPosition(getCamera())
				if (isLineOfSightClear(cX, cY, cZ, x, y, z, true, false, false, false)) then
					local dist = getDistanceBetweenPoints3D(x, y, z, cX, cY, cZ)
					if (dist <= self.range) then
						
						-- 100 * 10 / 40 = 25
						-- 100 / 40 * 10 = 25
						--
						local percent	= ((100 * dist) / self.range)
						local percent1	= (100-percent) / 100
						local scale		= math.lerp(0.5,1.0,percent1)
						
						local bX, bY, bZ = getPedBonePosition(key, 6)
						local sx, sy = getScreenFromWorldPosition(bX, bY, (bZ + 0.3) + math.lerp(0,0.8,(percent/100)))
						if (sx and sy) then
							local r, g, b = nametag:calcRGBByHP(key)
							
							if (isChatBoxInputActive()) then
								setElementData(localPlayer, "writing", true)
							else
								setElementData(localPlayer, "writing", false)
							end
							
							local socialState = index["SocialState"]
							if (index["writing"] == true) then
								socialState = "schreibt..."
							end
							
							local NametagText = index["NametagText"]
							if (index["afk"] == true) then
								NametagText = NametagText.." [AFK]"
							end
							
							dxDrawText(NametagText, sx, sy, sx, sy, tocolor(0, 0, 0, 255), 0.8*scale, self.nameFont, "center", "center")
							dxDrawText(NametagText, sx - 2, sy - 2, sx, sy, tocolor(r, g, b, 255), 0.8*scale, self.nameFont, "center", "center")
							dxDrawText(socialState, sx, sy + (45*scale), sx, sy, tocolor(0, 0, 0, 255), 0.5*scale, self.nameFont2, "center", "center")
							dxDrawText(socialState, sx - 2, sy - 1 + (45*scale), sx, sy, tocolor(200, 200, 50, 255), 0.5*scale, self.nameFont2, "center", "center")			
							
							local imgCount = 0
							local imgsDrawn = 0
							for k, v in pairs(index.imgs) do
								if (v == true) then
									imgCount = imgCount + 1
								end
							end
							
							for k, v in pairs(index.imgs) do
								if (v == true) then
									if (imgCount/2 == math.floor(imgCount/2)) then
										dxDrawImage(sx + (25*scale) * (imgsDrawn) - imgCount * (25*scale) + (25*scale), sy + (35*scale), (25*scale), (25*scale), "files/images/nametag/"..k..".png")
										imgsDrawn = imgsDrawn + 1
									else
										dxDrawImage(sx + (25*scale) * (imgsDrawn) - imgCount * (25*scale) / 2, sy + (35*scale), (25*scale), (25*scale), "files/images/nametag/"..k..".png")
										imgsDrawn = imgsDrawn + 1
									end
								end
							end
							
						end
					end
				end
			end
		end
	end
	
	for ped, data in pairs(self.peds) do
		if (ped and isElement(ped)) then
			local x, y, z = getElementPosition(ped)
			if (x and y and z) then
				
				local cX, cY, cZ = getElementPosition(getCamera())
				if (isLineOfSightClear(cX, cY, cZ, x, y, z, true, false, false, false)) then
					local dist = getDistanceBetweenPoints3D(x, y, z, cX, cY, cZ)
					if (dist <= self.range) then
						
						-- 100 * 10 / 40 = 25
						-- 100 / 40 * 10 = 25
						--
						local percent	= ((100 * dist) / self.range)
						local percent1	= (100-percent) / 100
						local scale		= math.lerp(0.5,1.0,percent1)
						
						local bX, bY, bZ = getPedBonePosition(ped, 6)
						local sx, sy = getScreenFromWorldPosition(bX, bY, (bZ+0.1) + math.lerp(0,0.8,(percent/100)))
						if (sx and sy) then
							
							dxDrawText(data, sx, sy, sx, sy, tocolor(0, 0, 0, 255), 0.5*scale, self.nameFont, "center", "center")
							dxDrawText(data, sx - 2, sy - 2, sx, sy, tocolor(255, 155, 0, 255), 0.5*scale, self.nameFont, "center", "center")
							
						end
					end
				end
				
			end
		end
	end
	
	dxSetRenderTarget()
	dxDrawImage(0, 0, sx, sy, renderTarget)
end
addEventHandler("onClientRender", root, function(...) nametag:display(...) end)

function nametag:calcRGBByHP(player)
	local hp = getElementHealth(player)
	local armor = getPedArmor(player)
	
	if (hp <= 0) then
		return 0, 0, 0
	else
		if (armor > 0) then
			armor = math.abs(armor - 0.01)
			return 0 + (2.55*armor), (255), 0 + (2.55*armor)
		else
			hp = math.abs(hp - 0.01)
			return (100 - hp) * 2.55 / 2, (hp * 2.55), 0
		end
	end
end