--[[ Client and Server functions ]] --

--> String and Number functions
function isString(string)
	if (not tonumber(string) and tostring(string) ~= "true" and tostring(string) ~= "false" and tostring(string) ~= "nil") then
		return true
	end
	return false
end

function isNumber(string)
	if (tonumber(string)) then
		return true
	end
	return false
end

function isLetter(string)
	if (isString(string)) then
		if (string.upper(string) ~= string.lower(string)) then
			return true
		end
	end
	return false
end

function formNumberToMoneyString ( value )
	if tonumber ( value ) then
		value = tostring ( value )
		if string.sub ( value, 1, 1 ) == "-" then
			return "-"..setDotsInNumber ( string.sub ( value, 2, #value ) ).." $"
		else
			return setDotsInNumber ( value ).." $"
		end
	end
	return false
end

function setDotsInNumber ( value )
	if (string.len(value) > 3) then
		return setDotsInNumber ( string.sub ( value, 1, string.len(value) - 3 ) ).."."..string.sub ( value, string.len(value) - 2, string.len(value) )
	else
		return value
	end
end

function containsText(lookingFor, text)
	if lookingFor and text then
		if #lookingFor >= #text then
			if lookingFor == text then
				return true
			else
				return false
			end
		else
			for i = 0, #text - #lookingFor + 1 do
				local switch = false
				for k = 1, #lookingFor do
					if string.sub ( text, i+k, i+k ) == string.sub ( lookingFor, k, k ) then
						switch = true
					else
						switch = false
						break
					end
				end
				if switch then
					return true
				end
			end
		end
	else
		return false
	end
end

function math.round(number, decimals, method)
    local decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then
		return math[method](number * factor) / factor
    else
		return tonumber(("%."..decimals.."f"):format(number))
	end
end

function round(num) -- rundet unter .5 ab über .5 auf
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

function urldecode(s)
	if (s) then
		s = string.gsub(s, '%%(%x%x)', function(hex)
			return string.char(tonumber(hex,16))
		end)
	end
	return s
end
function urlencode(str)
	if (str) then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w ])", function (c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "+")
	end
	return str    
end


function dumpvar(data)
    -- cache of tables already printed, to avoid infinite recursive loops
    local tablecache = {}
    local buffer = ""
    local padder = "    "
 
    local function _dumpvar(d, depth)
        local t = type(d)
        local str = tostring(d)
        if (t == "table") then
            if (tablecache[str]) then
                -- table already dumped before, so we dont
                -- dump it again, just mention it
                buffer = buffer.."<"..str..">\n"
            else
                tablecache[str] = (tablecache[str] or 0) + 1
                buffer = buffer.."("..str..") {\n"
                for k, v in pairs(d) do
                    buffer = buffer..string.rep(padder, depth+1).."["..k.."] => "
                    _dumpvar(v, depth+1)
                end
                buffer = buffer..string.rep(padder, depth).."}\n"
            end
        elseif (t == "number") then
            buffer = buffer.."("..t..") "..str.."\n"
        else
            buffer = buffer.."("..t..") \""..str.."\"\n"
        end
    end
    _dumpvar(data, 0)
    return buffer
end

--> Date and Time functions
local monthDays = {
	[1]=31,
	[2]=28,
	[3]=31,
	[4]=30,
	[5]=31,
	[6]=30,
	[7]=31,
	[8]=31,
	[9]=30,
	[10]=31,
	[11]=30,
	[12]=31
}

function dateString()
	local regtime = getRealTime()
	local year = regtime.year + 1900
	local month = regtime.month + 1
	local day = regtime.monthday
	local hour = regtime.hour
	if hour == 24 then hour = 0 end
	local minute = regtime.minute
	return tostring(day.."."..month.."."..year..", "..hour..":"..minute)
end

function getDaysInMonth(month, year)
	if (not year) then year = getRealTime().year + 1900 end
	local leap = isYearALeapYear(year)
	if month == 2 and leap then
		return 29
	else
		return monthDays[month]
	end
end

function isYearALeapYear(year)
    if (not year) then year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getDistanceBetweenMinutes(m1, h1, m2, h2)
	local t1 = m1 + h1 * 60
	local t2 = m2 + h2 * 60
	if t2 == t1 then
		return 0
	elseif t2 > t1 then
		return t2 - t1
	else
		return math.abs(1440 - t1 + t2)
	end
end

function timestampDays(add)
	local regtime = getRealTime()
	local day = regtime.monthday + add
	local year = regtime.year + 1900
	while day > 365 do
		day = day - 365
		year = year + 1
	end
	local month = regtime.month + 1
	local hour = regtime.hour
	if hour == 24 then hour = 0 end
	local minute = regtime.minute
	local timestamp = day.."."..month.."."..year
	return timestamp
end

function getSecTime(duration)
	if not duration then
		duration = 0
	end
	local time = getRealTime()
	local year = time.year -- Check!!
	local day = time.yearday
	local hour = time.hour
	local minute = time.minute
	local total = year * 365 * 24 * 60 + day * 24 * 60 + ( hour + duration ) * 60 + minute
	return total
end

function getSecondTime(duration)
	local time = getRealTime()
	local year = time.year -- Check!
	local day = time.yearday
	local hour = time.hour
	local minute = time.minute
	local seconds = time.second
	
	local total = 0
	total = year * 365 * 24 * 60 * 60
	total = total + day * 24 * 60 * 60
	total = total + hour * 60 * 60
	total = total + minute * 60
	total = total + seconds + duration
	
	return total
end

function getAge(day, month, year)
	local time = getRealTime()
	time.year = time.year + 1900
	time.month = time.month + 1
 
	year = time.year - year
	month = time.month - month
 
	if month < 0 then 
		year = year - 1 
	elseif month == 0 then
		if time.monthday < day then
			year = year - 1
		end
	end
	
	return year
end

function string2date(timestamp)
	local time = getRealTime(timestamp)
	local year = regtime.year + 1900
	local month = regtime.month + 1
	local day = regtime.monthday
	local hour = regtime.hour
	if hour == 24 then hour = 0 end
	local minute = regtime.minute
	return tostring(day.."."..month.."."..year..", "..hour..":"..minute)
