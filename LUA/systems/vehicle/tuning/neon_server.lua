----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local colorObjects = {}
for k, v in pairs(tuningUpgrades) do
	if (v.title == "Neon") then
		for i, arr in pairs(v.upgrades) do
			colorObjects[arr.color] = arr.objectID
			removeWorldModel(arr.objectID, 50000, 0, 0, 0)
		end
		break
	end
end

function destroyNeonElements(veh)
	local source = source
	if (veh) then source = veh end
	if not getElementData(source, "neonele") then return end
	
	local tubes = getElementData(source, "neonele")
	if (tubes) then
		if (isElement(tubes[1])) then
			destroyElement(tubes[1])
		end
		if (isElement(tubes[2])) then
			destroyElement(tubes[2])
		end
	end
	removeEventHandler("onElementDestroy", source, destroyNeonElements)
end

function attachNeonElements(veh, color)
	local source = source
	if (veh) then source = veh end
	local tubes = getElementData(source, "neonele")
	if (not tubes) then
		local x, y, z = getElementPosition(veh)
		local rx, ry, rz = getElementRotation(veh)
		
		local hand = getVehicleHandling(veh)
		local rDis = hand["suspensionLowerLimit"]
		
		local zDis = vehicleCentreOfMass[getElementModel(veh)]
		
		local neon1 = createObject(colorObjects[color], x, y, z)
		setElementRotation(neon1, rx, ry, rz)
		setElementInterior(neon1, getElementInterior(veh))
		setElementDimension(neon1, getElementDimension(veh))
		
		local neon2 = createObject(colorObjects[color], x, y, z)
		setElementRotation(neon2, rx, ry, rz)
		setElementInterior(neon2, getElementInterior(veh))
		setElementDimension(neon2, getElementDimension(veh))
		
		local fix = 0.1
		local vID = getVehID(veh)
		if (vID ~= nil) then
			local tunings	= fromJSON(Vehicles[vID].data["specialupgrades"])
			if (type(tunings["tiefer"]) == "number") then
				if (tunings["tiefer"] >= 5) then
					fix = fix + 0.3
				elseif (tunings["tiefer"] >= 4) then
					fix = fix + 0.2
				elseif (tunings["tiefer"] >= 3) then
					fix = fix + 0.15
				elseif (tunings["tiefer"] >= 2) then
					fix = fix + 0.1
				end
			end
		end
		attachElements(neon1, veh, 0.8, 0, -((zDis+rDis)-fix))
		attachElements(neon2, veh, -0.8, 0, -((zDis+rDis)-fix))
		
		setElementData(veh, "neonele", {neon1, neon2})
		addEventHandler("onElementDestroy", veh, destroyNeonElements)
		
		return true
	else
		return false
	end
end
function removeNeonElements(veh)
	if not veh then return end
	local neonElement = getElementData(veh, "neonele")
	if (neonElement) then
		destroyElement(neonElement[1])
		destroyElement(neonElement[2])
		removeElementData(veh, "neonele")
	end
	removeEventHandler("onElementDestroy", veh, destroyNeonElements)
end

function toggleNeon(veh, bool)
	local vID = getVehID(veh)
	if (vID ~= nil) then
		local color = Vehicles[vID].data["neon"]
		if (color ~= "") then
			
			if (bool) then
				attachNeonElements(veh, color)
			else
				removeNeonElements(veh)
			end
			
		end
	end
end


addEvent("neonPreviewAdd", true)
addEventHandler("neonPreviewAdd", root, function(color)
	local veh = getPedOccupiedVehicle(source)
	toggleNeon(veh, false)
	attachNeonElements(veh, color)
end)

addEvent("neonPreviewRemove", true)
addEventHandler("neonPreviewRemove", root, function()
	local veh = getPedOccupiedVehicle(source)
	removeNeonElements(veh, false)
	toggleNeon(veh, true)
end)