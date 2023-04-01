include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_icons.lua")
AddCSLuaFile("cl_draw.lua")

function GM:PlayerSpawnProp(ply)
    return !CanBuild(ply)
end

function GM:PlayerSpawnedProp(ply, _, prop)
    ply:AddCount( "props", prop )
    prop:SetSkin(math.random(1, prop:SkinCount()))
    prop:SetModelScale(0)
    prop:SetModelScale(1, 0.2)

    local effect = EffectData()
    effect:SetEntity(prop)
    util.Effect("propspawn", effect, true, true)
end

local meta = FindMetaTable("Player")
util.AddNetworkString("Inventory")

function meta:SendInventory()
    net.Start("Inventory")
    net.WriteTable(self.Inventory)
    net.Send(self)
end

function GetItem(name)
    local item = table.Copy(Items[name])
    item.ID = name
    return item
end

function SpawnItem(name)
    local item = ents.Create("spawned_weapon")
    local item2 = GetItem(name)
    item.Use = function(self, ply)
        ply:GiveItem(name)
        ply:ChatPrint("Picked up a " .. item2.Name)
        self:Remove()
    end
    item:SetModel(item2.Model or "models/weapons/w_physics.mdl")
    item:PhysicsInit(SOLID_VPHYSICS)
    item:Spawn()
    return item
end

function GM:Think()
    for _, ply in ipairs(player.GetAll()) do
        if !IsValid(ply:GetActiveWeapon()) then
            ply.PickingUp = true
            ply:Give((ply:Team() == TEAM_SATURN || ply:Team() == TEAM_KLEINER) && "weapon_bugbait" or "keys")
            ply.PickingUp = false
        end

        if UCHAnim.ValidPlayer(ply) then
            ply:MakePiggyNoises()
        end
    end
end

function meta:MakePiggyNoises()

    if !UCHAnim.ValidPlayer(self) || !self:Alive() then return end

    self.LastSnort = self.LastSnort || CurTime() + math.random( 9, 14 )

    if CurTime() >= self.LastSnort then
        
        self:EmitSound( "UCH/pigs/snort" .. tostring( math.random( 1, 4 ) ) .. ".wav", 75, math.random( 90, 105 ) )

        local num = math.Rand( 6, 9 )

        //if self:GetNWBool("IsScared") || !self:CanSprint() then
        //    num = num * .25
        //end
        
        self.LastSnort = CurTime() + num
        
    end

end

function GM:PlayerChangedTeam(ply, _, new)
    if new == TEAM_PIG then
        ply:SetSkin(math.random(0, 2))
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(1, ply:GetSkin() == 2 and 1 or 0)
    elseif new == TEAM_PIG2 then
        ply:SetSkin(3)
        ply:SetBodygroup(2, 1)
    end

    if new == TEAM_PIG or new == TEAM_PIG2 then
        ply:SetViewOffset(Vector(0, 0, 52))
    elseif new == TEAM_SATURN then
        ply:SetViewOffset(Vector(0, 0, 28))
        ply:SetViewOffsetDucked(Vector(0, 0, 28))
    else
        ply:SetViewOffset(Vector(0, 0, 64))
    end

    if new == TEAM_SATURN then
        ply:SetHull(Vector(-8, -8, 0), Vector(8, 8, 24))
        ply:SetHullDuck(ply:GetHull())
    else
        ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
        ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 32))
    end
end

function GM:PlayerSetHandsModel(ply, ent)
	timer.Simple(0.1, function()
		if !IsValid(ply) || !IsValid(ent) then return end
		ent:SetModel(ply:GetModel())
		ent:SetMaterial(nil)
		for i = 0, ent:GetBoneCount() - 1 do
			local name = ent:GetBoneName(i)
			name = name && string.lower(name) || nil
			if !name || !string.find(name, "arm") && !string.find(name, "hand") && !string.find(name, "finger") && !string.find(name, "wrist") && !string.find(name, "ulna") then
				ent:ManipulateBoneScale(i, Vector(math.huge, math.huge, math.huge))
			else
				ent:ManipulateBoneScale(i, Vector(1, 1, 1))
			end
		end
	end)
end


