----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local lastX, lastY = screenX/2, screenY/2
local function cursorShow(key, state)
	if (isLoggedin(localPlayer) and (getElementData(localPlayer, "clicked") == false)) then
		if (isCursorShowing()) then
			local x, y, _, _, _ = getCursorPosition()
			lastX, lastY		= x*screenX, y*screenY
			showCursor(false)
		else
			showCursor(true)
			setCursorPosition(lastX, lastY)
		end
	end
end
addEvent("cursorShow", true)
addEventHandler("cursorShow", root, cursorShow)

-- Custom cursor
setCursorAlpha(0)
addEventHandler("onClientRender", root, function()
	if (isCursorShowing() and isConsoleActive() == false and isMainMenuActive() == false) then
		local sX, sY, wX, wY, wZ = getCursorPosition()
		dxDrawImage((sX*screenX), (sY*screenY), 32, 32, "files/images/cursor.png", 0, 0, 0, tocolor(255,255,255), true)
	end
end)
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function()
	setCursorAlpha(255)
end)

local colshape = createColSphere(0, 0, 0, 0.5)
local furnClick = nil
local vendingClick = nil

local function cursorMouseOverHelp()
	furnClick = nil
	vendingClick = nil
	
	if (isCursorShowing() and (getElementData(localPlayer, "clicked") == false) and isLoggedin(localPlayer)) then
		local x, y, z								= getElementPosition(localPlayer)
		local cX, cY, cwX, cwY, cwZ					= getCursorPosition()
		local pX, pY, pZ							= getCameraMatrix(localPlayer)
		local textLeft, textMiddle, textRight, show = ".", ".", ".", false
		local hit, hX, hY, hZ, hitElement, nX, nY, nZ, material, lightning, piece, worldModelID, worldModelPos, worldModelRot, worldLODModelID = processLineOfSight(pX, pY, pZ, cwX, cwY, cwZ, true, true, true, true, true, false, false, false, nil, true, true)
		
		if (not hitElement) then
			if (hZ) then
				for i = 0, 10 do
					setElementPosition(colshape, hX, hY, hZ+i)
					setElementInterior(colshape, getElementInterior(localPlayer))
					setElementDimension(colshape, getElementDimension(localPlayer))
					local obj = getElementsWithinColShape(colshape, "object")[1]
					
					if (obj) then
						if (getElementData(obj, "furnitureObject") == true) then
							hit = true
							hitElement = obj
							furnClick = obj
							break
						end
					end
				end
			end
		end
		
		if ((not hX or not hY or not hZ) or getDistanceBetweenPoints3D(x, y, z, hX, hY, hZ) < 15) then
			if (hit and ( (hitElement and isElement(hitElement)) or (tonumber(worldModelID) ~= nil) )) then
				
				local modelID	= 0
				local eType		= ""
				if (hitElement) then
					modelID	= getElementModel(hitElement)
					eType	= getElementType(hitElement)
				else -- WorldObject
					modelID		= worldModelID
					eType		= "object"
					hitElement	= nil
				end
				
				if (eType == "vehicle") then
					if (getElementData(hitElement, "playerCar") == true) then
						if (getElementData(hitElement, "inTuning") == false) then
							local hasKey = false
							local keys = getElementData(hitElement, "vkeys")
							if (keys) then
								local json = fromJSON(keys)
								if (json[getPlayerName(localPlayer)] == true) then
									hasKey = true
								end
							end
							if (getElementData(hitElement, "owner") == getPlayerName(localPlayer) or hasKey) then
								textLeft = "Fahrzeuginfos"
								textMiddle = "Kofferaum"
								textRight = "Auf- / Abschliessen"
							else
								textLeft = "Fahrzeuginfos"
								textMiddle = false
								textRight = false
						end	
							show = true
						end
					end
					
				elseif (eType == "player") then
					if (hitElement == localPlayer) then
						textLeft = "Eigenmenü"
						textMiddle = false
						textRight = false
						show = true
					else
						textLeft = "Spielerinfos"
						textMiddle = false
						textRight = "Handeln"
						show = true
					end
					
				elseif (eType == "ped") then
						textLeft = "Interagieren"
						textMiddle = false
						textRight = false
						show = true
						
				elseif (eType == "object") then
					
					
					if (hitElement and getElementData(hitElement, "furnitureObject") == true) then
						textLeft = "Info"
						textMiddle = "Aufheben"
						textRight = "Bewegen"
						show = true
						
					elseif (hitElement and modelID == 3409 and getElementData(hitElement, "weed") == true) then
						textLeft = "Ernten"
						textMiddle = false
						textRight = false
						show = true
						
					elseif (modelID == 2942 or modelID == 3903) then -- ATM
						textLeft = "Öffnen"
						textMiddle = false
						textRight = false
						show = true
						
					elseif (modelID == 2886) then -- Keypad
						textLeft = "Öffnen / Schliessen"
						textMiddle = false
						textRight = false
						show = true
						
					elseif (modelID == 1656 and getElementData(hitElement, "fuelTyp") ~= false) then -- Tankstelle maus hit object
						local txt = ""
						local typ = getElementData(hitElement, "fuelTyp")
						if (typ == "diesel") then
							txt = "Diesel"
						elseif (typ == "petrol") then
							txt = "Super"
						elseif (typ == "elektro") then
							txt = "Elektro"
						end
						textLeft = txt
						textMiddle = false
						textRight = false
						show = true
						
					elseif (hitElement and (modelID == 1829 or modelID == 2332) --[[and tonumber(getElementData(hitElement, "isVault")) >= 0]]) then -- bank tresor
						local state = getElementData(hitElement, "state")
						textLeft = false
						show = true
						if (state == "closed") then
							textLeft = "Öffnen"
						elseif (state == "open") then
							textLeft = "Tresor leeren"
						else
							show = false
						end
						textMiddle = false
						textRight = false
					
					elseif (modelID == 955 or modelID == 1775 or modelID == 1302 or modelID == 1209) then -- Sprunk Automat
						textLeft = "Sprunk Kaufen X$"
						textMiddle = false
						textRight = false
						show = true
						vendingClick = modelID
						
					elseif (modelID == 956 or modelID == 1776) then -- Candy Automat
						textLeft = "Schokoriegel Kaufen X$"
						textMiddle = false
						textRight = false
						show = true
						vendingClick = modelID
						
					elseif (modelID == 18214) then -- Candy Automat
						textLeft = "Zigaretten Kaufen X$"
						textMiddle = false
						textRight = false
						show = true
						vendingClick = modelID
						
					end
				end
				
				if (show == true) then
					if textLeft then
						dxDrawImage((screenX*cX)-50, (screenY*cY)-6, 32, 32, "files/images/mouse/left_mouse.png")
						dxDrawText(textLeft, ((screenX*cX)-100)+1, ((screenY*cY)+25)+1, ((screenX*cX)+34)+1, ((screenY*cY)+66)+1, tocolor(0, 0, 0), 1, "default-bold", "center", "top")
						dxDrawText(textLeft, (screenX*cX)-100, (screenY*cY)+25, (screenX*cX)+34, (screenY*cY)+66, tocolor(255, 255, 255), 1, "default-bold", "center", "top")
					end
					
					if textMiddle then
						dxDrawImage((screenX*cX), (screenY*cY)+45, 32, 32, "files/images/mouse/middle_mouse.png")
						dxDrawText(textMiddle, ((screenX*cX)-16)+1, ((screenY*cY)+76)+1, ((screenX*cX)+50)+1, ((screenY*cY)+16)+1, tocolor(0, 0, 0), 1, "default-bold", "center", "top")
						dxDrawText(textMiddle, (screenX*cX)-16, (screenY*cY)+76, (screenX*cX)+50, (screenY*cY)+16, tocolor(255, 255, 255), 1, "default-bold", "center", "top")
					end
					
					if textRight then
						dxDrawImage((screenX*cX)+50, (screenY*cY)-6, 32, 32, "files/images/mouse/right_mouse.png")
						dxDrawText(textRight, ((screenX*cX)+34)+1, ((screenY*cY)+25)+1, ((screenX*cX)+100)+1, ((screenY*cY)+66)+1, tocolor(0, 0, 0), 1, "default-bold", "center", "top")
						dxDrawText(textRight, (screenX*cX)+34, (screenY*cY)+25, (screenX*cX)+100, (screenY*cY)+66, tocolor(255, 255, 255), 1, "default-bold", "center", "top")
					end	
				end
				
			end
		end
	end
