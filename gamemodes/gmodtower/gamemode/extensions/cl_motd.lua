module( "motd", package.seeall )

Browser = nil
CloseButton = nil
CloseIn = 0 -- Time until they can close it

LocalFilename = "gmtower/motd_L2ST.txt"
Seen = false

local function LoadSeen()

	local f = file.Exists(LocalFilename, "DATA")
	if f then Seen = true end

end

function SaveSeen()

	-- Save to local data
	file.CreateDir( "gmtower" )
	file.Write( LocalFilename, "1" )

end

function CanClose()
	return CurTime() > CloseIn
end

function GetElapsedString()
	local elapsed = CloseIn - CurTime()
	if elapsed <= 0 then return 0 end

	return "PLEASE TAKE A MOMENT... " .. math.ceil( elapsed ) .. ""
end

function OpenMOTD( URL, title, time )

	LoadSeen()
	if Seen then return end -- Don't do anything
	SaveSeen() -- They've seen it!
	
	if !IsValid( Browser ) then
		Browser = vgui.Create( "HTML" )
		Browser:SetSize( ScrW(), ScrH() - 58 )
	end

	CloseButton = vgui.Create( "DButton" )
	CloseButton:SetPos( 0, ScrH() - 58 )
	CloseButton:SetSize( ScrW(), 58 )
	CloseButton:SetEnabled( false )
	CloseButton:CenterHorizontal()
	CloseButton:SetFont( "GTowermidbold" )
	CloseButton:SetText( GetElapsedString() )

	CloseButton.Think = function()
		CloseButton:SetText( GetElapsedString() )

		if GetElapsedString() == 0 then
			CloseButton:SetText( "CLOSE. WE WON'T BOTHER YOU AGAIN WITH THIS." )
			CloseButton:SetEnabled( true )
		end
	end
	CloseButton.DoClick = function(self)
		if CanClose() then
			Close()
		end
	end
	--end
		
	Browser:SetPaintedManually( false )
	Browser:SetPos( 0, 0 )
	Browser:OpenURL( URL )
	Browser:MakePopup()

	//CloseIn = CurTime() + (time or 30)
	CloseIn = 0

end

function Close()

	if IsValid( Browser ) then
		Browser:Remove()
	end

	if IsValid( CloseButton ) then
		CloseButton:Remove()
	end

end


/*hook.Add( "PlayerSpawnClient", "MOTDPlayerCreated", function(ply)
	if not ply:IsPlayer() then return end 
	if IsLobby then
		OpenMOTD( "http://www.towerunite.com", "Tower Unite" )
	end
end )*/