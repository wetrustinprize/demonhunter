AddCSLuaFile()

SWEP.Author = "Prize"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Sacrifice Knife"
SWEP.Instructions = [[Insta-kill everyone.]]

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.SetHoldType = "knife"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

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

local AttackAnimationsNow = 0

local SwingSound = Sound("weapons/knife/knife_slash1.wav")

local HitSound = { 
    Sound("weapons/knife/knife_hit1.wav"),
    Sound("weapons/knife/knife_hit2.wav"),
    Sound("weapons/knife/knife_hit3.wav"),
    Sound("weapons/knife/knife_hit4.wav")
}

local HitPlayerSound = Sound("weapons/knife/knife_stab.wav")
local HitNotPlayerSound = Sound("weapons/knife/knife_hitwall1.wav")

function SWEP:Initialize()

    self:SetHoldType("knife")

end

function SWEP:Deploy()

    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

end

function SWEP:PrimaryAttack()

    if CLIENT then return end

    local ply = self:GetOwner()
    local vm = self.Owner:GetViewModel()

    ply:LagCompensation(true)

    local shootpos = ply:GetShootPos()
    local endshootpos = shootpos + ply:GetAimVector() * 50
    local tmin = Vector(1, 1, 1) * -10
    local tmax = Vector(1, 1, 1) * 10

    local tr = util.TraceHull( {
        start = shootpos,
        endpos = endshootpos,
        filter = ply,
        mask = MASK_SHOT_HULL,
        mins = tmin,
        maxs = tmax
    })

    if not IsValid(tr.Entity) then
        tr = util.TraceLine({
            start = shootpos,
            endpos = endshootpos,
            filter = ply,
            mask = MASK_SHOT_HULL
        })
    end

    local ent = tr.Entity

    if AttackAnimationsNow == 0 then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("midslash1"))
        AttackAnimationsNow = 1
    else
        vm:SendViewModelMatchingSequence(vm:LookupSequence("midslash2"))
        AttackAnimationsNow = 0
    end
    ply:SetAnimation( PLAYER_ATTACK1 )

    local dmg = DamageInfo()
    dmg:SetDamage(999)
    dmg:SetAttacker(ply)
    dmg:SetInflictor(self.Weapon)
    dmg:SetDamageForce(self.Owner:GetAimVector() * 100)
    dmg:SetDamagePosition(tr.HitPos)
    dmg:SetDamageType(DMG_SLASH)

    if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then

        ply:EmitSound(HitPlayerSound)
        ent:DispatchTraceAttack(dmg, tr)

    elseif tr.Hit then
        util.Decal("ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
        ply:EmitSound(HitNotPlayerSound)
        ent:DispatchTraceAttack(dmg, tr)
    else
        ply:EmitSound(SwingSound)
    end

    self:SetNextPrimaryFire(CurTime() + 0.5)

    ply:LagCompensation(false)

end

function SWEP:Reload()

    local vm = self.Owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("idle"))

end

function SWEP:SecondaryAttack()

    return 

end
