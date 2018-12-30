----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local OBJECTS	= {}
local CAT		= 0
local object	= createObject(1337, 1407.9, -579.8, 4005.2)
setElementCollisionsEnabled(object, false)
setElementFrozen(object, true)

local function onSwitch(nr)
	setElementModel(object, OBJECTS[nr].id)
end

local function renderObject()
	local rx, ry, rz = getElementRotation(object)
	setElementRotation(object, rx, ry, rz+0.8)
	
end

local function onClose()
	fadeCamera(false, 1, 0, 0, 0)
	setTimer(function()
		fadeCamera(true)
		setCameraTarget(localPlayer, localPlayer)
		destroyProductSelect()
		toggleAllControls(true, true, true)
		triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, false)
		removeEventHandler("onClientRender", root, renderObject)
		setElementFrozen(localPlayer, false)
		setElementStreamable(object, true)
	end, 1700, 1)
end

local function onBuy(nr)
	--onClose()
	triggerServerEvent("skykeaBuy", localPlayer, CAT, nr)
end

addEvent("openSkykea", true)
addEventHandler("openSkykea", root, function(tbl, kat)
	OBJECTS = tbl
	CAT		= kat
	toggleAllControls(false, false, false)
	setElementFrozen(localPlayer, true)
	
	setElementDimension(object, getElementDimension(localPlayer))
	setElementInterior(object, getElementInterior(localPlayer))
	setElementStreamable(object, false)
	
	fadeCamera(false, 1, 0, 0, 0)
	setTimer(function()
		fadeCamera(true)
		setCameraMatrix(1407.9, -590.1, 4005.7, 1407.9, -400.7, 4006.5)
		displayProductSelect("SKYKEA", OBJECTS, onSwitch, onBuy, onClose, "/files/images/productlist/skykea.png")
		addEventHandler("onClientRender", root, renderObject)
	end, 1700, 1)
	
end)
