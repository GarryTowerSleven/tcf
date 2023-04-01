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

    ply:SetSubMaterial()

    timer.Simple(0, function()
    if new == TEAM_STAFF or new == TEAM_STAFF2 then
        for i, mat in ipairs(ply:GetMaterials()) do
            if string.find(mat, "sheet") then

                local fe = string.find(ply:GetModel(), "fe") and "fe" or ""
                ply:SetSubMaterial(i - 1, "models/humans/" .. fe .. "male/gmtsui1/citizen_sheet")
            end
        end
    end
end)
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
    
    elseif IsValid(ply) and ply:IsPlayer() then
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

// Adds all missing shit to Lobby 2

local BeachChairColors = {
	Color( 230, 25, 75 ),		-- Red
	Color( 60, 180, 75 ),		-- Green
	Color( 255, 225, 25 ),	-- Yellow
	Color( 0, 130, 200 ),		-- Blue
	Color( 245, 130, 48 ),	-- Orange
	Color( 145, 30, 180 ),	-- Purple
	Color( 70, 240, 240 ),	-- Cyan
	Color( 240, 50, 230 ),	-- Magenta
	Color( 210, 245, 60 )		-- Lime
}

local condoDoorData = {
	{ 'bathroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 0, 0), Vector(-6, 4, 10)  },
	{ 'extraroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'outside', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, -90, 0), Vector(4, 6, 10)  },
	{ 'closet', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'pool2', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 90, 0), Vector(-4, -6, 10)  },
	{ 'bedroom', 'models/map_detail/condo_slidingdoor.mdl', Angle(0, 0, 0), Vector(-6, 4, 10)  },
	{ 'shower', 'models/map_detail/condo_shower_door.mdl', Angle(0, -90, 0), Vector(0, -34, -39)  },
	{ 'pool', 'models/map_detail/condo_slidingbackdoor.mdl', Angle(0, -90, 0), Vector(2, 0, -0.3)  },
}

local function GetNearestCondo( pos )

	local doors = {}

	for k,v in pairs( ents.FindByClass("gmt_condo_door") ) do
		if v:GetCondoDoorType() == 1 then
			doors[v] = v:GetPos():Distance(pos)
		end
	end

	local value = math.min( unpack( doors ) )
	local door = table.KeyFromValue( doors, value )

	if !IsValid(door) then return end

	return door:GetCondoID()

end

local function AddL2Camera( pos, ang )
	local cam = ents.Create("gmt_condo_camera")
	cam:SetPos( pos )
	cam:SetAngles( ang )
	cam:Spawn()

	cam:SetNWInt( "Condo", (GetNearestCondo( pos ) or 0) )

end

local function AddL2Seat( model, pos, angle, skin, color )

	local seat = ents.Create( "prop_dynamic" )
	seat:SetPos( pos )
	seat:SetAngles( angle )
	seat:SetModel( model )
	seat:SetSolid( SOLID_VPHYSICS )
	seat:SetSkin( skin )
	seat:Spawn()

	if model == "models/map_detail/beach_chair.mdl" then
		seat:SetColor( table.Random( BeachChairColors ) )
	end

	if color != Color(255, 255, 255) then
		seat:SetColor( color )
	end

	seat:SetSaveValue("fademindist", 2048)
	seat:SetSaveValue("fademaxdist", 4096)

end

local function AddL2Door( ent, name, pos )

	local doorRaw = string.sub( name, 13 )

	local doorID = string.sub( doorRaw, 1, 2 )
	local doorName = string.sub( doorRaw, 14 )

	local condodoorAng, condodoorPos, condodoorModel

	for k,v in pairs(condoDoorData) do
		if v[1] == doorName then
			condodoorAng = v[3]
			condodoorPos = pos + v[4]
			condodoorModel = v[2]
		end
	end

	local door = ents.Create( "prop_dynamic" )
	door:SetPos( condodoorPos or pos )
	door:SetAngles( condodoorAng or Angle(0,0,0) )
	door:SetModel( condodoorModel or 'models/map_detail/condo_slidingdoor.mdl' )
	door:SetParent( ent )
	door:Spawn()
	door:DrawShadow( false )

end

local function AddMapEntity( class, pos, ang )

	if !class then return end

	if !pos then
		print("Not spawning map entity " .. class .. ". No position specified.")
		return
	end

	local e = ents.Create( class )
	e:SetPos( pos )
	e:SetAngles( ang or Angle(0,0,0) )
	e:Spawn()
end

local function SpawnDynamicProp( model, pos, ang, shadow )
	local prop = ents.Create( "prop_dynamic" )
	prop:SetPos( pos )
	prop:SetAngles( ang )
	prop:SetModel( model )
	prop:SetSolid( SOLID_VPHYSICS )
	prop:Spawn()
	prop:DrawShadow( shadow )
end

local function RespawnEnt( ent )
	local class = ent:GetClass()
	local pos = ent:GetPos()
	pos.y = pos.y + 1.5
	local ang = ent:GetAngles()

	ent:Remove()

	local new = ents.Create( class )
	new:SetPos( pos )
	new:SetAngles( ang )
	new:Spawn()
end

local function NetworkCondoPanelIDs()
	for k,v in pairs(ents.FindByClass("gmt_condo_panel")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

		v:SetNWInt( "condoID", condoID )
	end
end

local function SpawnCondoPlayers()
	for k,v in pairs(ents.FindByClass("gmt_roomloc")) do
		local entloc = Location.Find( v:GetPos() )
		local condoID = entloc

		local e = ents.Create("gmt_condoplayer")
		e:SetPos(v:GetPos())
		e:Spawn()
		e:SetNWInt( "condoID", condoID )

		e:SetNoDraw(true)
		e:SetSolid(SOLID_NONE)
	end
end

local function MapFixes()

	// Center SK Multi
	for k,v in pairs( ents.FindInSphere( Vector(6254.8671875, -6095.8579101563, -825.11450195313), 600 ) ) do
		if v:GetClass() == "gmt_multiserver" then
			v:SetPos( v:GetPos() - Vector(16, 0, 0) )
		end
	end

	// Condo Doors
	for k,v in pairs(ents.FindByClass("func_door")) do
		AddL2Door( v, v:GetName(), v:GetPos() )
	end

	// Condo Bathroom
	for k,v in pairs( ents.FindByClass("gmt_roomloc") ) do
		AddL2Seat( "models/map_detail/condo_toilet.mdl", v:GetPos() + Vector(-32, -148, 0.3), Angle(0, 180, 0), 0, Color(255, 255, 255))

		SpawnDynamicProp( "models/map_detail/condo_toiletpaper.mdl", v:GetPos() + Vector(-0, -160, 28.8), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/condo_towelrack.mdl", v:GetPos() + Vector(-0, -212, 60), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/bathroomsink.mdl", v:GetPos() + Vector(-184, -264, 0), Angle(0,180,0), false )
		SpawnDynamicProp( "models/map_detail/mirrorfixture.mdl", v:GetPos() + Vector(-188, -299, 65), Angle(0,90,0), false )
		SpawnDynamicProp( "models/map_detail/bathtub1.mdl", v:GetPos() + Vector(-116, -151, 0.3), Angle(0,270,0), false )
	end

	// Mapboard in Station
	for k,v in pairs(ents.FindByClass('gmt_mapboard')) do
		if v:GetPos() == Vector(7128.000000, 0.000000, -1074.000000) then
			v:Remove()
		end
	end

	// Gamemodes Banner
	AddMapEntity( "gmt_gamebanner", Vector( 4400, -2915, 118 ), Angle( 0, 0, 0 ) )
	--SpawnDynamicProp( "models/map_detail/gmbanners.mdl", Vector( 4400, -2915, 118 ), Angle( 0, 90, 0 ), true )

	// Remove Fog
	timer.Simple( 3, function()
		for _, v in pairs( ents.FindByClass("func_smokevolume") ) do
			v:Remove()
		end
	end)

	// Respawn Electronic NPC
	timer.Simple( 5, function()
		for k,v in pairs( ents.FindByClass("gmt_npc_electronic") ) do
			RespawnEnt( v )
		end
	end)

	// Arcade Tables
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4064, 4111, -896), Angle(0,60,0), false )
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4656, 4364, -896), Angle(0,75,0), false )
	SpawnDynamicProp( "models/wilderness/wildernesstable1.mdl", Vector(4656, 4413, -896), Angle(0,55,0), false )

	// Ballrace Port Goal
	SpawnDynamicProp( "models/props_memories/memories_levelend.mdl", Vector(3424, -6400, -904), Angle(0, 0, 0), false )

