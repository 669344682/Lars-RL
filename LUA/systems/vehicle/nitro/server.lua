addEvent("syncNitro", true)
addEventHandler("syncNitro", root, function(veh, count, level)
	setElementData(veh, "nitrocount", count)
	if (tonumber(level) ~= nil) then
		setElementData(veh, "nitrolevel", level)
	end
end)
addEvent("activateNitro", true)
addEventHandler("activateNitro", root, function(veh, state, players)
	for k, v in pairs(players) do
		if (k and isElement(k) and k ~= source) then
			triggerClientEvent(k, "activateNitroClient", k, veh, state)
		end
	end
end)


addEventHandler("onVehicleStartEnter", root, function(player, seat, jacked, door)
	if (seat == 0) then
		local count = getElementData(source, "nitrocount")
		if (not count or tonumber(count) ~= nil) then
			local count = 0
			local id	= getVehicleUpgradeOnSlot(source, 8)
			if (id == 1009) then
				count = 10
			elseif (id == 1008) then
				count = 20
			elseif (id == 1010) then
				count = 30
			end
			if (count ~= 0) then
				setElementData(source, "nitrocount", count)
			end
		end
	end
end)