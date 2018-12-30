----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

MySQL = {}
MySQL.handler = nil

function MySQL:connect () 
	self.handler = dbConnect("mysql", "dbname="..settings.general.mysql.database.. ";host="..settings.general.mysql.host..";port="..settings.general.mysql.port, settings.general.mysql.user, settings.general.mysql.password)
	if (self.handler) then
		dbExec("SET NAMES utf8;")
		return true
	end
	
	return false
end

function MySQL:disconnect () 
	return destroyElement(self.handler)
end

local _dbQuery = dbQuery
function dbQuery(...)
  return _dbQuery(MySQL.handler, ...)
end

local _dbExec = dbExec
function dbExec(...)
  return _dbExec(MySQL.handler, ...)
end

local _dbPrepareString = dbPrepareString
function dbPrepareString(...)
	return _dbPrepareString(MySQL.handler, ...)
end



function MySQL:fetchRow(tbl, condition)
	if (self.handler) then
		
		local query = dbQuery("SELECT * FROM `??` WHERE "..condition, tbl)
		if (query) then
			
			local res = dbPoll(query, -1)
			if (res and res[1]) then
				
				return res[1]
				
			end
			
		end
		
	end
	return false
end

function MySQL:getValue(tbl, field, condition)
	if (self.handler) then
		
		local query = dbQuery("SELECT `??` FROM `??` WHERE "..condition, field, tbl)
		if (query) then
			
			local res = dbPoll(query, -1)
			if (res and res[1]) then
				
				local ret = res[1][field]
				if (tonumber(ret) ~= nil) then
					return tonumber(ret)
				end
				return tostring(ret)
				
			end
			
		end
		
	end
	return false
end

function MySQL:setValue(tbl, field, value, condition)
	if (self.handler) then
		
		return dbExec("UPDATE `??` SET `??`=? WHERE "..condition, tbl, field, value)
		
	end
	return false
end

function MySQL:delRow(tbl, condition)
	if (self.handler) then
		
		return dbExec("DELETE FROM `??` WHERE "..condition, tbl)
		
	end
	return false
end

function MySQL:rowExists(tbl, condition)
	if (self.handler) then
		
		local query = dbQuery("SELECT * FROM `??` WHERE "..condition, tbl)
		if (query) then
			
			local res = dbPoll(query, -1)
			if (res and #res > 0) then
				
				return true
				
			end
			
		end
		
	end
	return false
end