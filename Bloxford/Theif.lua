getgenv().AutoTheif = true
getgenv().SafePlace = CFrame.new(546, 152, 43)
getgenv().AutoGive = true
getgenv().Host = "MyAxeBase"
local highlights = Instance.new('Folder', game:service'CoreGui')

hostin = false
game.Players.PlayerAdded:Connect(function()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Name == getgenv().Host then
            hostin = true
        end
    end
end)
for i,v in pairs(game.Players:GetPlayers()) do
    if v.Name == getgenv().Host then
        hostin = true
    end
end

if game.Workspace:FindFirstChild("Paths") then else
    safe = Instance.new("Part")
    e = Instance.new("Folder")
    e.Parent = game.Workspace
    e.Name = "E"
    safe.Parent = game.Workspace.E
    safe.CFrame = getgenv().SafePlace
    safe.Anchored = true
    safe.CanCollide = false
    safe.Transparency = 1
    Paths = Instance.new("Folder")
    Paths.Parent = game.Workspace
    Paths.Name = "Paths"
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Seat") then
            v:Destroy() 
        end
    end
end

game:GetService("ReplicatedStorage").Events.ChangeJob:FireServer("Theif")

local last = game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value
Link = 'https://discordapp.com/api/webhooks/996180810732421240/yR1gxaKwCna_-Z02I0GOzZyCBzD5tIgAdISZ6XRxrX9D63-4efo1cDHfGCtCCtSZcV79'
local id = 0

function GiveMoney()
    if hostin == true then
        if game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value <= 100000 then
            game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.Player.Text = getgenv().Host
            game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.Amount.Text = game.Players.LocalPlayer.PlayerGui.InfoBar.Frame.Money.Money.mon.Value
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.TextButton.MouseButton1Down)
        else
            game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.Player.Text = getgenv().Host
            game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.Amount.Text = 100000
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Menu.Frame.Actions.ScrollingFrame.GiveMoney.TextButton.MouseButton1Down)
        end
    end
end

ship = 0
printerss = 0 

function Init()
    local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "**Dark Rp - Thief**",
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
                ["name"] = (":printer: Printers:"),
                ["value"] =  tostring("```\n"..printerss.."```"),
                ["inline"] = false
            },
            {
                ["name"] = (":card_box: Shipments:"),
                ["value"] =  tostring("```\n"..ship.."```"),
                ["inline"] = false
            },
        },
        ["color"] = tonumber(0xff0000),
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
        ["title"] = "**Dark Rp - Thief**",
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
                ["name"] = (":printer: Printers:"),
                ["value"] =  tostring("```\n"..printerss.."```"),
                ["inline"] = false
            },
            {
                ["name"] = (":card_box: Shipments:"),
                ["value"] =  tostring("```\n"..ship.."```"),
                ["inline"] = false
            },
        },
        ["color"] = tonumber(0xff0000),
        },
    }    
}
    local json = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    requeste = syn.request or request
    requeste({Url = ("%s/messages/%s"):format(Link,id).."?wait=true", Body = json, Method = "PATCH", Headers = headers})
end

Init()

inst = 0
function Tp(dest)
    Edit()
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

function getPrinter()
    GiveMoney()
    for i,v in pairs(highlights:GetChildren()) do
       v:Destroy() 
    end
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if string.find(v.Name, "Printer") then
            printerss = i
            if v:FindFirstChild("Main") and v.Main.moneyprinter.health.Value ~= 0 and v.Main.moneyprinter.money.Value ~= 0 and v.Main.moneyprinter.beingCarried.Value == false then
                local highlight = Instance.new('Highlight', highlights)
                highlight.Adornee = v
                highlight.FillColor = Color3.fromRGB(124,252,0)
                highlight.FillTransparency = .75
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                return v.Main
            end
        end
    end
end

function getShipment()
    for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
        if string.find(v.Name, "Shipment") then
            ship = i
            if v:FindFirstChild("shipment") and v.shipment.amount.Value ~= 0 then
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
end

function stealPrinterCash(printer)
    if printer ~= nil then 
        Tp(printer)
        repeat task.wait(.1)
            Tp(printer)
            game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(printer.moneyprinter, {[1] = "Collect",[2] = "E"})
        until printer.moneyprinter.money.Value == 0
    end
end

function stealShipments(shipment)
    if shipment ~= nil then 
        Tp(shipment)
        repeat task.wait(.1)
            Tp(shipment)
            game:GetService("ReplicatedStorage").Events.ActionHandler2:FireServer(shipment.shipment, {[1] = "Take 1",[2] = "E"})
        until shipment.shipment.amount.Value == 0
    end
end

repeat task.wait()
    stealPrinterCash(getPrinter())
    stealShipments(getShipment())
until getgenv().AutoTheif == false
