function adjustPlayerHead ()
	if (getCameraTarget()) then
		local x, y, z = getWorldFromScreenPosition(sx / 2, sy / 2, 50)
		setPedLookAt(localPlayer, x, y, z, -1, nil)
	end
end
setTimer(adjustPlayerHead, 100, 0)

setAmbientSoundEnabled("gunfire", false)
setWorldSpecialPropertyEnabled("extraairresistance", false)