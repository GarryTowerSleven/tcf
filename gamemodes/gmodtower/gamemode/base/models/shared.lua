function GM:AllowModel( ply, model )
	return GTowerModels.Models[ model ] == nil || ply:IsAdmin()
end

module( "GTowerModels", package.seeall )

DEBUG = false
DefaultModel = "models/player/normal.mdl"
MaxScale = 4.0
Models = Models or {}
AdminModels = AdminModels or {}

local function AddPlayerModel( name, model, hands, admin )

	player_manager.AddValidModel( name, model )
	player_manager.AddValidHands( name, hands or "models/weapons/c_arms_citizen.mdl", 0, "00000000" )

	list.Set( "PlayerOptionsModel", name, model )

	if not admin then
		Models[name] = model -- Add to the list of public models
	else
		AdminModels[name] = model -- Add to the list of admin only/ignored models
	end

end

// Private Use
// ============================
AddPlayerModel( "infected", "models/player/virusi.mdl", nil, true ) -- for virus
AddPlayerModel( "minigolf", "models/sunabouzu/golf_ball.mdl", nil, true ) -- minigolf!
AddPlayerModel( "uchghost", "models/uch/mghost.mdl", nil, true ) -- uch
AddPlayerModel( "uchpigmask", "models/uch/pigmask.mdl", nil, true ) -- uch

// Public Use
// ============================

