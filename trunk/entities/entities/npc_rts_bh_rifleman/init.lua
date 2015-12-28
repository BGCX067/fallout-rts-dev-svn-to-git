AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/fallout_3/power_armor_admin.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN)
	
	self:Give("weapon_ak47")
	self:SetHealth(100)
	
	self:SetNWInt("maxhealth", 100)
	self:SetNWInt("health", 100)
	self:SetNWInt("maxarmor", 100)
	self:SetNWInt("armor", 100)
	self:SetNWInt("maxenergy", 0)
	self:SetNWInt("energy", 0)
	self:SetNWString("name", self.PrintName)
	self.Attacking = false
	self.NextAttack = 0
	self.NextTrackingUpdate = CurTime()
end