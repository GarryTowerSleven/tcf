include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local pos = 0

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger( true )
end

function ENT:StartTouch( entity )
	if entity:IsPlayer() and entity:Team() != TEAM_FINISHED then

		pos = pos + 1

		entity:AddAchievement( ACHIEVEMENTS.GRMILESTONE2, 1 )

		if entity:GetNWInt("Points") == 0 then
			entity:AddAchievement(ACHIEVEMENTS.GRMALNOURISHED,1)
		end

		entity:Freeze(true)
		entity:SetNWString("Powerup","")
		entity:SetTeam( TEAM_FINISHED )
		entity:SendLua([[RunConsoleCommand( "act", "dance" )]])
		entity:SendLua([[RunConsoleCommand( "gmt_showscores", "1" )]])
		self:EmitSound("gmodtower/gourmetrace/actions/finish.wav",80)

		if entity:GetNWBool("Invincible") then
			entity:SetNWBool("Invincible",false)
			entity:StopSound("Invincibility")
			entity:SetMaterial("",true)
		end

		entity:StripWeapons()
		entity:SetNWInt("Pos",pos)

		entity.AfkTime = CurTime() + 120

		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "finish", effectdata )

		GAMEMODE:SetMusic(MUSIC_FINISH,entity)

		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("#]].. pos ..[[ | ]]..entity:Name()..[[ has finished in ]]..stringmod.FormattedTime( CurTime() - v.StartTime, "%02i:%02i:%02i" )..[[!", Color(0, 96, 255, 255))]])
		end

		if pos == 1 then
			entity:AddAchievement(ACHIEVEMENTS.GRRACER,1)
		end

	end
end

function GetFirst()

	local distances = {}

	for _,ent in pairs(ents.GetAll()) do if ent:GetClass() == "finish_flag" then

		for _,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_FINISHED then return end
			table.insert(distances,(v:GetPos():Distance(ent:GetPos())))
			v.Dist = (v:GetPos():Distance(ent:GetPos()))
		end

	end
	end

	table.sort(distances,function(a,b) return a < b end)

	for k,ply in pairs(player.GetAll()) do
		if ply.Dist == distances[1] then
			return ply
		end
	end

end

hook.Add("ResetPositions","PosReset",function() pos = 0 end)