end
addEventHandler("onClientRender", root, cursorMouseOverHelp)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (clickedElement and isElement(clickedElement) and getElementModel(clickedElement) == 1656 and getElementData(clickedElement, "fuelTyp") ~= false and state == "up" and isPedInVehicle(localPlayer)) then
		if (canChangeFuelTyp) then
			typ = getElementData(clickedElement, "fuelTyp")
			if (curFuelTyp ~= typ) then
				local eTyp = getVehicleHandling(getPedOccupiedVehicle(localPlayer))["engineType"]
				if ((eTyp ~= "electric" and typ == "elektro") or (eTyp == "electric" and typ ~= "elektro")) then
					notificationShow("error", "Du kannst diesen Kraftstoff nicht tanken.")
				else
					curFuelTyp = getElementData(clickedElement, "fuelTyp")
					gasPump = getElementData(clickedElement, "parent")
					infoShow("info", "Halte die Leertaste gedrückt um zu Tanken.")
				end
			end
		end
		
	elseif (furnClick) then
		triggerServerEvent("onPlayerClickFurn", localPlayer, button, state, furnClick, worldX, worldY, worldZ, absoluteX, absoluteY)
		
	elseif (vendingClick) then
		if (state == "up" and button == "left") then
			triggerServerEvent("useVendingMachine", localPlayer, vendingClick)
		end
	end
