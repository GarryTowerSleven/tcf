
if !string.StartWith(game.GetMap(),"gmt_lobby") then return end

local function HasJetpack(ply)
	if ply.CosmeticEquipment == nil then return false end
	
	for k,v in pairs(ply.CosmeticEquipment) do
		if v:GetClass() == "gmt_jetpack" and v:GetModel() != "models/gmod_tower/backpack.mdl" then return true end
	end
	
	return false
end

hook.Add("Move", "Inventory.JetPack.Move", function(ply, mv, cmd)

	if HasJetpack(ply) then
		if mv:KeyDown(IN_JUMP) and not ply:IsOnGround() and ply:WaterLevel() < 2 then
			if not ply:GetNWBool("IsJetpackOn") then
				ply:SetNWFloat("JetpackStart", CurTime())
				ply:SetNWBool("IsJetpackOn", true)
			end

			local oVec = mv:GetVelocity()
			local finalVec = Vector(0, 0, 15)
			local dirPower = ply:GetWalkSpeed()
			local powerSetting = 1--ply.CurInventory[TYPE.ACCESSORY].Settings.power
			local frameTime = FrameTime()

			local ang = mv:GetMoveAngles()
			local forwardVec = ang:Forward()
			local rightVec = ang:Right()
			forwardVec.z = 0
			rightVec.z = 0

			if mv:KeyDown(IN_SPEED) and mv:KeyDown(IN_DUCK) then
				dirPower = ply:GetRunSpeed()*5
			elseif mv:KeyDown(IN_SPEED) then
				dirPower = ply:GetRunSpeed()
			end

			finalVec = finalVec + forwardVec * math.Clamp(mv:GetForwardSpeed(), -1, 1) * dirPower * frameTime
			finalVec = finalVec + rightVec * math.Clamp(mv:GetSideSpeed(), -1, 1) * dirPower * frameTime
			finalVec = finalVec + oVec

			finalVec.x = math.Clamp(finalVec.x, -dirPower*4, dirPower*4)
			finalVec.y = math.Clamp(finalVec.y, -dirPower*4, dirPower*4)
			finalVec.z = math.min(finalVec.z, dirPower)

			mv:SetVelocity(finalVec)

			if mv:KeyDown(IN_DUCK) then
				mv:SetButtons(mv:GetButtons() - IN_DUCK) -- There's no CMoveData:RemoveKey function, so...bitwise operations
			end
		else
			if ply:GetNWBool("IsJetpackOn") then
				ply:SetNWFloat("JetpackStart", 0)
				ply:SetNWBool("IsJetpackOn", false)
			end
			if IsFirstTimePredicted() and ply.RocketShoesSound then
				ply.RocketShoesSound:Stop()
			end
		end
	else
		if ply:GetNWBool("IsJetpackOn") then
			ply:SetNWBool("IsJetpackOn", false)
		end
		if IsFirstTimePredicted() and ply.RocketShoesSound then
			ply.RocketShoesSound:Stop()
		end
	end
end)