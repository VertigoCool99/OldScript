getgenv().AutoMiner = true
getgenv().AutoSmelt = true --PLACE A PLOT WITH A SMELTER ON ELSE IT WONT WORK
local highlights = Instance.new('Folder', game:service'CoreGui')

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

local last = game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value
local sold = "nil"

Link = 'https://discordapp.com/api/webhooks/996180810732421240/yR1gxaKwCna_-Z02I0GOzZyCBzD5tIgAdISZ6XRxrX9D63-4efo1cDHfGCtCCtSZcV79'
local id = 0

function Init()
    local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "**Dark Rp - Miner**",
        ["fields"] = {
            {
                ["name"] = ":moneybag: Money:",
                ["value"] =  tostring("```\n$"..tostring(game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.Text).."```"),
                ["inline"] = true
            },
            {
                ["name"] = (":bar_chart: Money Made:"),
                ["value"] =  tostring("```\n"..game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value - last.."```"),
                ["inline"] = true
            },
            {
                ["name"] = ":pick: Last Sold:",
                ["value"] =  tostring("```\n"..sold.."```"),
                ["inline"] = false
            },
        },
        ["color"] = tonumber(0xd4af37),
        },
    }    
}
    local json = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    requeste = syn.request or request
    id = game:GetService("HttpService"):JSONDecode(requeste({Url = Link.."?wait=true", Body = json, Method = "POST", Headers = headers}).Body).id
end

function Edit()
    local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "**Dark Rp - Miner**",
        ["fields"] = {
            {
                ["name"] = ":moneybag: Money:",
                ["value"] =  tostring("```\n$"..tostring(game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.Text).."```"),
                ["inline"] = true
            },
            {
                ["name"] = (":bar_chart: Money Made:"),
                ["value"] =  tostring("```\n"..game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value - last.."```"),
                ["inline"] = true
            },
            {
                ["name"] = ":pick: Last Sold:",
                ["value"] =  tostring("```\n"..sold.."```"),
                ["inline"] = false
            },
        },
        ["color"] = tonumber(0xd4af37),
        },
    }    
}
    local json = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    requeste = syn.request or request
    requeste({Url = ("%s/messages/%s"):format(Link,id).."?wait=true", Body = json, Method = "PATCH", Headers = headers})
end

Init()

game:GetService("ReplicatedStorage").Events.ChangeJob:FireServer("Miner")
inst = 0
function Tp(dest)
    Edit()
    if inst == 3 then
        inst = 0
        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - dest.Position).Magnitude
    	tps = dist/tonumber(250)
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
                tweenspeed = dist/tonumber(200)
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

function GetRock()
    for i,v in pairs(game:GetService("Workspace").Map["Mining Rocks"]:GetChildren()) do
        if v.mine.health.Value ~= 0 then
            local highlight = Instance.new('Highlight', highlights)
            highlight.Adornee = v
            highlight.FillColor = Color3.fromRGB(124,252,0)
            highlight.FillTransparency = .75
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            return v
        end
    end
end

function Mine(Rock)
    Tp(Rock)
    repeat task.wait()
        game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(Rock.mine, {[1] = "Mine",[2] = "E"})
        task.wait()
        game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(Rock.mine, {[1] = "Mine",[2] = "E"})
        task.wait()
        game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(Rock.mine, {[1] = "Mine",[2] = "E"})
        task.wait()
        game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(Rock.mine, {[1] = "Mine",[2] = "E"})
        Tp(Rock)
    until Rock.mine.health.Value == 0
    for i,v in pairs(game:GetService("CoreGui").Folder:GetChildren()) do
        v:Destroy() 
    end
end

repeat task.wait(.1)
    if game.Players.LocalPlayer.Backpack:FindFirstChild("Pickaxe") then
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Pickaxe"))
    end
    for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if string.find(v.Name, "Ore") then
            if getgenv().AutoSmelt == true then
                game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(workspace[game.Players.LocalPlayer.Name.."-Plot"].Smelter.Part.smelter, {[1] = "Process Ores",[2] = "E"}) 
                sold = tostring(v.Name)
            else
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name))
                game:GetService("ReplicatedStorage").Events.DropItem:FireServer()
                wait(1)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name))
            end
        else
            game:GetService("ReplicatedStorage").Events.Trader2:FireServer(v.Name)
            task.wait(.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Pickaxe"))
            sold = tostring(v.Name)
        end
        print(sold)
    end
    Mine(GetRock())
until getgenv().AutoMiner == false