AddPlayerModel( "normal", "models/player/normal.mdl" ) // Used in Duels and PVP Battle!
AddPlayerModel( "teslapower", "models/player/teslapower.mdl" )
AddPlayerModel( "spytf2", "models/player/drpyspy/spy.mdl" )
AddPlayerModel( "shaun", "models/player/shaun.mdl" )
AddPlayerModel( "isaac", "models/player/security_suit.mdl" )
AddPlayerModel( "midna", "models/player/midna.mdl" )
AddPlayerModel( "sunabouzu", "models/player/Sunabouzu.mdl" )
AddPlayerModel( "zoey", "models/player/zoey.mdl" )
AddPlayerModel( "sniper", "models/player/robber.mdl" )
AddPlayerModel( "spacesuit", "models/player/spacesuit.mdl" )
AddPlayerModel( "scarecrow", "models/player/scarecrow.mdl" )
AddPlayerModel( "smith", "models/player/smith.mdl" )
AddPlayerModel( "libertyprime", "models/player/sam.mdl" )
AddPlayerModel( "rpcop", "models/player/azuisleet1.mdl" )
AddPlayerModel( "altair", "models/player/altair.mdl" )
AddPlayerModel( "dinosaur", "models/player/foohysaurusrex.mdl" )
AddPlayerModel( "rorschach", "models/player/rorschach.mdl" )
AddPlayerModel( "aphaztech", "models/player/aphaztech.mdl" )
AddPlayerModel( "faith", "models/player/faith.mdl" )
AddPlayerModel( "robot", "models/player/robot.mdl" )
AddPlayerModel( "niko", "models/player/niko.mdl" )
AddPlayerModel( "zelda", "models/player/zelda.mdl" )
AddPlayerModel( "dude", "models/player/dude.mdl" )
AddPlayerModel( "leon", "models/player/leon.mdl" )
AddPlayerModel( "chris", "models/player/chris.mdl" )
AddPlayerModel( "wesker", "models/player/re/albert_wesker_overcoat_pm.mdl" )
AddPlayerModel( "gmen", "models/player/gmen.mdl" )
AddPlayerModel( "joker", "models/player/joker.mdl" )
AddPlayerModel( "hunter", "models/player/hunter.mdl" )
AddPlayerModel( "steve", "models/player/mcsteve.mdl" )
AddPlayerModel( "gordon", "models/player/hl2ac_gordon.mdl" )
AddPlayerModel( "masseffect", "models/player/masseffect.mdl" )
AddPlayerModel( "scorpion", "models/player/scorpion.mdl" )
AddPlayerModel( "subzero", "models/player/subzero.mdl" )
AddPlayerModel( "undeadcombine", "models/player/clopsy.mdl" )
AddPlayerModel( "boxman", "models/player/nuggets.mdl" )
AddPlayerModel( "macdguy", "models/player/macdguy.mdl" )
AddPlayerModel( "rayman", "models/player/rayman.mdl" )
AddPlayerModel( "raz", "models/player/raz.mdl" )
AddPlayerModel( "knight", "models/player/knight.mdl" )
AddPlayerModel( "bobafett", "models/player/bobafett.mdl" )
AddPlayerModel( "chewbacca", "models/player/chewbacca.mdl" )
AddPlayerModel( "assassin", "models/player/dishonored_assassin1.mdl" )
AddPlayerModel( "haroldlott", "models/player/haroldlott.mdl" )
AddPlayerModel( "harry_potter", "models/player/harry_potter.mdl" )
AddPlayerModel( "jack_sparrow", "models/player/jack_sparrow.mdl" )
AddPlayerModel( "jawa", "models/player/jawa.mdl" )
AddPlayerModel( "marty", "models/player/martymcfly.mdl" )
AddPlayerModel( "samuszero", "models/player/samusz.mdl" )
AddPlayerModel( "skeleton", "models/player/skeleton.mdl" )
AddPlayerModel( "stormtrooper", "models/player/stormtrooper.mdl" )
AddPlayerModel( "luigi", "models/player/suluigi_galaxy.mdl" )
AddPlayerModel( "mario", "models/player/sumario_galaxy.mdl" )
AddPlayerModel( "zero", "models/player/lordvipes/MMZ/Zero/zero_playermodel_cvp.mdl" )
AddPlayerModel( "yoshi", "models/player/yoshi.mdl" )
AddPlayerModel( "miku", "models/player/miku.mdl" )
--AddPlayerModel( "helite", "models/player/lordvipes/h2_elite/eliteplayer.mdl", "models/player/lordvipes/h2_elite/arms/elitearms.mdl" )
--AddPlayerModel( "grayfox", "models/player/lordvipes/Metal_Gear_Rising/gray_fox_playermodel_cvp.mdl" )
AddPlayerModel( "crimsonlance", "models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl" )
--[[AddPlayerModel( "nighthawk", "models/player/lordvipes/residentevil/nighthawk/nighthawk_playermodel_cvp.mdl", "models/player/lordvipes/residentevil/nighthawk/nighthawkARMS_cvp.mdl" )
AddPlayerModel( "hunk", "models/player/lordvipes/residentevil/HUNK/hunk_playermodel_cvp.mdl", "models/player/lordvipes/residentevil/HUNK/hunkarms_cvp.mdl" )
AddPlayerModel( "geth", "models/player/lordvipes/masseffect/geth/geth_trooper_playermodel_cvp.mdl", "models/player/lordvipes/masseffect/geth/Arms/getharms_cvp.mdl" )]]
AddPlayerModel( "walterwhite", "models/agent_47/agent_47.mdl" )
--[[AddPlayerModel( "franklin", "models/GrandTheftAuto5/Franklin.mdl" )
AddPlayerModel( "trevor", "models/GrandTheftAuto5/Trevor.mdl" )
AddPlayerModel( "michael", "models/GrandTheftAuto5/Michael.mdl" )]]
AddPlayerModel( "jackskellington", "models/vinrax/player/Jack_player.mdl" ) -- by Vinrax
AddPlayerModel( "deadpool", "models/player/deadpool.mdl" )
AddPlayerModel( "deathstroke", "models/norpo/ArkhamOrigins/Assassins/Deathstroke_ValveBiped.mdl" )
AddPlayerModel( "carley", "models/nikout/carleypm.mdl" )
AddPlayerModel( "solidsnake", "models/player/big_boss.mdl" )
--AddPlayerModel( "atlas", "models/bots/survivor_mechanic.mdl", "models/bots/arms/v_arms_mechanic_new.mdl" ) -- by Voikanaa
AddPlayerModel( "tronanon", "models/player/anon/anon.mdl" ) -- by Rokay "Rambo"
AddPlayerModel( "alice", "models/player/alice.mdl" )
AddPlayerModel( "ash", "models/player/red.mdl" )
AddPlayerModel( "megaman", "models/vinrax/player/megaman64_player.mdl" )
AddPlayerModel( "kilik", "models/player/hhp227/kilik.mdl" )
--AddPlayerModel( "bond", "models/player/bond.mdl" )
AddPlayerModel( "ironman", "models/Avengers/Iron Man/mark7_player.mdl" )
AddPlayerModel( "masterchief", "models/player/lordvipes/haloce/spartan_classic.mdl" )
AddPlayerModel( "doomguy", "models/ex-mo/quake3/players/doom.mdl" )
AddPlayerModel( "freddykruger", "models/player/freddykruger.mdl" )
AddPlayerModel( "greenarrow", "models/player/greenarrow.mdl" )
AddPlayerModel( "linktp", "models/player/linktp.mdl" )
AddPlayerModel( "roman", "models/player/romanbellic.mdl" )
AddPlayerModel( "denton", "models/player/jcplayer.mdl" )
AddPlayerModel( "james", "models/player/sh/james_sunderland.mdl" )
AddPlayerModel( "oldgordon", "models/player/tcf/hl1_gordon.mdl" )
AddPlayerModel( "gasmask", "models/player/tcf/gasmask_citizen.mdl" )
AddPlayerModel( "redrabbit", "models/player/redrabbit2.mdl" )
AddPlayerModel( "renamon", "models/player/renamon.mdl" )
AddPlayerModel( "david", "models/player/dwecqihoodie.mdl" )
--AddPlayerModel( "ornstein", "models/nikout/darksouls2/characters/olddragonslayer.mdl" )

