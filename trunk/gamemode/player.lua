local meta = FindMetaTable("Player")

/*====================
	IsKopimi()

	Used to identify
	kopimi.
=====================*/
function meta:IsKopimi()
	return self:SteamID() == "STEAM_0:0:21481048"
end

function meta:SendNotify(msg)
	umsg.Start("Notify", self)
	umsg.String(msg)
	umsg.End()
end