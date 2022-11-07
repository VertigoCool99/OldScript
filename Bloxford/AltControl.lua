--Put your own usernames!
getgenv().Accounts = {
	["Host"] = "VertigoCool",
	["Alts"] = {
		"AshleeHines5",
		"SheilaNguyen33",
		"DavidOdom24",
		"PaulColeman94",
		"NatalieProctor70",
		"SusanCarroll6",
		"JudyFox6",
	},
}

if game.Workspace:FindFirstChild("Paths") then else
    Paths = Instance.new("Folder")
    Paths.Parent = game.Workspace
    Paths.Name = "Paths"
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Seat") then
            v:Destroy() 
        end
    end
end
local Locations = {["spawn"] = CFrame.new(468, 13, -213),["mine"] = CFrame.new(698, 7, -145),["bank"] = CFrame.new(289, 14, -71), ["garage"] = CFrame.new(162, 13, -186),["market"] = CFrame.new(466, 13, -878),["hunt"] = CFrame.new(868, 27, -1677),["shed"] = CFrame.new(1218, 21, -1872)}
inst = 0

function getPrinter()
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if string.find(v.Name, "Printer") then
            if v:FindFirstChild("Main") and v.Main.moneyprinter.health.Value ~= 0 and v.Main.moneyprinter.money.Value ~= 0 and v.Main.moneyprinter.beingCarried.Value == false then
                return v.Main
            end
        end
    end
end

function Tp(dest)
    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - dest.Position).Magnitude < 20 then
            for i,v in pairs(game.Workspace.Paths:GetChildren()) do
                v:Destroy()
            end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = dest.CFrame
    else
        if inst == 3 then
            for i,v in pairs(game.Workspace.Paths:GetChildren()) do
                v:Destroy()
            end
            inst = 0
            local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - dest.Position).Magnitude
        	tps = dist/tonumber(100)
        	local info = TweenInfo.new(tps, Enum.EasingStyle.Linear)
        	local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = dest.CFrame + Vector3.new(0,2,0)})
            tween:Play()
        else
            inst = inst + 1
            for i,v in pairs(game.Workspace.Paths:GetChildren()) do
                v:Destroy()
            end
            if game.Players.LocalPlayer.Backpack:FindFirstChild("Pickaxe") then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Pickaxe"))
            end
            local char= game.Players.LocalPlayer.Character
            local rootPart = char.HumanoidRootPart
            local humanoid = char.Humanoid
            local destination = dest.Position
            local function GetPath(destination) 
                local path = game:GetService("PathfindingService"):CreatePath({WaypointSpacing = 10})
                    path:ComputeAsync(rootPart.Position,destination)
                return path
            end
            
            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character
            local hm = char.HumanoidRootPart
            local dist
            local tweenspeed
            
            function WalkToWaypoints(tableWaypoints)
                for i,v in pairs(tableWaypoints) do
                    part = Instance.new("Part" ,game.Workspace.Paths)
                    part.Shape = "Ball"
                    part.Material = "Neon"
                    part.Anchored = true
                    part.CanCollide = false
                    part.Size = Vector3.new(1,1,1)
                    part.Position = v.Position + Vector3.new(0,2,0)
                    dist = (hm.Position - v.Position).magnitude
                    tweenspeed = dist/tonumber(300)
                    local ti = TweenInfo.new(tonumber(tweenspeed), Enum.EasingStyle.Linear)
                    local tp = {CFrame = CFrame.new(v.Position) + Vector3.new(0,3,0)}
                    ts:Create(hm, ti, tp):Play()
                    wait(tonumber(tweenspeed))
                    if v.Action == Enum.PathWaypointAction.Jump then
                        humanoid.Jump = true
                    end
                end
            end
            function WalkTo(destination)
                local path = GetPath(destination)
                if path.Status == Enum.PathStatus.Success then -- the path will return either success as true value or nopath as false value if it's computed.
                    WalkToWaypoints(path:GetWaypoints())
                end
            end
        WalkTo(destination)
        end
    end
end

function GetCar()
	for i,v in pairs(game:GetService("Workspace").Cars:GetChildren()) do
		if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude < 3.4 then
			return v
		end
	end
end

function GetGarageMan()
	for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
		if v.Name == "Dummy" and v:FindFirstChild("LowerTorso") and v.LowerTorso:FindFirstChild("garage") then
			return v
		end
	end
end

