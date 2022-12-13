game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Text = "!p"
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.FocusLost,true)
    
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local Settings = {Target="",FileName="",BuildSpeed="Normal",RantimeReset=150,ForceBtools=false,IsBuilding=false}
local Window = Material.Load({Title = "Town",Style = 3,SizeX = 360,SizeY = 300,Theme = "Dark"})
local PlotTab = Window.New({Title = "Plot"})
local speeds = {Normal=.3,Fast=.27,Slow=1}

makefolder("townPlots")
function SaveBase(Player)
    local Saved = {}
    table.clear(Saved)
    local MyPlot = game:GetService("Workspace")["Private Building Areas"][game.Players.LocalPlayer.Name.."BuildArea"].Build
    local Plot = game:GetService("Workspace")["Private Building Areas"][Player.."BuildArea"].Build
    for i,v in pairs(Plot:GetChildren())do
        if v:IsA("Folder") then
            for i2,v2 in pairs(v:GetChildren()) do
               v2.Parent = Plot
            end
        end
        if v:IsA("Model") then
            for i3,v3 in pairs(v:GetChildren()) do
               v3.Parent = Plot
            end
        end
        
        if v:IsA("BasePart") then
            local childs = {}
            table.clear(childs)
            local Offset = v.Position - Plot.Parent.Position
            local x,y,z = v.CFrame:toEulerAnglesXYZ()
            if v:FindFirstChild("SpotLight") then
               table.insert(childs,{Type=v.SpotLight.Name,Color={R=v.SpotLight.Color.R,G=v.SpotLight.Color.G,B=v.SpotLight.Color.B},Brightness=tonumber(v.SpotLight.Brightness),Range=tonumber(v.SpotLight.Range),Angle=tonumber(v.SpotLight.Angle),Side=tostring(v.SpotLight.Face),Shadows=v.SpotLight.Shadows})
            end
            if v:FindFirstChild("SurfaceLight") then
                table.insert(childs,{Type=v.SurfaceLight.Name,Color={R=v.SurfaceLight.Color.R,G=v.SurfaceLight.Color.G,B=v.SurfaceLight.Color.B},Range=tonumber(v.SurfaceLight.Range),Brightness=tonumber(v.SurfaceLight.Brightness),Shadows=v.SurfaceLight.Shadows})
            elseif v:FindFirstChild("PointLight") then
                table.insert(childs,{Type=v.PointLight.Name,Color={R=v.PointLight.Color.R,G=v.PointLight.Color.G,B=v.PointLight.Color.B},Range=tonumber(v.PointLight.Range),Brightness=tonumber(v.PointLight.Brightness),Shadows=v.PointLight.Shadows})
            elseif v:FindFirstChild("Mesh") then
                table.insert(childs,{Type=v.Mesh.Name,MeshType=tostring(v.Mesh.MeshType),MeshId=v.Mesh.MeshId,Scale={X=v.Mesh.Scale.X,Y=v.Mesh.Scale.Y,Z=v.Mesh.Scale.Z},Offset={X=v.Mesh.Offset.X,Y=v.Mesh.Offset.Y,Z=v.Mesh.Offset.Z},TextureId=tostring(v.Mesh.TextureId),Tint={X=v.Mesh.VertexColor.X,Y=v.Mesh.VertexColor.Y,Z=v.Mesh.VertexColor.Z}})
            elseif v:FindFirstChild("Decal") then
                table.insert(childs,{Type=v.Decal.Name,Face=tostring(v.Decal.Face),Texture=tostring(v.Decal.Texture),Transparency=v.Decal.Transparency})
            elseif v:FindFirstChild("Texture") then
                table.insert(childs,{Type=v.Texture.Name,Face=tostring(v.Texture.Face),Texture=tostring(v.Texture.Texture),Transparency=v.Texture.Transparency,Repeat={X=v.Texture.StudsPerTileU,Y=StudsPerTileV}})
            end
            table.insert(Saved,{Type=v.Name,Offset={X=Offset.X,Y=Offset.Y,Z=Offset.Z},Size={X=v.Size.X,Y=v.Size.Y,Z=v.Size.Z},Rotation={X=v.Rotation.X,Y=v.Rotation.Y,Z=v.Rotation.Z},Color={R=v.Color.R,G=v.Color.G,B=v.Color.B},Material=tostring(v.Material),Transparency=v.Transparency,CanCollide=v.CanCollide,Angle={X=x,Y=y,Z=z},Children=childs})
        end
    end
    return Saved
