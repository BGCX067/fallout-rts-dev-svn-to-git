include("shared.lua")

function ENT:Initialize()
	self.ent1 = ClientsideModel("models/clutter/scrapmetal.mdl", RENDERGROUP_OPAQUE)
	self.ent1:SetPos(self:GetPos() + Vector(0, 0, 0))
	self.ent1:SetModelScale(Vector(5, 5, 5))
	self.ent1:SetParent(self)
	
	/*self.ent2 = ClientsideModel("models/clutter/toolbox.mdl", RENDERGROUP_OPAQUE)
	self.ent2:SetPos(self:GetPos() + Vector(-25, -25, 0))
	self.ent2:SetAngles(Angle(0, -45, 0))
	self.ent2:SetModelScale(Vector(2, 2, 2))
	self.ent2:SetParent(self)*/
end

function ENT:Draw()
end