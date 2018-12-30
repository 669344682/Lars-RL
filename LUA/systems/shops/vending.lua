----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local vendingPrice		= 5
local vendingTypes	= {
	[955]		= "sprunk",
	[1775]		= "sprunk",
	
	[1302]		= "soda",
	[1209]		= "soda",
	
	[956]		= "candy",
	[1776]		= "candy",
	
	[18214]	= "cigarettes",
}


function useVendingMachine(objectID)
	if (type(vendingTypes[objectID]) == "string") then
		if (getPlayerMoney(source) >= vendingPrice) then
			if (vendingTypes[objectID] == "candy") then
				addInventory(source, "schoko", 1)
			elseif (vendingTypes[objectID] == "cigarettes") then
				addInventory(source, "cigarettes", 1)
			else
				addInventory(source, "sprunk", 1)
			end
			
			takePlayerMoney(source, vendingPrice, "Automat")
			
		else
			infoShow(source, "error", "Du hast nicht genügend Geld.")
		end
			
	end
end
addEvent("useVendingMachine", true)
addEventHandler("useVendingMachine", root, useVendingMachine)