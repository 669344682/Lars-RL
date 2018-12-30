----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local sounds = {}

addEvent("playSound", true)
addEventHandler("playSound", root, function(sound, loop, volume)
	if (sounds[sound] ~= nil and isElement(sounds[sound])) then
		stopSound(sounds[sound])
		sounds[sound] = nil
	end
	
	if (loop == nil) then loop = false end
	if (volume == nil) then volume = 0.6 end
	
	sounds[sound] = playSound("files/sounds/"..sound..".mp3", loop)
	setSoundVolume(sounds[sound], volume)
end)

addEvent("playSound3D", true)
addEventHandler("playSound3D", root, function(sound, x, y, z, loop, volume)
	if (sounds[sound] ~= nil and isElement(sounds[sound])) then
		stopSound(sounds[sound])
		sounds[sound] = nil
	end
	
	if (loop == nil) then loop = false end
	if (volume == nil) then volume = 0.6 end
	
	sounds[sound] = playSound3D("files/sounds/"..sound..".mp3", x, y, z, loop)
	setSoundVolume(sounds[sound], volume)
end)
