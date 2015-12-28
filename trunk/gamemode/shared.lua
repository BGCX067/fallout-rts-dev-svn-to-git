GM.Name		= "FALLOUT: RTS"
GM.Author	= "kopimi"
GM.Email	= "regan.flow@gmail.com"

TEAM_BROTHERHOOD	= 1
TEAM_ENCLAVE		= 2
TEAM_NCR			= 3
TEAM_LEGION			= 4
TEAM_SPECTATOR		= 5

team.SetUp(TEAM_BROTHERHOOD, "Brotherhood of Steel", Color(51, 153, 255, 255))
team.SetUp(TEAM_ENCLAVE, "Enclave", Color(100, 100, 100, 255))
team.SetUp(TEAM_NCR, "New California Republic", Color(102, 204, 0, 255))
team.SetUp(TEAM_LEGION, "Caesar's Legion", Color(230, 0, 0, 255))
team.SetUp(TEAM_SPECTATOR, "Spectator", Color(204, 184, 0, 255))

RESOURCES = {}
RESOURCES[TEAM_BROTHERHOOD]	= {Scrap = 150, Uranium = 0}
RESOURCES[TEAM_ENCLAVE]		= {Scrap = 150, Uranium = 0}
RESOURCES[TEAM_NCR]			= {Scrap = 150, Uranium = 0}
RESOURCES[TEAM_LEGION]		= {Scrap = 150, Uranium = 0}

BUILDINGS = {
	{Name = "Command Center", Class = "rts_base", Scrap = 500, Uranium = 0},
	{Name = "Barracks", Class = "rts_barracks", Scrap = 150, Uranium = 0},
}