end

function Light(Table,Part)
    if Part and Table and Table.Type == "SpotLight" or Part and Table and Table.Type == "SurfaceLight" then
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateLights",{[1]={["Part"]=Part,["LightType"]=tostring(Table.Type)}})
        task.wait(.03)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncLighting",{[1]={["Part"]=Part,["LightType"]=tostring(Table.Type),["Color"]=Color3.new(Table.Color.R,Table.Color.B,Table.Color.B),["Range"]=Table.Range,["Angle"]=Table.Angle,["Side"]=Enum.NormalId[Table.Side:reverse():split(".")[1]:reverse()],["Shadows"]=Table.Shadows}})
    elseif Part and Table and Table.Type == "PointLight" then
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateLights",{[1]={["Part"]=Part,["LightType"]=tostring(Table.Type)}})
        task.wait(.03)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncLighting",{[1]={["Part"]=Part,["LightType"]=tostring(Table.Type),["Color"]=Color3.new(Table.Color.R,Table.Color.B,Table.Color.B),["Range"]=Table.Range,["Shadows"]=Table.Shadows}})
    end
end

function Mesh(Table,Part)
    if Table.TextureId == "" then
       Table.TextureId = "rbxassetid://0" 
    end
    if Table.MeshId then
        table.foreach(Table,print)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateMeshes",{[1]={["Part"]=Part}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["MeshType"]=Enum.MeshType.FileMesh}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["MeshId"]=Table.MeshId}})
        task.wait(.02)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["Scale"]=Vector3.new(Table.Scale.X,Table.Scale.Y,Table.Scale.Z)}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["Offset"]=Vector3.new(Table.Offset.X,Table.Offset.Y,Table.Offset.Z)}})
        task.wait(.02)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["TextureId"]=Table.TextureId}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["VertexColor"]=Vector3.new(Table.Tint.X,Table.Tint.Y,Table.Tint.Z)}})
    else
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateMeshes",{[1]={["Part"]=Part}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMesh",{[1]={["Part"]=Part,["MeshType"]=Enum.MeshType[Table.MeshType:reverse():split(".")[1]:reverse()],["Scale"]=Vector3.new(Table.Scale.X,Table.Scale.Y,Table.Scale.Z),["Offset"]=Vector3.new(Table.Offset.X,Table.Offset.Y,Table.Offset.Z)}})
    end   
end

function Decal(Part,Table)
    if Table and Part and Table.Type == "Decal" then
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateTextures",{[1]={["Part"]=Part,["Face"]=Enum.NormalId[Table.Face:reverse():split(".")[1]:reverse()],["TextureType"]=Table.Type}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncTexture",{[1]={["Part"]=Part,["Face"]=Enum.NormalId[Table.Face:reverse():split(".")[1]:reverse()],["TextureType"]=Table.Type,["Texture"]=Table.Texture}})
    else
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreateTextures",{[1]={["Part"]=Part,["Face"]=Enum.NormalId[Table.Face:reverse():split(".")[1]:reverse()],["TextureType"]=Table.Type}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncTexture",{[1]={["Part"]=Part,["Face"]=Enum.NormalId[Table.Face:reverse():split(".")[1]:reverse()],["TextureType"]=Table.Type,["Texture"]=Table.Texture,["StudsPerTileU"]=Table.Repeat.X,["StudsPerTileV"]=Table.Repeat.Y}})
    end
