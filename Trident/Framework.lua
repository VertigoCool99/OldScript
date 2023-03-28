local oldtick = tick()
print("Loading")
--Locals
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle
local Mouse = game.Players.LocalPlayer:GetMouse()
local RunService = Game:GetService("RunService")

--Tables
local Framework = {}
local Esp = {Settings={Boxes=false,Distances=false,Armor=false,ItemDistances=false,ItemNames=false,OreDistances=false,OreNames=false,PlayerRenderDistance=1000,ItemRenderDistance=1000,OreRenderDistance=1000,PlayerBoxColor=Color3.fromRGB(120,81,169),PlayerDistanceColor=Color3.fromRGB(120,81,169),PlayerArmorColor=Color3.fromRGB(120,81,169),LocalChamsColor=Color3.fromRGB(120,81,169),LocalChamsMaterial=Enum.Material.ForceField},Drawings={},Connections={}}
local Crosshair = {Enabled=false,CrosshairThickness=2,CrosshairSize=8,CrosshairColor=Color3.fromRGB(255,0,255),X,Y}
local Aimbot = {Settings={FovEnabled=false,FovTransparency=1,FovSize=90,FovFilled=false,FovColor=Color3.fromRGB(120,81,169)},Fov={},FovCircleDrawing=nil,AimbotHitpart="Head"}
local AllowedOres = {"StoneOre","NitrateOre","IronOre"}
local AllowedItems = {"PartsBox","MilitaryCrate","SnallBox","SnallBox","Backpack","VendingMachine"}

--Functions
function Framework:IsVisible(PlayerModel)
    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {game:GetService("Workspace").Ignore}
    Params.FilterType = Enum.RaycastFilterType.Blacklist

    ray = game:GetService("Workspace"):Raycast(Camera.CFrame.p, PlayerModel:GetPivot().p, Params)
    if ray.Instance:IsDescendantOf(PlayerModel) then
        return true
    else
        return
    end
end
function Framework:GetCenterScreen()
    return Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
end
function Framework:ReplaceSound(SoundName,NewId)
    game:GetService("SoundService")[SoundName].SoundId = NewId
end
function Framework:CreateConnection(Object,Callback)
    local Connection = Object:Connect(Callback)
    table.insert(Esp.Connections, connection)
    return Connection
end
function Framework:GetArmor(Model)
    if Model.Armor:FindFirstChildOfClass("Model") then
        return true
    else
        return false
    end
end
function Framework:GetHoldingTool()
    if getrenv()._G.modules.FPS.GetEquippedItem().id == nil then return "None" end
    return getrenv()._G.modules.FPS.GetEquippedItem().id
end
function Framework:GetEntitys()
    return getrenv()._G.modules.Entity.List
end
function Framework:GetPlayers()
    return getupvalues(getrenv()._G.modules.Player.GetPlayerModel)[1]
end
function Framework:DistanceFromCharacter(Vector3)
    return (CharcaterMiddle:GetPivot().p - Vector3).Magnitude
end
function Framework:IsOnScreen(Model)
    local RandomVar, OnScreen = Camera:WorldToViewportPoint(Model:GetPivot().p)
    return OnScreen
end
function Framework:PositionToVector2(Vector3)
    local ViewportPosition, onscreen = Camera:WorldToViewportPoint(Vector3)
    return Vector2.new(ViewportPosition.X,ViewportPosition.Y), onscreen
end
function Framework:MoveMouse(PositionX,PositionY,Smoothing) --Provide Characters X And Y As It Takes Off Mouse
    NewPos = Vector2.new(Mouse.X-PositionX, Mouse.Y-PositionY)
    mousemoverel((-NewPos.X*0.5)/Smoothing,(-NewPos.Y*0.5)/Smoothing)
end
function Framework:Draw(Type,Propities)
    Object = Drawing.new(Type)
    for i,v in next,Propities do
        Object[i] = v
    end
    table.insert(Esp.Drawings, Object)
    return Object
end
function Framework:ItemToColor(Item)
    table = {}
    table["PartsBox"] = Color3.new(0.929,0.973,0.796)
    table["MilitaryCrate"] = Color3.new(0.075,0.353,0.086)
    table["SnallBox"] = Color3.new(0.263,0.200,0.075)
    table["MediumBox"] = Color3.new(0.404,0.302,0.094)
    table["Backpack"] = Color3.new(0.404,0.302,0.094)
    table["VendingMachine"] = Color3.new(0.192,0.478,0.988)
    table["StoneOre"] = Color3.new(0.612,0.612,0.612)
    table["IronOre"] = Color3.new(0.773,0.686,0.365)
    table["NitrateOre"] = Color3.new(1,1,1)
    return table[Item]
