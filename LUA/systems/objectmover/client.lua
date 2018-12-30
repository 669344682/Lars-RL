----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local currentObject			= nil
local plotRadius			= nil
local isPlayerInHouse		= false
--local furnitureHitted		= nil
--local playerColsphere		= createColSphere(0, 0, 0, 3)
local objectType			= "furniture"
local oldPosition			= nil
local hasPos				= false
local ooX, ooY, ooZ			= 0, 0, 0
local viewMode				= "air"

function objectPlaceStart(objectID, isInHouse, typ, oldPos)
	if (currentObject == nil) then
		--[[local fix = "\nMit den Pfeiltasten sowie den Bild-Auf und -Ab Tasten kannst Du die Ansicht der Vogelperspektive ändern.\nMit einem Linksklick plazierst Du das Objekt."
		if (isInHouse == true) then fix="" end
		notificationShow("info", "Du kannst das Objekt mit der Maus bewegen und mit dem Scrollrad rotieren."..fix.."\nMit der Leertaste kannst Du das platzieren abbrechen.", 15)]]
		
		guiSetInputMode("no_binds")
		
		local fix = ""
		if (isInHouse) then
			fix = "V = Ansicht wechseln\n"
		end
		notificationShow("info", "\nMaus / Scrollrad = Bewegen / Rotieren\n"..fix.."Pfeiltasten u. +/-: Ansicht ändern\nLinke Maus = Objekt platzieren\nLeertaste = Abbrechen", 15)
		
		currentObject		= createObject(objectID, 0, 0, 0)
		setElementDimension(currentObject, getElementDimension(localPlayer))
		setElementInterior(currentObject, getElementInterior(localPlayer))
		
		local pX, pY, pZ	= getElementPosition(localPlayer)
		local oX, oY, oZ	= pX, pY, pZ+1
		if (type(oldPos) == "table") then
			oX, oY, oZ = oldPos[1], oldPos[2], oldPos[3]
			setElementRotation(currentObject, 0, 0, oldPos[4])
		end
		setElementPosition(currentObject, oX, oY, oZ)
		setElementCollisionsEnabled(currentObject, false)
		
		
		setCameraClip(false, false)
		
		isPlayerInHouse = isInHouse
		objectType		= typ
		oldPosition		= oldPos
		hasPos			= false
		
		
		if (isPlayerInHouse) then
			viewMode	= "player"
		else
			viewMode 	= "air"
			setCameraMatrix(pX, pY, pZ+15, pX, pY, pZ)
		end
		
		triggerServerEvent("checkIfPlayerOnHousePlot", localPlayer)
	end
end
addEvent("objectPlaceStart", true)
addEventHandler("objectPlaceStart", root, objectPlaceStart)

addEvent("receiveCheckIfPlayerOnHousePlot", true)
addEventHandler("receiveCheckIfPlayerOnHousePlot", root, function(radius)
	plotRadius = radius
end)

