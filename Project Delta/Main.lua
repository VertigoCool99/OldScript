local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local OldIndex = gmt.__index
gmt.__index = newcclosure(function(self, key)
    if key == "WalkSpeed" then
        return 16
    end
    return OldIndex(self, key)
end)

local repo = 'https://github.com/VertigoCool99/LinoriaLib'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Project Vertigo',
    Center = true, 
    AutoShow = true,
})

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local Mouse = localPlayer:GetMouse()

local currentCam = workspace.CurrentCamera
local worldToView = currentCam.WorldToViewportPoint

local Settings = {
	--Aimbot
	AimbotEnabled = false, AimbotSmoothing = 1, FovEnabled = true,FovSize = 60, AimbotDistance = 500,
	--Player Modification
	Walkspeed = 16, LocalChams = false, LocalChamsColor = Color3.fromRGB(0,255,255),
	--Enviroment Modification
	Fullbright = false,
	--PlayerStuff
	PlayerEspEnabled = false,PlayerRenderDistance = 5000, PlayerTracersEnabled = false,PlayerBoxesEnabled = false,PlayerNamesEnabled = false,PlayerDistancesEnabled = false,PlayerEspColor = Color3.new(0,1,1),PlayerEspTextOutline = true,PlayerEspTextSize = 13,
	--ItemStuff
	ItemEspEnabled = false,ItemRenderDistance = 5000,ItemNamesEnabled = false,ItemDistancesEnabled = false,ItemEspColor = Color3.fromRGB(255,165,0),ItemEspTextSize = 13,ItemEspTextOutline = true,
	--DropStuff
	DropEspEnabled = false,DropRenderDistance = 5000,DropNamesEnabled = false,DropDistancesEnabled = false,DropEspColor = Color3.fromRGB(153,50,204),DropEspTextSize = 13,DropEspTextOutline = true,
	--ExitStuff
	ExitEspEnabled = false,ExitNamesEnabled = false,ExitDistancesEnabled = false,ExitEspColor = Color3.fromRGB(0,255,0),ExitEspTextSize = 13,ExitEspTextOutline = true,
	--Inventory Viewer Stuff
	InvViewer = false, InventoryViewerColor = Color3.new(0,1,1),
}

local Drawings = {}
local ItemDrawings = {}
local ExitDrawings = {}
local DropDrawings = {}
local Characters = {}
local InventoryDrawing = {}

InvBox = Drawing.new("Square")
InvBox.Position = Vector2.new(currentCam.ViewportSize.X/currentCam.ViewportSize.X, currentCam.ViewportSize.Y/4) 
InvBox.Size = Vector2.new(130,30)
InvBox.Visible = false
InvBox.Thickness = 0
InvBox.Filled = true
InvBox.Color = Color3.fromRGB(25, 25, 25)
InvBoxDec = Drawing.new("Line")
InvBoxDec.Visible = InvBox.Visible
InvBoxDec.From = Vector2.new(InvBox.Position.X, InvBox.Position.Y)
InvBoxDec.To = Vector2.new((InvBox.Position.X+InvBox.Size.X), (InvBox.Position.Y))
InvBoxDec.Thickness = 1.5
InvBoxDec.Color = Settings.InventoryViewerColor

InventoryDrawing = {InvBack = InvBox,InvDec = InvBoxDec,Items = {}}

function GetClosestPlayer()
    local target = nil
    local dist = 80
    for i,v in next, game:GetService("Players"):GetPlayers() do
        if v.Character ~= nil and v.Name ~= localPlayer.Name and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local playerpos, onscreen = worldToView(currentCam,v.Character:GetPivot().Position)
            local VectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(playerpos.X, playerpos.Y)).Magnitude
            if VectorDistance <= dist and onscreen == true then
                target = v
            end
        end
    end
    return target
end

function InitEsp(player)
	if (player.Character) then
		Characters[player] = player.Character
	end
	player.CharacterAdded:connect(function(character)
		Characters[player] = character
	end)
	player.CharacterRemoving:Connect(function()
		for i,v in pairs(Drawings[player]) do
			v.Visible = false
		end
	end)
	if (player == localPlayer) then return end
	local Tracer = Drawing.new("Line")
	Tracer.Visible = false
	Tracer.Thickness = 1
	Tracer.Color = Settings.PlayerEspColor
	Tracer.Transparency = 1
	Tracer.From = Vector2.new(currentCam.ViewportSize.X / 2, currentCam.ViewportSize.Y)
	local Box = Drawing.new("Square")
	Box.Visible = false
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Color = Settings.PlayerEspColor
    Box.Filled = false
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Center = true
    Name.Outline = Settings.PlayerEspTextOutline 
    Name.Font = 2
    Name.Color = Settings.PlayerEspColor
    Name.Size = Settings.PlayerEspTextSize
    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Center = true
    Dist.Outline = Settings.PlayerEspTextOutline 
    Dist.Font = 2
    Dist.Color = Settings.PlayerEspColor
    Dist.Size = Settings.PlayerEspTextSize
    
	Drawings[player] = {Tracers = Tracer,Boxes = Box,Names = Name,Distances = Dist}
