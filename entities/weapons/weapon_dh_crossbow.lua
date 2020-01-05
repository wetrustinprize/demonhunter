AddCSLuaFile()

SWEP.Author = "Prize"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Crossbow"
SWEP.Instructions = [[Insta-kill the demon.
Or create new ones.]]

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.SetHoldType = "crossbow"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true


SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 999
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.Primary.AutoReload = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ShouldDropOnDie = true 

local ShootSound = Sound("weapons/crossbow/fire1.wav")
local ReloadSound = Sound("weapons/crossbow/reload1.wav")

function SWEP:Initialize()

    self:SetHoldType( "crossbow" )

end

function SWEP:Deploy()

    if not self:CanPrimaryAttack() then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end

end

function SWEP:PrimaryAttack()

    local ply = self:GetOwner()

    ply:LagCompensation(true)

    ply:SetAmmo(1, "XBowBolt")
    if( not self:CanPrimaryAttack() ) then return end

    local Bullet = {}
        Bullet.Num = self.Primary.NumShots
        Bullet.Src = ply:GetShootPos()
        Bullet.Dir = ply:GetAimVector()
        Bullet.AmmoType = self.Primary.Ammo
        Bullet.Damage = self.Primary.Damage
        Bullet.Attacker = ply
        
    self:ShootEffects()
    self:FireBullets(Bullet)
    
    self:EmitSound(ShootSound)
    self:TakePrimaryAmmo( 1 )

    ply:SetAmmo(1, "XBowBolt")

    ply:LagCompensation(false)

end

function SWEP:CanSecondaryAttack()
    return false
end