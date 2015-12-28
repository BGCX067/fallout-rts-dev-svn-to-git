AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player.lua")
AddCSLuaFile("cl_chat.lua")
AddCSLuaFile("derma.lua")

include("shared.lua")
include("player.lua")

local SPAWN_POINTS = {}
SPAWN_POINTS["gm_construct"] = {}
SPAWN_POINTS["gm_construct"][TEAM_BROTHERHOOD]	= Vector(370, -600, -148)
SPAWN_POINTS["gm_construct"][TEAM_ENCLAVE]		= Vector(-1630, -345, -148)
SPAWN_POINTS["gm_construct"][TEAM_NCR]			= Vector(1445, 3240, -22)
SPAWN_POINTS["gm_construct"][TEAM_LEGION]		= Vector(-2500, 1650, -148)
SPAWN_POINTS["gm_atomic"] = {}
SPAWN_POINTS["gm_atomic"][TEAM_BROTHERHOOD]	= Vector(3448.6020507813, 2296.2609863281, -12276.517578125)
SPAWN_POINTS["gm_atomic"][TEAM_ENCLAVE]		= Vector(-4387.494140625, 1582.2045898438, -12245.211914063)
SPAWN_POINTS["gm_atomic"][TEAM_NCR]			= Vector(-8704.626953125, -2365.1174316406, -12260.788085938)
SPAWN_POINTS["gm_atomic"][TEAM_LEGION]		= Vector(1383.6268310547, -2206.94921875, -12222.129882813)

local SCRAP_POINTS = {}
SCRAP_POINTS["gm_construct"] = {
	Vector(610, -585, -148),
	Vector(605, -670, -148),
	Vector(555, -750, -148),
	Vector(500, -800, -148),
	Vector(420, -830, -148),
	Vector(-1715, -610, -148),
	Vector(-1835, -540, -148),
	Vector(-1900, -405, -148),
	Vector(-1915, -305, -148),
	Vector(-1845, -205, -148),
	Vector(1180, 3310, -22),
	Vector(1240, 3365, -22),
	Vector(1300, 3425, -22),
	Vector(1375, 3445, -22),
	Vector(1465, 3470, -22),
	Vector(-2270, 1835, -148),
	Vector(-2260, 1705, -148),
	Vector(-2280, 1590, -148),
	Vector(-2360, 1470, -148),
	Vector(-2490, 1405, -148)
}
SCRAP_POINTS["gm_atomic"] = {
	Vector(7122, 11254, -13934),
	Vector(-3813.8203125, -1937.6895751953, -10485.491210938),
	Vector(-3722.3347167969, -1856.8563232422, -10799.046875),
	Vector(-9744, -2520, -12261.700195313),
	Vector(-9496, -2158, -12257),
	Vector(1391.7965087891, -1934.4494628906, -12203.971679688),
	Vector(1469.7635498047, -1936.7791748047, -12203.18359375),
	Vector(1530.1688232422, -1956.0090332031, -12201.8984375),
	Vector(1572.5858154297, -1996.8428955078, -12199.606445313),
	Vector(1606.1942138672, -2051.939453125, -12196.866210938),
	Vector(-8841.056640625, -2213.62109375, -12231.991210938),
	Vector(-8792.6826171875, -2170.3112792969, -12231.271484375),
	Vector(-8705.72265625, -2134.2395019531, -12231.620117188),
	Vector(-8621.8955078125, -2154.2272949219, -12231.974609375),
	Vector(-4578.72265625, 1470.4791259766, -12214.184570313),
	Vector(-8559.9130859375, -2195.8598632813, -12231.985351563),
	Vector(-4612.8642578125, 1539.9610595703, -12213.967773438),
	Vector(-4609.1274414063, 1620.0107421875, -12213.977539063),
	Vector(-4569.1284179688, 1690.4954833984, -12213.913085938),
	Vector(-4521.1459960938, 1749.9635009766, -12215.698242188),
	Vector(3587.0456542969, 2132.8627929688, -12244.291015625),
	Vector(3516.5148925781, 2087.3786621094, -12245.068359375),
	Vector(3446.49609375, 2064.3212890625, -12245.942382813),
	Vector(3373.2026367188, 2079.5048828125, -12246.6953125),
	Vector(3310.5075683594, 2111.0302734375, -12246.950195313)
}