end

function InitItemEsp(obj)
	local root = localPlayer.Character:GetPivot().Position
	if not obj:IsA("Model") then return end
	local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Center = true
    Name.Outline = Settings.ItemEspTextOutline 
    Name.Font = 2
    Name.Color = Settings.ItemEspColor
    Name.Size = Settings.ItemEspTextSize
    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Center = true
    Dist.Outline = Settings.ItemEspTextOutline
    Dist.Font = 2
    Dist.Color = Settings.ItemEspColor
    Dist.Size = Settings.ItemEspTextSize
    
    ItemDrawings[obj] = {Names = Name,Distances = Dist}
end
	
function InitExitEsp(obj)
	local root = localPlayer.Character:GetPivot().Position
	if not obj:IsA("Part") then return end
	local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Center = true
    Name.Outline = Settings.ExitEspTextOutline 
    Name.Font = 2
    Name.Color = Settings.ExitEspColor
    Name.Size = Settings.ExitEspTextSize
    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Center = true
    Dist.Outline = Settings.ExitEspTextOutline
    Dist.Font = 2
    Dist.Color = Settings.ExitEspColor
    Dist.Size = Settings.ExitEspTextSize
    
    ExitDrawings[obj] = {Names = Name,Distances = Dist}
end

function InitDropEsp(obj)
	local root = localPlayer.Character:GetPivot().Position
	if not obj:IsA("Model") then return end
	obj.AncestryChanged:Connect(function()
		for i,v in pairs(DropDrawings[obj]) do
			v.Visible = false
		end
	end)
	local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Center = true
    Name.Outline = Settings.DropEspTextOutline 
    Name.Font = 2
    Name.Color = Settings.DropEspColor
    Name.Size = Settings.DropEspTextSize
    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Center = true
    Dist.Outline = Settings.DropEspTextOutline
    Dist.Font = 2
    Dist.Color = Settings.DropEspColor
    Dist.Size = Settings.DropEspTextSize
    
    DropDrawings[obj] = {Names = Name,Distances = Dist}
end
	
function Render()
	local localRoot = localPlayer.Character:GetPivot().Position
	for player, character in pairs(Characters) do
		if (player == localPlayer) then continue end
		esp = Drawings[player]
		root = character:GetPivot().Position
		if (root) and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
			local MouseVector = Vector2.new(Mouse.X, Mouse.Y)
			local hrp, onscreen = worldToView(currentCam, root)
			local hrpVec2 = Vector2.new(hrp.X, hrp.Y);
            local Vector2Magnitude = (MouseVector - hrpVec2).Magnitude
            local Vector3Magnitude = (root - localRoot).Magnitude
            local Size = (currentCam:WorldToViewportPoint(root - Vector3.new(0, 3, 0)).Y - currentCam:WorldToViewportPoint(root + Vector3.new(0, 2.6, 0)).Y) / 2
			local BoxSize = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
            local BoxPos = Vector2.new(math.floor(hrp.X - Size * 1.5 / 2), math.floor(hrp.Y - Size * 1.6 / 2))
            
			if Vector3Magnitude <= Settings.PlayerRenderDistance and Settings.PlayerEspEnabled == true and Settings.PlayerEspEnabled == true and hrp and onscreen == true and Settings.PlayerNamesEnabled == true then
				 esp.Names.Text = "[ "..player.Name.." ]"
				 esp.Names.Position = Vector2.new(BoxPos.X+(BoxSize.x/2),BoxPos.Y) - Vector2.new(0,esp.Names.TextBounds.Y)
				 esp.Names.Visible = true
				 --Update Settings
				 esp.Names.Color = Settings.PlayerEspColor
				 esp.Names.Outline = Settings.PlayerEspTextOutline
				 esp.Names.Size = Settings.PlayerEspTextSize
			else
				esp.Names.Visible = false
			end
			if Vector3Magnitude <= Settings.PlayerRenderDistance and Settings.PlayerEspEnabled == true and hrp and onscreen == true and Settings.PlayerTracersEnabled == true then
				if Settings.BoxEnabled == false then
					esp.Tracers.To = hrpVec2
				else
					esp.Tracers.To = Vector2.new(BoxPos.X+(BoxSize.X/2),BoxPos.Y+(BoxSize.Y))
				end
				esp.Tracers.Visible = true
				--Update Settings
				esp.Tracers.Color = Settings.PlayerEspColor
			else
				esp.Tracers.Visible = false
			end
			if Vector3Magnitude <= Settings.PlayerRenderDistance and Settings.PlayerEspEnabled == true and hrp and onscreen == true and Settings.PlayerBoxesEnabled == true then
				esp.Boxes.Visible = true
				esp.Boxes.Size = BoxSize
				esp.Boxes.Position = BoxPos
				--Update Settings
				esp.Boxes.Color = Settings.PlayerEspColor
			else
				esp.Boxes.Visible = false
			end
			if Vector3Magnitude <= Settings.PlayerRenderDistance and Settings.PlayerEspEnabled == true and hrp and onscreen == true and Settings.PlayerDistancesEnabled == true then
				esp.Distances.Text = "[ "..math.floor((Vector3Magnitude / 3.5714285714)).."m ]"
				esp.Distances.Position = Vector2.new(BoxPos.X+(BoxSize.X/2),BoxPos.Y+(BoxSize.Y))
				esp.Distances.Visible = true
				--Update Settings
				esp.Distances.Color = Settings.PlayerEspColor
				esp.Distances.Outline = Settings.PlayerEspTextOutline
				esp.Distances.Size = Settings.PlayerEspTextSize
			else
				esp.Distances.Visible = false
			end
		end
	end
