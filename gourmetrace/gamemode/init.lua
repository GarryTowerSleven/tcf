AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_music.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_move.lua" )
AddCSLuaFile( "sh_meta.lua" )
AddCSLuaFile( "sh_think.lua" )

include( "shared.lua" )
include( "sh_move.lua" )
include( "sh_meta.lua" )
include( "sh_think.lua" )

include( "sv_misc.lua" )
include( "sv_player.lua" )
include( "sv_round.lua" )
include( "sv_spawn.lua" )

util.AddNetworkString("JumpPuff")
util.AddNetworkString("PowerupGet")

CreateConVar("gmt_srvid", 20 )

function GM:Initalize()
	NWTableGlobal()
end

hook.Add( "PlayerDisconnected", "NoPlayerCheck", function( ply )
	if ply:IsBot() then return end
	
	timer.Simple( 5, function()
		if player.GetCount() == 0 then GAMEMODE:EndServer() end
	end )
end )

function GM:SetMusic( idx, ply, win )

	local rp = RecipientFilter():AddAllPlayers()
	if ply then rp = ply end

	umsg.Start( "GR_PlayMusic", rp )
		umsg.Char( idx )
		if win then
			umsg.Bool( win )
		end
	umsg.End()

end

function GM:OnPlayerHitGround( ply, inWater, onFloater, speed )
	ply.FirstDoubleJump = true
end

function PlayerSetup(ply)
	hook.Call( "PlayerSetModel", GAMEMODE, ply )
	ply:GodEnable()
	ply:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	NWTablePlayer(ply)
end

function GM:IsSpawnpointSuitable( ply, spawnpointent, bMakeSuitable )
	return true
end

function GM:PlayerDisconnected( ply )
	 --ply:SendLua([[RunConsoleCommand('-speed')]])
end

function GM:PlayerButtonDown( ply, button )

	if button == KEY_E then
		if ply:GetNWString("Powerup") != "" then

			ply:AddAchievement(ACHIEVEMENTS.GRMILESTONE1,1)

			if ply:GetNWString("Powerup") == "warpstar" then

				ply:SetNWString("Powerup","")
				ply:EmitSound("gmodtower/gourmetrace/actions/teleport.wav",80)

				PostEvent( ply, "warpstar_on" )
				timer.Simple(0.3,function()
					local first = GetFirst()
					if !IsValid(first) then return end
					ply:SetPos(first:GetPos())
					if ply != first then
						ply:AddAchievement(ACHIEVEMENTS.GRBOTTOM,1)
					end
				end)
				timer.Simple(0.6,function()
					PostEvent( ply, "warpstar_off" )
				end)
				return
			end

			local pu = ents.Create(ply:GetNWString("Powerup"))
			if !IsValid(pu) then ply:SetNWString("Powerup","") return end
			pu:SetOwner(ply)
			pu:SetPos(ply:GetPos())
			pu:Spawn()
			ply:SetNWString("Powerup","")
			ply:EmitSound("gmodtower/gourmetrace/actions/pu_place.wav",80)
		else
			ply:SendLua([[surface.PlaySound("gmodtower/gourmetrace/actions/pu_invalid.wav")]])
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

hook.Add( "PlayerInitialSpawn", "PlayerNW", PlayerSetup )

hook.Add( "KeyPress", "keypress_jump_super", function( ply, key )
	if not IsFirstTimePredicted() then return end
	if ( key == IN_JUMP ) then
		if ply:CanDoubleJump() then
			ply:DoubleJump()
			net.Start("JumpPuff")
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end
end )

concommand.Add("gr_settime",function(ply,cmd,args,str)
	if ply:IsAdmin() then SetGlobalInt( "Time", CurTime() + str ) end
end)