local oldPx, oldPy, oldPz = nil, nil, nil
addEventHandler("onClientRender", root, function()
	if (currentObject ~= nil) then
		showCursor(true)
		
		if (hasPos) then return end
		
		renderGridlines(currentObject)
		
		local uX, uY, uZ			= getElementPosition(localPlayer)
		local cX, cY, cwX, cwY, cwZ	= getCursorPosition()
		local pX, pY, pZ			= getCameraMatrix(localPlayer)
		local massDist				= getElementDistanceFromCentreOfMassToBaseOfModel(currentObject)
		
		local bool, oX, oY, oZ, hit = processLineOfSight(pX, pY, pZ, cwX, cwY, cwZ, true, true, false, false, false, false, false, false, currentObject, false, false)
		if (not bool) then
			oX, oY, oZ = cwX, cwY, cwZ
		end
		
		local _oZ = oZ + massDist
		setElementPosition(currentObject, oX, oY, _oZ)
		
		local eX, eY, eZ						= getElementPosition(currentObject)
		local bMinX, bMinY, _, bMaxX, bMaxY, _	= getElementBoundingBox(currentObject)
		if (bMinX < 0) then bMinX = bMinX*-1 end
		if (bMinY < 0) then bMinY = bMinY*-1 end
		
		if (type(plotRadius) == "table") then
			local x1, y1, x2, y2, x3, y3, x4, y4 = unpack(plotRadius)
			dxDrawLine3D(x1, y1, -10, x1, y1, 500, tocolor(255,0,0), 10)
			dxDrawLine3D(x2, y2, -10, x2, y2, 500, tocolor(255,0,0), 10)
			dxDrawLine3D(x3, y3, -10, x3, y3, 500, tocolor(255,0,0), 10)
			dxDrawLine3D(x4, y4, -10, x4, y4, 500, tocolor(255,0,0), 10)
			
			local oZ = getGroundPosition(getElementPosition(localPlayer))
			for i = 0, 50, 5 do
				dxDrawLine3D(x1, y1, oZ+i, x2, y2, oZ+i, tocolor(255,0,0), 10)
				dxDrawLine3D(x2, y2, oZ+i, x3, y3, oZ+i, tocolor(255,0,0), 10)
				dxDrawLine3D(x3, y3, oZ+i, x4, y4, oZ+i, tocolor(255,0,0), 10)
				dxDrawLine3D(x4, y4, oZ+i, x1, y1, oZ+i, tocolor(255,0,0), 10)
			end
		end
	end
end)


function rotateTheObject(btn, press)
	if (press ~= true) then return end
	
	if (currentObject ~= nil) then
		
		local orX, orY, orZ				= getElementRotation(currentObject)
		local pX, pY, pZ, pX2, pY2, pZ2	= getCameraMatrix(localPlayer)
		local oX, oY, oZ				= getElementPosition(currentObject)
		
		if (btn == "mouse_wheel_up") then
			orZ = orZ + 1
		elseif (btn == "mouse_wheel_down") then
			orZ = orZ - 1
			
		elseif (btn == "num_sub") then
			if (hasPos) then
				oZ = oZ - .1
			else
				local a = 1
				if (isPlayerInHouse) then a = 0.2 end
				pZ = pZ + a
			end
			
		elseif (btn == "num_add") then
			if (hasPos) then
				oZ = oZ + .1
			else
				local a = 1
				if (isPlayerInHouse) then a = 0.2 end
				pZ = pZ - a
			end
			
		elseif (btn == "arrow_u") then
			if (hasPos) then
				oX = oX + .1
			else
				pX = pX + 1
			end
		elseif (btn == "arrow_d") then
			if (hasPos) then
				oX = oX - .1
			else
				pX = pX - 1
			end
		elseif (btn == "arrow_l") then
			if (hasPos) then
				oY = oY + .1
			else
				pY = pY + 1
			end
		elseif (btn == "arrow_r") then
			if (hasPos) then
				oY = oY - .1
			else
				pY = pY - 1
			end
			
		elseif (btn == "v") then
			if (isPlayerInHouse) then
				if (viewMode == "air") then
					viewMode = "player"
					setCameraTarget(localPlayer, localPlayer)
				else
					viewMode = "air"
					local x, y, z = getElementPosition(localPlayer)
					setCameraMatrix(x, y, z+2, x, y, z)
				end
			end
			
		elseif (btn == "mouse1" or btn == "enter") then
			if (hasPos and btn == "enter") then
				showCursor(false)
				setCameraTarget(localPlayer, localPlayer)
				setCameraClip(true, true)
				
				local x, y, z = getElementPosition(currentObject)
				if (objectType == "furniture") then
					triggerServerEvent("placeObject", localPlayer, getElementModel(currentObject), x, y, z, orX, orY, orZ)
				elseif (objectType == "garage") then
					triggerServerEvent("placeNewGarage", localPlayer, x, y, z, orX, orY, orZ)
				end
				destroyElement(currentObject)
				
				currentObject = nil
				isPlayerInHouse = false
				
				guiSetInputMode("allow_binds")
				
				return;
				
			elseif (not hasPos and btn == "mouse1") then
				hasPos = true
				notificationShow("success", "Mit den Pfeiltasten und +/- Tasten kannst Du die Position leicht korrigieren.\nEnter zum platzieren.")
				ooX, ooY, ooZ = getElementPosition(currentObject)
			end
			
		elseif (btn == "space") then
			showCursor(false)
			setCameraTarget(localPlayer, localPlayer)
			setCameraClip(true, true)
			
			if (oldPosition ~= nil) then
				local oX, oY, oZ, orZ = unpack(oldPosition)
				triggerServerEvent("placeObject", localPlayer, getElementModel(currentObject), oX, oY, oZ, 0, 0, orZ)
			end
			
			destroyElement(currentObject)
			guiSetInputMode("allow_binds")
			
			currentObject = nil
			isPlayerInHouse = false
			plotRadius = nil
			
			return;
			
		end
		
		setElementRotation(currentObject, orX, orY, orZ)
		
		dX = ooX - oX
		if (dX < 0) then dX = dX * -1 end
		dY = ooY - oY
		if (dY < 0) then dY = dY * -1 end
		dZ = ooZ - oZ
		if (dZ < 0) then dZ = dZ * -1 end
		
		if (dX < 0.5 and dY < 0.5 and dZ < 0.25) then
			setElementPosition(currentObject, oX, oY, oZ)
		end
		
		
		local rX = pX - pX2
		local rY = pY - pY2
		local rZ = pZ - pZ2
		if (((rZ >= 2 and rZ <= 50) and (rY >= -10 and rY <= 10) and (rX >= -10 and rX <= 10))) then
			if (viewMode == "air") then
				
				local x1, y1, z1, x2, y2, z3 = getCameraMatrix()
				
				setCameraMatrix(pX, pY, pZ, pX2, pY2, pZ2)
				
				if (isPlayerInHouse) then
					local sX, sY, sZ, eX, eY, eZ= getCameraMatrix(localPlayer)
					local bool, oX, oY, oZ, hit = processLineOfSight(sX, sY, sZ, eX, eY, eZ, true, false, false, false, false, false, false, false, currentObject, false, false)
					
					if (bool) then
						setCameraMatrix(x1, y1, z1, x2, y2, z3)
					end
				end
				
			end
		end
	end
