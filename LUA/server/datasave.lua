------------------------------------------------------------
------------------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
------------------------------------------------------------
------------------------------------------------------------

function datasave(player)
	local source = source
	if (player and type(player) == "userdata" and getElementType(player) == "player") then source = player end
		
	if (isLoggedin(source)) then
		local pName = getPlayerName(source)
		
		local fields = ""
		fields = fields..dbPrepareString(" SpawnPos=?, ",			getElementData(source, "SpawnPos"))
		fields = fields..dbPrepareString(" Playingtime=?, ",		getElementData(source, "Playingtime"))
		fields = fields..dbPrepareString(" Money=?, ",				getPlayerMoney(source))
		fields = fields..dbPrepareString(" BankMoney=?, ",			getPlayerBankMoney(source))
		fields = fields..dbPrepareString(" Kills=?, ",				getElementData(source, "Kills"))
		fields = fields..dbPrepareString(" Deaths=?, ",				getElementData(source, "Deaths"))
		fields = fields..dbPrepareString(" Jailtime=?, ",			getElementData(source, "JailTime"))
		fields = fields..dbPrepareString(" Deathtime=?, ",			getElementData(source, "DeathTime"))
		fields = fields..dbPrepareString(" Wanteds=?, ",			getPlayerWantedLevel(source))
		fields = fields..dbPrepareString(" Stvo=?, ",				getElementData(source, "Stvo"))
		fields = fields..dbPrepareString(" LastFactionChange=?, ",	getElementData(source, "LastFactionChange"))
		fields = fields..dbPrepareString(" Job=?, ",				getElementData(source, "Job"))
		fields = fields..dbPrepareString(" JobLevels=?, ",				getElementData(source, "JobLevels"))
		fields = fields..dbPrepareString(" JobEarnings=?, ",				getElementData(source, "JobEarnings"))
		fields = fields..dbPrepareString(" SkinID=?, ",				getElementData(source, "SkinID"))
		fields = fields..dbPrepareString(" TelNR=?, ",				getElementData(source, "telNR"))
		fields = fields..dbPrepareString(" SocialState=?, ",		getElementData(source, "SocialState"))
		fields = fields..dbPrepareString(" MaxCars=?, ",			getElementData(source, "MaxCars"))
		fields = fields..dbPrepareString(" Inventory=?, ",			toJSON(Inventories["player"][source]))
		fields = fields..dbPrepareString(" Hunger=? ",				getElementData(source, "Hunger"))
		
		dbExec("UPDATE userdata SET "..fields.." WHERE Name LIKE ?", pName)
		fields = ""
		
		
		
		outputDebugString("[Server->Datasave]: Saved data from "..pName..".")
	end
end
addEventHandler("onPlayerQuit", root, datasave)