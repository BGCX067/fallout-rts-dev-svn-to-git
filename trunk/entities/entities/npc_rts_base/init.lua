AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

RTS_CMD_MOVE = ai_schedule.New("RTS_Move")
RTS_CMD_MOVE:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
RTS_CMD_MOVE:EngTask("TASK_RUN_PATH", 0)

RTS_CMD_ATTACK = ai_schedule.New("RTS_Attack")
RTS_CMD_ATTACK:EngTask("TASK_STOP_MOVING", 0)

function ENT:Initialize()
	self:SetModel("models/Humans/Group03/male_07.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN)
	
	self:Give("weapon_ak47")
	
	self:SetNWInt("maxhealth", 100)
	self:SetNWInt("health", 100)
	self:SetNWInt("maxarmor", 0)
	self:SetNWInt("armor", 0)
	self:SetNWInt("maxenergy", 0)
	self:SetNWInt("energy", 0)
	self:SetNWString("name", "RTS NPC")
	self.Attacking = false
	self.NextAttack = 0
	self.NextTrackingUpdate = CurTime()
end

function ENT:MoveToVector(pos)
	self.Attacking = false
	self:SetLastPosition(pos)
	self:StartSchedule(RTS_CMD_MOVE)
end

function ENT:AttackEntity(ent)
	if !ValidEntity(ent) || ent == self then return end
	
	local ang = self:GetAngles()
	ang.y = ((ent:GetPos() - self:GetPos()):Angle()).y
	
	self:StartSchedule(RTS_CMD_ATTACK)
	self:SetEnemy(ent)
	self:SetAngles(ang)
	
	self.Attacking = true
end

function ENT:OnTakeDamage(dmg)
	local amt = dmg:GetDamage()

	if self:GetNWInt("armor") > 0 then
		if self:GetNWInt("armor") > amt then
			self:SetNWInt("armor", self:GetNWInt("armor") - amt)
		else
			amt = amt - self:GetNWInt("armor")
			self:SetNWInt("armor", 0)
		end
	end
	
	if self:GetNWInt("armor") <= 0 then
		self:SetNWInt("health", self:GetNWInt("health") - amt)
	end
	
	if self:GetNWInt("health") <= 0 then
		self:SetNPCState(NPC_STATE_DEAD)
		self:SetSchedule(SCHED_DIE_RAGDOLL)
	end
end

function ENT:Think()
	if self.Attacking then
		if CurTime() >= self.NextAttack then
			if CurTime() >= self.NextTrackingUpdate then
				local ang = self:GetAngles()
				ang.y = ((self:GetEnemy():GetPos() - self:GetPos()):Angle()).y
				self:SetAngles(ang)
				
				self.NextTrackingUpdate = CurTime() + 0.5
			end
		
			if ValidEntity(self:GetEnemy()) && self:GetEnemy():GetNPCState() != NPC_STATE_DEAD then
				local bullet = {}
				bullet.Src			= self:GetShootPos()
				bullet.Attacker		= self
				bullet.Dir			= (self:GetEnemy():LocalToWorld(self:GetEnemy():OBBCenter()) - self:LocalToWorld(self:OBBCenter())):Normalize()
				bullet.Spread		= self:GetActiveWeapon().Primary.Spread
				bullet.Num			= self:GetActiveWeapon().Primary.NumberofShots
				bullet.Damage		= self:GetActiveWeapon().Primary.Damage
				bullet.Force		= 1
				bullet.Tracer		= 1
				bullet.TracerName	= "Tracer"
				self:FireBullets(bullet)
				self:EmitSound(self:GetActiveWeapon().Primary.Sound)
				self:GetEnemy():TakeDamage(bullet.Damage, self, self)
				
				self.NextAttack = CurTime() + self:GetActiveWeapon().Primary.Delay
			else
				self.Attacking = false
			end
		end
	end
end

function ENT:SelectSchedule()
	//eh fuck off, i'm on break
end