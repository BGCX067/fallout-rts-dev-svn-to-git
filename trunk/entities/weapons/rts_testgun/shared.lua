SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if ValidEntity(tr.Entity) && tr.Entity:IsNPC() then
		if ValidEntity(self.Target) then
			self.Target:SetColor(255, 255, 255, 255)
		end
		
		self.Target = tr.Entity
		self.Target:SetColor(0, 255, 0, 255)
	end
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if tr.Hit && ValidEntity(self.Target) then
		if ValidEntity(tr.Entity) && tr.Entity:IsNPC() then
			self.Target:AttackEntity(tr.Entity)
		else
			self.Target:MoveToVector(tr.HitPos)
		end
	end
end