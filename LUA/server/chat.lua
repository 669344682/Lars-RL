------------------------------------------------------------
------------------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
------------------------------------------------------------
----------------------------------------------------

chatTeam = createTeam("ChatTeam", 255, 255, 255)

local function canPlayerChat(player)
	if (isLoggedin(player) and isPedDead(player) == false and isPlayerMuted(player) == false) then
		return true
	end
	return false
end


function sendMsgOnlyNearbyPlayers(message, messageType)
	--cancelEvent()
	local pName				= getPlayerName(source)
	local x, y, z			= getElementPosition(source)
	local chatSphere		= createColSphere(x, y, z, 10)
	local nearbyPlayers		= getElementsWithinColShape(chatSphere, "player")
	
	if (not isPlayerMuted(source)) then
		if (canPlayerChat(source)) then
			
			local dim = getElementDimension(source)
			local typ = ""
			
			if (messageType == 0) then -- normal Message
				local fix = ""
				if (getElementData(source, "callState") == true) then
					fix = " (Handy)"
				end
				for _, nearbyPlayer in ipairs(nearbyPlayers) do
					local x2, y2, z2	= getElementPosition(nearbyPlayer)
					local distance		= getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
					local rgb			= 15 * distance - 125
					local rgb			= math.abs(rgb - 255) + 125
					if (dim == getElementDimension(nearbyPlayer)) then
						outputChatBox(pName..tostring(fix)..": "..message, nearbyPlayer, rgb, rgb, rgb)
					end
				end
				
				typ = "SAY"
				
			elseif (messageType == 1) then -- /me
				for _, nearbyPlayer in pairs(nearbyPlayers) do
					if (dim == getElementDimension(nearbyPlayer)) then
						outputChatBox(pName.." "..message, nearbyPlayer, 200, 0, 200)
					end
				end
				
				typ = "ME"
				
			elseif (messageType == 2) then -- Team Message (y)
				--teamchat(source, message)
				
				typ = "TEAM"
				
			end
			
			outputLog("chat", "["..typ.."]: "..message, pName)
			
		end
	else
		notificationShow(player, "error", "Du wurdest gemuted.")
	end
	
	destroyElement(chatSphere)
end
addEventHandler("onPlayerChat", root, function()
	if (not settings.general.DEBUG) then
		cancelEvent(true)
	end
end)
addEventHandler("onPlayerChat", root, sendMsgOnlyNearbyPlayers)