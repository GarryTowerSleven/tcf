function StartSong(ent,song,title,artist,duration)
	if IsValid(ent.stream) then
		ent.stream:Stop()
		ent.title,ent.artist,ent.dur,ent.url = nil
	end
	sound.PlayURL ( song, "3d", function( station )
		if ( IsValid( station ) ) then
			
			ent.title = (title || song)
			ent.artist = (artist || "Not Available")
			ent.dur = (duration || "Not Available")
			ent.url = song
			ent.stream = station
			
			if (ent.duration == 0 || ent.duration == "Not Available") then
				return
			else
				station:SetPos( LocalPlayer():GetPos(), Vector(0,0,0) )
				station:Play()
				timer.Simple( ent.dur, function() station:Stop() ent.title,ent.artist,ent.dur,ent.url = nil end )
			end

		else

			LocalPlayer():ChatPrint( "Invalid URL!" )

		end
	end )
end

function PlaySong(ent,song)
	http.Fetch(
	string.format("http://gbr.ddns.net/ayy/musicshiz.php?url=%s",
		song
	),
	function(body)
		local body = util.JSONToTable(body)
		local title = body.song_title
		local artist = body.song_artist
		local duration = body.song_runtime
		StartSong(ent,song,title,artist,duration)
	end,
	function(code)
		//error(string.format("FamilySharing: Failed API call for %s | %s (Error: %s)\n", ply:Nick(), ply:SteamID(), code))
	end
	)
end

function RadioInput(ent)
	Derma_StringRequest(
		"Test Radio",
		"Input the string to print to console",
		"",
		function( text ) PlaySong(ent,text) end,
		function( text ) print( "Cancelled input" ) end
	 )
end

net.Receive( "RadioTestThing", function( len, pl )
	RadioInput(net.ReadEntity())
end )