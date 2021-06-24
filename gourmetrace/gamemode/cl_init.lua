include( "shared.lua" )
include( "sh_move.lua" )
include( "sh_meta.lua" )
include( "sh_think.lua" )
include( "cl_hud.lua" )
include( "cl_music.lua" )
include( "cl_scoreboard.lua" )

surface.CreateFont( "gr_playername", { font = "Kirby Classic", size = 75, weight = 100, shadow = true } )

//function GM:Think() gui.EnableScreenClicker( true ) end
function GM:ShouldDrawLocalPlayer() return true end

function GM:PlayerBindPress( ply, bind, pressed )

	if bind == "+duck" || bind == "+forward" || bind == "+back" || bind == "+menu" || bind == "+zoom" || bind == "+menu_context" || bind == "+speed" then
		return true
	end

end

function GM:HUDWeaponPickedUp()
	return false
end
function GM:HUDItemPickedUp()
	return false
end
function GM:HUDAmmoPickedUp()
	return false
end

local GtowerHudToHide = {
	CHudHealth = true,
	CHudAmmo = true,
	CHudBattery = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( GtowerHudToHide[ name ] ) then return false end
end )

hook.Add("PostPlayerDraw", "CSSWeaponFix", function(v)
	local wep = v:GetActiveWeapon()
	if !IsValid(wep) then return end

	local hbone = wep:LookupBone("ValveBiped.Bip01_R_Hand")
	if !hbone then
		local hand = v:LookupBone("ValveBiped.Bip01_R_Hand")
		if hand then

			local pos, ang = v:GetBonePosition(hand)

			ang:RotateAroundAxis(ang:Forward(), 180)

			if wep:GetModel() == "models/weapons/w_pvp_neslg.mdl" then
				ang:RotateAroundAxis(ang:Up(), -90)
			end

			wep:SetRenderOrigin(pos)
			wep:SetRenderAngles(ang)

		end
	end
end)

hook.Add( "PostDrawOpaqueRenderables", "example", function()
	local angle = Angle(0,0,90)
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v:Alive() and v != LocalPlayer() then
			cam.Start3D2D( v:GetPos() + Vector(0,0,100), angle, 0.2 )
				draw.DrawText(v:Name(),"gr_playername",4,4,Color( 0, 0, 0, 175 ),1)
				draw.DrawText(v:Name(),"gr_playername",0,0,Color( 255, 255, 255, 200 ),1)
			cam.End3D2D()
		end
	end
end )

net.Receive("JumpPuff",function()
	local vPoint = net.ReadEntity():GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "jump_puff", effectdata)
end)

usermessage.Hook( "PlayerCute", function( um )

	for k, ply in ipairs( player.GetAll() ) do
		if !IsValid( ply ) then return end

		local scale = 0.75
		ply:SetModelScale( scale, 1 )
		ply:SetRenderBounds( Vector( -16, -16, 0 ) * scale, Vector( 16,  16,  72 ) * scale )
		ply:SetStepSize( math.Clamp( 18 * scale, 1, 36 ) )
		--ply:ManualEquipmentDraw()

		function ply.BuildBonePositions()

			local boneIndex = ply:LookupBone( "ValveBiped.Bip01_Head1" )
			local boneMatrix = ply:GetBoneMatrix( boneIndex )
				boneMatrix:Scale( Vector( 3, 3, 3 ) )
			ply:SetBoneMatrix( boneIndex, boneMatrix )

			boneIndex = ply:LookupBone( "ValveBiped.Bip01_L_Forearm" )
				boneMatrix = ply:GetBoneMatrix( boneIndex )
				boneMatrix:Scale( Vector( 1.5, 1.5, 2 ) )
			ply:SetBoneMatrix( boneIndex, boneMatrix )

			boneIndex = ply:LookupBone( "ValveBiped.Bip01_R_Forearm" )
				boneMatrix = ply:GetBoneMatrix( boneIndex )
				boneMatrix:Scale( Vector( 1.5, 1.5, 1.5 ) )
			ply:SetBoneMatrix( boneIndex, boneMatrix )

			boneIndex = ply:LookupBone( "ValveBiped.Bip01_L_Calf" )
				boneMatrix = ply:GetBoneMatrix( boneIndex )
				boneMatrix:Scale( Vector( 1, 1.5, 1.5 ) )
			ply:SetBoneMatrix( boneIndex, boneMatrix )

			boneIndex = ply:LookupBone( "ValveBiped.Bip01_R_Calf" )
				boneMatrix = ply:GetBoneMatrix( boneIndex )
				boneMatrix:Scale( Vector( 1, 1.5, 1.5 ) )
			ply:SetBoneMatrix( boneIndex, boneMatrix )

		end

	end

end )