function GM:PlayerDeath(ply)
    for _, i in ipairs(ply.Inventory) do
    for _, i2 in ipairs(i) do
        if i2.Name and i2.Model and i2.Name ~= "Gravity Gun" then
            print(i2, i2.ID)
            local item = SpawnItem(i2.ID)
            item:SetPos(ply:GetPos())
        end
    end
end

if UCHAnim.ValidPlayer(ply) then
    ply:EmitSound("uch/pigs/die.wav")
else
    //ply:EmitSound("player/death" .. math.random(6) .. ".wav")
end

end

function GM:PostEntityTakeDamage(ply, _, take)
    if !take then return end
    print("!", ply)
    if IsValid(ply) and UCHAnim.ValidPlayer(ply) then
        ply:EmitSound( "UCH/pigs/squeal" .. tostring( math.random( 1, 3 ) ) .. ".wav", 80, math.random( 90, 105 ) )
    
    elseif IsValid(ply) and ply:isPlayer() then
        ply:EmitSound(string.find(ply:GetModel(), "kleiner") and "vo/k_lab/kl_ahhhh.wav" or "vo/npc/" .. (string.find(ply:GetModel(), "female") and "fe" or "") .. "male01/pain0" .. math.random(9) .. ".wav", 80, math.random(90, 105))
    end

end

function GM:PlayerDeathSound()
    return true
end




local Player = FindMetaTable("Player")
if Player then
    function Player:LastLocation()
        return self._LastLocation
    end
end

local _LocationDelay = 1
local _LastLocationThink = CurTime() + _LocationDelay
hook.Add( "Think", "GTowerLocation", function()
    if ( CurTime() < _LastLocationThink ) then
        return
    end

    _LastLocationThink = CurTime() + _LocationDelay

    local players = player.GetAll()

    for _, ply in ipairs( players ) do
        local loc = Location.Find( ply:GetPos() + Vector(0,0,5) )

        if ply._LastLocation != loc then
            ply._Location = loc
		    ply._LastLocation = loc

            ply:SetNWInt( "Location", loc )
            hook.Call( "Location", GAMEMODE, ply, loc, ply._LastLocation or 0 )
        end
    end
end )

function meta:GiveItem(item)
    local empty

    for i = 1, #self.Inventory do
        for i2 = 1, #self.Inventory[1] do
            if !self.Inventory[i][i2].Name and (empty and empty[2] == 1 or !empty) then
                empty = {i, i2}
            end
        end
    end

    if empty then
        local item = GetItem(item)
        self.Inventory[empty[1]][empty[2]] = item
        self:SendInventory()
    end
end

function GM:PlayerSpawn(ply)
    ply.Inventory = {}

    ply:ScreenFade(SCREENFADE.IN, color_black, 1, 2)
    ply:EmitSound("gmodtower/lobby/elevator/elevator_bell.wav")
    ply:EmitSound("gmodtower/lobby/elevator/elevator_doorclose.wav")
    ply:EmitSound("gmodtower/lobby/elevator/elevator_arrive.wav")
    // ply:EmitSound("gmodtower/lobby/condo/vault_close.wav")

    timer.Simple(1.8, function()
        ply:ViewPunch(Angle(-4, 0, 0))
    end)

    for i = 1, 9 do
        ply.Inventory[i] = {}

        for i2 = 1, 5 do
            ply.Inventory[i][i2] = {}
        end
    end

    ply.Inventory[1][1] = GetItem("fists")

    ply.Inventory[2][1] = GetItem("grav")

    ply:SendInventory()
    // GAMEMODE:PlayerLoadout(ply)
    self.BaseClass.PlayerSpawn(self, ply)

    ply:SetPlayerColor(Vector(math.Rand(0, 1), math.Rand(0, 1), math.Rand(0, 1)))
end