end

hook.Add("InitPostEntity","AddL2Ents",function()

	MapFixes()

	NetworkCondoPanelIDs()
	SpawnCondoPlayers()	


	// Dopefish
	local ent = ents.Create("prop_dynamic")
	ent:SetPos( Vector(-5726.058594, -2349.844482, -1063.220093) )
	ent:SetAngles( Angle(1.677856, 180.635330, 0.000000) )
	ent:SetModel( "models/gmod_tower/dopefishisaliveyall.mdl" )
	ent:Spawn()
	ent:ResetSequenceInfo()
	ent:SetSequence( "idle" )

	// Halloween Shop
	if IsHalloween then
		AddL2Seat( "models/gmod_tower/shopstand.mdl", Vector( 5497.978516, -187.837418, -895.029480 ), Angle(0, 90, 0), 0, Color(255, 255, 255))
		AddMapEntity( "gmt_npc_halloween", Vector( 5497.978516, -220, -895.029480 ), Angle( 0, 90, 0 ) )
	end

	// Christmas Sack
	if IsChristmas then
		AddMapEntity( "gmt_presentbag", Vector( 4927.875, 208.3125, -894.718750 ), Angle( 0, 120, 0 ) )
	end

	// Particles Store
	--AddMapEntity( "gmt_npc_particles", Vector( 7434, 221, -1088 ), Angle( 0, -135, 0 ) )
	
	// Transit Station NPCs
	AddMapEntity( "gmt_npc_vip", Vector( 7425, 218, -1085 ), Angle( 0, -135, 0 ) )
	AddMapEntity( "gmt_npc_money", Vector( 7425, -212, -1085 ), Angle( 0, 135, 0 ) )

	// Web Board
	//AddMapEntity( "gmt_webboard", Vector( 7504, 0, -1080 ), Angle( 0, 180, 0 ) )
	
	// The Board
	AddMapEntity( "gmt_streamer_board", Vector( 2580, 4930, -911 ), Angle( 0, 75, 0 ) )

	AddL2Camera( Vector( -1154, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -672, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -192, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -3940, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -3458, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -2978, 54, 15100 ), Angle(0, 90, 0) )
	AddL2Camera( Vector( -2888, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -3368, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -3850, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -102, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -582, 654, 15100 ), Angle(0, -90, 0) )
	AddL2Camera( Vector( -1064, 654, 15100 ), Angle(0, -90, 0) )

	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(64, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(224, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(64, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(224, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2464, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2320, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2912, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3056, -1024, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, -368, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, -224, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, 368, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(1664, 224, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2464, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2320, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2912, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3056, 1024, -896), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, 368, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, 224, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, -368, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3712, -224, -896), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5032, 248, -883), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5144, 248, -883), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5032, -248, -883), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5144, -248, -883), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 1312, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 1176, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, 584, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -1312, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -1176, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(4864, -584, -883), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1188, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1028, -104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1028, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-1188, 104, -896), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4204, -368, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4364, -368, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4364, -160.08799743652, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4204, -160.08799743652, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4372, 376, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4212, 376, -895.75), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4212, 168.08799743652, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4372, 168.08799743652, -895.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1896.9499511719, -4646.6298828125, -2604), Angle(0, 34.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1885.3100585938, -4713.9799804688, -2604), Angle(0, -55, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1829.5999755859, -4634.9799804688, -2604), Angle(0, 125, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1822.0699462891, -4699.4501953125, -2604), Angle(0, -145.00001525879, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1953.5600585938, -4502.2900390625, -2604), Angle(0, -10.000014305115, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1914.1800537109, -4446.4399414063, -2604), Angle(0, 80, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1863.2700195313, -4486.7001953125, -2604), Angle(0, 170, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1897.7099609375, -4541.6801757813, -2604), Angle(0, -99.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2021.8000488281, -4594, -2604), Angle(0, 177, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2067.419921875, -4547.830078125, -2604), Angle(0, 86.999992370605, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2062.6799316406, -4644.3701171875, -2604), Angle(0, -93.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5397.8999023438, -3608.25, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5333.25, -3617.8598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5459.490234375, -3619.1201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5708.41015625, -3624.3598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5834.6499023438, -3625.6201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(5773.0600585938, -3614.75, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6147.3500976563, -3629.4301757813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6212, -3619.8198242188, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6273.58984375, -3630.6899414063, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3363.3500976563, -3629.4301757813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3428, -3619.8198242188, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3489.5900878906, -3630.6899414063, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2924.4099121094, -3624.3598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(3050.6499023438, -3625.6201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2989.0600585938, -3614.75, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2613.8999023438, -3608.25, -895.53900146484), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2549.25, -3617.8598632813, -895.53900146484), Angle(0, 7.5000100135803, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2675.4899902344, -3619.1201171875, -895.53900146484), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4332, -4952, -895.7509765625), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4492, -4952, -895.7509765625), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4332, -4744.08984375, -895.7509765625), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4492, -4744.08984375, -895.7509765625), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -768, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -840, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -568, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -640, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(4617.759765625, -704, -3519.75), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3339, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3373, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3407, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3441, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3475, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3509, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3543, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3577, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3645, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3611, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3834, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3793, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, 768, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, 920, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, 920, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, -768.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, -768.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, -920.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, -920.08801269531, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5400, -216, -595), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5560, -216, -595), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5400, 216, -595), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench_metal.mdl", Vector(5560, 216, -595), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, -1128, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-256, 1127.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(-96, 1127.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(576, 1135.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, 768, -672), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(688, 1135.9100341797, -672), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-448, 1536, -672), Angle(0, 90, 0), 1, Color(172, 92, 45, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(218.03500366211, 1536, -672), Angle(0, 270, 0), 1, Color(172, 92, 45, 255))
	AddL2Seat( "models/gmod_tower/medchair.mdl", Vector(-1568, -1016, -888), Angle(0, 334, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/reclining_chair.mdl", Vector(-1568, -968, -888), Angle(0, 247, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/haxxer/me2_props/illusive_chair.mdl", Vector(-1568, -920, -888), Angle(0, 153.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/comfychair.mdl", Vector(-912, -1400, -664), Angle(0, 110, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/splayn/rp/lr/chair.mdl", Vector(-768, -1392, -664), Angle(0, 135, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2600, -9536, -2624), Angle(0, 90, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2600, -9404, -2624), Angle(0, 90, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(3402.0300292969, -9404, -2624), Angle(0, 270, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(3402.0300292969, -9536, -2624), Angle(0, 270, 0), 1, Color(139, 12, 5, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2809.1298828125, -2490.2399902344, -863.81097412109), Angle(0, 244, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2820, -2428.6499023438, -863.81097412109), Angle(0, 269.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2810.3898925781, -2364, -863.81097412109), Angle(0, 277.5, 0), 1, Color(196, 0, 0, 255))

	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2818.1101074219, -2104.9299316406, -864), Angle(0, 279, 0), 1, Color(196, 0, 0, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2696.0700683594, -2015.6300048828, -863.81097412109), Angle(0, 19, 0), 1, Color(196, 0, 0, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2756, -2024, -863.81097412109), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))

	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(2770.7399902344, -2047.4300537109, -863.81097412109), Angle(0, 315, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2816, -2128, -863.81097412109), Angle(0, 285, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2688, -2000, -863.81097412109), Angle(0, 345, 0), 1, Color(196, 0, 0, 255))

	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2386.9799804688, -1994.2800292969, -864), Angle(0, 7.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2451.6298828125, -1984.6800537109, -864), Angle(0, 359.5, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(2513.2199707031, -1995.5500488281, -864), Angle(0, 334, 0), 1, Color(196, 0, 0, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6432, -288, -1066.4799804688), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6672, -288, -1066.4799804688), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6432, 288, -1066.4799804688), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6672, 288, -1066.4799804688), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, 936, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, 816, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, 936, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, 816, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, -816, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(6592, -936, -1259), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, -816, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7664, -936, -1259), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, -101, -1066.4799804688), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/station_bench.mdl", Vector(7484, 99.000099182129, -1067), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5056, -2624), Angle(0, 105, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1888, -4992, -2623.8100585938), Angle(0, 90.000007629395, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -4928, -2623.8100585938), Angle(0, 74.999984741211, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5264, -2624), Angle(0, 105, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1936, -5135.9995117188, -2623.8100585938), Angle(0, 74.999984741211, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(1888, -5200, -2623.8100585938), Angle(0, 90.000007629395, 0), 1, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2536, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2576, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2456, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2496, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2296, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2336, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2376, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2416, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4352, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4392, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4432, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2247.0500488281, -4543.080078125, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1999.6700439453, -4352.16015625, -2604), Angle(0, -180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(2096.330078125, -4351.83984375, -2604), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1960, -4353.7797851563, -2604), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1863.3399658203, -4354.1000976563, -2604), Angle(0, -180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1761.7799072266, -4495.33984375, -2604), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/lobby_cafechair.mdl", Vector(1762.0999755859, -4592, -2604), Angle(0, -90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2200, -4544, -2623), Angle(0, 90.000007629395, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/music_drumset_stool.mdl", Vector(2132, -4476, -2623), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector(2048, -5664, -2623.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_curve_couch.mdl", Vector(2304, -5664, -2623.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3787.9099121094, -4657.009765625, -895.76000976563), Angle(0, 5.0000100135803, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3827.9299316406, -4775.0498046875, -895.76000976563), Angle(0, 33.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2924.0700683594, -4785.0498046875, -895.76000976563), Angle(0, 147, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(2958.0900878906, -4687, -895.76000976563), Angle(0, 176.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3458, -5286.91015625, -895.76000976563), Angle(0, 270.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(3332, -5286.91015625, -895.76000976563), Angle(0, 270.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5356, -5297.91015625, -895.76000976563), Angle(0, 269.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5482, -5297.91015625, -895.76000976563), Angle(0, 269.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5839.91015625, -4706, -895.76000976563), Angle(0, 3.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5873.9301757813, -4804.0498046875, -895.76000976563), Angle(0, 33, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(5018.08984375, -4668.009765625, -895.76000976563), Angle(0, 175, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/plaza_bench.mdl", Vector(4978.0698242188, -4786.0498046875, -895.76000976563), Angle(0, 146.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1754, -586, 15303), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1658, -690, 15303), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2041, 1710, 14983.200195313), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1608.5500488281, -136.86000061035, 14983.200195313), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-1690.5500488281, -54.860000610352, 14983.200195313), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2434.5900878906, -16.590000152588, 14983.200195313), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2352.5900878906, -98.589996337891, 14983.200195313), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2402, -674, 15303), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(-2298, -578, 15303), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4149.8100585938, 1037.0999755859, -952.95098876953), Angle(-3.6437900066376, 311.76800537109, 1.69468998909), 0, Color(79, 237, 33, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4303.509765625, 1558.8699951172, -942.40600585938), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(207, 228, 58, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4254.7700195313, 1502.6999511719, -938.06701660156), Angle(-3.6437900066376, 305.76800537109, 1.69468998909), 0, Color(224, 128, 39, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4227.3901367188, 1777.0200195313, -935.71301269531), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(228, 58, 186, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-4543.3500976563, 1793.1999511719, -972.94598388672), Angle(-0.71457898616791, 2.9219899177551, -2.3608200550079), 0, Color(32, 177, 208, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3716.7800292969, 1460.7099609375, -907.52099609375), Angle(-0.71457898616791, 305.92199707031, -2.3608200550079), 0, Color(216, 58, 228, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3744.3000488281, 966.97698974609, -935.69299316406), Angle(-3.6437900066376, 292.76800537109, 1.69468998909), 0, Color(241, 18, 23, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3717.6799316406, 908.56701660156, -935.78302001953), Angle(-3.6437900066376, 292.76800537109, 1.69468998909), 0, Color(48, 98, 216, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3833, 4334, -895.98297119141), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3696, 4224, -895.98297119141), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(3744, 4312, -895.98297119141), Angle(0, 30, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(4964.990234375, 4327.8999023438, -895.98297119141), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(5053.919921875, 4305.83984375, -895.98297119141), Angle(0, 330, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/sunabouzu/theater_sofa01.mdl", Vector(5101.740234375, 4217.8500976563, -895.98297119141), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3150, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(3191, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5433, -2943.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5350, -2917.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5268, -2891.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5186, -2865.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5106, -2839.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 5025, -2813.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5155, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5189, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5223, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5257, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5291, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5325, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5359, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5393, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5461, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5427, 4945, -2787.75), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(4966, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5007, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5350, -2918), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5268, -2892), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5186, -2866), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5106, -2840), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 5025, -2814), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5650, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/gmod_tower/theater_seat.mdl", Vector(5609, 4945, -2788), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6422, 1209, -607), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6340, 1127, -607), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6349, 1437, -607), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6267, 1355, -607), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6364.7299804688, -1126.2199707031, -606.80999755859), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6288.58984375, -1210.5200195313, -606.80999755859), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6444.3901367188, -1341.5500488281, -606.80999755859), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6374.1201171875, -1423.1600341797, -606.80999755859), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, -816, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, -720, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, -632, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, -464, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, -368, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, -280, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, 256, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, 352, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 440, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7000, 608, -608), Angle(0, 239.5, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7016, 704, -608), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	//AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 792, -608), Angle(0, 287, 0), 0, Color(255, 255, 255, 255))

	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 712, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 807, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 617, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, 392, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 487, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, 297, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -380, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -285, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -475, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7004, -704, -607.81097412109), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -609, -607.81097412109), Angle(0, 360, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6949, -799, -607.81097412109), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7257, 968, -607.5), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7352, 1023, -607.5), Angle(0, 270, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7162, 1023, -607.5), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7242, -965, -607.5), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7337, -1020, -607.5), Angle(0, -90, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7147, -1020, -607.5), Angle(0, 90, 0), 0, Color(255, 255, 255, 255))

	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7504, 1512, -608), Angle(0, 343, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(7416, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7320, 1504, -608), Angle(0, 31, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(7008, 1504, -608), Angle(0, 329.5, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/sofa_lobby.mdl", Vector(6912, 1520, -608), Angle(0, 0, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/chair_lobby.mdl", Vector(6824, 1512, -608), Angle(0, 17, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3503.6398925781, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3707.2900390625, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3639.3999023438, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3571.5200195313, -935.53802490234, -896), Angle(0, 180, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3392.0700683594, -895.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3344.0700683594, -847.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3296.0700683594, -799.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-3248.0700683594, -751.4169921875, -896), Angle(0, 225, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2991.9299316406, -1818.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2935.9299316406, -1762.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2887.9299316406, -1714.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2839.9299316406, -1666.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))
	AddL2Seat( "models/map_detail/beach_chair.mdl", Vector(-2791.9299316406, -1618.5799560547, -896), Angle(0, 45, 0), 0, Color(255, 255, 255, 255))

end)