AddCSLuaFile( "shared.lua" )

SWEP.Contact 		= ""
SWEP.Author			= "ErrolLiamP and QuentinDylanP"
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.ViewModelFOV 	= 70
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType = "none"

SWEP.FiresUnderwater = true
SWEP.Primary.Damage         = 50
SWEP.base					= "crowbar"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay = 0.5

SWEP.Weight				= 1
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Category			= "Five Nights at Freddy's 4"
SWEP.PrintName			= "NMS"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
 
function SWEP:Think()
end

function SWEP:Initialize()
		self.ScareNoises = {
		Sound("fnaf4/breathing1.wav"),
		Sound("fnaf4/breathing2.wav"),
		Sound("fnaf4/breathing3.wav"),
		Sound("fnaf4/breathing4.wav")}
		self:SetWeaponHoldType( "none" )
end

function SWEP:PrimaryAttack()
	--if self.Owner:WaterLevel() > 0 or not self:CanPrimaryAttack() then return end
	--self:TakePrimaryAmmo(0)

	local tr = util.TraceLine { 
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 500,
		filter = self.Owner
	}
	
	if !IsValid(tr.Entity) then
	self:EmitSound("nms/nms.wav", 100, math.random(100, 100)) end
	
	if SERVER then
		if IsValid(tr.Entity) then
			tr.Entity:Fire("sethealth", "" ..tr.Entity:Health() - 9999999 .."", 0)
			tr.Entity:EmitSound("nms/nms.wav")
			if tr.Entity:IsNPC() then return end
			if tr.Entity:IsPlayer() then
			-----------------------------------
			tr.Entity:ConCommand( "pp_mat_overlay overlays/nms/nms" )
			timer.Create( "Hide Jumpscare", 2, 1, function()
			if !IsValid(self) then return end
			if !IsValid(tr.Entity) then return end
			tr.Entity:ConCommand( "pp_mat_overlay overlays/fivenights_bleed_out/bleed_out" )
			end)
			timer.Create( "Hide Bleed Out", 3, 1, function()
			if !IsValid(tr.Entity) then return end
			tr.Entity:ConCommand( "pp_mat_overlay  " )
			end)
			-----------------------------------	
			end
		end
		else
	end
	
	self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
self:EmitSound(self.ScareNoises[math.random(#self.ScareNoises)])
self:SetNextSecondaryFire(CurTime() + 5)
end

function SWEP:Deploy()
self:EmitSound("", 100, 100)
return true;
end

function SWEP:Holster()
return true;
end