end)














Vector3D = {
	new = function(self, _x, _y, _z)
		local newVector = { x = _x or 0.0, y = _y or 0.0, z = _z or 0.0 }
		return setmetatable(newVector, { __index = Vector3D })
	end,

	Copy = function(self)
		return Vector3D:new(self.x, self.y, self.z)
	end,

	Normalize = function(self)
		local mod = self:Module()
		self.x = self.x / mod
		self.y = self.y / mod
		self.z = self.z / mod
	end,

	Dot = function(self, V)
		return self.x * V.x + self.y * V.y + self.z * V.z
	end,

	Module = function(self)
		return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	end,

	AddV = function(self, V)
		return Vector3D:new(self.x + V.x, self.y + V.y, self.z + V.z)
	end,

	SubV = function(self, V)
		return Vector3D:new(self.x - V.x, self.y - V.y, self.z - V.z)
	end,

	CrossV = function(self, V)
		return Vector3D:new(self.y * V.z - self.z * V.y,
		                    self.z * V.x - self.x * V.z,
				    self.x * V.y - self.y * V.z)
	end,

	Mul = function(self, n)
		return Vector3D:new(self.x * n, self.y * n, self.z * n)
	end,

	Div = function(self, n)
		return Vector3D:new(self.x / n, self.y / n, self.z / n)
	end,
}

collisionTest = { }

