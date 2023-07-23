hook.Add("PlayerBindPress", "a", function(_, b)
    if b == "gmod_undo" then
        net.Start("Taunt")
        net.SendToServer()
    end
end)