---------------------------------
//Obligatory at first

co_color = Color( 50, 255, 50 )
co_color2 = Color( 255, 50, 50 )

include("base/sh_global_net.lua")
include("base/exnet/shared.lua")

include("base/debug/cl_init.lua")
include("nwvar/shared.lua")
include("sh_extensions.lua")

include("shared.lua")

include("base/anti_script_hook/cl_scripthookpwnd.lua")
include("base/sh_net_queue.lua")

// Fake clients
include("base/fakeclient/cl_init.lua")
include("base/fakeclient/shared.lua")

include("base/maps/shared.lua")

include("base/enchant/cl_init.lua")

include("base/translation/shared.lua")

include("base/gui/cl_selection.lua")

include("base/gtrivia/cl_init.lua")

//For gamemode
include("base/admin/cl_admin.lua")
include("base/admin/cl_admin_usermessage.lua")
include("base/admin/cl_dbug_profiler.lua")

include("base/gui/cl_icons.lua")
include("base/gui/cl_icons2.lua")
include("base/gui/cl_messages.lua")
include("base/gui/cl_clientmenu.lua")
include("base/gui/cl_clientmenu_action.lua")
include("base/gui/cl_sidemenu.lua")
include("base/gui/cl_voice.lua")
include("base/gui/cl_menu.lua")
include("base/gui/cl_gamemode.lua")

include("base/postevents/init.lua")

// LOADABLES
include("sh_loadables.lua" )

include("base/chat/cl_init.lua" )
include("base/store/cl_init.lua")

include("base/multiserver/cl_init.lua" )

include("base/inventory/cl_init.lua")

include("base/models/cl_init.lua")

include("base/theater/cl_init.lua")

include("base/sh_player.lua")
include("base/sh_money.lua")

include("base/admin/sh_spray.lua")

-- Derma
for k,v in pairs (file.Find("gmodtower/gamemode/base/derma/*.lua","LUA")) do
	include("gmodtower/gamemode/base/derma/" .. v);
end

CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

CurMap = ""
SafeToSend = false

concommand.Add("gmt_modules", function()
	if BASS then
		Msg("BASS module is loaded.\n")
	else
		Msg("BASS module is NOT loaded.\n")
	end

	if chrome then
		Msg("CHROME module is loaded.\n")
	else
		Msg("CHROME module is NOT loaded.\n")
	end

end )

hook.Add("Initialize", "GtowerInit", function()
    local mfont = "CenterPrintText"

	surface.CreateFont("tiny",{ font = "Arial", size = 10, weight = 600, antialias = false, additive = false })
	surface.CreateFont("small",{ font = "Arial", size = 14, weight = 400, antialias = true, additive = false })
	surface.CreateFont("smalltitle",{ font = "Arial", size = 16, weight = 600, antialias = true, additive = false })

	surface.CreateFont("Gtowerhuge",{ font = mfont, size = 45, weight = 100, antialias = true, additive = false })
	surface.CreateFont("Gtowerbig",{ font = mfont, size = 28, weight = 125, antialias = true, additive = false })
	surface.CreateFont("Gtowerbigbold",{ font = mfont, size = 20, weight = 1200, antialias = true, additive = false })
	surface.CreateFont("Gtowerbiglocation",{ font = mfont, size = 28, weight = 125, antialias = true, additive = false })

    surface.CreateFont("Gtowermidbold",{ font = mfont, size = 16, weight = 1200, antialias = true, additive = false })

	surface.CreateFont( "Gtowerbold",{ font = mfont, size = 14, weight = 700, antialias = true, additive = false })

end )

// this is to protect console commands you believe could be called at bad times (the player isn't valid to the server yet)
// or the game would put the command in the buffer to execute on the map change
hook.Add("Think", "PlayerValid", function()
	if IsValid(LocalPlayer()) && (GetWorldEntity() != NULL) then
		SafeToSend = true
		hook.Remove("Think", "PlayerValid")
	end
end)

hook.Add("InitPostEntity", "GTowerFindMap", function()

	local worldspawn = ents.GetByIndex(0)
	local mapName = worldspawn:GetModel()

	mapName = string.gsub(mapName,"(%w*/)","")
	mapName = string.gsub(mapName,".bsp","")

	CurMap = mapName
end )

hook.Add("UpdateAnimation", "Breathing", function(ply)
	ply:SetPoseParameter("breathing", 0.2)
end)

local BAL = 0

hook.Add("CalcView", "DrunkCalc", function(ply, origin, angle, fov)
	if !ply.BAL then return end

	if ply.BAL < BAL then
		BAL = math.Approach(BAL, ply.BAL, -0.2)
	else
		BAL = math.Approach(BAL, ply.BAL, 0.1)
	end

	if ply.BAL <= 0 then return end

	local multiplier = ( 20 / 100 ) * BAL;
	angle.pitch = angle.pitch + math.sin( CurTime() ) * multiplier;
	angle.roll = angle.roll + math.cos( CurTime() ) * multiplier;
end)

