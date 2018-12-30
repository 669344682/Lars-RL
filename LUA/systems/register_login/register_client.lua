---------------------------------------------
---------------------------------------------
------ Copyright (c) 2014 by [THC]Lars ------
---Copyright (c) 2014 by [THC]DjThaKiller----
---------------------------------------------
---------------------------------------------

local sx, sy = guiGetScreenSize()

RegisterWindow = {
    staticimage = {},
    label = {},
    edit = {},
    button = {},
    window = {},
    radiobutton = {},
    combobox = {}
}
RegisterWindow.window[1] = guiCreateWindow(402, 249, 562, 402, "Lars-RL - Registrierung", false)
guiWindowSetMovable(RegisterWindow.window[1], false)
guiWindowSetSizable(RegisterWindow.window[1], false)
guiSetVisible(RegisterWindow.window[1], false)

--RegisterWindow.staticimage[1] = guiCreateStaticImage(10, 29, 540, 125, ":RegisterWindow/client/colorpicker/palette.png", false, RegisterWindow.window[1])

RegisterWindow.label[1] = guiCreateLabel(10, 164, 540, 36, "Herzlch Willkommen!", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[1], "sa-header")
guiLabelSetHorizontalAlign(RegisterWindow.label[1], "center", false)
guiLabelSetVerticalAlign(RegisterWindow.label[1], "center")

RegisterWindow.label[2] = guiCreateLabel(10, 210, 539, 15, "Um auf Lars-RL spielen zu können, musst du einen Account anlegen.", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[2], "default-bold-small")

RegisterWindow.label[3] = guiCreateLabel(14, 241, 163, 15, "Name:", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[3], "clear-normal")
RegisterWindow.edit[1] = guiCreateEdit(14, 256, 163, 23, getPlayerName(localPlayer), false, RegisterWindow.window[1])
guiEditSetReadOnly(RegisterWindow.edit[1], true)

RegisterWindow.label[8] = guiCreateLabel(201, 241, 163, 15, "Geburtsdatum:", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[8], "clear-normal")
RegisterWindow.combobox[1] = guiCreateComboBox(201, 257, 44, 90, "TT", false, RegisterWindow.window[1])
RegisterWindow.combobox[2] = guiCreateComboBox(250, 257, 44, 90, "MM", false, RegisterWindow.window[1])
RegisterWindow.combobox[3] = guiCreateComboBox(300, 257, 64, 90, "JJJJ", false, RegisterWindow.window[1])
for i = 1, 31 do 
	guiComboBoxAddItem(RegisterWindow.combobox[1], i)
end
for i = 1, 12 do 
	guiComboBoxAddItem(RegisterWindow.combobox[2], i)
end
local time = getRealTime()
for i = ((time.year+1900)-10), ((time.year+1900)-50), -1 do 
	guiComboBoxAddItem(RegisterWindow.combobox[3], i)
end
	
RegisterWindow.label[4] = guiCreateLabel(386, 241, 163, 15, "Geschlecht:", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[4], "clear-normal")
RegisterWindow.radiobutton[1] = guiCreateRadioButton(386, 257, 68, 23, "Männlich", false, RegisterWindow.window[1])
RegisterWindow.radiobutton[2] = guiCreateRadioButton(485, 256, 64, 23, "Weiblich", false, RegisterWindow.window[1])
guiRadioButtonSetSelected(RegisterWindow.radiobutton[1], false)
guiRadioButtonSetSelected(RegisterWindow.radiobutton[2], false)

RegisterWindow.label[5] = guiCreateLabel(14, 289, 163, 15, "Passwort:", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[5], "clear-normal")
RegisterWindow.edit[2] = guiCreateEdit(14, 304, 163, 23, "", false, RegisterWindow.window[1])
guiEditSetMasked(RegisterWindow.edit[2], true)

RegisterWindow.label[6] = guiCreateLabel(201, 289, 163, 15, "Passwort (Wdh.):", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[6], "clear-normal")
RegisterWindow.edit[3] = guiCreateEdit(201, 304, 163, 23, "", false, RegisterWindow.window[1])
guiEditSetMasked(RegisterWindow.edit[3], true)

RegisterWindow.label[7] = guiCreateLabel(386, 290, 163, 15, "E-Mail Adresse:", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.label[7], "clear-normal")
RegisterWindow.edit[4] = guiCreateEdit(386, 305, 163, 23, "", false, RegisterWindow.window[1])


RegisterWindow.button[1] = guiCreateButton(177, 343, 209, 44, "Registrieren", false, RegisterWindow.window[1])
guiSetFont(RegisterWindow.button[1], "default-bold-small")
guiSetProperty(RegisterWindow.button[1], "NormalTextColour", "FFAAAAAA")

function showRegisterWindow()
	guiSetVisible(RegisterWindow.window[1], true)
	centerWindow(RegisterWindow.window[1])
	showCursor(true)
	
	addEventHandler("onClientGUIClick", RegisterWindow.button[1], registerSubmit)
end
addEvent("showRegisterWindow", true)
addEventHandler("showRegisterWindow", root, showRegisterWindow)

function registerSubmit(btn, state)
	if (source == RegisterWindow.button[1]) then
		local bDay = tonumber(guiGetText(RegisterWindow.combobox[1])) or 0
		local bMonth = tonumber(guiGetText(RegisterWindow.combobox[2])) or 0
		local bYear = tonumber(guiGetText(RegisterWindow.combobox[3])) or 0
		
		local ok = false
		if (bDay < 29) then
			ok = true
		elseif (bDay == 29 or bDay == 30) and bMonth ~= 2 then
			ok = true
		elseif (bDay == 31 and (bMonth ~= 2 and bMonth ~= 4 and bMonth == 6 and bMonth ~= 9 and bMonth ~= 11)) then
			ok = true
		elseif (bDay == 29 and bMonth == 2 and math.floor((bYear/4)) == (bYear/4)) then
			ok = true
		end
		
		if (ok == true) then
			local pw1 = guiGetText(RegisterWindow.edit[2])
			local pw2 = guiGetText(RegisterWindow.edit[3])
			
			if (string.len(pw1) >= 6) then
				if (pw1 == pw2) then
					local email = guiGetText(RegisterWindow.edit[4])
					if (string.match(email,'^[%w+%.%-_]+@[%w+%.%-_]+%.%a%a+$') == email and string.len(email) >= 7) then
						local sex = 0
						if (guiRadioButtonGetSelected(RegisterWindow.radiobutton[2])) then
							sex = 1
						end
						
						triggerServerEvent("registerPlayer", localPlayer, pw1, birthday, sex, email)
						
						removeEventHandler("onClientGUIClick", RegisterWindow.button[1], registerSubmit)
						guiSetVisible(RegisterWindow.window[1], false)
						showCursor(false)
					else
						notificationShow("error", "Bitte gib eine gültige E-Mail Adresse an.", 5000)
					end
				else
					notificationShow("error", "Die Passwörter stimmen nicht überein.", 5000)
				end
			else
				notificationShow("error", "Das Passwort muss min. 6 Zeichen haben und sollte min. einen Groß- sowie Kleinbuchstaben und eine Zahl enthalten.", 8000)
			end
		else
			notificationShow("error", "Bitte gib ein gültiges Geburtsdatum an.", 5000)
		end
	end
end