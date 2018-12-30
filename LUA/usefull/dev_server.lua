function vanish_test(player)
	local x,y,z = getElementPosition(player)
	local elem = createVehicle(411, x+3, y+3, z+1)
	warpPedIntoVehicle(player, elem)
	setTimer(vanishElement, 2500, 1, elem)
end
if (settings.general.DEBUG) then addCommandHandler("vsh", vanish_test) end

function createAtm(player)
	local x,y,z = getElementPosition(player)
	local elem = createObject(2942, x+3, y+3, z)
	setTimer(vanishElement, 15000, 1, elem)
end
if (settings.general.DEBUG) then addCommandHandler("atm", createAtm) end

function esffdsaf(player)
	local x,y,z = getElementPosition(player)
	local elem = createObject(1215, x+3, y+3, z)
	setElementDimension(elem, getElementDimension(player))
	setElementInterior(elem, getElementInterior(player))
	setElementData(elem, "furnitureObject", true)
	setElementData(elem, "furnitureObjectOwner", getPlayerName(player))
end
if (settings.general.DEBUG) then  addCommandHandler("bol", esffdsaf) end

function esffdsaf(player, cmd, id)
	local x,y,z = getElementPosition(player)
	local elem = createObject(id, x+3, y+3, z)
	setElementDimension(elem, getElementDimension(player))
	setElementInterior(elem, getElementInterior(player))
	setElementData(elem, "furnitureObject", true)
	setElementData(elem, "furnitureObjectOwner", getPlayerName(player))
end
if (settings.general.DEBUG) then  addCommandHandler("object", esffdsaf) end


function sspawn(player)
	local x,y,z = getElementPosition(player)
	local _,_,rz = getElementRotation(player)
	local i = getElementInterior(player)
	local d = getElementDimension(player)
	local p = toJSON({x,y,z,rz,i,d})
	
	setElementData(player, "SpawnPos", p)
	MySQL:setValue("userdata", "SpawnPos", p, "Name='"..getPlayerName(player).."'")
	
	outputChatBox("UPDATED SPAWNPOS!", player)
end
if (settings.general.DEBUG) then addCommandHandler("spawn", sspawn) end

--[[
function sPed(x,y)
	local ped = createPed(0, 1455-x, 1439-y, 13.2)
	setElementData(ped, "Adminlvl", 5)
	setElementData(ped, "SocialState", "SocialState")
end
for a = 0, 10 do
	for b = 0, 10 do
		sPed((1*b), a)
	end
end
]]












function runString (commandstring, outputTo, source)
	me = source
	local sourceName = source and getPlayerName(source) or "Console"
	
	outputChatBox(sourceName.." executed command: "..commandstring, outputTo, true)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBox("Error: "..errorMsg, outputTo)
		return
	end
	--Finally, lets execute our function
	local results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBox("Error: "..results[2], outputTo)
		return
	end
	
	local resultsString = ""
	local first = true
	for i = 2, #results do
		if first then
			first = false
		else
			resultsString = resultsString..", "
		end
		local resultType = type(results[i])
		if isElement(results[i]) then
			resultType = "element:"..getElementType(results[i])
		end
		resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
	end
	
	if #results > 1 then
		outputChatBox("Command results: " ..resultsString)
		return
	end
	
	outputChatBox("Command executed!")
end

-- run command
if (settings.general.DEBUG) then
addCommandHandler("runs",
	function (player, command, ...)
		local commandstring = table.concat({...}, " ")
		return runString(commandstring, root, player)
	end
)
end