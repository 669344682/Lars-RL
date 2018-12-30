addEventHandler("onClientPlayerWasted", localPlayer, function()
	triggerServerEvent("playerSpawn", localPlayer, localPlayer)
end)