end

--COLOR  Color3.new(Table.Color.R,Table.Color.B,Table.Color.B)
--ENUMS  Enum.Material[Table.Material:reverse():split(".")[1]:reverse()]
--CFRAME CFrame.new(Table.CFrame.X,Table.CFrame.Y,Table.CFrame.Z)

function GetPlayers()
    local tbl = {}
    table.clear(tbl)
    for i,v in pairs(game.Players:GetPlayers()) do
        if not table.find(tbl,v.Name) then
            table.insert(tbl,v.Name)   
        end
    end
    return tbl
end

local drop = PlotTab.Dropdown({
    Text="Players",
    Callback= function(Value)
        Settings.Target = Value
    end,
    Options = GetPlayers(),
})
game.Players.PlayerAdded:Connect(function()
    drop:SetOptions(GetPlayers())
end)
game.Players.PlayerRemoving:Connect(function()
    drop:SetOptions(GetPlayers())
end)
local Statsus;

PlotTab.TextField({
    Text="File Name",
    Callback = function(Value)
        Settings.FileName = Value
    end,
})
local speed = PlotTab.Dropdown({
    Text="Build Speed",
    Callback= function(Value)
        Settings.BuildSpeed = Value
    end,
    Options = {"Fast","Normal","Slow"},
})
PlotTab.Button({
    Text = "Save Plot",
    Callback = function()
        writefile("townPlots/"..Settings.FileName..".plot",game:GetService("HttpService"):JSONEncode(SaveBase(Settings.Target)))
        Statsus:SetText("Saved Plot! | "..Settings.FileName)
    end,
})
PlotTab.Button({
    Text = "Load Plot",
    Callback = function()
        LoadBase(game:GetService("HttpService"):JSONDecode(readfile("townPlots/"..Settings.FileName..".plot")))
    end,
})
Statsus = PlotTab.Button({Text = "Status: Waiting!"})

function SaveInGame(Name)
   game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Text = "!svp "..Name
    firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.FocusLost,true) 
end

