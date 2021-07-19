AddCSLuaFile("cl_init.lua")

// Experimental multi core options to increase FPS in Lobby 2.
//===========================================================

MCoreCommands = {
  [1] = {"gmod_mcore_test", "1"},
  [2] = {"mat_queue_mode", "-1"},
  [3] = {"cl_threaded_bone_setup", "1"},
}

hook.Add( "PlayerInitialSpawn", "ApplyMCores", function( ply )

  // Runs all MCore commands on the player when they join.

  if (ply:GetInfo("gmt_usemcore") or "1") != "1" then return end

  for _, cmd in pairs( MCoreCommands ) do
    ply:SendLua( [[RunConsoleCommand("]] .. cmd[1] .. [[","]] .. cmd[2] .. [[")]] )
  end

end )

hook.Add( "Location", "ResetMQueueClub", function( ply, new, old )

  if (ply:GetInfo("gmt_usemcore") or "1") != "1" then return end

  // mat_queue_mode breaks the Nightclub lights, reset them.

  // Disable when they enter the club
  if Location.IsNightclub(new) then
    ply.NightClubMCore = true
    ply:SendLua( [[RunConsoleCommand("mat_queue_mode","1")]] )
  end

  // Enable when they leave the club
  if new != 25 and new != 26 and ply.NightClubMCore then
    ply:SendLua( [[RunConsoleCommand("mat_queue_mode","-1")]] )
    ply.NightClubMCore = false
  end

end )