// Remove bad playermodels
// ============================
/*local PlayerModels = player_manager.AllValidModels()
PlayerModels["american_assault"] = nil
PlayerModels["german_assault"] = nil
PlayerModels["scientist"] = nil
PlayerModels["gina"] = nil
PlayerModels["magnusson"] = nil*/

ScaledModels = {
	/*["models/player/sackboy.mdl"] = 0.55,*/
	["models/player/rayman.mdl"] = 0.75,
	["models/player/midna.mdl"] = 0.45,
	["models/player/mcsteve.mdl"] = 0.75,
	["models/player/raz.mdl"] = 0.50,
	["models/player/jawa.mdl"] = 0.65,
	["models/player/sumario_galaxy.mdl"] = 0.45,
	["models/player/suluigi_galaxy.mdl"] = 0.5,
	["models/player/lordvipes/mmz/zero/zero_playermodel_cvp.mdl"] = 0.85,
	["models/vinrax/player/megaman64_player.mdl"] = 0.7,
	["models/player/alice.mdl"] = 0.85,
	["models/player/harry_potter.mdl"] = 0.75,
	["models/player/yoshi.mdl"] = 0.5,
	["models/player/linktp.mdl"] = 0.85,
	["models/player/red.mdl"] = 0.85,
	["models/player/martymcfly.mdl"] = 0.85,
	["models/player/hhp227/kilik.mdl"] = 1.05,

	["models/player/redrabbit2.mdl"] = 0.65,
	["models/player/redrabbit3.mdl"] = 0.65,
	["models/player/digi.mdl"] = 0.75,
}

local BodyGroupHatModels = {
	["models/player/freddykruger.mdl"] = { 1, 1 },
	["models/player/linktp.mdl"] = { 1, 1 },
	["models/heroes/windranger/windranger.mdl"] = { 1, 0 },
}

function GetScale( model )
	return ScaledModels[ model ] or 1
end

function GetHatBodygroup( model )
	return BodyGroupHatModels[ model ] or {0,0}
end

