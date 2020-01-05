AddCSLuaFile()

SWEP.Author = "Prize"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Revolver"
SWEP.Instructions = [[Help kill the demons]]

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.SetHoldType = "revolver"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false


SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.Primary.AutoReload = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ShouldDropOnDie = true 

local ShootSound = Sound("weapons/357/357_fire2.wav")

function SWEP:Initialize()

    self:SetHoldType( "revolver" )

end

function SWEP:Deploy()

    if not self:CanPrimaryAttack() then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end

end

function SWEP:PrimaryAttack()

    local ply = self:GetOwner()
    ply:SetAmmo(1, "357")
    
    if( not self:CanPrimaryAttack() ) then return end

    ply:LagCompensation(true)

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
    self:SetNextPrimaryFire(CurTime() + 0.6)
    self:TakePrimaryAmmo( 1 )
    ply:SetAmmo(1, "357")

    ply:LagCompensation(false)

end

function SWEP:CanSecondaryAttack()
    return false
end