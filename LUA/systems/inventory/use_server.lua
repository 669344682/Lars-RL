----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


-- EAT --
local eatShit = {}
local smokeShit = {}

local function eatIt(player)
	if (type(eatShit[player]) == "table") then
		local t = eatShit[player]
		if (t.canEat == true) then
			givePlayerHunger(player, (t.health/8))
			setPedAnimation(player,t.block,t.anim,100,false,false,false)
			
			if (t.times >= 8) then
				unbindKey(player, "mouse2", "down", eatIt)
				setTimer(function(p)
					detachElementFromBone(eatShit[p].object)
					destroyElement(eatShit[p].object)
					eatShit[p] = nil
				end, t.animtime, 1, player)
				
			else
				
				eatShit[player].times = t.times + 1
				eatShit[player].canEat = false
				setTimer(function(p)
					eatShit[p].canEat = true
				end, t.animtime, 1, player)
			end
		end
	end
end
function eatSomething(player, health, block, anim, animtime, objectID, bone, x, y, z, rx, ry, rz)
	if (not block) then block, anim = "food", "eat_burger" end
	
	if (not eatShit[player] and not smokeShit[player]) then
		if (objectID) then
			local obj = createObject(objectID, 0, 0, 0)
			setElementDimension(obj, getElementDimension(player))
			setElementInterior(obj, getElementInterior(player))
			attachElementToBone(obj, player, bone, x, y, z, rx, ry, rz)
			eatShit[player] = {
				times = 0,
				health = health,
				block = block,
				anim = anim,
				object = obj,
				animtime = animtime,
				canEat	= true,
			}
			bindKey(player, "mouse2", "down", eatIt)
			return true
		
		else
			setPedAnimation(player,block,anim,1000,false,false,false)
			givePlayerHunger(player, health)
			return true
		end
	end
	
	return false
end


--[[
addCommandHandler("srot", function(p, _, a, b)
	ped,bone,_,_,_,x,y,z = getElementBoneAttachmentDetails(eatShit[p].object)
	if (a == "x") then
		x = x + 5
	elseif (a == "y") then
		y = y + 5
	elseif (a == "z") then
		z = z + 5
	end
	setElementBoneRotationOffset(eatShit[p].object,x,y,z)
	outputChatBox(x..","..y..","..z)
end)
addCommandHandler("spos", function(p, _, a, b)
	ped,bone,x,y,z = getElementBoneAttachmentDetails(eatShit[p].object)
	if (a == "x") then
		x = x + 0.1
	elseif (a == "y") then
		y = y + 0.1
	elseif (a == "z") then
		z = z + 0.1
	end
	setElementBonePositionOffset(eatShit[p].object,x,y,z)
	outputChatBox(x..","..y..","..z)
end)
]]



-- SMOKE --
local function smokeIt(player)
	if (type(smokeShit[player]) == "table") then
		if (smokeShit[player].canSmoke == true) then
			setPedAnimation(player, "smoking", "m_smk_drag", 3000, false, false, false, false)
			
			if (smokeShit[player].times >= 8) then
				smokeShit[player].canSmoke = false
				setTimer(function(player)
					setPedAnimation(player, "smoking", "m_smk_out", 3000, false, false, false, false)
					
					setTimer(function(player)
						detachElementFromBone(smokeShit[player].object)
						local x, y, z = getElementPosition(player)
						local _, _, rz = getElementRotation(player)
						setElementCollisionsEnabled(smokeShit[player].object, false)
						setElementPosition(smokeShit[player].object, x, y, z+0.4)
						local xv, yv = getPointFromDistanceRotation2(x, y, 3, rz)
						moveObject(smokeShit[player].object, 800, xv, yv, z-0.80)
						
						setTimer(function(ele)
							vanishElement(ele)
						end, 15000, 1, smokeShit[player].object)
						smokeShit[player] = false
					end, 2500, 1, player)
					
				end, 3000, 1, player)
				
				unbindKey(player, "mouse2", "down", smokeIt)
			else
				smokeShit[player].times = smokeShit[player].times + 1
				smokeShit[player].canSmoke = false
				setTimer(function(p)
					smokeShit[p].canSmoke = true
				end, 3000, 1, player)
			end
		end
	end
end
function smokeCigarette(player)
	if (getInventoryCount(player, "cigarettes") > 0) then
		if (not smokeShit[player] and not eatShit[player]) then
			local obj = createObject(3044, 0, 0, 0)
			setObjectScale(obj, 1.3)
			smokeShit[player] = {
				times = 0,
				object = obj,
				canSmoke = true,
			}
			setTimer(function(player)
				attachElementToBone(obj, player, 12,-0.1,0.15,0.12,0,0,0)
			end, 900, 1, player)
			
			setPedAnimation(player, "smoking", "m_smk_in", 5000, false, false, false, false)
			
			setTimer(function()
				bindKey(player, "mouse2", "down", smokeIt)
			end, 5000, 1, player)
			
			return true
			
		end
		
	else
		notificationShow(player, "error", "Du hast keinen Zigaretten.")
	end
	return false
end
addCommandHandler("smoke", function(p)
	if (smokeCigarette(p)) then
		takeInventory(p, "cigarettes", 1)
	end
end)




-- DICE --
local dices = {}
local function rotDice(player, nr)
	if (dices[player]) then
		local x, y, z		= getElementPosition(dices[player])
		local rx, ry, rz	= getElementRotation(dices[player])
		
		rx = rx + math.random(0, 180)
        ry = ry + math.random(0, 180)
        rz = rz + math.random(0, 180)

        moveObject(dices[player], 1000, x, y, z, rx, ry, rz)
		
		nr = nr + 1
		if (nr <= 2) then
			setTimer(rotDice, 1000, 1, player, nr)
		else
			setTimer(function(p)
				local x, y, z		= getElementPosition(dices[p])
				local rx, ry, rz	= getElementRotation(dices[p])
				
				local cur_x_part = rx / 90
				local round_x = math.floor(cur_x_part + 0.5)
				local dst_rx = round_x * 90
				local drx = dst_rx - rx
				
				local cur_y_part = ry / 90
				local round_y = math.floor(cur_y_part + 0.5)
				local dst_ry = round_y * 90
				local dry = dst_ry - ry
				
				local cur_z_part = rz / 90
				local round_z = math.floor(cur_z_part + 0.5)
				local dst_rz = round_z * 90
				local drz = dst_rz - rz
				
				moveObject(dices[p], 1000, x, y, z, drx, dry, drz)
				setTimer(function(p)
					vanishElement(dices[p])
					dices[p] = nil
				end, 3000, 1, p)
			end, 1000, 1, player)
		end
	end
end
function useDice(player)
	if (getInventoryCount(player, "dice") > 0) then
		if (not dices[player]) then
			local x, y, z		= getElementPosition(player)
			local rx, ry, rz	= getElementRotation(player)
			x, y				= getPointFromDistanceRotation2(x, y, 1, rz)
			local obj = createObject(1851, x, y, z-0.5, math.random(0,360), math.random(0,360), math.random(0,360))
			setObjectScale(obj, 1.5)
			dices[player] = obj
			rotDice(player, 0)
		end
	else
		notificationShow(player, "error", "Du hast keinen Würfeö.")
	end
end
addCommandHandler("dice", useDice)