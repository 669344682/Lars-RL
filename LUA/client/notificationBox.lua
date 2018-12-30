----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local notification = {
	display = false,
	sound = nil
}

function notificationShow(typ, text, lng)
	local time = string.len(text)*50
	if (time < 5000) then
		time = 5000
	end
	if (tonumber(lng) ~= nil) then time = lng*1000 end
	
	notification = {
		display = true,
		image = "files/images/notification/"..typ..".png",
		text = text,
		startTick = getTickCount(),
		curYpos = 0,
		time = time,
		timer = nil,
		state = "starting",
		sound = nil
	}
	
	if (notification.sound) then
		destroyElement(notification.sound)
		notification.sound = nil
	end
	setTimer(function()
		notification.sound = playSound("files/sounds/notification.mp3")
		setSoundVolume(notification.sound, 0.5)
	end, 250, 1)
	
	setWindowFlashing(true, 9999)
end
addEvent("notificationShow", true)
addEventHandler("notificationShow", root, notificationShow)

addEventHandler("onClientRender", root, function ()
	if (notification.display == true) then
		
		if (notification.state == "starting") then
			local progress = (getTickCount() - notification.startTick) / notification.time
			local intY = interpolateBetween(-130, 0, 0, 30, 0, 0, progress, "OutElastic")
			if intY then
				notification.curYpos = intY
			else
				notification.curYpos = 100
			end
			if (progress > 1) then
				notification.state = "showing"
				notification.timer = setTimer(function()
					notification.startTick = getTickCount()
					notification.state = "hiding"
				end, notification.time, 1)
			end
		elseif (notification.state == "showing") then
			notification.curYpos = 30
		elseif (notification.state == "hiding") then
			local progress = (getTickCount() - notification.startTick) / (notification.time/2)
			local intY = interpolateBetween(30, 0, 0, -190, 0, 0, progress, "Linear")
			if (intY) then
				notification.curYpos = intY
			else
				notification.curYpos = 100
			end
			if progress > 1 then
				notification.display = false
				notification.state = nil
				return
			end
		else
			return
		end
		
		local x, y = (screenX/2 - 512/2), notification.curYpos
		local textX, textY = x+155, notification.curYpos+35
		local textWidth, textHeight = 345, 50
		dxDrawImage(x, y, 512, 150, notification.image, 0, 0, 0, tocolor(255,255,255), true)
		dxDrawText(notification.text, textX, textY, textX+textWidth, textY+textHeight, tocolor(222,222,222), 1, "default-bold", "center", "top", false, true, true)
	end
end)