end
addEventHandler("onClientKey", root, rotateTheObject)



















local gridLineObject = nil
local ignoreMatrix = {
	pickup = true
}
local MAX_THICKNESS = 1.2
local MAX_THICKNESS_AngleHelper = .8
function renderGridlines(ele)
	if (ele) then
		gridLineObject = ele
	end
	if not isElement(gridLineObject) then gridLineObject = nil return end
	if getElementDimension(gridLineObject) ~= getElementDimension(localPlayer) then return end
	
	local x,y,z = getElementPosition(gridLineObject)
	if not x then return end

	local minX,minY,minZ,maxX,maxY,maxZ = getElementBoundingBox ( gridLineObject )
	if not minX then
		local radius = getElementRadius ( gridLineObject )
		if radius then
			minX,minY,minZ,maxX,maxY,maxZ = -radius,-radius,-radius,radius,radius,radius
		end
	end
	
	if not minX or not minY or not minZ or not maxX or not maxY or not maxZ then return end
	local camX,camY,camZ = getCameraMatrix()
	--Work out our line thickness
	local thickness = (100/getDistanceBetweenPoints3D(camX,camY,camZ,x,y,z)) * MAX_THICKNESS
	--
	local elementMatrix = (getElementMatrix(gridLineObject) and not ignoreMatrix[getElementType(gridLineObject)]) 
							and matrix(getElementMatrix(gridLineObject))
	if not elementMatrix then
		--Make them into absolute coords
		minX,minY,minZ = minX + x,minY + y,minZ + z
		maxX,maxY,maxZ = maxX + x,maxY + y,maxZ + z
	end
	--
	local face1 = matrix{
		 	{minX,maxY,minZ,1}, 
			{minX,maxY,maxZ,1}, 
			{maxX,maxY,maxZ,1}, 
			{maxX,maxY,minZ,1},
		}
	local face2 = matrix{
			{minX,minY,minZ,1},
			{minX,minY,maxZ,1}, 
			{maxX,minY,maxZ,1}, 
			{maxX,minY,minZ,1},
		}
	if elementMatrix then
		face1 = face1*elementMatrix
		face2 = face2*elementMatrix
	end
	
	local faces = { face1,face2	}
	local drawLines,furthestNode,furthestDistance = {},{},0
	--Draw rectangular faces
	for k,face in ipairs(faces) do
		for i,coord3d in ipairs(face) do
			if not getScreenFromWorldPosition(coord3d[1],coord3d[2],coord3d[3],10) then return end
			local nextIndex = i + 1
			if not face[nextIndex] then nextIndex = 1 end
			local targetCoord3d  = face[nextIndex]
			table.insert ( drawLines, { coord3d, targetCoord3d } )
			local camDistance = getDistanceBetweenPoints3D(camX,camY,camZ,unpack(coord3d))
			if camDistance > furthestDistance then
				furthestDistance = camDistance
				furthestNode = faces[k][i]
			end
		end
	end
	--Connect these faces together with four lines
	for i=1,4 do
		table.insert ( drawLines, { faces[1][i], faces[2][i] } )
	end
	--
	for i,draw in ipairs(drawLines) do
		if ( not vectorCompare ( draw[1], furthestNode ) ) and ( not vectorCompare ( draw[2], furthestNode ) ) then
			drawLine (draw[1],draw[2],tocolor(200,0,0,180),thickness)
		end
	end