end


function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isYearALeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isYearALeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    
    --timestamp = timestamp + (3600*2) --Sommerzeit: gmt/utc+2, Winterzeit: gmt/utc+1
    if datetime.isdst then timestamp = timestamp - 3600 end
    
    return timestamp
end

--> Table/ Array functions
function sortArray(tbl)
	local array = {}
	local size = table.size ( tbl )
	local curBiggest = 0
	local curID = 0
	
	for k = 1, size do
		for i = 1, size do
			if tbl[i] > curBiggest then
				curBiggest = tbl[i]
				curID = i
			end
		end
		array[k] = curBiggest
		tbl[curID] = 0
		curBiggest = 0
	end
	
	return array
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do
		length = length + 1
	end
    return length
end

function table.reverse(t) 
    local reversedTable = {} 
    local itemCount = #t  
    for k, v in ipairs(t) do 
        reversedTable[itemCount + 1 - k] = v  
    end 
    return reversedTable  
end 

function tableMerge(t1, t2)
    for k,v in pairs(t2) do
    	if type(v) == "table" then
    		if type(t1[k] or false) == "table" then
    			tableMerge(t1[k] or {}, t2[k] or {})
    		else
    			t1[k] = v
    		end
    	else
    		t1[k] = v
    	end
    end
    return t1
end

function ripairs(t) -- iparis rueckwaerts
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end






function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,#t.__orderedIndex do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t) -- kann anstatt (i)pairs genutzt werden, sortiert die table aufsteigend nach key
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end


--> Position functions
function isReallyInsideRadarArea(theArea, x, y)
	local posX, posY = getElementPosition(theArea)
	local sizeX, sizeY = getRadarAreaSize(theArea)
	return (x >= posX) and (x <= posX + sizeX) and (y >= posY) and (y <= posY + sizeY)
end

function attachElementsInCorrectWay ( element1, element2 )
	local x1, y1, z1 = getElementPosition ( element1 )
	--local rx1, ry1, rz1 = getElementRotation ( element1 )
	local x2, y2, z2 = getElementPosition ( element2 )
	--local rx2, ry2, rz2 = getElementRotation ( element1 )
	attachElements ( element1, element2, x1-x2, y1-y2, z1-z2--[[, rx1-rx2, ry1-ry2, rz1-rz2]] )
end

function attachElementsInVeryCorrectWay ( element1, element2 )
	local x1, y1, z1 = getElementPosition ( element1 )
	local rx1, ry1, rz1 = getElementRotation ( element1 )
	local x2, y2, z2 = getElementPosition ( element2 )
	local rx2, ry2, rz2 = getElementRotation ( element1 )
	attachElements ( element1, element2, x1-x2, y1-y2, z1-z2, rx2, ry2, rz2 )
end

function findRotation(x1, y1, x2, y2)
	local t = - math.deg(math.atan2 (x2 - x1, y2 - y1))
	if t < 0 then t = t + 360 end
	return t
end

function getPointFromDistanceRotation2(x, y, dist, angle)
    local a = math.rad(angle + 90)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end

-- getPointFromDistanceRotation scheint nur teilweise zu funktionieren, wenn nicht geht getPointFromDistanceRotation2 nutzen
function getPointFromDistanceRotation ( x, y, dist, angle )
	local a = math.rad ( 90 - angle )
	local dx = math.cos ( a ) * dist
	local dy = math.sin ( a ) * dist
	return x + dx, y + dy
end

function vec2Angle(x, y) 
	local t = -math.deg(math.atan2(x, y))
	if t < 0 then t = t + 360 end
	return t
end

function crossProduct(vec1, vec2) 
	return Vector3(
		((vec1.y * vec2.z) - (vec1.z * vec2.y)),
	  - ((vec1.x * vec2.z) - (vec1.z * vec2.x)),
		((vec1.x * vec2.y) - (vec1.y * vec2.x)))
end

function createCameraMatrix(fwVec, upVec, pos)
	local zaxis = (fwVec):getNormalized()
	local xaxis = (crossProduct(-upVec, zaxis)):getNormalized()
	local yaxis = crossProduct(xaxis, zaxis)
	elMat:setRight(xaxis)
	elMat:setForward(zaxis)
	elMat:setUp(yaxis)
	return elMat
end

function createCameraMatrix(fwVec, upVec, pos)
	local zaxis = (fwVec):getNormalized()
	local xaxis = (crossProduct(-upVec, zaxis)):getNormalized()
	local yaxis = crossProduct(xaxis, zaxis)
	elMat:setRight(xaxis)
	elMat:setForward(zaxis)
	elMat:setUp(yaxis)
	return elMat
end

function getScreenFrom3DPosition(posVec, viewProj, screenWH)
	local posTab = {posVec.x, posVec.y, posVec.z, 1}
	local worldViewProjection = matrixVec4MultiplyTab(viewProj, posTab)
	worldViewProjection[1] = worldViewProjection[1] / worldViewProjection[3] 
	worldViewProjection[2] = -worldViewProjection[2] / worldViewProjection[3]
	worldViewProjection[1] = (worldViewProjection[1] + 1) * screenWH.x / 2
	worldViewProjection[2] = (worldViewProjection[2] + 1) * screenWH.y / 2
	return Vector2(worldViewProjection[1], worldViewProjection[2])
end

function createViewMatrixTab(fwVec, upVec, pos)
	local zaxis = (fwVec):getNormalized()
	local xaxis = (crossProduct(-upVec, zaxis)):getNormalized()
	local yaxis = crossProduct(xaxis, zaxis)
	return {
		{ xaxis.x, yaxis.x, zaxis.x, 0 },
		{ xaxis.y, yaxis.y, zaxis.y, 0 },
		{ xaxis.z, yaxis.z, zaxis.z, 0 },
		{-xaxis:dot(pos), -yaxis:dot(pos), -zaxis:dot(pos), 1 }
		}