end

function ItemRender()
	local localRoot = localPlayer.Character:GetPivot().Position
	for i, crate in pairs(game:GetService("Workspace").Containers:GetChildren()) do
		esp = ItemDrawings[crate]
		if (crate) and (crate:IsA("Model")) then
			local cratepos, onscreencra = worldToView(currentCam, crate:GetPivot().Position)
			local crateVec2 = Vector2.new(cratepos.X, cratepos.Y)
			local Vector3Magnitude = (crate:GetPivot().Position - localRoot).Magnitude
			if onscreencra == true then
				if Vector3Magnitude <= Settings.ItemRenderDistance and Settings.ItemEspEnabled == true and crate:FindFirstChild("Inventory") and Settings.ItemNamesEnabled == true then
					if crate.Inventory:FindFirstChildOfClass("StringValue") then
						for i,v in pairs(crate.Inventory:GetChildren()) do
							esp.Names.Text = "[ "..crate.Name.." | "..i.." Items ]"
						end
					else
						esp.Names.Text = "[ "..crate.Name.." | 0 Items ]"
					end
					esp.Names.Position = crateVec2
					esp.Names.Visible = true
					--Update Settings
					esp.Names.Color = Settings.ItemEspColor
					esp.Names.Size = Settings.ItemEspTextSize
					esp.Names.Outline = Settings.ItemEspTextOutline
				else
					esp.Names.Visible = false
				end
				if Vector3Magnitude <= Settings.ItemRenderDistance and Settings.ItemEspEnabled == true and crate:FindFirstChild("Inventory") and Settings.ItemDistancesEnabled == true then
					esp.Distances.Text = "[ "..tostring(math.floor((Vector3Magnitude / 3.5714285714))).."m ]"
					esp.Distances.Position = crateVec2 + Vector2.new(0,esp.Distances.TextBounds.Y)
					esp.Distances.Visible = true
					--Update Settings
					esp.Distances.Color = Settings.ItemEspColor
					esp.Distances.Size = Settings.ItemEspTextSize
					esp.Distances.Outline = Settings.ItemEspTextOutline
				else
					esp.Distances.Visible = false
				end
			else
				esp.Distances.Visible = false
				esp.Names.Visible = false
			end
		end
	end
end

