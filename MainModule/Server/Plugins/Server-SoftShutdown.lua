server, service = nil, nil
--// Originally written by Merely
--// Edited by GitHub@LolloDev5123 and Irreflexive

return function()
	
	local TeleportService = game:GetService("TeleportService")
	local parameterName = "ADONIS_SOFTSHUTDOWN"
	
	if (game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0)  then
		--// This is a reserved server
		
		local waitTime = 5
		local function teleport(player)
			local joindata = player:GetJoinData()
			local data = joindata.TeleportData
			if typeof(data) == "table" and data[parameterName] then
				server.Functions.Message("Server Restart", "Teleporting back to main server...", {player}, false, 1000)
				wait(waitTime)
				waitTime = waitTime / 2
				TeleportService:Teleport(game.PlaceId, player)
			end
		end
	
		service.Events.PlayerAdded:Connect(teleport)
		
		for _,player in ipairs(service.GetPlayers()) do
			teleport(player)
		end
	
	end
	server.Commands.SoftShutdown = {
		Prefix = server.Settings.Prefix;	-- Prefix to use for command
		Commands = {"softshutdown","restart","sshutdown"};	-- Commands
		Args = {};	-- Command arguments
		Description = "Restarts the server";	-- Command Description
		Hidden = false; -- Is it hidden from the command list?
		Fun = false;	-- Is it fun?
		AdminLevel = "Admins";	    -- Admin level; If using settings.CustomRanks set this to the custom rank name (eg. "Baristas")
		Function = function(plr,args)    -- Function to run for command
			local newserver = TeleportService:ReserveServer(game.PlaceId)
			if (#game.Players:GetPlayers() == 0) then
				return
			end
			
			if (game:GetService("RunService"):IsStudio()) then
				return
			end
			
			server.Functions.Message("Server Restart", "The server is restarting, please wait...", service.GetPlayers(), false, 1000)
			wait(2)
			
			for _,player in pairs(game.Players:GetPlayers()) do
				TeleportService:TeleportToPrivateServer(game.PlaceId, newserver, { player }, "", {[parameterName] = true})
			end
			game.Players.PlayerAdded:connect(function(player)
				TeleportService:TeleportToPrivateServer(game.PlaceId, newserver, { player }, "", {[parameterName] = true})
			end)
			while (#game.Players:GetPlayers() > 0) do
				wait(1)
			end	
			
			-- done
		end
	}
end