end

function createProjectionMatrixTab(nearPlane, farPlane, fovHoriz, fovAspect)
	local h, w, Q
	w = 1/math.tan(fovHoriz * 0.5)
	h = w / fovAspect
	Q = farPlane/(farPlane - nearPlane)
	return {
		{w, 0, 0, 0},
		{0, h, 0, 0},
		{0, 0, Q, 1},
		{0, 0, -Q * nearPlane, 0}
	}    
end

function matrixVec4MultiplyTab(mat, vec)
	local vecOut = {}
	vecOut[1] = vec[1] * mat[1][1] + vec[2] * mat[2][1] + vec[3] * mat[3][1] + vec[4] * mat[4][1]
	vecOut[2] = vec[1] * mat[1][2] + vec[2] * mat[2][2] + vec[3] * mat[3][2] + vec[4] * mat[4][2]
	vecOut[3] = vec[1] * mat[1][3] + vec[2] * mat[2][3] + vec[3] * mat[3][3] + vec[4] * mat[4][3]
	vecOut[4] = vec[1] * mat[1][4] + vec[2] * mat[2][4] + vec[3] * mat[3][4] + vec[4] * mat[4][4]
	return vecOut
end

function matrixMultiplyTab(mat1, mat2)
	local matOut = {}
	for i = 1,#mat1 do
		matOut[i] = {}
		for j = 1,#mat2[1] do
			local num = mat1[i][1] * mat2[1][j]
			for n = 2,#mat1[1] do
				num = num + mat1[i][n] * mat2[n][j]
			end
			matOut[i][j] = num
		end
	end
	return matOut
end

function clampWorldPos2Angle(viewPos, bliPos, camFwVec, halfAngle, isBorder)
	local angle2blip = getObiectToCameraAngle(bliPos, viewPos, camFwVec)
	local angle2plane = (angle2blip - math.pi/2)
	if math.abs(angle2plane) < 0.0175 then
		if angle2plane < 0 then
			angle2plane = -0.0175
		else
			angle2plane = 0.0175				
		end
	end
	local planarDist = math.sin(angle2plane) * (viewPos - bliPos).length
	local planarPos = viewPos - camFwVec * planarDist
	local planar2blipVec = (planarPos - bliPos):getNormalized()
	local planarVecLen 
	if isBorder then 
		planarVecLen = math.tan(math.rad(halfAngle)) * planarDist  
	else
		planarVecLen = math.tan(math.min(math.rad(halfAngle), angle2blip)) * planarDist
	end
	return Vector3(planarPos + planar2blipVec * planarVecLen)
end

function getObiectToCameraAngle(elementPos, cameraPos, fwVec)
	local elementDir = (elementPos-cameraPos):getNormalized()
	return math.acos(elementDir:dot(fwVec)/(elementDir.length * fwVec.length))
end

function findEmptyEntry(inTable)
	for index,value in ipairs(inTable) do
		if not value.enabled then
			return index
		end
	end
	return #inTable + 1
end


--> Player/Ped functions
function isPlayerUnarmed(player)
	for i = 2, 8 do
		if getPedWeapon(player, i) > 0 then
			if getPedTotalAmmo(player, i) > 0 then
				return false
			end
		end
	end
	return true
end

function addElementHealth(element, value)
	if isElement(element) then
		local total = getElementHealth(element) + value
		if (total > 100) then
			return setElementHealth(element, 100)
		else
			return setElementHealth(element, total)
		end
	end
	return false
end

function fadeElementInterior(player, int, intx, inty, intz, rot, dim, freeze)
	if (getElementType(player) == "player") then
		if (getElementData(player, "intchange") == false) then
			setElementData(player, "intchange", true )
			setElementFrozen(player, true)
			toggleGhostMode(player, true, 2000)
			setTimer(function()
				setElementData(player, "intchange", false)
			end, 1750, 1)
			
			fadeCamera ( player, false, 1, 0, 0, 0 )
			if (freeze) then setElementFrozen(player, true) end
			
			setTimer(function()
				
				setElementInterior(player, int or 0)
				setElementDimension(player, dim or 0)
				setElementPosition(player, intx, inty, intz)
				
				setElementRotation(player, 0, 0, rot or 0, "default", true)
				
				local attached = getPedBoneAttachedElement(player)
				if (attached ~= false and isElement(attached)) then
					setElementDimension(attached, dim or 0)
					setElementInterior(attached, int or 0)
				end
				
				setTimer(function()
					setElementRotation(player, 0, 0, rot or 0, "default", true)
					fadeCamera(player, true)
					setElementFrozen(player, false)
				end, 75, 1)
				
			end, 900, 1)
		end
	end
end

function getPlayerUniqueDimension(player) -- Dimensionen ab 10000 sind für spieler reserviert!
	if (not player) then player = localPlayer end
	local userID = tonumber(getElementData(player, "uID"))
	local dim = 10000 + userID
	if (dim > 65535) then dim = math.random(10000, 65535) end
	return dim
end

function findPlayerByName(playerPart)
	if playerPart then
		local pl = getPlayerFromName(playerPart)
		if isElement(pl) then
			return pl
		else
			for i, v in ipairs(getElementsByType("player")) do
				if string.find(string.gsub(string.lower(getPlayerName(v)), "#%x%x%x%x%x%x", ""), string.lower(playerPart)) then
					return v
				end
			end
		end
	end
	return false
end

--> Element functions
function vanishElement(element)
	if (isElement(element)) then
		for i = 1, 25 do
			setTimer(setElementAlpha, 100 * i, 1, element, 255 / 25 * (25 - i))
		end
		setTimer(destroyElement, 2500, 1, element)
	end
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.91 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
	return false
end

--> Other shit
function isLoggedin(player)
	if (not player) then player = localPlayer end
	if (isElement(player)) then
		if (getElementData(player, "loggedin") and getElementData(player, "loggedin") == true) then
			return true
		end
	end
	return false
end


--[[ only Client functions ]] --