function StealCar()
	for i,v in next, game.Workspace.Cars:GetDescendants() do
				if v:IsA("VehicleSeat") then
					if v:FindFirstChild("SeatWeld") then
						print("Car is taken")
					else
						if game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Position) <= 20 then
							v:Sit(game.Players.LocalPlayer.Character.Humanoid)
						end
					end
				end
            end
end

function TpTween(dest,v3)
	local test = false
	v3 = v3 or 0
	local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - dest.Position).Magnitude
    tps = dist/tonumber(100)
    local info = TweenInfo.new(tps, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = dest.CFrame - Vector3.new(0,v3,0)})
    tween:Play()
    tween.Completed:Connect(function()
		test = true
	end)
    repeat task.wait()
    until test == true
end

function GetPlayerName(str)
	for i,v in pairs(game.Players:GetChildren()) do
		if v.Name:lower():sub(1,string.len(str)) == str:lower() then
			return v.Name
		elseif v.DisplayName:lower():sub(1,string.len(str)) == str:lower() then
			return v.Name
		end
	end
end

function Notify(Title,Text)
	game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Notification[3623751224]:Play()
	local Frame = game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Frame.Notification:Clone()
	Frame.Parent = game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Frame
	Frame.Visible = true
	Frame.ImageLabel:Destroy()
	Frame.Txt2:Destroy()
	Frame.Title2:Destroy()
	Frame.Title.Position = UDim2.new(.15,0,.15,0)
	Frame.Txt.Position = UDim2.new(.15,0,.3,0)
	Frame.Title.Text = Title or "Title"
	Frame.Txt.Text = Text or "Text"
	wait(4)
	Frame:Destroy()
end

function GetAlts()
	local tbl = {}
	for i,v in pairs(getgenv().Accounts["Alts"]) do
		if game.Players:FindFirstChild(v) then
			table.insert(tbl,v)		
		end
	end
	return tbl
end

