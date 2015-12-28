include("shared.lua")
include("player.lua")
include("cl_chat.lua")
include("derma.lua")

surface.CreateFont("Monofonto", 18, 400, true, false, "MainFont_Small", false, false, 0)
surface.CreateFont("Monofonto", 22, 500, true, false, "MainFont_Med", false, false, 0)
surface.CreateFont("Monofonto", 32, 500, true, false, "MainFont_Med2", false, false, 0)
surface.CreateFont("Monofonto", 48, 700, true, false, "MainFont_Large", false, false, 0)

local BrotherhoodLogoTex = surface.GetTextureID("UI/bos")
local EnclaveLogoTex = surface.GetTextureID("UI/enclave")
local NCRLogoTex = surface.GetTextureID("UI/ncr")
local LegionLogoTex = surface.GetTextureID("UI/legion")
local GamelogoTex = surface.GetTextureID("UI/logo")
local SelectionMarkerTex = surface.GetTextureID("UI/select_marker")
local PipBoyTex = surface.GetTextureID("UI/pipboy")
local VaultTecTex = surface.GetTextureID("UI/vaulttec")
local BuildMenuTex = surface.GetTextureID("UI/buildmenu")

local TEAM_ICONS = {}
TEAM_ICONS[TEAM_BROTHERHOOD]	= BrotherhoodLogoTex
TEAM_ICONS[TEAM_ENCLAVE]		= EnclaveLogoTex
TEAM_ICONS[TEAM_NCR]			= NCRLogoTex
TEAM_ICONS[TEAM_LEGION]			= LegionLogoTex

local camOffset = Vector(0, 0, 0)
local camPos = Vector(0, 0, 0)
local nextCamTick = CurTime()
local buildingPlacement = false
local buildingEnt = nil
local selectionBox = {}
local selectionActive = false
currentSelection = {}

gui.EnableScreenClicker(true)

function InitPostEntity()
	camOffset = Vector(0, 0, 250)
end
hook.Add("InitPostEntity", "InitPostEntity", InitPostEntity)