collisionTest.Rectangle = function(lineStart, lineEnd, rectangleCenter, sizeX, sizeY )
    -- check if line intersects rectangle around element
	local ratio = rectangleCenter.z / lineEnd.z
	
	lineEnd.x = rectangleCenter.x * lineEnd.x
	lineEnd.y = rectangleCenter.y * lineEnd.y
	lineEnd.z = rectangleCenter.z
	
	if lineEnd.x < (rectangleCenter.x + sizeX/2) and lineEnd.x > (rectangleCenter.x - sizeX/2) then
		if lineEnd.y < (rectangleCenter.y + sizeY/2) and lineEnd.y > (rectangleCenter.y - sizeY/2) then
			return lineEnd
		end
	end
end

collisionTest.Sphere = function(lineStart, lineEnd, sphereCenter, sphereRadius)
        -- check if line intersects sphere around element
	local vec = Vector3D:new(lineEnd.x - lineStart.x, lineEnd.y - lineStart.y, lineEnd.z - lineStart.z)

	local A = vec.x^2 + vec.y^2 + vec.z^2
	local B = ( (lineStart.x - sphereCenter.x) * vec.x + (lineStart.y - sphereCenter.y) * vec.y + (lineStart.z - sphereCenter.z) * vec.z ) * 2
	local C = ( (lineStart.x - sphereCenter.x)^2 + (lineStart.y - sphereCenter.y)^2 + (lineStart.z - sphereCenter.z)^2 ) - sphereRadius^2

	local delta = B^2 - 4*A*C

	if (delta >= 0) then
		delta = math.sqrt(delta)
		local t = (-B - delta) / (2*A)

		if (t > 0) then
			return Vector3D:new(lineStart.x + vec.x * t, lineStart.y + vec.y * t, lineStart.z + vec.z * t)
		end
	end
end

