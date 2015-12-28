ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName		= "RTS NPC Base"
ENT.Author			= "kopimi"
ENT.Contact			= "regan.flow@gmail.com"
ENT.Purpose			= "Use in RTS gamemodes."
ENT.Instructions	= ""

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end