hook.Add("RenderScreenspaceEffects", "DrunkEffect", function()
	local lp = LocalPlayer()
	if !IsValid(lp) || BAL <= 0 then return end

	local alpha = ( ( 1 / 100 ) * BAL );
	if( alpha > 0 ) then

		alpha = math.Clamp( 1 - alpha, 0.04, 0.99 );

		DrawMotionBlur( alpha, 0.9, 0.0 );

	end

	local sharp = ( ( 0.75 / 100 ) * BAL );
	if( sharp > 0 ) then
		DrawSharpen( sharp, 0.5 );
	end

	local frac = math.min( BAL / 60, 1 );

	local rg = ( ( ( 0.2 / 100 ) * BAL ) + 0.1 ) * frac;

	local tab = {};
	tab[ "$pp_colour_addr" ] 		= rg;
	tab[ "$pp_colour_addg" ] 		= rg;
	tab[ "$pp_colour_addb" ] 		= 0;
	tab[ "$pp_colour_brightness" ] 		= -( ( 0.05 / 100 ) * BAL );
	tab[ "$pp_colour_contrast" ] 		= 1 - ( ( 0.5 / 100 ) * BAL );
	tab[ "$pp_colour_colour" ] 		= 1;
	tab[ "$pp_colour_mulr" ] 		= 0;
	tab[ "$pp_colour_mulg" ] 		= 0;
	tab[ "$pp_colour_mulb" ] 		= 0;

	DrawColorModify( tab );

end)


hook.Add("CreateMove", "DrunkMove", function(ucmd)
	local ply = LocalPlayer()
	if !IsValid(ply) || BAL <= 0 then return end

	local sidemove = math.sin( CurTime() ) * ( ( 150 / 100 ) * ply.BAL )
	ucmd:SetSideMove( ucmd:GetSideMove() + sidemove )
end)

local function GetCenterPos( ent )



	if !IsValid( ent ) then return end



	if ent:IsPlayer() && !ent:Alive() && IsValid( ent:GetRagdollEntity() ) then

		ent = ent:GetRagdollEntity()

	end



	if ent:IsPlayer() and isfunction( ent.GetClientPlayerModel ) and IsValid( ent:GetClientPlayerModel() ) then

		ent = ent:GetClientPlayerModel():Get()

	end



	local Torso = ent:LookupBone( "ValveBiped.Bip01_Spine2" )



	if !Torso then return ent:GetPos() end



	local pos, ang = ent:GetBonePosition( Torso )



	if !ent:IsPlayer() then return pos end



	return pos



end

HudToHide = {}

surface.CreateFont( "TargetIDText", { font = "Impact", size = 32, weight = 500, antialias = true } )

surface.CreateFont( "TargetIDTextSmall", { font = "Impact", size = 20, weight = 500, antialias = true } )



local DrawnPlayerNames = {}

local DrawPlayerNamesFor = 2 -- 2 seconds

local DrawPlayerDist = 500



local function GetValidPlayer( ent )



	if not IsValid( ent ) or ent:GetNoDraw() or ent:GetColor().a == 0 then return end



	local ply = nil



	-- Get normal player

	if ent:IsPlayer() and ent.Name then

		ply = ent

	end



	-- Get vehicle owner players

	if ent:IsVehicle() then

		local owner = ent:GetOwner()

		if IsValid( owner ) && owner:IsPlayer() and owner.Name then

			ply = owner

		end

	end



	return ply



end



