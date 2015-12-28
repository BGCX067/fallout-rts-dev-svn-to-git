AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube2x2x2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(0, 0, 0, 255)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetNWString("name", "Barracks")
	self:SetNWInt("maxhealth", 1000)
	self:SetNWInt("health", 1000)
	self:SetNWInt("maxarmor", 1000)
	self:SetNWInt("armor", 1000)
	
	self.NextTick = CurTime()
end