include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
SetupBrowser( ENT, 720, 480 )

usermessage.Hook( "StartGame", function( um )

	local ent = um:ReadEntity()
	local game = ent.GameIDs[ ent:GetSkin() + ( ent.StartId or 1 ) ] or "Patapon"
	ent:DisplayControls( game .. " - Powered by Ruffle", GAMEMODE.WebsiteUrl .. "arcade/?flash=" .. game /*, function() net.Start( "LeaveArcade" ) net.SendToServer() end*/ )

end )

function ENT:MouseThink() end
function ENT:DrawBrowser() end

/*local GameIDS = ENT.GameIDs

usermessage.Hook( "ArcJunkie", function(um)

	local Count = um:ReadChar()
	local Names = {}
	
	Msg("You still need to complete:\n")
	
	for i=1, Count do
		
		local Id = um:ReadChar()
		
		Msg( "\t" .. i .. ". " .. GameIDS[ Id ] .. "\n")
	end

end )*/