function ExitRender()
	local localRoot = localPlayer.Character:GetPivot().Position
	for i, exits in pairs(game:GetService("Workspace").NoCollision.ExitLocations:GetChildren()) do
		esp = ExitDrawings[exits]
		if (exits) and (exits:IsA("Part")) then
			local exitpos, onscreenexit = worldToView(currentCam, exits:GetPivot().Position)
			local crateVec2 = Vector2.new(exitpos.X, exitpos.Y)
			local Vector3Magnitude = (exits:GetPivot().Position - localRoot).Magnitude
			if onscreenexit == true then
				if esp ~= nil and Vector3Magnitude and Settings.ExitEspEnabled == true and Settings.ExitNamesEnabled == true then
					esp.Names.Text = "[ EXIT ]"
					esp.Names.Position = crateVec2
					esp.Names.Visible = true
					--Update Settings
					esp.Names.Color = Settings.ExitEspColor
					esp.Names.Size = Settings.ExitEspTextSize
					esp.Names.Outline = Settings.ExitEspTextOutline
				else
					if esp ~= nil then
						esp.Names.Visible = false
					end
				end
				if esp ~= nil and Vector3Magnitude and Settings.ExitEspEnabled == true and Settings.ExitDistancesEnabled == true then
					esp.Distances.Text = "[ "..tostring(math.floor((Vector3Magnitude / 3.5714285714))).."m ]"
					esp.Distances.Position = crateVec2 + Vector2.new(0,esp.Distances.TextBounds.Y)
					esp.Distances.Visible = true
					--Update Settings
					esp.Distances.Color = Settings.ExitEspColor
					esp.Distances.Size = Settings.ExitEspTextSize
					esp.Distances.Outline = Settings.ExitEspTextOutline
				else
					if esp ~= nil then
						esp.Distances.Visible = false
					end
				end
			else
			if esp ~= nil then
					esp.Distances.Visible = false
					esp.Names.Visible = false
				end
			end
		end
	end
end

function DropRender()
	local localRoot = localPlayer.Character:GetPivot().Position
	for i, drop in pairs(game:GetService("Workspace").DroppedItems:GetChildren()) do
		esp = DropDrawings[drop]
		if (drop) and (drop:IsA("Model")) then
			local droppos, onscreendrop = worldToView(currentCam, drop:GetPivot().Position)
			local dropVec2 = Vector2.new(droppos.X, droppos.Y)
			local Vector3Magnitude = (drop:GetPivot().Position - localRoot).Magnitude
			if onscreendrop == true then
				if esp ~= nil and Vector3Magnitude <= Settings.DropRenderDistance and Settings.DropEspEnabled == true and Settings.DropNamesEnabled == true then
					esp.Names.Text = "[ "..drop.Name.." ]"
					esp.Names.Position = dropVec2
					esp.Names.Visible = true
					--Update Settings
					esp.Names.Color = Settings.DropEspColor
					esp.Names.Size = Settings.DropEspTextSize
					esp.Names.Outline = Settings.DropEspTextOutline
				else
					if esp ~= nil then
						esp.Names.Visible = false
					end
				end
				if esp ~= nil and Vector3Magnitude <= Settings.DropRenderDistance and Settings.DropEspEnabled == true and Settings.DropDistancesEnabled == true then
					esp.Distances.Text = "[ "..tostring(math.floor((Vector3Magnitude / 3.5714285714))).."m ]"
					esp.Distances.Position = dropVec2 + Vector2.new(0,esp.Distances.TextBounds.Y)
					esp.Distances.Visible = true
					--Update Settings
					esp.Distances.Color = Settings.DropEspColor
					esp.Distances.Size = Settings.DropEspTextSize
					esp.Distances.Outline = Settings.DropEspTextOutline
				else
					if esp ~= nil then
						esp.Distances.Visible = false
					end
				end
			else
				if esp ~= nil then
					esp.Distances.Visible = false
					esp.Names.Visible = false
				end
			end
		elseif drop == nil then
			esp.Distances.Visible = false
			esp.Names.Visible = false
		end
	end
end

InventoryDrawing = {InvBack = InvBox,InvDec = InvBoxDec,Items = {}}
function InvClear()
	for i,v in pairs(InventoryDrawing.Items) do
		v:Remove()
		InventoryDrawing.Items[i] = nil
	end
	InventoryDrawing.InvBack.Visible = false
	InventoryDrawing.InvDec.Visible = false
