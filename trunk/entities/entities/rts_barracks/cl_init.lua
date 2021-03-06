include("shared.lua")

function ENT:Initialize()
	self.NextTick = CurTime()

	self.ent1 = ClientsideModel("models/llama/sniper.mdl", RENDERGROUP_OPAQUE)
	self.ent1:SetPos(self:GetPos() + Vector(0, 0, 160))
	self.ent1:SetAngles(Angle(0, 0, 90))
	self.ent1:SetModelScale(Vector(2, 2, 2))
	self.ent1:SetParent(self)
	
	self.ent2 = ClientsideModel("models/NewVegasProps/stripwall.mdl", RENDERGROUP_OPAQUE)
	self.ent2:SetPos(self:GetPos() + Vector(40, 40, 0))
	self.ent2:SetParent(self)
	
	self.ent3 = ClientsideModel("models/NewVegasProps/stripwall.mdl", RENDERGROUP_OPAQUE)
	self.ent3:SetPos(self:GetPos() + Vector(40, -40, 0))
	self.ent3:SetAngles(Angle(0, -90, 0))
	self.ent3:SetParent(self)
	
	self.ent4 = ClientsideModel("models/NewVegasProps/stripwall.mdl", RENDERGROUP_OPAQUE)
	self.ent4:SetPos(self:GetPos() + Vector(-40, -40, 0))
	self.ent4:SetAngles(Angle(0, -180, 0))
	self.ent4:SetParent(self)
	
	self.ent5 = ClientsideModel("models/NewVegasProps/stripwall.mdl", RENDERGROUP_OPAQUE)
	self.ent5:SetPos(self:GetPos() + Vector(-40, 40, 0))
	self.ent5:SetAngles(Angle(0, 90, 0))
	self.ent5:SetParent(self)
	
	self.ent6 = ClientsideModel("models/llama/locker03.mdl", RENDERGROUP_OPAQUE)
	self.ent6:SetPos(self:GetPos() + Vector(100, 100, 0))
	self.ent6:SetAngles(Angle(0, 45, 0))
	self.ent6:SetParent(self)
	
	self.ent7 = ClientsideModel("models/llama/enclavebed.mdl", RENDERGROUP_OPAQUE)
	self.ent7:SetPos(self:GetPos() + Vector(50, 150, 15))
	self.ent7:SetModelScale(Vector(0.7, 0.7, 0.7))
	self.ent7:SetAngles(Angle(0, 255, 0))
	self.ent7:SetParent(self)
end

function ENT:Draw()
end

function ENT:Think()
	if CurTime() >= self.NextTick then
		self.ent1:SetAngles(self.ent1:GetAngles() + Angle(0, 2, 0))
		self.ent1:SetPos(self.ent1:GetPos() + Vector(0, 0, 0.25) * math.sin(CurTime()))
		self.NextTick = CurTime() + 0.01
	end
end