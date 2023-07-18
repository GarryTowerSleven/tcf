if SERVER then

	AddCSLuaFile( "shared.lua" )

	util.AddNetworkString( "SlapAnimation" )

end

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

SWEP.PrintName	= "Slappers"
SWEP.Slot		= 1
SWEP.SlotPos	= 0

SWEP.ViewModel	= Model("models/weapons/v_watch.mdl")
SWEP.WorldModel	= ""
SWEP.HoldType	= "normal"

SWEP.SlapForce = 200

SWEP.Primary = {
    ClipSize     = -1,
    Delay = 0.8,
    DefaultClip = -1,
    Automatic = false,
    Ammo = "none"
}

SWEP.Secondary = SWEP.Primary

SWEP._LastSlap = 0

SWEP.Sounds = {
	Miss = {
		clsound.Register("weapons/knife/knife_slash1.wav"),
		clsound.Register("weapons/knife/knife_slash2.wav"),
	},
	HitWorld = {
		clsound.Register("physics/plastic/plastic_box_impact_soft2.wav"),
		clsound.Register("physics/plastic/plastic_box_impact_soft3.wav"),
		clsound.Register("physics/plastic/plastic_box_impact_soft4.wav"),
	},
	Hurt = {
		clsound.Register("vo/npc/male01/ow01.wav"),
		clsound.Register("vo/npc/male01/ow02.wav"),
		clsound.Register("vo/npc/female01/ow01.wav"),
		clsound.Register("vo/npc/female01/ow02.wav"),
	},
	Slap = {
		clsound.Register("elevator/effects/slap_hit01.wav"),
		clsound.Register("elevator/effects/slap_hit02.wav"),
		clsound.Register("elevator/effects/slap_hit03.wav"),
		clsound.Register("elevator/effects/slap_hit04.wav"),
		clsound.Register("elevator/effects/slap_hit05.wav"),
		clsound.Register("elevator/effects/slap_hit06.wav"),
		clsound.Register("elevator/effects/slap_hit07.wav"),
		clsound.Register("elevator/effects/slap_hit08.wav"),
		clsound.Register("elevator/effects/slap_hit09.wav")
	}
}

SWEP.Mins = Vector(-8, -8, -8)
SWEP.Maxs = Vector(8, 8, 8)


/*
	Weapon Config
*/
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:DrawShadow(false)

	if CLIENT then
		self:SetupHands()
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:ShouldDropOnDie()
	return false
end


/*
	Slap Animation Reset
*/
if SERVER then
	function SWEP:Think()
		local vm = self:GetOwner():GetViewModel()
		if (self._LastSlap and self._LastSlap + .7 < CurTime()) and vm:GetSequence() != 0 then
			vm:ResetSequence(0)
		end
	end
end

/*
	Third Person Slap Hack
*/
function SWEP:SlapAnimation()

	-- Inform players of slap
	if SERVER then
		net.Start( "SlapAnimation" )
			net.WriteEntity(self:GetOwner())
		net.Broadcast()
	end

	-- Temporarily change hold type so that we
	-- can use the crowbar melee animation
	self:SetWeaponHoldType("melee")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	-- Change back to normal holdtype once we're done
	timer.Simple(0.3, function()
		if IsValid(self) then
			self:SetWeaponHoldType(self.HoldType)
		end
	end)

end

net.Receive( "SlapAnimation", function()

	-- Make sure the player is still valid
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end

	-- Make sure they're still using the slappers
	local weapon = ply:GetActiveWeapon()
	if !IsValid(weapon) or !weapon.SlapAnimation then return end

	-- Perform slap animation
	weapon:SlapAnimation()

end)


/*
	Slapping
*/
function SWEP:PrimaryAttack()

	-- Left handed slap
	self.ViewModelFlip = false

	self:Slap()

end

function SWEP:SecondaryAttack()

	-- Right handed slap
	self.ViewModelFlip = true

	self:Slap()

end

function SWEP:Slap()
	
	-- Broadcast third person slap
	self:SlapAnimation()
	
	-- Perform trace
	if SERVER then

		-- Use view model slap animation
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2)

		-- Trace for slap hit
		local tr = util.TraceHull({
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * 40),
			mins = self.Mins,
			maxs = self.Maxs,
			filter = self:GetOwner()
		})

		local ent = tr.Entity

		if IsValid(ent) or game.GetWorld() == ent then

			if ent:IsPlayer() or string.match( ent:GetClass(), "gmt_npc" ) then
				self:SlapPlayer(ent, tr)
			elseif ent:IsWorld() then
				self:SlapWorld()
			else
				self:SlapProp(ent, tr)
			end

		else
			self:GetOwner():EmitSoundInLocation( table.Random( self.Sounds.Miss ), 50 )
		end

	end

	local delay = (self:GetOwner().IsStaff && self:GetOwner():IsStaff()) && .5 or 3

	self._LastSlap = CurTime()
	
	self:SetNextPrimaryFire( CurTime() + delay )
	self:SetNextSecondaryFire( CurTime() + delay )

