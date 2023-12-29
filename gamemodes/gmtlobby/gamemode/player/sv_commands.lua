concommand.AdminAdd("gmt_disco", function(ply)

	if ply:GetNWBool("IsDisco") and timer.Exists("DiscoTimer") then
		timer.Destroy("DiscoTimer")
		ply:SetNWBool("IsDisco", false)

		return
	end

	ply:SetNWBool("IsDisco", true)

	local red = Vector( 1000000000, 0, 0 )
	local green = Vector( 0, 1000000000, 0 )
	local blue = Vector( 0, 0, 1000000000 )

	ply:SetPlayerColor(red)

	timer.Create("DiscoTimer", 0.25, 0, function()
		if not IsValid(ply) then timer.Destroy("DiscoTimer") end

		if ply:GetPlayerColor() == red then
			ply:SetPlayerColor(green)
		elseif ply:GetPlayerColor() == green then
			ply:SetPlayerColor(blue)
		elseif ply:GetPlayerColor() == blue then
			ply:SetPlayerColor(red)
		end

	end)

end)

concommand.AdminAdd("gmt_adminmessage", function(ply, cmd, args, str)
	net.Start("AdminMessage")
		net.WriteEntity(ply)
		net.WriteString(str)
	net.Broadcast()
end)

concommand.AdminAdd("remove_ent", function(ply,cmd,args,str)
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == str then
			v:Remove()
		end
	end
end)

concommand.AdminAdd("gmt_bigheads", function(ply)
	for k,v in pairs(player.GetAll()) do
		local Head = v:LookupBone("ValveBiped.Bip01_Head1")
		v:ManipulateBoneScale(Head,Vector(5,5,5))
	end
end)