end

function getElementBoundRadius(elem)
	local x0, y0, z0, x1, y1, z1 = getElementBoundingBox(elem)
	return math.max(x0+x1,y0+y1,z0+z1)*1.3
end

function drawXYZLines()
	if not isElement(gridLineObject) then return end
	local camX,camY,camZ = getCameraMatrix()
	if getElementDimension(gridLineObject) ~= getElementDimension(localPlayer) then return end
	local radius = (tonumber(getElementRadius(gridLineObject)) or .3)*1.2
	local x,y,z = getElementPosition(gridLineObject)
	local xx,xy,xz = getPositionFromElementAtOffset(gridLineObject,radius,0,0)
	local yx,yy,yz = getPositionFromElementAtOffset(gridLineObject,0,radius,0)
	local zx,zy,zz = getPositionFromElementAtOffset(gridLineObject,0,0,radius)
	local thickness = (100/getDistanceBetweenPoints3D(camX,camY,camZ,x,y,z)) * MAX_THICKNESS_AngleHelper
	drawLine({x,y,z},{xx,xy,xz},tocolor(200,0,0,200),thickness)
	drawLine({x,y,z},{yx,yy,yz},tocolor(0,200,0,200),thickness)
	drawLine({x,y,z},{zx,zy,zz},tocolor(0,0,200,200),thickness)	
end

function getPositionFromElementAtOffset(element,x,y,z)
   if not x or not y or not z then
      return false
   end
		local ox,oy,oz = getElementPosition(element)
        local matrix = getElementMatrix ( element )
		if not matrix then return ox+x,oy+y,oz+z end
        local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
        local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
        local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
        return offX, offY, offZ
end

function drawLine(vecOrigin, vecTarget,color,thickness)
	local startX,startY = getScreenFromWorldPosition(vecOrigin[1],vecOrigin[2],vecOrigin[3],10)
	if (not vecTarget[1]) then return false end
	local endX,endY = getScreenFromWorldPosition(vecTarget[1],vecTarget[2],vecTarget[3],10)
	if not startX or not startY or not endX or not endY then 
		return false
	end
	
	return dxDrawLine ( startX,startY,endX,endY,color,thickness, false)
end

function vectorCompare ( vec1,vec2 )
	if vec1[1] == vec2[1] and vec1[2] == vec2[2] and vec1[3] == vec2[3] then return true end
end