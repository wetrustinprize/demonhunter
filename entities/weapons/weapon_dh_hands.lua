AddCSLuaFile()

SWEP.Author = "Prize"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Hands"
SWEP.Instructions = [[You are pointless.]]

SWEP.ViewModel = ""
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = ""
SWEP.SetHoldType = "normal"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false


SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ShouldDropOnDie = true 

local ShootSound = Sound("weapons/357/357_fire2.wav")

function SWEP:Initialize()

    self:SetHoldType( "normal" )

end

function SWEP:PrimaryAttack()

    if CLIENT then return end

    local ply = self:GetOwner()

    ply:SelectWeapon("weapon_fists")

    return false

end

function SWEP:CanSecondaryAttack()
    return false
end