AddCSLuaFile()

SWEP.Author = "Prize"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Clock Maker"
SWEP.Instructions = [[Make new clocks]]

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
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

function SWEP:CanPrimaryAttack()

    if CLIENT then return end


    ply = self:GetOwner()

    local tr = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 999999999,
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    local clock = ents.Create("demonclock")
    clock:SetPos(tr.HitPos + tr.HitNormal * 1.5)
    clock:SetAngles(tr.HitNormal:Angle())
    clock:Spawn()

end