concommand.AdminAdd("gmt_chimera", function(ply)
	ply:SetModel( "models/UCH/uchimeraGM.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )

	ply:SetWalkSpeed(100)
	ply:SetRunSpeed(250)

	ply:EmitSound("uch/music/endround/pigs_lose.mp3")
end)

concommand.AdminAdd("gmt_trex", function(ply)
	ply:SetModel( "models/dinosaurs/trex.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )
end)

concommand.AdminAdd("gmt_dog", function(ply)
	ply:SetModel( "models/zom/dog.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )
end)

concommand.AdminAdd("gmt_setalldog", function(ply)
	for k,v in pairs( player.GetAll() ) do
		v:SetModel( "models/zom/dog.mdl" )
		v:SetSkin( 0 )
		v:SetBodygroup( 1, 1 )
	end
end)

concommand.AdminAdd("gmt_spider", function(ply)
	ply:SetModel( "models/npc/spider_regular/npc_spider_regular.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )
end)

concommand.AdminAdd("gmt_spiderbig", function(ply)
	ply:SetModel( "models/npc/spider_monster/npc_spider_monster.mdl" )
	ply:SetSkin( 0 )
	ply:SetBodygroup( 1, 1 )
end)

concommand.AdminAdd("gmt_salsa", function(ply)
	if ply:GetModel() == "models/uch/uchimeragm.mdl" then

		ply:EmitSound("uch/music/endround/salsa.mp3")

		timer.Create("ConfettiSalsa", 0.25, 70, function()
			local vPoint = ply:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )

			util.Effect( "confetti", effectdata )
		end)
	end
end)

concommand.AdminAdd("toss", function(ply, cmd, args)
    if (ply.NextToss and CurTime() < ply.NextToss) then return end

    ply.NextToss = CurTime() + .5

    local num = math.Clamp(tonumber(args[1]) or 1, 1, 10)

    for i = 1,num do
        local eye = ply:EyeAngles()

        local aim = eye - Angle(30, 0, 0)
        local aimforward = aim:Forward()

        local trace = util.TraceLine({start=ply:GetShootPos(), endpos=ply:GetShootPos() + ply:GetAimVector() * 30, filter=ply})
        local start = trace.HitPos - (aimforward * num * 5) - (aimforward * 10)

        local corn = ents.Create("candycorn")

        if i > 1 then
            local offset = eye:Up() * math.random(-15,15) + eye:Right() * math.random(-15, 15) + (aimforward * i * 5)
            corn:SetPos(start + offset)
        else
            corn:SetPos(start)
        end

        corn:SetAngles(VectorRand():Angle())
        corn:Spawn()

        local phys = corn:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetVelocity(aimforward * 300)
        end
    end
end)

concommand.AdminAdd("morebeer", function(ply, cmd, args)
    if (ply.NextBeer and CurTime() < ply.NextBeer) then return end

    ply.NextBeer = CurTime() + .5

    local eye = ply:EyeAngles()

    local aim = eye - Angle(30, 0, 0)
    local aimforward = aim:Forward()

    local trace = util.GetPlayerTrace(ply)
    trace = util.TraceLine(trace)

    local beer = ents.Create("alcohol_bottle")

    beer:SetPos(trace.HitPos)
    beer:Spawn()
    local phys = beer:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end)

concommand.AdminAdd("gmt_giveammo", function(ply, cmd, args)
    ply:GiveAmmo( 50, "SMG1", true )
    ply:GiveAmmo( 50, "AR2", true )
    ply:GiveAmmo( 50, "AlyxGun", true )
    ply:GiveAmmo( 50, "Pistol", true )
    ply:GiveAmmo( 50, "SMG1", true )
    ply:GiveAmmo( 50, "357", true )
    ply:GiveAmmo( 50, "XBowBolt", true )
    ply:GiveAmmo( 50, "Buckshot", true )
    ply:GiveAmmo( 50, "RPG_Round", true )
    ply:GiveAmmo( 50, "SMG1_Grenade", true )
    ply:GiveAmmo( 50, "SniperRound", true )
    ply:GiveAmmo( 50, "SniperPenetratedRound", true )
    ply:GiveAmmo( 50, "Grenade", true )
    ply:GiveAmmo( 50, "Trumper", true )
    ply:GiveAmmo( 50, "Gravity", true )
    ply:GiveAmmo( 50, "Battery", true )
    ply:GiveAmmo( 50, "GaussEnergy", true )
    ply:GiveAmmo( 50, "CombineCannon", true )
    ply:GiveAmmo( 50, "AirboatGun", true )
    ply:GiveAmmo( 50, "StriderMinigun", true )
    ply:GiveAmmo( 50, "HelicopterGun", true )
    ply:GiveAmmo( 50, "AR2AltFire", true )
    ply:GiveAmmo( 50, "slam", true )
end)

-- Chimera command functions:
hook.Add( "PlayerFootstep", "ChimeraSteps", function(ply)

	if ply:IsAdmin() and ply:GetModel() == "models/uch/uchimeragm.mdl" then
		ply:EmitSound( "UCH/chimera/step.wav", 82, math.random( 94, 105 ))
		util.ScreenShake( ply:GetPos(), 5, 5, .5, ( 450 * 1.85 ) )
		return true
	end

end )

hook.Add( "KeyPress", "Bite", function( ply, key )

	if ply:IsAdmin() and ply:GetModel() == "models/uch/uchimeragm.mdl" and ply:Alive() then
		if ( key == IN_ATTACK ) then
			Bite(ply)
		end
	end

end )

function FindThingsToBite(ply)

	local tbl = {}

	local pos = ply:GetShootPos()
	local fwd = ply:GetForward()

	local function playerGetAllMinus( ent )

		local tbl = {}

		for k, v in pairs( player.GetAll() ) do
			if v != ent then
				table.insert( tbl, v )
			end
		end

		return tbl

	end

	fwd.z = 0
	fwd:Normalize()

	local vec = ( ( pos + Vector( 0, 0, -16 ) ) + ( fwd * 60 ) )
	local rad = 70

	for k, v in pairs( ents.FindInSphere( vec, rad ) ) do

		if v:IsPlayer() then

			local pos = ply:GetShootPos()
			local epos = v:IsPlayer() && v:GetShootPos() || v:GetPos()
			local tr = util.QuickTrace( pos, (epos - pos ) * 10000, playerGetAllMinus( v ) )

			if IsValid( tr.Entity ) && tr.Entity == v then
				table.insert( tbl, v )
			end

		end

	end

	return tbl

end

function Bite(ply)
	if timeout then return end

	Animation.PlayAnim( ply, ACT_MELEE_ATTACK1 )

	local timeout = true

	ply:Freeze(true)
	ply:EmitSound( "UCH/chimera/bite.mp3", 80, math.random( 94, 105 ) )

	timer.Simple(0.75, function()
		timeout = false
		ply:Freeze(false)
	end)

	local tbl = FindThingsToBite(ply)

	if #tbl >= 1 then
		for k, v in pairs( tbl ) do

			if v:IsPlayer() then
				v:Freeze( true )
			end

			timer.Simple( .32, function()
				if IsValid( ply ) && IsValid( v ) then
					v:Kill()
					v:EmitSound("uch/pigs/die.wav")
					ply:EmitSound("uch/music/roundtimer_add.wav")
				end
			end )
		end
	end

end