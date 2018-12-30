----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


-- Wichtig: die settings_both muss vor der settings_server geladen werden!

local ServerSettings = {
	general = {
		mysql = {
			host						= "127.0.0.1",
			port						= "3306",
			user						= "user",
			password					= "pass",
			database					= "db"
		},
		apiSalz							= "REPLACE READ INSTALL.TXT",
	},
}

tableMerge(settings, ServerSettings)


allowedDoubleAccounts = {
	["SERIAL"] = 2, -- Serial = Anzahl
}