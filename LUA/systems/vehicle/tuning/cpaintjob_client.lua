----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local textures	= {}
local paintJobs = {}
local function togglePaintjob(veh, bool)
	if (bool) then
		local pj = getElementData(veh, "cPaintjob")
		if (pj) then
			local shader = dxCreateShader("/files/textures/cpaintjob.fx")
			engineApplyShaderToWorldTexture(shader, "vehiclegrunge256", veh)
			engineApplyShaderToWorldTexture(shader, "?emap*", veh)
			if (not textures[pj]) then
				textures[pj] = dxCreateTexture("/files/images/tuning/cpaintjobs/"..pj..".jpg")
			end
			dxSetShaderValue(shader, "import_texture", textures[pj])
			paintJobs[veh] = shader
		end
	else
		destroyElement(paintJobs[veh])
	end
end


addEventHandler("onClientElementStreamIn", root, function()
	if (getElementType(source) == "vehicle") then
		togglePaintjob(source, true)
		if (getElementData(source,"owner")) then
			--outputChatBox("LOAD PAINTJOB: "..getElementData(source,"owner").." - "..getElementData(source,"slot"))
		end
	end
end)
addEventHandler("onClientElementStreamOut", root, function()
	if (getElementType(source) == "vehicle") then
		togglePaintjob(source, false)
		if (getElementData(source,"owner")) then
			--outputChatBox("UNLOAD PAINTJOB: "..getElementData(source,"owner").." - "..getElementData(source,"slot"))
		end
	end
end)