collisionTest.Cylinder = function(lineStart, lineEnd, cylCenter, cylRadius, cylHeight)
	local kU = Vector3D:new(1, 0, 0)
	local kV = Vector3D:new(0, 1, 0)
	local kW = Vector3D:new(0, 0, 1)
	local rkDir = lineEnd:SubV(lineStart)
	rkDir:Normalize()

	local afT = { 0.0, 0.0 }

	local fHalfHeight = cylHeight * 0.5
	local fRSqr = cylRadius * cylRadius

	local kDiff = lineStart:SubV(cylCenter)
	local kP = Vector3D:new(kU:Dot(kDiff), kV:Dot(kDiff), kW:Dot(kDiff))

	local fDz = kW:Dot(rkDir)

	if (math.abs(fDz) >= 1.0 - ZERO_TOLERANCE) then
		local fRadialSqrDist = fRSqr - kP.x * kP.x - kP.y * kP.y
		if (fRadialSqrDist < 0.0) then
			return nil
		end

		if (fDz > 0.0) then
			afT[1] = -kP.z - fHalfHeight
			if afT[1] < 0 then return nil end
			return lineStart:AddV(rkDir:Mul(afT[1]))
		else
			afT[1] = kP.z - fHalfHeight
			if afT[1] < 0 then return nil end
			return lineStart:AddV(rkDir:Mul(afT[1]))
		end
	end

	local kD = Vector3D:new(kU:Dot(rkDir), kV:Dot(rkDir), fDz)
	local fA0, fA1, fA2, fDiscr, fRoot, fInv, fT

	if (math.abs(kD.z) <= ZERO_TOLERANCE) then
		if (math.abs(kP.z) > fHalfHeight) then
			return nil
		end

		fA0 = kP.x * kP.x + kP.y * kP.y - fRSqr
		fA1 = kP.x * kD.x + kP.y * kD.y
		fA2 = kD.x * kD.x + kD.y * kD.y
		fDiscr = fA1 * fA1 - fA0 * fA2

		if (fDiscr < 0.0) then
			return nil
		
		elseif (fDiscr > ZERO_TOLERANCE) then
			fRoot = math.sqrt(fDiscr)
			fInv = 1.0 / fA2
			afT[1] = (-fA1 - fRoot) * fInv

			if afT[1] < 0 then return nil end
			return lineStart:AddV(rkDir:Mul(afT[1]))
		else
			afT[1] = -fA1 / fA2
			if afT[1] < 0 then return nil end
			return lineStart:AddV(rkDir:Mul(afT[1]))
		end
	end

	local iQuantity = 0
	fInv = 1.0 / kD.z

	local fT0 = (-fHalfHeight - kP.z) * fInv
	local fXTmp = kP.x + fT0 * kD.x
	local fYTmp = kP.y + fT0 * kD.y
	if (fXTmp * fXTmp + fYTmp * fYTmp <= fRSqr) then
		iQuantity = iQuantity + 1
		afT[iQuantity] = fT0
	end

	local fT1 = (fHalfHeight - kP.z) * fInv
	fXTmp = kP.x + fT1 * kD.x
	fYTmp = kP.y + fT1 * kD.y
	if (fXTmp * fXTmp + fYTmp * fYTmp <= fRSqr) then
		iQuantity = iQuantity + 1
		afT[iQuantity] = fT1
	end

	if (iQuantity == 2) then
		if (afT[1] > afT[2]) then
			local fSave = afT[1]
			afT[1] = afT[2]
			afT[2] = fSave
		end

		if afT[1] < 0 then return nil end
		return lineStart:AddV(rkDir:Mul(afT[1]))
	end

	fA0 = kP.x * kP.x + kP.y * kP.y - fRSqr
	fA1 = kP.x * kD.x + kP.y * kD.y
	fA2 = kD.x * kD.x + kD.y * kD.y
	fDiscr = fA1 * fA1 - fA0 * fA2
	if (fDiscr < 0.0) then
		return nil

	elseif (fDiscr > ZERO_TOLERANCE) then
		fRoot = math.sqrt(fDiscr)
		fInv = 1.0 / fA2
		fT = (-fA1 - fRoot) * fInv
		if (fT0 <= fT1) then
			if (fT0 <= fT and fT <= fT1) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		else
			if (fT1 <= fT and fT <= fT0) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		end

		if (iQuantity == 2) then
			if (afT[1] > afT[2]) then
				local fSave = afT[1]
				afT[1] = afT[2]
				afT[2] = fSave
			end

			if afT[1] < 0 then return nil end
			return lineStart:AddV(rkDir:Mul(afT[1]))
		end

		fT = (-fA1 + fRoot) * fInv
		if (fT0 <= fT1) then
			if (fT0 <= fT and fT <= fT1) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		else
			if (fT1 <= fT and fT <= fT0) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		end
	else
		fT = -fA1 / fA2
		if (fT0 <= fT1) then
			if (fT0 <= fT and fT <= fT1) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		else
			if (fT1 <= fT and fT <= fT0) then
				iQuantity = iQuantity + 1
				afT[iQuantity] = fT
			end
		end
	end

	if (iQuantity == 2) then
		if (afT[1] > afT[2]) then
			local fSave = afT[1]
			afT[1] = afT[2]
			afT[2] = fSave
		end

		if afT[1] < 0 then return nil end
		return lineStart:AddV(rkDir:Mul(afT[1]))
	elseif (iQuantity == 1) then
		if afT[1] < 0 then return nil end
		return lineStart:AddV(rkDir:Mul(afT[1]))
	end

	return nil
end

local g_colless = {}
local isColless = {
	marker = true,
	vehicle = true,
	pickup = true,
	ped = true,
	water = true,
}
local hitComponents = function (hit)
	if hit then return hit.x, hit.y, hit.z
	else return nil end
end
local commonIntersection = function (startX, startY, startZ, endX, endY, endZ, centerX, centerY, centerZ, element)
	local _start = Vector3D:new(startX, startY, startZ)
	local _end = Vector3D:new(endX, endY, endZ)
	local _center = Vector3D:new(centerX, centerY, centerZ)

	local elementType = getElementType(element)
	local radius
	if (elementType == "pickup") then
		radius = 1
	elseif (elementType == "marker") then
		radius = getMarkerSize(element)
	else
		radius = getElementRadius(element)
	end
	return hitComponents(collisionTest.Sphere(_start, _end, _center, radius))