end
function InvAddText(RealText,Indent)
	InventoryDrawing.InvDec.Visible = true
	InventoryDrawing.InvBack.Visible = true
	local Text = Drawing.new("Text")
	Text.Text = RealText
	Text.Visible = true
	Text.Size = 15
	Text.Font = 2
	Text.Outline = true
	Text.Color = Color3.new(1,1,1)
	table.insert(InventoryDrawing.Items,Text)
	if #InventoryDrawing.Items == 1 then
		Text.Center = true
		Text.Position = Vector2.new((InventoryDrawing.InvBack.Position.X*InventoryDrawing.InvBack.Size.X/2),(InventoryDrawing.InvBack.Position.Y+InventoryDrawing.InvDec.Thickness*3))
		InventoryDrawing.InvBack.Size = Vector2.new(InventoryDrawing.InvBack.Size.X,Text.Size+4)
	elseif Indent == true then
		InventoryDrawing.InvBack.Size = Vector2.new(InventoryDrawing.InvBack.Size.X,(Text.Size*#InventoryDrawing.Items)+InventoryDrawing.InvDec.Thickness*3+3)
		Text.Position = Vector2.new((InventoryDrawing.InvBack.Position.X/InventoryDrawing.InvBack.Size.X+InventoryDrawing.InvDec.Thickness*7),(InventoryDrawing.InvBack.Position.Y+InventoryDrawing.InvDec.Thickness*3)) + Vector2.new(0, (#InventoryDrawing.Items - 1) * Text.Size)
	else
		InventoryDrawing.InvBack.Size = Vector2.new(InventoryDrawing.InvBack.Size.X,(Text.Size*#InventoryDrawing.Items)+InventoryDrawing.InvDec.Thickness*3+3)
		Text.Position = Vector2.new((InventoryDrawing.InvBack.Position.X/InventoryDrawing.InvBack.Size.X+InventoryDrawing.InvDec.Thickness*4),(InventoryDrawing.InvBack.Position.Y+InventoryDrawing.InvDec.Thickness*3)) + Vector2.new(0, (#InventoryDrawing.Items - 1) * Text.Size)
	end
end
function InvUpdate()
	InvClear()
	player = GetClosestPlayer()
	if player ~= nil then
		InventoryDrawing.InvDec.Color = Settings.InventoryViewerColor
		InvAddText(player.Name,false)
		InvAddText("[ HotBar ]",true)
		for i,v in pairs(game:GetService("ReplicatedStorage").Players[player.Name].Inventory:GetChildren()) do
			InvAddText(v.Name,false)
		end
		for i, v in pairs(game:GetService("ReplicatedStorage").Players[player.Name].Clothing:GetChildren()) do
			InvAddText("[ "..v.Name.." ]",true)
			if v:FindFirstChild("Inventory") then
				for i2,v2 in pairs(v.Inventory:GetChildren()) do
					InvAddText(v2.Name,false)
				end
			end
		end
	else
		InvAddText("No Player Fount",false)
	end
end

local updated = false
local rs = game:GetService("RunService")
rs.Heartbeat:Connect(function()
	if updated == false then
		updated = true
		InvUpdate()
		task.wait(.1)
		updated = false
	end
end)
rs.RenderStepped:Connect(function()
	if Library.Unloaded ~= true then
		if localPlayer and localPlayer.Character ~= nil and localPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Settings.Walkspeed
		end
		if game.Workspace.Camera:FindFirstChild("ViewModel") and Settings.LocalChams == true then
			for i,v in pairs(game.Workspace.Camera.ViewModel:GetChildren()) do
				if string.find(v.Name,"Shirt") or string.find(v.Name,"Glove") or string.find(v.Name,"Wrap") then
					v:Destroy()
				end
				if v:IsA("MeshPart") then
					v.Color = Settings.LocalChamsColor
					v.Material = Enum.Material.ForceField
				end
			end
		end
		if Settings.Fullbright == true then
			game.Lighting.Brightness = 3
			game.Lighting.GlobalShadows = false
			game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
		else
			game.Lighting.Brightness = 3
			game.Lighting.GlobalShadows = true
			game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
		end
		Render()
		ItemRender()
		DropRender()
		ExitRender()
	end
end)

players.PlayerRemoving:Connect(function(plr)
	if Library.Unloaded == false then
		Characters[plr] = nil
		for i,v in pairs(Drawings[plr]) do
			v.Visible = false
		end
		Drawings[plr] = nil
	end
end)

for i,v in pairs (players:GetPlayers()) do
	InitEsp(v)
end

players.PlayerAdded:Connect(function(v)
	if Library.Unloaded == false then
		InitEsp(v)
	end
end)

for i,v in pairs(game:GetService("Workspace").Containers:GetDescendants()) do
	if v:IsA("Model") then
		InitItemEsp(v)
	end
end
for i,v in pairs(game:GetService("Workspace").NoCollision.ExitLocations:GetChildren()) do
	InitExitEsp(v)
end
for i,v in pairs(game:GetService("Workspace").DroppedItems:GetChildren()) do
	InitDropEsp(v)
end

game:GetService("Workspace").Containers.ChildAdded:Connect(function(v)
	if Library.Unloaded == false then
		InitItemEsp(v)
	end
end)
game:GetService("Workspace").NoCollision.ExitLocations.ChildAdded:Connect(function(v)
	if Library.Unloaded == false then
		InitExitEsp(v)
	end
end)
game:GetService("Workspace").DroppedItems.ChildAdded:Connect(function(v)
	InitDropEsp(v)
end)

local Tabs = {Main = Window:AddTab('Main'), Visuals = Window:AddTab('Visuals'),Misc = Window:AddTab('Misc'), ['UI Settings'] = Window:AddTab('UI Settings'),}

local AimbotGroup = Tabs.Main:AddLeftGroupbox('Aimbot')

AimbotGroup:AddToggle('AimbotEnabled', {Text = 'Enabled',Default = false,})
AimbotGroup:AddToggle('FovEnabled', {Text = 'Fov Enabled',Default = true,})
AimbotGroup:AddSlider('FovSize', {Text = 'FovSize',Default = 60,Min = 1,Max = 500,Rounding = 0,Compact = false,})

local PlayerEspGroup = Tabs.Visuals:AddLeftGroupbox('Player Esp')
local ItemEspGroup = Tabs.Visuals:AddRightGroupbox('Item Esp')
local DropEspGroup = Tabs.Visuals:AddLeftGroupbox('Drop Esp')
local ExitEspGroup = Tabs.Visuals:AddRightGroupbox('Exit Esp')
local InvViewGroup = Tabs.Visuals:AddRightGroupbox('Inventory Viewer')

PlayerEspGroup:AddToggle('PlayerEspEnabled', {Text = 'Esp Enabled',Default = false,})
PlayerEspGroup:AddSlider('PlayerRenderDistance', {Text = 'Render Distance',Default = 800,Min = 1,Max = 5000,Rounding = 0,Compact = false,})
PlayerEspGroup:AddToggle('PlayerTracersEnabled', {Text = 'Tracers',Default = false,})
PlayerEspGroup:AddToggle('PlayerBoxesEnabled', {Text = 'Boxes',Default = false,})
PlayerEspGroup:AddToggle('PlayerNamesEnabled', {Text = 'Names',Default = false,})
PlayerEspGroup:AddToggle('PlayerDistancesEnabled', {Text = 'Distances',Default = false,})
PlayerEspGroup:AddDivider()
PlayerEspGroup:AddLabel('Player Esp Color'):AddColorPicker('PlayerEspColor', {Default = Settings.PlayerEspColor,Title = 'Player Esp Color',})
PlayerEspGroup:AddToggle('PlayerEspTextOutline', {Text = 'Text Outline',Default = false,})
PlayerEspGroup:AddSlider('PlayerEspTextSize', {Text = 'Text Size',Default = 13,Min = 1,Max = 50,Rounding = 0,Compact = false,})
ItemEspGroup:AddToggle('ItemEspEnabled', {Text = 'Esp Enabled',Default = false,})
ItemEspGroup:AddSlider('ItemRenderDistance', {Text = 'Item Render Distance',Default = 400,Min = 1,Max = 5000,Rounding = 0,Compact = false,})
ItemEspGroup:AddToggle('ItemNamesEnabled', {Text = 'Names',Default = false,})
ItemEspGroup:AddToggle('ItemDistancesEnabled', {Text = 'Distances',Default = false,})
ItemEspGroup:AddDivider()
ItemEspGroup:AddLabel('Item Esp Color'):AddColorPicker('ItemEspColor', {Default = Settings.ItemEspColor,Title = 'Item Esp Color',})
ItemEspGroup:AddToggle('ItemEspTextOutline', {Text = 'Text Outline',Default = false,})
ItemEspGroup:AddSlider('ItemEspTextSize', {Text = 'Text Size',Default = 13,Min = 1,Max = 50,Rounding = 0,Compact = false,})
DropEspGroup:AddToggle('DropEspEnabled', {Text = 'Esp Enabled',Default = false,})
DropEspGroup:AddSlider('DropRenderDistance', {Text = 'Drop Render Distance',Default = 400,Min = 1,Max = 5000,Rounding = 0,Compact = false,})
DropEspGroup:AddToggle('DropNamesEnabled', {Text = 'Names',Default = false,})
DropEspGroup:AddToggle('DropDistancesEnabled', {Text = 'Distances',Default = false,})
DropEspGroup:AddDivider()
DropEspGroup:AddLabel('Drop Esp Color'):AddColorPicker('DropEspColor', {Default = Settings.DropEspColor,Title = 'Drop Esp Color',})
DropEspGroup:AddToggle('DropEspTextOutline', {Text = 'Text Outline',Default = false,})
DropEspGroup:AddSlider('DropEspTextSize', {Text = 'Text Size',Default = 13,Min = 1,Max = 50,Rounding = 0,Compact = false,})
ExitEspGroup:AddToggle('ExitEspEnabled', {Text = 'Esp Enabled',Default = false,})
ExitEspGroup:AddToggle('ExitNamesEnabled', {Text = 'Names',Default = false,})
ExitEspGroup:AddToggle('ExitDistancesEnabled', {Text = 'Distances',Default = false,})
ExitEspGroup:AddDivider()
ExitEspGroup:AddLabel('Exit Esp Color'):AddColorPicker('ExitEspColor', {Default = Settings.ExitEspColor,Title = 'Exit Esp Color',})
ExitEspGroup:AddToggle('ExitEspTextOutline', {Text = 'Text Outline',Default = false,})
ExitEspGroup:AddSlider('ExitEspTextSize', {Text = 'Text Size',Default = 13,Min = 1,Max = 50,Rounding = 0,Compact = false,})
InvViewGroup:AddToggle('InvViewer', {Text = 'Enabled',Default = false,})
InvViewGroup:AddLabel('Inventory Viewer Color'):AddColorPicker('InventoryViewerColor', {Default = Settings.InventoryViewerColor,Title = 'Inventory Viewer Color',})

local PlayerMods = Tabs.Misc:AddLeftGroupbox('Player Modification')
PlayerMods:AddSlider('Walkspeed', {Text = 'Walkspeed',Default = 16,Min = 16,Max = 30,Rounding = 0,Compact = false,})
PlayerMods:AddToggle('LocalChams', {Text = 'Local Chams',Default = false,})
PlayerMods:AddLabel('Local Chams Color'):AddColorPicker('LocalChamsColor', {Default = Settings.LocalChamsColor,Title = 'Local Chams Color',})
PlayerMods:AddDivider()
PlayerMods:AddToggle('NoCameraBob', {Text = 'No Camera Bob',Default = false,})
local EnviroMods = Tabs.Misc:AddRightGroupbox('Enviroment Modification')
EnviroMods:AddToggle('Grass', {Text = 'Grass Enabled',Default = true,})
EnviroMods:AddToggle('Clouds', {Text = 'Clouds Enabled',Default = true,})
EnviroMods:AddToggle('Foilage', {Text = 'Foilage Enabled',Default = true,})
EnviroMods:AddToggle('Fullbright', {Text = 'FullBright',Default = false,})

--ON CHANGES
--TOGGLES
Toggles["AimbotEnabled"]:OnChanged(function()
	Settings.AimbotEnabled = Toggles["AimbotEnabled"].Value
end)
Toggles["PlayerEspEnabled"]:OnChanged(function()
    Settings.PlayerEspEnabled = Toggles["PlayerEspEnabled"].Value
end)
Toggles["PlayerTracersEnabled"]:OnChanged(function()
    Settings.PlayerTracersEnabled = Toggles["PlayerTracersEnabled"].Value
end)
Toggles["PlayerBoxesEnabled"]:OnChanged(function()
    Settings.PlayerBoxesEnabled = Toggles["PlayerBoxesEnabled"].Value
end)
Toggles["PlayerNamesEnabled"]:OnChanged(function()
    Settings.PlayerNamesEnabled = Toggles["PlayerNamesEnabled"].Value
end)
Toggles["PlayerDistancesEnabled"]:OnChanged(function()
    Settings.PlayerDistancesEnabled = Toggles["PlayerDistancesEnabled"].Value
end)
Toggles["PlayerEspTextOutline"]:OnChanged(function()
    Settings.PlayerEspTextOutline = Toggles["PlayerEspTextOutline"].Value
end)
Toggles["ItemEspEnabled"]:OnChanged(function()
    Settings.ItemEspEnabled = Toggles["ItemEspEnabled"].Value
end)
Toggles["ItemNamesEnabled"]:OnChanged(function()
    Settings.ItemNamesEnabled = Toggles["ItemNamesEnabled"].Value
end)
Toggles["ItemDistancesEnabled"]:OnChanged(function()
    Settings.ItemDistancesEnabled = Toggles["ItemDistancesEnabled"].Value
end)
Toggles["ItemEspTextOutline"]:OnChanged(function()
    Settings.ItemEspTextOutline = Toggles["ItemEspTextOutline"].Value
end)
Toggles["DropEspEnabled"]:OnChanged(function()
    Settings.DropEspEnabled = Toggles["DropEspEnabled"].Value
end)
Toggles["DropNamesEnabled"]:OnChanged(function()
    Settings.DropNamesEnabled = Toggles["DropNamesEnabled"].Value
end)
Toggles["DropDistancesEnabled"]:OnChanged(function()
    Settings.DropDistancesEnabled = Toggles["DropDistancesEnabled"].Value
end)
Toggles["DropEspTextOutline"]:OnChanged(function()
    Settings.DropEspTextOutline = Toggles["DropEspTextOutline"].Value
end)
Toggles["ExitEspEnabled"]:OnChanged(function()
    Settings.ExitEspEnabled = Toggles["ExitEspEnabled"].Value
end)
Toggles["ExitNamesEnabled"]:OnChanged(function()
    Settings.ExitNamesEnabled = Toggles["ExitNamesEnabled"].Value
end)
Toggles["ExitDistancesEnabled"]:OnChanged(function()
    Settings.ExitDistancesEnabled = Toggles["ExitDistancesEnabled"].Value
end)
Toggles["ExitEspTextOutline"]:OnChanged(function()
    Settings.ExitEspTextOutline = Toggles["ExitEspTextOutline"].Value
end)
Toggles["InvViewer"]:OnChanged(function()
    Settings.InvViewer = Toggles["InvViewer"].Value
end)
Toggles["LocalChams"]:OnChanged(function()
	Settings.LocalChams = Toggles["LocalChams"].Value
end)
Toggles["Grass"]:OnChanged(function()
	sethiddenproperty(game:GetService("Workspace").Terrain,"Decoration",Toggles["Grass"].Value)
end)
Toggles["Clouds"]:OnChanged(function()
	game:GetService("Workspace").Terrain.Clouds.Enabled = Toggles["Clouds"].Value
end)
Toggles["Foilage"]:OnChanged(function()
	for i,v in pairs(game:GetService("Workspace").SpawnerZones.Foliage:GetDescendants()) do
		if v:IsA("SurfaceAppearance") and v.Parent.Transparency == 0 then
			v.Parent.Transparency = 1
		elseif v:IsA("SurfaceAppearance") and v.Parent.Transparency == 1 then
			v.Parent.Transparency = 0
		end
	end
end)
Toggles["Fullbright"]:OnChanged(function()
	Settings.Fullbright = Toggles["Fullbright"].Value
end)


local springModule = require(game:GetService("ReplicatedStorage").Modules.spring)
local oldSpringIndex
oldSpringIndex = hookfunction(springModule.update, function(...)
    if Toggles["NoCameraBob"].Value == true then
        return;
    end

    return oldSpringIndex(...)
end)

--OPTIONS
Options["PlayerRenderDistance"]:OnChanged(function()
    Settings.PlayerRenderDistance = Options["PlayerRenderDistance"].Value
end)
Options["PlayerEspColor"]:OnChanged(function()
    Settings.PlayerEspColor = Options.PlayerEspColor.Value
end)
Options["PlayerEspTextSize"]:OnChanged(function()
    Settings.PlayerEspTextSize = Options.PlayerEspTextSize.Value
end)
Options["ItemRenderDistance"]:OnChanged(function()
    Settings.ItemRenderDistance = Options["ItemRenderDistance"].Value
end)
Options["ItemEspColor"]:OnChanged(function()
    Settings.ItemEspColor = Options.ItemEspColor.Value
end)
Options["ItemEspTextSize"]:OnChanged(function()
    Settings.ItemEspTextSize = Options.ItemEspTextSize.Value
end)
Options["DropRenderDistance"]:OnChanged(function()
    Settings.DropRenderDistance = Options["DropRenderDistance"].Value
end)
Options["DropEspColor"]:OnChanged(function()
    Settings.DropEspColor = Options.DropEspColor.Value
end)
Options["DropEspTextSize"]:OnChanged(function()
    Settings.DropEspTextSize = Options.DropEspTextSize.Value
end)
Options["ExitEspColor"]:OnChanged(function()
    Settings.ExitEspColor = Options.ExitEspColor.Value
end)
Options["ExitEspTextSize"]:OnChanged(function()
    Settings.ExitEspTextSize = Options.ExitEspTextSize.Value
end)
Options["InventoryViewerColor"]:OnChanged(function()
    Settings.InventoryViewerColor = Options.InventoryViewerColor.Value
end)
Options["Walkspeed"]:OnChanged(function()
    Settings.Walkspeed = Options.Walkspeed.Value
end)
Options["LocalChamsColor"]:OnChanged(function()
    Settings.LocalChamsColor = Options.LocalChamsColor.Value
end)

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Project Vertigo | VertigoCool#6520')
Library.KeybindFrame.Visible = false

Library:OnUnload(function()
    Library.Unloaded = true
    render = nil
    table.clear(Drawings)
    table.clear(Characters)
    spawn(function()
    	task.wait(1)
    	Drawing.clear()
	end)
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Insert', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('ProjectVertigo')
SaveManager:SetFolder('ProjectVertigo/ProjectDelta')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
