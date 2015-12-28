surface.CreateFont("FixedsysTTF", 16, 400, true, false, "rts_chat", false, false)

local chatOpac = 255	//Opacity for the chatbox when not active

local chatActive = false	//Tells us whether or not the chatbox is active
chatOverride = false
local chatTeamOnly = false	//Tells us if we're sending a team only message

local chatlog = {}		//Table that will contain all current chat messages to be displayed
local chatIn			//Table to contain the users' chatbox input

local CHAT_PLAYER = 1
local CHAT_CONSOLE = 2
local CHAT_ANNOUNCE = 3

local RANK_ADMIN = 1
local RANK_MOD = 2
local RANK_VIP = 3
local RANK_KOPIMI = 1337
local RANK_PLAYER = 0

VIPS = {}

/*========================================
Creates a derma element that will serve as
a chatbox.
========================================*/
chatbox = vgui.Create("DFrame")
chatbox:SetPos(10, ScrH() - 510)
chatbox:SetSize(590, 180)
chatbox:SetTitle(" ")
chatbox:SetSizable(false)
chatbox:ShowCloseButton(false)
chatbox:SetDraggable(false)
chatbox:SetVisible(false)
chatbox.Paint = function()
	if !chatOverride then return end

	//draw.RoundedBox(0, 0, 0, 590, 180, Color(255, 255, 255, 200))
	surface.SetFont("rts_chat")
	
	if chatActive then
		//Chatbox Frame
		//draw.RoundedBox(0, 0, 0, 560, 170, Color(0, 0, 0, 220))
		//draw.RoundedBox(0, 60, 180, 50, 20, Color(0, 0, 0, 220))
		//draw.RoundedBox(0, 115, 180, 445, 20, Color(0, 0, 0, 220))
		
		if chatTeamOnly then
			draw.DrawText("Team:", "rts_chat", 16, 163, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Team:", "rts_chat", 15, 162, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT)
		else
			draw.DrawText("Say:", "rts_chat", 19, 163, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Say:", "rts_chat", 18, 162, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT)
		end
		
		draw.DrawText(chatIn || " ", "rts_chat", 71, 163, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		draw.DrawText(chatIn || " ", "rts_chat", 70, 162, Color(0, 255, 0, 255), TEXT_ALIGN_LEFT)
	end
	
	local line = 0
	for k,v in pairs(chatlog) do
		local pre = v[1]
		local msg = v[2]
		local color = v[3]
		local rank = v[4]
		local msgtype = v[5]
			
		if msgtype == CHAT_PLAYER then
			/*if rank == RANK_KOPIMI then
				draw.DrawText("(Owner)", "rts_chat", 56, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
				draw.DrawText("(Owner)", "rts_chat", 55, 137 - 20*line, Color(255 * math.abs(math.sin(CurTime())), 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
			elseif rank == RANK_ADMIN then
				draw.DrawText("(Admin)", "rts_chat", 56, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
				draw.DrawText("(Admin)", "rts_chat", 55, 137 - 20*line, Color(255 * math.abs(math.sin(CurTime())), 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
			elseif rank == RANK_MOD then
				draw.DrawText("(Mod)", "rts_chat", 56, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
				draw.DrawText("(Mod)", "rts_chat", 55, 137 - 20*line, Color(102 * math.abs(math.sin(CurTime())), 255 * math.abs(math.sin(CurTime())), 0, chatOpac), TEXT_ALIGN_RIGHT)
			elseif rank == RANK_VIP then
				draw.DrawText("(VIP)", "rts_chat", 56, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_RIGHT)
				draw.DrawText("(VIP)", "rts_chat", 55, 137 - 20*line, Color(255 * math.abs(math.sin(CurTime())), 204 * math.abs(math.sin(CurTime())), 0, chatOpac), TEXT_ALIGN_RIGHT)
			end*/
			
			draw.DrawText(pre, "rts_chat", 16, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_LEFT)
			draw.DrawText(pre, "rts_chat", 15, 137 - 20*line, Color(color.r, color.g, color.b, chatOpac), TEXT_ALIGN_LEFT)
			draw.DrawText(msg, "rts_chat", surface.GetTextSize(pre) + 21, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_LEFT)
			draw.DrawText(msg, "rts_chat", surface.GetTextSize(pre) + 20, 137 - 20*line, Color(0, 255, 0, chatOpac), TEXT_ALIGN_LEFT)
		elseif msgtype == CHAT_CONSOLE then
			draw.DrawText(msg, "rts_chat", 16, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_LEFT)
			draw.DrawText(msg, "rts_chat", 15, 137 - 20*line, Color(color.r, color.g, color.b, chatOpac), TEXT_ALIGN_LEFT)
		elseif msgtype == CHAT_ANNOUNCE then
			draw.DrawText(msg, "rts_chat", surface.GetTextSize(pre) + 16, 138 - 20*line, Color(0, 0, 0, chatOpac), TEXT_ALIGN_LEFT)
			draw.DrawText(msg, "rts_chat", surface.GetTextSize(pre) + 15, 137 - 20*line, Color(color.r, color.g, color.b, chatOpac), TEXT_ALIGN_LEFT)
		end
		
		line = line + 1
	end
end

/*========================================
Handles the fading of the chatbox when not
actively being displayed.
========================================*/
local chatFadeTick = 255
timer.Create("chatFadeTimer", 0.01, 255, function()
	chatOpac = chatOpac - 1
	chatFadeTick = chatFadeTick - 1
	
	if chatFadeTick <= 0 then
		timer.Stop("chatFadeTimer")
		if !chatActive then chatbox:SetVisible(false) end
	end
end)
timer.Stop("chatFadeTimer")

/*========================================
Used to add a message to the chatbox.
========================================*/
function ChatMsg(msg)
	table.insert(chatlog, 1, msg)
	table.remove(chatlog, 8)
	
	chatbox:SetVisible(true)
	chatOpac = 255
	chatFadeTick = 255
	
	timer.Simple(5, function()
		if !chatActive then
			timer.Start("chatFadeTimer")
		end
	end)
end

/*========================================
Called to update the text that is shown
while you are typing your message.
========================================*/
function GM:ChatTextChanged(text)
	chatIn = text
end

/*========================================
Called when you recieve a message typed
by a PLAYER
========================================*/
function GM:OnPlayerChat(pl, text, teamonly, isdead)
	if !ValidEntity(pl) then return end

	local color = Color(0, 255, 0, 255)//team.GetColor(pl:Team())
	
	if isdead then
		color.r = color.r - 50
		color.g = color.g - 50
		color.b = color.b - 50
		
		if color.r < 0 then
			color.r = 0
		end
		
		if color.g < 0 then
			color.g = 0
		end
		
		if color.b < 0 then
			color.b = 0
		end
	end
		
	local msg = {}
		
	msg[2] = text
	msg[3] = color
	
	if pl:IsKopimi() then
		msg[4] = RANK_KOPIMI
		msg[1] = tostring("<&" .. pl:Name() .. "> ")
	elseif pl:IsUserGroup("moderator") then
		msg[4] = RANK_MOD
		msg[1] = tostring("<%" .. pl:Name() .. "> ")
	elseif pl:IsAdmin() then
		msg[4] = RANK_ADMIN
		msg[1] = tostring("<@" .. pl:Name() .. "> ")
	elseif table.HasValue(VIPS, pl:SteamID()) then
		msg[4] = RANK_VIP
		msg[1] = tostring("<+" .. pl:Name() .. "> ")
	else
		msg[1] = tostring("<" .. pl:Name() .. "> ")
		msg[4] = RANK_PLAYER
	end
	
	if teamonly then
		msg[1] = tostring("[TEAM] " .. msg[1])
	end
	
	msg[5] = CHAT_PLAYER
	
	if (pl:IsKopimi() || pl:IsAdmin()) && string.lower(string.sub(msg[2], 1, 10)) == "/announce " then
		msg[1] = ""
		msg[2] = string.gsub(msg[2], "/announce ", "")
		msg[3] = Color(102, 255, 51, 255)
		msg[5] = CHAT_ANNOUNCE
	end
	
	surface.SetFont("rts_chat")
	if surface.GetTextSize(tostring(msg[1] .. msg[2])) > 540 then
		local lastline = false
		for i=1,3 do
			if surface.GetTextSize(tostring(msg[1] .. msg[2])) > 540 || lastline then	
				if !string.find(msg[2], " ") then return end
				
				local temp = {}
				local temp2 = {}
				local fin = {"", "", msg[3], msg[4], msg[5]}
				if i != 1 then fin[4] = RANK_PLAYER end
				
				if i == 1 then
					temp = string.Explode(" ", msg[2])
					fin[1] = msg[1]
				else
					temp = string.Explode(" ", msg[2])
				end
				
				local indexes = {}
				for k,v in pairs(temp) do
					if surface.GetTextSize(tostring(fin[1] .. fin[2])) + surface.GetTextSize(v) <= 540 then
						fin[2] = tostring(fin[2] .. " " .. v)
						table.insert(indexes, k)
					else
						break
					end
				end
				for k,v in pairs(temp) do
					if k != indexes[k] then
						table.insert(temp2, v)
					end
				end
				
				msg[2] = table.concat(temp2, " ")
				
				ChatMsg(fin)
			else
				lastline = true
			end
		end
	else
		ChatMsg(msg)
	end
end

/*========================================
Called when you recieve a message typed
by ANYTHING (This is used to handle console)
========================================*/
function GM:ChatText(index, name, text, msgtype)
	if msgtype != "none" && msgtype != "joinleave" then return end
	
	local msg = {"", text, Color(255, 0, 0, 255), false, CHAT_CONSOLE}
	if string.sub(text, 1, 8) == "[ADVERT]" then
		msg[3] = Color(102, 255, 51, 255)
	end
	
	surface.SetFont("rts_chat")
	if surface.GetTextSize(msg[2]) > 540 then
		local lastline = false
		for i=1,3 do
			if surface.GetTextSize(msg[2]) > 540 || lastline then	
				if !string.find(msg[2], " ") then return end
				
				local temp = {}
				local temp2 = {}
				local fin = {"", "", msg[3], msg[4], msg[5]}
				
				if i == 1 then
					temp = string.Explode(" ", msg[2])
					fin[1] = msg[1]
				else
					temp = string.Explode(" ", msg[2])
				end
				
				local indexes = {}
				for k,v in pairs(temp) do
					if surface.GetTextSize(tostring(fin[1] .. fin[2])) + surface.GetTextSize(v) <= 540 then
						fin[2] = tostring(fin[2] .. " " .. v)
						table.insert(indexes, k)
					else
						break
					end
				end
				for k,v in pairs(temp) do
					if k != indexes[k] then
						table.insert(temp2, v)
					end
				end
				
				msg[2] = table.concat(temp2, " ")
				
				ChatMsg(fin)
			else
				lastline = true
			end
		end
	else
		ChatMsg(msg)
	end
end

/*========================================
Called when the chatbox is opened.
========================================*/
function GM:StartChat(teamonly)
	chatbox:SetVisible(true)
	chatActive = true
	chatOverride = true
	chatTeamOnly = teamonly
	timer.Stop("chatFadeTimer")
	chatFadeTick = 255
	chatOpac = 255
	return true
end

/*========================================
Called when the chatbox is closed.
========================================*/
function GM:FinishChat()
	chatActive = false
	timer.Simple(5, function()
		if !chatActive then timer.Start("chatFadeTimer") end
	end)
end