--> Player/Ped functions
function isPedAiming(thePedToCheck)
	if thePedToCheck and isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function isCursorOnElement(x,y,w,h)
	if (isCursorShowing()) then
		local mx,my = getCursorPosition()
		cursorx,cursory = mx*screenWidth,my*screenHeight
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		else
			return false
		end
	end
end

function getPingColor (ping)
	if ping <= 50 then
		return 0, 200, 0
	elseif ping <= 150 then
		return 200, 200, 0
	else
		return 200, 0, 0
	end
end

--[[ only Server functions ]] --

--> GUI functions
function centerWindow(center_window)
    local screenW,screenH = guiGetScreenSize()
    local windowW,windowH = guiGetSize(center_window,false)
    local x,y = (screenW-windowW)/2,(screenH-windowH)/2
    guiSetPosition(center_window,x,y,false)
end

function dxDrawGifImage ( x, y, w, h, path, iStart, iType, effectSpeed )
	local gifElement = createElement ( "dx-gif" )
	if ( gifElement ) then
		setElementData (
			gifElement,
			"gifData",
			{
				x = x,
				y = y,
				w = w,
				h = h,
				imgPath = path,
				startID = iStart,
				imgID = iStart,
				imgType = iType,
				speed = effectSpeed,
				tick = getTickCount ( )
			},
			false
		)
		return gifElement
	else
		return false
	end
end
 
addEventHandler ( "onClientRender", root,
	function ( )
		local currentTick = getTickCount ( )
		for index, gif in ipairs ( getElementsByType ( "dx-gif" ) ) do
			local gifData = getElementData ( gif, "gifData" )
			if ( gifData ) then
				if ( currentTick - gifData.tick >= gifData.speed ) then
					gifData.tick = currentTick
					gifData.imgID = ( gifData.imgID + 1 )
					if ( fileExists ( gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType ) ) then
						gifData.imgID = gifData.imgID
						setElementData ( gif, "gifData", gifData, false )
					else
						gifData.imgID = gifData.startID
						setElementData ( gif, "gifData", gifData, false )
					end
				end
				dxDrawImage ( gifData.x, gifData.y, gifData.w, gifData.h, gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType )
			end
		end
	end
)

--> Player/Ped functions
function damagePlayer(player, amount, damager, weapon)
	if isElement(player) then
		local armor = getPedArmor(player)
		local health = getElementHealth(player)
		if armor > 0 then
			if armor >= amount then
				setPedArmor(player, armor - amount)
			else
				setPedArmor(player, 0)
				amount = math.abs(armor - amount)
				setElementHealth(player, health - amount)
				if getElementHealth(player) - amount <= 0 then
					killPed(player, damager, weapon, 3, false)
				end
			end
		else
			if getElementHealth (player) - amount <= 0 then
				killPed(player, damager, weapon, 3, false)
			end
			setElementHealth(player, health - amount)
		end
	end
end

--> Other shit
local smoothTmp = {
	moving	= false,
	obj1	= nil,
	obj2	= nil,
	timer	= nil,
}
local function smoothRender()
	if (smoothTmp.moving) then
		local x1, y1, z1 = getElementPosition(smoothTmp.obj1)
		local x2, y2, z2 = getElementPosition(smoothTmp.obj2)
		setCameraMatrix(x1, y1, z1, x2, y2, z2)
	end
end
function smoothDestroy()
	if (smoothTmp.moving) then
		removeEventHandler("onClientRender", root, smoothRender)
		destroyElement(smoothTmp.obj1)
		destroyElement(smoothTmp.obj2)
		killTimer(smoothTmp.timer)
		smoothTmp.moving = false
	end
end

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
	smoothDestroy()
	
	if (not time) then
		local dist = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
		time = dist*75
		if (time > 2500) then time = 2500 end
	end
	
	smoothTmp.moving = true
	
	smoothTmp.obj1 = createObject(3808, x1, y1, z1 )
	setElementAlpha(smoothTmp.obj1, 0)
	setElementCollidableWith(smoothTmp.obj1, root, false)
	setElementCollisionsEnabled(smoothTmp.obj1 , false)
	
	smoothTmp.obj2 = createObject(3808, x1t, y1t, z1t)
	setElementAlpha(smoothTmp.obj2, 0)
	setElementCollidableWith(smoothTmp.obj2, root, false)
	setElementCollisionsEnabled(smoothTmp.obj2, false)
	
	moveObject(smoothTmp.obj1, time, x2, y2, z2)
	moveObject(smoothTmp.obj2, time, x2t, y2t, z2t)
	
	addEventHandler("onClientRender", root, smoothRender)
	smoothTmp.timer = setTimer(smoothDestroy, time, 1)
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function getMiddleGuiPosition(w, h)
	local sWidth, sHeight = guiGetScreenSize()
    local Width,Height = w, h
    local X = (sWidth/2) - (Width/2)
    local Y = (sHeight/2) - (Height/2)
	return X, Y, Width, Height
end

-- File Functions
function fileGetContents(pth)
	if (fileExists(pth)) then
		local f = fileOpen(pth, true)
		if (f) then
			local c = fileRead(f, fileGetSize(f))
			fileClose(f)
			return c
		end
	end
	return false
end
function filePutContents(pth, content)
	local f = false
	if (fileExists(pth)) then
		f = fileOpen(pth, false)
	else
		f = fileCreate(pth)
	end
	if (f) then
		w = fileWrite(f, content)
		fileClose(f)
		return w
	end
	return false
end




--- FUNCTION OVERRIDES --
_destroyElement = destroyElement
function destroyElement(elem)
	if (isElement(elem)) then
		return _destroyElement(elem)
	end
	return false
end

_killTimer = killTimer
function killTimer(elem)
	if (isTimer(elem)) then
		return _killTimer(elem)
	end
	return false
end

_getPlayerFromName = getPlayerFromName
function getPlayerFromName(name)
	local target = _getPlayerFromName(name)
	if (target and isLoggedin(target)) then
		return target
	end
	return false
end