function GM:HUDDrawPlayerName( ply, fade, remain )


	if not IsValid( ply ) then return end



	local text = "ERROR"

	local font = "TargetIDText"

	local opacity = 1



	-- Fade based on distance

	if fade then



		local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )

		if ( !LocalPlayer():GetPos():WithinDistance( ply:GetPos(), DrawPlayerDist ) ) then return end // no need to draw anything if the player is far away

		opacity = math.Fit( dist, 100, DrawPlayerDist, 1, 0 )



	end



	-- Fade based on time

	if remain then

		opacity = 1-remain

	end



	-- Get player name

	text = ply:Name()



	-- Get position


	local pos = GetCenterPos( ply )
	
	if ply.MonorailModel then
		pos = GetCenterPos( ply.MonorailModel )
	end

	pos = pos:ToScreen()



	-- Append AFK

	/*if ply:GetNet("AFK") then

		text = "*AFK* " .. text

	end
*/


	-- Draw text shadow

	draw.SimpleText( text, font, pos.x+1, pos.y+1, Color( 0, 0, 0, 120 * opacity ), TEXT_ALIGN_CENTER )

	draw.SimpleText( text, font, pos.x+2, pos.y+2, Color( 0, 0, 0, 50 * opacity ), TEXT_ALIGN_CENTER )



	-- Get color

	local color = Color( 255, 255, 255 )

	color = ply:GetDisplayTextColor() -- Get display color

	local realcolor = Color( color.r, color.g, color.b, color.a * opacity )



	-- Draw name

	draw.SimpleText( text, font, pos.x, pos.y, realcolor, TEXT_ALIGN_CENTER )



	-- Lobby HUD

	if string.StartWith(game.GetMap(),"gmt_lobby") then



		-- Show Rank

		local respect = ply:GetTitle()

		if respect then

			draw.SimpleText( respect, "TargetIDTextSmall", pos.x, pos.y + 28, realcolor, TEXT_ALIGN_CENTER )

		end



		-- Room number

		if !ply.GRoomId then return end

		local roomid = ply.GRoomId

		if roomid && roomid > 0 then

			local room = tostring( roomid ) or ""

			if room != "" then

				local dark = colorutil.Brighten( realcolor, .75 )

				surface.SetDrawColor( dark )

				surface.DrawRect( pos.x - 40, pos.y + 28 + 20, 80, 2 )

				draw.SimpleText( "CONDO " .. room, "TargetIDTextSmall", pos.x, pos.y + 28 + 20, dark, TEXT_ALIGN_CENTER )

			end

		end



	end



end



local function AddNewPlayerToDraw( ply )



	local add = true

	for id, plyname in pairs( DrawnPlayerNames ) do

		-- Update existing player name

		if plyname.ply == ply then

			plyname.time = RealTime()

			add = false

		end

	end



	if add then

		table.insert( DrawnPlayerNames, { ply = ply, time = RealTime() } )

	end



end



function GM:HUDDrawTargetID()


	-- Hide while the camera is out

	if LocalPlayer():IsCameraOut() then return end



	-- Draw all player names when Q is held

	if input.IsButtonDown( KEY_Q ) then

		if string.StartWith(game.GetMap(),"gmt_lobby") then

			for _, ent in pairs( ents.GetAll() ) do

				local ply = GetValidPlayer( ent )

				if ply == LocalPlayer() or not ply then continue end

				self:HUDDrawPlayerName( ply, true )

			end

		end

	end



	-- Draw recently rolled over players

	if DrawnPlayerNames then

		for id, plyname in pairs( DrawnPlayerNames ) do



			-- Auto remove name

			if plyname.duration and plyname.duration >= 1 then

				table.remove( DrawnPlayerNames, id )

				continue

			end



			-- Draw the name

			if plyname.time then

				plyname.duration = math.min( RealTime() - plyname.time, DrawPlayerNamesFor ) / DrawPlayerNamesFor

			end



			self:HUDDrawPlayerName( plyname.ply, false, plyname.duration )



		end

	end



	-- Add new player to draw name tag of

	local tr = util.GetPlayerTrace( LocalPlayer(), GetMouseAimVector() )

	local trace = util.TraceLine( tr )

	if (!trace.Hit) then return end

	if (!trace.HitNonWorld) then return end



	local ply = GetValidPlayer( trace.Entity )

	if ply and ply != LocalPlayer() then

		AddNewPlayerToDraw( ply )

	end



	-- Get mouse position

	--[[local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then

		MouseX = ScrW() / 2

		MouseY = ScrH() / 2

	end]]



end

hook.Add("HUDWeaponPickedUp", "FixRareBug", function( wep )
	if !wep.GetPrintName then
		return true
	end
end )

function GM:AllowModel( ply, model )
	return GTowerModels.AdminModels[ model ] == nil
end

local scrw, scrh = ScrW(), ScrH()
local rtw, rth = 0, 0

function GM:ShouldDrawLocalPlayer()
	if (rtw == 0 || rth == 0) && (ScrW() < scrw && ScrH() < scrh) then
		rtw = ScrW()
		rth = ScrH()
	end

	if ScrW() == rtw && ScrH() == rth && render.GetRenderTarget():GetName() == "_rt_waterreflection" then
		return true
	end
end

concommand.Add("gmt_printminres", function()
	Msg("Minimun found size: ", rtw, "/", rth, "\n")
end )


hook.Add( "CalcView", "FullyConnected", function()
	hook.Remove( "CalcView", "FullyConnected" )
	
	net.Start( "ClientFullyConnected" )
	net.SendToServer()
end )

VoiceEnable = CreateConVar( "gmt_voice_enable", 1, nil, nil, 0, 1 )
hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
	if !VoiceEnable:GetBool() then return false end
end )