function InitPostEntity()
	timer.Simple(5, function()
		for k,v in pairs(SPAWN_POINTS[string.lower(game.GetMap())]) do
			local ent = ents.Create("rts_base")
			ent:SetNWInt("team", k)
			ent:SetPos(v)
			ent:Spawn()
		end
		
		for k,v in pairs(SCRAP_POINTS[string.lower(game.GetMap())]) do
			local ent = ents.Create("rts_scrapyard")
			ent:SetPos(v)
			ent:Spawn()
		end
	end)
end
hook.Add("InitPostEntity", "InitPostEntity", InitPostEntity)

function PlayerInitialSpawn(pl)
	timer.Simple(0, function()
		umsg.Start("OpenIntro", pl)
		umsg.End()
	end)
end
hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn", PlayerInitialSpawn)

function PlayerSpawn(pl)
	timer.Simple(0, function()
		pl:SetMoveType(MOVETYPE_NONE)
		
		if SPAWN_POINTS[string.lower(game.GetMap())][pl:Team()] then
			pl:SetPos(SPAWN_POINTS[string.lower(game.GetMap())][pl:Team()])
		end
	end)
end
hook.Add("PlayerSpawn", "PlayerSpawn", PlayerSpawn)

function GM:PlayerLoadout(pl)
end

function ChooseTeam(pl, cmd, args)
	if ValidEntity(pl) && args[1] then
		local teamID = tonumber(args[1])
		pl:SetTeam(teamID)
		pl:SetPos(SPAWN_POINTS[string.lower(game.GetMap())][pl:Team()])
		
		if RESOURCES[pl:Team()] then
			timer.Simple(1, function()
				umsg.Start("SetScrap", pl)
				umsg.Short(RESOURCES[pl:Team()].Scrap)
				umsg.End()
				
				umsg.Start("SetUranium", pl)
				umsg.Short(RESOURCES[pl:Team()].Uranium)
				umsg.End()
			end)
		end
	end
end
concommand.Add("sv_rts_setteam", ChooseTeam)

function CreateBuilding(pl, cmd, args)
	if args[1] && args[2] && args[3] && args[4] then
		local id = tonumber(args[1])
		local pos = Vector(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
		
		if BUILDINGS[id] != nil then
			if RESOURCES[pl:Team()].Scrap >= BUILDINGS[id].Scrap && RESOURCES[pl:Team()].Uranium >= BUILDINGS[id].Uranium then
				RESOURCES[pl:Team()].Scrap = RESOURCES[pl:Team()].Scrap - BUILDINGS[id].Scrap
				RESOURCES[pl:Team()].Uranium = RESOURCES[pl:Team()].Uranium - BUILDINGS[id].Uranium
				
				local ent = ents.Create(BUILDINGS[id].Class)
				ent:SetPos(pos)
				ent:SetNWInt("team", pl:Team())
				ent:Spawn()
			else
				pl:SendNotify("You cannot afford this!")
			end
		end
	end
end
concommand.Add("sv_rts_placebuilding", CreateBuilding)

function SetScrap(scrap, teamnum)
	RESOURCES[teamnum].Scrap = scrap
	for k,v in pairs(team.GetPlayers(teamnum)) do
		umsg.Start("SetScrap", v)
		umsg.Short(scrap)
		umsg.End()
	end
end

function SetUranium(uranium, teamnum)
	RESOURCES[teamnum].Uranium = uranium
	for k,v in pairs(team.GetPlayers(teamnum)) do
		umsg.Start("SetUranium", v)
		umsg.Short(uranium)
		umsg.End()
	end
end