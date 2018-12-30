----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local function replace()
	for k, v in pairs(tuningUpgrades) do
		if (v.title == "Neon") then
			for i, arr in pairs(v.upgrades) do
				local dff = engineLoadDFF("files/textures/neon/"..arr.color..".dff")
				local col = engineLoadCOL("files/textures/neon/neon.col")
				engineReplaceModel(dff, arr.objectID)
				engineReplaceCOL(col, arr.objectID)
			end
			break
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), replace)