function SetHull( ply, scale )
	if DEBUG then
		Msg("Changing " .. tostring(ply) .. " scale to: " .. scale .. "\n" )
	end

	/*if scale != 1.0 then
		ply:SetHull( Vector( -16, -16, 0 ) * scale, Vector( 16,  16,  72 ) * scale)
		ply:SetHullDuck( Vector( -16, -16, 0 ) * scale , Vector( 16,  16,  36 ) * scale )
	else
		ply:ResetHull()
	end*/

	local ViewOffset = Vector(0,0,64) * scale
	local ViewOffsetDucket = Vector(0,0,28) * scale

	if ViewOffset.z < 1 then
		ViewOffset.z = 1
	end

	if ViewOffsetDucket.z < 1 then
		ViewOffsetDucket.z = 1
	end

	ply:SetViewOffset( ViewOffset )
	ply:SetViewOffsetDucked( ViewOffsetDucket )

	ply:SetJumpPower( math.Clamp( 240 * ( 1 / scale ), 240, 400 ) )
	ply:SetStepSize( math.Clamp( 18 * scale, 1, 36 ) )

	ply._PlyScale = scale

	ply:SetModelScale( scale, 0 )

	if CLIENT and ply.ResetEquipmentScale then
		ply:ResetEquipmentScale()
	end
end

/*function UpdateModelScaleForAll( ply )

	if SERVER then
		UpdateModelScale( ply )

		umsg.Start("UpdateScale")
			umsg.Short( ply:EntIndex() )
		umsg.End()
	end

end

if CLIENT then
	usermessage.Hook("UpdateScale", function( um )

		local ent = ents.GetByIndex( um:ReadShort() )

		if IsValid( ent ) && ent:IsPlayer() then
			UpdateModelScale( ent )
		end

	end )
end*/

if CLIENT then
	hook.Add( "PlayerThink", "PlayerUpdateScales", function( ply )

		if hook.Call( "ShouldAutoScalePlayers", GAMEMODE ) == true then
			for _, ply2 in pairs( player.GetAll() ) do
				UpdateOnClient( ply2 )
			end
		end

	end )
end

function UpdateModelScale( ply )

	// local model = ply:GetModel()
	local scale = Get( ply ) or 1.0
		
	if ply._PlyScale != scale then
		SetHull( ply, scale )
	end

	if CLIENT then
		UpdateOnClient( ply )
	end

end

function UpdateOnClient( ply )

	local scale = Get( ply ) or 1.0
	local ModelScale = math.Round( /*GetScale( ply:GetModel() ) * */scale, 2 )

	if math.Round( ply:GetModelScale(), 2 ) != ModelScale then

		//MsgN( "rescaling", ply )
		//MsgN( ModelScale, " ", math.Round( ply:GetModelScale(), 2 ) )

		ply:SetModelScale( ModelScale, 0 )
		ply:SetRenderBounds( Vector( -16, -16, 0 ) * ModelScale, Vector( 16,  16,  72 ) * ModelScale )
		ply:ResetEquipmentScale()

	end

end

function ChangeHull( ply )
	if SERVER && ply:InVehicle() then
		ply:ExitVehicle()
	end

	timer.Simple( 0.0, ChangeHull2, ply )
end

ChangeHull2 = function( ply )
	
	if IsValid( ply ) && _G.GAMEMODE.AllowChangeSize != false then
				
		// local model = ply:GetModel()
		local scale = Get( ply ) or 1.0
		
		if ply._PlyScale != scale then
			SetHull( ply, scale )
		end
		
		if CLIENT then
			UpdateOnClient( ply )
		end
		
	end

end

function GetModelName( Name )
	local model, skin = string.match( string.lower( Name ), "([%a%d_]+)[%-]*(%d*)" )

	return model, tonumber( skin ) or 0
end

_G.hook.Add("Location","GTowerScaleHook", function( ply )
	ChangeHull( ply )
end )

if IsLobby then
	plynet.Register( "Float", "ModelSize", { default = 1.0, callback = function( ply )
		if ( SERVER ) then return end
		
		ChangeHull( ply )
	end } )
end