end

function SWEP:SlapPlayer(ply, tr)

	// local vec = (tr.HitPos - tr.StartPos):GetNormal()

	-- Emit hurt sound on player
	ply:EmitSoundInLocation(table.Random(self.Sounds.Hurt), 60 )

	-- Apply force to player
	// ply:SetLocalVelocity( vec * GetConVar("slappers_force"):GetInt() )

	-- Emit slap sound
	self:GetOwner():EmitSoundInLocation( table.Random(self.Sounds.Slap), 60 )

end

function SWEP:SlapWorld()

	self:GetOwner():EmitSoundInLocation( table.Random(self.Sounds.HitWorld), 60 )

end

function SWEP:SlapProp(ent, tr)

	local vec = (tr.HitPos - tr.StartPos):GetNormal()
	local emitSound = self.Sounds.HitWorld
	// local damage = math.random(10,13)

	if ent:GetClass() == "func_button" then
		ent:Input("Press", self:GetOwner(), self:GetOwner())	-- Press button
	elseif string.match(ent:GetClass(), "door") then
		ent:Input("Use", self:GetOwner(), self:GetOwner())	-- Open door
	/*elseif ent:Health() > 0 then

		if ent:Health() <= damage then
			ent:Fire("Break")
		else
			-- Damage props with health
			local dmginfo = DamageInfo()
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self:GetOwner())
			dmginfo:SetDamage(damage)
			ent:TakeDamageInfo(dmginfo)
		end*/

	end

	-- Apply force to prop
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		emitSound = table.Random(self.Sounds.Slap)
		phys:SetVelocity( phys:GetVelocity() + vec * self.SlapForce * math.Clamp( 100 / phys:GetMass(), 0, 1) )
	end

	-- Emit slap sound
	self:GetOwner():EmitSoundInLocation( emitSound, 90, 100 )

end

hook.Add( "PlayerCanPickupWeapon", "SlapCanPickup", function( ply, weapon )
	if weapon.CannotPickup and weapon.CannotPickup > CurTime() then
		return false
	end
end )

if CLIENT then

	local CvarAnimCam = CreateClientConVar("slappers_animated_camera", 0, true, false)
	
	SWEP.DrawCrosshair = false

	function SWEP:DrawHUD() end
	function SWEP:DrawWorldModel() end

	local function GetViewModelAttachment(attachment)
		local vm = LocalPlayer():GetViewModel()
		local attachID = vm:LookupAttachment(attachment)
		return vm:GetAttachment(attachID)
	end
	
	--[[-----------------------------------------
		CalcView override effect
		
		Uses attachment angles on view
		model for view angles
	-------------------------------------------]]
	function SWEP:CalcView( ply, origin, angles, fov )
		if CvarAnimCam:GetBool() and !IsValid(self:GetOwner():GetVehicle()) then -- don't alter calcview when in vehicle
			local attach = GetViewModelAttachment("attach_camera")
			if attach and self:GetNextPrimaryFire() > CurTime() then
				local angdiff = angles - (attach.Ang + Angle(0,0,-90))
				
				-- SUPER HACK
				if (self:GetNextPrimaryFire() > CurTime()) and angdiff.r > 179.9 then -- view is flipped
					angdiff.p = -(89 - angles.p) -- find pitch difference to stop at 89 degrees
				end
				
				angles = angles - angdiff
			end
		end
		
		return origin, angles, fov
	end

	--[[-----------------------------------------
		Allow slappers to use hand view model
	-----------------------------------------]]

	local CvarUseHands = CreateClientConVar("slappers_vm_hands", 1, true, false)
	local shouldHideVM = false
	local bonesToHide = {
		"ValveBiped.Bip01_L_UpperArm",
		"ValveBiped.Bip01_L_Clavicle",
		"ValveBiped.Bip01_R_UpperArm",
		"ValveBiped.Bip01_R_Clavicle",
	}
	local boneScale = vector_origin

	function SWEP:PreDrawViewModel( vm, ply, weapon )
		if shouldHideVM then
			shouldHideVM = false

			vm:SetMaterial("engine/occlusionproxy")
		end

		for _, bone in ipairs(bonesToHide) do
			local boneId = vm:LookupBone(bone)
			if not boneId then continue end
			vm:ManipulateBoneScale(boneId, boneScale)
		end
	end

	function SWEP:SetupHands()
		local useHands = CvarUseHands:GetBool()
		self.UseHands = useHands
		shouldHideVM = useHands
	end

	function SWEP:Holster()
		self:OnRemove()
		return true
	end

	function SWEP:OnRemove()
		if not IsValid(self:GetOwner()) then return end

		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then
			vm:SetMaterial("")
		end
	end
	
end