end

function Esp:LocalChams()
    for i,v in pairs(game:GetService("Workspace").Ignore.FPSArms:GetChildren()) do
        if v:IsA("MeshPart") then
            v.Color = Esp.Settings.LocalChamsColor
            v.Material = Esp.Settings.LocalChamsMaterial
            Esp.Connections.UpdateLocalChams = Framework:CreateConnection(RunService.RenderStepped,function()
                v.Color = Esp.Settings.LocalChamsColor
                v.Material = Esp.Settings.LocalChamsMaterial
            end)
        end
    end
end

function Esp:CreateCrosshair()
    do
        Crosshair.X = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.Y = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.X.From = Framework:GetCenterScreen() - Vector2.new(0,Crosshair.CrosshairSize)
        Crosshair.X.To = Framework:GetCenterScreen() + Vector2.new(0,Crosshair.CrosshairSize)
        Crosshair.Y.From = Framework:GetCenterScreen() - Vector2.new(Crosshair.CrosshairSize,0)
        Crosshair.Y.To = Framework:GetCenterScreen() + Vector2.new(Crosshair.CrosshairSize,0)
        Crosshair.X.Visible = Crosshair.Enabled
        Crosshair.Y.Visible = Crosshair.Enabled
        Esp.Connections.UpdateCrosshair = Framework:CreateConnection(RunService.RenderStepped,function()
            Crosshair.X.Color=Crosshair.CrosshairColor
            Crosshair.X.Thickness=Crosshair.CrosshairThickness
            Crosshair.Y.Color=Crosshair.CrosshairColor
            Crosshair.Y.Thickness=Crosshair.CrosshairThickness
            Crosshair.X.From = Framework:GetCenterScreen() - Vector2.new(0,Crosshair.CrosshairSize)
            Crosshair.X.To = Framework:GetCenterScreen() + Vector2.new(0,Crosshair.CrosshairSize)
            Crosshair.Y.From = Framework:GetCenterScreen() - Vector2.new(Crosshair.CrosshairSize,0)
            Crosshair.Y.To = Framework:GetCenterScreen() + Vector2.new(Crosshair.CrosshairSize,0)
            Crosshair.X.Visible = Crosshair.Enabled
            Crosshair.Y.Visible = Crosshair.Enabled
        end)
    end
end

--Esp Loops
do
    function Esp:AddOre(Item)
        local e={Drawings={}}
        e.Drawings.distance = Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9})
        e.Drawings.name = Framework:Draw("Text",{Text="",Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9})
        function e:Clear()
            Esp.Connections.OreUpdate:Disconnect()
            for i,v in next, Drawings do
                v:Remove()
            end
        end
        Esp.Connections.OreUpdate = Framework:CreateConnection(RunService.RenderStepped,function()
            if Item ~= nil then
                if Item.model then
                    local pos2 = Camera:WorldToViewportPoint(Item.model:GetPivot().p)
                    pos = Vector2.new(pos2.X,pos2.Y)
                    if Framework:IsOnScreen(Item.model) and Framework:DistanceFromCharacter(Item.model:GetPivot().p) <= Esp.Settings.OreRenderDistance then
                        print(Esp.Settings.OreDistances)
                        if Esp.Settings.OreDistances == true then
                            e.Drawings.distance.Visible = true
                            e.Drawings.distance.Color = Framework:ItemToColor(tostring(Item.typ))
                            e.Drawings.distance.Text = tostring(math.floor(Framework:DistanceFromCharacter(Item.model:GetPivot().p))).." Studs"
                            e.Drawings.distance.Position = pos-Vector2.new(0,e.Drawings.distance.TextBounds.Y)
                        else
                            e.Drawings.distance.Visible = false
                        end
                        if Esp.Settings.OreNames == true then
                            e.Drawings.name.Visible = true
                            e.Drawings.name.Color = Framework:ItemToColor(tostring(Item.typ))
                            e.Drawings.name.Text = Item.typ
                            e.Drawings.name.Position = pos
                        else
                            e.Drawings.name.Visible = false
                        end
                    else
                        for i,v in next, e.Drawings do
                            v.Visible = false
                        end
                    end
                else
                    for i,v in next, e.Drawings do
                        v.Visible = false
                    end
                end
            else
                e:Clear()
            end
        end)
    end