--[[
local EventHandlers = {}
function isEventHandled(eventName, attachedTo, handlerFunction)
	local check = false
	if (type(EventHandlers[eventName]) == "table") then
		if (type(EventHandlers[eventName][attachedTo]) == "table") then
			if (type(EventHandlers[eventName][attachedTo][tostring(handlerFunction)]) == "boolean") then
				check = EventHandlers[eventName][attachedTo][tostring(handlerFunction)]
			end
		end
	end
	if (check == true) then
		return true
	end
	return false
end
_addEventHandler = addEventHandler
function addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
	outputChatBox(tostring(handlerFunction))
	if (not isEventHandled(eventName, attachedTo, handlerFunction)) then
		if (type(getPropagated) ~= "boolean") then getPropagated = true end
		if (type(priority) ~= "string") then priority = "normal" end
		if (type(EventHandlers[eventName]) ~= "table") then EventHandlers[eventName] = {} end
		if (type(EventHandlers[eventName][attachedTo]) ~= "table") then EventHandlers[eventName][attachedTo] = {} end
		
		EventHandlers[eventName][attachedTo][tostring(handlerFunction)] = true
		return _addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
		
	end
	return false
end
_removeEventHandler = removeEventHandler
function removeEventHandler(eventName, attachedTo, handlerFunction)
	if (isEventHandled(eventName, attachedTo, handlerFunction)) then
		EventHandlers[eventName][attachedTo][tostring(handlerFunction)] = false
		return _removeEventHandler(eventName, attachedTo, handlerFunction)
	end
	return false
end
]]

if (localPlayer) then
	local arrowTimers	= {}
	
	addEventHandler("onClientElementStreamIn", root, function()
		if (getElementType(source) == "marker") and (getMarkerType (source) == "arrow") then
			
			if (type(arrowTimers[source]) ~= "table") then
				arrowTimers[source] = {}
				local x, y, z = getElementPosition(source)
				arrowTimers[source].pos	= {x, y, z+0.05}
				arrowTimers[source].state = "up"
				arrowTimers[source].bin = createObject(3808, x, y, z+0.05)
				setElementInterior(arrowTimers[source].bin, getElementInterior(source))
				setElementDimension(arrowTimers[source].bin, getElementDimension(source))
				attachElements(source, arrowTimers[source].bin, 0, 0, 0)
				setElementAlpha(arrowTimers[source].bin, 0)
				arrowTimers[source].timer = nil
			end
			
			if (type(arrowTimers[source]) == "table" and not isTimer(arrowTimers[source].timer)) then
				
				arrowTimers[source].timer = setTimer(function(mark)
					if (mark and isElement(mark)) then
						setElementInterior(arrowTimers[mark].bin, getElementInterior(mark))
						setElementDimension(arrowTimers[mark].bin, getElementDimension(mark))
						local x,y,z = unpack(arrowTimers[mark].pos)
						
						local tz = 0
						if (arrowTimers[mark].state == "up") then
							tz = z+0.1
							arrowTimers[mark].state = "down"
						else
							tz = z-0.1
							arrowTimers[mark].state = "up"
						end
						
						local m = moveObject(arrowTimers[mark].bin, 700, x, y, tz);
						
					else
						
						if (mark and isElement(mark)) then
							killTimer(arrowTimers[mark].timer)
							arrowTimers[mark] = nil
						end
					end
				end, 705, 0, source)
				
			end
		end
	end)
	
	addEventHandler("onClientElementStreamOut", root, function()
		if (getElementType(source) == "marker") and (getMarkerType (source) == "arrow") then
			if (type(arrowTimers[source]) == "table") then
				if (isElement(arrowTimers[source].bin)) then
					detachElements(source, arrowTimers[source].bin, 0, 0, 0)
					destroyElement(arrowTimers[source].bin)
				end
				if (isTimer(arrowTimers[source].timer)) then
					killTimer(arrowTimers[source].timer)
				end
				
				arrowTimers[source] = nil
			end
		end
	end)
end


if (localPlayer) then
	function setObjectsUnbreakable()
		for k, v in ipairs(getElementsByType("object", root, false)) do
			if (getElementData(v, "unbreakable") == true) then
				setObjectBreakable(v, false)
			end
		end
		setTimer(setObjectsUnbreakable, 1000*60, 1)
	end
	setObjectsUnbreakable()
end


local FirstNameMale = {
	"Franz",
	"Daniel",
	"Lars",
	"Jeremy-Pascal",
	"Laser",
	"Atomfried",
	"Satan",
	"Sputnik",
	"Verleihnix",
	"Karlfried",
	"Pumuckl",
	"Kävin",
	"Sultan",
	"Leonardo da Vinci Franz",
	"Detlef",
	"Alfred",
	"Alfons",
	"Michel",
	"Joda",
	"Peter",
	"Tim",
	"Tom",
	"Luca",
	"Lukas",
	"Stephan",
	"Bernd",
	"Jonas",
	"Michael",
	"Walter",
	"Marcel",
	"Dominik",
	"Marc",
	"Leif",
	"Leon",
	"Marco",
	"Christian",
	"Matthias",
	"David",
	"Nikolas",
	"Olaf",
	"Oliver",
	"Florian",
	"Fridolin",
	"Pietro",
	"Uwe",
	"Werner",
	"Otto",
	"Erich",
	"Hagen",
	"Adolf",
	"Hermann",
	"Josef",
	"Heinrich",
	"Albert",
	"Karl",
	"Rudolf",
	"Rainer",
	"Ben",
	"Finn",
	"Luis",
	"Paul",
	"Felix",
	"Noah",
	"Elias",
	"Max",
	"Julian",
	"Phillip",
	"Adrian",
	"Moritz",
	"Niklas",
	"Alexander",
	"Jan",
	"Jakob",
	"David",
	"Erik",
	"Fabian",
	"Simon",
	"Jannik",
	"Nico",
	"Lennard",
	"Linux",
	"Nils",
	"Anton",
	"Emil",
	"Florian",
	"Nick",
	"Rafael",
	"Leo",
	"Marlon",
	"Till",
	"Samuel",
	"Sebastian",
	"Tobias",
	"Aaron",
	"Bastian",
	"Gabriel",
	"Noel",
	"Valentin",
	"Bennet",
	"Dean",
	"Dennis",
	"Leopold",
	"Manuel",
	"Theodor",
	"Kai",
	"Fritz",
	"André",
	"Andreas",
	"Ferdinand",
	"Hendrik",
	"Gustav",
	"Robert",
	"Alessandro",
	"Christoph",
	"Sven",
	"Konrad",
	"Miroslav",
	"Joachim",
	"Boris",
	"Günther",
	"Herbert",
	"Helmut",
	"Willy",
	"Martin",
}