function GM:HUDPaint()
	draw.RoundedBox(0, 0, 0, ScrW(), 20, Color(40, 40, 40, 240))
	draw.RoundedBox(0, 0, 20, ScrW(), 1, Color(0, 0, 0, 255))
	draw.RoundedBox(0, 0, 19, ScrW(), 1, Color(90, 90, 90, 255))
	
	if RESOURCES[LocalPlayer():Team()] then
		surface.SetFont("MainFont_Small")
		local width = surface.GetTextSize
	
		draw.SimpleTextOutlined("SCRAP: " .. RESOURCES[LocalPlayer():Team()].Scrap, "MainFont_Small", ScrW() / 2 - 300, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
		draw.SimpleTextOutlined("URANIUM: " .. RESOURCES[LocalPlayer():Team()].Uranium, "MainFont_Small", ScrW() / 2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
	end

	local trace = {}
	trace.start = camPos
	trace.endpos = gui.ScreenToVector(gui.MousePos()) * 99999
	trace.filter = LocalPlayer()
	
	local tr = util.TraceLine(trace)
	
	if buildingPlacement && ValidEntity(buildingEnt) && tr.Hit then
		buildingEnt:SetPos(tr.HitPos)
	end
	
	if ValidEntity(tr.Entity) && tr.Entity:IsNPC() then
		local pos = (tr.Entity:GetPos() + Vector(0, 0, 75)):ToScreen()
		
		draw.SimpleTextOutlined(tr.Entity:GetNWString("name"), "MainFont_Small", pos.x, pos.y - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
		draw.RoundedBox(0, pos.x - 77, pos.y - 2, 154, 9, Color(0, 0, 0, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y, 150, 5, Color(128, 13, 0, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y, 150 * (tr.Entity:GetNWInt("health") / tr.Entity:GetNWInt("maxhealth")), 5, Color(255, 26, 0, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y, 150 * (tr.Entity:GetNWInt("health") / tr.Entity:GetNWInt("maxhealth")), 1, Color(255, 255, 255, 50))
		
		for i=1,15 do
			draw.RoundedBox(0, (pos.x - 75) + (10 * i), pos.y, 2, 5, Color(0, 0, 0, 255))
		end
		
		draw.RoundedBox(0, pos.x - 77, pos.y + 12, 154, 9, Color(0, 0, 0, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y + 14, 150, 5, Color(0, 31, 153, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y + 14, 150 * (tr.Entity:GetNWInt("armor") / tr.Entity:GetNWInt("maxarmor")), 5, Color(26, 71, 255, 255))
		draw.RoundedBox(0, pos.x - 75, pos.y + 14, 150 * (tr.Entity:GetNWInt("armor") / tr.Entity:GetNWInt("maxarmor")), 1, Color(255, 255, 255, 50))
		
		for i=1,15 do
			draw.RoundedBox(0, (pos.x - 75) + (10 * i), pos.y + 14, 2, 5, Color(0, 0, 0, 255))
		end
	elseif ValidEntity(tr.Entity) && tr.Entity:GetClass() != "rts_scrapyard" then
		local pos = (tr.Entity:GetPos() + Vector(0, 0, 75)):ToScreen()
		
		draw.SimpleTextOutlined(tr.Entity:GetNWString("name"), "MainFont_Small", pos.x, pos.y - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
		draw.RoundedBox(0, pos.x - 127, pos.y - 2, 254, 9, Color(0, 0, 0, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y, 250, 5, Color(128, 13, 0, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y, 250 * (tr.Entity:GetNWInt("health") / tr.Entity:GetNWInt("maxhealth")), 5, Color(255, 26, 0, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y, 250 * (tr.Entity:GetNWInt("health") / tr.Entity:GetNWInt("maxhealth")), 1, Color(255, 255, 255, 50))
		
		for i=1,25 do
			draw.RoundedBox(0, (pos.x - 125) + (10 * i), pos.y, 2, 5, Color(0, 0, 0, 255))
		end
		
		draw.RoundedBox(0, pos.x - 127, pos.y + 12, 254, 9, Color(0, 0, 0, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y + 14, 250, 5, Color(0, 31, 153, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y + 14, 250 * (tr.Entity:GetNWInt("armor") / tr.Entity:GetNWInt("maxarmor")), 5, Color(26, 71, 255, 255))
		draw.RoundedBox(0, pos.x - 125, pos.y + 14, 250 * (tr.Entity:GetNWInt("armor") / tr.Entity:GetNWInt("maxarmor")), 1, Color(255, 255, 255, 50))
		
		for i=1,25 do
			draw.RoundedBox(0, (pos.x - 125) + (10 * i), pos.y + 14, 2, 5, Color(0, 0, 0, 255))
		end
	elseif ValidEntity(tr.Entity) && tr.Entity:GetClass() == "rts_scrapyard" then
		local pos = (tr.Entity:GetPos() + Vector(0, 0, 75)):ToScreen()
		draw.SimpleTextOutlined("Scrap: " .. tr.Entity:GetNWInt("scrap"), "MainFont_Small", pos.x, pos.y - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
	end
	
	if selectionActive then
		selectionBox.x2 = gui.MouseX()
		selectionBox.y2 = gui.MouseY()
	
		if selectionBox.x2 > selectionBox.x1 then
			if selectionBox.y2 > selectionBox.y1 then
				draw.RoundedBox(0, selectionBox.x1, selectionBox.y1, selectionBox.x2 - selectionBox.x1, selectionBox.y2 - selectionBox.y1, Color(0, 255, 0, 20))
			else
				draw.RoundedBox(0, selectionBox.x1, selectionBox.y2, selectionBox.x2 - selectionBox.x1, selectionBox.y1 - selectionBox.y2, Color(0, 255, 0, 20))
			end
		else
			if selectionBox.y2 > selectionBox.y1 then
				draw.RoundedBox(0, selectionBox.x2, selectionBox.y1, selectionBox.x1 - selectionBox.x2, selectionBox.y2 - selectionBox.y1, Color(0, 255, 0, 20))
			else
				draw.RoundedBox(0, selectionBox.x2, selectionBox.y2, selectionBox.x1 - selectionBox.x2, selectionBox.y1 - selectionBox.y2, Color(0, 255, 0, 20))
			end
		end
		
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawLine(selectionBox.x1, selectionBox.y1, selectionBox.x2, selectionBox.y1)
		surface.DrawLine(selectionBox.x1, selectionBox.y1, selectionBox.x1, selectionBox.y2)
		surface.DrawLine(selectionBox.x2, selectionBox.y2, selectionBox.x2, selectionBox.y1)
		surface.DrawLine(selectionBox.x2, selectionBox.y2, selectionBox.x1, selectionBox.y2)
		
		for k,v in pairs(ents.FindByClass("*rts_*")) do
			if v:IsNPC() || v:GetClass() == "rts_base" || v:GetClass() == "rts_barracks" then
				local pos = v:GetPos():ToScreen()
				local minX = math.min(selectionBox.x1, selectionBox.x2)
				local minY = math.min(selectionBox.y1, selectionBox.y2)
				local maxX = math.max(selectionBox.x1, selectionBox.x2)
				local maxY = math.max(selectionBox.y1, selectionBox.y2)
				
				if pos.x > minX && pos.x < maxX && pos.y > minY && pos.y < maxY then
					if !table.HasValue(currentSelection, v) && ((v:GetNWInt("team") && v:GetNWInt("team") == LocalPlayer():Team()) || table.Count(currentSelection) == 0) then
						table.insert(currentSelection, v)
					end
				else
					if table.HasValue(currentSelection, v) then
						for i,e in pairs(currentSelection) do
							if e == v then table.remove(currentSelection, i) end
						end
					end
				end
			end
		end
	end
end

hook.Add("PostDrawOpaqueRenderables", "PostDrawOpaqueRenderables", function()
	for k,v in pairs(currentSelection) do
		if ValidEntity(v) then
			local size = 256
			local offset = Vector(0, 0, 2)
			local color = Color(255, 255, 102)
			
			if v:GetClass() == "rts_base" then
				size = 1800
			end
			
			if v:GetClass() == "rts_barracks" then
				size = 1800
			end
			
			if v:GetNWInt("team") && v:GetNWInt("team") == LocalPlayer():Team() then
				color = Color(0, 255, 0)
			end
			
			cam.Start3D2D(v:GetPos() + offset, Angle(0, 0, 0), 0.2)
				render.SetToneMappingScaleLinear(Vector(0.5, 0.5, 0.5))
				surface.SetDrawColor(color.r, color.g, color.b, 255)
				surface.SetTexture(SelectionMarkerTex)
				surface.DrawTexturedRect(-(size / 2), -(size / 2), size, size)
				render.SetToneMappingScaleLinear(Vector(1, 1, 1))
			cam.End3D2D()
		end
	end
end)

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)

function GM:GUIMousePressed(mc, vec)
	if mc == MOUSE_LEFT then
		if buildingPlacement && ValidEntity(buildingEnt) then
			local trace = {}
			trace.start = camPos
			trace.endpos = gui.ScreenToVector(gui.MousePos()) * 99999
			trace.filter = LocalPlayer()
			
			local tr = util.TraceLine(trace)
			
			if tr.Hit then
				RunConsoleCommand("sv_rts_placebuilding", buildingEnt.ID, tr.HitPos.x, tr.HitPos.y, tr.HitPos.z)
				buildingPlacement = false
				buildingEnt:Remove()
			end
		else
			RunConsoleCommand("+attack")
			currentSelection = {}
			selectionActive = true
			selectionBox.x1 = gui.MouseX()
			selectionBox.y1 = gui.MouseY()
		end
	elseif mc == MOUSE_RIGHT then
		RunConsoleCommand("+attack2")
	end
end

function GM:GUIMouseReleased(mc)
	if mc == MOUSE_LEFT then
		RunConsoleCommand("-attack")
		selectionActive = false
		selectionBox.x2 = gui.MouseX()
		selectionBox.y2 = gui.MouseY()
		controlPanel.unit:SetVisible(false)
		chatOverride = true
		
		if table.Count(currentSelection) > 0 then
			controlPanel.unit:SetVisible(true)
			chatOverride = false
		end
	elseif mc == MOUSE_RIGHT then
		RunConsoleCommand("-attack2")
	end
end

hook.Add("CalcView", "CalcView", function(pl, pos, ang, fov)
	if CurTime() >= nextCamTick then
		local x,y = gui.MousePos()

		if x < 50 then
			camOffset = camOffset - ang:Right() * 10
		end
		
		if x > ScrW() - 50 then
			camOffset = camOffset + ang:Right() * 10
		end
		
		if y < 50 then
			camOffset = camOffset + (ang:Forward() * 10) * Vector(1, 1, 0)
		end
		
		if y > ScrH() - 50 then
			camOffset = camOffset - (ang:Forward() * 10) * Vector(1, 1, 0)
		end
		
		nextCamTick = CurTime() + 0.01
	end

	local view = {}
	view.origin = pos + camOffset
	view.angles = Angle(30, ang.y, 0)
	view.fov = fov
	
	camPos = pos + camOffset
	return view
end)

function StartBuildingPlacement(id)
	if BUILDINGS[id] == nil then return end
	
	buildingPlacement = true
	buildingEnt = ClientsideModel("models/magnusson_teleporter.mdl", RENDERGROUP_OPAQUE)
	buildingEnt:Spawn()
	buildingEnt:SetColor(255, 255, 255, 200)
	buildingEnt.ID = id
end

function OpenMainUI()
	local mainFrame = vgui.Create("DFrame")
	mainFrame:SetPos(0, ScrH() - 200)
	mainFrame:SetSize(ScrW(), 200)
	mainFrame:SetTitle("")
	mainFrame:ShowCloseButton(false)
	mainFrame:SetDraggable(false)
	mainFrame:SetSizable(false)
	mainFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), 200, Color(40, 40, 40, 240))
		draw.RoundedBox(0, 0, 0, ScrW(), 1, Color(0, 0, 0, 255))
		draw.RoundedBox(0, 0, 1, ScrW(), 1, Color(90, 90, 90, 255))
		surface.SetDrawColor(70, 70, 70, 150)
		surface.SetTexture(VaultTecTex)
		surface.DrawTexturedRect(ScrW() / 2 - 650, 40, 300, 122)
		surface.DrawTexturedRect(ScrW() / 2 + 350, 40, 300, 122)
	end
	
	controlPanel = vgui.Create("DPanel", mainFrame)
	controlPanel:SetPos(ScrW() / 2 - 300, 5)
	controlPanel:SetSize(600, 190)
	controlPanel.Paint = function()
		draw.RoundedBox(0, 0, 0, 600, 190, Color(0, 0, 0, 255))
		draw.RoundedBox(0, 1, 1, 598, 188, Color(90, 90, 90, 100))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(PipBoyTex)
		surface.DrawTexturedRect(2, 2, 596, 186)
	end
	
	controlPanel.unit = vgui.Create("DPanel", controlPanel)
	controlPanel.unit:SetPos(0, 0)
	controlPanel.unit:SetSize(600, 190)
	controlPanel.unit.Paint = function()
		if chatActive || chatOverride then return end
	
		for k,v in pairs(currentSelection) do
			if ValidEntity(v) then
				draw.RoundedBox(0, 10, 10, 170, 170, Color(0, 0, 0, 255))
				draw.RoundedBox(0, 11, 11, 168, 168, Color(80, 80, 80, 255))
				
				if v:GetNWInt("team") then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetTexture(TEAM_ICONS[v:GetNWInt("team")])
					surface.DrawTexturedRect(12, 12, 166, 166)
				end
				
				draw.SimpleText(v:GetNWString("name"), "MainFont_Med2", 400, 10, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER) 
				draw.RoundedBox(4, 200, 55, 380, 15, Color(255, 26, 0, 255))
				draw.RoundedBox(4, 202, 56, 376, 13, Color(0, 0, 0, 255))
				draw.RoundedBox(4, 204, 58, 372 * (v:GetNWInt("maxhealth") / v:GetNWInt("health")), 9, Color(255, 26, 0, 255))
				draw.SimpleTextOutlined("HEALTH: " .. v:GetNWInt("maxhealth") .. "/" .. v:GetNWInt("health"), "MainFont_Small", 400, 63, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
				
				if v:GetNWInt("maxarmor") != 0 then
					draw.RoundedBox(4, 200, 80, 380, 15, Color(26, 71, 255, 255))
					draw.RoundedBox(4, 202, 81, 376, 13, Color(0, 0, 0, 255))
					draw.RoundedBox(4, 204, 83, 372 * (v:GetNWInt("maxarmor") / v:GetNWInt("armor")), 9, Color(26, 71, 255, 255))
					draw.SimpleTextOutlined("ARMOR: " .. v:GetNWInt("maxarmor") .. "/" .. v:GetNWInt("armor"), "MainFont_Small", 400, 88, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
				end
				
				if v:GetNWInt("maxenergy") != 0 then
					draw.RoundedBox(4, 200, 105, 380, 15, Color(102, 0, 102, 255))
					draw.RoundedBox(4, 202, 106, 376, 13, Color(0, 0, 0, 255))
					draw.RoundedBox(4, 204, 108, 372 * (v:GetNWInt("maxenergy") / v:GetNWInt("energy")), 9, Color(102, 0, 102, 255))
					draw.SimpleTextOutlined("ENERGY: " .. v:GetNWInt("maxenergy") .. "/" .. v:GetNWInt("energy"), "MainFont_Small", 400, 113, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 50))
				end
				
				break
			end
		end
	end
	
	local cp1 = vgui.Create("PipIconButton", controlPanel.unit)
	cp1:SetPos(200, 130)
	cp1:SetSize(50, 50)
	
	local cp2 = vgui.Create("PipIconButton", controlPanel.unit)
	cp2:SetPos(260, 130)
	cp2:SetSize(50, 50)
	
	local cp3 = vgui.Create("PipIconButton", controlPanel.unit)
	cp3:SetPos(320, 130)
	cp3:SetSize(50, 50)
	
	local cp4 = vgui.Create("PipIconButton", controlPanel.unit)
	cp4:SetPos(380, 130)
	cp4:SetSize(50, 50)
	
	local cp5 = vgui.Create("PipIconButton", controlPanel.unit)
	cp5:SetPos(440, 130)
	cp5:SetSize(50, 50)
	
	local cp6 = vgui.Create("PipIconButton", controlPanel.unit)
	cp6:SetPos(500, 130)
	cp6:SetSize(50, 50)
	
	controlPanel.unit:SetVisible(false)
	
	chatbox:SetParent(controlPanel)
	chatbox:SetPos(5, 5)
end

function OpenBuildMenu()
	buildMenu = vgui.Create("DFrame")
	buildMenu:SetSize(512, 512)
	buildMenu:SetPos(ScrW() / 2 - 256, (ScrH() - 200) / 2 - 276)
	buildMenu:SetTitle("")
	buildMenu:SetDraggable(false)
	buildMenu:SetSizable(false)
	buildMenu:ShowCloseButton(false)
	buildMenu.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(BuildMenuTex)
		surface.DrawTexturedRect(0, 0, 512, 512)
	end
	
	local buildList = vgui.Create("DPanelList", buildMenu)
	buildList:SetPos(45, 50)
	buildList:SetSize(420, 400)
	buildList:SetSpacing(10)
	buildList:EnableHorizontal(false)
	buildList:EnableVerticalScrollbar(true)
	buildList.Paint = function()
		//invis
	end
	
	for k,v in pairs(BUILDINGS) do
		if v.Team && v.Team != LocalPlayer():Team() then return end
		
		local p = vgui.Create("DPanel")
		p:SetSize(400, 80)
		p.Paint = function()
			draw.RoundedBox(0, 0, 0, 400, 80, Color(0, 255, 0, 20))
			draw.RoundedBox(0, 0, 0, 400, 2, Color(0, 255, 0, 255))
			draw.RoundedBox(0, 0, 78, 400, 2, Color(0, 255, 0, 255))
			draw.RoundedBox(0, 0, 0, 2, 80, Color(0, 255, 0, 255))
			draw.RoundedBox(0, 398, 0, 2, 80, Color(0, 255, 0, 255))
			draw.SimpleText(v.Name, "MainFont_Med2", 6, 0, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Scrap: " .. v.Scrap .. " | Uranium: " .. v.Uranium, "Default", 8, 30, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT)
		end
		
		local b = vgui.Create("DButton", p)
		b:SetSize(380, 20)
		b:SetPos(10, 50)
		b:SetText("Construct Building")
		b.Paint = function()
			draw.RoundedBox(0, 0, 0, 380, 20, Color(0, 150, 0, 255))
			draw.RoundedBox(0, 1, 1, 378, 18, Color(153, 200, 0, 255))
			draw.RoundedBox(0, 2, 2, 376, 16, Color(0, 170, 0, 255))
		end
		b.DoClick = function()
			StartBuildingPlacement(k)
		end
		
		buildList:AddItem(p)
	end
	
	buildMenu:MakePopup()
end
hook.Add("OnSpawnMenuOpen", "OnSpawnMenuOpen", OpenBuildMenu)

function CloseBuildMenu()
	if buildMenu != nil then
		buildMenu:Close()
	end
end
hook.Add("OnSpawnMenuClose", "OnSpawnMenuClose", CloseBuildMenu)

function OpenIntro()
	local intro = vgui.Create("DFrame")
	intro:SetSize(ScrW(), ScrH())
	intro:SetTitle("")
	intro:ShowCloseButton(false)
	intro:SetDraggable(false)
	intro:SetSizable(false)
	intro.Paint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
		surface.SetDrawColor(255, 255, 255, 255 - math.random(0, 150))
		surface.SetTexture(GamelogoTex)
		surface.DrawTexturedRect(ScrW() / 2 - 364, ScrH() / 2 - 70, 650, 125)
	end
	intro:MakePopup()
	
	timer.Simple(5, function()
		intro:Close()
		OpenTeamMenu()
	end)
end
usermessage.Hook("OpenIntro", OpenIntro)

function OpenTeamMenu()
	local alpha = math.random(0, 100)

	local f = vgui.Create("DFrame")
	f:SetSize(ScrW(), ScrH())
	f:SetTitle("")
	f:ShowCloseButton(false)
	f:SetDraggable(false)
	f:SetSizable(false)
	f.Paint = function()
		alpha = math.random(0, 100)
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
		draw.DrawText("Choose Your Faction", "MainFont_Large", ScrW() / 2, ScrH() / 2 - 356, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
	end
	f:MakePopup()

	local bos = vgui.Create("DButton", f)
	bos:SetText("")
	bos:SetSize(256, 256)
	bos:SetPos(ScrW() / 2 - 281, ScrH() / 2 - 281)
	bos.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255 - alpha)
		surface.SetTexture(BrotherhoodLogoTex)
		surface.DrawTexturedRect(0, 0, 256, 256)
		draw.RoundedBox(0, 0, 206, 256, 50, Color(0, 0, 0, 230))
		draw.SimpleText("Brotherhood of Steel", "MainFont_Med", 128, 219, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, 0, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 254, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 0, 256, 2, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 254, 256, 2, Color(255, 255, 255, 255 - alpha))
	end
	bos.DoClick = function()
		RunConsoleCommand("sv_rts_setteam", TEAM_BROTHERHOOD)
		f:Close()
		OpenMainUI()
	end
	
	local enclave = vgui.Create("DButton", f)
	enclave:SetText("")
	enclave:SetSize(256, 256)
	enclave:SetPos(ScrW() / 2 + 25, ScrH() / 2 - 281)
	enclave.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255 - alpha)
		surface.SetTexture(EnclaveLogoTex)
		surface.DrawTexturedRect(0, 0, 256, 256)
		draw.RoundedBox(0, 0, 206, 256, 50, Color(0, 0, 0, 230))
		draw.SimpleText("Enclave", "MainFont_Med", 128, 219, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, 0, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 254, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 0, 256, 2, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 254, 256, 2, Color(255, 255, 255, 255 - alpha))
	end
	enclave.DoClick = function()
		RunConsoleCommand("sv_rts_setteam", TEAM_ENCLAVE)
		f:Close()
		OpenMainUI()
	end
	
	local ncr = vgui.Create("DButton", f)
	ncr:SetText("")
	ncr:SetSize(256, 256)
	ncr:SetPos(ScrW() / 2 - 281, ScrH() / 2 + 25)
	ncr.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255 - alpha)
		surface.SetTexture(NCRLogoTex)
		surface.DrawTexturedRect(0, 0, 256, 256)
		draw.RoundedBox(0, 0, 206, 256, 50, Color(0, 0, 0, 230))
		draw.SimpleText("New California Republic", "MainFont_Med", 128, 219, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, 0, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 254, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 0, 256, 2, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 254, 256, 2, Color(255, 255, 255, 255 - alpha))
	end
	ncr.DoClick = function()
		RunConsoleCommand("sv_rts_setteam", TEAM_NCR)
		f:Close()
		OpenMainUI()
	end
	
	local legion = vgui.Create("DButton", f)
	legion:SetText("")
	legion:SetSize(256, 256)
	legion:SetPos(ScrW() / 2 + 25, ScrH() / 2 + 25)
	legion.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255 - alpha)
		surface.SetTexture(LegionLogoTex)
		surface.DrawTexturedRect(0, 0, 256, 256)
		draw.RoundedBox(0, 0, 206, 256, 50, Color(0, 0, 0, 230))
		draw.SimpleText("Caesar's Legion", "MainFont_Med", 128, 219, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, 0, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 254, 0, 2, 256, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 0, 256, 2, Color(255, 255, 255, 255 - alpha))
		draw.RoundedBox(0, 0, 254, 256, 2, Color(255, 255, 255, 255 - alpha))
	end
	legion.DoClick = function()
		RunConsoleCommand("sv_rts_setteam", TEAM_LEGION)
		f:Close()
		OpenMainUI()
	end
end

usermessage.Hook("SetCamPos", function(msg)
	local pos = msg:ReadVector()
	camOffset = Vector(0, 0, 250)
end)

usermessage.Hook("SetScrap", function(msg)
	local scrap = msg:ReadShort()
	RESOURCES[LocalPlayer():Team()].Scrap = scrap
end)

usermessage.Hook("SetUranium", function(msg)
	local uranium = msg:ReadShort()
	RESOURCES[LocalPlayer():Team()].Uranium = uranium
end)