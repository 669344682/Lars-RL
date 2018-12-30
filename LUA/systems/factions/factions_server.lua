----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

Factions = {}
Factions.LeaderRank = 5
Factions.factions = {
	[1]				= {
		name			= "LSPD",
		color			= {0, 255, 0},
		ranks			= {
			[0]		= "Rank 0",
			[1]		= "Rank 1",
			[2]		= "Rank 2",
			[3]		= "Rank 3",
			[4]		= "Rank 4",
			[5]		= "Rank 5",
		},
		skins			= {
			-- rank -> skins
			[0]		= {284},
			[1]		= {282, 283, 288},
			[2]		= {280, 267},
			[3]		= {265, 266},
			[4]		= {281},
			[5]		= {285},
		},
		state			= true,
		evil			= false,
		
	},
}

function Factions:Init()
	local sql = dbQuery("SELECT * FROM factions")
	if (sql) then
		local result, num_affected_rows = dbPoll(sql, -1)
		if (num_affected_rows > 0) then
			for i, row in pairs(result) do
				
				Factions.factions[(row['ID'])]['money'] = tonumber(row['money'])
				
				Factions.factions[(row['ID'])]['members'] = {}
				local sql2 = dbQuery("SELECT * FROM userdata WHERE Faction=?;", row['ID'])
				if (sql2) then
					local result2, num_affected_rows2 = dbPoll(sql2, -1)
					if (num_affected_rows2 > 0) then
						for i2, row2 in pairs(result2) do
							Factions.factions[(row['ID'])]['members'] = tonumber(row2['FactionRank'])
						end
					end
				end
				
			end
		end
	end
end







function Factions:GetFaction(player)
	if (type(player) ~= "string") then player = getPlayerName(player) end
	
	local ret = false
	for k, v in pairs(self.factions) do
		if (tonumber(v['members'][player]) ~= nil) then
			ret = k
			break
		end
	end
	
	return ret
end

function Factions:SetFaction(player, faction, rank)
	if (type(player) ~= "string") then player = getPlayerName(player) end
	if (not rank) then rank = 0 end
	
	if (not self:GetFaction(player)) then
		self.factions[faction]['members'][player] = rank
	end
	
	return false
end

function Factions:RemoveFaction(player, faction)
	if (type(player) ~= "string") then player = getPlayerName(player) end
	
	if (self:GetFaction(player) ~= false) then
		self.factions[faction]['members'][player] = nil
	end
	
	return false
end



function Factions:GetRank(player)
	if (type(player) ~= "string") then player = getPlayerName(player) end
	
	local f = self:GetFaction(player)
	if (f) then
		return tonumber(self.factions[f]['members'][player])
	end
	
	return -1
end

function Factions:SetRank(player, rank)
	if (type(player) ~= "string") then player = getPlayerName(player) end
	rank = tonumber(rank)
	
	if (rank ~= nil and rank >= 0) then
		local f = self:GetFaction(player)
		if (f) then
			self.factions[f]['members'][player] = rank
			return true
		end
	end
	return false
end



function Factions:IsMemberOf(player, faction)
	local c = self:GetFaction(player)
	if (c == faction) then
		return true
	end
	return false
end

function Factions:IsLeaderOf(player, faction)
	if (self:IsMemberOf(player, faction) and self:GetRank(player) >= self.LeaderRank) then
		return true
	end
	return false
end






