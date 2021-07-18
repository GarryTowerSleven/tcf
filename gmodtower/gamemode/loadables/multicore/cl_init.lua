
cvars.AddChangeCallback( "gmt_usemcore", function( convar_name, value_old, value_new )

  local ply = LocalPlayer()

	if value_new == "1" then
    RunConsoleCommand("gmod_mcore_test","1")

    if ply:Location() != 27 and ply:Location() != 26 then
      RunConsoleCommand("mat_queue_mode","-1")
    end

    RunConsoleCommand("cl_threaded_bone_setup","1")
  else
    RunConsoleCommand("gmod_mcore_test","0")
    RunConsoleCommand("mat_queue_mode","1")
    RunConsoleCommand("cl_threaded_bone_setup","0")
  end
end )
