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
	
	self:SetNWString("name", "Command Center")
	self:SetNWInt("maxhealth", 2500)
	self:SetNWInt("health", 2500)
	self:SetNWInt("maxarmor", 2500)
	self:SetNWInt("armor", 2500)
	self:SetNWInt("maxenergy", 500)
	self:SetNWInt("energy", 500)
	self:SetNWInt("collectionRate", 1)
	
	self.NextTick = CurTime()
end

function ENT:Think()
	if CurTime() >= self.NextTick && self:GetNWInt("team") then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
			if v:GetClass() == "rts_scrapyard" then
				if (v:GetNWInt("scrap") >= v:GetNWInt("scrapPerTick") * self:GetNWInt("collectionRate")) then
					SetScrap(RESOURCES[self:GetNWInt("team")].Scrap + v:GetNWInt("scrapPerTick") * self:GetNWInt("collectionRate"), self:GetNWInt("team"))
					v:SetNWInt("scrap", v:GetNWInt("scrap") - v:GetNWInt("scrapPerTick") * self:GetNWInt("collectionRate"))
				else
					SetScrap(RESOURCES[self:GetNWInt("team")].Scrap + v:GetNWInt("scrap"), self:GetNWInt("team"))
					v:SetNWInt("scrap", 0)
					v:Remove()
				end
			end
		end
		
		self.NextTick = CurTime() + 10
	end
end