end
local specialIntersections = {
	marker = function (startX, startY, startZ, endX, endY, endZ, centerX, centerY, centerZ, element)
		local markerType = getMarkerType(element)
		local _start = Vector3D:new(startX, startY, startZ)
		local _end = Vector3D:new(endX, endY, endZ)
		local _center = Vector3D:new(centerX, centerY, centerZ)
		local size = getMarkerSize(element)

		if markerType == "corona" or markerType == "ring" or markerType == "arrow" then
			return hitComponents(collisionTest.Sphere(_start, _end, _center, size))
		elseif markerType == "cylinder" then
			return hitComponents(collisionTest.Cylinder(_start, _end, _center, size, size))
		elseif markerType == "checkpoint" then
			return hitComponents(collisionTest.Cylinder(_start, _end, _center, size, 60 * size))
		end
	end,
	water = function (startX, startY, startZ, endX, endY, endZ, centerX, centerY, centerZ, element)
		local _start = Vector3D:new(startX, startY, startZ)
		local _end = Vector3D:new(endX, endY, endZ)
		local _center = Vector3D:new(centerX, centerY, centerZ)
		--
		local x1 = getWaterVertexPosition ( element, 1 )
		local x2,y1 = getWaterVertexPosition ( element, 2 )
		--
		sizeX = x2 - x1
		--
		local _,y2 = getWaterVertexPosition ( element, 3 )
		sizeY = y2 - y1
		
		return hitComponents(collisionTest.Rectangle(_start, _end, _center, sizeX, sizeY))
	end,
}
function processLineForElements(startX, startY, startZ, endX, endY, endZ)
	local foundElement = false
	local hitX, hitY, hitZ = nil, nil, nil
	--limit foundElementDistance to distance to endpoint because the collision check goes past the endpoint for some reason
	local foundElementDistance = math.sqrt((endX-startX)^2 + (endY-startY)^2 + (endZ-startZ)^2)
	for v in pairs(g_colless) do
		while true do
			if (not isElementStreamedIn(v)) then
				break
			end
			--forget elements that have been destroyed
			if not isElement(v) then
				g_colless[v] = nil
				break
			end
			--ignore if it's in a different dimension
			if getElementDimension(v) ~= getElementDimension(localPlayer) then
				break
			end
			
			--ignore if its not a valid type
			local strType = getElementType(v)
			if not isColless[strType] and strType ~= "object" then
				g_colless[v] = nil
				break
			end

			--ignore if it's in a different interior
			if getElementInterior(v) ~= getElementInterior(localPlayer) then
				break
			end
			local centerX, centerY, centerZ = getElementPosition(v)
			local distance = math.sqrt((centerX-startX)^2 + (centerY-startY)^2 + (centerZ-startZ)^2)

			if (distance <= foundElementDistance) then
				local intersection = specialIntersections[getElementType(v)] or commonIntersection
				local _hitX, _hitY, _hitZ = intersection(startX, startY, startZ, endX, endY, endZ, centerX, centerY, centerZ, v)

				if _hitX then
					foundElement = v
					foundElementDistance = distance
					hitX = _hitX
					hitY = _hitY
					hitZ = _hitZ
				end
			end
			break
		end
	end
	return foundElement, hitX, hitY, hitZ
end

function streamInCollessObjects()
	if getElementType(source) == "object" then
		g_colless[source] = true
	end
end

function streamOutCollessObjects()
	if getElementType(source) == "object" then
		g_colless[source] = nil
	end
end
addEventHandler ( "onClientElementStreamIn", root, streamInCollessObjects )
addEventHandler ( "onClientElementStreamOut", root, streamOutCollessObjects )