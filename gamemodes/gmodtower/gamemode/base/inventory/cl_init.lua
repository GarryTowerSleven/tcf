include("shared.lua")
include("sh_load.lua")
include("sh_trace.lua")
include("cl_store.lua")
include("sh_rabbit.lua")
include("sh_playermodel.lua")
include("sh_potion.lua")
include("sh_baseitem.lua")
include("cl_genicons.lua")


function GTowerItems:UseProp( ent )

	net.Start("GMTUse")
		net.WriteEntity(ent)
		net.WriteEntity(LocalPlayer())
	net.SendToServer()

	GTowerItems:UseEffects( ent )

end

function GTowerItems:UseEffects( ent )

	local Item = GTowerItems:GetTableByEntity( ent )
	if Item then

		// Play animation
		if Item.UseAnim then
			local seq = ent:LookupSequence( Item.UseAnim )

			if ( seq == -1 ) then return end

			timer.Create( "DanceRepeat", 0.3, 15, function()
				if !IsValid(ent) then return end
				ent:ResetSequence( seq )
			end )
		end

		// Play use scale effect
		if Item.UseScale && !Item.UseAnim then
			timer.Destroy( ent:EntIndex() .. "_animtimer" )
			timer.Create( ent:EntIndex() .. "_animtimer", 0, 0, function()

				if not ent.CurScale then ent.CurScale = 1 end

				if not ent.ScaleTo then
					ent.ScaleTo = .85
				end

				if ent.CurScale == .85 then
					ent.ScaleTo = 1
				end

				ent.CurScale = math.Approach( ent.CurScale, ent.ScaleTo, .01 )
				ent:ManipulateBoneScale( 0, Vector( ent.CurScale, ent.CurScale, ent.CurScale ) )

				if ent.CurScale == 1 and ent.ScaleTo == 1 then
					ent.CurScale = nil
					ent.ScaleTo = nil
					timer.Destroy( ent:EntIndex().. "_animtimer" )
				end

			end )

		end
	end

end

net.Receive( "GMTUseEffect", function( len, ply )
	local ent = net.ReadEntity()
	local activator = net.ReadEntity()

	if ply != activator then
		GTowerItems:UseEffects( ent )
	end
end )