local FirstNameFemale = {
	"Pepsi-Carola",
	"Radegunde",
	"Jacqueline",
	"Chantal",
	"Sarafina",
	"Loredana",
	"Silvana",
	"Sarah-Jayne",
	"Lavinina",
	"Estefania",
	"Kunigunde",
	"Gertrude",
	"Hedwig",
	"Laura",
	"Michelle",
	"Martina",
	"Anja",
	"Jasmin",
	"Nadine",
	"Jennifer",
	"Carola",
	"Jana",
	"Sandra",
	"Nina",
	"Jessica",
	"Charlotte",
	"Lara",
	"Lea",
	"Alina",
	"Janine",
	"Hanna",
	"Anastasia",
	"Mercedes",
	"Emma",
	"Olga",
	"Gina",
	"Porsche",
	"Eva",
	"Wiebke",
	"Helga",
	"Heike",
	"Olivia",
	"Isabelle",
	"Ilona",
	"Fabienne",
	"Dilara",
	"Corinna",
	"Anne",
	"Mia",
	"Leonie",
	"Lina",
	"Sofia",
	"Marie",
	"Emily",
	"Amelie",
	"Luisa",
	"Paula",
	"Lotta",
	"Greta",
	"Marlene",
	"Mathilda",
	"Frieda",
	"Stella",
	"Annika",
	"Fiona",
	"Franziska",
	"Selina",
	"Sina",
	"Klara",
	"Paulina",
	"Linda",
	"Laurissa",
	"Kim",
	"Alexandra",
	"Kimberlie",
	"Mona",
	"Lorena",
	"Nicole",
	"Svenja",
	"Heidi",
	"Rosa",
	"Hermine",
	"Viola",
	"Frederike",
	"Jasmina",
	"Vivien",
	"Judith",
	"Nike",
	"Flora",
	"Inga",
	"Henrike",
	"Anita",
	"Kathleen",
	"Betty",
	"Michaela",
	"Melina",
	"Vanessa",
	"Luise",
	"Janina",
	"Ida",
	"Caroline",
	"Angela",
	"Alice",
}

local LastNames = {
	"Schneider",
	"Wollny",
	"Braun",
	"Hettler",
	"Müller",
	"Winkler",
	"Albrecht",
	"Schmitz",
	"Wagner",
	"Becker",
	"Schulz",
	"Fischer",
	"Schröder",
	"Groß",
	"Vogt",
	"Winter",
	"Lorenz",
	"Beck",
	"Roth",
	"König",
	"Hofmann",
	"Baumann",
	"Berger",
	"Voigt",
	"Busch",
	"Führer",
	"Schindler",
	"Goebbels",
	"Göring",
	"Himmler",
	"Speer",
	"Dönitz",
	"Frank",
	"Heß",
	"Höcke",
	"Petry",
	"Zufall",
	"Schweiger",
	"Adenauer",
	"Luther",
	"Marx",
	"Brandt",
	"Einstein",
	"Kohl",
	"Schwarzer",
	"Gottschalk",
	"Grönemeyer",
	"Schumacher",
	"Jauch",
	"Bohlen",
	"Merkel",
	"Pocher",
	"Löw",
	"Klose",
	"Schiffer",
	"Klum",
	"Poth",
	"Hoeneß",
	"Schweighöfer",
	"Lanz",
	"Geissen",
	"Schäfer",
	"Pfeiffer",
	"Wolf",
	"Sauer",
	"Seidel",
	"Seiler",
	"Jäger",
	"Stein",
	"Schuster",
	"Ernst",
	"Kühne",
	"Graf",
	"Schulte",
	"Sommer",
	"Haas",
	"Ziegler",
	"Krause",
	"Ludwig",
	"Vogel",
	"Kurz",
	"Lang",
	"Jung",
	"Weiß",
	"Peters",
	"Fuchs",
	"Scholz",
	"Maier",
	"Meyer",
	"Hartmann",
	"Schmitt",
	"Schwarz",
	"Richter",
	"Neumann",
	"Hermann",
}

local FemaleSkins = {[9]=true,[10]=true,[11]=true,[12]=true,[13]=true,[31]=true,[38]=true,[39]=true,[40]=true,[41]=true,[53]=true,[54]=true,[55]=true,[56]=true,[63]=true,[64]=true,[69]=true,[75]=true,[76]=true,[77]=true,[85]=true,[87]=true,[88]=true,[89]=true,[90]=true,[91]=true,[92]=true,[93]=true,[129]=true,[130]=true,[131]=true,[138]=true,[139]=true,[140]=true,[141]=true,[145]=true,[148]=true,[150]=true,[151]=true,[152]=true,[153]=true,[169]=true,[172]=true,[178]=true,[190]=true,[191]=true,[192]=true,[193]=true,[194]=true,[195]=true,[196]=true,[197]=true,[198]=true,[199]=true,[01]=true,[205]=true,[207]=true,[211]=true,[214]=true,[215]=true,[216]=true,[218]=true,[219]=true,[224]=true,[225]=true,[226]=true,[231]=true,[232]=true,[233]=true,[237]=true,[238]=true,[243]=true,[244]=true,[245]=true,[246]=true,[251]=true,[256]=true,[257]=true,[263]=true,[298]=true,[304]=true}

