if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "gmt_money_bezier"

ENT.ModelString = Model( "models/gmt_money/one.mdl" )
ENT.MaterialOverride = "gmt_money/gmt_chip_blue"

ENT.Sound = Sound( "gmodtower/casino/chip.wav" )
ENT.SoundVolume = 60