function CreatePart(Table)
    local MyPlot = game:GetService("Workspace")["Private Building Areas"][game.Players.LocalPlayer.Name.."BuildArea"].Build
    local newCFrame = MyPlot.Parent.CFrame + Vector3.new(Table.Offset.X,Table.Offset.Y,Table.Offset.Z)
    local newPosition = MyPlot.Parent.Position + Vector3.new(Table.Offset.X,Table.Offset.Y,Table.Offset.Z)
    if Table.Type == "Part" then
        local Part = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreatePart","Normal",newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z),MyPlot)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncResize",{[1] = {["Part"] = Part,["CFrame"]=newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z),["Size"]=Vector3.new(Table.Size.X,Table.Size.Y,Table.Size.Z)}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncColor",{[1]={["Part"]=Part,["Color"]=Color3.fromRGB(math.round(Table.Color.R*255),math.round(Table.Color.G*255),math.round(Table.Color.B*255)),["UnionColoring"] = true}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMaterial",{[1]={["Part"]=Part,["Material"]=Enum.Material[Table.Material:reverse():split(".")[1]:reverse()]}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMaterial",{[1]={["Part"]=Part,["Transparency"]=Table.Transparency}})
        task.wait(.1)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncCollision",{[1]={["Part"]=Part,["CanCollide"]=Table.CanCollide}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncRotate",{[1]={["Part"]=Part,["CFrame"]=newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z)}})
        if Table.Children[1] and Table.Children[1].Type == "PointLight" or Table.Children[1] and Table.Children[1].Type == "SpotLight" or Table.Children[1] and Table.Children[1].Type == "SurfaceLight" then
            Light(Table.Children,Part)
        end
        if Table.Children[1] and Table.Children[1].Type == "Mesh" then
            Mesh(Table.Children[1],Part)
        end
        if Table.Children[1] and Table.Children[1].Type == "Decal" or Table.Children[1] and Table.Children[1].Type == "Texture" then
            Decal(Part,Table.Children[1])
        end
    elseif Table.Type == "Wedge" or Table.Type == "Truss" or Table.Type == "Corner" or Table.Type == "Seat" or Table.Type == "VehicleSeat" then
        local Part = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("CreatePart",Table.Type,newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z),MyPlot)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncResize",{[1] = {["Part"] = Part,["CFrame"]=newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z),["Size"]=Vector3.new(Table.Size.X,Table.Size.Y,Table.Size.Z)}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncColor",{[1]={["Part"]=Part,["Color"]=Color3.new(Table.Color.R,Table.Color.B,Table.Color.B),["UnionColoring"] = true}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncMaterial",{[1]={["Part"]=Part,["Material"]=Enum.Material[Table.Material:reverse():split(".")[1]:reverse()],["Transparency"]=Table.Transparency}})
        task.wait(.1)
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncCollision",{[1]={["Part"]=Part,["CanCollide"]=Table.CanCollide}})
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer("SyncRotate",{[1]={["Part"]=Part,["CFrame"]=newCFrame*CFrame.Angles(Table.Angle.X,Table.Angle.Y,Table.Angle.Z)}})
        if Table.Children[1] and Table.Children[1].Type == "PointLight" or Table.Children[1] and Table.Children[1].Type == "SpotLight" or Table.Children[1] and Table.Children[1].Type == "SurfaceLight" then
            Light(Table.Children,Part)
        end
        if Table.Children[1] and Table.Children[1].Type == "Mesh" then
            Mesh(Table.Children[1],Part)
        end
        if Table.Children[1] and Tasle.Children[1].Type == "Decal" or Table.Children[1] and Tasle.Children[1].Type == "Texture" then
            Decal(Part,Table.Children[1])
        end
    end
end
local Rantimes = 0

function LoadBase(Table)
    if not game.Players.LocalPlayer.Backpack:FindFirstChild("Building Tools") then
        game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Text = "!bt"
        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.FocusLost,true)
        task.wait(1)
    end
    if not game.Players.LocalPlayer.Character:FindFirstChild("Building Tools") then
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Building Tools"))
    end
    Rantimes = 0
    Settings.RantimeReset = 0
    if Settings.BuildSpeed == ("Normal" or "Slow") then
        Settings.RantimeReset = 80
    else
        Settings.RantimeReset = 15
    end
    local oldtick = tick()
    local MyPlot = game:GetService("Workspace")["Private Building Areas"][game.Players.LocalPlayer.Name.."BuildArea"].Build
    Settings.IsBuilding = true
    if Settings.ForceBtools == true and Settings.IsBuilding == true then
        task.spawn(function()
            while Settings.IsBuilding == true and not game.Players.LocalPlayer.Character:FindFirstChild("Building Tools") do task.wait()
               game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("Building Tools"))
            end
        end)
    end
    for i,v in pairs(Table) do
        game:GetService("StarterGui"):SetCore("SendNotification",{Text = "Parts: "..tonumber(#Table);Duration = 2;})
        Rantimes = Rantimes + 1
        if Rantimes >= Settings.RantimeReset then
            Rantimes = 0
            Statsus:SetText("Waiting, To Not Get Kicked!")
            SaveInGame(Settings.FileName)
            task.wait(4.5)
        else
            task.wait(speeds[Settings.BuildSpeed])
            if not game.Players.LocalPlayer.Character:FindFirstChild("Building Tools") then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Character:FindFirstChild("Building Tools"))
            end
            CreatePart(v) 
        end
        Statsus:SetText(math.floor((tonumber(i)/tonumber(#Table))*100+0.5).."% | Type: "..v.Type.." | Parts Till Pause: "..(Settings.RantimeReset-Rantimes))
    end
    SaveInGame(Settings.FileName)
    Statsus:SetText("Done! | Took: "..(tick()-oldtick))
end