end
do
    function Esp:AddItem(Item)
        local e={Drawings={}}
        e.Drawings.distance = Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9})
        e.Drawings.name = Framework:Draw("Text",{Text = Type,Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9})
        function e:Clear()
            Esp.Connections.ItemUpdate:Disconnect()
            for i,v in next, Drawings do
                v:Remove()
            end
        end
        Esp.Connections.ItemUpdate = Framework:CreateConnection(RunService.RenderStepped,function()
            if Item ~= nil then
                if Item.model then
                    local pos2 = Camera:WorldToViewportPoint(Item.model:GetPivot().p)
                    pos = Vector2.new(pos2.X,pos2.Y)
                    if Framework:IsOnScreen(Item.model) and Framework:DistanceFromCharacter(Item.model:GetPivot().p) <= Esp.Settings.ItemRenderDistance then
                        if Esp.Settings.ItemDistances == true then
                            e.Drawings.distance.Visible = true
                            e.Drawings.distance.Color = Framework:ItemToColor(tostring(Item.typ))
                            e.Drawings.distance.Text = tostring(math.floor(Framework:DistanceFromCharacter(Item.model:GetPivot().p))).." Studs"
                            e.Drawings.distance.Position = pos-Vector2.new(0,e.Drawings.distance.TextBounds.Y)
                        else
                            e.Drawings.distance.Visible = false
                        end
                        if Esp.Settings.ItemNames == true then
                            e.Drawings.name.Visible = true
                            e.Drawings.name.Color = Framework:ItemToColor(tostring(Item.typ))
                            e.Drawings.name.Text = Item.typ
                            e.Drawings.name.Position = pos
                        else
                            e.Drawings.name.Visible = false
                        end
                    else
                        for i,v in next, e.Drawings do
                            v.Visible = false
                        end
                    end
                else
                    for i,v in next, e.Drawings do
                        v.Visible = false
                    end
                end
            else
                e:Clear()
            end
        end)
    end