net.Receive("Inventory", function(_, ply)
    local msg = net.ReadInt(8)

    if msg == 1 then
        local t = net.ReadTable()
        local item = ply.Inventory[t[1]][t[2]]
        ply.Inventory[t[1]][t[2]] = ply.Inventory[t[3]][t[4]]
        ply.Inventory[t[3]][t[4]] = item
    elseif msg == 2 then
        local class = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or ""
        for _, wep in ipairs(ply:GetWeapons()) do
            ply:GiveAmmo(wep:Clip1(), wep:GetPrimaryAmmoType())
        end
        ply:StripWeapons()
        local xy = net.ReadTable()
        local x, y = xy[1], xy[2]
        local item = ply.Inventory[x] and ply.Inventory[x][y]
        if !item then return end
        if !item.Weapon then return end
        if class == item.Weapon then return end
        ply.PickingUp = true
        ply:Give(item.Weapon)
        ply.PickingUp = false
        ply:SelectWeapon(ply:GetWeapon(item.Weapon))

        local wep = ply:GetWeapon(item.Weapon)
        wep:SetClip1(0)
        local ammo = math.min(wep:GetMaxClip1(), wep:GetOwner():GetAmmoCount(wep:GetPrimaryAmmoType()))
        // print(ammo)
        if wep.Primary.Pump then
            ammo = 1
        end
        wep:SetClip1(wep:Clip1() + ammo)
        wep:GetOwner():RemoveAmmo(ammo, wep:GetPrimaryAmmoType())

        // ply:GiveAmmo(9999, ply:GetWeapon(item.Weapon):GetPrimaryAmmoType())
    end

    ply:SendInventory()

end)

e = {}

for _, e in ipairs(e) do
    print([[{
        "]] .. e[1] .. [[",
        Vector(]] .. e[2].x .. [[, ]] .. e[2].y .. [[, ]] .. e[2].z .. [[)
        , Angle(]] .. e[3].p .. [[, ]] .. e[3].y .. [[, ]] .. e[3].r .. [[)
        

    }]])
end