if (not localPlayer) then
	local _createPed = createPed
	function createPed(id, x, y, z, rot, sync, name)
		local ped = _createPed(id, x, y, z, rot, sync)
		if (name ~= false) then
			
			if (FemaleSkins[id]) then
				name = FirstNameFemale[math.random(1,#FirstNameFemale)].." "..LastNames[math.random(1,#LastNames)]
			else
				name = FirstNameMale[math.random(1,#FirstNameMale)].." "..LastNames[math.random(1,#LastNames)]
			end
			setElementData(ped, "firstLastName", name)
			
		end
		return ped
	end
end







-------
Bikes = {[509]=true,[481]=true,[510]=true}
MotorBikes = {[581]=true,[462]=true,[521]=true,[463]=true,[522]=true,[461]=true,[448]=true,[468]=true,[586]=true,[523]=true,[471]=true}

SmallCar = {[496]=true,[401]=true,[527]=true,[589]=true,[410]=true,[436]=true,[439]=true,[574]=true,[530]=true,[572]=true,[583]=true,[441]=true,[464]=true,[594]=true,[501]=true,[465]=true,[564]=true,[568]=true,[424]=true,[457]=true,[571]=true,[539]=true}
MiddleCar = {[602]=true,[518]=true,[419]=true,[587]=true,[533]=true,[526]=true,[474]=true,[545]=true,[517]=true,[600]=true,[549]=true,[491]=true,[445]=true,[604]=true,[507]=true,[587]=true,[466]=true,[492]=true,[546]=true,[551]=true,[516]=true,[467]=true,[426]=true,[547]=true,[405]=true,[580]=true,[550]=true,[566]=true,[540]=true,[421]=true,[529]=true,[438]=true,[420]=true,[470]=true,[596]=true,[598]=true,[597]=true,[536]=true,[575]=true,[534]=true,[567]=true,[535]=true,[576]=true,[412]=true,[402]=true,[542]=true,[603]=true,[475]=true,[429]=true,[541]=true,[415]=true,[480]=true,[562]=true,[565]=true,[434]=true,[411]=true,[559]=true,[560]=true,[506]=true,[451]=true,[558]=true,[555]=true,[477]=true,[504]=true,[500]=true}
BigCar = {[409]=true,[525]=true,[599]=true,[601]=true,[422]=true,[482]=true,[605]=true,[418]=true,[543]=true,[478]=true,[554]=true,[579]=true,[400]=true,[404]=true,[489]=true,[505]=true,[479]=true,[442]=true,[458]=true,[494]=true,[502]=true,[503]=true,[561]=true,[483]=true,[495]=true}

Transporter = {[552]=true,[416]=true,[433]=true,[427]=true,[490]=true,[528]=true,[428]=true,[499]=true,[609]=true,[498]=true,[588]=true,[423]=true,[414]=true,[531]=true,[456]=true,[459]=true,[582]=true,[413]=true,[440]=true,[508]=true}

LKW = {[408]=true,[431]=true,[437]=true,[407]=true,[544]=true,[432]=true,[524]=true,[532]=true,[578]=true,[486]=true,[406]=true,[573]=true,[403]=true,[443]=true,[515]=true,[514]=true}
Trailers = {[606]=true,[607]=true,[610]=true,[584]=true,[611]=true,[608]=true,[435]=true,[450]=true,[591]=true}
Trains = {[590]=true,[538]=true,[570]=true,[569]=true,[537]=true,[449]=true}
MonsterTruck = {[444]=true,[556]=true,[557]=true}

SmallBoat = {[472]=true,[473]=true}
MiddleBoat = {[493]=true,[595]=true,[452]=true,[446]=true}
BigBoat = {[430]=true,[453]=true,[454]=true,[484]=true}

Helicopter = {[548]=true,[425]=true,[417]=true,[487]=true,[488]=true,[497]=true,[563]=true,[447]=true,[469]=true}
SmallPlane = {[511]=true,[512]=true,[593]=true,[520]=true,[476]=true,[519]=true,[460]=true,[513]=true}
BigPlane = {[592]=true,[577]=true,[553]=true}


function getRealVehicleType(veh)
	if (veh and isElement(veh)) then
		local typ	= getVehicleType(veh)
		local ID	= getElementModel(veh)
		if (typ == "Automobile") then
			if (LKW[ID]) then
				typ = "truck"
			end
		end
		
		return typ
	end
	return false
end








-------------
vehicleCentreOfMass = {
	[400] = 1.136110663414,
	[401] = 0.86781454086304,
	[402] = 0.93999981880188,
	[403] = 1.700000166893,
	[404] = 0.8299999833107,
	[405] = 1,
	[406] = 1.7513251304626,
	[407] = 1.3700000047684,
	[408] = 1.75,
	[409] = 0.92499983310699,
	[410] = 0.74999296665192,
	[411] = 0.79999983310699,
	[412] = 0.94999992847443,
	[413] = 1.1499999761581,
	[414] = 1.1500000953674,
	[415] = 0.84952139854431,
	[416] = 1.2995755672455,
	[417] = 1.2730000019073,
	[418] = 1.1829564571381,
	[419] = 0.92999982833862,
	[420] = 0.84999972581863,
	[421] = 1,
	[422] = 1.0799999237061,
	[423] = 1.1302119493484,
	[424] = 0.84722626209259,
	[425] = 1.8510003089905,
	[426] = 0.81999969482422,
	[427] = 1.2480000257492,
	[428] = 1.2497900724411,
	[429] = 0.75,
	[430] = 0.79800415039063,
	[431] = 1.25,
	[432] = 1.0993369817734,
	[433] = 1.5699999332428,
	[434] = 1.1492453813553,
	[435] = 1.6541831493378,
	[436] = 0.87799340486526,
	[437] = 1.25,
	[438] = 1.1999999284744,
	[439] = 1,
	[440] = 1.2126893997192,
	[441] = 0.17500001192093,
	[442] = 0.94986796379089,
	[443] = 1.750394821167,
	[444] = 0.3917441368103,
	[445] = 0.98999989032745,
	[446] = 1.0186829566956,
	[447] = 1.1000000238419,
	[448] = 0.67021918296814,
	[449] = 0,
	[450] = 1.6541831493378,
	[451] = 0.76437205076218,
	[452] = 0.58204936981201,
	[453] = 0.93193912506104,
	[454] = 1.2658512592316,
	[455] = 1.5699999332428,
	[456] = 1.25,
	[457] = 0.7293484210968,
	[458] = 0.97020995616913,
	[459] = 1.1399999856949,
	[460] = 2.219527721405,
	[461] = 0.67450165748596,
	[462] = 0.67021918296814,
	[463] = 0.61699998378754,
	[464] = 0.40700000524521,
	[465] = 0.4549999833107,
	[466] = 0.91999995708466,
	[467] = 0.87000000476837,
	[468] = 0.75999987125397,
	[469] = 1.1000000238419,
	[470] = 1.1100116968155,
	[471] = 0.57500004768372,
	[472] = 0.77418208122253,
	[473] = 0.32354342937469,
	[474] = 0.89999985694885,
	[475] = 0.8999999165535,
	[476] = 2.1701526641846,
	[477] = 0.85000002384186,
	[478] = 1.0799999237061,
	[479] = 0.90458089113235,
	[480] = 0.85000002384186,
	[481] = 0.60877603292465,
	[482] = 1.25,
	[483] = 1.0955964326859,
	[484] = 1.3414800167084,
	[485] = 0.69999998807907,
	[486] = 1.3000000715256,
	[487] = 1.2650001049042,
	[488] = 1.2650001049042,
	[489] = 1.3601264953613,
	[490] = 1.3201265335083,
	[491] = 0.8999999165535,
	[492] = 0.89999997615814,
	[493] = 1.3853187561035,
	[494] = 0.97000002861023,
	[495] = 1.5600740909576,
	[496] = 0.78772735595703,
	[497] = 1.2650001049042,
	[498] = 1.210000038147,
	[499] = 1.0999999046326,
	[500] = 1.2200000286102,
	[501] = 0.4549999833107,
	[502] = 0.9694904088974,
	[503] = 0.9694904088974,
	[504] = 0.93999993801117,
	[505] = 1.3601264953613,
	[506] = 0.79211330413818,
	[507] = 0.95000004768372,
	[508] = 1.4499998092651,
	[509] = 0.5997970700264,
	[510] = 0.69584167003632,
	[511] = 2.5158977508545,
	[512] = 1.6340000629425,
	[513] = 1.78475689888,
	[514] = 1.6996750831604,
	[515] = 2.1537208557129,
	[516] = 0.89999997615814,
	[517] = 0.93566590547562,
	[518] = 0.79480773210526,
	[519] = 2.0000722408295,
	[520] = 1.9195756912231,
	[521] = 0.66037738323212,
	[522] = 0.66037738323212,
	[523] = 0.66037738323212,
	[524] = 2.0531990528107,
	[525] = 0.99000000953674,
	[526] = 0.84999984502792,
	[527] = 0.78314852714539,
	[528] = 1.1849999427795,
	[529] = 0.73788851499557,
	[530] = 0.80008584260941,
	[531] = 1.0064532756805,
	[532] = 2.1097192764282,
	[533] = 0.79999989271164,
	[534] = 0.8228771686554,
	[535] = 0.8400000333786,
	[536] = 0.85000014305115,
	[537] = 0,
	[538] = 0,
	[539] = 0.65000009536743,
	[540] = 0.97950112819672,
	[541] = 0.69999998807907,
	[542] = 0.84339809417725,
	[543] = 0.94999998807907,
	[544] = 1.3700000047684,
	[545] = 0.94999980926514,
	[546] = 0.84184813499451,
	[547] = 0.83999991416931,
	[548] = 2.9000618457794,
	[549] = 0.86147683858871,
	[550] = 0.92278164625168,
	[551] = 0.87999987602234,
	[552] = 0.77690804004669,
	[553] = 3.2349998950958,
	[554] = 1.1949999332428,
	[555] = 0.78037416934967,
	[556] = 0.3917441368103,
	[557] = 0.3917441368103,
	[558] = 0.70379173755646,
	[559] = 0.75406360626221,
	[560] = 0.80497515201569,
	[561] = 0.92399996519089,
	[562] = 0.75354951620102,
	[563] = 1.8857498168945,
	[564] = 0.23500001430511,
	[565] = 0.6919310092926,
	[566] = 0.90000021457672,
	[567] = 0.97834157943726,
	[568] = 0.97500002384186,
	[569] = 0,
	[570] = 0,
	[571] = 0.33228185772896,
	[572] = 0.63999998569489,
	[573] = 1.215448141098,
	[574] = 0.79393339157104,
	[575] = 0.7399999499321,
	[576] = 0.75,
	[577] = 1.0746998786926,
	[578] = 1.75,
	[579] = 1.098637342453,
	[580] = 0.90752363204956,
	[581] = 0.69976079463959,
	[582] = 1.1549999713898,
	[583] = 0.64689421653748,
	[584] = 2.1593854427338,
	[585] = 0.69692599773407,
	[586] = 0.59700000286102,
	[587] = 0.81000000238419,
	[588] = 1.1393926143646,
	[589] = 0.71692597866058,
	[590] = 0,
	[591] = 1.6541831493378,
	[592] = 2.2973258495331,
	[593] = 1.5501824617386,
	[594] = 0.20966726541519,
	[595] = 1.102756023407,
	[596] = 0.81999969482422,
	[597] = 0.8699996471405,
	[598] = 0.8699996471405,
	[599] = 1.3851264715195,
	[600] = 0.84184813499451,
	[601] = 0.93020880222321,
	[602] = 0.90000009536743,
	[603] = 1.0026750564575,
	[604] = 0.91999995708466,
	[605] = 0.94999998807907,
	[606] = 1.0937063694,
	[607] = 1.0999999046326,
	[608] = 1.5730134248734,
	[609] = 1.210000038147,
	[610] = 0.4003584086895,
	[611] = 0.69189035892487,
}