end
do 
    function Esp:AddPlayer(Player)
        local e={Drawings={}}
        e.Drawings.Box = Framework:Draw("Square",{Thickness=1,Filled=false,Color = Esp.Settings.PlayerBoxColor,ZIndex = -9})
        e.Drawings.BoxOutline = Framework:Draw("Square",{Thickness=2,Filled=false,Color = Color3.fromRGB(0,0,0),ZIndex = -10})
        e.Drawings.Distance = Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerDistanceColor,ZIndex = -9})
        e.Drawings.Armor = Framework:Draw("Text",{Text = "Nil",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerArmorColor,ZIndex = -9})
        function e:Clear()
            Esp.Connections.Update:Disconnect()
            for i,v in next, Drawings do
                v:Remove()
            end
        end
        Esp.Connections.Update = Framework:CreateConnection(RunService.RenderStepped,function()
            if Player ~= nil then
                if Player.model and Player.model:FindFirstChild("HumanoidRootPart") then
                    if Framework:IsOnScreen(Player.model) and Framework:DistanceFromCharacter(Player.model:GetPivot().p) <= Esp.Settings.PlayerRenderDistance then
                        local pos2, onscreen = Camera:WorldToViewportPoint(Player.model:GetPivot().p)
                        local Size = (Camera:WorldToViewportPoint(Player.model:GetPivot().p - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(Player.model:GetPivot().p + Vector3.new(0, 2.6, 0)).Y) / 2
                        local BoxSize = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
                        local pos = Vector2.new(math.floor(pos2.X - Size * 1.5 / 2), math.floor(pos2.Y - Size * 1.6 / 2))
                        
                        if pos and BoxSize then
                            do
                                if Esp.Settings.Boxes == true then
                                    e.Drawings.Box.Position = pos
                                    e.Drawings.Box.Size = BoxSize
                                    e.Drawings.Box.Color = Esp.Settings.PlayerBoxColor
                                    e.Drawings.BoxOutline.Position = e.Drawings.Box.Position
                                    e.Drawings.BoxOutline.Size = e.Drawings.Box.Size
                                    e.Drawings.Box.Visible = true
                                    e.Drawings.BoxOutline.Visible = true
                                else
                                    e.Drawings.Box.Visible = false
                                    e.Drawings.BoxOutline.Visible = false
                                end
                            end
                            do
                                if Esp.Settings.Distances == true then
                                    e.Drawings.Distance.Visible = true
                                    e.Drawings.Distance.Color = Esp.Settings.PlayerDistanceColor
                                    e.Drawings.Distance.Text = tostring(math.floor(Framework:DistanceFromCharacter(Player.model:GetPivot().p))).." Studs"
                                    if e.Drawings.Box.Visible == true then
                                        e.Drawings.Distance.Position = e.Drawings.Box.Position + Vector2.new(BoxSize.X/2,e.Drawings.Box.Size.Y)
                                    else
                                        e.Drawings.Distance.Position = e.Drawings.Box.Position + Vector2.new(BoxSize.X/2,-e.Drawings.Armor.TextBounds.Y)
                                    end
                                else
                                    e.Drawings.Distance.Visible = false
                                end
                            end
                            do
                                if Esp.Settings.Armor then
                                    if Framework:GetArmor(Player.model) == true then e.Drawings.Armor.Text = "Has Armor" else e.Drawings.Armor.Text = "No Armor" end
                                    e.Drawings.Armor.Visible = true
                                    e.Drawings.Armor.Color = Esp.Settings.PlayerArmorColor
                                    if e.Drawings.Box.Visible == true then
                                        e.Drawings.Armor.Position = e.Drawings.Box.Position + Vector2.new(BoxSize.X/2, -e.Drawings.Armor.TextBounds.Y)
                                    else
                                        e.Drawings.Armor.Position = pos + Vector2.new(BoxSize.X/2, - e.Drawings.Armor.TextBounds.Y)
                                    end
                                else
                                    e.Drawings.Armor.Visible = false
                                end
                            end
                        else
                            for i,v in next, e.Drawings do
                                v.Visible = false
                            end
                        end
                    else
                        for i,v in next, e.Drawings do
                            v.Visible = false
                        end
                    end
                else
                    for i,v in next, e.Drawings do
                        v.Visible = false
                    end
                end
            else
                e:Clear()
            end
        end)
    end
end

function Aimbot:GetProjectileInfo()
    if getrenv()._G.modules.FPS.GetEquippedItem() == nil then return false end
    local mod = require(game:GetService("ReplicatedStorage").ItemConfigs[getrenv()._G.modules.FPS.GetEquippedItem().id])
    if table.find(mod, "ProjectileSpeed") then
        PS,PD = mod.projectileSpeed, mod.projectileDrop        
        return PS,PD
    end
    return nil
end
function Aimbot:CreateFov()
    FovCircle = Framework:Draw("Circle",{Visible=Aimbot.Settings.FovEnabled,Transparency=Aimbot.Settings.FovTransparency})
    FovCircle.Visible = Aimbot.Settings.FovEnabled
    FovCircle.Transparency=Aimbot.Settings.FovTransparency
    FovCircle.Thickness=2
    FovCircle.NumSides=120
    FovCircle.Radius=Aimbot.Settings.FovSize
    FovCircle.Filled=Aimbot.Settings.FovFilled
    FovCircle.Color=Aimbot.Settings.FovColor
    FovCircle.Position=Framework:GetCenterScreen()
    Aimbot.FovCircleDrawing = FovCircle
end
function Aimbot:InFov(Model)
    if not Model then return false end
    local playerpos = Camera:WorldToViewportPoint(Model:GetPivot().p)
    local distance = (Aimbot.FovCircleDrawing.Position - Vector2.new(playerpos.X,playerpos.Y)).magnitude
    if distance <= Aimbot.FovCircleDrawing.Radius then
        return true
    end
    return false
end
function Aimbot:GetClosest(Type)
    if not Type then Type = "Character" end
    if Type == "Fov" then
        local closest, distance = nil,math.huge
        for i, v in pairs(Framework:GetPlayers()) do
            if v and v.model and v.model:FindFirstChild(Aimbot.AimbotHitpart) and Aimbot:InFov(v.model) == true then
                local playerpos = Camera:WorldToViewportPoint(v.model:GetPivot().p)
                local magnitude = (Vector2.new(playerpos.X, playerpos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if magnitude < distance then
                    closest = v.model
                    distance = magnitude
                end
            end
        end
        return closest
    elseif Type == "Character" then
        local nearestPlayer, nearestDistance
        local dist = math.huge
        for i,v in pairs(Framework:GetPlayers()) do 
            if v and v.model and v.model:FindFirstChild(Aimbot.AimbotHitpart) then
                local newdist = Framework:DistanceFromCharacter(v.model:GetPivot().p)
                if newdist < dist then
                    dist = newdist
                end
            end
            nearestPlayer = v.model
        end
        return nearestPlayer
    end
end
print("Loaded In: "..tick()-oldtick)

return Framework, Esp, Aimbot, Crosshair
