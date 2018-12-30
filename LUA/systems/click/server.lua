----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

function cursorShow(player, key, state)
	triggerClientEvent(player, "cursorShow", player, key, state)
end

function playerClick(mouseButton, buttonState, clickedElement, x, y, z, screenPosX, screenPosY)
	if (buttonState == "down") then
		if (isLoggedin(source)) then
			if (getElementData(source, "clicked") == false) then
				if (clickedElement and isElement(clickedElement)) then
					if (mouseButton == "left") then
						
						
						if (getElementType(clickedElement) == "player") then
							
							if (clickedElement == source) then
								outputChatBox("You Clicked on yourself", source)
							else
								outputChatBox("You Clicked on "..getPlayerName(clickedElement), source)
							end
							
						elseif (getElementType(clickedElement) == "ped") then
							if (tonumber(getElementData(clickedElement, "jobPed")) ~= nil) then
								Jobs:PedClick(source, getElementData(clickedElement, "jobPed"))
							end
							
						elseif (getElementType(clickedElement) == "vehicle") then
							
							if (getElementData(clickedElement, "playerCar") == true) then
								if (getElementData(clickedElement, "inTuning") == false) then
									triggerClientEvent(source, "showVehicleInfos", source, getVehData(clickedElement))
								end	
							end
							
							
						elseif (getElementType(clickedElement) == "object") then
							
							local modelID = getElementModel(clickedElement)
							
							outputChatBox("clicked on: "..modelID)
							if (modelID == 3409 and getElementData(clickedElement, "weed")) then -- Weed
								outputChatBox("You Clicked a Weed-Plant.", source)
								
							elseif (modelID == 2942 or modelID == 3903) then -- kbm_atm1
								triggerClientEvent(source, "showBank", source)
								
							elseif (modelID == 2886) then -- sec_keypad
								
							elseif (modelID == 2922) then -- kmb_keypad
								if (getElementData(clickedElement, "bankKeyPad") == true) then
									moveDoorToVault(source)
								end
								
							elseif (modelID == 2332 or modelID == 1829) then -- tresor
								if (tonumber(getElementData(clickedElement, "isVault")) ~= nil) then
									openVault(source, getElementData(clickedElement, "isVault"))
								end
								
							elseif (getElementData(clickedElement, "furnitureObject") == true) then
								local owner = getElementData(clickedElement, "furnitureObjectOwner")
								if (House.houseIdOwner[owner]) then
									owner = House.houseIdOwner[owner]
								end
								infoShow(source, "info", "Dieses Objekt gehört "..owner)
								
							end
						
						end
						
						
						
						
						
						
						
						
					elseif (mouseButton == "middle") then
						if (getElementType(clickedElement) == "object") then
							
							if (getElementData(clickedElement, "furnitureObject") == true) then
								pickupObject(source, clickedElement)
							end
							
						elseif (getElementType(clickedElement) == "vehicle") then
							
							if (getElementData(clickedElement, "playerCar") == true) then
								if (getElementData(clickedElement, "inTuning") == false) then
									if (hasPlayerVehKey(source, clickedElement)) then
										openVhInventory(source, clickedElement)
									else
										notificationShow(source, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
									end
								end	
							end
							
						end
						
						
						
						
						
						
						
					elseif (mouseButton == "right") then -- Mit Objekten Interagieren / Schnellaktionen
						
						if (getElementType(clickedElement) == "player") then
							
							if (clickedElement ~= source) then
								openInventory(source, clickedElement)
							end
						
						elseif (getElementType(clickedElement) == "vehicle") then
							if (getElementData(clickedElement, "inTuning") == false) then
								if (hasPlayerVehKey(source, clickedElement)) then
									lockVeh(clickedElement)
								else
									notificationShow(source, "error", "Du hast keinen Schlüssel für dieses Fahrzeug.")
								end
							end
						
						
						elseif (getElementType(clickedElement) == "object") then
							
							if (getElementData(clickedElement, "furnitureObject") == true) then
								triggerEvent("startObjectPlacer", source, clickedElement)
							end
							
						end
						
						
					end
				end
			end
		end
	end
end
addEventHandler("onPlayerClick", root, playerClick)
addEvent("onPlayerClickFurn", true)
addEventHandler("onPlayerClickFurn", root, playerClick)