props = {{
    "models/props_c17/oildrum001.mdl",
    Vector(423.57766723633, -1791.8450927734, -652.8515625)
    , Angle(22.629585266113, -127.4225769043, 72.324607849121)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(673.98077392578, -1534.9453125, -657.80004882813)
    , Angle(-33.722450256348, -99.840545654297, -90.002777099609)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(502.78750610352, -1928.7764892578, -634.08868408203)
    , Angle(53.197998046875, -55.108707427979, -29.412109375)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(489.13494873047, -1826.7069091797, -671.47717285156)
    , Angle(-2.5637173166615e-06, -96.685020446777, -2.0606016732927e-06)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(457.34713745117, -1993.6157226563, -661.45037841797)
    , Angle(-25.958759307861, 135.1167755127, -39.767395019531)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(447.44006347656, -1823.1729736328, -632.30767822266)
    , Angle(24.53258895874, -108.78456878662, 86.168838500977)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(485.70712280273, -1886.5399169922, -612.24566650391)
    , Angle(78.764633178711, 177.97346496582, -90.120086669922)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(504.35635375977, -1697.9312744141, -657.60931396484)
    , Angle(52.658847808838, -77.382049560547, -90.020935058594)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(367.00595092773, -1975.8826904297, -657.66101074219)
    , Angle(-58.503448486328, 28.164443969727, -90.002319335938)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(508.60134887695, -1983.5673828125, -625.77545166016)
    , Angle(-44.033889770508, -93.704025268555, -49.601226806641)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(358.53103637695, -1985.1871337891, -649.53356933594)
    , Angle(-4.6828656196594, 38.66858291626, 71.96533203125)


},
{
    "models/props_c17/oildrum001.mdl",
    Vector(456.76873779297, -1840.8237304688, -612.35504150391)
    , Angle(-12.011896133423, -80.379974365234, 89.923820495605)


},
{
    "models/props_c17/fence03a.mdl",
    Vector(4307.1733398438, -3900.9006347656, -840.93481445313)
    , Angle(-0.85186380147934, 94.695472717285, -0.14096069335938)


},
{
    "models/props_c17/fence03a.mdl",
    Vector(4744.51171875, -3688.0871582031, -841.57000732422)
    , Angle(-3.4471278190613, -179.88177490234, -0.0048828125)


},
{
    "models/props_c17/fence03a.mdl",
    Vector(4760.6875, -3688.7639160156, -841.61462402344)
    , Angle(-6.1683359146118, -179.8960723877, -0.016815185546875)


},
{
    "models/props_c17/fence03a.mdl",
    Vector(4753.9194335938, -3687.2807617188, -841.45373535156)
    , Angle(-3.4298198223114, -179.89158630371, -0.00042724609375)


},
{
    "models/props_c17/fence03a.mdl",
    Vector(4749.5952148438, -3683.2912597656, -841.55554199219)
    , Angle(3.429815530777, 0.12350622564554, -0.018798828125)


},
{
    "models/props_wasteland/cargo_container01.mdl",
    Vector(4382.7880859375, -3981.419921875, -833.6650390625)
    , Angle(0.644007563591, -87.997856140137, -0.003509521484375)


},
{
    "models/props_wasteland/cargo_container01.mdl",
    Vector(4430.7900390625, -4018.2858886719, -704.12341308594)
    , Angle(-0.28219985961914, 89.981468200684, 0.0086588328704238)


},
{
    "models/props_wasteland/cargo_container01.mdl",
    Vector(4444.5561523438, -4112.4116210938, -834.25427246094)
    , Angle(0.075951009988785, -88.002838134766, -0.063568115234375)


},
{
    "models/props_wasteland/interior_fence001g.mdl",
    Vector(4224.5122070313, -3890.0502929688, -837.69140625)
    , Angle(-21.446811676025, 94.814476013184, 0.059437859803438)


},
{
    "models/props_wasteland/kitchen_shelf001a.mdl",
    Vector(4238.44140625, -4151.0776367188, -864.26489257813)
    , Angle(-89.891525268555, -178.32945251465, 90.034996032715)


},
{
    "models/props_wasteland/kitchen_shelf001a.mdl",
    Vector(4179.3354492188, -4162.2646484375, -878.64117431641)
    , Angle(-2.9020318984985, -5.6028966903687, -90.026641845703)


},
{
    "models/props_wasteland/cafeteria_table001a.mdl",
    Vector(4748.5727539063, -3446.8942871094, -880.26245117188)
    , Angle(0.0257054772228, -179.17330932617, -0.020782470703125)


},
{
    "models/props_trainstation/payphone_reciever001a.mdl",
    Vector(4755.626953125, -3500.5593261719, -861.46875)
    , Angle(14.18137550354, 22.115055084229, -90.088287353516)


},
{
    "models/map_detail/arcade_windowframe2.mdl",
    Vector(4401.9262695313, -2935.0222167969, -795.31420898438)
    , Angle(-0.95155066251755, 90.000663757324, 0.11400904506445)


},
{
    "models/map_detail/condo_toilet.mdl",
    Vector(2663.4304199219, 5012.1376953125, -911.62292480469)
    , Angle(0.02903632260859, 179.96905517578, -0.34942626953125)


},
{
    "models/map_detail/condo_toiletpaper.mdl",
    Vector(2698.1381835938, 5031.56640625, -875.98870849609)
    , Angle(-0.10060810297728, -90.169807434082, -0.00103759765625)


},
{
    "models/map_detail/flagside_deluxe_flag.mdl",
    Vector(-3208.8334960938, -4484.3232421875, -310.78237915039)
    , Angle(-24.479686737061, 97.356910705566, -14.605743408203)


},
{
    "models/map_detail/flagside_deluxe_flag.mdl",
    Vector(-3208.8334960938, -4484.3232421875, -310.78237915039)
    , Angle(-24.479686737061, 97.356910705566, -14.605743408203)


},
{
    "models/map_detail/flagside_deluxe_base.mdl",
    Vector(-3348.6057128906, -4538.3999023438, -381.15344238281)
    , Angle(18.165374755859, -177.39399719238, -40.832794189453)


},
{
    "models/map_detail/lobby_constructionsign.mdl",
    Vector(4407.6098632813, -2854.7387695313, -895.869140625)
    , Angle(-0.030885607004166, 90.351142883301, 0.00093969434965402)


},
{
    "models/map_detail/lobby_constructionsign.mdl",
    Vector(1775.6223144531, -1686.1429443359, -863.90112304688)
    , Angle(0.018477566540241, 0.19033069908619, 0.0018062609015033)


},
{
    "models/map_detail/maglev_train_front.mdl",
    Vector(7019.7705078125, 1162.8116455078, -1237.7971191406)
    , Angle(-1.4203434706584e-13, -89.999992370605, 0)


},
{
    "models/map_detail/maglev_train_front.mdl",
    Vector(7019.7705078125, 1162.8116455078, -1237.7971191406)
    , Angle(-1.4203434706584e-13, -89.999992370605, 0)


},
{
    "models/map_detail/maglev_train_middle.mdl",
    Vector(7753.8515625, 1164.2019042969, -1244.6171875)
    , Angle(-6.328333497285e-15, -90, 0)


},
{
    "models/map_detail/maglev_train_middle.mdl",
    Vector(7753.8515625, 1164.2019042969, -1244.6171875)
    , Angle(-6.328333497285e-15, -90, 0)


},
{
    "models/map_detail/maglev_train_front.mdl",
    Vector(7308.7861328125, -1158.2312011719, -1229.8472900391)
    , Angle(1.8008072246931e-13, 89.999992370605, 0)


},
{
    "models/map_detail/maglev_train_front.mdl",
    Vector(7308.7861328125, -1158.2312011719, -1229.8472900391)
    , Angle(1.8008072246931e-13, 89.999992370605, 0)


},
{
    "models/map_detail/maglev_train_middle.mdl",
    Vector(6578.3950195313, -1155.4154052734, -1236.6442871094)
    , Angle(3.97526690656e-14, 90.000007629395, -1.3845564126314e-06)


},
{
    "models/map_detail/maglev_train_middle.mdl",
    Vector(6578.3950195313, -1155.4154052734, -1236.6442871094)
    , Angle(3.97526690656e-14, 90.000007629395, -1.3845564126314e-06)


},
{
    "models/map_detail/plaza_trashcan.mdl",
    Vector(5423.3413085938, 239.67141723633, -884.31158447266)
    , Angle(90, 86.810180664063, 180)


},
{
    "models/map_detail/security_camera.mdl",
    Vector(5266.2875976563, -203.78051757813, -770.82421875)
    , Angle(-2.7641511302079e-10, 180, 0)


},
{
    "models/map_detail/instructions_poster.mdl",
    Vector(5745.544921875, -3098.0725097656, -474.03677368164)
    , Angle(-1.9132288694382, -27.19518661499, 21.237264633179)


},
{
    "models/map_detail/instructions_poster.mdl",
    Vector(5745.544921875, -3098.0725097656, -474.03677368164)
    , Angle(-1.9132288694382, -27.19518661499, 21.237264633179)


},
{
    "models/map_detail/gamemodes_window4.mdl",
    Vector(4399.5546875, -2926.212890625, -901.47247314453)
    , Angle(-0.018270216882229, 90.002326965332, -0.009674072265625)


},
{
    "models/map_detail/casino_duelingsign.mdl",
    Vector(2475.4318847656, -2836.2434082031, -683.85534667969)
    , Angle(-0.085981927812099, 90.027328491211, 89.95263671875)


},
{
    "models/map_detail/casino_duelingsign.mdl",
    Vector(2475.4318847656, -2836.2434082031, -683.85534667969)
    , Angle(-0.085981927812099, 90.027328491211, 89.95263671875)


},}

function load()
    for _, p in ipairs(props) do
        local ent = ents.Create("prop_dynamic")
        ent:SetModel(p[1])
        ent:SetPos(p[2])
        ent:SetAngles(p[3])
        ent:Spawn()
        ent:PhysicsInit(SOLID_VPHYSICS)
        if IsValid(ent:GetPhysicsObject()) then
            ent:GetPhysicsObject():EnableMotion(false)
        end
    end

    local merchant = ents.Create("npc")
    merchant:SetPos(Vector(3016, -3084, -831 - 64))
    merchant:SetAngles(Angle(0, 70, 0))
    merchant:Spawn()
    merchant:SetModel("models/gmod_tower/merchant.mdl")
    merchant:SetSequence(merchant:LookupSequence("lineidle01"))
    merchant.Selling = {
        ["build"] = 800,
        ["pistol"] = 1200,
        ["toyhammer"] = 900
    }
    print(merchant)
end

function GM:InitPostEntity()
    if LOADED then return end
    LOADED = true
    load()
end

function GM:PostCleanupMap()
    load()
end