game.ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData) 
	local User = messageData.FromSpeaker
	local Message = messageData.Message
	if User == getgenv().Accounts["Host"] then
		if Message == ",sit" then
			game.Players.LocalPlayer.Character.Humanoid.Sit = true
		elseif string.find(Message,",hbe") then
			local to = string.split(Message,",hbe")[2]
			local Tog = string.sub(to,2,string.len(to))
			if Tog == "true" then
				for i,v in pairs(game.Players:getChildren()) do
					v.Character.HumanoidRootPart.Size = Vector3.new(4,4,4)
					v.Character.HumanoidRootPart.Transparency = 0.8
					v.Character.HumanoidRootPart.CanCollide = false
				end
			elseif Tog == "false" then
				for i,v in pairs(game.Players:getChildren()) do
					v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
					v.Character.HumanoidRootPart.Transparency = 1
					v.Character.HumanoidRootPart.CanCollide = true
				end
			else
				spawn(function()
					Notify("Vertigo Alt Control","Provided wrong args for [hbe]")
				end)
				error("Provided wrong args for [hbe]")
			end
		elseif string.find(Message,",chat") then
			local New = string.split(Message,",chat")[2]
			local Msg = string.sub(New,2,string.len(New))
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Msg,"All")
		elseif Message == ",advert" then
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Vertigo Alt-Control V1.2","All")
		elseif string.find(Message,",buy") then
			local P = string.split(Message,",buy")[2]
			local Purchase = string.sub(P,2,string.len(P))
			game:GetService("ReplicatedStorage").Events.Shop:FireServer(Purchase)
		elseif string.find(Message,",cwp") then --Create Waypoint
			local w = string.split(Message,",cwp")[2]
			local waypoint = string.sub(w,2,string.len(w))
			Locations[tostring(waypoint)] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		elseif string.find(Message,",tp") then
			local t = string.split(Message,",tp")[2]
			local CF = string.sub(t,2,string.len(t))
			spawn(function()
				Notify("Vertigo Alt Control","Attempting Tp To, "..CF)
			end)
			if CF == "spawn" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["spawn"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "mine" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["mine"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "bank" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["bank"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "garage" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["garage"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "market" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["market"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "hunt" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["hunt"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "shed" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["shed"]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			elseif CF == "printbase" then
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations["shed"]
				TpTween(p)
				p:Destroy()
			else
				local p = Instance.new("Part",workspace)
				p.CFrame = Locations[CF]
				Tp(p)
				p:Destroy()
				for i,v in pairs(game.Workspace.Paths:GetChildren()) do
					v:Destroy()
				end
			end
		elseif string.find(Message,",ctp") then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts["Host"] then
				local t = string.split(Message,",ctp")[2]
				local CF = string.sub(t,2,string.len(t))
				spawn(function()
					Notify("Vertigo Alt Control","Attempting Car Tp To, "..CF)
				end)
				local Car = GetCar()
				if CF == "spawn" then
					Car:SetPrimaryPartCFrame(Locations["spawn"])
				elseif CF == "mine" then
					Car:SetPrimaryPartCFrame(Locations["mine"])
				elseif CF == "bank" then
					Car:SetPrimaryPartCFrame(Locations["bank"])
				elseif CF == "garage" then
					Car:SetPrimaryPartCFrame(Locations["garage"])
				elseif CF == "market" then
					Car:SetPrimaryPartCFrame(Locations["market"])
				elseif CF == "hunt" then
					Car:SetPrimaryPartCFrame(Locations["hunt"])
				elseif CF == "shed" then
					Car:SetPrimaryPartCFrame(Locations["shed"])
				else
					Car:SetPrimaryPartCFrame(Locations[CF])
				end
			end
		elseif Message == ",stealcar" then
			 StealCar()
        elseif Message == ",carmod" then
        	 for i, v in next, getgc(true) do
				if type(v) == "table" and rawget(v, "WheelFriction") then
					v.WheelFriction = math.huge
					v.MaxSpeed = math.huge
					v.BrakingTorque = math.huge
					v.DrivingTorque = math.huge
					v.TorsionSpringDamping = 0
					v.StrutSpringStiffnessRear = 0
					v.MaxSteer = 5
					v.ReverseSpeed = math.huge
				end
			end
		elseif string.find(Message,",spawn") then
			local s = string.split(Message,",spawn")[2]
			local car = string.sub(s,2,string.len(s))
			game:GetService("ReplicatedStorage").Events.Garage:FireServer(0,car,"spawn","White")
			task.wait(1)
			for i,v in pairs(game:GetService("Workspace").Cars:GetChildren()) do
				if (v.PrimaryPart.Position - GetGarageMan().LowerTorso.Position).Magnitude <= 50 then
					local old = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					Tp(v.PrimaryPart)
					task.wait(.5)
					StealCar()
					task.wait(1)
					StealCar()
					GetCar():SetPrimaryPartCFrame(old)
					for i,v in pairs(game.Workspace.Paths:GetChildren()) do
						v:Destroy()
					end
				else
					spawn(function()
						Notify("Vertigo Alt Control","Error Occoured Please Try Tp")
					end)
				end
			end
		elseif string.find(Message,",kill") then
			local k = string.split(Message,",kill")[2]
			local targ = string.sub(k,2,string.len(k))
			local p = Instance.new("Part",workspace)
			local Nametrag = GetPlayerName(targ)
			p.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
			game:GetService("ReplicatedStorage").Events.ChangeJob:FireServer("Thug")
			spawn(function()
				Notify("Vertigo Alt Control","Waiting 5s")
			end)
			task.wait(5)
			game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack.Knife)
			TpTween(game.Players[Nametrag].Character.HumanoidRootPart)
			for i,v in pairs(game.Workspace.Paths:GetChildren()) do
				v:Destroy()
			end
			repeat task.wait(.25)
				TpTween(game.Players[Nametrag].Character.HumanoidRootPart,-4)
				game:GetService("ReplicatedStorage").Events.Melee:FireServer(game:GetService("Players").LocalPlayer.Character.Knife,game.Players[Nametrag].Character.Humanoid)
			until game.Players[Nametrag].Character.Humanoid.Health <= 0
			game:GetService("Players").LocalPlayer.Character.Humanoid:UnequipTools()
			spawn(function()
				Notify("Vertigo Alt Control","Killed "..Nametrag)
			end)
			TpTween(p)
			p:Destroy()
			for i,v in pairs(game.Workspace.Paths:GetChildren()) do
				v:Destroy()
			end
		elseif Message == ",fps" then
			if game.Players.LocalPlayer.Name == getgenv().Accounts.Host then 
				game:GetService("RunService"):Set3dRenderingEnabled(true)
				setfpscap(60) 
			else 
				for i,v in pairs(game:GetService("Workspace"):getDescendants()) do
					if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
						v.Material = Enum.Material.SmoothPlastic
					elseif v:IsA("Texture") then
						v:Destroy()
					elseif v:IsA("Image") then
						v:Destroy()
					end
				end
				sethiddenproperty(game:GetService("Workspace").Terrain, "Decoration", false)
				game:GetService("RunService"):Set3dRenderingEnabled(false)
				setfpscap(10)
			end
		elseif Message == ",idle" then
			wait(0.5)local ba=Instance.new("ScreenGui")
			local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
			local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
			ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
			ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true
			ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,370,0,52)
			ca.Font=Enum.Font.SourceSansSemibold;ca.Text="Anti AFK Script"ca.TextColor3=Color3.new(0,1,1)
			ca.TextSize=22;da.Parent=ca
			da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0)
			da.Size=UDim2.new(0,370,0,107)_b.Parent=da
			_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0)
			_b.Size=UDim2.new(0,370,0,21)_b.Font=Enum.Font.Arial;_b.Text="made by choo#8395 "
			_b.TextColor3=Color3.new(0,1,1)_b.TextSize=20;ab.Parent=da
			ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377,0)
			ab.Size=UDim2.new(0,370,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="Status: Active"
			ab.TextColor3=Color3.new(0,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
			game:service'Players'.LocalPlayer.Idled:connect(function()
			bb:CaptureController()bb:ClickButton2(Vector2.new())
			ab.Text="Roblox tried to kick u but i kicked him instead"wait(2)ab.Text="Status : Active"end)
		elseif Message == ",bring" then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts.Host then
				TpTween(game.Players[getgenv().Accounts.Host].Character.HumanoidRootPart)
			end
		elseif Message == ",freeze" then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts.Host then
				game.Players.LocalPlayer.Character.Head.Anchored = true
			end
		elseif Message == ",unfreeze" then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts.Host then
				game.Players.LocalPlayer.Character.Head.Anchored = false
			end
		elseif Message == ",jump" then
			game.Players.LocalPlayer.Character.Humanoid.Jumping = true
		elseif Message == ",shutdown" then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts["Host"] then
				game:Shutdown()
			end
		elseif Message == ",line" then
			for i,v in pairs(GetAlts()) do
				if i == 1 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
				elseif i == 2 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(6,0,0)
				elseif i == 3 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(9,0,0)
				elseif i == 4 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(12,0,0)
				elseif i == 5 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(15,0,0)
				elseif i == 6 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(18,0,0)
				elseif i == 7 then
					game.Players[v].Character.HumanoidRootPart.CFrame = game.Players[getgenv().Accounts["Host"]].Character.HumanoidRootPart.CFrame + Vector3.new(21,0,0)
				end
			end
		elseif string.find(Message,",givemoneyall") then
			local m = string.split(Message,",givemoneyall")[2]
			local mon = string.sub(m,2,string.len(m))
			for i,v in pairs(GetAlts()) do
				task.wait(1.5)
				game:GetService("ReplicatedStorage").Events.GiveMoney:FireServer(v,mon)
			end
		elseif Message == ",returnmoney" then
			if game.Players.LocalPlayer.Name ~= getgenv().Accounts["Host"] then
				game:GetService("ReplicatedStorage").Events.GiveMoney:FireServer(getgenv().Accounts["Host"],game.Players.LocalPlayer.Money.Value)
			end
		elseif Message == ",rejoin" then
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		elseif Message == ",cmds" then
			print("Vertigos Alt Control\n\nLocations { spawn | mine | bank | garage | market | hunt | shed }\n,jump - Makes Character Jump\n,sit - Sits the player\n,freeze - Freezes player\n,unfreeze - Unfreezes the player\n,kill [Args] - args = player name | Kills player by using a knife\n,hbe [Args] - Hit box expander args = true / false\n,advert - Displays the advertising message in chat\n,chat [Args] - Chats the message you sent\n,buy [Args] - Must be exact name of item and will purchase said item\n,cwp [Args] - Create a waypoint for tp\n,tp [Args] - Normal tp to location\n,ctp [Args] - Car tp MUST BE IN CAR\n,spawn [Args] - Spawn car name\n,bring - Brings all accounts to host\n,stealcar - Steals the car near you\n,carmod - Makes car very fast\n,fps - Boosts fps on alts\n,idle - Anti afk\n,returnmoney - Gives the alts money to the host\n,givemoneyall [Args] - Give alts the args ammount\n,line - Lines up all alts\n,rejoin - Makes all accounts rejoin\n,cmds - shows this")		end
	end
end)

spawn(function()
	Notify("Vertigo Alt Control","Loaded")
end)
