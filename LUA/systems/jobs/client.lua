----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local w, h = 500, 422
local function JobGui(jobID, jobName, jobDesc, levels, myLevel)
	local window = dxWindow:new(jobName, nil, nil, w, h)
	
	dxImage:new(15, 10, 472, 163, "files/images/jobs/gabelstaplerfahrer.png", window)
	
	dxText:new(15, 190, 472, 130, jobDesc, window, "left", 1, 'exo-10', nil, false)
	
	
	local lvlAdd = 0
	if (type(levels) == "table") then
		dxText:new(20, 315, 400, 10, "Joblevel: "..myLevel, window, "left", 1, 'exo-bold-10', nil, false)
		
		local rand		= 30
		if (#levels > 3) then rand = 15 end
		local maxW	= 470
		local wPer		= (470-((#levels*rand)-1))/#levels
		for k, v in ipairs(levels) do
			dxButton:new((rand/4)+rand+(wPer*(k-1))+(rand*(k-1)), 335, wPer, 50, v.name, window, function() triggerServerEvent("Jobs:Start", localPlayer, jobID, k) window:close()  end, nil, nil, 1)
		end
		
		lvlAdd = 92
		window:resize(w, h+lvlAdd, true)
	end
	
	
	if (tonumber(getElementData(localPlayer, "Job")) == jobID and lvlAdd == 0) then
		dxButton:new(45, 320+lvlAdd, 185, 40, "Starten", window, function() triggerServerEvent("Jobs:Start", localPlayer, jobID, nil) window:close()  end, nil, nil, 1)
	
	else
		dxButton:new(45, 320+lvlAdd, 185, 40, "Annehmen", window, function() triggerServerEvent("Jobs:Accept", localPlayer, jobID) window:close() end, nil, nil, 1)
	end
	local cancel = dxButton:new(275, 320+lvlAdd, 185, 40, "Kündigen", window, function() triggerServerEvent("Jobs:Cancel", localPlayer, jobID) window:close() end, nil, nil, 1)
	
end
addEvent("JobGui", true)
addEventHandler("JobGui", root, JobGui)
