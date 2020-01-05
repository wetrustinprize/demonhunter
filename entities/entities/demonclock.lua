AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Demon Hunter Clock"
ENT.Spawnable = true

local clockbell = Sound("demonhunters/clock/bell.wav")

if CLIENT then

    tex_minutes = Material("demonhunters/clock/clock_minutespointer.png", "noclamp")
    tex_hours = Material("demonhunters/clock/clock_hourspointer.png", "noclamp")
    tex_clock = Material("demonhunters/clock/clock.png", "noclamp")
    tex_penta = Material("demonhunters/clock/clock_penta.png", "noclamp")

    minute_rot = 0
    hour_rot = 0
    clock_rot = 0
    old_clock_rot = 0

    danger_alpha = 0

end

function ENT:Initialize()

    if SERVER then

        self:SetModel("models/props_trainstation/trainstation_clock001.mdl")
        self:PhysicsInit(SOLID_BBOX)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_NONE)

        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            
            phys:Wake()

        end
    
    end

end

function ENT:SetupDataTables()

    self:NetworkVar("float", 0, "TimerPercentage")

end


function ENT:Draw()

    if SERVER then return end

    old_clock_rot = self:GetNWFloat("TimerPercentage")
    if old_clock_rot != clock_rot then
        clock_rot = old_clock_rot
        if clock_rot >= 1 then
            self:EmitSound(clockbell, 100)
        end
    end

    local forward = self:GetAngles():Forward()

    minute_rot = Lerp(1/100, minute_rot, 360 * clock_rot * 12)
    hour_rot = Lerp(1/10, hour_rot, 360 * clock_rot)
    
    if clock_rot == 1 then
        danger_alpha = Lerp(1/100, danger_alpha, 255)
    else
        danger_alpha = Lerp(1/10, danger_alpha, 0)
    end

    self:DrawModel()

    render.SetMaterial(tex_clock)
    render.DrawQuadEasy(self:GetPos() + forward * 0.1, forward, 55, 55, Color(125,0,0, danger_alpha), 180)

    render.SetMaterial(tex_penta)
    render.DrawQuadEasy(self:GetPos() + forward * 0.1, forward, 55 + 5 * ((math.sin(CurTime()) + 1) / 2), 55 + 5 * ((math.sin(CurTime()) + 1) / 2), Color(125,0,0, danger_alpha * ((math.sin(CurTime()) + 1) / 2)), 180)

    render.SetMaterial(tex_minutes)
    render.DrawQuadEasy(self:GetPos() + forward * 0.5, forward, 55, 55, Color(255,255,255,255 - danger_alpha), 180 - minute_rot)

    render.SetMaterial(tex_hours)
    render.DrawQuadEasy(self:GetPos() + forward * 0.5, forward, 55, 55, Color(255,255,255,255 - danger_alpha), 180 - hour_rot)

end